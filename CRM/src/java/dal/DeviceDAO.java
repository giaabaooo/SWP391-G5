package dal;

import data.Device;
import java.sql.*;
import java.util.*;

public class DeviceDAO extends DBContext {

    // Lấy danh sách device theo user + filter + pagination
    public List<Device> getDevicesByUserId(int userId, String keyword, String brand, String category, String status, int offset, int limit) {
        List<Device> devices = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
            SELECT 
                d.id AS device_id,
                d.status AS device_status,
                p.name AS product_name,
                c.name AS category_name,
                b.name AS brand_name,
                p.purchase_price,
                p.selling_price
            FROM Device d
            JOIN ContractItem ci ON d.contract_item_id = ci.id
            JOIN Product p ON ci.product_id = p.id
            JOIN Category c ON p.category_id = c.id
            JOIN Brand b ON p.brand_id = b.id
            JOIN Contract con ON ci.contract_id = con.id
            WHERE con.customer_id = ?
        """);

        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND p.name LIKE ? ");
        }
        if (brand != null && !brand.equalsIgnoreCase("ALL")) {
            sql.append(" AND b.name = ? ");
        }
        if (category != null && !category.equalsIgnoreCase("ALL")) {
            sql.append(" AND c.name = ? ");
        }
        if (status != null && !status.equalsIgnoreCase("ALL")) {
            sql.append(" AND d.status = ? ");
        }

        sql.append(" ORDER BY d.id ASC LIMIT ? OFFSET ?");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int index = 1;
            ps.setInt(index++, userId);

            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
            }
            if (brand != null && !brand.equalsIgnoreCase("ALL")) {
                ps.setString(index++, brand);
            }
            if (category != null && !category.equalsIgnoreCase("ALL")) {
                ps.setString(index++, category);
            }
            if (status != null && !status.equalsIgnoreCase("ALL")) {
                ps.setString(index++, status);
            }

            ps.setInt(index++, limit);
            ps.setInt(index, offset);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Device d = new Device();
                d.setId(rs.getInt("device_id"));
                d.setProductName(rs.getString("product_name"));
                d.setCategoryName(rs.getString("category_name"));
                d.setBrandName(rs.getString("brand_name"));
                d.setStatus(rs.getString("device_status"));
                d.setPurchasePrice(rs.getBigDecimal("purchase_price"));
                d.setSellingPrice(rs.getBigDecimal("selling_price"));
                devices.add(d);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return devices;
    }

    // Đếm tổng device của user theo filter (để pagination)
    public int countDevicesByUser(int userId, String keyword, String brand, String category, String status) {
        int total = 0;

        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(*) AS total
            FROM Device d
            JOIN ContractItem ci ON d.contract_item_id = ci.id
            JOIN Product p ON ci.product_id = p.id
            JOIN Category c ON p.category_id = c.id
            JOIN Brand b ON p.brand_id = b.id
            JOIN Contract con ON ci.contract_id = con.id
            WHERE con.customer_id = ?
        """);

        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND p.name LIKE ? ");
        }
        if (brand != null && !brand.equalsIgnoreCase("ALL")) {
            sql.append(" AND b.name = ? ");
        }
        if (category != null && !category.equalsIgnoreCase("ALL")) {
            sql.append(" AND c.name = ? ");
        }
        if (status != null && !status.equalsIgnoreCase("ALL")) {
            sql.append(" AND d.status = ? ");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int index = 1;
            ps.setInt(index++, userId);

            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
            }
            if (brand != null && !brand.equalsIgnoreCase("ALL")) {
                ps.setString(index++, brand);
            }
            if (category != null && !category.equalsIgnoreCase("ALL")) {
                ps.setString(index++, category);
            }
            if (status != null && !status.equalsIgnoreCase("ALL")) {
                ps.setString(index++, status);
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt("total");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return total;
    }

    // Lấy danh sách brand/category/status để hiển thị filter
    public List<String> getBrandsByUserId(int userId) {
        List<String> brands = new ArrayList<>();
        String sql = """
            SELECT DISTINCT b.name
            FROM Device d
            JOIN ContractItem ci ON d.contract_item_id = ci.id
            JOIN Product p ON ci.product_id = p.id
            JOIN Brand b ON p.brand_id = b.id
            JOIN Contract con ON ci.contract_id = con.id
            WHERE con.customer_id = ?
            ORDER BY b.name
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                brands.add(rs.getString("name"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return brands;
    }

    public List<String> getCategoriesByUserId(int userId) {
        List<String> categories = new ArrayList<>();
        String sql = """
            SELECT DISTINCT c.name
            FROM Device d
            JOIN ContractItem ci ON d.contract_item_id = ci.id
            JOIN Product p ON ci.product_id = p.id
            JOIN Category c ON p.category_id = c.id
            JOIN Contract con ON ci.contract_id = con.id
            WHERE con.customer_id = ?
            ORDER BY c.name
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                categories.add(rs.getString("name"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return categories;
    }

    public List<String> getStatusesByUserId(int userId) {
        List<String> statuses = new ArrayList<>();
        String sql = """
            SELECT DISTINCT d.status
            FROM Device d
            JOIN ContractItem ci ON d.contract_item_id = ci.id
            JOIN Contract con ON ci.contract_id = con.id
            WHERE con.customer_id = ?
            ORDER BY d.status
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                statuses.add(rs.getString("status"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return statuses;
    }

    public Device getDeviceById(int deviceId) {
        String sql = """
            SELECT d.id, d.contract_item_id, d.serial_number, d.warranty_expiration, d.status,
                   p.name AS product_name, b.name AS brand_name, c.name AS category_name
            FROM Device d
            JOIN ContractItem ci ON d.contract_item_id = ci.id
            JOIN Product p ON ci.product_id = p.id
            JOIN Brand b ON p.brand_id = b.id
            JOIN Category c ON p.category_id = c.id
            WHERE d.id = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, deviceId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Device d = new Device();
                d.setId(rs.getInt("id"));
                d.setContractItemId(rs.getInt("contract_item_id"));
                d.setSerialNumber(rs.getString("serial_number"));
                d.setWarrantyExpiration(rs.getDate("warranty_expiration"));
                d.setStatus(rs.getString("status"));
                d.setProductName(rs.getString("product_name"));
                d.setBrandName(rs.getString("brand_name"));
                d.setCategoryName(rs.getString("category_name"));
                return d;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Device> getDevicesByUserId(int userId) {
        List<Device> list = new ArrayList<>();
        String sql = "SELECT d.id AS device_id,d.serial_number,\n" +
"                   d.status,\n"
                + "    p.name AS product_name,\n"
                + "    b.name AS brand_name,\n"
                + "    c.name AS category_name "
                + "FROM Device d "
                + "JOIN ContractItem ci ON d.contract_item_id = ci.id "
                + "JOIN Product p ON ci.product_id = p.id "
                + "JOIN Brand b ON p.brand_id = b.id "
                + "JOIN Category c ON p.category_id = c.id "
                + "JOIN Contract con ON ci.contract_id = con.id "
                + "WHERE con.customer_id = ?";
        try (
                PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Device d = new Device();
                d.setId(rs.getInt("device_id"));
                d.setSerialNumber(rs.getString("serial_number"));             
                d.setStatus(rs.getString("status"));
                d.setProductName(rs.getString("product_name"));
                d.setBrandName(rs.getString("brand_name"));
                d.setCategoryName(rs.getString("category_name"));
                // ... set thêm nếu cần
                list.add(d);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

}
