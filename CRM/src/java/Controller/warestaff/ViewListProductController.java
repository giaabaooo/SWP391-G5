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
import dal.InventoryDAO;
import data.Product;
import data.Category;
import data.Brand;
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;

/**
 * Trang danh sách sản phẩm với lọc, tìm kiếm, phân trang và lượng tồn
 */
public class ViewListProductController extends HttpServlet {
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            ProductDAO productDAO = new ProductDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            BrandDAO brandDAO = new BrandDAO();
            
            // Bước 1: Nhận các tham số phân trang, lọc và tìm kiếm từ request
            String pageParam = request.getParameter("page");
            String pageSizeParam = request.getParameter("pageSize");
            String searchQuery = request.getParameter("search");
            String categoryParam = request.getParameter("categoryId");
            String brandParam = request.getParameter("brandId");
            String statusParam = request.getParameter("status");

            int page = 1;
            int pageSize = 10; // Default page size
            Integer categoryId = null;
            Integer brandId = null;
            Integer status = null;
            
            // Chuẩn hóa số trang
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            
            // Chuẩn hóa kích thước trang
            if (pageSizeParam != null && !pageSizeParam.isEmpty()) {
                try {
                    pageSize = Integer.parseInt(pageSizeParam);
                    if (pageSize < 1) pageSize = 10;
                    if (pageSize > 100) pageSize = 100; // Max 100 items per page
                } catch (NumberFormatException e) {
                    pageSize = 10;
                }
            }
            
            // Chuyển đổi filter danh mục/ thương hiệu sang dạng số
            if (categoryParam != null && !categoryParam.isEmpty() && !categoryParam.equals("0")) {
                try {
                    categoryId = Integer.parseInt(categoryParam);
                } catch (NumberFormatException e) {
                    categoryId = null;
                }
            }
            
            if (brandParam != null && !brandParam.isEmpty() && !brandParam.equals("0")) {
                try {
                    brandId = Integer.parseInt(brandParam);
                } catch (NumberFormatException e) {
                    brandId = null;
                }
            }

            // Chỉ nhận trạng thái 0 (ẩn) hoặc 1 (hiển thị)
            if (statusParam != null && !statusParam.isEmpty()) {
                try {
                    status = Integer.parseInt(statusParam);
                    if (status != 0 && status != 1) {
                        status = null; // Only accept 0 or 1
                    }
                } catch (NumberFormatException e) {
                    status = null;
                }
            }

            // Bước 2: Lấy danh sách sản phẩm theo các điều kiện đã chuẩn hóa
            List<Product> products;
            int totalProducts;

            products = productDAO.getProductsWithFilters(page, pageSize, searchQuery, categoryId, brandId, status);
            totalProducts = productDAO.getTotalProductsWithFilters(searchQuery, categoryId, brandId, status);
            
            // Tính tổng số trang để phục vụ phân trang trên giao diện
            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
            
            // Bước 3: Lấy danh mục/ thương hiệu để hiển thị filter drop-down
            List<Category> categories = categoryDAO.getAllCategories();
            List<Brand> brands = brandDAO.getAllBrands();
            
            // Dùng map để dễ hiển thị tên từ id
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
            request.setAttribute("selectedStatus", statusParam);

            // Bước 4: Tính lượng tồn kho hiện tại của từng sản phẩm trong trang
            Map<Integer, Integer> inventoryMap = new HashMap<>();
            if (products != null && !products.isEmpty()) {
                InventoryDAO inventoryDAO = new InventoryDAO();
                ArrayList<Integer> productIds = new ArrayList<>();
                for (Product p : products) {
                    productIds.add(p.getId());
                }
                inventoryMap = inventoryDAO.getQuantitiesByProductIds(productIds);
            }
            request.setAttribute("inventoryMap", inventoryMap);
            
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