/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import data.Contract;
import data.ContractItem;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.sql.Date;

/**
 *
 * @author admin
 */
public class ContractDAO extends DBContext {

    public int countContracts(String keyword, String fromDate, String toDate) {
        String sql = "SELECT COUNT(*) FROM Contract c "
                + "JOIN User u ON c.customer_id = u.id "
                + "WHERE 1=1 AND c.is_active = true";
        ArrayList<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (c.contract_code LIKE ? OR u.full_name LIKE ?)";
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql += " AND c.contract_date >= ?";
            params.add(Date.valueOf(fromDate));
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql += " AND c.contract_date <= ?";
            params.add(Date.valueOf(toDate));
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
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

    public List<Contract> listContracts(int page, int pageSize, String keyword, String fromDate, String toDate, String sort) {
        List<Contract> list = new ArrayList<>();
        String sql = "SELECT c.*, u.full_name AS customer_name "
                + "FROM Contract c "
                + "LEFT JOIN User u ON c.customer_id = u.id "
                + "WHERE 1=1 AND c.is_active = true ";
        ArrayList<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (c.contract_code LIKE ? OR u.full_name LIKE ?)";
            params.add("%" + keyword.trim() + "%");
            params.add("%" + keyword.trim() + "%");
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql += " AND c.contract_date >= ? ";
            params.add(Date.valueOf(fromDate));
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql += " AND c.contract_date <= ? ";
            params.add(Date.valueOf(toDate));
        }

        String orderBy = "c.contract_date DESC";
        if (sort != null) {
            switch (sort) {
                case "contractCode_asc":
                    orderBy = "c.contract_code ASC";
                    break;
                case "contractCode_desc":
                    orderBy = "c.contract_code DESC";
                    break;
                case "customer_asc":
                    orderBy = "u.full_name ASC";
                    break;
                case "customer_desc":
                    orderBy = "u.full_name DESC";
                    break;
                case "contractDate_asc":
                    orderBy = "c.contract_date ASC";
                    break;
                case "contractDate_desc":
                    orderBy = "c.contract_date DESC";
                    break;
                case "totalAmount_asc":
                    orderBy = "c.total_amount ASC";
                    break;
                case "totalAmount_desc":
                    orderBy = "c.total_amount DESC";
                    break;
            }
        }

        sql += " ORDER BY " + orderBy + " LIMIT ? OFFSET ?";
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Contract c = new Contract();
                c.setId(rs.getInt("id"));
                c.setCustomerId(rs.getInt("customer_id"));
                c.setCustomerName(rs.getString("customer_name"));
                c.setContractCode(rs.getString("contract_code"));
                c.setContractDate(rs.getDate("contract_date"));
                c.setTotalAmount(rs.getDouble("total_amount"));
                c.setDescription(rs.getString("description"));
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Contract getById(int id) {
        String sql = "SELECT * FROM Contract WHERE id=? AND is_active = true";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Contract c = new Contract();
                c.setId(rs.getInt("id"));
                c.setCustomerId(rs.getInt("customer_id"));
                c.setContractCode(rs.getString("contract_code"));
                c.setContractDate(rs.getDate("contract_date"));
                c.setTotalAmount(rs.getDouble("total_amount"));
                c.setDescription(rs.getString("description"));
                return c;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int insertContractWithItems(Contract contract, List<ContractItem> items) {
        String insertContractSql = """
        INSERT INTO Contract (customer_id, contract_code, contract_date, total_amount, description)
        VALUES (?, ?, ?, ?, ?)
    """;

        String insertItemSql = """
        INSERT INTO ContractItem (contract_id, product_id, quantity, unit_price, warranty_months, maintenance_months, maintenance_frequency_months)
        VALUES (?, ?, ?, ?, ?, ?, ?)
    """;

        int generatedContractId = -1;

        try {
            connection.setAutoCommit(false);

            try (PreparedStatement ps = connection.prepareStatement(insertContractSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, contract.getCustomerId());
                ps.setString(2, contract.getContractCode());
                ps.setDate(3, contract.getContractDate());
                ps.setDouble(4, contract.getTotalAmount());
                ps.setString(5, contract.getDescription());
                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedContractId = rs.getInt(1);
                    }
                }
            }

            try (PreparedStatement psItem = connection.prepareStatement(insertItemSql)) {
                for (ContractItem item : items) {
                    psItem.setInt(1, generatedContractId);
                    psItem.setInt(2, item.getProductId());
                    psItem.setInt(3, item.getQuantity());
                    psItem.setDouble(4, item.getUnitPrice());
                    psItem.setInt(5, item.getWarrantyMonths());
                    psItem.setInt(6, item.getMaintenanceMonths());
                    psItem.setInt(7, item.getMaintenanceFrequencyMonths());
                    psItem.addBatch();
                }
                psItem.executeBatch();
            }

            connection.commit();
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return generatedContractId;
    }

    public int getLastActiveContractItemId(int contractId, int productId) throws SQLException {
        String sql = "SELECT id FROM ContractItem WHERE contract_id = ? AND product_id = ? AND is_active = true ORDER BY id DESC LIMIT 1";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, contractId);
            stm.setInt(2, productId);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id");
                }
            }
        }
        return -1;
    }

    public boolean isContractCodeExists(String contractCode) {
        String sql = "SELECT COUNT(*) FROM Contract WHERE contract_code = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, contractCode);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public void update(Contract c) {
        String sql = "UPDATE Contract SET customer_id=?, contract_code=?, contract_date=?, total_amount=?, description=? WHERE id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, c.getCustomerId());
            ps.setString(2, c.getContractCode());
            ps.setDate(3, c.getContractDate());
            ps.setDouble(4, c.getTotalAmount());
            ps.setString(5, c.getDescription());
            ps.setInt(6, c.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Contract> getContractsByUserId(int userId, String keyword, String brand, String category, int offset, int limit) {
        List<Contract> contracts = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
        SELECT 
            ct.id AS contract_id,
            ct.contract_code,
            ct.contract_date,         
            p.name AS product_name,
            b.name AS brand_name,
            cg.name AS category_name        
        FROM 
            Contract ct
            JOIN ContractItem ci ON ci.contract_id = ct.id
            JOIN Product p ON p.id = ci.product_id
            JOIN Brand b ON p.brand_id = b.id
            JOIN Category cg ON p.category_id = cg.id
        WHERE 
            ct.customer_id = ?
            AND ct.is_active = true
            AND ci.is_active = true                                
        
        """);
        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND p.name LIKE ? ");
        }
        if (brand != null && !brand.equalsIgnoreCase("ALL")) {
            sql.append(" AND b.name = ? ");
        }
        if (category != null && !category.equalsIgnoreCase("ALL")) {
            sql.append(" AND cg.name = ? ");
        }
        sql.append(" ORDER BY ct.contract_date DESC LIMIT ? OFFSET ?");

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
            ps.setInt(index++, limit);
            ps.setInt(index, offset);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Contract ct = new Contract();
                ct.setId(rs.getInt("contract_id"));
                ct.setContractCode(rs.getString("contract_code"));
                ct.setContractDate(rs.getDate("contract_date"));
                ct.setProductName(rs.getString("product_name"));
                ct.setBrandName(rs.getString("brand_name"));
                ct.setCategoryName(rs.getString("category_name"));
                contracts.add(ct);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return contracts;
    }

    public Contract getContractDetail(int id) {
        String sql = """
            SELECT c.*, u.full_name AS customer_name
            FROM Contract c
            JOIN User u ON c.customer_id = u.id
            WHERE c.id = ? AND c.is_active = true
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Contract c = new Contract();
                c.setId(rs.getInt("id"));
                c.setCustomerId(rs.getInt("customer_id"));
                c.setCustomerName(rs.getString("customer_name"));
                c.setContractCode(rs.getString("contract_code"));
                c.setContractDate(rs.getDate("contract_date"));
                c.setTotalAmount(rs.getDouble("total_amount"));
                c.setDescription(rs.getString("description"));
                return c;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<ContractItem> getContractItems(int contractId) {
        List<ContractItem> items = new ArrayList<>();
        String sql = """
            SELECT ci.*, p.name AS product_name, b.name AS brand_name, c.name AS category_name
            FROM ContractItem ci
            JOIN Product p ON ci.product_id = p.id
            JOIN Brand b ON p.brand_id = b.id
            JOIN Category c ON p.category_id = c.id
            WHERE ci.contract_id = ? AND ci.is_active = true
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contractId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ContractItem ci = new ContractItem();
                ci.setId(rs.getInt("id"));
                ci.setContractId(rs.getInt("contract_id"));
                ci.setProductId(rs.getInt("product_id"));
                ci.setQuantity(rs.getInt("quantity"));
                ci.setUnitPrice(rs.getDouble("unit_price"));
                ci.setWarrantyMonths(rs.getInt("warranty_months"));
                ci.setMaintenanceMonths(rs.getInt("maintenance_months"));
                ci.setMaintenanceFrequencyMonths(rs.getInt("maintenance_frequency_months"));
                ci.setProductName(rs.getString("product_name"));
                ci.setBrandName(rs.getString("brand_name"));
                ci.setCategoryName(rs.getString("category_name"));
                items.add(ci);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    public void deleteContractWithItems(int contractId) {
        String updateDevicesSql = "UPDATE Device SET is_active = false "
                + "WHERE contract_item_id IN (SELECT id FROM ContractItem WHERE contract_id = ?)";

        String updateItemsSql = "UPDATE ContractItem SET is_active = false WHERE contract_id = ?";

        String updateContractSql = "UPDATE Contract SET is_active = false WHERE id = ?";

        try {
            connection.setAutoCommit(false);

            try (PreparedStatement psDevices = connection.prepareStatement(updateDevicesSql); PreparedStatement psItems = connection.prepareStatement(updateItemsSql); PreparedStatement psContract = connection.prepareStatement(updateContractSql)) {

                psDevices.setInt(1, contractId);
                psDevices.executeUpdate();

                psItems.setInt(1, contractId);
                psItems.executeUpdate();

                psContract.setInt(1, contractId);
                psContract.executeUpdate();

                connection.commit();
            }

        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean updateContractAndRecreateItems(Contract contract, List<ContractItem> items) {
        String updateContractSql = "UPDATE Contract SET customer_id=?, contract_code=?, contract_date=?, total_amount=?, description=? WHERE id=?";

        String deactivateDevicesSql = "UPDATE Device SET is_active = false "
                + "WHERE contract_item_id IN (SELECT id FROM ContractItem WHERE contract_id = ? AND is_active = true)";

        String deactivateItemsSql = "UPDATE ContractItem SET is_active = false WHERE contract_id = ? AND is_active = true";

        String insertItemSql = """
        INSERT INTO ContractItem (contract_id, product_id, quantity, unit_price, warranty_months, maintenance_months, maintenance_frequency_months)
        VALUES (?, ?, ?, ?, ?, ?, ?)
        """;

        try {
            connection.setAutoCommit(false);

            try (PreparedStatement ps = connection.prepareStatement(deactivateDevicesSql)) {
                ps.setInt(1, contract.getId());
                ps.executeUpdate();
            }

            try (PreparedStatement ps = connection.prepareStatement(deactivateItemsSql)) {
                ps.setInt(1, contract.getId());
                ps.executeUpdate();
            }

            try (PreparedStatement ps = connection.prepareStatement(updateContractSql)) {
                ps.setInt(1, contract.getCustomerId());
                ps.setString(2, contract.getContractCode());
                ps.setDate(3, contract.getContractDate());
                ps.setDouble(4, contract.getTotalAmount());
                ps.setString(5, contract.getDescription());
                ps.setInt(6, contract.getId());
                ps.executeUpdate();
            }

            try (PreparedStatement psItem = connection.prepareStatement(insertItemSql)) {
                for (ContractItem item : items) {
                    psItem.setInt(1, contract.getId());
                    psItem.setInt(2, item.getProductId());
                    psItem.setInt(3, item.getQuantity());
                    psItem.setDouble(4, item.getUnitPrice());
                    psItem.setInt(5, item.getWarrantyMonths());
                    psItem.setInt(6, item.getMaintenanceMonths());
                    psItem.setInt(7, item.getMaintenanceFrequencyMonths());
                    psItem.addBatch();
                }
                psItem.executeBatch();
            }

            connection.commit();
            return true;

        } catch (SQLException e) {
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
}
