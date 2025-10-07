/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import data.Account;
import dal.DBContext;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author pdatt
 */
public class DAOAccount extends DBContext {

    
    public int disableAccount(Account acc){
        int n = 0;
        String sql = "Update Account set Status = ? Where AccountID = ?";
        PreparedStatement ps;
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1,(acc.isStatus() == true ? 1 : 0));
            ps.setInt(2, acc.getAccountID());   
            n = ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(DAOAccount.class.getName()).log(Level.SEVERE, null, ex);
        }
        return n;
    }
    
    
    public Account getCustomerByEmailAndPassword(String email, String password) {
        Account customer = null;
        String sql = "SELECT * FROM Account WHERE Email = ? AND Password = ?";
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, email);
            statement.setString(2, password);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                customer = new Account();
                customer.setAccountID(resultSet.getInt("AccountID"));
                customer.setName(resultSet.getString("Name"));
                customer.setEmail(resultSet.getString("Email"));
                customer.setPassword(resultSet.getString("Password"));
                customer.setPhoneNum(resultSet.getString("PhoneNum"));
                customer.setAddress(resultSet.getString("Address"));
                customer.setYearOfBirth(resultSet.getInt("YearOfBirth"));
                customer.setStatus(resultSet.getBoolean("Status"));
                customer.setGender(resultSet.getString("Gender"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOAccount.class.getName()).log(Level.SEVERE, null, ex);
        }
        return customer;
    }

    public boolean isPhoneExist(String phone) {
        try {
            String sql = "SELECT * FROM Account WHERE PhoneNum = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, phone);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return true; // Email already exists
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false; // Email does not exist
    }

    public String getPassword(int cid) {
        String password = null;
        String sql = "SELECT Password FROM Account WHERE AccountID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, cid);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    password = rs.getString("Password");
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOAccount.class.getName()).log(Level.SEVERE, "Lỗi khi lấy mật khẩu: " + ex.getMessage(), ex);
        }

        return password;
    }

    public int updatePassword(int cid, String newPass) {
        int n = 0;
        String sql = "UPDATE Account SET Password = ? WHERE AccountID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newPass); // Nếu có bcrypt, dùng BCrypt.hashpw(newPass, BCrypt.gensalt())
            ps.setInt(2, cid);
            n = ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(DAOAccount.class.getName()).log(Level.SEVERE, "Lỗi khi cập nhật mật khẩu: " + ex.getMessage(), ex);
        }
        return n;
    }

    public Account getAccountById(int id) {
        String sql = "SELECT A.AccountID, A.Name, A.Email, A.Password, A.PhoneNumber, A.Address, "
                + "A.YearOfBirth, A.Gender, A.LoyaltyPoint, A.MembershipLevel, A.Status, A.Role, "
                + "I.ImageID, I.ImagePath "
                + "FROM Account A "
                + "LEFT JOIN Image I ON A.Avatar = I.ImageID "
                + "WHERE A.AccountID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                
                return new Account(
                        rs.getInt("AccountID"),
                        rs.getString("Name"),
                        rs.getString("Email"),
                        rs.getString("Password"),
                        rs.getString("PhoneNumber"),
                        rs.getString("Address"),
                        rs.getInt("YearOfBirth"),
                        rs.getString("Gender"),
                        
                        rs.getInt("LoyaltyPoint"),
                        rs.getString("MembershipLevel"),
                        rs.getBoolean("Status"),
                        rs.getString("Role")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean isEmailExist(String email) {
        try {
            String sql = "SELECT * FROM Account WHERE email = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int updateCustomer(Account acc) {
        int result = 0;
        String sql = "UPDATE Account SET Name=?, PhoneNum=?, Address=?, YearOfBirth=? ,Gender=? WHERE AccountID=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, acc.getName());
            ps.setString(2, acc.getPhoneNum());
            ps.setString(3, acc.getAddress());
            ps.setInt(4, acc.getYearOfBirth());
            ps.setString(5, acc.getGender());
            ps.setInt(6, acc.getAccountID());

            result = ps.executeUpdate();
            System.out.println("Update executed, affected rows: " + result);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public int updateAvatar(int accountID, int ImageID) {
        int result = 0;
        String sql = "UPDATE Account SET Avatar=? WHERE AccountID=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, ImageID);
            ps.setInt(2, accountID);

            result = ps.executeUpdate();
            System.out.println("Update executed, affected rows: " + result);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public int createAccount(Account customer) {
        int affectedRow = 0;
        String sql = "INSERT INTO Account (Name, Email, Password, PhoneNumber, Address, YearOfBirth, Status, Role, Gender) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, customer.getName());
            preparedStatement.setString(2, customer.getEmail());
            preparedStatement.setString(3, customer.getPassword());
            preparedStatement.setString(4, customer.getPhoneNum());
            preparedStatement.setString(5, customer.getAddress());
            preparedStatement.setInt(6, customer.getYearOfBirth());
            preparedStatement.setBoolean(7, customer.isStatus());
            preparedStatement.setString(8, customer.getRole());
            preparedStatement.setString(9, customer.getGender());
            affectedRow = preparedStatement.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return affectedRow;
    }

    public Account AccountLogin(String email, String password) {
        Account customer = null;
        String sql = "SELECT * FROM Account WHERE Email = ? AND Password = ?";
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, email);
            statement.setString(2, password);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                customer = new Account();
                customer.setAccountID(resultSet.getInt("AccountID"));
                customer.setName(resultSet.getString("Name"));
                customer.setEmail(resultSet.getString("Email"));
                customer.setPassword(resultSet.getString("Password"));
                customer.setPhoneNum(resultSet.getString("PhoneNumber"));
                customer.setAddress(resultSet.getString("Address"));
                customer.setYearOfBirth(resultSet.getInt("YearOfBirth"));
                customer.setStatus(resultSet.getBoolean("Status"));
                customer.setRole(resultSet.getString("Role"));
                customer.setGender(resultSet.getString("Gender"));
                customer.setLoyaltyPoint(resultSet.getInt("LoyaltyPoint"));
                customer.setMembershipLevel(resultSet.getString("MembershipLevel"));
                int imageId = resultSet.getInt("Avatar");
                            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOAccount.class.getName()).log(Level.SEVERE, null, ex);
        }
        return customer;
    }

    public Account getAccountByEmail(String email) {
        String sql = "SELECT Email FROM Account WHERE Email = ?";
        PreparedStatement preparedStatement;
        try {
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, email);
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                return new Account(resultSet.getInt(1),
                        resultSet.getString(2),
                        resultSet.getString(3),
                        resultSet.getString(4),
                        resultSet.getString(5),
                        resultSet.getString(6),
                        resultSet.getInt(7), true,
                        resultSet.getString(8),
                        resultSet.getString(9));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    public int resetPasswordByEmail(String mail, String newPass) {
        int n = 0;
        String sql = "UPDATE Account SET Password = ? WHERE Email = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newPass); // Nếu có bcrypt, dùng BCrypt.hashpw(newPass, BCrypt.gensalt())
            ps.setString(2, mail);
            n = ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(DAOAccount.class.getName()).log(Level.SEVERE, "Lỗi khi cập nhật mật khẩu: " + ex.getMessage(), ex);
        }
        return n;
    }
    
    public List<Account> getAllCustomers(String sql) {
    List<Account> customerList = new ArrayList<>();
    
    Statement state;
    ResultSet rs = null;

    try {
        state = connection.createStatement();
        rs = state.executeQuery(sql);
        
        while (rs.next()) {
            
            int accountID = rs.getInt("accountID");
            String Name = rs.getString("Name");
            String Email = rs.getString("Email");
            String Password = rs.getString("Password");
            String PhoneNumber = rs.getString("PhoneNumber");
            String Address = rs.getString("Address");
            int YearOfBirth = rs.getInt("YearOfBirth");
            String Gender = rs.getString("Gender");
            int LoyaltyPoint = rs.getInt("LoyaltyPoint");
            String MembershipLevel = rs.getString("MembershipLevel");
            boolean Status = rs.getBoolean("Status");
            String Role = rs.getString("Role");
            int AvatarID = rs.getInt("Avatar");
            
            

            // Tạo đối tượng Account và thêm vào danh sách
            Account account = new Account(accountID, Name, Email, Password, PhoneNumber, Address, YearOfBirth, Gender, LoyaltyPoint,MembershipLevel, Status, Role, AvatarID);
            customerList.add(account);
        }
    } catch (SQLException ex) {
        Logger.getLogger(DAOAccount.class.getName()).log(Level.SEVERE, null, ex);
    } finally {
        try {
            if (rs != null) rs.close();
        } catch (SQLException ex) {
            Logger.getLogger(DAOAccount.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    return customerList;
}

    
    

    public static void main(String[] args) {
        DAOAccount dao = new DAOAccount();
//    int accountId = 1; // ID của tài khoản cần lấy thông tin
//
//    Account account = dao.getAccountById(accountId);
//    
//    if (account != null) {
//        System.out.println("Thông tin tài khoản:");
//        System.out.println("ID: " + account.getAccountID());
//        System.out.println("Tên: " + account.getName());
//        System.out.println("Email: " + account.getEmail());
//        System.out.println("Số điện thoại: " + account.getPhoneNum());
//        System.out.println("Địa chỉ: " + account.getAddress());
//        System.out.println("Năm sinh: " + account.getYearOfBirth());
//        System.out.println("Giới tính: " + account.getGender());
//        System.out.println("Điểm thưởng: " + account.getLoyaltyPoint());
//        System.out.println("Cấp độ thành viên: " + account.getMembershipLevel());
//        System.out.println("Trạng thái: " + (account.isStatus() ? "Hoạt động" : "Bị khóa"));
//        System.out.println("Vai trò: " + account.getRole());
//
//        // Kiểm tra và hiển thị ảnh đại diện nếu có
//        if (account.getAvatar() != null) {
//            System.out.println("Avatar ID: " + account.getAvatar().getImageID());
//            System.out.println("Đường dẫn Avatar: " + account.getAvatar().getImagePath());
//        } else {
//            System.out.println("Avatar: Không có");
//        }
//    } else {
//        System.out.println("Không tìm thấy tài khoản với ID: " + accountId);
//    }


//        String email = "john.doe@example.com";
//        String password = "password123";
//
//        // Gọi phương thức AccountLogin
//        Account account = dao.AccountLogin(email, password);
//
//        // Kiểm tra kết quả đăng nhập và in ra thông tin nếu đăng nhập thành công
//        if (account != null) {
//            System.out.println("Đăng nhập thành công!");
//            System.out.println("Account ID: " + account.getAccountID());
//            System.out.println("Name: " + account.getName());
//            System.out.println("Email: " + account.getEmail());
//            System.out.println("Gender: " + account.getGender());
//            System.out.println("Phone: " + account.getPhoneNum());
//            System.out.println("Address: " + account.getAddress());
//            System.out.println("Year Of Birth: " + account.getYearOfBirth());
//            System.out.println("Loyalty Point: " + account.getLoyaltyPoint());
//            System.out.println("Membership Level: " + account.getMembershipLevel());
//            // Nếu có avatar, bạn có thể in thêm thông tin liên quan
//            if (account.getAvatar() != null) {
//                System.out.println("Avatar Image ID: " + account.getAvatar().getImageID());
//                System.out.println("Avatar Image Path: " + account.getAvatar().getImagePath());
//            }
//        } else {
//            System.out.println("Đăng nhập thất bại: không tìm thấy tài khoản với thông tin đã cung cấp.");
//        }

    List<Account> list = dao.getAllCustomers("Select*from Account where Name like '%John%'");
    
    for(Account acc : list){
        System.out.println(acc);
    }
    }

}
