package dal;

import java.sql.PreparedStatement;
import java.sql.SQLException;

public class GuestContactDAO extends DBContext {

    /**
     * Lưu tin nhắn của khách vãng lai vào database.
     * @param fullName Tên đầy đủ
     * @param email Email
     * @param phone Số điện thoại (có thể null)
     * @param message Nội dung tin nhắn
     * @return true nếu lưu thành công, false nếu thất bại
     */
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