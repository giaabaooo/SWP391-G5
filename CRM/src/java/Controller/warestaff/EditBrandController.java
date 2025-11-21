package Controller.warestaff;

import dal.BrandDAO;
import data.Brand;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Cập nhật thông tin thương hiệu
 */
public class EditBrandController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Bước 1: Lấy ID thương hiệu ở query string
            String idParam = request.getParameter("id");
            if (idParam == null) {
                response.sendRedirect(request.getContextPath() + "/warestaff/brandList?error=Missing%20id");
                return;
            }
            int id = Integer.parseInt(idParam);
            BrandDAO dao = new BrandDAO();
            // Bước 2: Lấy thông tin chi tiết để đổ vào form
            Brand brand = dao.getBrandById(id);
            if (brand == null) {
                response.sendRedirect(request.getContextPath() + "/warestaff/brandList?error=Not%20found");
                return;
            }
            request.setAttribute("brand", brand);
            request.getRequestDispatcher("/warehouse/editBrand.jsp").forward(request, response);
        } catch (Exception ex) {
            response.sendRedirect(request.getContextPath() + "/warestaff/brandList?error=Invalid%20request");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Bước 1: Nhận dữ liệu cập nhật từ form
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            boolean isActive = request.getParameter("is_active") != null;

            // Bước 2: Kiểm tra tên bắt buộc
            if (name == null || name.trim().isEmpty()) {
                throw new IllegalArgumentException("Brand name is required");
            }

            // Bước 3: Tạo đối tượng brand mới với dữ liệu đã chuẩn hóa
            Brand brand = new Brand(id, name.trim(), description != null ? description.trim() : "", isActive);
            BrandDAO dao = new BrandDAO();
            // Bước 4: Gọi DAO cập nhật và phản hồi cho người dùng
            boolean ok = dao.updateBrand(brand);
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/warestaff/brandList?success=Brand%20updated");
                return;
            }
            request.setAttribute("error", "Failed to update brand.");
            request.setAttribute("brand", brand);
            request.getRequestDispatcher("/warehouse/editBrand.jsp").forward(request, response);
        } catch (IllegalArgumentException ex) {
            request.setAttribute("error", ex.getMessage());
            request.getRequestDispatcher("/warehouse/editBrand.jsp").forward(request, response);
        } catch (Exception ex) {
            request.setAttribute("error", "Unexpected error. Please try again.");
            request.getRequestDispatcher("/warehouse/editBrand.jsp").forward(request, response);
        }
    }
}


