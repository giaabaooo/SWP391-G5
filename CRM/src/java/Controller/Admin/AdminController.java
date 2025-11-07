/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.Admin;

import dal.UserDBContext;
import data.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.Validation;

/**
 *
 * @author admin
 */
@WebServlet("/admin/user")
public class AdminController extends HttpServlet {

    UserDBContext userDb = new UserDBContext();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {

            case "add":
                String error = req.getParameter("error");

                if (null != error) {
                    switch (error) {
                        case "empty" ->
                            req.setAttribute("error", "All fields must be filled in and must not be spaces.");
                        case "addressEmpty" ->
                            req.setAttribute("error", "All address fields (Province, District, Ward, Street) are required.");
                        case "usernameTooLong" ->
                            req.setAttribute("error", "Username must be between 4 and 30 character");
                        case "fullNameTooLong" ->
                            req.setAttribute("error", "FullName must be between 4 and 30 character");
                        case "addressTooLong" ->
                            req.setAttribute("error", "Address must be between 5 and 255 character");
                        case "invalidEmail" ->
                            req.setAttribute("error", "Invalid email format.");
                        case "invalidPhone" ->
                            req.setAttribute("error", "Invalid Vietnamese phone format. Use 0..., 84..., or +84...");
                        case "usernameContain" ->
                            req.setAttribute("error", "Username is contain");
                        case "emailContain" ->
                            req.setAttribute("error", "Email is contain");
                        default -> {
                        }
                    }
                }

                req.setAttribute("roleList", userDb.getAllRoles());
                req.getRequestDispatcher("/admin/add_user.jsp").forward(req, resp);

                break;

            case "edit":
                String id = req.getParameter("id");
                String errorE = req.getParameter("error");

                if (null != errorE) {
                    switch (errorE) {
                        case "empty" ->
                            req.setAttribute("error", "All fields must be filled in and must not be spaces.");
                        case "addressEmpty" ->
                            req.setAttribute("error", "All address fields (Province, District, Ward, Street) are required.");
                        case "usernameTooLong" ->
                            req.setAttribute("error", "Username must be between 4 and 30 character");
                        case "fullNameTooLong" ->
                            req.setAttribute("error", "FullName must be between 4 and 30 character");
                        case "addressTooLong" ->
                            req.setAttribute("error", "Address must be between 5 and 255 character");
                        case "invalidEmail" ->
                            req.setAttribute("error", "Invalid email format.");
                        case "invalidPhone" ->
                            req.setAttribute("error", "Invalid Vietnamese phone format. Use 0..., 84..., or +84...");
                        case "usernameContain" ->
                            req.setAttribute("error", "Username is contain");
                        case "emailContain" ->
                            req.setAttribute("error", "Email is contain");
                        default -> {
                        }
                    }
                }

                User user = userDb.get(Integer.parseInt(id));

                if (user.getAddress() != null && !user.getAddress().trim().isEmpty()) {
                    String[] parts = user.getAddress().split(",", 2);
                    req.setAttribute("streetDetail", parts[0].trim());
                } else {
                    req.setAttribute("streetDetail", "");
                }

                req.setAttribute("roleList", userDb.getAllRoles());
                req.setAttribute("user", userDb.get(Integer.parseInt(id)));
                req.getRequestDispatcher("/admin/edit_user.jsp").forward(req, resp);

                break;

            case "delete":
                String idD = req.getParameter("id");

                userDb.toggleCustomerStatus(Integer.parseInt(idD));
                resp.sendRedirect(req.getContextPath() + "/admin/user");
                break;
            case "list":
            default:
                int page = req.getParameter("page") == null ? 1 : Integer.parseInt(req.getParameter("page"));
                int size = req.getParameter("pageSize") == null ? 10 : Integer.parseInt(req.getParameter("pageSize"));

                String keyword = req.getParameter("keyword");
                String role = req.getParameter("role");

                var re = userDb.list(1, Integer.MAX_VALUE, "", "", "active");
                int totalPages = (int) Math.ceil((double) re.size() / size);

                req.setAttribute("users", userDb.list(page, size, keyword, role, "active"));
                req.setAttribute("totalProducts", re.size());
                req.setAttribute("page", page);
                req.setAttribute("pageSize", size);
                req.setAttribute("totalPages", totalPages);

                req.getRequestDispatcher("/admin/user_list.jsp").forward(req, resp);

        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "add":
                String username = req.getParameter("username");
                String roleId = req.getParameter("roleId");
                String fullName = req.getParameter("fullName");
                String email = req.getParameter("email");
                String phone = req.getParameter("phone");
                String street = req.getParameter("street");
                String ward = req.getParameter("wardName");
                String district = req.getParameter("districtName");
                String province = req.getParameter("provinceName");

                if (username == null || username.trim().isEmpty()
                        || fullName == null || fullName.trim().isEmpty()
                        || email == null || email.trim().isEmpty()
                        || phone == null || phone.trim().isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/admin/user?action=add" + "&error=empty");
                    return;
                }

                if (street == null || street.trim().isEmpty()
                        || ward == null || ward.trim().isEmpty()
                        || district == null || district.trim().isEmpty()
                        || province == null || province.trim().isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/admin/user?action=add" + "&error=addressEmpty");
                    return;
                }

                if (username.length() < 4 || username.length() > 30) {
                    resp.sendRedirect(req.getContextPath() + "/admin/user?action=add" + "&error=usernameTooLong");
                    return;
                }
                if (fullName.length() < 4 || fullName.length() > 30) {
                    resp.sendRedirect(req.getContextPath() + "/admin/user?action=add" + "&error=fullNameTooLong");
                    return;
                }

                if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
                    resp.sendRedirect(req.getContextPath() + "/admin/user?action=add" + "&error=invalidEmail");
                    return;
                }

