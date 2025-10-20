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
import java.util.*;
import java.sql.Date;

/**
 *
 * @author admin
 */
public class ContractDAO extends DBContext {

    public int countContracts(String keyword, String fromDate, String toDate) {
        String sql = "SELECT COUNT(*) FROM Contract c "
                + "JOIN User u ON c.customer_id = u.id "
                + "WHERE 1=1";
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

    public List<Contract> listContracts(int page, int pageSize, String keyword, String fromDate, String toDate) {
        List<Contract> list = new ArrayList<>();
        String sql = "SELECT c.*, u.full_name AS customer_name "
                + "FROM Contract c "
                + "LEFT JOIN User u ON c.customer_id = u.id "
                + "WHERE 1=1 ";
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

        sql += " ORDER BY c.contract_date DESC LIMIT ? OFFSET ?";
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
        String sql = "SELECT * FROM Contract WHERE id=?";
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
                // Thêm thông tin phụ từ join
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
            WHERE c.id = ?
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
            WHERE ci.contract_id = ?
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
        String deleteItemsSql = "DELETE FROM ContractItem WHERE contract_id = ?";
        String deleteContractSql = "DELETE FROM Contract WHERE id = ?";

        try {
            connection.setAutoCommit(false);

            try (PreparedStatement ps1 = connection.prepareStatement(deleteItemsSql); PreparedStatement ps2 = connection.prepareStatement(deleteContractSql)) {

                ps1.setInt(1, contractId);
                ps1.executeUpdate();

                ps2.setInt(1, contractId);
                ps2.executeUpdate();

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
}
