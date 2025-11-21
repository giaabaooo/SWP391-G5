package Controller.warestaff;

import dal.BrandDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Vô hiệu hóa hoặc xóa hẳn thương hiệu
 */
public class DeleteBrandController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Bước 1: Lấy ID thương hiệu và chế độ xóa (mềm/ cứng)
            int id = Integer.parseInt(request.getParameter("id"));
            String mode = request.getParameter("mode"); // soft|hard
            BrandDAO dao = new BrandDAO();
            boolean ok;
            // Bước 2: Tùy theo mode mà gọi DAO tương ứng
            if ("hard".equalsIgnoreCase(mode)) {
                ok = dao.deleteBrand(id);
            } else {
                ok = dao.deactivateBrand(id);
            }
            // Bước 3: Điều hướng về danh sách với thông báo kết quả
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/warestaff/brandList?success=Brand%20deactivated%20successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/warestaff/brandList?error=Failed%20to%20deactivate%20brand");
            }
        } catch (Exception ex) {
            response.sendRedirect(request.getContextPath() + "/warestaff/brandList?error=Invalid%20request");
        }
    }
}


