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
import java.util.ArrayList;
import java.util.Date;


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
            case"createBill":
                
                ArrayList<CustomerRequestAssignment> task1 = new ArrayList<>();
                ArrayList<CustomerRequest> requestList = new ArrayList<CustomerRequest>();

                for (var i : db.getListTask(1, Integer.MAX_VALUE, "", "", "", "","")) {
                    CustomerRequestAssignment tech = db.getTaskById(i.getRequest_id());
                    for (var j : tech.getTechnician()) {
                        if (j.getId() == account.getId()) {
                            task1.add(i);
                        }
                    }
                }

                for(var i: task1){
                    requestList.add(i.getCustomerRequest());
                }
                
                req.setAttribute("requestList", requestList);
                req.getRequestDispatcher("/technician/create_bill.jsp").forward(req, resp);
                break;
            
            case "detail":
                int id = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("tasks", db.getTaskById(id));
                req.getRequestDispatcher("/technician/task_detail.jsp").forward(req, resp);
                break;

            case "list":
            default:
                int page = req.getParameter("page") == null ? 1 : Integer.parseInt(req.getParameter("page"));
                int size = 10;

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
        double paidAmount = Double.parseDouble(req.getParameter("paidAmount"));
        String paymentStatus = req.getParameter("paymentStatus");
        String assignDate = req.getParameter("assignDate");

        CustomerRequestMeta bill = new CustomerRequestMeta();
        bill.setRequest_id(taskId);
        bill.setTotal_cost(totalCost);
        bill.setPaid_amount(paidAmount);
        bill.setPayment_status(paymentStatus);
        bill.setPayment_due_date(java.sql.Date.valueOf(assignDate));

        db.insertCusRequestMeta(bill);
        db.deleteByRequestId(taskId);

        resp.sendRedirect("task");
    }

}
