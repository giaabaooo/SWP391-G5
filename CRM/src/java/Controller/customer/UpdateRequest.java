/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.customer;

import data.Device;
import data.CustomerRequest;
import data.User;
import dal.DeviceDAO;
import dal.CustomerRequestDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;

/**
 *
 * @author admin
 */
public class UpdateRequest extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method. This method is responsible for
     * displaying the form to edit an existing request. It fetches the request
     * data and the list of user's devices from the database.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        int requestId = Integer.parseInt(request.getParameter("id"));
        CustomerRequestDAO requestDAO = new CustomerRequestDAO();
        CustomerRequest requestData = requestDAO.getCusRequestById(requestId);        
                           
        DeviceDAO deviceDAO = new DeviceDAO();
        List<Device> devices = deviceDAO.getDevicesByUserId(user.getId());     
        request.setAttribute("requestData", requestData);
        request.setAttribute("devices", devices);      
        request.getRequestDispatcher("/customer/updateRequest.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        User user = (User) request.getSession().getAttribute("user");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
        
        CustomerRequestDAO requestDAO = new CustomerRequestDAO();
        CustomerRequest originalRequest = null; // Khai báo ở đây
      
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String title = request.getParameter("title");
            int deviceId = Integer.parseInt(request.getParameter("device_id"));
            String description = request.getParameter("description");
            String requestType = request.getParameter("request_type"); // Phải là IN HOA
            

            String desiredDateStr = request.getParameter("desired_date");
            String isUrgentStr = request.getParameter("isUrgent");
            originalRequest = requestDAO.getCusRequestById(id);

            java.util.Date utilDate = null;
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
                        throw new Exception("The desired completion date must be tomorrow or later.");
                    }
                } catch (Exception e) {
                    request.setAttribute("error", e.getMessage());
                    request.setAttribute("requestData", originalRequest); // Gửi lại data cũ
                    DeviceDAO deviceDAO = new DeviceDAO();
                    List<Device> devices = deviceDAO.getDevicesByUserId(user.getId());
                    request.setAttribute("devices", devices);
                    request.getRequestDispatcher("/customer/updateRequest.jsp").forward(request, response);
                    return;
                }
            }

            String priority = (isUrgentStr != null && isUrgentStr.equals("true")) ? "URGENT" : "MEDIUM";

            CustomerRequest updatedRequest = new CustomerRequest();
            updatedRequest.setId(id);
            updatedRequest.setTitle(title);
            updatedRequest.setDevice_id(deviceId);
            updatedRequest.setDescription(description);
            updatedRequest.setRequest_type(requestType);

            boolean successMain = requestDAO.updateRequest(updatedRequest);          
            boolean successMeta = requestDAO.updateRequestMeta(id, utilDate, priority);

            if (successMain && successMeta) {
                response.sendRedirect(request.getContextPath() + "/customer/listRequest?success=Request updated successfully");
            } else {
                throw new Exception("Failed to update request in database.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to update request: " + e.getMessage());
            DeviceDAO deviceDAO = new DeviceDAO();
            List<Device> devices = deviceDAO.getDevicesByUserId(user.getId());
            request.setAttribute("devices", devices);

            int requestId = Integer.parseInt(request.getParameter("id"));
            request.setAttribute("requestData", requestDAO.getCusRequestById(requestId)); 
            request.getRequestDispatcher("/customer/updateRequest.jsp").forward(request, response);
        }
    }
}
