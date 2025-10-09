/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import data.Contract;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author admin
 */
public class ContractDAO extends DBContext {

    // ===== COUNT (phục vụ phân trang) =====
    public int countContracts(String keyword, String fromDate, String toDate) {
        String sql = "SELECT COUNT(*) FROM Contract WHERE 1=1";
        ArrayList<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND contract_code LIKE ?";
            params.add("%" + keyword + "%");
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql += " AND contract_date >= ?";
            params.add(Date.valueOf(fromDate));
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql += " AND contract_date <= ?";
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

    // ===== LIST (có phân trang + lọc) =====
    public List<Contract> listContracts(int page, int pageSize, String keyword, String fromDate, String toDate) {
        List<Contract> list = new ArrayList<>();
        String sql = "SELECT * FROM Contract WHERE 1=1";
        ArrayList<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND contract_code LIKE ?";
            params.add("%" + keyword + "%");
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql += " AND contract_date >= ?";
            params.add(Date.valueOf(fromDate));
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql += " AND contract_date <= ?";
            params.add(Date.valueOf(toDate));
        }

        sql += " ORDER BY contract_date DESC LIMIT ? OFFSET ?";
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

    // ===== GET BY ID =====
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

    // ===== INSERT =====
    public void insert(Contract c) {
        String sql = "INSERT INTO Contract (customer_id, contract_code, contract_date, total_amount, description) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, c.getCustomerId());
            ps.setString(2, c.getContractCode());
            ps.setDate(3, c.getContractDate());
            ps.setDouble(4, c.getTotalAmount());
            ps.setString(5, c.getDescription());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ===== UPDATE =====
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

    // ===== DELETE =====
    public void delete(int id) {
        try (PreparedStatement ps = connection.prepareStatement("DELETE FROM Contract WHERE id=?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
