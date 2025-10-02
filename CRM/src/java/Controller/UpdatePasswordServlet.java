package Controller;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/update-password")
public class UpdatePasswordServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String newPassword = request.getParameter("password");

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("resetEmail");

        if (email != null) {
            userDAO.updatePassword(email, newPassword);

            // clear token
            session.removeAttribute("resetToken");
            session.removeAttribute("resetEmail");

            response.sendRedirect("login.jsp?reset=success");
        } else {
            response.getWriter().println("Session expired. Please try again.");
        }
    }
}
