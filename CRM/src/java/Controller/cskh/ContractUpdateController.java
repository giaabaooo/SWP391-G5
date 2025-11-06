/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.cskh;

import dal.ContractDAO;
import dal.DeviceDAO;
import dal.ProductDAO;
import dal.UserDBContext;
import data.Contract;
import data.ContractItem;
import data.Device;
import data.Product;
import data.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author admin
 */
@WebServlet("/cskh/updateContract")
public class ContractUpdateController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private ContractDAO contractDAO = new ContractDAO();
    private DeviceDAO deviceDAO = new DeviceDAO();
    private UserDBContext userDAO = new UserDBContext();
    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int contractId = Integer.parseInt(request.getParameter("id"));

            Contract contract = contractDAO.getContractDetail(contractId);
            List<ContractItem> items = contractDAO.getContractItems(contractId);

            ArrayList<User> customers = userDAO.getAllActiveCustomers();
            List<Product> products = productDAO.getAllActiveProducts();

            List<Device> allDevices = deviceDAO.getDevicesByContractId(contractId);

            Map<Integer, List<String>> serialsMap = new HashMap<>();
            for (Device d : allDevices) {
                serialsMap.computeIfAbsent(d.getContractItemId(), k -> new ArrayList<>())
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

            request.setAttribute("serialsMap", serialsMap);

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

        try {
            request.setCharacterEncoding("UTF-8");

            int contractId = Integer.parseInt(request.getParameter("contractId"));

            int customerId = Integer.parseInt(request.getParameter("customerId"));
            String contractCode = request.getParameter("contractCode");
            String contractDateStr = request.getParameter("contractDate");
            String description = request.getParameter("description");

            String[] serialNumbers = request.getParameterValues("serialNumber");
            
            if (serialNumbers != null) {
                java.util.Set<String> serialSet = new java.util.HashSet<>();
                for (String serial : serialNumbers) {
                    if (serial == null || serial.trim().isEmpty()) {
                        request.setAttribute("error", "Serial number cannot be empty.");
                        reloadFormData(request);
                        request.getRequestDispatcher("/cskh/contract_update.jsp").forward(request, response);
                        return;
                    }
                    
                    String trimmedSerial = serial.trim();
                    
                    if (!serialSet.add(trimmedSerial)) {
                        request.setAttribute("error", "Duplicate serial number entered: " + trimmedSerial);
                        reloadFormData(request);
                        request.getRequestDispatcher("/cskh/contract_update.jsp").forward(request, response);
                        return;
                    }

                    if (deviceDAO.isSerialNumberExistsOnOtherContracts(trimmedSerial, contractId)) {
                        request.setAttribute("error", "Serial number already exists on another contract: " + trimmedSerial);
                        reloadFormData(request);
                        request.getRequestDispatcher("/cskh/contract_update.jsp").forward(request, response);
                        return;
                    }
                }
            }
            
            Date contractDate = Date.valueOf(contractDateStr);

            Contract contract = new Contract();
            contract.setId(contractId);
            contract.setCustomerId(customerId);
            contract.setContractCode(contractCode);
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

            if (productIds != null) {
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
                }
            }

            if (items.isEmpty()) {
                throw new Exception("Contract must have at least one item.");
            }

            contract.setTotalAmount(calculatedTotalAmount);

            boolean success = contractDAO.updateContractAndRecreateItems(contract, items);

            if (success) {
                int serialIndex = 0;
                for (ContractItem item : items) {
                    int contractItemId = contractDAO.getLastActiveContractItemId(contractId, item.getProductId());

                    for (int j = 0; j < item.getQuantity(); j++) {
                        String serial = (serialNumbers != null && serialIndex < serialNumbers.length)
                                ? serialNumbers[serialIndex].trim()
                                : "AUTO-" + System.currentTimeMillis() + "-" + j;

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
                response.sendRedirect(request.getContextPath() + "/cskh/contract_detail?id=" + contractId + "&message=updated");
            } else {
                throw new Exception("Failed to update contract in DAO.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to update contract: " + e.getMessage());
            reloadFormData(request);
            request.getRequestDispatcher("/cskh/contract_update.jsp").forward(request, response);
        }
    }

    private void reloadFormData(HttpServletRequest request) {
        try {
            int contractId = Integer.parseInt(request.getParameter("contractId"));
            request.setAttribute("contract", contractDAO.getContractDetail(contractId));
            request.setAttribute("items", contractDAO.getContractItems(contractId));
            request.setAttribute("customers", userDAO.getAllActiveCustomers());
            request.setAttribute("products", productDAO.getAllActiveProducts());
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}
