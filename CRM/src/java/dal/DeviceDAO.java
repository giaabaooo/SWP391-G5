package dal;

import data.Devices;
import java.sql.*;
import java.util.*;

public class DeviceDAO extends DBContext {
    public List<Devices> getDevicesByUserId(int userId) {
        List<Devices> list = new ArrayList<>();
        String sql = "SELECT d.id AS device_id, dd.id AS device_detail_id, " +
                     "p.name AS productName, p.image_url, dd.serial_number, " +
                     "dd.warranty_expiration, dd.status " +
                     "FROM Device d " +
                     "JOIN Product p ON d.product_id = p.id " +
                     "JOIN DeviceDetail dd ON d.id = dd.device_id " +
                     "WHERE d.user_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Devices device = new Devices();
                device.setDeviceId(rs.getInt("device_id"));
                device.setDeviceDetailId(rs.getInt("device_detail_id"));
                device.setProductName(rs.getString("productName"));
                device.setImageUrl(rs.getString("image_url"));
                device.setSerialNumber(rs.getString("serial_number"));
                device.setWarrantyExpiration(rs.getDate("warranty_expiration"));
                device.setStatus(rs.getString("status"));
                list.add(device);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
