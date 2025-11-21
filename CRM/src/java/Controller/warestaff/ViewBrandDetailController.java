package Controller.warestaff;

import dal.BrandDAO;
import dal.ProductDAO;
import data.Brand;
import data.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Xem thông tin chi tiết của thương hiệu cùng danh sách sản phẩm liên quan
 */
public class ViewBrandDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Bước 1: Đọc và kiểm tra ID thương hiệu từ query string
            String idParam = request.getParameter("id");
            if (idParam == null) {
                response.sendRedirect(request.getContextPath() + "/warestaff/brandList?error=Missing%20brand%20id");
                return;
            }

            int brandId;
            try {
                brandId = Integer.parseInt(idParam);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/warestaff/brandList?error=Invalid%20brand%20id");
                return;
            }

            BrandDAO brandDAO = new BrandDAO();
            Brand brand = brandDAO.getBrandById(brandId);
            if (brand == null) {
                response.sendRedirect(request.getContextPath() + "/warestaff/brandList?error=Brand%20not%20found");
                return;
            }

            // Bước 2: Lấy danh sách sản phẩm thuộc thương hiệu này
            ProductDAO productDAO = new ProductDAO();
            java.util.List<Product> products = productDAO.getProductsByBrand(brandId);

            // Bước 3: Gắn dữ liệu để JSP hiển thị chi tiết
            request.setAttribute("brand", brand);
            request.setAttribute("products", products);
            request.getRequestDispatcher("/warehouse/brandDetail.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/warestaff/brandList?error=An%20error%20occurred%20while%20loading%20brand%20details");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doGet(request, response);
    }
}


