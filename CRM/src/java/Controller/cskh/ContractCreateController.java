/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.cskh;

import dal.ContractDAO;
import dal.ProductDAO;
import dal.UserDBContext;
import data.Contract;
import data.ContractItem;
import data.Product;
import data.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/cskh/createContract")
public class ContractCreateController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            UserDBContext userDAO = new UserDBContext();
            ProductDAO productDAO = new ProductDAO();

            ArrayList<User> customers = userDAO.getAllActiveCustomers();
            List<Product> products = productDAO.getAllActiveProducts();

            request.setAttribute("customers", customers);
            request.setAttribute("products", products);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading data: " + e.getMessage());
        }

        request.getRequestDispatcher("/cskh/contract_create.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            request.setCharacterEncoding("UTF-8");

            int customerId = Integer.parseInt(request.getParameter("customerId"));
            String contractCode = request.getParameter("contractCode");
            String contractDateStr = request.getParameter("contractDate");
            String description = request.getParameter("description");

            if (contractCode == null || contractCode.isEmpty() || contractDateStr == null) {
                throw new IllegalArgumentException("Contract code or date missing!");
            }

            ContractDAO dao = new ContractDAO();

            if (dao.isContractCodeExists(contractCode)) {
                request.setAttribute("error", "Contract code already exists! Please choose another one.");

                UserDBContext userDAO = new UserDBContext();
                ProductDAO productDAO = new ProductDAO();
                request.setAttribute("customers", userDAO.getAllActiveCustomers());
                request.setAttribute("products", productDAO.getAllActiveProducts());

                request.getRequestDispatcher("/cskh/contract_create.jsp").forward(request, response);
                return;
            }

            Date contractDate = Date.valueOf(contractDateStr);

            Contract contract = new Contract();
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

            if (productIds == null || productIds.length == 0) {
                request.setAttribute("error", "Please add at least one contract item!");
                reloadFormData(request);
                request.getRequestDispatcher("/cskh/contract_create.jsp").forward(request, response);
                return;
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
            }

            if (items.isEmpty()) {
                request.setAttribute("error", "Contract must contain at least one valid product!");
                reloadFormData(request);
                request.getRequestDispatcher("/cskh/contract_create.jsp").forward(request, response);
                return;
            }

            contract.setTotalAmount(calculatedTotalAmount);

            int newContractId = dao.insertContractWithItems(contract, items);

            if (newContractId > 0) {
                response.sendRedirect(request.getContextPath() + "/cskh/contract?message=created");
            } else {
                request.setAttribute("error", "Failed to create contract! Please try again.");
                reloadFormData(request);
                request.getRequestDispatcher("/cskh/contract_create.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while creating the contract!");
            reloadFormData(request);
            request.getRequestDispatcher("/cskh/contract_create.jsp").forward(request, response);
        }
    }

    private void reloadFormData(HttpServletRequest request) {
        try {
            UserDBContext userDAO = new UserDBContext();
            ProductDAO productDAO = new ProductDAO();
            request.setAttribute("customers", userDAO.getAllActiveCustomers());
            request.setAttribute("products", productDAO.getAllActiveProducts());
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

}
