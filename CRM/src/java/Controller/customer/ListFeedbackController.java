/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.customer;

import dal.FeedbackDAO;
import data.Feedback;
import data.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import static java.util.Collections.list;
import java.util.List;

/**
 *
 * @author admin
 */
public class ListFeedbackController extends HttpServlet {
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
        int page = 1;
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        int offset = (page - 1) * LIMIT;

        FeedbackDAO dao = new FeedbackDAO();
        String searchQuery = request.getParameter("search");
        String type = request.getParameter("type");
        String rating = request.getParameter("rating");
        String keyword = request.getParameter("keyword");
        
        List<Feedback> feedbacks = dao.getFeedbacksByCustomer(user.getId(), searchQuery, type, rating,offset,LIMIT);
        List<String> requestTypes = List.of("WARRANTY", "REPAIR", "MAINTENANCE");
        request.setAttribute("types", requestTypes);
        request.setAttribute("type", type);
        request.setAttribute("search", searchQuery);
        request.setAttribute("rating", rating);

        request.setAttribute("feedbacks", feedbacks);
        request.getRequestDispatcher("/customer/listFeedback.jsp").forward(request, response);
    }
}
