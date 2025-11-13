package Controller.cskh;

import com.google.gson.Gson;
// SỬA: Import đúng Connection
import java.sql.Connection;
import java.sql.SQLException;
import dal.ContractDAO;
import dal.DeviceDAO;
import dal.ProductDAO;
import dal.ProductSerialDAO;
import dal.UserDBContext;
import data.Contract;
import data.ContractItem;
import data.Device;
import data.Product;
import data.ProductSerial;
import data.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
// XÓA: dal.DBContext (không cần thiết vì đã có trong DAO)

@WebServlet("/cskh/createContract")
public class ContractCreateController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // SỬA: Dùng try-with-resources để đảm bảo DAO được đóng
        try (UserDBContext userDAO = new UserDBContext();
             ProductDAO productDAO = new ProductDAO();
             ProductSerialDAO psDAO = new ProductSerialDAO()) {

            ArrayList<User> customers = userDAO.getAllActiveCustomers();
            List<Product> products = productDAO.getAllActiveProducts();
            Map<Integer, List<ProductSerial>> serialsMap = psDAO.getAvailableSerialsGroupedByProduct();
            String availableSerialsJson = new Gson().toJson(serialsMap);

            request.setAttribute("customers", customers);
            request.setAttribute("products", products);
            request.setAttribute("availableSerialsJson", availableSerialsJson);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading data: " + e.getMessage());
        }

        request.getRequestDispatcher("/cskh/contract_create.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // SỬA: Khai báo DAO MỘT LẦN ở đây
        ContractDAO contractDAO = new ContractDAO();
        DeviceDAO deviceDAO = new DeviceDAO();
        ProductSerialDAO psDAO = new ProductSerialDAO();

        // SỬA: Lấy Connection (kiểu java.sql.Connection)
        Connection conn = contractDAO.getConnection();
        
        // SỬA: Chia sẻ connection cho các DAO khác
        deviceDAO.setConnection(conn);
        psDAO.setConnection(conn);
        
        try {
            request.setCharacterEncoding("UTF-8");

            // MỚI: Bắt đầu Transaction
            conn.setAutoCommit(false);

            int customerId = Integer.parseInt(request.getParameter("customerId"));
            String contractDateStr = request.getParameter("contractDate");
            String description = request.getParameter("description");
            
            // XÓA: Không khai báo lại DAO ở đây
            // ContractDAO contractDAO = new ContractDAO();
            // DeviceDAO deviceDAO = new DeviceDAO();

            String[] serialNumbers = request.getParameterValues("serialNumber");

            // XÓA: Toàn bộ khối validation serial cũ.
            // Chúng ta sẽ validate bên trong transaction bằng psDAO.reserveSerial()
            
            Date contractDate = Date.valueOf(contractDateStr);

            Contract contract = new Contract();
            contract.setCustomerId(customerId);
            contract.setContractDate(contractDate);
            contract.setDescription(description);

            String[] productIds = request.getParameterValues("productId");
            String[] quantities = request.getParameterValues("quantity");
            String[] prices = request.getParameterValues("unitPrice");
            String[] warrantyMonths = request.getParameterValues("warrantyMonths");
            String[] maintenanceMonths = request.getParameterValues("maintenanceMonths");
            String[] maintenanceFreq = request.getParameterValues("maintenanceFrequencyMonths");

            List<ContractItem> items = new ArrayList<>();
            double calculatedTotalAmount = 0.0;
            int totalQuantity = 0; // MỚI: Đếm tổng số lượng

            if (productIds == null || productIds.length == 0) {
                // SỬA: Ném exception để rollback
                throw new Exception("Please add at least one contract item!");
            }

            for (int i = 0; i < productIds.length; i++) {
                if (productIds[i] == null || productIds[i].isEmpty()) {
                    continue;
                }

                int qty = Integer.parseInt(quantities[i]);
                double price = Double.parseDouble(prices[i]);
                if (qty <= 0) {
                    continue;
                }

                ContractItem item = new ContractItem();
                item.setProductId(Integer.parseInt(productIds[i]));
                item.setQuantity(qty);
                item.setUnitPrice(price);
                item.setWarrantyMonths(Integer.parseInt(warrantyMonths[i]));
                item.setMaintenanceMonths(Integer.parseInt(maintenanceMonths[i]));
                item.setMaintenanceFrequencyMonths(Integer.parseInt(maintenanceFreq[i]));

                items.add(item);
                calculatedTotalAmount += qty * price;
                totalQuantity += qty; // MỚI
            }

            if (items.isEmpty()) {
                throw new Exception("Contract must contain at least one valid product!");
            }
            
            // MỚI: Kiểm tra số lượng serial và số lượng sản phẩm
            if (serialNumbers == null || serialNumbers.length != totalQuantity) {
                 throw new Exception("The number of serials selected (" + (serialNumbers == null ? 0 : serialNumbers.length) +
                         ") does not match the total product quantity (" + totalQuantity + ").");
            }
            
            // MỚI: Kiểm tra serial trùng lặp (vẫn cần thiết)
            java.util.Set<String> serialSet = new java.util.HashSet<>();
            for (String serial : serialNumbers) {
                if (serial == null || serial.trim().isEmpty()) {
                    throw new Exception("A selected serial number is empty.");
                }
                if (!serialSet.add(serial.trim())) {
                    throw new Exception("Duplicate serial number selected: " + serial.trim());
                }
            }

            contract.setTotalAmount(calculatedTotalAmount);

            // Bước 1: Insert Contract và ContractItems (dùng contractDAO)
            int newContractId = contractDAO.insertContractWithItems(contract, items);

            if (newContractId > 0) {
                int serialIndex = 0;
                for (ContractItem item : items) {
                    // Phải lấy contract_item_id sau khi đã insert
                    int contractItemId = contractDAO.getLastActiveContractItemId(newContractId, item.getProductId());
                    if (contractItemId == -1) {
                         throw new SQLException("Could not find newly created contract item ID.");
                    }

                    for (int j = 0; j < item.getQuantity(); j++) {
                        String serial = serialNumbers[serialIndex].trim();
                        int productId = item.getProductId();

                        // Bước 2: MỚI - Reserve Serial (dùng psDAO)
                        // Thao tác này sẽ ném ra SQLException nếu thất bại
                        psDAO.reserveSerial(serial, productId);

                        // Bước 3: Insert Device (dùng deviceDAO)
                        Device device = new Device();
                        device.setContractItemId(contractItemId);
                        device.setSerialNumber(serial);
                        device.setWarrantyExpiration(Date.valueOf(
                                LocalDate.now().plusMonths(item.getWarrantyMonths())));
                        device.setStatus("InWarranty");

                        deviceDAO.insert(device); // Hàm này phải KHÔNG commit
                        serialIndex++;
                    }
                }

                // MỚI: Commit transaction nếu mọi thứ thành công
                conn.commit();
                response.sendRedirect(request.getContextPath() + "/cskh/contract?message=created");
            
            } else {
                throw new Exception("Failed to create contract! Please try again.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            try {
                // MỚI: Rollback transaction nếu có lỗi
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            reloadFormData(request); // Tải lại data cho form
            request.getRequestDispatcher("/cskh/contract_create.jsp").forward(request, response);
        
        } finally {
            // MỚI: Luôn dọn dẹp
            try {
                conn.setAutoCommit(true); // Reset autoCommit
            } catch (SQLException e) {
                e.printStackTrace();
            }
            // Đóng tất cả DAO (việc này sẽ đóng connection)
            contractDAO.close();
            deviceDAO.close();
            psDAO.close();
        }
    }

   private void reloadFormData(HttpServletRequest request) {
        // SỬA: Dùng try-with-resources và tải lại TẤT CẢ data
        try (UserDBContext userDAO = new UserDBContext();
             ProductDAO productDAO = new ProductDAO();
             ProductSerialDAO psDAO = new ProductSerialDAO()) { // <-- THÊM DÒNG NÀY
            
            request.setAttribute("customers", userDAO.getAllActiveCustomers());
            request.setAttribute("products", productDAO.getAllActiveProducts());
            
            // THÊM 3 DÒNG NÀY:
            Map<Integer, List<ProductSerial>> serialsMap = psDAO.getAvailableSerialsGroupedByProduct();
            String availableSerialsJson = new Gson().toJson(serialsMap);
            request.setAttribute("availableSerialsJson", availableSerialsJson);

        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}