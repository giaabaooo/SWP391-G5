/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.cskh;

import dal.CustomerRequestDAO;
import data.CustomerRequest;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author admin
 */
@WebServlet("/cskh/customer-request/detail")
public class CustomerRequestDetailController extends HttpServlet {

    private CustomerRequestDAO requestDAO = new CustomerRequestDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cskh/customer-request");
            return;
        }

        try {
            int requestId = Integer.parseInt(idParam);
            CustomerRequest requestDetail = requestDAO.getCusRequestById(requestId);
            if (requestDetail == null) {
                resp.sendRedirect(req.getContextPath() + "/cskh/customer-request");
                return;
            }

            req.setAttribute("requestDetail", requestDetail);
            req.getRequestDispatcher("/cskh/customer_request_detail.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/cskh/customer-request");
        }
    }
}
