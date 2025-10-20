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
        String keyword = request.getParameter("keyword");
        String type = request.getParameter("type");
        String status = request.getParameter("status");
        String pageParam = request.getParameter("page");

        // Phân trang
        int page = 1;
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int offset = (page - 1) * LIMIT;

        List<CustomerRequest> list = CustomerRequestDAO.getRequestsByUserId(user.getId(), keyword, type, status, offset, LIMIT);
        List<String> requestTypes = List.of("WARRANTY", "REPAIR", "MAINTENANCE");
        List<String> statuses = List.of("PENDING", "SCHEDULED", "COMPLETED", "OVERDUE");

        request.setAttribute("types", requestTypes);
        request.setAttribute("statuses", statuses);

        request.setAttribute("list", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("keyword", keyword);
        request.setAttribute("type", type);
        request.setAttribute("status", status);

        request.getRequestDispatcher("/customer/listRequest.jsp").forward(request, response);
    }

}
