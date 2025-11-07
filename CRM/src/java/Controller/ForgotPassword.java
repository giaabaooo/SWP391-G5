package Controller;

import java.io.IOException;
import java.util.Random;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dal.DAOAccount;
import utils.EmailTemplate;
import utils.EmailUtility;

@WebServlet(name = "ForgotPassword", urlPatterns = {"/forgotpw"})
public class ForgotPassword extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String email = request.getParameter("email");
        DAOAccount dao = new DAOAccount();
        HttpSession httpSession = request.getSession();

        try {
            if (email == null || email.isEmpty()) {
                request.setAttribute("mess", "Please enter your email address!");
                request.getRequestDispatcher("forgetPassword.jsp").forward(request, response);
                return;
            }

            if (!dao.isEmailExist(email)) {
                request.setAttribute("mess", "This email is not registered! Please try another email!");
                request.getRequestDispatcher("forgetPassword.jsp").forward(request, response);
                return;
            }

            int otpValue = 100000 + new Random().nextInt(900000);

            String subject = "Password Reset OTP";
            String htmlContent = EmailTemplate.getOtpEmailHtml(String.valueOf(otpValue));
            EmailUtility.sendEmail(email, subject, htmlContent);
            long otpCreationTime = System.currentTimeMillis();

            EmailUtility.sendEmail(email, subject, htmlContent);

            httpSession.setAttribute("otp", otpValue);
            httpSession.setAttribute("email", email);
            httpSession.setAttribute("otpTime", otpCreationTime);
            request.setAttribute("mess", "OTP has been sent to your email.");
            request.getRequestDispatcher("OTPConfirm.jsp").forward(request, response);

        } catch (Exception e) {
            System.out.println("Error in ForgotPassword servlet: " + e.getMessage());
            e.printStackTrace();

            if (e instanceof jakarta.mail.MessagingException) {
                request.setAttribute("mess", "Failed to send email. Please check server configuration or try again later.");
            } else {
                request.setAttribute("mess", "An error occurred: " + e.getMessage());
            }
            request.getRequestDispatcher("forgetPassword.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("forgetPassword.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Handles password reset OTP generation and email sending.";
    }
}
