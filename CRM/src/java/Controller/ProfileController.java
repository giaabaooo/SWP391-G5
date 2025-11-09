package Controller;

import dal.UserDBContext;
import data.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import utils.Validation; 

@WebServlet("/user/profile")
public class ProfileController extends HttpServlet {

    private UserDBContext userDAO = new UserDBContext();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User sessionUser = (User) session.getAttribute("user");

        if (sessionUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        User user = userDAO.get(sessionUser.getId());

        if (user.getAddress() != null && !user.getAddress().trim().isEmpty()) {
            String[] parts = user.getAddress().split(",", 2); 
            req.setAttribute("streetDetail", parts[0].trim());
        } else {
            req.setAttribute("streetDetail", "");
        }
        
        req.setAttribute("user", user);

        String action = req.getParameter("action");
        if ("edit".equals(action)) {
            req.getRequestDispatcher("/edit_profile.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/profile.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User sessionUser = (User) session.getAttribute("user");

        if (sessionUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");
        String redirectUrl = req.getContextPath() + "/user/profile?action=edit";

        try {
            if ("updateInfo".equals(action)) {
                String fullName = req.getParameter("fullName");
                String phone = req.getParameter("phone");
                
                String street = req.getParameter("street");
                String ward = req.getParameter("wardName");
                String district = req.getParameter("districtName");
                String province = req.getParameter("provinceName");

                if (fullName == null || fullName.trim().isEmpty() || phone == null || phone.trim().isEmpty()) {
                    req.setAttribute("errorInfo", "Full name and phone must not be empty.");
                } else if (street == null || street.trim().isEmpty() || 
                           ward == null || ward.trim().isEmpty() || 
                           district == null || district.trim().isEmpty() || 
                           province == null || province.trim().isEmpty()) {
                    req.setAttribute("errorInfo", "All address fields (Province, District, Ward, Street) are required.");
                } else if (fullName.length() < 4 || fullName.length() > 30) {
                    req.setAttribute("errorInfo", "Full name must be between 4 and 30 characters.");
                } else if (!Validation.checkPhoneNum(phone.trim())) {
                    req.setAttribute("errorInfo", "Invalid Vietnamese phone format. Use 0..., 84..., or +84...");
                } else {

                    String fullAddress = street + ", " + ward + ", " + district + ", " + province;
                    
                    String normalizedPhone = Validation.normalizeVietnamesePhone(phone.trim());

                    userDAO.updateUserProfile(sessionUser.getId(), fullName, normalizedPhone, fullAddress);
                    
                    sessionUser.setFullName(fullName);
                    sessionUser.setPhone(normalizedPhone);
                    sessionUser.setAddress(fullAddress);
                    session.setAttribute("user", sessionUser);

                    redirectUrl = req.getContextPath() + "/user/profile?message=infoUpdated";
                }

            } else if ("changePass".equals(action)) {
                String currentPass = req.getParameter("currentPassword");
                String newPass = req.getParameter("newPassword");
                String confirmPass = req.getParameter("confirmPassword");

                if (!newPass.equals(confirmPass)) {
                    req.setAttribute("errorPass", "New password and confirmation do not match.");
                } else if (!Validation.checkPassWord(newPass)) { 
                     req.setAttribute("errorPass", "Password not strong. Must be 8+ chars, include uppercase, lowercase, number, and special character.");
                } else {
                    String hashedCurrentPass = userDAO.hashPassword(currentPass);
                    String dbPass = sessionUser.getPassword();

                    if (!hashedCurrentPass.equals(dbPass)) {
                        req.setAttribute("errorPass", "Current password is not correct.");
                    } else {
                        String hashedNewPass = userDAO.hashPassword(newPass);
                        userDAO.changePassword(sessionUser.getId(), hashedNewPass);
                        
                        sessionUser.setPassword(hashedNewPass);
                        session.setAttribute("user", sessionUser);

                        redirectUrl = req.getContextPath() + "/user/profile?message=passUpdated";
                    }
                }
            }
            
            if (redirectUrl.contains("?action=edit")) {
                User user = userDAO.get(sessionUser.getId());

                if (user.getAddress() != null && !user.getAddress().trim().isEmpty()) {
                    String[] parts = user.getAddress().split(",", 2);
                    req.setAttribute("streetDetail", parts[0].trim());
                } else {
                    req.setAttribute("streetDetail", "");
                }
        
                req.setAttribute("user", user);
                req.getRequestDispatcher("/edit_profile.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(redirectUrl);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorInfo", "An error occurred: " + e.getMessage());
            User user = userDAO.get(sessionUser.getId());
            
            if (user.getAddress() != null && !user.getAddress().trim().isEmpty()) {
                String[] parts = user.getAddress().split(",", 2);
                req.setAttribute("streetDetail", parts[0].trim());
            } else {
                req.setAttribute("streetDetail", "");
            }

            req.setAttribute("user", user);
            req.getRequestDispatcher("/edit_profile.jsp").forward(req, resp);
        }
    }
}