/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.customer;

import dal.CustomerRequestDAO;
import dal.FeedbackDAO;
import data.CustomerRequest;
import data.Feedback;
import data.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author admin
 */
public class CreateFeedbackController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Lấy danh sách request đã hoàn thành để hiển thị trên dropdown
        CustomerRequestDAO dao = new CustomerRequestDAO();
        List<CustomerRequest> requestList = dao.getCompletableRequests(user.getId());

        request.setAttribute("requestList", requestList);
        request.getRequestDispatcher("/customer/createFeedback.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int requestId = Integer.parseInt(request.getParameter("requestId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            Feedback feed = new Feedback();
            feed.setRequestId(requestId);
            feed.setComment(comment);
            feed.setRating(rating);
            
            FeedbackDAO dao = new FeedbackDAO();           
            // Lưu feedback
            boolean success = dao.saveFeedback(feed);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/customer/listFeedback?success=Feedback created successfully!");
            } else {
                request.setAttribute("error", "Failed to create Feedback. Please try again.");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
