package Controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.UUID;

@WebServlet(name = "OTPController", urlPatterns = {"/otp"})
public class OTPController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            String otpStr = request.getParameter("otp");
            if (otpStr == null || otpStr.trim().isEmpty()) {
                request.setAttribute("mess", "OTP cannot be empty!");
                request.getRequestDispatcher("OTPConfirm.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession();
            Integer storedOtp = (Integer) session.getAttribute("otp");
            if (storedOtp == null) {
                request.setAttribute("mess", "OTP session expired. Please request a new OTP.");
                request.getRequestDispatcher("forgetPassword.jsp").forward(request, response);
                return;
            }

            int value = Integer.parseInt(otpStr);

            if (value == storedOtp) {
                String email = (String) session.getAttribute("email");
                if (email == null || email.trim().isEmpty()) {
                    request.setAttribute("mess", "Session expired. Please try again.");
                    request.getRequestDispatcher("forgetPassword.jsp").forward(request, response);
                    return;
                }

                String token = UUID.randomUUID().toString();

                session.setAttribute("resetToken", token);
                session.setAttribute("emailForReset", email);

                session.removeAttribute("otp");
                session.removeAttribute("email");

                response.sendRedirect("newpassword?token=" + token);

            } else {
                request.setAttribute("mess", "Invalid OTP. Please try again!");
                request.getRequestDispatcher("OTPConfirm.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("mess", "Invalid OTP format!");
            request.getRequestDispatcher("OTPConfirm.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mess", "An error occurred. Please try again.");
            request.getRequestDispatcher("OTPConfirm.jsp").forward(request, response);
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
        return "Short description";
    }
}
