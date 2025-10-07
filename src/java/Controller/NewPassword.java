/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dal.DAOAccount;
import java.sql.PreparedStatement;
import utils.Validation;

/**
 *
 * @author pdatt
 */
@WebServlet(name = "NewPassword", urlPatterns = {"/newpassword"})
public class NewPassword extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        String newPassword = request.getParameter("password");
        String rePassword = request.getParameter("repassword");
        
        if (!newPassword.equals(rePassword)) {
            request.setAttribute("mess", "Your password does not match.");
            request.getRequestDispatcher("newPassword.jsp").forward(request, response);
            return;
        }
        
        if (!Validation.checkPassWord(newPassword)){
             request.setAttribute("mess", "Password must have at least 6 characters, including uppercase letters, lowercase letters, and special characters");
                request.getRequestDispatcher("newPassword.jsp").forward(request, response);
                return;
            }
        
        try {
            String mail = (String) session.getAttribute("email");
            DAOAccount dao = new DAOAccount();
            int result = dao.resetPasswordByEmail(mail, newPassword);
            if (result > 0) {
                request.setAttribute("mess", "Reset successfully!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else { 
                request.setAttribute("mess", "Reset password failed!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mess", "An error occurred while resetting password.");
            request.getRequestDispatcher("newPassword.jsp").forward(request, response);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
