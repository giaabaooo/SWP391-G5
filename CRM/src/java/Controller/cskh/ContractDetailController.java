/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.cskh;

import dal.ContractDAO;
import data.Contract;
import data.ContractItem;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author admin
 */
@WebServlet("/cskh/contract_detail")
public class ContractDetailController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/cskh/contract_list");
            return;
        }

        int id = Integer.parseInt(idStr);
        ContractDAO dao = new ContractDAO();
        Contract contract = dao.getContractDetail(id);
        List<ContractItem> items = dao.getContractItems(id);

        if (contract == null) {
            response.sendRedirect(request.getContextPath() + "/cskh/contract_list");
            return;
        }

        request.setAttribute("contract", contract);
        request.setAttribute("items", items);
        request.getRequestDispatcher("/cskh/contract_detail.jsp").forward(request, response);
    }
}