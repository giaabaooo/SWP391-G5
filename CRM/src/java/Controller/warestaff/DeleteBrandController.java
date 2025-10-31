package Controller.warestaff;

import dal.BrandDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Delete or deactivate brand
 */
public class DeleteBrandController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String mode = request.getParameter("mode"); // soft|hard
            BrandDAO dao = new BrandDAO();
            boolean ok;
            if ("hard".equalsIgnoreCase(mode)) {
                ok = dao.deleteBrand(id);
            } else {
                ok = dao.deactivateBrand(id);
            }
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/warestaff/brandList?success=Brand%20removed");
            } else {
                response.sendRedirect(request.getContextPath() + "/warestaff/brandList?error=Delete%20failed");
            }
        } catch (Exception ex) {
            response.sendRedirect(request.getContextPath() + "/warestaff/brandList?error=Invalid%20request");
        }
    }
}


