package Controller.warestaff;

import dal.BrandDAO;
import data.Brand;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet phụ trách tạo mới thương hiệu trong kho
 */
public class AddBrandController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Hiển thị form thêm mới thương hiệu
        request.getRequestDispatcher("/warehouse/addBrand.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Bước 1: Nhận dữ liệu người dùng nhập trên form
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            boolean isActive = request.getParameter("is_active") != null;

            // Bước 2: Kiểm tra tên thương hiệu để tránh dữ liệu rỗng
            if (name == null || name.trim().isEmpty()) {
                throw new IllegalArgumentException("Brand name is required");
            }

            // Bước 3: Đóng gói dữ liệu vào đối tượng Brand
            Brand brand = new Brand();
            brand.setName(name.trim());
            brand.setDescription(description != null ? description.trim() : "");
            brand.setActive(isActive);

            // Bước 4: Lưu thương hiệu mới và điều hướng phù hợp
            BrandDAO dao = new BrandDAO();
            int id = dao.addBrand(brand);
            if (id > 0) {
                response.sendRedirect(request.getContextPath() + "/warestaff/brandList?success=Brand%20created");
                return;
            }
            request.setAttribute("error", "Failed to create brand.");
            request.getRequestDispatcher("/warehouse/addBrand.jsp").forward(request, response);
        } catch (IllegalArgumentException ex) {
            request.setAttribute("error", ex.getMessage());
            request.getRequestDispatcher("/warehouse/addBrand.jsp").forward(request, response);
        } catch (Exception ex) {
            request.setAttribute("error", "Unexpected error. Please try again.");
            request.getRequestDispatcher("/warehouse/addBrand.jsp").forward(request, response);
        }
    }
}


