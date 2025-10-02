package Controller;

import dal.UserDAO;
import util.EmailUtility;
import util.TokenGenerator;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("emailOrUsername");

        if (userDAO.checkEmailExists(email)) {
            String token = TokenGenerator.generateToken();

            HttpSession session = request.getSession();
            session.setAttribute("resetToken", token);
            session.setAttribute("resetEmail", email);
            session.setMaxInactiveInterval(15 * 60); // 15 phút

            String resetLink = request.getScheme() + "://" +
                    request.getServerName() + ":" + request.getServerPort() +
                    request.getContextPath() + "/reset-password?token=" + token;

            try {
                EmailUtility.sendEmail(email, "Password Reset Request",
                        "Click here to reset your password: " + resetLink);
                response.sendRedirect("forgot.jsp?success=true");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("forgot.jsp?error=email");
            }
        } else {
            response.sendRedirect("forgot.jsp?error=notfound");
        }
    }
}
