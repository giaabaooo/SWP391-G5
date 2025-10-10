package utils;

import java.util.regex.Pattern;
import java.util.regex.Matcher;

public class Validation {

    // Validate Password: Must have at least 8 characters, including uppercase, lowercase, numbers, and special characters
    public static boolean checkPassWord(String password) {
        String regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$";
        return Pattern.matches(regex, password);
    }

    // Validate Vietnamese Phone Number: Starts with '84' or '0' followed by 3,5,7,8,9 and exactly 8 more digits
    public static boolean checkPhoneNum(String phone) {
        String regex = "^(84|0[35789])[0-9]{8}$";
        return Pattern.matches(regex, phone);
    }
}
