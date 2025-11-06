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
import java.time.LocalDate;

/**
 *
 * @author admin
 */
@WebServlet("/techmanager/task")
public class TaskController extends HttpServlet {

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
                req.setAttribute("tasks", db.getTaskById(id));
                req.getRequestDispatcher("/techmanager/task_detail.jsp").forward(req, resp);
                break;
            case "edit":
                String error = req.getParameter("error");
                String techName = req.getParameter("techName");

                if ("tooMuchTask".equals(error)) {
                    req.setAttribute("error", techName + " has had a lot of task on that day");
                } else if ("errorTime".equals(error)) {
                    req.setAttribute("error", "Estimated hours must be between 1 and 200");
                } else if ("pastDate".equals(error)) {
                    req.setAttribute("error", "Date can not in the part");
                }

                int id2 = Integer.parseInt(req.getParameter("id"));

                int leaderId = 0;
                var a = db.getTaskById(id2);
                var b = db.getListTask(1, Integer.MAX_VALUE, "", "", "", "", "");
                for (var i : b) {
                    if (i.getId() == a.getId()) {
                        leaderId = i.getTechnician_id();
                    }
                }

                req.setAttribute("tasks", a);
                req.setAttribute("leaderId", leaderId);
                req.setAttribute("technicianList", userDb.list(1, Integer.MAX_VALUE, "", "TECHNICIAN", "active"));
                req.getRequestDispatcher("/techmanager/edit_task.jsp").forward(req, resp);

                break;
            case "list":
            default:
                int page = req.getParameter("page") == null ? 1 : Integer.parseInt(req.getParameter("page"));
                int size = req.getParameter("pageSize") == null ? 10 : Integer.parseInt(req.getParameter("pageSize"));

                String keyword = req.getParameter("keyword");
                String requestType = req.getParameter("requestType");
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

                var re = db.getListTask(1, Integer.MAX_VALUE, "", "", "", "", "");
                int totalPages = (int) Math.ceil((double) re.size() / size);

                req.setAttribute("task", db.getListTask(page, size, keyword, fromDate, toDate, "", requestType));
                req.setAttribute("totalProducts", re.size());
                req.setAttribute("page", page);
                req.setAttribute("pageSize", size);
                req.setAttribute("totalPages", totalPages);

                req.getRequestDispatcher("/techmanager/task_list.jsp").forward(req, resp);

        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "add":
                try {
                int requestId = Integer.parseInt(req.getParameter("taskId"));
                String[] technicianIds = req.getParameterValues("technicianIds");
                String leaderId = req.getParameter("leaderId");
                String assignedDate = req.getParameter("assignedDate");
                int estimatedHours = Integer.parseInt(req.getParameter("estimatedHours"));

                if (estimatedHours <= 0 || estimatedHours > 200) {
                    resp.sendRedirect(req.getContextPath() + "/techmanager/request?action=assignTask&id=" + requestId + "&error=errorTime");

                    return;
                }

                if (technicianIds != null) {
                    LocalDate startDate = LocalDate.parse(assignedDate);

                    LocalDate today = LocalDate.now();
                    if (startDate.isBefore(today)) {
                        resp.sendRedirect(req.getContextPath() + "/techmanager/request?action=assignTask&id=" + requestId + "&error=pastDate");
                        return;
                    }

                    int remainingHours = estimatedHours;

                    for (String techIdStr : technicianIds) {
                        if (techIdStr == null || techIdStr.isEmpty()) {
                            continue;
                        }

                        int techId = Integer.parseInt(techIdStr);
                        LocalDate currentDay = startDate;
                        boolean overloaded = false;

                        while (remainingHours > 0) {
                            int todayHours = Math.min(8, remainingHours);
                            int totalHours = db.getTotalEstimatedHoursByTechnicianAndDate(techId, currentDay.toString());

                            if (totalHours + todayHours > 8) {
                                overloaded = true;
                                break;
                            }

                            remainingHours -= todayHours;
                            currentDay = currentDay.plusDays(1);
                        }

                        remainingHours = estimatedHours;

                        if (overloaded) {
                            resp.sendRedirect(req.getContextPath() + "/techmanager/request?action=assignTask&id=" + requestId + "&techName=" + userDb.get(techId).getFullName() + "&error=tooMuchTask");
                            return;
                        }
                    }

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
                        ca.setEstimated_hours(estimatedHours);

                        db.insert(ca);
                    }
                }

