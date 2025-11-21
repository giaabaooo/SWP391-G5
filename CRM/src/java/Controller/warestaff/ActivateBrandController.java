package Controller.warestaff;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dal.BrandDAO;

/**
 * Bộ điều khiển dùng để kích hoạt lại thương hiệu trong kho
 */
public class ActivateBrandController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Bước 1: Lấy ID thương hiệu từ form để biết bản ghi cần bật lại
            int id = Integer.parseInt(request.getParameter("id"));
            BrandDAO dao = new BrandDAO();
            // Bước 2: Gọi DAO để cập nhật trạng thái hoạt động
            boolean ok = dao.activateBrand(id);
            // Bước 3: Điều hướng về danh sách kèm thông báo thành công/thất bại
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/warestaff/brandList?success=Brand%20activated");
            } else {
                response.sendRedirect(request.getContextPath() + "/warestaff/brandList?error=Activation%20failed");
            }
        } catch (Exception ex) {
            response.sendRedirect(request.getContextPath() + "/warestaff/brandList?error=Invalid%20request");
        }
    }
}

