//package Controller.customer;
//
//import dal.DeviceDAO;
//import data.Device;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//
//import java.io.IOException;
//
//
//public class DetailDeviceController extends HttpServlet {
//    private DeviceDAO deviceDAO = new DeviceDAO();
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
//            throws ServletException, IOException {
//        String deviceIdStr = request.getParameter("deviceId");
//        if (deviceIdStr != null) {
//            try {
//                int deviceId = Integer.parseInt(deviceIdStr.trim());
//                Device device = deviceDAO.getDeviceById(deviceId);
//                if (device != null) {
//                    request.setAttribute("device", device);
//                    request.getRequestDispatcher("/customer/detailDevice.jsp").forward(request, response);
//                    return;
//                }
//            } catch (NumberFormatException e) {
//                e.printStackTrace();
//            }
//        }
//        // Nếu deviceId null hoặc không tìm thấy
//        response.sendRedirect(request.getContextPath() + "/customer/devices");
//    }
//}
