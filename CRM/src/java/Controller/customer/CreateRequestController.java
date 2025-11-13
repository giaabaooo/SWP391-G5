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
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;

/**
 *
 * @author admin
 */
public class CreateRequestController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        DeviceDAO deviceDAO = new DeviceDAO();
        List<Device> devices = deviceDAO.getDevicesByUserId(user.getId());
        String deviceIdStr = request.getParameter("deviceId");
        String requestType = request.getParameter("type");

        if (deviceIdStr != null && !deviceIdStr.isEmpty() && requestType != null && !requestType.isEmpty()) {
            try {
                int deviceId = Integer.parseInt(deviceIdStr);
                CustomerRequestDAO dao = new CustomerRequestDAO();
                
                // Kiểm tra xem đã có request nào đang hoạt động cho thiết bị này với loại này chưa
                if (dao.hasActiveRequest(deviceId, requestType)) {
                    // Nếu có, redirect về trang list devices với thông báo lỗi
                    response.sendRedirect(request.getContextPath() + "/customer/devices?error=An active request of type '" + requestType + "' already exists for this device.");
                    return; // Dừng thực thi
                }
                
                // Nếu không, set attribute để pre-select trên form
                // Trang createRequest.jsp đã tự xử lý việc này bằng JS và scriptlet
                
            } catch (NumberFormatException e) {
                // Bỏ qua nếu deviceId không hợp lệ, form sẽ hiển thị bình thường
                System.err.println("Invalid deviceId parameter: " + deviceIdStr);
            }
        }

        request.setAttribute("devices", devices);
        request.getRequestDispatcher("/customer/createRequest.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        try {
            CustomerRequestDAO dao = new CustomerRequestDAO();
            DeviceDAO deviceDAO = new DeviceDAO();
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
            String desiredDateStr = request.getParameter("desired_date");
            String isUrgentStr = request.getParameter("isUrgent");

            CustomerRequest req = new CustomerRequest();
            req.setCustomer_id(customerId);
            req.setDevice_id(deviceId);
            req.setTitle(title);
            req.setDescription(description);
            req.setRequest_type(requestType);
            req.setStatus("PENDING");
            java.util.Date utilDate = null;
            String deviceIdStr = request.getParameter("deviceId");
        

        if (dao.hasActiveRequest(deviceId, requestType)) {
            
                request.setAttribute("error", "An active request of type '" + requestType + "' already exists for this device.");
                List<Device> devices = deviceDAO.getDevicesByUserId(user.getId());
                // Tải lại danh sách thiết bị cho dropdown
                request.setAttribute("devices", devices);
                
                // Forward trở lại form
                request.getRequestDispatcher("/customer/createRequest.jsp").forward(request, response);
                return; // Dừng thực thi
            }

            if (desiredDateStr != null && !desiredDateStr.isEmpty()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    sdf.setLenient(false);
                    utilDate = sdf.parse(desiredDateStr);

                    LocalDate today = LocalDate.now();

                    LocalDate selectedDate = utilDate.toInstant()
                            .atZone(ZoneId.systemDefault())
                            .toLocalDate();

                    if (selectedDate.isBefore(today.plusDays(1))) {
                        List<Device> devices = deviceDAO.getDevicesByUserId(user.getId());
                        request.setAttribute("error", "The desired completion date must be tomorrow or later.");
                        request.setAttribute("devices", devices);
                        request.getRequestDispatcher("/customer/createRequest.jsp").forward(request, response);
                        return;
                    }
                    req.setDesired_completion_date(utilDate);
                } catch (Exception e) {
                    List<Device> devices = deviceDAO.getDevicesByUserId(user.getId());
                    request.setAttribute("error", "Invalid date format.");
                    request.setAttribute("devices", devices);
                    request.getRequestDispatcher("/customer/createRequest.jsp").forward(request, response);
                    return;
                }
            }
            String priority = (isUrgentStr != null && isUrgentStr.equals("true")) ? "URGENT" : "MEDIUM";

            
            int newRequestId = dao.createRequest(req);

            if (newRequestId > 0) {
                if (req.getDesired_completion_date() != null) {
                    dao.insertRequestMeta(newRequestId, req.getDesired_completion_date(), priority);
                }
                response.sendRedirect(request.getContextPath() + "/customer/listRequest?success=Request created successfully!");
                return;
            } else {
                request.setAttribute("error", "Failed to create request. Please try again.");
            }
            int selectedDeviceId = -1;
            String deviceIdParam = request.getParameter("deviceId");
            if (deviceIdParam != null && !deviceIdParam.isEmpty()) {
                try {
                    selectedDeviceId = Integer.parseInt(deviceIdParam);
                } catch (NumberFormatException e) {
                    selectedDeviceId = -1;
                }
            }
            request.setAttribute("selectedDeviceId", selectedDeviceId);
            List<Device> devices = deviceDAO.getDevicesByUserId(user.getId());
            

            request.setAttribute("devices", devices);

            request.getRequestDispatcher("/customer/createRequest.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();

        }
    }

}
