package dal;

import data.User;
import data.Role;
import java.sql.*;
import java.util.ArrayList;

public class UserDBContext extends DBContext {

    // Lấy user theo username + password (login)
    public User checkLogin(String username, String password) {
        String sql = "SELECT u.*, r.id AS role_id, r.name AS role_name, r.description AS role_desc, r.is_active AS role_active " +
                     "FROM User u INNER JOIN Role r ON u.role_id = r.id " +
                     "WHERE u.username=? AND u.password=? AND u.is_active=1";

        try (
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Role role = new Role();
                role.setId(rs.getInt("role_id"));
                role.setName(rs.getString("role_name"));
                role.setDescription(rs.getString("role_desc"));
                role.setIsActive(rs.getBoolean("role_active"));

                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password")); // đã là MD5
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address"));
                user.setIsActive(rs.getBoolean("is_active"));
                user.setRole(role);

                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
