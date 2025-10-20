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
            
            // Get pagination parameters
            String pageParam = request.getParameter("page");
            String pageSizeParam = request.getParameter("pageSize");
            String searchQuery = request.getParameter("search");
            String categoryParam = request.getParameter("categoryId");
            String brandParam = request.getParameter("brandId");
            
            int page = 1;
            int pageSize = 10; // Default page size
            Integer categoryId = null;
            Integer brandId = null;
            
            // Parse page number
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            
            // Parse page size
            if (pageSizeParam != null && !pageSizeParam.isEmpty()) {
                try {
                    pageSize = Integer.parseInt(pageSizeParam);
                    if (pageSize < 1) pageSize = 10;
                    if (pageSize > 100) pageSize = 100; // Max 100 items per page
                } catch (NumberFormatException e) {
                    pageSize = 10;
                }
            }
            
            // Parse category ID
            if (categoryParam != null && !categoryParam.isEmpty() && !categoryParam.equals("0")) {
                try {
                    categoryId = Integer.parseInt(categoryParam);
                } catch (NumberFormatException e) {
                    categoryId = null;
                }
            }
            
            // Parse brand ID
            if (brandParam != null && !brandParam.isEmpty() && !brandParam.equals("0")) {
                try {
                    brandId = Integer.parseInt(brandParam);
                } catch (NumberFormatException e) {
                    brandId = null;
                }
            }
            
            // Get products with filters
            List<Product> products;
            int totalProducts;
            
            // Use the new filter method
            products = productDAO.getProductsWithFilters(page, pageSize, searchQuery, categoryId, brandId);
            totalProducts = productDAO.getTotalProductsWithFilters(searchQuery, categoryId, brandId);
            
            // Calculate total pages
            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
            
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
            request.setAttribute("categories", categories);
            request.setAttribute("brands", brands);
            request.setAttribute("categoryMap", categoryMap);
            request.setAttribute("brandMap", brandMap);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("searchQuery", searchQuery);
            request.setAttribute("selectedCategoryId", categoryId);
            request.setAttribute("selectedBrandId", brandId);
            
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