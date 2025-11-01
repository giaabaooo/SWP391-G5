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
@WebServlet("/cskh/checkContractCode")
public class CheckContractCodeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String contractCode = request.getParameter("code");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if (contractCode == null || contractCode.trim().isEmpty()) {
            out.print("{\"exists\": false}");
            out.flush();
            return;
        }

        try {
            ContractDAO dao = new ContractDAO();
            boolean exists = dao.checkContractCodeExists(contractCode.trim());

            out.print("{\"exists\": " + exists + "}");

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"exists\": false, \"error\": \"" + e.getMessage() + "\"}");
        }

        out.flush();
    }
}
