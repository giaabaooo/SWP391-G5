package dal;

import java.sql.*;
import java.util.*;
import data.ProductSerial;

/**
 * DAO for managing ProductSerial table operations
 */
public class ProductSerialDAO extends DBContext {

    /**
     * Check if a serial number already exists in the database
     *
     * @param serialNumber The serial number to check
     * @return true if exists, false otherwise
     */
    public boolean serialNumberExists(String serialNumber) {
        String sql = "SELECT 1 FROM ProductSerial WHERE serial_number = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, serialNumber);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("Error checking serial number existence: " + e.getMessage());
            return false;
        }
    }

    /**
     * Insert a new serial number for a product
     *
     * @param productId The product ID
     * @param serialNumber The serial number
     * @param status The status (IN_STOCK or SOLD)
     * @return true if successful, false otherwise
     */
    public boolean insertSerial(int productId, String serialNumber, String status) {
        String sql = "INSERT INTO ProductSerial (product_id, serial_number, status) VALUES (?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setString(2, serialNumber);
            ps.setString(3, status);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error inserting serial number: " + e.getMessage());
            return false;
        }
    }

    /**
     * Batch insert serial numbers (used within a transaction)
     *
     * @param conn The connection to use (for transaction control)
     * @param productId The product ID
     * @param serialNumbers List of serial numbers to insert
     * @param status The status for all serials
     * @throws SQLException if insertion fails
     */
    public void batchInsertSerials(Connection conn, int productId, List<String> serialNumbers, String status) throws SQLException {
        String sql = "INSERT INTO ProductSerial (product_id, serial_number, status) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (String serialNumber : serialNumbers) {
                ps.setInt(1, productId);
                ps.setString(2, serialNumber);
                ps.setString(3, status);
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    /**
     * Update serial number status to SOLD
     *
     * @param serialNumber The serial number to update
     * @return true if successful, false otherwise
     */
    public boolean markSerialAsSold(String serialNumber) {
        String sql = "UPDATE ProductSerial SET status = 'SOLD' WHERE serial_number = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, serialNumber);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error marking serial as sold: " + e.getMessage());
            return false;
        }
    }

    /**
     * Update serial number status to SOLD (used within a transaction)
     *
     * @param conn The connection to use
     * @param serialNumber The serial number to update
     * @throws SQLException if update fails
     */
    public void markSerialAsSold(Connection conn, String serialNumber) throws SQLException {
        String sql = "UPDATE ProductSerial SET status = 'SOLD' WHERE serial_number = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, serialNumber);
            int updated = ps.executeUpdate();
            if (updated == 0) {
                throw new SQLException("Serial number not found or already sold: " + serialNumber);
            }
        }
    }

    /**
     * Check if a serial number exists and is IN_STOCK for a specific product
     *
     * @param productId The product ID
     * @param serialNumber The serial number
     * @return true if exists and in stock, false otherwise
     */
    public boolean isSerialInStock(int productId, String serialNumber) {
        String sql = "SELECT 1 FROM ProductSerial ps "
                + "WHERE ps.product_id = ? AND ps.serial_number = ? AND ps.status = 'IN_STOCK'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setString(2, serialNumber);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("Error checking serial stock status: " + e.getMessage());
            return false;
        }
    }

    /**
     * Get all serial numbers for a product with a specific status
     *
     * @param productId The product ID
     * @param status The status to filter by
     * @return List of serial numbers
     */
    public List<String> getSerialsByProductAndStatus(int productId, String status) {
        List<String> serials = new ArrayList<>();
        String sql = "SELECT serial_number FROM ProductSerial WHERE product_id = ? AND status = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setString(2, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    serials.add(rs.getString("serial_number"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting serials by product and status: " + e.getMessage());
        }
        return serials;
    }

    /**
     * Get a ProductSerial object by serial number
     *
     * @param serialNumber The serial number to search for
     * @return ProductSerial object if found, null otherwise
     */
    public ProductSerial getSerialByNumber(String serialNumber) {
        String sql = "SELECT id, product_id, serial_number, status FROM ProductSerial WHERE serial_number = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, serialNumber);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ProductSerial serial = new ProductSerial();
                    serial.setId(rs.getInt("id"));
                    serial.setProductId(rs.getInt("product_id"));
                    serial.setSerialNumber(rs.getString("serial_number"));
                    serial.setStatus(rs.getString("status"));
                    return serial;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting serial by number: " + e.getMessage());
        }
        return null;
    }

    /**
     * Update the status of a serial number
     *
     * @param serialNumber The serial number to update
     * @param newStatus The new status (IN_STOCK or SOLD)
     * @return true if successful, false otherwise
     */
    public boolean updateSerialStatus(String serialNumber, String newStatus) {
        String sql = "UPDATE ProductSerial SET status = ? WHERE serial_number = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setString(2, serialNumber);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating serial status: " + e.getMessage());
            return false;
        }
    }

    public Map<Integer, List<ProductSerial>> getAvailableSerialsGroupedByProduct() {
        Map<Integer, List<ProductSerial>> serialsMap = new HashMap<>();
        String sql = "SELECT id, product_id, serial_number, status "
                + "FROM ProductSerial WHERE status = 'IN_STOCK' ORDER BY product_id, serial_number";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ProductSerial psObj = new ProductSerial();
                psObj.setId(rs.getInt("id"));
                psObj.setProductId(rs.getInt("product_id"));
                psObj.setSerialNumber(rs.getString("serial_number"));
                psObj.setStatus(rs.getString("status"));

                serialsMap
                        .computeIfAbsent(psObj.getProductId(), k -> new ArrayList<>())
                        .add(psObj);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return serialsMap;
    }

    public void reserveSerial(String serialNumber, int productId) throws SQLException {
        String sql = "UPDATE ProductSerial SET status = 'SOLD' "
                + "WHERE serial_number = ? AND product_id = ? AND status = 'IN_STOCK'";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, serialNumber);
            ps.setInt(2, productId);

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Serial number " + serialNumber
                        + " is invalid, not in stock, or does not belong to product " + productId);
            }
        }
    }

    public void releaseSerial(String serialNumber) throws SQLException {
        String sql = "UPDATE ProductSerial SET status = 'IN_STOCK' "
                + "WHERE serial_number = ? AND status = 'SOLD'";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, serialNumber);
            ps.executeUpdate();
        }
    }

    public Map<Integer, List<ProductSerial>> getAvailableSerialsForUpdate(int contractId) {
        Map<Integer, List<ProductSerial>> serialsMap = new HashMap<>();
        String sql = """
            (SELECT id, product_id, serial_number, status
             FROM ProductSerial
             WHERE status = 'IN_STOCK')
            UNION
            (SELECT ps.id, ps.product_id, ps.serial_number, ps.status
             FROM ProductSerial ps
             JOIN Device d ON ps.serial_number = d.serial_number
             JOIN ContractItem ci ON d.contract_item_id = ci.id
             WHERE ci.contract_id = ? AND ps.status = 'SOLD' AND d.is_active = true)
            ORDER BY product_id, serial_number
            """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contractId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductSerial psObj = new ProductSerial();
                    psObj.setId(rs.getInt("id"));
                    psObj.setProductId(rs.getInt("product_id"));
                    psObj.setSerialNumber(rs.getString("serial_number"));
                    psObj.setStatus(rs.getString("status"));

                    serialsMap
                            .computeIfAbsent(psObj.getProductId(), k -> new ArrayList<>())
                            .add(psObj);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return serialsMap;
    }

    public int getTotalSerialCountByProductId(int productId) {
        String sql = "SELECT COUNT(*) FROM ProductSerial WHERE product_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting serial count by product ID: " + e.getMessage());
        }
        return 0;
    }

    public List<ProductSerial> getSerialsByProductId(int productId, int page, int pageSize) {
        List<ProductSerial> serials = new ArrayList<>();
        String sql = "SELECT id, product_id, serial_number, status "
                + "FROM ProductSerial "
                + "WHERE product_id = ? "
                + "ORDER BY status, serial_number "
                + "LIMIT ?, ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, (page - 1) * pageSize);
            ps.setInt(3, pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductSerial serial = new ProductSerial();
                    serial.setId(rs.getInt("id"));
                    serial.setProductId(rs.getInt("product_id"));
                    serial.setSerialNumber(rs.getString("serial_number"));
                    serial.setStatus(rs.getString("status"));
                    serials.add(serial);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting paginated serials by product ID: " + e.getMessage());
        }
        return serials;
    }
}
