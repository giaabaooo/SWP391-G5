package dal;

import java.sql.PreparedStatement;
import java.sql.SQLException;

public class GuestContactDAO extends DBContext {

    public boolean saveContactMessage(String fullName, String email, String phone, String message) {
        String sql = """
            INSERT INTO GuestContact (full_name, email, phone, message, status) 
            VALUES (?, ?, ?, ?, 'NEW')
        """;       
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, message);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace(); 
            return false;
        }
    }
}