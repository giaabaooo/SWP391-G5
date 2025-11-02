/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import data.CustomerRequest; // Import các model
import data.CustomerRequestMeta;
import data.Device;
import java.math.BigDecimal; // Import nếu bạn dùng (mặc dù code của bạn đang dùng double)
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author admin
 */
public class PaymentDAO extends DBContext {

    /**
     * Lấy thông tin chi tiết Bill để hiển thị trang thanh toán. (Sử dụng
     * getter/setter snake_case của model bạn cung cấp)
     */
    public CustomerRequest getRequestWithPaymentDetails(int requestId, int customerId) {
        CustomerRequest req = null;
        String sql = """
            SELECT cr.id, cr.title, cr.customer_id,cr.request_type, 
                   meta.total_cost, meta.paid_amount, meta.payment_status,
                   p.name AS product_name 
            FROM CustomerRequest cr
            JOIN CustomerRequestMeta meta ON cr.id = meta.request_id
            JOIN Device d ON cr.device_id = d.id
            JOIN ContractItem ci ON d.contract_item_id = ci.id
            JOIN Product p ON ci.product_id = p.id
            WHERE cr.id = ? AND cr.customer_id = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            ps.setInt(2, customerId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                req = new CustomerRequest();
                req.setId(rs.getInt("id"));
                req.setTitle(rs.getString("title"));
                req.setCustomer_id(rs.getInt("customer_id"));
                req.setRequest_type(rs.getString("request_type"));

                // Set thông tin device (chỉ tên)
                Device device = new Device();
                device.setProductName(rs.getString("product_name"));
                req.setDevice(device);

                CustomerRequestMeta meta = new CustomerRequestMeta();
                meta.setTotal_cost(rs.getDouble("total_cost"));
                meta.setPaid_amount(rs.getDouble("paid_amount"));
                meta.setPayment_status(rs.getString("payment_status"));

                req.setRequestMeta(meta); // Gán object Meta vào Request
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return req;
    }

    /**
     * Xử lý thanh toán (Transaction). Tự động cập nhật payment_status (UNPAID,
     * PARTIALLY_PAID, PAID) Sử dụng kiểu 'double' theo model của bạn.
     */
    public boolean processPayment(int requestId, double amountPaid) {
        
        PreparedStatement psLog = null;
        PreparedStatement psUpdateMeta = null;
        PreparedStatement psCheck = null;
        

        String sqlLog = "INSERT INTO Payment (request_id, amount, status, payment_date) VALUES (?, ?, 'COMPLETED', NOW())";
        String sqlUpdateMeta = "UPDATE CustomerRequestMeta SET paid_amount = paid_amount + ? WHERE request_id = ?";
        String sqlCheck = "SELECT total_cost, paid_amount FROM CustomerRequestMeta WHERE request_id = ?";

        try {
            connection.setAutoCommit(false);

            // 1. Ghi log vào bảng Payment
            psLog = connection.prepareStatement(sqlLog);
            psLog.setInt(1, requestId);
            psLog.setDouble(2, amountPaid);
            psLog.executeUpdate();

            // 2. Cập nhật paid_amount trong Meta
            psUpdateMeta = connection.prepareStatement(sqlUpdateMeta);
            psUpdateMeta.setDouble(1, amountPaid);
            psUpdateMeta.setInt(2, requestId);
            psUpdateMeta.executeUpdate();

            // 3. Lấy tổng nợ và tổng đã trả
            psCheck = connection.prepareStatement(sqlCheck);
            psCheck.setInt(1, requestId);
            ResultSet rs = psCheck.executeQuery();

            String newRequestStatus = "AWAITING_PAYMENT";
            String newPaymentStatus = "PARTIALLY_PAID";

            if (rs.next()) {
                double totalCost = rs.getDouble("total_cost");
                double paidAmount = rs.getDouble("paid_amount");

                // 4. Quyết định trạng thái mới (dùng 1 sai số nhỏ cho double)
                if (paidAmount >= (totalCost - 0.001)) {
                    newRequestStatus = "PAID"; // Hoặc "CLOSED" tùy bạn
                    newPaymentStatus = "PAID";
                }
            }

            // 5. Cập nhật trạng thái
            updatePaymentAndRequestStatus(connection, requestId, newRequestStatus, newPaymentStatus);

            connection.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            try {
                if (connection != null) {
                    connection.rollback();
                }
            } catch (SQLException ex) {
            }
            return false;
        } finally {
            // Đóng tất cả resources
            try {
                if (psLog != null) {
                    psLog.close();
                }
            } catch (SQLException e) {
            }
            try {
                if (psUpdateMeta != null) {
                    psUpdateMeta.close();
                }
            } catch (SQLException e) {
            }
            try {
                if (psCheck != null) {
                    psCheck.close();
                }
            } catch (SQLException e) {
            }
            try {
                if (connection != null) {
                    connection.setAutoCommit(true);
                    connection.close();
                }
            } catch (SQLException e) {
            }
        }
    }

    private void updatePaymentAndRequestStatus(Connection conn, int requestId, String requestStatus, String paymentStatus) throws SQLException {
        try (PreparedStatement psRequest = conn.prepareStatement("UPDATE CustomerRequest SET status = ? WHERE id = ?")) {
            psRequest.setString(1, requestStatus);
            psRequest.setInt(2, requestId);
            psRequest.executeUpdate();
        }

        try (PreparedStatement psMeta = conn.prepareStatement("UPDATE CustomerRequestMeta SET payment_status = ? WHERE request_id = ?")) {
            psMeta.setString(1, paymentStatus);
            psMeta.setInt(2, requestId);
            psMeta.executeUpdate();
        }
    }
}
