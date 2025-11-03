/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.cskh;

import dal.ContractDAO;
import dal.CustomerRequestDAO;
import dal.FeedbackDAO;
import dal.UserDBContext;
import data.CustomerRequest;
import data.Feedback;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
/**
 *
 * @author admin
 */
@WebServlet({"/cskh/dashboard", "/cskh/home"})
public class CSKHDashboardController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
private CustomerRequestDAO requestDAO = new CustomerRequestDAO();
    private FeedbackDAO feedbackDAO = new FeedbackDAO();
    private UserDBContext userDAO = new UserDBContext();
    private ContractDAO contractDAO = new ContractDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int pendingRequests = requestDAO.countCustomerRequests(null, "PENDING", null, null);

            int newFeedbacks = feedbackDAO.countAllFeedbacks("not_responded", null);

            int activeCustomers = userDAO.countCustomers(null, "active");

            int activeContracts = contractDAO.countContracts(null, null, null);

            List<CustomerRequest> recentPending = requestDAO.getRecentPendingRequests(5);
            List<Feedback> recentFeedbacks = feedbackDAO.getRecentFeedbacks(5);

            Map<String, Integer> weeklyStats = requestDAO.getWeeklyRequestStats(7);

            List<String> chartLabels = new ArrayList<>(weeklyStats.keySet());
            List<Integer> chartData = new ArrayList<>(weeklyStats.values());

            request.setAttribute("pendingRequestsCount", pendingRequests);
            request.setAttribute("newFeedbacksCount", newFeedbacks);
            request.setAttribute("activeCustomerCount", activeCustomers);
            request.setAttribute("activeContractCount", activeContracts);

            request.setAttribute("recentPendingRequests", recentPending);
            request.setAttribute("recentFeedbacks", recentFeedbacks);

            request.setAttribute("chartLabels", chartLabels);
            request.setAttribute("chartData", chartData);

            request.getRequestDispatcher("/cskh/cskh_dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading dashboard data.");
        }
    }
}
