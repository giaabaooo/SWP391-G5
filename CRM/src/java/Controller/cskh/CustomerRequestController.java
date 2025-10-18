/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.cskh;

import dal.CustomerRequestDAO;
import data.CustomerRequest;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author admin
 */
@WebServlet("/cskh/customer-request")
public class CustomerRequestController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        CustomerRequestDAO dao = new CustomerRequestDAO();

        int page = 1;
        int pageSize = 10;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Math.max(1, Integer.parseInt(pageParam));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        String type = request.getParameter("type");
        String status = request.getParameter("status");

        int offset = (page - 1) * pageSize;
        List<CustomerRequest> list = dao.getCustomerRequestsByCSKH(offset, pageSize, type, status);
        int total = dao.countCustomerRequests(type, status);
        int totalPages = (int) Math.ceil((double) total / pageSize);
        if (totalPages == 0) {
            totalPages = 1;
        }

        request.setAttribute("requests", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("total", total);
        request.setAttribute("type", type);
        request.setAttribute("status", status);
        request.setAttribute("pageSize", pageSize);

        request.getRequestDispatcher("/cskh/customer_request_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        CustomerRequestDAO dao = new CustomerRequestDAO();
        HttpSession session = request.getSession();

        if ("transferToTechManager".equals(action)) {
            try {
                int requestId = Integer.parseInt(request.getParameter("id"));
                dao.transferToTechManager(requestId);
                session.setAttribute("message", "Request transferred successfully!");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("error", "Failed to transfer request!");
            }
        }

        response.sendRedirect(request.getContextPath() + "/cskh/customer-request");
    }
}
