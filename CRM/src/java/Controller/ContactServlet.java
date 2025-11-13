package Controller;

import dal.GuestContactDAO;
import java.io.IOException;
// import java.io.PrintWriter; 
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.EmailTemplate;
import utils.EmailUtility;

public class ContactServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 1. Lấy dữ liệu từ form
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String message = request.getParameter("message");

        try {
            if (fullName == null || fullName.trim().isEmpty()
                    || email == null || email.trim().isEmpty()
                    || message == null || message.trim().isEmpty()) {

                throw new Exception("Please fill in all required fields.");
            }

            GuestContactDAO dao = new GuestContactDAO();
            boolean success = dao.saveContactMessage(fullName, email, phone, message);

            if (success) {
                request.setAttribute("success", "Thank you! Your message has been sent. We will contact you shortly.");

                try {
                    String emailSubject = "We have received your contact request - CRM System";
                    String emailBody = EmailTemplate.getContactConfirmationHtml(fullName);
                    EmailUtility.sendEmail(email, emailSubject, emailBody);

                } catch (Exception emailEx) {
                    emailEx.printStackTrace();
                    System.out.println("Error sending confirmation email: " + emailEx.getMessage());
                }
            } else {
                throw new Exception("Error! Could not save message to database.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", e.getMessage());
        }
        request.getRequestDispatcher("/landing_page.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/landing_page.jsp");
    }
}
