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
        User user = (User) request.getSession().getAttribute("user");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        int deviceId = Integer.parseInt(request.getParameter("device_id"));
        String description = request.getParameter("description");
        String requestType = request.getParameter("request_type");

        CustomerRequest updatedRequest = new CustomerRequest();
        updatedRequest.setId(id);
        updatedRequest.setTitle(title);
        updatedRequest.setDevice_id(deviceId);
        updatedRequest.setDescription(description);
        updatedRequest.setRequest_type(requestType);

        
        CustomerRequestDAO requestDAO = new CustomerRequestDAO();
        boolean success = requestDAO.updateRequest(updatedRequest);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/customer/listRequest?success=Request updated successfully");
        } else {
            request.setAttribute("error", "Failed to update request. Please try again.");
        }          
    }
}
