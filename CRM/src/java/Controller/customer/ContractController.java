/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.customer;

import dal.ContractDAO;
import dal.DeviceDAO;
import data.Contract;
import data.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author admin
 */
public class ContractController extends HttpServlet {

    private DeviceDAO deviceDAO = new DeviceDAO();
    private ContractDAO contractDAO = new ContractDAO();
    private final int LIMIT = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("../login");
            return;
        }
        User user = (User) session.getAttribute("user");
        String brand = request.getParameter("brand");
        String category = request.getParameter("category");
        String pageParam = request.getParameter("page");
        String searchQuery = request.getParameter("search");
        String contractcode = request.getParameter("contract_code");
        int page = 1;
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        int offset = (page - 1) * LIMIT;

        List<String> brands = deviceDAO.getBrandsByUserId(user.getId());
        List<String> categories = deviceDAO.getCategoriesByUserId(user.getId());
        List<String> codes = deviceDAO.getContractCodesByUserId(user.getId());
        List<Contract> contracts = contractDAO.getContractsByUserId(user.getId(), searchQuery, contractcode, brand, category, offset, LIMIT);

        request.setAttribute("brands", brands);
        request.setAttribute("categories", categories);
        request.setAttribute("codes", codes);
        request.setAttribute("brand", brand);
        request.setAttribute("category", category);
        request.setAttribute("search", searchQuery);
        request.setAttribute("contracts", contracts);
        request.setAttribute("totalProducts", contracts.size());
        request.setAttribute("totalPages", 1);

        request.getRequestDispatcher("/customer/contract.jsp").forward(request, response);
    }
}
