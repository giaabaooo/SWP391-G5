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
            Set<String> matrix = userDb.getRolePermissionMatrix();

            allRoles.removeIf(role -> role.getName().equalsIgnoreCase("ADMIN"));
            req.setAttribute("allRoles", allRoles);
            req.setAttribute("allPermissions", allPermissions);
            req.setAttribute("matrix", matrix);

            if ("true".equals(req.getParameter("success"))) {
                req.setAttribute("successMessage", "Permissions matrix updated successfully!");
            }
            if ("true".equals(req.getParameter("error"))) {
                req.setAttribute("errorMessage", "Failed to update permissions matrix.");
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

        String[] allCheckedPerms = req.getParameterValues("permission_matrix");

        try {
            boolean success = userDb.updateFullPermissionMatrix(allCheckedPerms);

            if (success) {
                resp.sendRedirect(req.getContextPath() + "/admin/permissions?success=true");
            } else {
                throw new Exception("Failed to update permissions in database.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/permissions?error=true");
        }
    }
}