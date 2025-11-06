/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.cskh;

import dal.FeedbackDAO;
import data.Feedback;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author admin
 */
@WebServlet("/cskh/feedback")
public class FeedbackController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private FeedbackDAO feedbackDAO = new FeedbackDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int page = 1;
        int pageSize = 10;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        String responseStatus = request.getParameter("responseStatus");
        String rating = request.getParameter("rating");

        int totalItems = feedbackDAO.countAllFeedbacks(responseStatus, rating);
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);

        List<Feedback> feedbacks = feedbackDAO.getAllFeedbacks(page, pageSize, responseStatus, rating);

        request.setAttribute("feedbacks", feedbacks);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("page", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);

        request.setAttribute("responseStatus", responseStatus);
        request.setAttribute("rating", rating);

        request.getRequestDispatcher("/cskh/feedback_list.jsp").forward(request, response);
    }
}
