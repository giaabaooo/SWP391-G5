/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.techmanager;

import dal.CustomerRequestDAO;
import dal.UserDBContext;
import data.CustomerRequestAssignment;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

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

                String error = req.getParameter("error");
                String techName = req.getParameter("techName");

                if ("tooMuchTask".equals(error)) {
                    req.setAttribute("error", techName + " has had a lot of task on that day");
                }

                if (req.getParameter("id") != null) {
                    req.setAttribute("requestSelected", Integer.valueOf(req.getParameter("id")));
                }

                String selectedDateStr = req.getParameter("selectedDate");
                LocalDate selectedDate;

                if (selectedDateStr == null || selectedDateStr.isEmpty()) {
                    selectedDate = LocalDate.now(); // default: today
                } else {
                    selectedDate = LocalDate.parse(selectedDateStr);
                }

                LocalDate monday = selectedDate.with(DayOfWeek.MONDAY);
                LocalDate sunday = selectedDate.with(DayOfWeek.SUNDAY);

                req.setAttribute("weekStart", monday.toString());
                req.setAttribute("weekEnd", sunday.toString());

                LocalDate[] weekDays = new LocalDate[7];
                for (int i = 0; i < 7; i++) {
                    weekDays[i] = monday.plusDays(i);
                }
                req.setAttribute("weekDays", weekDays);

                List<CustomerRequestAssignment> schedule
                        = db.getListTask(1, Integer.MAX_VALUE, "", monday.toString(), sunday.toString(), "", "");

                if (schedule == null) {
                    schedule = new ArrayList<>();
                }
                req.setAttribute("weekSchedule", schedule);

                req.setAttribute("requestList",db.getListRequest(1, Integer.MAX_VALUE, "", "", "", "", "", "active"));
                req.setAttribute("technicianList",userDb.list(1, Integer.MAX_VALUE, "", "TECHNICIAN", "active"));

                req.getRequestDispatcher("/techmanager/assign_task.jsp").forward(req, resp);
                break;
            case "list":
            default:
                int page = req.getParameter("page") == null ? 1 : Integer.parseInt(req.getParameter("page"));
                int size = req.getParameter("pageSize") == null ? 10 : Integer.parseInt(req.getParameter("pageSize"));

                String keyword = req.getParameter("keyword");
                String requestType = req.getParameter("requestType");
                String status = req.getParameter("status");
                String isActive = req.getParameter("isActive");
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

                var re = db.getListRequest(1, Integer.MAX_VALUE, "", "", "", "", "", "");
                int totalPages = (int) Math.ceil((double) re.size() / size);
                
                req.setAttribute("requests", db.getListRequest(page, size, keyword, status, fromDate, toDate, requestType, isActive));
                req.setAttribute("totalProducts", re.size());
                req.setAttribute("page", page);
                req.setAttribute("pageSize", size);
                req.setAttribute("totalPages", totalPages);

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
        }else if(reason.length()>=300){
            req.setAttribute("error", "Reject reason is too long!");
            req.getRequestDispatcher("/techmanager/requestdetail.jsp").forward(req, resp);
            return;
        }

        db.updateRequest("CANCELLED",0,Integer.parseInt(id));
        db.insertRejectReason(Integer.parseInt(id), reason);

        resp.sendRedirect("request");
    }
}
