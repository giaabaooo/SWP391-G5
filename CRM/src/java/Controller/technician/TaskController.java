/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.technician;

import dal.CustomerRequestDAO;
import data.CustomerRequest;
import data.CustomerRequestAssignment;
import data.CustomerRequestMeta;
import data.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.LocalDate;
import java.util.ArrayList;

/**
 *
 * @author admin
 */
@WebServlet("/technician/task")
public class TaskController extends HttpServlet {

    CustomerRequestDAO db = new CustomerRequestDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        User account = (User) req.getSession().getAttribute("user");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "createBill":
                String error = req.getParameter("error");
                if ("paidExceed".equals(error)) {
                    req.setAttribute("error", "The amount paid cannot be greater than the total amount.");
                }

                if (req.getParameter("id") != null) {
                    req.setAttribute("taskSelected", Integer.valueOf(req.getParameter("id")));
                }
                ArrayList<CustomerRequestAssignment> task1 = new ArrayList<>();
                ArrayList<CustomerRequest> requestList = new ArrayList<CustomerRequest>();

                for (var i : db.getListTask(1, Integer.MAX_VALUE, "", "", "", "", "")) {
                    CustomerRequestAssignment tech = db.getTaskById(i.getRequest_id());
                    for (var j : tech.getTechnician()) {
                        if (j.getId() == account.getId()) {
                            task1.add(i);
                        }
                    }
                }

                for (var i : task1) {
                    if (i.getIs_main() == 1 && account.getId() == i.getTechnician_id()) {
                        var a = i.getCustomerRequest();
                        if (!a.getRequest_type().equals("WARRANTY")) {
                            requestList.add(a);
                        }
                    }

                }

                req.setAttribute("requestList", requestList);
                req.getRequestDispatcher("/technician/create_bill.jsp").forward(req, resp);
                break;
            case "complete":
                int idComplete = Integer.parseInt(req.getParameter("id"));
                db.updateRequest("COMPLETED", 1, idComplete);

                CustomerRequestMeta bill = new CustomerRequestMeta();
                bill.setRequest_id(idComplete);
                bill.setTotal_cost(0);
                bill.setPaid_amount(0);
                bill.setPayment_status("PAID");
                bill.setPayment_due_date(java.sql.Date.valueOf(LocalDate.now()));

                db.insertCusRequestMeta(bill);
                db.deleteByRequestId(idComplete);

                //req.setAttribute("success", "This task has been completed");
                //req.getRequestDispatcher("/technician/task_list.jsp").forward(req, resp);
                resp.sendRedirect(req.getContextPath() + "/technician/task?action=list&success=complete");

                break;
            case "inProgress":
                int idInProgress = Integer.parseInt(req.getParameter("id"));

                var a2 = db.getListTask(1, Integer.MAX_VALUE, "", "", "", "", "");
                ArrayList<CustomerRequestAssignment> task2 = new ArrayList<>();

                for (var i : a2) {
                    CustomerRequestAssignment tech = db.getTaskById(i.getRequest_id());
                    for (var j : tech.getTechnician()) {
                        if (j.getId() == account.getId()) {
                            task2.add(i);
                        }
                    }
                }

                for (var i : task2) {
                    if (i.getCustomerRequest().getStatus().equals("IN_PROGRESS")) {
                        resp.sendRedirect(req.getContextPath() + "/technician/task?action=list&error=processing");

                        return;
                    }
                }

                db.updateRequest("IN_PROGRESS", 1, idInProgress);

                resp.sendRedirect(req.getContextPath() + "/technician/task?action=list&success=processing");
                break;

            case "detail":
                int id = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("tasks", db.getTaskById(id));
                req.getRequestDispatcher("/technician/task_detail.jsp").forward(req, resp);
                break;

            case "list":
            default:
                String errorPro = req.getParameter("error");
                if ("processing".equals(errorPro)) {
                    req.setAttribute("error", "You have a task in progress.");
                }
                String success = req.getParameter("success");
                if ("processing".equals(success)) {
                    req.setAttribute("success", "This task's status has been changed to processing.");
                }else if("complete".equals(success)){
                    req.setAttribute("success", "This task has been completed.");
                }
                
                int page = req.getParameter("page") == null ? 1 : Integer.parseInt(req.getParameter("page"));
                int size = req.getParameter("pageSize") == null ? 10 : Integer.parseInt(req.getParameter("pageSize"));

                String requestType = req.getParameter("requestType");
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
                        req.getRequestDispatcher("/technician/task_list.jsp").forward(req, resp);

                        return;
                    }
                }

                if (toDate != null && !toDate.isEmpty()) {
                    try {
                        to = java.sql.Date.valueOf(toDate);
                    } catch (IllegalArgumentException e) {
                        req.setAttribute("error", "Invalid format!");
                        req.getRequestDispatcher("/technician/task_list.jsp").forward(req, resp);

                        return;
                    }
                }

                if (from != null && to != null && from.after(to)) {
                    req.setAttribute("error", "The start date cannot be greater than the end date!");
                    req.getRequestDispatcher("/technician/task_list.jsp").forward(req, resp);

                    return;
                }

                var a = db.getListTask(page, size, keyword, fromDate, toDate, "", requestType);
                ArrayList<CustomerRequestAssignment> task = new ArrayList<>();

                for (var i : a) {
                    CustomerRequestAssignment tech = db.getTaskById(i.getRequest_id());
                    for (var j : tech.getTechnician()) {
                        if (j.getId() == account.getId()) {
                            task.add(i);
                        }
                    }
                }

                req.setAttribute("task", task);
                //req.setAttribute("total", total);
                req.setAttribute("page", page);
                req.setAttribute("pageSize", size);

                req.getRequestDispatcher("/technician/task_list.jsp").forward(req, resp);

        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int taskId = Integer.parseInt(req.getParameter("taskId"));
        double totalCost = Double.parseDouble(req.getParameter("totalCost"));
        String paidAmountStr = req.getParameter("paidAmount");
        double paidAmount = 0;

        if (paidAmountStr != null && !paidAmountStr.trim().isEmpty()) {
            paidAmount = Double.parseDouble(paidAmountStr);
        }

        String paymentStatus = req.getParameter("paymentStatus");
        String assignDate = req.getParameter("assignDate");

        if (paidAmount > totalCost) {
            req.setAttribute("error", "The amount paid cannot be greater than the total amount.");
            //req.getRequestDispatcher("/technician/task?action=createBill").forward(req, resp);
            resp.sendRedirect(req.getContextPath() + "/technician/task?action=createBill&error=paidExceed");

            return;
        }
        if (paidAmount == totalCost) {
            paymentStatus = "PAID";
        }

        CustomerRequestMeta bill = new CustomerRequestMeta();
        bill.setRequest_id(taskId);
        bill.setTotal_cost(totalCost);
        bill.setPaid_amount(paidAmount);
        bill.setPayment_status(paymentStatus);
        bill.setPayment_due_date(java.sql.Date.valueOf(assignDate));

        if (paymentStatus.toLowerCase().equals("unpaid") || paymentStatus.toLowerCase().equals("partially_paid")) {
            db.updateRequest("AWAITING_PAYMENT", 1, taskId);
        } else {
            db.updateRequest("PAID", 1, taskId);
        }

        db.insertCusRequestMeta(bill);
        db.deleteByRequestId(taskId);

        resp.sendRedirect("task");
    }

}
