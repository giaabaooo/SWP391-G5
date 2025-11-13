package dal;

import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public abstract class DBContext implements AutoCloseable {

    protected Connection connection;
    private boolean externalConnection = false;

    public DBContext() {
        try {
            // Thông tin kết nối MySQL
            String user = "root";
            String pass = "123456";
            String url = "jdbc:mysql://127.0.0.1:3306/crm_device_management?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=Asia/Ho_Chi_Minh";

            // Load MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Tạo connection
            connection = DriverManager.getConnection(url, user, pass);
            this.externalConnection = false;
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, "MySQL Driver not found.", ex);
        } catch (SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, "Connection failed.", ex);
        }
    }

    public Connection getConnection() {
        return this.connection;
    }

    public void setConnection(Connection connection) {
        this.connection = connection;
        this.externalConnection = true;
    }

    @Override
    public void close() {
        if (connection != null && !externalConnection) {
            try {
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, "Error closing connection.", ex);
            } finally {
                connection = null;
            }
        }
    }
}
