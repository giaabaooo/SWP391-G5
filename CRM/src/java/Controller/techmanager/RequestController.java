/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.techmanager;

import dal.CustomerRequestDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Date;

/**
 *
 * @author admin
 */
@WebServlet("/techmanager/request")
public class RequestController extends HttpServlet {

    CustomerRequestDAO db = new CustomerRequestDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "new":
                req.getRequestDispatcher("/WEB-INF/jsp/cskh/user_form.jsp").forward(req, resp);
                break;
            case "detail":
                int id = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("requests", db.getRequestById(id));
                req.getRequestDispatcher("/techmanager/request_detail.jsp").forward(req, resp);
                break;
//            case "delete":
//                db.delete(Integer.parseInt(req.getParameter("id")));
//                resp.sendRedirect("user");
//                break;
            case "list":
            default:
                int page = req.getParameter("page") == null ? 1 : Integer.parseInt(req.getParameter("page"));
                int size = 10;

                String keyword = req.getParameter("keyword");
                String status = req.getParameter("status");
                String fromDate = req.getParameter("fromDate");
                String toDate = req.getParameter("toDate");

                java.sql.Date from = null,
                 to = null;
                if (fromDate != null && !fromDate.isEmpty()) {
                    try {
                        from = java.sql.Date.valueOf(fromDate);
                    } catch (IllegalArgumentException e) {
                        req.setAttribute("error", "Invalid format!");
                        req.getRequestDispatcher("/techmanager/request_list.jsp").forward(req, resp);

                        return;
                    }
                }

                if (toDate != null && !toDate.isEmpty()) {
                    try {
                        to = java.sql.Date.valueOf(toDate);
                    } catch (IllegalArgumentException e) {
                        req.setAttribute("error", "Invalid format!");
                        req.getRequestDispatcher("/techmanager/request_list.jsp").forward(req, resp);

                        return;
                    }
                }

                if (from != null && to != null && from.after(to)) {
                    req.setAttribute("error", "The start date cannot be greater than the end date!");
                    req.getRequestDispatcher("/techmanager/request_list.jsp").forward(req, resp);

                    return;
                }

                req.setAttribute("requests", db.list(page, size, keyword, status, fromDate, toDate));
                //req.setAttribute("total", total);
                req.setAttribute("page", page);
                req.setAttribute("pageSize", size);

                req.getRequestDispatcher("/techmanager/request_list.jsp").forward(req, resp);

        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        String id = req.getParameter("id");
//        User u = new User();
//        u.setUsername(req.getParameter("username"));
//        u.setFullName(req.getParameter("fullName"));
//        u.setEmail(req.getParameter("email"));
//        u.setPhone(req.getParameter("phone"));
//        u.setAddress(req.getParameter("address"));
//        Role r = new Role();
//        r.setId(Integer.parseInt(req.getParameter("roleId")));
//        u.setRole(r);
//        u.setIsActive(req.getParameter("is_active") != null);
//
//        if (id == null || id.isEmpty()) {
//            u.setPassword("123456"); // TODO: hash password
//            db.insert(u);
//        } else {
//            u.setId(Integer.parseInt(id));
//            db.update(u);
//        }
        resp.sendRedirect("request");
    }
}
