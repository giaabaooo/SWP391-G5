package Controller.warestaff;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dal.BrandDAO;

/**
 * Controller for activating brands
 */
public class ActivateBrandController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            BrandDAO dao = new BrandDAO();
            boolean ok = dao.activateBrand(id);
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/warestaff/brandList?success=Brand%20activated");
            } else {
                response.sendRedirect(request.getContextPath() + "/warestaff/brandList?error=Activation%20failed");
            }
        } catch (Exception ex) {
            response.sendRedirect(request.getContextPath() + "/warestaff/brandList?error=Invalid%20request");
        }
    }
}

