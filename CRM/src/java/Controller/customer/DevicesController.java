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
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");

        String keyword = request.getParameter("search");
        String brand = request.getParameter("brand");
        String warranty = request.getParameter("warranty");
        String pageParam = request.getParameter("page");

        int page = (pageParam != null) ? Integer.parseInt(pageParam) : 1;
        int limit = 3;
        int offset = (page - 1) * limit;

        DeviceDAO dao = new DeviceDAO();
        List<Devices> devices = dao.getDevicesByUserId(user.getId(), keyword, brand, warranty, offset, limit);

        int total = dao.countDevicesByUser(user.getId(), keyword, brand, warranty);
        int totalPages = (int) Math.ceil((double) total / limit);

        request.setAttribute("devices", devices);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", keyword);
        request.setAttribute("brand", brand);
        request.setAttribute("warranty", warranty);

        // để JSP có danh sách brand trong filter
        request.setAttribute("brands", dao.getAllBrands());
        request.getRequestDispatcher("/customer/devices.jsp").forward(request, response);
    }
}
