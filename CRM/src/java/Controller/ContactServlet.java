package Controller;

import dal.GuestContactDAO;
import java.io.IOException;
// import java.io.PrintWriter; // Không cần PrintWriter nữa
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet; // Đảm bảo đã import
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


public class ContactServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // 1. Lấy dữ liệu từ form
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String message = request.getParameter("message");

        try {
            // 2. Validate dữ liệu phía Server (Bảo mật)
            if (fullName == null || fullName.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                message == null || message.trim().isEmpty()) {
                
                // Ném Exception để khối catch xử lý
                throw new Exception("Please fill in all required fields.");
            }

            // 3. Gọi DAO để lưu
            GuestContactDAO dao = new GuestContactDAO();
            boolean success = dao.saveContactMessage(fullName, email, phone, message);

            if (success) {
                // 4. THÀNH CÔNG: Đặt Attribute
                request.setAttribute("success", "Thank you! Your message has been sent. We will contact you shortly.");
            } else {
                // 5. THẤT BẠI (DAO)
                throw new Exception("Error! Could not save message to database.");
            }
            
        } catch (Exception e) {
            // 6. THẤT BẠI (Chung)
            e.printStackTrace();
            request.setAttribute("error", e.getMessage()); // Gửi lỗi
        }
        
        // 7. LUÔN LUÔN FORWARD
        // Chuyển tiếp về lại trang chủ để hiển thị thông báo
        // (Nếu file trang chủ của bạn là "landing_page.jsp", hãy đổi tên ở đây)
        request.getRequestDispatcher("/landing_page.jsp").forward(request, response); 
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng GET (trỏ về trang chủ)
        response.sendRedirect(request.getContextPath() + "/landing_page.jsp"); // Sửa lại tên file nếu cần
    }
}