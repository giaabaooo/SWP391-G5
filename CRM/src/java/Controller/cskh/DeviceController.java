package Controller.cskh;

import dal.DeviceDAO;
import data.Device;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

@WebServlet(name = "CskhDeviceController", urlPatterns = {"/cskh/devices"})
public class DeviceController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        DeviceDAO dao = new DeviceDAO();

        String keyword = request.getParameter("keyword");
        String customer = request.getParameter("customer");
        String brand = request.getParameter("brand");
        String category = request.getParameter("category");
        String status = request.getParameter("status");

        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
            page = 1;
        }

        int offset = (page - 1) * PAGE_SIZE;
        int totalItems = dao.countAllDevices(keyword, brand, category, status, customer);
        int totalPages = (int) Math.ceil((double) totalItems / PAGE_SIZE);
        List<Device> deviceList = dao.getAllDevices(keyword, brand, category, status, customer, offset, PAGE_SIZE);

        request.setAttribute("deviceList", deviceList);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("pageSize", PAGE_SIZE);
        request.setAttribute("keywordFilter", keyword);
        request.setAttribute("customerFilter", customer);
        request.setAttribute("brandFilter", brand);
        request.setAttribute("categoryFilter", category);
        request.setAttribute("statusFilter", status);

        request.getRequestDispatcher("/cskh/device_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
