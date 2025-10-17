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

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        CustomerRequestDAO dao = new CustomerRequestDAO();

        String pageParam = request.getParameter("page");
        int page = (pageParam != null && pageParam.matches("\\d+")) ? Integer.parseInt(pageParam) : 1;
        int offset = (page - 1) * PAGE_SIZE;

        List<CustomerRequest> list = dao.getCustomerRequestsByCSKH(offset, PAGE_SIZE);
        int total = dao.countCustomerRequests();
        int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);

        HttpSession session = request.getSession();
        String message = (String) session.getAttribute("message");
        String error = (String) session.getAttribute("error");
        session.removeAttribute("message");
        session.removeAttribute("error");

        request.setAttribute("requests", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("total", total);
        request.setAttribute("message", message);
        request.setAttribute("error", error);

        request.getRequestDispatcher("/WEB-INF/jsp/cskh/customer_request_list.jsp").forward(request, response);
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
