package dal;

import data.Permission;
import data.User;
import data.Role;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.security.SecureRandom;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

public class UserDBContext extends DBContext {

    // Lấy user theo username + password (login)
    public User checkLogin(String username, String password) {
        String sql = "SELECT u.*, r.id AS role_id, r.name AS role_name, r.description AS role_desc, r.is_active AS role_active "
                + "FROM User u INNER JOIN Role r ON u.role_id = r.id "
                + "WHERE u.username=? AND u.password=? AND u.is_active=1";

        try (
                PreparedStatement stmt = connection.prepareStatement(sql)) {

            var a = hashPassword("123");
            var hashPass = hashPassword(password);

            stmt.setString(1, username);
            stmt.setString(2, hashPass);

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

                Set<String> permissions = getUserPermissions(user.getRole().getId(), user.getId());
                user.setPermissions(permissions);

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

    public Role getRoleById(int id) {
        String sql = "SELECT * FROM role where id = ? and is_active = 1";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                Role r = new Role();

                r.setId(rs.getInt("id"));
                r.setName(rs.getString("name"));
                r.setDescription("description");
                r.setIsActive(true);

                return r;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void insert(User u) {
        String sql = "INSERT INTO `crm_device_management`.`user` (username,password,full_name,email,phone,address,role_id,is_active) VALUES(?,?,?,?,?,?,?,?)";
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
        String sql = "UPDATE `crm_device_management`.`user` SET username=?, full_name=?, email=?, phone=?, address=?, role_id=?, is_active=? WHERE id=?";
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

    public ArrayList<User> getAllActiveCustomers() {
        ArrayList<User> users = new ArrayList<>();
        String sql = "SELECT u.id, u.full_name, u.email "
                + "FROM User u INNER JOIN Role r ON u.role_id = r.id "
                + "WHERE r.name = 'Customer' AND u.is_active = 1 "
                + "ORDER BY u.full_name ASC";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                users.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }

    public ArrayList<User> listCustomers(int page, int pageSize, String keyword, String status, String sort) {
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
        String orderBy = "u.username ASC";
        if (sort != null) {
            switch (sort) {
                case "username_asc":
                    orderBy = "u.username ASC";
                    break;
                case "username_desc":
                    orderBy = "u.username DESC";
                    break;
                case "fullname_asc":
                    orderBy = "u.full_name ASC";
                    break;
                case "fullname_desc":
                    orderBy = "u.full_name DESC";
                    break;
                case "email_asc":
                    orderBy = "u.email ASC";
                    break;
                case "email_desc":
                    orderBy = "u.email DESC";
                    break;
                case "phone_asc":
                    orderBy = "u.phone ASC";
                    break;
                case "phone_desc":
                    orderBy = "u.phone DESC";
                    break;
            }
        }
        sql += " ORDER BY " + orderBy + " LIMIT ? OFFSET ?";
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

    public void toggleCustomerStatus(int id) {
        String sql = "UPDATE User SET is_active = NOT is_active WHERE id=?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            stm.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public String generateRandomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#$%&!";
        SecureRandom random = new SecureRandom();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < length; i++) {
            int index = random.nextInt(chars.length());
            sb.append(chars.charAt(index));
        }
        return sb.toString();
    }

    public void sendEmailForNewUser(String toEmail, String username, String password) {
        final String fromEmail = "ducnmhe172104@fpt.edu.vn";
        final String appPassword = "zkqa szgs ucqr chws";

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "465");
        props.put("mail.smtp.ssl.enable", "true");

        Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, appPassword);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("CRM Account Created Successfully");

            String body = "Xin chao " + username + ",\n\n"
                    + "Tai khoan CRM cua ban da duoc tao thanh cong.\n"
                    + "Duoi day la thong tin dang nhap :\n\n"
                    + "Username: " + username + "\n"
                    + "Password: " + password + "\n\n"
                    + "Vui long dang nhap va doi mat khau.\n\n"
                    + "Tran trong,\nCRM Admin Team";

            message.setText(body);

            Transport.send(message);
            System.out.println("Email sent successfully to " + toEmail);

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    public String hashPassword(String password) {
        try {
            java.security.MessageDigest md = java.security.MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void updateUserProfile(int userId, String fullName, String phone, String address) {
        String sql = "UPDATE user SET full_name=?, phone=?, address=? WHERE id=?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, fullName);
            stm.setString(2, phone);
            stm.setString(3, address);
            stm.setInt(4, userId);
            stm.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean changePassword(int userId, String newHashedPassword) {
        String sql = "UPDATE user SET password=? WHERE id=?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, newHashedPassword);
            stm.setInt(2, userId);
            return stm.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public ArrayList<Permission> getAllPermissions() {
        ArrayList<Permission> permissions = new ArrayList<>();
        String sql = "SELECT id, name, description FROM Permission WHERE is_active = 1 ORDER BY name";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Permission p = new Permission();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setDescription(rs.getString("description"));
                permissions.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return permissions;
    }

    public Set<String> getRolePermissionMatrix() {
        Set<String> matrix = new HashSet<>();
        String sql = "SELECT role_id, permission_id FROM Role_Permission";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                String key = rs.getInt("role_id") + "_" + rs.getInt("permission_id");
                matrix.add(key);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return matrix;
    }

    public boolean updateFullPermissionMatrix(String[] allCheckedPerms) {
        String deleteSql = "DELETE FROM Role_Permission";
        String insertSql = "INSERT INTO Role_Permission (role_id, permission_id) VALUES (?, ?)";

        try {
            connection.setAutoCommit(false);

            try (PreparedStatement stmDelete = connection.prepareStatement(deleteSql)) {
                stmDelete.executeUpdate();
            }

            if (allCheckedPerms != null && allCheckedPerms.length > 0) {
                try (PreparedStatement stmInsert = connection.prepareStatement(insertSql)) {
                    for (String checkedValue : allCheckedPerms) {
                        String[] parts = checkedValue.split("_");
                        if (parts.length == 2) {
                            int roleId = Integer.parseInt(parts[0]);
                            int permId = Integer.parseInt(parts[1]);

                            stmInsert.setInt(1, roleId);
                            stmInsert.setInt(2, permId);
                            stmInsert.addBatch();
                        }
                    }
                    stmInsert.executeBatch();
                }
            }

            connection.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public Set<String> getUserPermissions(int roleId, int userId) {
        Set<String> permissions = new HashSet<>();

        String roleSql = "SELECT p.name FROM Permission p "
                + "JOIN Role_Permission rp ON p.id = rp.permission_id "
                + "WHERE rp.role_id = ?";
        try (PreparedStatement stm = connection.prepareStatement(roleSql)) {
            stm.setInt(1, roleId);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                permissions.add(rs.getString("name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        String userSql = "SELECT p.name, up.is_granted FROM Permission p "
                + "JOIN User_Permission up ON p.id = up.permission_id "
                + "WHERE up.user_id = ?";
        try (PreparedStatement stm = connection.prepareStatement(userSql)) {
            stm.setInt(1, userId);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                String permissionName = rs.getString("name");
                boolean isGranted = rs.getBoolean("is_granted");

                if (isGranted) {
                    permissions.add(permissionName);
                } else {
                    permissions.remove(permissionName);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return permissions;
    }

    public ArrayList<User> getAllActiveUsers() {
        ArrayList<User> users = new ArrayList<>();
        String sql = "SELECT u.id, u.username, u.full_name, r.name as role_name "
                + "FROM User u JOIN Role r ON u.role_id = r.id "
                + "WHERE u.is_active = 1 ORDER BY u.full_name";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setFullName(rs.getString("full_name"));

                Role r = new Role();
                r.setName(rs.getString("role_name"));
                u.setRole(r);

                users.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }

    public ArrayList<User> getFilteredActiveUsers(String keyword, String roleIdStr) {
        ArrayList<User> users = new ArrayList<>();

        String sql = "SELECT u.id, u.username, u.full_name, r.name as role_name "
                + "FROM User u JOIN Role r ON u.role_id = r.id "
                + "WHERE u.is_active = 1";

        ArrayList<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (u.username LIKE ? OR u.full_name LIKE ?)";
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }

        if (roleIdStr != null && !roleIdStr.trim().isEmpty()) {
            try {
                int roleId = Integer.parseInt(roleIdStr);
                sql += " AND u.role_id = ?";
                params.add(roleId);
            } catch (NumberFormatException e) {
            }
        }

        sql += " ORDER BY u.full_name";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                stm.setObject(i + 1, params.get(i));
            }

            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setFullName(rs.getString("full_name"));

                Role r = new Role();
                r.setName(rs.getString("role_name"));
                u.setRole(r);

                users.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }

    public Map<Integer, Boolean> getUserOverrides(int userId) {
        Map<Integer, Boolean> overrides = new HashMap<>();
        String sql = "SELECT permission_id, is_granted FROM User_Permission WHERE user_id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, userId);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                overrides.put(rs.getInt("permission_id"), rs.getBoolean("is_granted"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return overrides;
    }

    public boolean updateUserOverrides(int userId, Map<Integer, Boolean> overrides) {
        String deleteSql = "DELETE FROM User_Permission WHERE user_id = ?";
        String insertSql = "INSERT INTO User_Permission (user_id, permission_id, is_granted) VALUES (?, ?, ?)";

        try {
            connection.setAutoCommit(false);

            try (PreparedStatement stmDelete = connection.prepareStatement(deleteSql)) {
                stmDelete.setInt(1, userId);
                stmDelete.executeUpdate();
            }

            if (overrides != null && !overrides.isEmpty()) {
                try (PreparedStatement stmInsert = connection.prepareStatement(insertSql)) {
                    for (Map.Entry<Integer, Boolean> entry : overrides.entrySet()) {
                        stmInsert.setInt(1, userId);
                        stmInsert.setInt(2, entry.getKey());
                        stmInsert.setBoolean(3, entry.getValue());
                        stmInsert.addBatch();
                    }
                    stmInsert.executeBatch();
                }
            }

            connection.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    public boolean isUsernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM User WHERE username = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM User WHERE email = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean createUser(User user) {
        // ID Role 'CUSTOMER' là 6 (dựa theo DB dump của bạn)
        String sql = "INSERT INTO User (role_id, username, password, full_name, email, phone, address, is_active) "
                   + "VALUES (6, ?, ?, ?, ?, ?, ?, 1)";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            
            // Dùng hàm hashPassword CÓ SẴN trong file này
            String hashedPassword = hashPassword(user.getPassword()); 
            
            ps.setString(2, hashedPassword); // Lưu mật khẩu đã HASH
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPhone());
            ps.setString(6, user.getAddress());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
