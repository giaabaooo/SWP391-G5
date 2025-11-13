/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.techmanager;

import dal.UserDBContext;
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
@WebServlet("/techmanager/technician")
public class TechnicianController extends HttpServlet {

    UserDBContext db = new UserDBContext();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {

            case "detail":
                int id = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("list", db.get(id));
                req.getRequestDispatcher("/techmanager/technician_detail.jsp").forward(req, resp);
                break;
            case "delete":
                int id2 = Integer.parseInt(req.getParameter("id"));
                db.toggleCustomerStatus(id2);
                
                resp.sendRedirect("technician");
                break;
                
            case "list":
            default:
                int page = req.getParameter("page") == null ? 1 : Integer.parseInt(req.getParameter("page"));
                int size = req.getParameter("pageSize") == null ? 10 : Integer.parseInt(req.getParameter("pageSize"));
                String keyword = req.getParameter("keyword");
//                String role = req.getParameter("role");
                String role = "TECHNICIAN";
                String status = req.getParameter("status");

                int total = db.countUser(keyword, role, status);

                int totalPages = (int) Math.ceil((double) total / size);

                req.setAttribute("users", db.list(page, size, keyword, role, status));
                req.setAttribute("totalProducts", total);
                req.setAttribute("page", page);
                req.setAttribute("pageSize", size);
                req.setAttribute("totalPages", totalPages);

                req.setAttribute("roles", db.getAllRoles());

                req.getRequestDispatcher("/techmanager/technician_list.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        resp.sendRedirect("technician");
    }
}
