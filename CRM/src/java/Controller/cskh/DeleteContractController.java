package Controller.cskh;

import dal.ContractDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/cskh/deleteContract")
public class DeleteContractController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cskh/contract?error=missing_id");
            return;
        }

        try (ContractDAO contractDAO = new ContractDAO()) {
            int contractId = Integer.parseInt(idParam);
            
            contractDAO.deleteContractWithItems(contractId); 
            
            response.sendRedirect(request.getContextPath() + "/cskh/contract?message=deleted");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/cskh/contract?error=delete_failed");
        }
    }
}   