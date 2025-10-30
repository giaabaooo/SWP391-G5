/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.customer;

import dal.CustomerRequestDAO;
import data.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author admin
 */
public class DeleteRequest extends HttpServlet {
   
   @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        try {
            // Get product ID from parameter
            String requestIdParam = request.getParameter("id");
            
            if (requestIdParam == null || requestIdParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/customer/listRequest?error=Request ID is required");
                return;
            }
            
            int requestId;
            try {
                requestId = Integer.parseInt(requestIdParam);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/customer/listRequest?error=Invalid request ID");
                return;
            }
            
            // Deactivate product (soft delete) instead of hard delete to preserve referential integrity
           CustomerRequestDAO dao = new CustomerRequestDAO();
            boolean isDeleted = dao.deactivateRequest(requestId, user.getId());
            
            if (isDeleted) {
                response.sendRedirect(request.getContextPath() + "/customer/listRequest?success=Request deleted successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/customer/listRequest?error=Failed to delete request");
            }
            
        } catch (Exception e) {
            System.err.println("Error deleting product: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/customer/listRequest?error=An error occurred while deleting the product");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Redirect GET requests to POST
        doPost(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Delete Request Controller";
    }

}
