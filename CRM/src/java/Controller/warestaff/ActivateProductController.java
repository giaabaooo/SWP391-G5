package Controller.warestaff;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dal.ProductDAO;

/**
 * Controller for activating products
 * @author vttrung
 */
public class ActivateProductController extends HttpServlet {
   
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Get product ID from parameter
            String productIdParam = request.getParameter("id");
            
            if (productIdParam == null || productIdParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?error=Product ID is required");
                return;
            }
            
            int productId;
            try {
                productId = Integer.parseInt(productIdParam);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?error=Invalid product ID");
                return;
            }
            
            // Activate product
            ProductDAO productDAO = new ProductDAO();
            boolean isActivated = productDAO.activateProduct(productId);
            
            if (isActivated) {
                response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?success=Product activated successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?error=Failed to activate product");
            }
            
        } catch (Exception e) {
            System.err.println("Error activating product: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?error=An error occurred while activating the product");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Redirect GET requests to POST
        doPost(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Activate Product Controller";
    }
}

