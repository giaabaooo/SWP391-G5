package Controller.warestaff;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dal.CategoryDAO;

/**
 * Servlet giúp bật lại danh mục đang bị vô hiệu hóa
 */
public class ActivateCategoryController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Bước 1: Lấy ID danh mục do nhân viên chọn ở form
            int id = Integer.parseInt(request.getParameter("id"));
            CategoryDAO dao = new CategoryDAO();
            // Bước 2: Gọi DAO để cập nhật trạng thái active
            boolean ok = dao.activateCategory(id);
            // Bước 3: Điều hướng về danh sách kèm thông báo phù hợp
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/warestaff/categoryList?success=Category%20activated");
            } else {
                response.sendRedirect(request.getContextPath() + "/warestaff/categoryList?error=Activation%20failed");
            }
        } catch (Exception ex) {
            response.sendRedirect(request.getContextPath() + "/warestaff/categoryList?error=Invalid%20request");
        }
    }
}

