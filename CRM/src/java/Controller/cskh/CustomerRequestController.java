/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.cskh;

import dal.CustomerRequestDAO;
import data.CustomerRequest;
import data.CustomerRequestMeta;
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
                page = Integer.parseInt(pageParam);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        String type = request.getParameter("type");
        String status = request.getParameter("status");
        String priority = request.getParameter("priority");
        String paymentStatus = request.getParameter("paymentStatus");

        int total = dao.countCustomerRequests(type, status, priority, paymentStatus);
        int totalPages = (int) Math.ceil((double) total / pageSize);
        if (totalPages == 0) {
            totalPages = 1;
        }

        int offset = (page - 1) * pageSize;
        List<CustomerRequest> list = dao.getCustomerRequestsByCSKH(offset, pageSize, type, status, priority, paymentStatus);

        request.setAttribute("requests", list);
        request.setAttribute("totalItems", total);
        request.setAttribute("page", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);

        request.setAttribute("type", type);
        request.setAttribute("status", status);
        request.setAttribute("priority", priority);
        request.setAttribute("paymentStatus", paymentStatus);

        request.getRequestDispatcher("/cskh/customer_request_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        CustomerRequestDAO dao = new CustomerRequestDAO();
        HttpSession session = request.getSession();

        String redirectUrl = request.getContextPath() + "/cskh/customer-request";

        try {
            if (idParam == null || idParam.isEmpty()) {
                throw new Exception("Missing ID");
            }

            int requestId = Integer.parseInt(idParam);

            if ("transferToTechManager".equals(action)) {
                dao.transferToTechManager(requestId);
                CustomerRequestMeta meta = dao.getCusRequestMetaById(requestId);
                if (meta == null || meta.getPriority() == null || meta.getPriority().isEmpty()) {
                dao.updatePriority(requestId, "MEDIUM");
            }
                session.setAttribute("message", "Request #" + requestId + " transferred successfully!");

            } else if ("closeRequest".equals(action)) {
                dao.updateRequest("CLOSED", 1, requestId);
                session.setAttribute("message", "Request #" + requestId + " has been closed.");

            } else {
                throw new Exception("Unknown action");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Failed to perform action: " + e.getMessage());
        }

        response.sendRedirect(redirectUrl);
    }
}
