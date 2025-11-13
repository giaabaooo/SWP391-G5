package Controller.cskh;

import com.google.gson.Gson;
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
import java.util.Set;
import java.util.stream.Collectors;

@WebServlet("/cskh/createContract")
public class ContractCreateController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try (UserDBContext userDAO = new UserDBContext(); ProductDAO productDAO = new ProductDAO(); ProductSerialDAO psDAO = new ProductSerialDAO()) {

            ArrayList<User> customers = userDAO.getAllActiveCustomers();

            Map<Integer, List<ProductSerial>> serialsMap = psDAO.getAvailableSerialsGroupedByProduct();
            String availableSerialsJson = new Gson().toJson(serialsMap);
            Set<Integer> productIdsWithStock = serialsMap.keySet();
            List<Product> allProducts = productDAO.getAllActiveProducts();
            List<Product> availableProducts = allProducts.stream()
                    .filter(p -> productIdsWithStock.contains(p.getId()))
                    .collect(Collectors.toList());

            request.setAttribute("customers", customers);
            request.setAttribute("products", availableProducts);
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

        ContractDAO contractDAO = new ContractDAO();
        DeviceDAO deviceDAO = new DeviceDAO();
        ProductSerialDAO psDAO = new ProductSerialDAO();

        Connection conn = contractDAO.getConnection();

        deviceDAO.setConnection(conn);
        psDAO.setConnection(conn);

        try {
            request.setCharacterEncoding("UTF-8");

            conn.setAutoCommit(false);

            int customerId = Integer.parseInt(request.getParameter("customerId"));
            String contractDateStr = request.getParameter("contractDate");
            String description = request.getParameter("description");

            String[] serialNumbers = request.getParameterValues("serialNumber");

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
            int totalQuantity = 0;

            if (productIds == null || productIds.length == 0) {
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
                totalQuantity += qty;
            }

            if (items.isEmpty()) {
                throw new Exception("Contract must contain at least one valid product!");
            }

            if (serialNumbers == null || serialNumbers.length != totalQuantity) {
                throw new Exception("The number of serials selected (" + (serialNumbers == null ? 0 : serialNumbers.length)
                        + ") does not match the total product quantity (" + totalQuantity + ").");
            }

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

            int newContractId = contractDAO.insertContractWithItems(contract, items);

            if (newContractId > 0) {
                int serialIndex = 0;
                for (ContractItem item : items) {
                    int contractItemId = contractDAO.getLastActiveContractItemId(newContractId, item.getProductId());
                    if (contractItemId == -1) {
                        throw new SQLException("Could not find newly created contract item ID.");
                    }

                    for (int j = 0; j < item.getQuantity(); j++) {
                        String serial = serialNumbers[serialIndex].trim();
                        int productId = item.getProductId();
                        psDAO.reserveSerial(serial, productId);

                        Device device = new Device();
                        device.setContractItemId(contractItemId);
                        device.setSerialNumber(serial);
                        device.setWarrantyExpiration(Date.valueOf(
                                LocalDate.now().plusMonths(item.getWarrantyMonths())));
                        device.setStatus("InWarranty");

                        deviceDAO.insert(device);
                        serialIndex++;
                    }
                }

                conn.commit();
                response.sendRedirect(request.getContextPath() + "/cskh/contract?message=created");

            } else {
                throw new Exception("Failed to create contract! Please try again.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            reloadFormData(request);
            request.getRequestDispatcher("/cskh/contract_create.jsp").forward(request, response);

        } finally {
            try {
                conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            contractDAO.close();
            deviceDAO.close();
            psDAO.close();
        }
    }

    private void reloadFormData(HttpServletRequest request) {
        try (UserDBContext userDAO = new UserDBContext(); ProductDAO productDAO = new ProductDAO(); ProductSerialDAO psDAO = new ProductSerialDAO()) {

            request.setAttribute("customers", userDAO.getAllActiveCustomers());

            Map<Integer, List<ProductSerial>> serialsMap = psDAO.getAvailableSerialsGroupedByProduct();
            String availableSerialsJson = new Gson().toJson(serialsMap);
            Set<Integer> productIdsWithStock = serialsMap.keySet();
            List<Product> allProducts = productDAO.getAllActiveProducts();
            List<Product> availableProducts = allProducts.stream()
                    .filter(p -> productIdsWithStock.contains(p.getId()))
                    .collect(Collectors.toList());
            request.setAttribute("products", availableProducts);
            request.setAttribute("availableSerialsJson", availableSerialsJson);

        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}
