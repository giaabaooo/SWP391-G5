package Controller.warestaff;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dal.ProductDAO;
import dal.CategoryDAO;
import dal.BrandDAO;
import data.Product;
import data.Category;
import data.Brand;

/**
 * Controller for viewing product details
 * @author vttrung
 */
public class ViewProductDetailController extends HttpServlet {
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Get product ID from parameter
            String productIdParam = request.getParameter("id");
            
            if (productIdParam == null || productIdParam.isEmpty()) {
                request.setAttribute("error", "Product ID is required");
                request.getRequestDispatcher("/warehouse/productList.jsp").forward(request, response);
                return;
            }
            
            int productId;
            try {
                productId = Integer.parseInt(productIdParam);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid product ID");
                request.getRequestDispatcher("/warehouse/productList.jsp").forward(request, response);
                return;
            }
            
            // Get product details
            ProductDAO productDAO = new ProductDAO();
            Product product = productDAO.getProductById(productId);
            
            if (product == null) {
                request.setAttribute("error", "Product not found");
                request.getRequestDispatcher("/warehouse/productList.jsp").forward(request, response);
                return;
            }
            
            // Get category and brand details
            CategoryDAO categoryDAO = new CategoryDAO();
            BrandDAO brandDAO = new BrandDAO();
            
            Category category = categoryDAO.getCategoryById(product.getCategoryId());
            Brand brand = null;
            if (product.getBrandId() != null) {
                brand = brandDAO.getBrandById(product.getBrandId());
            }
            
            // Set attributes
            request.setAttribute("product", product);
            request.setAttribute("category", category);
            request.setAttribute("brand", brand);
            
            // Forward to JSP
            request.getRequestDispatcher("/warehouse/productDetail.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error loading product details: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "Unable to load product details. Please try again later.");
            request.getRequestDispatcher("/warehouse/productList.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "View Product Detail Controller";
    }
}

