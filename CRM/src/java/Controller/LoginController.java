package Controller;

import dal.UserDBContext;

import data.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;


public class LoginController extends HttpServlet {
    private UserDBContext UserDBContext = new UserDBContext();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        User user = UserDBContext.checkLogin(username, password);

        if (user != null) {
            HttpSession session = req.getSession();
            session.setAttribute("user", user);

            // Redirect theo role
            String role = user.getRole().getName();
            if ("ADMIN".equalsIgnoreCase(role)) {
                resp.sendRedirect("admin/dashboard.jsp");
            } else if ("USER".equalsIgnoreCase(role)) {
                resp.sendRedirect("user/home.jsp");
            } else {
                resp.sendRedirect("index.jsp"); // fallback
            }
        } else {
            req.setAttribute("error", "Sai username hoặc mật khẩu!");
            
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("login.jsp").forward(req, resp);
    }
}
