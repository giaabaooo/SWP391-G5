/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.techmanager;

import dal.CustomerRequestDAO;
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
@WebServlet("/techmanager/request")
public class RequestController extends HttpServlet {

    CustomerRequestDAO db = new CustomerRequestDAO();
    UserDBContext userDb = new UserDBContext();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            
            case "detail":
                int id = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("requests", db.getRequestById(id));
                req.getRequestDispatcher("/techmanager/request_detail.jsp").forward(req, resp);
                break;
            case "reject":
                int id_reject = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("requests", db.getRequestById(id_reject));
                req.getRequestDispatcher("/techmanager/reject_request.jsp").forward(req, resp);
                break;
            case "assignTask":
                
                req.setAttribute("requestList", db.getListRequest(1, Integer.MAX_VALUE, "", "active", "", ""));
                req.setAttribute("technicianList", userDb.list(1, Integer.MAX_VALUE, "", "TECHNICIAN", "active"));
                req.getRequestDispatcher("/techmanager/assign_task.jsp").forward(req, resp);
                break;
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

                req.setAttribute("requests", db.getListRequest(page, size, keyword, status, fromDate, toDate));
                //req.setAttribute("total", total);
                req.setAttribute("page", page);
                req.setAttribute("pageSize", size);

                req.getRequestDispatcher("/techmanager/request_list.jsp").forward(req, resp);

        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String id = req.getParameter("requestId");
        String reason = req.getParameter("reason");

        if (id == null || reason == null || reason.trim().isEmpty()) {
            req.setAttribute("error", "Reject reason is required!");
            req.getRequestDispatcher("/techmanager/requestdetail.jsp").forward(req, resp);
            return;
        }

        db.updateRequest("REJECTED",0,Integer.parseInt(id));
        db.insertRejectReason(Integer.parseInt(id), reason);

        resp.sendRedirect("request");
    }
}
