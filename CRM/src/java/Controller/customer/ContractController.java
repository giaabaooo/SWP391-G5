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
import java.text.DecimalFormat;
import java.text.NumberFormat;
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
        String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");
        

        int page = 1;
        int pageSize = LIMIT;

        // Parse page number
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // Parse page size
        if (pageSizeParam != null && !pageSizeParam.isEmpty()) {
            try {
                pageSize = Integer.parseInt(pageSizeParam);
                if (pageSize < 1) {
                    pageSize = LIMIT;
                }
                if (pageSize > 100) {
                    pageSize = 100; // Max 100 items per page
                }
            } catch (NumberFormatException e) {
                pageSize = LIMIT;
            }
        }

        int offset = (page - 1) * pageSize;

        List<Contract> contracts = contractDAO.getContractsByUserId(user.getId(), offset, pageSize);
        int totalContracts = contractDAO.countContractsByUserId(user.getId());
        int totalPages = (int) Math.ceil((double) totalContracts / (double) pageSize);
        if (totalPages == 0) {
            totalPages = 1; // At least 1 page even if no contracts
        }
        request.setAttribute("contracts", contracts);
        request.setAttribute("totalContracts", totalContracts);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);

        request.getRequestDispatcher("/customer/contract.jsp").forward(request, response);
    }
}
