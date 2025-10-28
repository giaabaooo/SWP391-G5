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
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author admin
 */
public class DetailRequestController extends HttpServlet {
   private DeviceDAO deviceDAO = new DeviceDAO();
   @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         HttpSession session = request.getSession(false);
         User user = (User) session.getAttribute("user");

         
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("../login");
            return;
        }     
        try {            
            int requestId = Integer.parseInt(request.getParameter("id"));
                       
            CustomerRequestDAO dao = new CustomerRequestDAO();
            CustomerRequest requestDetails = dao.getRequestDetailsById(requestId);

            request.setAttribute("requestDetails", requestDetails);
            request.getRequestDispatcher("/customer/detailRequest.jsp").forward(request, response);        
        } catch (NumberFormatException e) {
            e.printStackTrace();                  
        } 
        response.sendRedirect(request.getContextPath() + "/customer/listRequest");
    }
}
