/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.cskh;

import dal.ContractDAO;
import data.Contract;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author admin
 */
@WebServlet("/cskh/contract")
public class ContractController extends HttpServlet {

    private ContractDAO dao = new ContractDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int page = 1;
        int pageSize = 10;

        try {
            String pageParam = req.getParameter("page");
            if (pageParam != null) {
                page = Math.max(1, Integer.parseInt(pageParam));
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        String keyword = req.getParameter("keyword");
        String fromDate = req.getParameter("fromDate");
        String toDate = req.getParameter("toDate");

        int total = dao.countContracts(keyword, fromDate, toDate);
        int totalPages = (int) Math.ceil((double) total / pageSize);
        if (totalPages == 0) {
            totalPages = 1;
        }
        List<Contract> contracts = dao.listContracts(page, pageSize, keyword, fromDate, toDate);

        req.setAttribute("contracts", contracts);
        req.setAttribute("total", total);
        req.setAttribute("page", page);
        req.setAttribute("pageSize", pageSize);
        req.setAttribute("keyword", keyword);
        req.setAttribute("fromDate", fromDate);
        req.setAttribute("toDate", toDate);
        req.setAttribute("totalPages", totalPages);

        req.getRequestDispatcher("/cskh/contract_list.jsp").forward(req, resp);
    }
}
