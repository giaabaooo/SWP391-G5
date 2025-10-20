/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.cskh;

import dal.ContractDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author admin
 */
@WebServlet("/cskh/deleteContract")
public class ContractDeleteController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");

        if (idStr == null || idStr.isEmpty()) {
            request.setAttribute("error", "Missing contract ID to delete!");
            request.getRequestDispatcher("/jsp/cskh/contract_list.jsp").forward(request, response);
            return;
        }

        try {
            int id = Integer.parseInt(idStr);

            ContractDAO dao = new ContractDAO();

            dao.deleteContractWithItems(id);

            response.sendRedirect(request.getContextPath() + "/cskh/contract?message=deleted");

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid contract ID!");
            request.getRequestDispatcher("/jsp/cskh/contract_list.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Contract deletion failed!");
            request.getRequestDispatcher("/jsp/cskh/contract_list.jsp").forward(request, response);
        }
    }
}