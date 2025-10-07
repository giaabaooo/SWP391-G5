package Controller.warestaff;

import java.io.IOException;
import java.math.BigDecimal;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dal.ProductDAO;
import dal.CategoryDAO;
import dal.BrandDAO;
import data.Product;

/**
 * Controller for editing products
 * @author vttrung
 */
public class EditProductController extends HttpServlet {
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
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
            
            // Get product details
            ProductDAO productDAO = new ProductDAO();
            Product product = productDAO.getProductById(productId);
            
            if (product == null) {
                response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?error=Product not found");
                return;
            }
            
            // Get categories and brands for dropdowns
            CategoryDAO categoryDAO = new CategoryDAO();
            BrandDAO brandDAO = new BrandDAO();
            
            request.setAttribute("product", product);
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.setAttribute("brands", brandDAO.getAllBrands());
            
            // Forward to edit page
            request.getRequestDispatcher("/warehouse/editProduct.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error loading product for edit: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?error=An error occurred");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Get product ID
            String productIdParam = request.getParameter("id");
            if (productIdParam == null || productIdParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?error=Product ID is required");
                return;
            }
            
            int productId = Integer.parseInt(productIdParam);
            
            // Get form data
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String purchasePriceStr = request.getParameter("purchase_price");
            String sellingPriceStr = request.getParameter("selling_price");
            String categoryIdStr = request.getParameter("category_id");
            String brandIdStr = request.getParameter("brand_id");
            String imageUrl = request.getParameter("image_url");
            String isActiveStr = request.getParameter("is_active");
            
            // Validate required fields
            if (name == null || name.trim().isEmpty() || 
                purchasePriceStr == null || purchasePriceStr.trim().isEmpty() ||
                categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
                
                request.setAttribute("error", "Please fill in all required fields");
                doGet(request, response);
                return;
            }
            
            // Parse values
            BigDecimal purchasePrice = new BigDecimal(purchasePriceStr);
            BigDecimal sellingPrice = null;
            if (sellingPriceStr != null && !sellingPriceStr.trim().isEmpty()) {
                sellingPrice = new BigDecimal(sellingPriceStr);
            }
            
            int categoryId = Integer.parseInt(categoryIdStr);
            Integer brandId = null;
            if (brandIdStr != null && !brandIdStr.trim().isEmpty()) {
                brandId = Integer.parseInt(brandIdStr);
            }
            
            boolean isActive = (isActiveStr != null && isActiveStr.equals("on"));
            
            // Create Product object
            Product product = new Product(
                productId,
                categoryId,
                brandId,
                imageUrl,
                name,
                description,
                purchasePrice,
                sellingPrice,
                isActive
            );
            
            // Update product
            ProductDAO productDAO = new ProductDAO();
            boolean success = productDAO.updateProduct(product);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?success=Product updated successfully");
            } else {
                request.setAttribute("error", "Failed to update product");
                doGet(request, response);
            }
            
        } catch (NumberFormatException e) {
            System.err.println("Invalid number format: " + e.getMessage());
            request.setAttribute("error", "Invalid number format");
            doGet(request, response);
        } catch (Exception e) {
            System.err.println("Error updating product: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while updating the product");
            doGet(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Edit Product Controller";
    }
}