                if (!Validation.checkPhoneNum(phone.trim())) {
                    resp.sendRedirect(req.getContextPath() + "/admin/user?action=add" + "&error=invalidPhone");
                    return;
                }

                for (var a : userDb.list(1, Integer.MAX_VALUE, "", "", "")) {
                    if (a.getUsername().equals(username)) {
                        resp.sendRedirect(req.getContextPath() + "/admin/user?action=add" + "&error=usernameContain");
                        return;
                    } else if (a.getEmail().equals(email)) {
                        resp.sendRedirect(req.getContextPath() + "/admin/user?action=add" + "&error=emailContain");
                        return;
                    }
                }

                String randomPassword = userDb.generateRandomPassword(10);
                String hashedPassword = userDb.hashPassword(randomPassword);

                try {
                    User newUser = new User();
                    newUser.setUsername(username);
                    newUser.setFullName(fullName);
                    newUser.setEmail(email);

                    String normalizedPhone = Validation.normalizeVietnamesePhone(phone.trim());
                    String fullAddress = street + ", " + ward + ", " + district + ", " + province;

                    newUser.setPhone(normalizedPhone);
                    newUser.setAddress(fullAddress);
                    newUser.setRole(userDb.getRoleById(Integer.parseInt(roleId)));
                    newUser.setPassword(hashedPassword);
                    newUser.setIsActive(true);

                    userDb.insert(newUser);

                    userDb.sendEmailForNewUser(email, username, randomPassword);

                    resp.sendRedirect(req.getContextPath() + "/admin/user");
                } catch (Exception ex) {
                    ex.printStackTrace();

                }

                break;

            case "edit":
                String idE = req.getParameter("id");
                String usernameE = req.getParameter("username");
                String roleIdE = req.getParameter("roleId");
                String fullNameE = req.getParameter("fullName");
                String emailE = req.getParameter("email");
                String phoneE = req.getParameter("phone");
                String streetE = req.getParameter("street");
                String wardE = req.getParameter("wardName");
                String districtE = req.getParameter("districtName");
                String provinceE = req.getParameter("provinceName");

                if (usernameE == null || usernameE.trim().isEmpty()
                        || fullNameE == null || fullNameE.trim().isEmpty()
                        || emailE == null || emailE.trim().isEmpty()
                        || phoneE == null || phoneE.trim().isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/admin/user?action=edit&id=" + idE + "&error=empty");
                    return;
                }

                if (streetE == null || streetE.trim().isEmpty()
                        || wardE == null || wardE.trim().isEmpty()
                        || districtE == null || districtE.trim().isEmpty()
                        || provinceE == null || provinceE.trim().isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/admin/user?action=edit&id=" + idE + "&error=addressEmpty");
                    return;
                }

                if (usernameE.length() < 4 || usernameE.length() > 30) {
                    resp.sendRedirect(req.getContextPath() + "/admin/user?action=edit&id=" + idE + "&error=usernameTooLong");
                    return;
                }
                if (fullNameE.length() < 4 || fullNameE.length() > 30) {
                    resp.sendRedirect(req.getContextPath() + "/admin/user?action=edit&id=" + idE + "&error=fullNameTooLong");
                    return;
                }

                if (!emailE.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
                    resp.sendRedirect(req.getContextPath() + "/admin/user?action=edit&id=" + idE + "&error=invalidEmail");
                    return;
                }

                if (!Validation.checkPhoneNum(phoneE.trim())) {
                    resp.sendRedirect(req.getContextPath() + "/admin/user?action=edit&id=" + idE + "&error=invalidPhone");
                    return;
                }

                for (var a : userDb.list(1, Integer.MAX_VALUE, "", "", "")) {
                    if (a.getId() != Integer.parseInt(idE)) {
                        if (a.getUsername().equals(usernameE)) {
                            resp.sendRedirect(req.getContextPath() + "/admin/user?action=edit&id=" + idE + "&error=usernameContain");
                            return;
                        } else if (a.getEmail().equals(emailE)) {
                            resp.sendRedirect(req.getContextPath() + "/admin/user?action=edit&id=" + idE + "&error=emailContain");
                            return;
                        }
                    }

                }
                try {
                    User newUser = new User();

                    newUser.setId(Integer.parseInt(idE));
                    newUser.setUsername(usernameE);
                    newUser.setFullName(fullNameE);
                    newUser.setEmail(emailE);

                    String normalizedPhoneE = Validation.normalizeVietnamesePhone(phoneE.trim());
                    String fullAddressE = streetE + ", " + wardE + ", " + districtE + ", " + provinceE;

                    newUser.setPhone(normalizedPhoneE);
                    newUser.setAddress(fullAddressE);
                    newUser.setRole(userDb.getRoleById(Integer.parseInt(roleIdE)));
                    newUser.setIsActive(true);

                    userDb.update(newUser);

                    resp.sendRedirect(req.getContextPath() + "/admin/user");
                } catch (Exception ex) {
                    ex.printStackTrace();

                }

                break;

            default:
        }

    }

}
