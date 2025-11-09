/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.customer;

import dal.CustomerRequestDAO;
import dal.DeviceDAO;
import data.CustomerRequest;
import data.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author admin
 */
public class ListRequestController extends HttpServlet {

    private CustomerRequestDAO CustomerRequestDAO = new CustomerRequestDAO();
    private final int LIMIT = 10; // số items 1 trang
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

        // Lấy param từ URL (nếu có)
        String searchQuery = request.getParameter("search");
        String type = request.getParameter("type");
        String status = request.getParameter("status");
        String pageParam = request.getParameter("page");
        String limitParam = request.getParameter("pageSize");
        
        
        int page = 1;
        int limit = LIMIT;
        try {
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        // Đọc số lượng mỗi trang (pageSize)
        try {
            if (limitParam != null && !limitParam.isEmpty()) {
                limit = Integer.parseInt(limitParam);
            }
        } catch (NumberFormatException e) {
            limit = LIMIT;
        }

        int offset = (page - 1) * limit;

        List<CustomerRequest> list = CustomerRequestDAO.getRequestsByUserId(user.getId(), searchQuery, type, status, offset, limit);
        int totalRequests = CustomerRequestDAO.countRequestsByUserId(user.getId(), searchQuery, type, status);
        int totalPages = (int) Math.ceil((double) totalRequests / (double) limit);
        if (totalPages == 0) {
            totalPages = 1;
        }
        List<String> requestTypes = List.of("WARRANTY", "REPAIR", "MAINTENANCE");
        List<String> statuses = List.of("PENDING", "TRANSFERRED", "ASSIGNED",
                "IN_PROGRESS", "COMPLETED", "AWAITING_PAYMENT", "PAID", "CLOSED", "CANCELLED");

        request.setAttribute("types", requestTypes);
        request.setAttribute("statuses", statuses);
        request.setAttribute("list", list);

        request.setAttribute("status", status);
        request.setAttribute("search", searchQuery);
        request.setAttribute("type", type);

        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRequests", totalRequests);
        request.setAttribute("pageSize", limit);

        request.getRequestDispatcher("/customer/listRequest.jsp").forward(request, response);
    }

}
