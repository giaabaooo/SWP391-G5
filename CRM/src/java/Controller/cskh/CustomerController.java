/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.cskh;

import dal.UserDBContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/cskh/customer")
public class CustomerController extends HttpServlet {

    private UserDBContext db = new UserDBContext();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        int page = 1;
        int pageSize = 10;
        String pageParam = req.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        String keyword = req.getParameter("keyword");
        String status = req.getParameter("status");

        int total = db.countCustomers(keyword, status);
        int totalPages = (int) Math.ceil((double) total / pageSize);
        if (totalPages == 0) {
            totalPages = 1;
        }

        req.setAttribute("customers", db.listCustomers(page, pageSize, keyword, status));
        req.setAttribute("total", total);
        req.setAttribute("page", page);
        req.setAttribute("pageSize", pageSize);
        req.setAttribute("totalPages", totalPages);

        req.getRequestDispatcher("/cskh/customer_list.jsp").forward(req, resp);
    }
}
