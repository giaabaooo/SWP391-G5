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
        
        // Check blank
    if (username == null || username.trim().isEmpty() ||
        password == null || password.trim().isEmpty()) {
        req.setAttribute("error", "Username or password cannot be blank!");
        req.getRequestDispatcher("login.jsp").forward(req, resp);
        return;
    }

        User user = UserDBContext.checkLogin(username, password);

         if (user != null) {
            HttpSession session = req.getSession();
            session.setAttribute("user", user);
            

            // Lấy role name từ DB
            String role = user.getRole().getName().toUpperCase();

            switch (role) {
                case "ADMIN":
                    resp.sendRedirect("admin/dashboard.jsp");
                    break;
                case "CUSTOMER":
                    resp.sendRedirect("customer/dashboard.jsp");
                    break;
                case "CUSTOMERSERVICE":
                    resp.sendRedirect("cskh/customer?action=list");
                    break;
                case "TECH_MANAGER":
                    resp.sendRedirect("techmanager/dashboard");
                    break;
                case "TECHNICIAN":
                    resp.sendRedirect("technician/dashboard.jsp");
                    break;
                case "WAREHOUSE":
                    resp.sendRedirect("warehouse/dashboard.jsp");
                    break;
                default:
                    resp.sendRedirect("index.jsp"); // fallback
            }
        } else {
            req.setAttribute("error", "Wrong username or password!");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("login.jsp").forward(req, resp);
    }
}
