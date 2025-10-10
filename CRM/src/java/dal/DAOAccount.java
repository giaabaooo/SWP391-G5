package dal;

import data.Account;
import java.sql.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DAOAccount – Dùng cho bảng `user` trong database `crm_device_management`
 */
public class DAOAccount extends DBContext {

    // ----------------------- UPDATE STATUS -----------------------
    public int disableAccount(Account acc) {
        int n = 0;
        String sql = "UPDATE user SET is_active = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, acc.isStatus() ? 1 : 0);
            ps.setInt(2, acc.getAccountID());
            n = ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(DAOAccount.class.getName()).log(Level.SEVERE, null, ex);
        }
        return n;
    }

    // ----------------------- LOGIN CHECK -----------------------
    public Account getCustomerByEmailAndPassword(String email, String password) {
        Account customer = null;
        String sql = "SELECT * FROM user WHERE email = ? AND password = ? AND is_active = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                customer = extractAccount(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOAccount.class.getName()).log(Level.SEVERE, null, ex);
        }
        return customer;
    }

    // ----------------------- CHECK EMAIL EXISTS -----------------------
    public boolean isEmailExist(String email) {
        String sql = "SELECT 1 FROM user WHERE email = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException ex) {
            Logger.getLogger(DAOAccount.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // ----------------------- GET PASSWORD -----------------------
    public String getPassword(int userId) {
        String password = null;
        String sql = "SELECT password FROM user WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                password = rs.getString("password");
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOAccount.class.getName()).log(Level.SEVERE, null, ex);
        }
        return password;
    }

    // ----------------------- UPDATE PASSWORD -----------------------
    public int updatePassword(int userId, String newPass) {
        int n = 0;
        String sql = "UPDATE user SET password = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newPass);
            ps.setInt(2, userId);
            n = ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(DAOAccount.class.getName()).log(Level.SEVERE, null, ex);
        }
        return n;
    }

    // ----------------------- RESET PASSWORD BY EMAIL -----------------------
    public int resetPasswordByEmail(String email, String newPass) {
        int n = 0;
        String sql = "UPDATE user SET password = ? WHERE email = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newPass);
            ps.setString(2, email);
            n = ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(DAOAccount.class.getName()).log(Level.SEVERE, null, ex);
        }
        return n;
    }

    // ----------------------- GET USER BY EMAIL -----------------------
    public Account getAccountByEmail(String email) {
        String sql = "SELECT * FROM user WHERE email = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return extractAccount(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOAccount.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    // ----------------------- LOGIN -----------------------
    public Account AccountLogin(String email, String password) {
        Account user = null;
        String sql = "SELECT * FROM user WHERE email = ? AND password = ? AND is_active = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = extractAccount(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOAccount.class.getName()).log(Level.SEVERE, null, ex);
        }
        return user;
    }

    // ----------------------- GET ALL USERS -----------------------
    public List<Account> getAllUsers() {
        List<Account> list = new ArrayList<>();
        String sql = "SELECT * FROM user";
        try (Statement st = connection.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(extractAccount(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOAccount.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // ----------------------- UPDATE PROFILE -----------------------
    public int updateUser(Account acc) {
        int n = 0;
        String sql = "UPDATE user SET full_name=?, phone=?, address=? WHERE id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, acc.getName());
            ps.setString(2, acc.getPhoneNum());
            ps.setString(3, acc.getAddress());
            ps.setInt(4, acc.getAccountID());
            n = ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(DAOAccount.class.getName()).log(Level.SEVERE, null, ex);
        }
        return n;
    }

    // ----------------------- SUPPORT METHOD -----------------------
    private Account extractAccount(ResultSet rs) throws SQLException {
        Account acc = new Account();
        acc.setAccountID(rs.getInt("id"));
        acc.setName(rs.getString("full_name"));
        acc.setEmail(rs.getString("email"));
        acc.setPassword(rs.getString("password"));
        acc.setPhoneNum(rs.getString("phone"));
        acc.setAddress(rs.getString("address"));
        acc.setStatus(rs.getBoolean("is_active"));
               return acc;
    }

    // ----------------------- TEST MAIN -----------------------
    public static void main(String[] args) {
        DAOAccount dao = new DAOAccount();

        // Kiểm tra email tồn tại
        String email = "user1@example.com";
        System.out.println("Email tồn tại? " + dao.isEmailExist(email));

        // Kiểm tra login
        Account a = dao.AccountLogin(email, "123");
        if (a != null) {
            System.out.println("Đăng nhập thành công: " + a.getName());
        } else {
            System.out.println("Đăng nhập thất bại!");
        }
    }
}
