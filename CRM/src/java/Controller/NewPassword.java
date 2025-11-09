package Controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dal.DAOAccount;
import dal.UserDBContext;
import java.sql.PreparedStatement;
import utils.Validation;

@WebServlet(name = "NewPassword", urlPatterns = {"/newpassword"})
public class NewPassword extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String token = request.getParameter("token");
        HttpSession session = request.getSession();
        String sessionToken = (String) session.getAttribute("resetToken");

        if (token != null && !token.isEmpty() && token.equals(sessionToken)) {
            request.getRequestDispatcher("newPassword.jsp").forward(request, response);
        } else {
            request.setAttribute("mess", "Invalid or expired password reset link.");
            request.getRequestDispatcher("forgetPassword.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();

        String newPassword = request.getParameter("password");
        String rePassword = request.getParameter("repassword");
        String formToken = request.getParameter("token"); // Lấy token từ form
        String sessionToken = (String) session.getAttribute("resetToken"); // Lấy token từ session

        if (formToken == null || !formToken.equals(sessionToken)) {
            request.setAttribute("mess", "Invalid or expired session. Please try again.");
            request.getRequestDispatcher("forgetPassword.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(rePassword)) {
            request.setAttribute("mess", "Your password does not match.");
            request.getRequestDispatcher("newPassword.jsp").forward(request, response);
            return;
        }

        if (!Validation.checkPassWord(newPassword)) {
            request.setAttribute("mess", "Password must have at least 6 characters, including uppercase letters, lowercase letters, and special characters");
            request.getRequestDispatcher("newPassword.jsp").forward(request, response);
            return;
        }

        try {
            String mail = (String) session.getAttribute("emailForReset");
            if (mail == null) {
                request.setAttribute("mess", "Session expired. Please start over.");
                request.getRequestDispatcher("forgetPassword.jsp").forward(request, response);
                return;
            }

            UserDBContext userDb = new UserDBContext();

            String hashedPassword = userDb.hashPassword(newPassword);

            DAOAccount dao = new DAOAccount();

            int result = dao.resetPasswordByEmail(mail, hashedPassword);

            session.removeAttribute("resetToken");
            session.removeAttribute("emailForReset");

            if (result > 0) {
                request.setAttribute("mess", "Reset successfully! Please login with your new password.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                request.setAttribute("mess", "Reset password failed!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mess", "An error occurred while resetting password.");
            request.getRequestDispatcher("newPassword.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
