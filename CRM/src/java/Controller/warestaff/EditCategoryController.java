package Controller.warestaff;

import dal.CategoryDAO;
import data.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Chỉnh sửa thông tin danh mục
 */
public class EditCategoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Bước 1: Đọc ID danh mục từ URL
            String idParam = request.getParameter("id");
            if (idParam == null) {
                response.sendRedirect(request.getContextPath() + "/warestaff/categoryList?error=Missing%20id");
                return;
            }
            int id = Integer.parseInt(idParam);
            CategoryDAO dao = new CategoryDAO();
            // Bước 2: Lấy dữ liệu chi tiết để đổ lên form chỉnh sửa
            Category category = dao.getCategoryById(id);
            if (category == null) {
                response.sendRedirect(request.getContextPath() + "/warestaff/categoryList?error=Not%20found");
                return;
            }
            request.setAttribute("category", category);
            request.getRequestDispatcher("/warehouse/editCategory.jsp").forward(request, response);
        } catch (Exception ex) {
            response.sendRedirect(request.getContextPath() + "/warestaff/categoryList?error=Invalid%20request");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Bước 1: Nhận dữ liệu cập nhật
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            boolean isActive = request.getParameter("is_active") != null;

            // Bước 2: Xác thực tên danh mục
            if (name == null || name.trim().isEmpty()) {
                throw new IllegalArgumentException("Category name is required");
            }

            // Bước 3: Tạo model và gọi DAO cập nhật
            Category category = new Category(id, name.trim(), description != null ? description.trim() : "", isActive);
            CategoryDAO dao = new CategoryDAO();
            // Bước 4: Thông báo kết quả cho người dùng
            boolean ok = dao.updateCategory(category);
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/warestaff/categoryList?success=Category%20updated");
                return;
            }
            request.setAttribute("error", "Failed to update category.");
            request.setAttribute("category", category);
            request.getRequestDispatcher("/warehouse/editCategory.jsp").forward(request, response);
        } catch (IllegalArgumentException ex) {
            request.setAttribute("error", ex.getMessage());
            request.getRequestDispatcher("/warehouse/editCategory.jsp").forward(request, response);
        } catch (Exception ex) {
            request.setAttribute("error", "Unexpected error. Please try again.");
            request.getRequestDispatcher("/warehouse/editCategory.jsp").forward(request, response);
        }
    }
}


