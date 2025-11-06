package Controller;

import java.io.IOException;
import java.util.Properties;
import java.util.Random;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import dal.DAOAccount;

@WebServlet(name = "ForgotPassword", urlPatterns = {"/forgotpw"})
public class ForgotPassword extends HttpServlet {

    private final String fromEmail = "ducnmhe172104@fpt.edu.vn";
    private final String password = "zkqa szgs ucqr chws";

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

            int OTPValue = 100000 + new Random().nextInt(900000);
            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.debug", "true");

            Session mailSession = Session.getInstance(props, new jakarta.mail.Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(fromEmail, password);
                }
            });

            MimeMessage message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(fromEmail));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(email));
            message.setSubject("Password Reset OTP");
            message.setText("Your OTP for password reset is: " + OTPValue);

            Transport.send(message);
            httpSession.setAttribute("otp", OTPValue);
            httpSession.setAttribute("email", email);
            request.setAttribute("mess", "OTP has been sent to your email.");
            request.getRequestDispatcher("OTPConfirm.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("Error in ForgotPassword servlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("mess", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("forgetPassword.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
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
