package Controller.warestaff;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dal.ProductDAO;

/**
 * Controller for deleting products
 * @author vttrung
 */
public class DeleteProductController extends HttpServlet {
   
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
            
            // Deactivate product (soft delete) instead of hard delete to preserve referential integrity
            ProductDAO productDAO = new ProductDAO();
            boolean isDeleted = productDAO.deactivateProduct(productId);
            
            if (isDeleted) {
                response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?success=Product deleted successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?error=Failed to delete product");
            }
            
        } catch (Exception e) {
            System.err.println("Error deleting product: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?error=An error occurred while deleting the product");
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
        return "Delete Product Controller";
    }
}

