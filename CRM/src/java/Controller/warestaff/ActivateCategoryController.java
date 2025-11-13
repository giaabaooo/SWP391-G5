package Controller.warestaff;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dal.CategoryDAO;

/**
 * Controller for activating categories
 */
public class ActivateCategoryController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            CategoryDAO dao = new CategoryDAO();
            boolean ok = dao.activateCategory(id);
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/warestaff/categoryList?success=Category%20activated");
            } else {
                response.sendRedirect(request.getContextPath() + "/warestaff/categoryList?error=Activation%20failed");
            }
        } catch (Exception ex) {
            response.sendRedirect(request.getContextPath() + "/warestaff/categoryList?error=Invalid%20request");
        }
    }
}

