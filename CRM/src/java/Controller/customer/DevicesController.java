package Controller.customer;

import dal.DeviceDAO;
import data.Device;
import data.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;


public class DevicesController extends HttpServlet {

    private DeviceDAO deviceDAO = new DeviceDAO();
    private final int LIMIT = 10; // số items 1 trang

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Lấy param từ request
        String pageParam = request.getParameter("page");
        String searchQuery = request.getParameter("search");
        String brand = request.getParameter("brand");
        String category = request.getParameter("category");
        String status = request.getParameter("status");

        int page = 1;
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        int offset = (page - 1) * LIMIT;

        // Lấy danh sách devices theo filter và pagination
        List<Device> devices = deviceDAO.getDevicesByUserId(user.getId(), searchQuery, brand, category, status, offset, LIMIT);
        int totalDevices = deviceDAO.countDevicesByUser(user.getId(), searchQuery, brand, category, status);
        int totalPages = (int) Math.ceil((double) totalDevices / LIMIT);

        // Lấy danh sách dropdown filter
        List<String> brands = deviceDAO.getBrandsByUserId(user.getId());
        List<String> categories = deviceDAO.getCategoriesByUserId(user.getId());
        List<String> statuses = deviceDAO.getStatusesByUserId(user.getId());

        // Đưa dữ liệu xuống JSP
        request.setAttribute("devices", devices);
        request.setAttribute("brands", brands);
        request.setAttribute("categories", categories);
        request.setAttribute("statuses", statuses);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.setAttribute("search", searchQuery);
        request.setAttribute("brand", brand);
        request.setAttribute("category", category);
        request.setAttribute("status", status);

        request.getRequestDispatcher("/customer/devices.jsp").forward(request, response);
    }
}
