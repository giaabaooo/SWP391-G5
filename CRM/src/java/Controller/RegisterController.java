package Controller;

import dal.UserDBContext; 
import data.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class RegisterController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        
        String username = request.getParameter("username");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        UserDBContext userDAO = new UserDBContext(); 

        if (username == null || username.trim().isEmpty() ||
            fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) { 
            
            request.setAttribute("error", "Username, Full Name, Email, and Password are required.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return; // Dừng lại nếu lỗi
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        if (userDAO.isUsernameExists(username)) {
            request.setAttribute("error", "Username is already taken.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        if (userDAO.isEmailExists(email)) {
            request.setAttribute("error", "This email is already registered.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
 
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setFullName(fullName);
        newUser.setEmail(email);
        newUser.setPhone(phone);
        newUser.setAddress(address);
        
        newUser.setPassword(password); 

        boolean success = userDAO.createUser(newUser);
    
        if (success) {
            response.sendRedirect("login.jsp?success=Registration successful! Please sign in.");
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}