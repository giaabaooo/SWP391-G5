/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.customer;

import dal.CustomerRequestDAO;
import dal.DeviceDAO;
import data.CustomerRequest;
import data.Device;
import data.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import static java.time.Clock.offset;
import java.util.List;

/**
 *
 * @author admin
 */
public class CreateRequestController extends HttpServlet {
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy user hiện tại từ session
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Lấy danh sách thiết bị của customer
        DeviceDAO deviceDAO = new DeviceDAO();
       List<Device> devices = deviceDAO.getDevicesByUserId(user.getId());

        request.setAttribute("devices", devices);
        request.getRequestDispatcher("/customer/createRequest.jsp").forward(request, response);
    
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {
            User user = (User) request.getSession().getAttribute("user");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            int customerId = user.getId();
            int deviceId = Integer.parseInt(request.getParameter("product_id"));
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String requestType = request.getParameter("request_type");

            CustomerRequest req = new CustomerRequest();
            req.setCustomer_id(customerId);
            req.setDevice_id(deviceId);
            req.setTitle(title);
            req.setDescription(description);
            req.setRequest_type(requestType);
            req.setStatus("Pending"); // mặc định

            CustomerRequestDAO dao = new CustomerRequestDAO();
            boolean success = dao.createRequest(req);

            if (success) {
                request.setAttribute("success", "Request created successfully!");
            } else {
                request.setAttribute("error", "Failed to create request. Please try again.");
            }

            // Load lại danh sách device để hiển thị trên form
            DeviceDAO deviceDAO = new DeviceDAO();
            List<Device> devices = deviceDAO.getDevicesByUserId(user.getId());
            request.setAttribute("devices", devices);

            request.getRequestDispatcher("/customer/createRequest.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/customer/createRequest.jsp").forward(request, response);
        }
    }

}
