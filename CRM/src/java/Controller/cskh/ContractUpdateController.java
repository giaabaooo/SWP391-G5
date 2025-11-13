package Controller.cskh;

import com.google.gson.Gson;
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
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@WebServlet("/cskh/updateContract")
public class ContractUpdateController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try (ContractDAO contractDAO = new ContractDAO();
             DeviceDAO deviceDAO = new DeviceDAO();
             UserDBContext userDAO = new UserDBContext();
             ProductDAO productDAO = new ProductDAO();
             ProductSerialDAO psDAO = new ProductSerialDAO()) {

            int contractId = Integer.parseInt(request.getParameter("id"));

            Contract contract = contractDAO.getContractDetail(contractId);
            List<ContractItem> items = contractDAO.getContractItems(contractId);
            ArrayList<User> customers = userDAO.getAllActiveCustomers();
            List<Product> products = productDAO.getAllActiveProducts();
            List<Device> allDevices = deviceDAO.getDevicesByContractId(contractId);

            Map<Integer, List<ProductSerial>> availableSerialsMap = psDAO.getAvailableSerialsForUpdate(contractId);
            String availableSerialsJson = new Gson().toJson(availableSerialsMap);

            Map<Integer, List<String>> currentSerialsMap = new HashMap<>();
            for (Device d : allDevices) {
                currentSerialsMap.computeIfAbsent(d.getContractItemId(), k -> new ArrayList<>())
                        .add(d.getSerialNumber());
            }

            if (contract == null) {
                response.sendRedirect(request.getContextPath() + "/cskh/contract?error=notFound");
                return;
            }

            request.setAttribute("contract", contract);
            request.setAttribute("items", items);
            request.setAttribute("customers", customers);
            request.setAttribute("products", products);
            
            request.setAttribute("availableSerialsJson", availableSerialsJson); 
            request.setAttribute("currentSerialsMap", currentSerialsMap); 

            request.getRequestDispatcher("/cskh/contract_update.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading contract data: " + e.getMessage());
            request.getRequestDispatcher("/cskh/contract_update.jsp").forward(request, response);
        }
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
        
        int contractId = 0; 

        try {
            request.setCharacterEncoding("UTF-8");
            conn.setAutoCommit(false); 

            contractId = Integer.parseInt(request.getParameter("contractId"));

            int customerId = Integer.parseInt(request.getParameter("customerId"));
            String contractCode = request.getParameter("contractCode"); 
            String contractDateStr = request.getParameter("contractDate");
            String description = request.getParameter("description");

            String[] newSerialNumbers = request.getParameterValues("serialNumber");
            Set<String> newSerialsSet = new HashSet<>();
            
            if (newSerialNumbers == null || newSerialNumbers.length == 0) {
                 throw new Exception("Contract must have at least one item.");
            }
            
            for (String serial : newSerialNumbers) {
                if (serial == null || serial.trim().isEmpty()) {
                    throw new Exception("A selected serial number is empty.");
                }
                if (!newSerialsSet.add(serial.trim())) {
                    throw new Exception("Duplicate serial number selected: " + serial.trim());
                }
            }

            List<Device> oldDevices = deviceDAO.getDevicesByContractId(contractId);
            Set<String> oldSerialsSet = oldDevices.stream()
                                                .map(Device::getSerialNumber)
                                                .collect(Collectors.toSet());

            Date contractDate = Date.valueOf(contractDateStr);

            Contract contract = new Contract();
            contract.setId(contractId);
            contract.setCustomerId(customerId);
            contract.setContractCode(contractCode); // Lấy contract code từ form (dù đã readonly)
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
            
            if (productIds == null || productIds.length != newSerialNumbers.length) {
                 throw new Exception("Mismatch between item count and serial count.");
            }

            for (int i = 0; i < productIds.length; i++) {
                int qty = Integer.parseInt(quantities[i]);
                double price = Double.parseDouble(prices[i]);

                ContractItem item = new ContractItem();
                item.setProductId(Integer.parseInt(productIds[i]));
                item.setQuantity(qty);
                item.setUnitPrice(price);
                item.setWarrantyMonths(Integer.parseInt(warrantyMonths[i]));
                item.setMaintenanceMonths(Integer.parseInt(maintenanceMonths[i]));
                item.setMaintenanceFrequencyMonths(Integer.parseInt(maintenanceFreq[i]));

                items.add(item);
                calculatedTotalAmount += qty * price;
            }

            contract.setTotalAmount(calculatedTotalAmount);

            boolean success = contractDAO.updateContractAndRecreateItems(contract, items);
            if (!success) {
                 throw new Exception("Failed to update contract items in DAO.");
            }

            int serialIndex = 0;
            for (ContractItem item : items) {
                int contractItemId = contractDAO.getLastActiveContractItemId(contractId, item.getProductId());
                if(contractItemId == -1) {
                    throw new SQLException("Could not find new contract item ID.");
                }
                
                String serial = newSerialNumbers[serialIndex].trim();

                Device device = new Device();
                device.setContractItemId(contractItemId);
                device.setSerialNumber(serial);
                device.setWarrantyExpiration(Date.valueOf(
                        LocalDate.now().plusMonths(item.getWarrantyMonths())));
                device.setStatus("InWarranty");

                deviceDAO.insert(device); 
                serialIndex++;
            }

            Set<String> serialsToRelease = new HashSet<>(oldSerialsSet);
            serialsToRelease.removeAll(newSerialsSet); 

            Set<String> serialsToReserve = new HashSet<>(newSerialsSet);
            serialsToReserve.removeAll(oldSerialsSet); 
            
            for (String serial : serialsToRelease) {
                psDAO.releaseSerial(serial);
            }
            
            // SỬA: XÓA VÒNG LẶP GÂY LỖI -1 TẠI ĐÂY
            
            Map<String, Integer> newSerialProductMap = new HashMap<>();
            for(int i=0; i < newSerialNumbers.length; i++) {
                newSerialProductMap.put(newSerialNumbers[i].trim(), Integer.parseInt(productIds[i]));
            }

            // Chỉ chạy vòng lặp ĐÚNG
            for (String serial : serialsToReserve) {
                int pId = newSerialProductMap.get(serial);
                psDAO.reserveSerial(serial, pId); // Giờ đã có productId
            }

            conn.commit(); 
            response.sendRedirect(request.getContextPath() + "/cskh/contract_detail?id=" + contractId + "&message=updated");

        } catch (Exception e) {
            e.printStackTrace();
            try {
                conn.rollback(); 
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            request.setAttribute("error", "Failed to update contract: " + e.getMessage());
            reloadFormData(request, contractId);
            request.getRequestDispatcher("/cskh/contract_update.jsp").forward(request, response);
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

    private void reloadFormData(HttpServletRequest request, int contractId) {
        try (ContractDAO contractDAO = new ContractDAO();
             DeviceDAO deviceDAO = new DeviceDAO();
             UserDBContext userDAO = new UserDBContext();
             ProductDAO productDAO = new ProductDAO();
             ProductSerialDAO psDAO = new ProductSerialDAO()) {
            
            request.setAttribute("contract", contractDAO.getContractDetail(contractId));
            request.setAttribute("items", contractDAO.getContractItems(contractId));
            request.setAttribute("customers", userDAO.getAllActiveCustomers());
            request.setAttribute("products", productDAO.getAllActiveProducts());

            Map<Integer, List<ProductSerial>> availableSerialsMap = psDAO.getAvailableSerialsForUpdate(contractId);
            String availableSerialsJson = new Gson().toJson(availableSerialsMap);

            List<Device> allDevices = deviceDAO.getDevicesByContractId(contractId);
            Map<Integer, List<String>> currentSerialsMap = new HashMap<>();
            for (Device d : allDevices) {
                currentSerialsMap.computeIfAbsent(d.getContractItemId(), k -> new ArrayList<>())
                        .add(d.getSerialNumber());
            }

            request.setAttribute("availableSerialsJson", availableSerialsJson);
            request.setAttribute("currentSerialsMap", currentSerialsMap);
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}