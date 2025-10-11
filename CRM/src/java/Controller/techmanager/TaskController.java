/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.techmanager;

import dal.CustomerRequestDAO;
import data.CustomerRequestAssignment;
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
@WebServlet("/techmanager/task")
public class TaskController extends HttpServlet {

    CustomerRequestDAO db = new CustomerRequestDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "detail":
                int id = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("tasks", db.getTaskById(id));
                req.getRequestDispatcher("/techmanager/task_detail.jsp").forward(req, resp);
                break;
            case "list":
            default:
                int page = req.getParameter("page") == null ? 1 : Integer.parseInt(req.getParameter("page"));
                int size = 10;

                String keyword = req.getParameter("keyword");
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
                req.setAttribute("task", db.getListTask(page, size, keyword, fromDate, toDate));
                //req.setAttribute("total", total);
                req.setAttribute("page", page);
                req.setAttribute("pageSize", size);

                req.getRequestDispatcher("/techmanager/task_list.jsp").forward(req, resp);

        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        try {
            
            int requestId = Integer.parseInt(req.getParameter("taskId"));
            String[] technicianIds = req.getParameterValues("technicianIds");
            String leaderId = req.getParameter("leaderId");
            String assignedDate = req.getParameter("assignedDate");

            if (technicianIds != null) {
                for (String techIdStr : technicianIds) {
                    if (techIdStr == null || techIdStr.isEmpty()) {
                        continue;
                    }

                    int techId = Integer.parseInt(techIdStr);
                    boolean isLeader = (leaderId != null && leaderId.equals(techIdStr));

                    CustomerRequestAssignment ca = new CustomerRequestAssignment();
                    ca.setRequest_id(requestId);
                    ca.setTechnician_id(techId);
                    ca.setIs_main(isLeader ? 1 : 0);
                    ca.setAssigned_date(java.sql.Date.valueOf(assignedDate));

                    db.insert(ca);
                }
            }
            db.updateRequest("PROCESSING", 1, requestId);
            
            resp.sendRedirect("task?msg=added");

        } catch (Exception ex) {
            ex.printStackTrace();
            req.setAttribute("error", "Có lỗi xảy ra khi thêm task assignment!");
            req.getRequestDispatcher("/techmanager/error.jsp").forward(req, resp);
        }
    }

}
