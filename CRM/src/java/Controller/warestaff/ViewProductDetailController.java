package Controller.warestaff;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dal.ProductDAO;
import dal.CategoryDAO;
import dal.BrandDAO;
import dal.ProductSerialDAO;
import data.Product;
import data.Category;
import data.Brand;
import data.ProductSerial;
import java.util.List;

/**
 * Hiển thị chi tiết sản phẩm và danh sách serial đang quản lý
 */
public class ViewProductDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Bước 1: Nhận ID sản phẩm từ request và kiểm tra hợp lệ
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

            int page = 1;
            int pageSize = 10;
            if (request.getParameter("page") != null) {
                try {
                    page = Integer.parseInt(request.getParameter("page"));
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            // Bước 2: Lấy thông tin sản phẩm, danh mục, thương hiệu và serial
            ProductDAO productDAO = null;
            CategoryDAO categoryDAO = null;
            BrandDAO brandDAO = null;
            ProductSerialDAO serialDAO = null;
            try {
                productDAO = new ProductDAO();
                categoryDAO = new CategoryDAO();
                brandDAO = new BrandDAO();
                serialDAO = new ProductSerialDAO();

                Product product = productDAO.getProductById(productId);

                if (product == null) {
                    request.setAttribute("error", "Product not found");
                    request.getRequestDispatcher("/warehouse/productList.jsp").forward(request, response);
                    return;
                }

                // Get category and brand details
                Category category = categoryDAO.getCategoryById(product.getCategoryId());
                Brand brand = null;
                if (product.getBrandId() != null) {
                    brand = brandDAO.getBrandById(product.getBrandId());
                }

                int totalSerials = serialDAO.getTotalSerialCountByProductId(productId);
                int totalPages = (int) Math.ceil((double) totalSerials / pageSize);
                List<ProductSerial> serials = serialDAO.getSerialsByProductId(productId, page, pageSize);

                // Bước 3: Đặt attribute để JSP hiển thị thông tin chi tiết + phân trang serial
                request.setAttribute("product", product);
                request.setAttribute("category", category);
                request.setAttribute("brand", brand);
                request.setAttribute("serials", serials);
                request.setAttribute("page", page);
                request.setAttribute("pageSize", pageSize);
                request.setAttribute("totalItems", totalSerials);
                request.setAttribute("totalPages", totalPages);
            } finally {
                if (productDAO != null) {
                    productDAO.close();
                }
                if (categoryDAO != null) {
                    categoryDAO.close();
                }
                if (brandDAO != null) {
                    brandDAO.close();
                }
                if (serialDAO != null) {
                    serialDAO.close();
                }
            }

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
