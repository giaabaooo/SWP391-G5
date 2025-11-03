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
        String limitParam = request.getParameter("pageSize");
        String searchQuery = request.getParameter("search");
        String type = request.getParameter("type");
        String rating = request.getParameter("rating");
        int page = 1;
        int limit = LIMIT;
        try {
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        // Đọc số lượng mỗi trang (pageSize)
        try {
            if (limitParam != null && !limitParam.isEmpty()) {
                limit = Integer.parseInt(limitParam);
            }
        } catch (NumberFormatException e) {
            limit = LIMIT;
        }

        int offset = (page - 1) * limit;

        FeedbackDAO dao = new FeedbackDAO();
             
        List<Feedback> feedbacks = dao.getFeedbacksByCustomer(user.getId(), searchQuery, type, rating,offset,limit);
        int totalProducts = dao.countFeedbacksByCustomer(user.getId(), searchQuery, type, rating);
        int totalPages = (int) Math.ceil((double) totalProducts / limit);
        if (totalPages == 0) {
            totalPages = 1; 
        }
        List<String> requestTypes = List.of("WARRANTY", "REPAIR", "MAINTENANCE");
        request.setAttribute("types", requestTypes);
        request.setAttribute("type", type);
        request.setAttribute("search", searchQuery);
        request.setAttribute("rating", rating);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("pageSize", limit);

        request.setAttribute("feedbacks", feedbacks);
        request.getRequestDispatcher("/customer/listFeedback.jsp").forward(request, response);
    }
}
