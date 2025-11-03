/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.customer;

import dal.CustomerRequestDAO;
import data.CustomerRequest;
import data.CustomerRequestMeta;
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
public class DashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("../login");
            return;
        }

        User user = (User) session.getAttribute("user");
        CustomerRequestDAO dao = new CustomerRequestDAO();
        

        // Lấy 3 request PENDING mới nhất của user
        List<CustomerRequest> pendingRequests = dao.getPendingRequestsByCustomer(user.getId(), 5);
        List<CustomerRequestMeta> recentFeedbacks = dao.getRecentFeedbacksByCustomer(user.getId(), 3);
        request.setAttribute("recentFeedbacks", recentFeedbacks);

        request.setAttribute("pendingRequests", pendingRequests);
        request.getRequestDispatcher("/customer/dashboard.jsp").forward(request, response);
    }
}
