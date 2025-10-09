package Controller.customer;

import dal.DeviceDAO;
import dal.ProductDAO;
import data.Device;
import data.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;


public class DetailDeviceController extends HttpServlet {
    private DeviceDAO deviceDAO = new DeviceDAO();
ProductDAO productDAO = new ProductDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idParam  = request.getParameter("id");
        String productIdParam = request.getParameter("id");
        if (idParam  != null) {
            try {
                int deviceId = Integer.parseInt(idParam .trim());
                int productId = Integer.parseInt(productIdParam);
                Device device = deviceDAO.getDeviceById(deviceId);
                Product product = productDAO.getProductById(productId);
                if (device != null) {
                    request.setAttribute("device", device);
                    request.setAttribute("product", product);
                    request.getRequestDispatcher("/customer/detailDevice.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        // Nếu deviceId null hoặc không tìm thấy
        response.sendRedirect(request.getContextPath() + "/customer/devices");
    }
}
