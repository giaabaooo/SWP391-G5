package Controller.customer;

import dal.CustomerRequestDAO;
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("../login");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Lấy param từ request
        String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");
        String searchQuery = request.getParameter("search");
        String brand = request.getParameter("brand");
        String category = request.getParameter("category");
        String status = request.getParameter("status");

        int page = 1;
        int pageSize = 10; // Default page size

        // Parse page number
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // Parse page size
        if (pageSizeParam != null && !pageSizeParam.isEmpty()) {
            try {
                pageSize = Integer.parseInt(pageSizeParam);
                if (pageSize < 1) {
                    pageSize = 10;
                }
                if (pageSize > 100) {
                    pageSize = 100; // Max 100 items per page
                }
            } catch (NumberFormatException e) {
                pageSize = 10;
            }
        }

        int offset = (page - 1) * pageSize;

        List<Device> devices = deviceDAO.getDevicesByUserId(user.getId(), searchQuery, brand, category, status, offset, pageSize);
        int totalDevices = deviceDAO.countDevicesByUser(user.getId(), searchQuery, brand, category, status);
        int totalPages = (int) Math.ceil((double) totalDevices / (double) pageSize);
        if (totalPages == 0) {
            totalPages = 1; // At least 1 page even if no devices
        }

        List<String> brands = deviceDAO.getBrandsByUserId(user.getId());
        List<String> categories = deviceDAO.getCategoriesByUserId(user.getId());
        List<String> statuses = deviceDAO.getStatusesByUserId(user.getId());
        CustomerRequestDAO requestDAO = new CustomerRequestDAO();
        java.util.Set<String> activeRequestKeys = requestDAO.getActiveRequestKeysByUserId(user.getId());
        request.setAttribute("activeRequestKeys", activeRequestKeys);

        request.setAttribute("devices", devices);
        request.setAttribute("brands", brands);
        request.setAttribute("categories", categories);
        request.setAttribute("statuses", statuses);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalDevices", totalDevices);
        request.setAttribute("totalPages", totalPages);

        request.setAttribute("search", searchQuery);
        request.setAttribute("brand", brand);
        request.setAttribute("category", category);
        request.setAttribute("status", status);

        request.getRequestDispatcher("/customer/devices.jsp").forward(request, response);
    }
}
