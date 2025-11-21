package Controller.warestaff;

import dal.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Vô hiệu hóa hoặc xóa hẳn danh mục sản phẩm
 */
public class DeleteCategoryController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Bước 1: Nhận ID danh mục và chế độ xóa từ form
            int id = Integer.parseInt(request.getParameter("id"));
            String mode = request.getParameter("mode"); // soft|hard
            CategoryDAO dao = new CategoryDAO();
            boolean ok;
            // Bước 2: Thực thi hành động phù hợp với chế độ
            if ("hard".equalsIgnoreCase(mode)) {
                ok = dao.deleteCategory(id);
            } else {
                ok = dao.deactivateCategory(id);
            }
            // Bước 3: Điều hướng về danh sách kèm thông báo
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/warestaff/categoryList?success=Category%20deactivated%20successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/warestaff/categoryList?error=Failed%20to%20deactivate%20category");
            }
        } catch (Exception ex) {
            response.sendRedirect(request.getContextPath() + "/warestaff/categoryList?error=Invalid%20request");
        }
    }
}


