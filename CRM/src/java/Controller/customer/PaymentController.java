/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.customer;

import dal.PaymentDAO;
import data.CustomerRequest;
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
public class PaymentController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("../login");
            return;
        }

        User user = (User) session.getAttribute("user");

        try {
            int requestId = Integer.parseInt(request.getParameter("id"));

            PaymentDAO dao = new PaymentDAO();
            CustomerRequest req = dao.getRequestWithPaymentDetails(requestId, user.getId());
           
            double totalCost = req.getRequestMeta().getTotal_cost();
            double paidAmount = req.getRequestMeta().getPaid_amount();
            double amountDue = totalCost - paidAmount;

          
            // Gửi thông tin sang JSP
            request.setAttribute("requestPaymentInfo", req);
            request.setAttribute("amountDue", amountDue);
            request.setAttribute("totalCost", totalCost); 
            request.setAttribute("paidAmount", paidAmount);

            request.getRequestDispatcher("/customer/payment.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * XỬ LÝ THANH TOÁN (KHÔNG QUA CỔNG BÊN NGOÀI) 
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int requestId = 0; 
        double amountDue = 0;
        CustomerRequest req = null;
        PaymentDAO dao = new PaymentDAO();

        try {
            //  Lấy dữ liệu từ form 
            requestId = Integer.parseInt(request.getParameter("requestId"));
            double amountToPay = Double.parseDouble(request.getParameter("amountToPay")); // Dùng double
            

            boolean success = dao.processPayment(requestId, amountToPay);

            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/customer/listRequest?success=Paid successfully!");
            } else {
                request.setAttribute("error", "Failed to Paid. Please try again.");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
