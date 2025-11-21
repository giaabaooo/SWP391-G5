package Controller.warestaff;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dal.ProductDAO;

/**
 * Servlet vô hiệu hóa sản phẩm (xóa mềm) để giữ toàn vẹn dữ liệu
 */
public class DeleteProductController extends HttpServlet {
   
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Bước 1: Lấy ID sản phẩm từ form và kiểm tra tính hợp lệ
            String productIdParam = request.getParameter("id");
            
            if (productIdParam == null || productIdParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?error=Product ID is required");
                return;
            }
            
            int productId;
            try {
                productId = Integer.parseInt(productIdParam);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?error=Invalid product ID");
                return;
            }
            
            // Bước 2: Xóa mềm sản phẩm để đảm bảo dữ liệu liên quan không bị mất
            ProductDAO productDAO = new ProductDAO();
            boolean isDeleted = productDAO.deactivateProduct(productId);

            // Bước 3: Điều hướng với thông báo tương ứng
            if (isDeleted) {
                response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?success=Product deactivated successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?error=Failed to deactivate product");
            }
            
        } catch (Exception e) {
            System.err.println("Error deactivating product: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?error=An error occurred while deactivating the product");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Nghiệp vụ chỉ cho phép POST nên GET sẽ tái sử dụng logic của doPost
        doPost(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Delete Product Controller";
    }
}

