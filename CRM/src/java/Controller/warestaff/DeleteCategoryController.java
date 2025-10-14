package Controller.warestaff;

import dal.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Delete or deactivate category
 */
public class DeleteCategoryController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String mode = request.getParameter("mode"); // soft|hard
            CategoryDAO dao = new CategoryDAO();
            boolean ok;
            if ("hard".equalsIgnoreCase(mode)) {
                ok = dao.deleteCategory(id);
            } else {
                ok = dao.deactivateCategory(id);
            }
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/warestaff/categoryList?success=Category%20removed");
            } else {
                response.sendRedirect(request.getContextPath() + "/warestaff/categoryList?error=Delete%20failed");
            }
        } catch (Exception ex) {
            response.sendRedirect(request.getContextPath() + "/warestaff/categoryList?error=Invalid%20request");
        }
    }
}


