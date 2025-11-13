package utils;

public class EmailTemplate {

    public static String getOtpEmailHtml(String otp) {
        String htmlTemplate = "<!DOCTYPE html>"
            + "<html lang='vi'>"
            + "<head>"
            + "<meta charset='UTF-8'>"
            + "<title>Password Reset OTP</title>"
            + "<style>"
            + "  body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f4f4f4; }"
            + "  .container { width: 90%; max-width: 600px; margin: 20px auto; background-color: #ffffff; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); overflow: hidden; }"
            + "  .header { background-color: #007bff; color: #ffffff; padding: 30px 20px; text-align: center; }"
            + "  .header h1 { margin: 0; font-size: 24px; }"
            + "  .content { padding: 40px 30px; }"
            + "  .content p { font-size: 16px; color: #333333; line-height: 1.6; }"
            + "  .otp-code { font-size: 36px; font-weight: bold; color: #007bff; text-align: center; margin: 30px 0; letter-spacing: 5px; padding: 15px; background-color: #f0f8ff; border-radius: 5px; }"
            + "  .footer { background-color: #f9f9f9; color: #777777; padding: 20px 30px; text-align: center; font-size: 12px; border-top: 1px solid #eeeeee; }"
            + "  .footer p { margin: 5px 0; }"
            + "</style>"
            + "</head>"
            + "<body>"
            + "<div class='container'>"
            + "  <div class='header'>"
            + "    <h1>Password Reset Request</h1>"
            + "  </div>"
            + "  <div class='content'>"
            + "    <p>Hello,</p>"
            + "    <p>We received a request to reset your password. Please use the following One-Time Password (OTP) to complete the process. This OTP is valid for 10 minutes.</p>"
            + "    <div class='otp-code'>"
            + "      " + otp + ""
            + "    </div>"
            + "    <p>If you did not request this password reset, please ignore this email or contact our support team.</p>"
            + "    <p>Thank you,<br>The CRM Team</p>"
            + "  </div>"
            + "  <div class='footer'>"
            + "    <p>&copy; 2025 CRM System. All rights reserved.</p>"
            + "    <p>This is an automated message. Please do not reply.</p>"
            + "  </div>"
            + "</div>"
            + "</body>"
            + "</html>";

        return htmlTemplate;
    }    
    
    public static String getContactConfirmationHtml(String guestName) {
        String displayName = (guestName == null || guestName.trim().isEmpty()) ? "valued customer" : guestName;

        String htmlTemplate = "<!DOCTYPE html>"
            + "<html lang='vi'>"
            + "<head>"
            + "<meta charset='UTF-8'>"
            + "<title>Contact Received</title>"
            + "<style>"
            + "  body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f4f4f4; }"
            + "  .container { width: 90%; max-width: 600px; margin: 20px auto; background-color: #ffffff; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); overflow: hidden; }"
            + "  .header { background-color: #007bff; color: #ffffff; padding: 30px 20px; text-align: center; }"
            + "  .header h1 { margin: 0; font-size: 24px; }"
            + "  .content { padding: 40px 30px; }"
            + "  .content p { font-size: 16px; color: #333333; line-height: 1.6; }"
            + "  .footer { background-color: #f9f9f9; color: #777777; padding: 20px 30px; text-align: center; font-size: 12px; border-top: 1px solid #eeeeee; }"
            + "  .footer p { margin: 5px 0; }"
            + "</style>"
            + "</head>"
            + "<body>"
            + "<div class='container'>"
            + "  <div class='header'>"
            + "    <h1>Thank You For Your Message</h1>"
            + "  </div>"
            + "  <div class='content'>"
            + "    <p>Hello " + displayName + ",</p>"
            + "    <p>We have successfully received your contact message. Our team will review your request and get back to you as soon as possible.</p>"
            + "    <p>Thank you for your interest in our services.</p>"
            + "    <p>Best regards,<br>The CRM Team</p>"
            + "  </div>"
            + "  <div class='footer'>"
            + "    <p>&copy; 2025 CRM System. All rights reserved.</p>"
            + "    <p>This is an automated message. Please do not reply.</p>"
            + "  </div>"
            + "</div>"
            + "</body>"
            + "</html>";

        return htmlTemplate;
    }
}