                db.updateRequest("ASSIGNED", 1, requestId);

                resp.sendRedirect("task?msg=added");

            } catch (Exception ex) {
                ex.printStackTrace();

            }
            break;
            case "update":
                try {

                int requestId = Integer.parseInt(req.getParameter("taskId"));
                String[] technicianIds = req.getParameterValues("technicianIds");
                String leaderId = req.getParameter("leaderId");
                String assignedDateStr = req.getParameter("assignedDate");

                java.sql.Date assignedDate = java.sql.Date.valueOf(assignedDateStr);
                int estimatedHours = Integer.parseInt(req.getParameter("estimatedHours"));

                if (estimatedHours <= 0 || estimatedHours > 200) {
                    resp.sendRedirect(req.getContextPath() + "/techmanager/task?action=edit&id=" + requestId + "&error=errorTime");

                    return;
                }

                if (technicianIds == null || technicianIds.length == 0 || (technicianIds.length == 1 && (technicianIds[0] == null || technicianIds[0].isEmpty()))) {
                    resp.sendRedirect(req.getContextPath() + "/techmanager/task?action=edit&id=" + requestId + "&error=noTechnician");
                    return;
                }

                LocalDate startDate = assignedDate.toLocalDate();

                LocalDate today = LocalDate.now();
                if (startDate.isBefore(today)) {
                    resp.sendRedirect(req.getContextPath() + "/techmanager/task?action=edit&id=" + requestId + "&error=pastDate");
                    return;
                }

                for (String techIdStr : technicianIds) {
                    if (techIdStr == null || techIdStr.isEmpty()) {
                        continue;
                    }
                    int techId = Integer.parseInt(techIdStr);

                    int oldEstimatedHours = db.getOldEstimatedHours(requestId);

                    LocalDate currentDay = startDate;
                    int remainingHours = estimatedHours;
                    boolean overloaded = false;

                    while (remainingHours > 0) {
                        int todayHours = Math.min(8, remainingHours);

                        int totalHours = db.getTotalEstimatedHoursByTechnicianAndDate(techId, currentDay.toString());

                        if (oldEstimatedHours > 0) {
                            int oldHoursToday = Math.min(8, oldEstimatedHours);
                            totalHours = Math.max(0, totalHours - oldHoursToday);
                            oldEstimatedHours -= oldHoursToday;
                        }

                        if (totalHours + todayHours > 8) {
                            overloaded = true;
                            break;
                        }

                        remainingHours -= todayHours;
                        currentDay = currentDay.plusDays(1);
                    }

                    if (overloaded) {
                        resp.sendRedirect(req.getContextPath() + "/techmanager/task?action=edit&id=" + requestId + "&techName=" + userDb.get(techId).getFullName() + "&error=tooMuchTask");
                        return;
                    }
                }

                db.deleteByRequestId(requestId);

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
                    ca.setAssigned_date(assignedDate);
                    ca.setEstimated_hours(estimatedHours);

                    db.insert(ca);
                }

                db.updateRequest("PROCESSING", 1, requestId);

                resp.sendRedirect("task?msg=updated");

            } catch (Exception ex) {
                ex.printStackTrace();
                req.setAttribute("error", "Có lỗi xảy ra khi cập nhật task assignment!");
                req.getRequestDispatcher("/techmanager/error.jsp").forward(req, resp);
            }
            break;

            default:
        }

    }

}
