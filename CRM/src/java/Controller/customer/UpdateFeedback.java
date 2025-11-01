/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.customer;

import dal.CustomerRequestDAO;
import dal.FeedbackDAO;
import data.Feedback;
import data.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author admin
 */
public class UpdateFeedback extends HttpServlet {
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
           int requestId = Integer.parseInt(request.getParameter("id"));
                       
            FeedbackDAO feedbackDAO = new FeedbackDAO();
            Feedback feedbackData = feedbackDAO.getFeedbackByRequestId(requestId, user.getId() );
           
            request.setAttribute("feedbackData", feedbackData);
            request.getRequestDispatcher("/customer/updateFeedback.jsp").forward(request, response);
      
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
      
            Feedback updateFeedback = new Feedback();
            updateFeedback.setRequestId(requestId);
            updateFeedback.setComment(comment);
            updateFeedback.setRating(rating);
            
            FeedbackDAO feedbackDAO = new FeedbackDAO();
            boolean success = feedbackDAO.updateFeedback(updateFeedback);        
             if (success) {
                response.sendRedirect(request.getContextPath() + "/customer/listFeedback?success=Feedback updated successfully!");
            } else {
                request.setAttribute("error", "Failed to update Feedback. Please try again.");
            }
           
        } catch (Exception e) {
             e.printStackTrace();
        }
    }
}
