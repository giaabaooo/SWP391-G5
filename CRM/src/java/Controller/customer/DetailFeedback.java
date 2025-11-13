package Controller.customer;

import dal.FeedbackDAO;
import data.Feedback;
import data.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


public class DetailFeedback extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int requestId = Integer.parseInt(request.getParameter("id"));
            FeedbackDAO dao = new FeedbackDAO();
            
            // Gọi hàm DAO mới
            Feedback feedback = dao.getFeedbackDetailsById(requestId);
            
            // Kiểm tra bảo mật (Nếu không tìm thấy hoặc không thuộc sở hữu)
            if (feedback == null) {
                session.setAttribute("errorMessage", "Feedback not found or you don't have permission.");
                response.sendRedirect(request.getContextPath() + "/customer/listFeedback");
                return;
            }
            
            request.setAttribute("feedback", feedback);
            request.getRequestDispatcher("/customer/detailFeedback.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error loading feedback details.");
            response.sendRedirect(request.getContextPath() + "/customer/listFeedback");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Trang này là trang chỉ đọc, không xử lý POST
        doGet(request, response);
    }
}