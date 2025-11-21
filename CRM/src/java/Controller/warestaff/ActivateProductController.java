package Controller.warestaff;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dal.ProductDAO;

/**
 * Servlet phục hồi trạng thái hoạt động cho sản phẩm bị khóa
 */
public class ActivateProductController extends HttpServlet {
   
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Bước 1: Lấy và kiểm tra ID sản phẩm được gửi từ form
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
            
            // Bước 2: Gọi DAO đổi cờ active cho sản phẩm
            ProductDAO productDAO = new ProductDAO();
            boolean isActivated = productDAO.activateProduct(productId);
            
            // Bước 3: Điều hướng về trang danh sách với thông báo tương ứng
            if (isActivated) {
                response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?success=Product activated successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?error=Failed to activate product");
            }
            
        } catch (Exception e) {
            System.err.println("Error activating product: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?error=An error occurred while activating the product");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Với nghiệp vụ này chỉ cho phép POST, GET sẽ gọi lại doPost để tận dụng chung logic
        doPost(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Activate Product Controller";
    }
}

