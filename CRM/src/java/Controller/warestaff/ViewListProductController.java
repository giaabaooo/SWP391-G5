package Controller.warestaff;

import java.io.IOException;
import java.util.List;
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
import java.util.HashMap;
import java.util.Map;

/**
 * Controller for viewing list of products
 * @author vttrung
 */
public class ViewListProductController extends HttpServlet {
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            ProductDAO productDAO = new ProductDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            BrandDAO brandDAO = new BrandDAO();
            
            // Get all products
            List<Product> products = productDAO.getAllProducts();
            
            // Get all categories and brands for mapping
            List<Category> categories = categoryDAO.getAllCategories();
            List<Brand> brands = brandDAO.getAllBrands();
            
            // Create maps for easy lookup
            Map<Integer, String> categoryMap = new HashMap<>();
            for (Category c : categories) {
                categoryMap.put(c.getId(), c.getName());
            }
            
            Map<Integer, String> brandMap = new HashMap<>();
            for (Brand b : brands) {
                brandMap.put(b.getId(), b.getName());
            }
            
            // Set attributes
            request.setAttribute("products", products);
            request.setAttribute("categoryMap", categoryMap);
            request.setAttribute("brandMap", brandMap);
            
            // Forward to JSP
            request.getRequestDispatcher("/warehouse/productList.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error loading inventory: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "Unable to load product list. Please try again later.");
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
        return "View List Product Controller";
    }
}

