package Controller.Admin;

import dal.UserDBContext;
import data.Permission;
import data.Role;
import data.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

@WebServlet("/admin/user-permissions")
public class UserPermissionController extends HttpServlet {
    
    private UserDBContext userDb = new UserDBContext();

@Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        try {
            String searchKeyword = req.getParameter("search");
            String filterRoleId = req.getParameter("filter_role_id");
            String userIdParam = req.getParameter("user_id");

            ArrayList<Role> allRoles = userDb.getAllRoles();
            ArrayList<User> filteredUsers = userDb.getFilteredActiveUsers(searchKeyword, filterRoleId);
            ArrayList<Permission> allPermissions = userDb.getAllPermissions();

            allRoles.removeIf(role -> role.getName().equalsIgnoreCase("ADMIN"));
            filteredUsers.removeIf(user -> user.getRole().getName().equalsIgnoreCase("ADMIN"));
            req.setAttribute("allRoles", allRoles);
            req.setAttribute("allUsers", filteredUsers);
            req.setAttribute("allPermissions", allPermissions);

            req.setAttribute("searchKeyword", searchKeyword);
            req.setAttribute("filterRoleId", filterRoleId);

            if (userIdParam != null && !userIdParam.isEmpty()) {
                int selectedUserId = Integer.parseInt(userIdParam);
                
                Map<Integer, Boolean> userOverrides = userDb.getUserOverrides(selectedUserId);
                User selectedUser = userDb.get(selectedUserId); 

                req.setAttribute("selectedUserId", selectedUserId);
                req.setAttribute("selectedUser", selectedUser);
                req.setAttribute("userOverrides", userOverrides);
            }
            
            if ("true".equals(req.getParameter("success"))) {
                req.setAttribute("successMessage", "User overrides updated successfully!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Error loading data: " + e.getMessage());
        }
        
        req.getRequestDispatcher("/admin/user_permission_management.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        String userIdParam = req.getParameter("user_id");
        
        if (userIdParam == null || userIdParam.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/user-permissions?error=true");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdParam);
            
            User userToEdit = userDb.get(userId);
            if (userToEdit != null && userToEdit.getRole().getName().equalsIgnoreCase("ADMIN")) {
                throw new Exception("Cannot modify permission overrides for an Admin user.");
            }
            
            Map<Integer, Boolean> newOverrides = new HashMap<>();

            for (String paramName : req.getParameterMap().keySet()) {
                if (paramName.startsWith("perm_")) {
                    String permIdStr = paramName.substring(5);
                    String permValue = req.getParameter(paramName);
                    
                    try {
                        int permissionId = Integer.parseInt(permIdStr);
                        
                        if ("grant".equals(permValue)) {
                            newOverrides.put(permissionId, true);
                        } else if ("deny".equals(permValue)) {
                            newOverrides.put(permissionId, false);
                        }
                        
                    } catch (NumberFormatException e) {
                    }
                }
            }

            boolean success = userDb.updateUserOverrides(userId, newOverrides);
            
            if (success) {
                resp.sendRedirect(req.getContextPath() + "/admin/user-permissions?user_id=" + userId + "&success=true");
            } else {
                throw new Exception("Failed to update user overrides in database.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/user-permissions?user_id=" + userIdParam + "&error=true");
        }
    }
}