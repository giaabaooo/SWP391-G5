package Controller.warestaff;

import dal.CategoryDAO;
import dal.ProductDAO;
import data.Category;
import data.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * View category details including products in this category
 */
public class ViewCategoryDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            String idParam = request.getParameter("id");
            if (idParam == null) {
                response.sendRedirect(request.getContextPath() + "/warestaff/categoryList?error=Missing%20category%20id");
                return;
            }
            
            int categoryId;
            try {
                categoryId = Integer.parseInt(idParam);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/warestaff/categoryList?error=Invalid%20category%20id");
                return;
            }
            
            CategoryDAO categoryDAO = new CategoryDAO();
            ProductDAO productDAO = new ProductDAO();
            
            // Get category details
            Category category = categoryDAO.getCategoryById(categoryId);
            if (category == null) {
                response.sendRedirect(request.getContextPath() + "/warestaff/categoryList?error=Category%20not%20found");
                return;
            }
            
            // Get products in this category
            List<Product> products = productDAO.getProductsByCategoryId(categoryId);
            
            // Get total count of products in this category
            int totalProducts = productDAO.getTotalProductsByCategoryId(categoryId);
            
            // Get active products count
            int activeProducts = productDAO.getActiveProductsByCategoryId(categoryId);
            
            // Get inventory statistics
            int[] inventoryStats = productDAO.getInventoryStatsByCategoryId(categoryId);
            
            // Get contract statistics
            Object[] contractStats = productDAO.getContractStatsByCategoryId(categoryId);
            
            // Get device statistics
            int[] deviceStats = productDAO.getDeviceStatsByCategoryId(categoryId);
            
            request.setAttribute("category", category);
            request.setAttribute("products", products);
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("activeProducts", activeProducts);
            request.setAttribute("inventoryStats", inventoryStats);
            request.setAttribute("contractStats", contractStats);
            request.setAttribute("deviceStats", deviceStats);
            
            request.getRequestDispatcher("/warehouse/categoryDetail.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error loading category details: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/warestaff/categoryList?error=An%20error%20occurred%20while%20loading%20category%20details");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doGet(request, response);
    }
}
