package Controller.customer;

import dal.DeviceDAO;
import data.Devices;
import data.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class DevicesController extends HttpServlet {

    private DeviceDAO deviceDAO = new DeviceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            // Chưa login thì redirect ra login
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Lấy danh sách device của user từ DB
        List<Devices> devices = deviceDAO.getDevicesByUserId(user.getId());

        // Gửi sang JSP
        request.setAttribute("devices", devices);
        request.getRequestDispatcher("/customer/devices.jsp").forward(request, response);
    }
}
