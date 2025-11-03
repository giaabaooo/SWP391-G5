/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.cskh;

import dal.ContractDAO;
import dal.UserDBContext;
import data.Contract;
import data.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
/**
 *
 * @author admin
 */
@WebServlet("/cskh/customer-detail")
public class CustomerDetailController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
private UserDBContext userDB = new UserDBContext();
    private ContractDAO contractDAO = new ContractDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        String idParam = req.getParameter("id");
        int id = -1;
        
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/cskh/customer");
            return;
        }

        User customer = userDB.get(id); 

        if (customer == null || !customer.getRole().getName().equalsIgnoreCase("Customer")) {
            resp.sendRedirect(req.getContextPath() + "/cskh/customer");
            return;
        }

        ArrayList<Contract> contracts = contractDAO.getContractsByCustomerId(id);

        req.setAttribute("customer", customer);
        req.setAttribute("contracts", contracts);

        req.getRequestDispatcher("/cskh/customer_detail.jsp").forward(req, resp);
    }
}
