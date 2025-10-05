package dal;

import data.Devices;
import java.sql.*;
import java.util.*;

public class DeviceDAO extends DBContext {
    public List<Devices> getDevicesByUserId(
        int userId, String keyword, String brandFilter, String warrantyStatus, int offset, int limit) {

    List<Devices> list = new ArrayList<>();
    String sql = "SELECT d.id AS device_id, dd.id AS device_detail_id, " +
                 "p.name AS productName, p.image_url, dd.serial_number, " +
                 "dd.warranty_expiration, dd.status, b.name AS brandName " +
                 "FROM Device d " +
                 "JOIN Product p ON d.product_id = p.id " +
                 "JOIN Brand b ON p.brand_id = b.id " +
                 "JOIN DeviceDetail dd ON d.id = dd.device_id " +
                 "WHERE d.user_id = ? ";

    // search theo tên hoặc serial
    if (keyword != null && !keyword.isEmpty()) {
        sql += "AND (p.name LIKE ? OR dd.serial_number LIKE ?) ";
    }

    // filter theo hãng
    if (brandFilter != null && !brandFilter.equals("ALL")) {
        sql += "AND b.name = ? ";
    }

    // filter theo bảo hành
    if (warrantyStatus != null && !warrantyStatus.equals("ALL")) {
        if (warrantyStatus.equals("UNDER")) {
            sql += "AND dd.warranty_expiration >= CURDATE() ";
        } else if (warrantyStatus.equals("EXPIRED")) {
            sql += "AND dd.warranty_expiration < CURDATE() ";
        }
    }

    sql += "ORDER BY dd.warranty_expiration DESC LIMIT ? OFFSET ?";

    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        int index = 1;
        ps.setInt(index++, userId);

        if (keyword != null && !keyword.isEmpty()) {
            ps.setString(index++, "%" + keyword + "%");
            ps.setString(index++, "%" + keyword + "%");
        }

        if (brandFilter != null && !brandFilter.equals("ALL")) {
            ps.setString(index++, brandFilter);
        }

        ps.setInt(index++, limit);
        ps.setInt(index, offset);

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
            device.setBrandName(rs.getString("brandName"));
            list.add(device);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}
    
    public int countDevicesByUser(
        int userId, String keyword, String brandFilter, String warrantyStatus) {
    String sql = "SELECT COUNT(*) FROM Device d " +
                 "JOIN Product p ON d.product_id = p.id " +
                 "JOIN Brand b ON p.brand_id = b.id " +
                 "JOIN DeviceDetail dd ON d.id = dd.device_id " +
                 "WHERE d.user_id = ? ";

    if (keyword != null && !keyword.isEmpty()) {
        sql += "AND (p.name LIKE ? OR dd.serial_number LIKE ?) ";
    }
    if (brandFilter != null && !brandFilter.equals("ALL")) {
        sql += "AND b.name = ? ";
    }
    if (warrantyStatus != null && !warrantyStatus.equals("ALL")) {
        if (warrantyStatus.equals("UNDER")) {
            sql += "AND dd.warranty_expiration >= CURDATE() ";
        } else if (warrantyStatus.equals("EXPIRED")) {
            sql += "AND dd.warranty_expiration < CURDATE() ";
        }
    }

    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        int index = 1;
        ps.setInt(index++, userId);

        if (keyword != null && !keyword.isEmpty()) {
            ps.setString(index++, "%" + keyword + "%");
            ps.setString(index++, "%" + keyword + "%");
        }
        if (brandFilter != null && !brandFilter.equals("ALL")) {
            ps.setString(index++, brandFilter);
        }

        ResultSet rs = ps.executeQuery();
        if (rs.next()) return rs.getInt(1);
    } catch (Exception e) {
        e.printStackTrace();
    }
    return 0;
}
     public List<String> getAllBrands() {
    List<String> brands = new ArrayList<>();
    String sql = "SELECT name FROM Brand";
    try (PreparedStatement ps = connection.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            brands.add(rs.getString("name"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return brands;
}
public Devices getDeviceById(int deviceId) {
    String sql = "SELECT d.id AS device_id, dd.id AS device_detail_id, " +
                 "p.name AS productName, p.image_url, dd.serial_number, " +
                 "dd.warranty_expiration, dd.status, b.name AS brandName " +
                 "FROM Device d " +
                 "JOIN Product p ON d.product_id = p.id " +
                 "JOIN Brand b ON p.brand_id = b.id " +
                 "JOIN DeviceDetail dd ON d.id = dd.device_id " +
                 "WHERE d.id = ?";

    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, deviceId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                Devices device = new Devices();
                device.setDeviceId(rs.getInt("device_id"));
                device.setDeviceDetailId(rs.getInt("device_detail_id"));
                device.setProductName(rs.getString("productName"));
                device.setImageUrl(rs.getString("image_url"));
                device.setSerialNumber(rs.getString("serial_number"));
                device.setWarrantyExpiration(rs.getDate("warranty_expiration"));
                device.setStatus(rs.getString("status"));
                device.setBrandName(rs.getString("brandName"));
                return device;
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null; // Nếu không tìm thấy
}
    
}
