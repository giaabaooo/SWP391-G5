package Controller.Admin;

import dal.UserDBContext;
import data.Permission;
import data.Role;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Set;

@WebServlet("/admin/permissions")
public class RolePermissionController extends HttpServlet {

    private UserDBContext userDb = new UserDBContext();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            ArrayList<Role> allRoles = userDb.getAllRoles();
            ArrayList<Permission> allPermissions = userDb.getAllPermissions();

            req.setAttribute("allRoles", allRoles);
            req.setAttribute("allPermissions", allPermissions);

            String roleIdParam = req.getParameter("role_id");
            if (roleIdParam != null && !roleIdParam.isEmpty()) {
                int selectedRoleId = Integer.parseInt(roleIdParam);

                Set<Integer> currentRolePermissions = userDb.getPermissionIdsForRole(selectedRoleId);

                Role selectedRole = allRoles.stream()
                        .filter(r -> r.getId() == selectedRoleId)
                        .findFirst()
                        .orElse(null);

                req.setAttribute("selectedRoleId", selectedRoleId);
                req.setAttribute("selectedRole", selectedRole);
                req.setAttribute("currentRolePermissions", currentRolePermissions);
            }

            // 4. Hiển thị thông báo (nếu có)
            if ("true".equals(req.getParameter("success"))) {
                req.setAttribute("successMessage", "Permissions updated successfully!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Error loading data: " + e.getMessage());
        }

        req.getRequestDispatcher("/admin/permission_management.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String roleIdParam = req.getParameter("role_id");
        String[] permissionIds = req.getParameterValues("permission_id");

        if (roleIdParam == null || roleIdParam.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/permissions?error=true");
            return;
        }

        try {
            int roleId = Integer.parseInt(roleIdParam);

            boolean success = userDb.updatePermissionsForRole(roleId, permissionIds);

            if (success) {
                resp.sendRedirect(req.getContextPath() + "/admin/permissions?role_id=" + roleId + "&success=true");
            } else {
                throw new Exception("Failed to update permissions in database.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/permissions?role_id=" + roleIdParam + "&error=true");
        }
    }
}
