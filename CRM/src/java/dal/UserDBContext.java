package dal;

import data.User;
import data.Role;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDBContext extends DBContext {

    // Lấy user theo username + password (login)
    public User checkLogin(String username, String password) {
        String sql = "SELECT u.*, r.id AS role_id, r.name AS role_name, r.description AS role_desc, r.is_active AS role_active "
                + "FROM User u INNER JOIN Role r ON u.role_id = r.id "
                + "WHERE u.username=? AND u.password=? AND u.is_active=1";

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

    public int countUser(String keyword, String role, String status) {
        String sql = "SELECT COUNT(*) FROM User u INNER JOIN Role r ON u.role_id = r.id WHERE 1=1";
        ArrayList<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (u.username LIKE ? OR u.email LIKE ?)";
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }
        if (role != null && !role.trim().isEmpty()) {
            sql += " AND r.name = ?";
            params.add(role);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql += " AND u.is_active = ?";
            params.add(status.equals("active") ? 1 : 0);
        }

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                stm.setObject(i + 1, params.get(i));
            }
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public ArrayList<User> list(int page, int pageSize, String keyword, String role, String status) {
        ArrayList<User> users = new ArrayList<>();
        String sql = "SELECT u.*, r.id AS role_id, r.name AS role_name, r.description AS role_desc "
                + "FROM User u INNER JOIN Role r ON u.role_id=r.id WHERE 1=1";
        ArrayList<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (u.username LIKE ? OR u.email LIKE ?)";
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }
        if (role != null && !role.trim().isEmpty()) {
            sql += " AND r.name = ?";
            params.add(role);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql += " AND u.is_active = ?";
            params.add(status.equals("active") ? 1 : 0);
        }

        sql += " LIMIT ? OFFSET ?";
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                stm.setObject(i + 1, params.get(i));
            }
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Role r = new Role();
                r.setId(rs.getInt("role_id"));
                r.setName(rs.getString("role_name"));
                r.setDescription(rs.getString("role_desc"));

                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setIsActive(rs.getBoolean("is_active"));
                u.setRole(r);

                users.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }

    public ArrayList<Role> getAllRoles() {
        ArrayList<Role> roles = new ArrayList<>();
        String sql = "SELECT id, name, description FROM Role WHERE is_active=1";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Role r = new Role();
                r.setId(rs.getInt("id"));
                r.setName(rs.getString("name"));
                r.setDescription(rs.getString("description"));
                roles.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return roles;
    }

    public User get(int id) {
        String sql = "SELECT u.*, r.id AS role_id, r.name AS role_name FROM User u INNER JOIN Role r ON u.role_id=r.id WHERE u.id=?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                Role r = new Role();
                r.setId(rs.getInt("role_id"));
                r.setName(rs.getString("role_name"));
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setAddress(rs.getString("address"));
                u.setIsActive(rs.getBoolean("is_active"));
                u.setRole(r);
                return u;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void insert(User u) {
        String sql = "INSERT INTO [User](username,password,full_name,email,phone,address,role_id,is_active) VALUES(?,?,?,?,?,?,?,?)";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, u.getUsername());
            stm.setString(2, u.getPassword());
            stm.setString(3, u.getFullName());
            stm.setString(4, u.getEmail());
            stm.setString(5, u.getPhone());
            stm.setString(6, u.getAddress());
            stm.setInt(7, u.getRole().getId());
            stm.setBoolean(8, u.isIsActive());
            stm.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void update(User u) {
        String sql = "UPDATE [User] SET username=?, full_name=?, email=?, phone=?, address=?, role_id=?, is_active=? WHERE id=?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, u.getUsername());
            stm.setString(2, u.getFullName());
            stm.setString(3, u.getEmail());
            stm.setString(4, u.getPhone());
            stm.setString(5, u.getAddress());
            stm.setInt(6, u.getRole().getId());
            stm.setBoolean(7, u.isIsActive());
            stm.setInt(8, u.getId());
            stm.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void delete(int id) {
        try (PreparedStatement stm = connection.prepareStatement("DELETE FROM [User] WHERE id=?")) {
            stm.setInt(1, id);
            stm.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public ArrayList<User> listCustomers(int page, int pageSize, String keyword, String status) {
    ArrayList<User> users = new ArrayList<>();
    String sql = "SELECT u.*, r.id AS role_id, r.name AS role_name, r.description AS role_desc "
               + "FROM User u INNER JOIN Role r ON u.role_id = r.id "
               + "WHERE r.name = 'Customer'";   // cố định chỉ lấy Customer
    ArrayList<Object> params = new ArrayList<>();

    if (keyword != null && !keyword.trim().isEmpty()) {
        sql += " AND (u.username LIKE ? OR u.email LIKE ?)";
        params.add("%" + keyword + "%");
        params.add("%" + keyword + "%");
    }
    if (status != null && !status.trim().isEmpty()) {
        sql += " AND u.is_active = ?";
        params.add(status.equals("active") ? 1 : 0);
    }

    sql += " LIMIT ? OFFSET ?";
    params.add(pageSize);
    params.add((page - 1) * pageSize);

    try (PreparedStatement stm = connection.prepareStatement(sql)) {
        for (int i = 0; i < params.size(); i++) {
            stm.setObject(i + 1, params.get(i));
        }
        ResultSet rs = stm.executeQuery();
        while (rs.next()) {
            Role r = new Role();
            r.setId(rs.getInt("role_id"));
            r.setName(rs.getString("role_name"));
            r.setDescription(rs.getString("role_desc"));

            User u = new User();
            u.setId(rs.getInt("id"));
            u.setUsername(rs.getString("username"));
            u.setFullName(rs.getString("full_name"));
            u.setEmail(rs.getString("email"));
            u.setPhone(rs.getString("phone"));
            u.setIsActive(rs.getBoolean("is_active"));
            u.setRole(r);

            users.add(u);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return users;
}


public int countCustomers(String keyword, String status) {
    String sql = "SELECT COUNT(*) "
               + "FROM User u "
               + "JOIN Role r ON u.role_id = r.id "
               + "WHERE r.name = 'Customer' ";

    if (keyword != null && !keyword.isEmpty()) {
        sql += " AND (u.username LIKE ? OR u.email LIKE ?)";
    }
    if (status != null && !status.isEmpty()) {
    sql += " AND u.is_active = ?";
}

    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        int idx = 1;
        if (keyword != null && !keyword.isEmpty()) {
            ps.setString(idx++, "%" + keyword + "%");
            ps.setString(idx++, "%" + keyword + "%");
        }
        if (status != null && !status.isEmpty()) {
    ps.setInt(idx++, status.equals("active") ? 1 : 0);
}

        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt(1);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return 0;
}

}
