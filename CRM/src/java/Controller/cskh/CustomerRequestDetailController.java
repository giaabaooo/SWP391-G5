/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.cskh;

import dal.CustomerRequestDAO;
import dal.UserDBContext;
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

/**
 *
 * @author admin
 */
@WebServlet("/cskh/customer-request/detail")
public class CustomerRequestDetailController extends HttpServlet {

    private CustomerRequestDAO requestDAO = new CustomerRequestDAO();
    private UserDBContext userDAO = new UserDBContext();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cskh/customer-request");
            return;
        }

        try {
            int requestId = Integer.parseInt(idParam);

            CustomerRequest requestDetail = requestDAO.getRequestDetailsById(requestId);

            if (requestDetail == null) {
                resp.sendRedirect(req.getContextPath() + "/cskh/customer-request?error=notFound");
                return;
            }

            User customerDetail = userDAO.get(requestDetail.getCustomer_id());

            CustomerRequestAssignment assignmentDetail = requestDAO.getTaskById(requestId);

            CustomerRequestMeta metaDetail = requestDAO.getCusRequestMetaById(requestId);

            req.setAttribute("requestDetail", requestDetail);
            req.setAttribute("customerDetail", customerDetail);
            req.setAttribute("assignmentDetail", assignmentDetail);
            req.setAttribute("metaDetail", metaDetail);

            req.getRequestDispatcher("/cskh/customer_request_detail.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/cskh/customer-request?error=invalidId");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/cskh/customer-request?error=load_failed");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String idParam = req.getParameter("requestId");

        if (idParam == null || action == null) {
            resp.sendRedirect(req.getContextPath() + "/cskh/customer-request?error=missingParams");
            return;
        }

        int requestId;
        try {
            requestId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/cskh/customer-request?error=invalidId");
            return;
        }

        String redirectUrl = req.getContextPath() + "/cskh/customer-request/detail?id=" + requestId;

        try {
            switch (action) {
                case "transfer":
                    String priority = req.getParameter("priority");

                    requestDAO.transferToTechManager(requestId); //

                    if (priority != null && !priority.isEmpty()) {
                        requestDAO.updatePriority(requestId, priority);
                    }

                    redirectUrl += "&message=transferred";
                    break;

                case "cancel":
                    String reason = req.getParameter("cancelReason");
                    if (reason == null || reason.trim().isEmpty()) {
                        reason = "Cancelled by CSKH without reason.";
                    }

                    boolean cancelSuccess = requestDAO.cancelRequest(requestId, reason);

                    if (cancelSuccess) {
                        redirectUrl += "&message=cancelled";
                    } else {
                        redirectUrl += "&error=actionFailed";
                    }
                    break;

                case "close":
                    requestDAO.updateRequest("CLOSED", 1, requestId);
                    redirectUrl += "&message=closed";
                    break;
                case "save_response":
                    String cskhResponse = req.getParameter("cskhResponse");
                    if (cskhResponse != null && !cskhResponse.trim().isEmpty()) {
                        requestDAO.saveCsResponse(requestId, cskhResponse);
                        redirectUrl += "&message=responseSaved";
                    } else {
                        redirectUrl += "&error=responseEmpty";
                    }
                    break;
                default:
                    redirectUrl += "&error=unknownAction";
            }

            resp.sendRedirect(redirectUrl);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(redirectUrl + "&error=actionFailed");
        }
    }
}