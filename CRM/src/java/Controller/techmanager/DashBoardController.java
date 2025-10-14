/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.techmanager;

import dal.CustomerRequestDAO;
import dal.UserDBContext;
import data.CustomerRequest;
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
@WebServlet("/techmanager/dashboard")
public class DashBoardController extends HttpServlet {

    CustomerRequestDAO db = new CustomerRequestDAO();
    UserDBContext userDb = new UserDBContext();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        var a = userDb.list(1, Integer.MAX_VALUE, "", "TECHNICIAN", "");
        int tech = a.size();

        int pending = 0, finish = 0, total = 0;

        ArrayList<CustomerRequest> pendingList = new ArrayList<CustomerRequest>();
                
        for (var b : db.getListRequest(1, Integer.MAX_VALUE, "", "", "", "","","")) {
            if (b.getStatus().contains("PENDING")) {
                pendingList.add(b);
                pending++;
            } else {
                finish++;
            }
            total++;
        }

        req.setAttribute("tech", tech);
        req.setAttribute("pending", pending);
        req.setAttribute("finish", finish);
        req.setAttribute("total", total);
        req.setAttribute("pendingList", pendingList);
        req.setAttribute("techList", userDb.list(1, 10, "", "TECHNICIAN", ""));

        req.getRequestDispatcher("/techmanager/dashboard.jsp").forward(req, resp);

    }
}
