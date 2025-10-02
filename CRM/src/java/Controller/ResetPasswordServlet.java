package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");
        HttpSession session = request.getSession();

        String savedToken = (String) session.getAttribute("resetToken");
        if (savedToken != null && savedToken.equals(token)) {
            request.getRequestDispatcher("resetpassword.jsp").forward(request, response);
        } else {
            response.getWriter().println("Invalid or expired reset token!");
        }
    }
}
