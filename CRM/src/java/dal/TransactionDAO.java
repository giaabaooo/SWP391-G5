package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import data.Transaction;

public class TransactionDAO extends DBContext {

    public boolean createImportAndUpdateInventory(int productId, int quantity, Timestamp transactionDate, String supplier, String note) {
        if (quantity <= 0) return false;
        boolean originalAutoCommit;
        try {
            Connection conn = this.connection;
            originalAutoCommit = conn.getAutoCommit();
            conn.setAutoCommit(false);

            String updateSql = "UPDATE Inventory SET quantity = quantity + ? WHERE product_id = ? AND is_active = 1";
            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setInt(1, quantity);
                ps.setInt(2, productId);
                int updated = ps.executeUpdate();
                if (updated == 0) {
                    String insertInv = "INSERT INTO Inventory (product_id, quantity, is_active) VALUES (?, ?, 1)";
                    try (PreparedStatement psi = conn.prepareStatement(insertInv)) {
                        psi.setInt(1, productId);
                        psi.setInt(2, quantity);
                        psi.executeUpdate();
                    }
                }
            }

            String finalNote = note != null ? note.trim() : "";
            if (supplier != null && !supplier.trim().isEmpty()) {
                String supplierText = "Supplier: " + supplier.trim();
                finalNote = finalNote.isEmpty() ? supplierText : (supplierText + " | " + finalNote);
            }

            String txSql = "INSERT INTO `Transaction` (product_id, contract_id, type, quantity, transaction_date, note, is_active) VALUES (?, NULL, 'IMPORT', ?, ?, ?, 1)";
            try (PreparedStatement pst = conn.prepareStatement(txSql)) {
                pst.setInt(1, productId);
                pst.setInt(2, quantity);
                pst.setTimestamp(3, transactionDate != null ? transactionDate : new Timestamp(System.currentTimeMillis()));
                pst.setString(4, finalNote.isEmpty() ? null : finalNote);
                pst.executeUpdate();
            }

            conn.commit();
            conn.setAutoCommit(originalAutoCommit);
            return true;
        } catch (SQLException e) {
            try { this.connection.rollback(); } catch (SQLException ignored) {}
            try { this.connection.setAutoCommit(true); } catch (SQLException ignored) {}
            System.err.println("Error creating import transaction: " + e.getMessage());
            return false;
        }
    }

    public boolean createExportAndUpdateInventory(int productId, int quantity, Timestamp transactionDate, String note) {
        if (quantity <= 0) return false;
        boolean originalAutoCommit;
        try {
            Connection conn = this.connection;
            originalAutoCommit = conn.getAutoCommit();
            conn.setAutoCommit(false);

            int currentQty = 0;
            String sel = "SELECT quantity FROM Inventory WHERE product_id = ? AND is_active = 1";
            try (PreparedStatement ps = conn.prepareStatement(sel)) {
                ps.setInt(1, productId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) currentQty = rs.getInt(1);
                }
            }
            if (currentQty < quantity) {
                conn.setAutoCommit(originalAutoCommit);
                return false;
            }

            String updateSql = "UPDATE Inventory SET quantity = quantity - ? WHERE product_id = ? AND is_active = 1";
            try (PreparedStatement psu = conn.prepareStatement(updateSql)) {
                psu.setInt(1, quantity);
                psu.setInt(2, productId);
                int updated = psu.executeUpdate();
                if (updated == 0) {
                    conn.setAutoCommit(originalAutoCommit);
                    return false;
                }
            }

            String txSql = "INSERT INTO `Transaction` (product_id, contract_id, type, quantity, transaction_date, note, is_active) VALUES (?, NULL, 'EXPORT', ?, ?, ?, 1)";
            try (PreparedStatement pst = conn.prepareStatement(txSql)) {
                pst.setInt(1, productId);
                pst.setInt(2, quantity);
                pst.setTimestamp(3, transactionDate != null ? transactionDate : new Timestamp(System.currentTimeMillis()));
                pst.setString(4, (note != null && !note.trim().isEmpty()) ? note.trim() : null);
                pst.executeUpdate();
            }

            conn.commit();
            conn.setAutoCommit(originalAutoCommit);
            return true;
        } catch (SQLException e) {
            try { this.connection.rollback(); } catch (SQLException ignored) {}
            try { this.connection.setAutoCommit(true); } catch (SQLException ignored) {}
            System.err.println("Error creating export transaction: " + e.getMessage());
            return false;
        }
    }

    public int getTotalTransactions(String typeFilter, String searchNote) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM `Transaction` WHERE is_active = 1");
        boolean hasType = (typeFilter != null && !typeFilter.isEmpty());
        boolean hasSearch = (searchNote != null && !searchNote.trim().isEmpty());
        if (hasType) sql.append(" AND type = ?");
        if (hasSearch) sql.append(" AND note LIKE ?");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (hasType) ps.setString(idx++, typeFilter);
            if (hasSearch) ps.setString(idx++, "%" + searchNote.trim() + "%");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error counting transactions: " + e.getMessage());
        }
        return 0;
    }

    public List<Transaction> getTransactions(int page, int pageSize, String typeFilter, String searchNote) {
        List<Transaction> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        StringBuilder sql = new StringBuilder(
            "SELECT t.id, t.product_id, p.name as product_name, t.contract_id, t.type, t.quantity, t.transaction_date, t.note, t.is_active " +
            "FROM `Transaction` t " +
            "LEFT JOIN Product p ON t.product_id = p.id " +
            "WHERE t.is_active = 1"
        );
        boolean hasType = (typeFilter != null && !typeFilter.isEmpty());
        boolean hasSearch = (searchNote != null && !searchNote.trim().isEmpty());
        if (hasType) sql.append(" AND t.type = ?");
        if (hasSearch) sql.append(" AND t.note LIKE ?");
        sql.append(" ORDER BY t.transaction_date DESC, t.id DESC LIMIT ? OFFSET ?");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (hasType) ps.setString(idx++, typeFilter);
            if (hasSearch) ps.setString(idx++, "%" + searchNote.trim() + "%");
            ps.setInt(idx++, pageSize);
            ps.setInt(idx, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Transaction t = new Transaction(
                        rs.getInt("id"),
                        rs.getInt("product_id"),
                        rs.getString("product_name"),
                        (Integer) rs.getObject("contract_id"),
                        rs.getString("type"),
                        rs.getInt("quantity"),
                        rs.getTimestamp("transaction_date"),
                        rs.getString("note"),
                        rs.getBoolean("is_active")
                    );
                    list.add(t);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching transactions: " + e.getMessage());
        }
        return list;
    }
}


