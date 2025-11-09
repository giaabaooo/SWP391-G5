/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.customer;

import dal.ContractDAO;
import data.Contract;
import data.ContractItem;
import data.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author admin
 */
public class DetailContract extends HttpServlet {
   
   private ContractDAO contractDAO = new ContractDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Kiểm tra session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("../login");
            return;
        }
        User user = (User) session.getAttribute("user");

        String idParam = request.getParameter("id");
        int contractId;

        // 2. Lấy và xác thực ID
        try {
            contractId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            // Nếu ID không phải là số, đá về trang list
            request.setAttribute("error", "Invalid contract ID.");
            request.getRequestDispatcher("/customer/contract.jsp").forward(request, response);
            return;
        }

       
        Contract contract = contractDAO.getContractDetail(contractId);
       
        // QUAN TRỌNG: Đảm bảo khách hàng chỉ xem được hợp đồng của chính mình
        if (contract.getCustomerId() != user.getId()) {
             request.setAttribute("error", "You are not authorized to view this contract.");
             request.getRequestDispatcher("/customer/contract.jsp").forward(request, response);
             return;
        }

        // 5. Nếu hợp lệ, lấy danh sách items
        List<ContractItem> items = contractDAO.getContractItems(contractId);

        // 6. Gửi dữ liệu qua JSP và chuyển hướng
        request.setAttribute("contract", contract);
        request.setAttribute("items", items);
        request.getRequestDispatcher("/customer/detailContract.jsp").forward(request, response);
    }
}
