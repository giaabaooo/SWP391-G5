/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.cskh;

import dal.ContractDAO;
import data.Contract;
import data.ContractItem;
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
            String totalAmountStr = request.getParameter("totalAmount");
            String description = request.getParameter("description");

            if (contractCode == null || contractCode.isEmpty() || contractDateStr == null) {
                throw new IllegalArgumentException("Contract code or date missing!");
            }

            Date contractDate = Date.valueOf(contractDateStr);
            double totalAmount = totalAmountStr != null && !totalAmountStr.isEmpty()
                    ? Double.parseDouble(totalAmountStr)
                    : 0.0;

            Contract contract = new Contract();
            contract.setCustomerId(customerId);
            contract.setContractCode(contractCode);
            contract.setContractDate(contractDate);
            contract.setTotalAmount(totalAmount);
            contract.setDescription(description);

            String[] productIds = request.getParameterValues("productId");
            String[] quantities = request.getParameterValues("quantity");
            String[] prices = request.getParameterValues("unitPrice");
            String[] warrantyMonths = request.getParameterValues("warrantyMonths");
            String[] maintenanceMonths = request.getParameterValues("maintenanceMonths");
            String[] maintenanceFreq = request.getParameterValues("maintenanceFrequencyMonths");

            List<ContractItem> items = new ArrayList<>();

            if (productIds != null) {
                for (int i = 0; i < productIds.length; i++) {
                    if (productIds[i] == null || productIds[i].isEmpty()) continue;

                    ContractItem item = new ContractItem();
                    item.setProductId(Integer.parseInt(productIds[i]));
                    item.setQuantity(Integer.parseInt(quantities[i]));
                    item.setUnitPrice(Double.parseDouble(prices[i]));
                    item.setWarrantyMonths(Integer.parseInt(warrantyMonths[i]));
                    item.setMaintenanceMonths(Integer.parseInt(maintenanceMonths[i]));
                    item.setMaintenanceFrequencyMonths(Integer.parseInt(maintenanceFreq[i]));

                    items.add(item);
                }
            }

            ContractDAO dao = new ContractDAO();
            int newContractId = dao.insertContractWithItems(contract, items);

            if (newContractId > 0) {
                response.sendRedirect(request.getContextPath() + "/cskh/contract?message=created");
            } else {
                request.setAttribute("error", "Failed to create contract! Please try again.");
                request.getRequestDispatcher("/cskh/contract_create.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while creating the contract!");
            request.getRequestDispatcher("/cskh/contract_create.jsp").forward(request, response);
        }
    }
}
