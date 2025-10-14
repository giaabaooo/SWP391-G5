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
        if (action == null) action = "list";

        switch (action) {
            
            case "edit":
                int id = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("user", db.get(id));
                req.getRequestDispatcher("/WEB-INF/jsp/cskh/user_form.jsp").forward(req, resp);
                break;
            case "delete":
                db.delete(Integer.parseInt(req.getParameter("id")));
                resp.sendRedirect("user");
                break;
            case "list":
            default:
                int page = req.getParameter("page") == null ? 1 : Integer.parseInt(req.getParameter("page"));
                int size = 10;
                String keyword = req.getParameter("keyword");
//                String role = req.getParameter("role");
                String role = "TECHNICIAN";
                String status = req.getParameter("status");

                int total = db.countUser(keyword, role, status);

                req.setAttribute("users", db.list(page, size, keyword, role, status));
                req.setAttribute("total", total);
                req.setAttribute("page", page);
                req.setAttribute("pageSize", size);
                req.setAttribute("roles", db.getAllRoles());

                req.getRequestDispatcher("/techmanager/technician_list.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
        resp.sendRedirect("technician");
    }
}
