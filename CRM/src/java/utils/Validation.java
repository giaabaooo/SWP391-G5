package utils;

import java.util.regex.Pattern;
import java.util.regex.Matcher;

public class Validation {

    // Validate Password: Must have at least 8 characters, including uppercase, lowercase, numbers, and special characters
    public static boolean checkPassWord(String password) {
        String regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$";
        return Pattern.matches(regex, password);
    }

    public static boolean checkPhoneNum(String phone) {
        String regex = "^(\\+84|84|0)[35789][0-9]{8}$";
        return Pattern.matches(regex, phone);
    }

    public static String normalizeVietnamesePhone(String phone) {
        if (phone == null) {
            return null;
        }
        if (phone.startsWith("+84")) {
            return "0" + phone.substring(3);
        }
        if (phone.startsWith("84")) {
            return "0" + phone.substring(2);
        }
        return phone;
    }
}
