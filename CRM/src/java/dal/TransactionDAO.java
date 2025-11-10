package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import data.Transaction;
import data.InventoryTransactionItem;

public class TransactionDAO extends DBContext {
    public Integer getCurrentInventoryQuantity(int productId) {
        String sql = "SELECT quantity FROM Inventory WHERE product_id = ? AND is_active = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting current inventory quantity: " + e.getMessage());
        }
        return null;
    }

    public boolean createImportAndUpdateInventory(int productId, int quantity, Timestamp transactionDate, String supplier, String note) {
        InventoryTransactionItem item = new InventoryTransactionItem(productId, quantity, null, null);
        return createImportBatchAndUpdateInventory(Collections.singletonList(item), transactionDate, supplier, note);
    }

    public boolean createImportBatchAndUpdateInventory(List<InventoryTransactionItem> items, Timestamp transactionDate, String supplier, String generalNote) {
        if (items == null || items.isEmpty()) {
            return false;
        }

        Connection conn = this.connection;
        if (conn == null) {
            return false;
        }

        boolean success = false;
        boolean originalAutoCommit = true;
        Timestamp effectiveDate = transactionDate != null ? transactionDate : new Timestamp(System.currentTimeMillis());

        try {
            originalAutoCommit = conn.getAutoCommit();
            conn.setAutoCommit(false);

            for (InventoryTransactionItem item : items) {
                if (item == null) {
                    continue;
                }
                if (item.getQuantity() <= 0) {
                    throw new IllegalArgumentException("Quantity must be greater than zero for all items");
                }

                int productId = item.getProductId();
                int quantity = item.getQuantity();

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

                String txSql = "INSERT INTO `Transaction` (product_id, contract_id, type, quantity, transaction_date, note, is_active) VALUES (?, NULL, 'IMPORT', ?, ?, ?, 1)";
                try (PreparedStatement pst = conn.prepareStatement(txSql)) {
                    pst.setInt(1, productId);
                    pst.setInt(2, quantity);
                    pst.setTimestamp(3, effectiveDate);
                    pst.setString(4, buildImportNote(supplier, generalNote, item));
                    pst.executeUpdate();
                }
            }

            conn.commit();
            success = true;
        } catch (SQLException | RuntimeException ex) {
            try { conn.rollback(); } catch (SQLException ignored) {}
            System.err.println("Error creating import batch: " + ex.getMessage());
        } finally {
            try { conn.setAutoCommit(originalAutoCommit); } catch (SQLException ignored) {}
        }

        return success;
    }

    private String buildImportNote(String supplier, String generalNote, InventoryTransactionItem item) {
        List<String> parts = new ArrayList<>();
        if (item.getUnit() != null && !item.getUnit().trim().isEmpty()) {
            parts.add("Unit: " + item.getUnit().trim());
        }
        if (item.getItemNote() != null && !item.getItemNote().trim().isEmpty()) {
            parts.add(item.getItemNote().trim());
        }
        if (supplier != null && !supplier.trim().isEmpty()) {
            parts.add("Supplier: " + supplier.trim());
        }
        if (generalNote != null && !generalNote.trim().isEmpty()) {
            parts.add(generalNote.trim());
        }
        if (parts.isEmpty()) {
            return null;
        }
        return String.join(" | ", parts);
    }

    public boolean createExportAndUpdateInventory(int productId, int quantity, Timestamp transactionDate, String note) {
        InventoryTransactionItem item = new InventoryTransactionItem(productId, quantity, null, null);
        return createExportBatchAndUpdateInventory(Collections.singletonList(item), transactionDate, note);
    }

    public boolean createExportBatchAndUpdateInventory(List<InventoryTransactionItem> items, Timestamp transactionDate, String generalNote) {
        if (items == null || items.isEmpty()) {
            return false;
        }

        Connection conn = this.connection;
        if (conn == null) {
            return false;
        }

        boolean success = false;
        boolean originalAutoCommit = true;
        Timestamp effectiveDate = transactionDate != null ? transactionDate : new Timestamp(System.currentTimeMillis());

        try {
            originalAutoCommit = conn.getAutoCommit();
            conn.setAutoCommit(false);

            for (InventoryTransactionItem item : items) {
                if (item == null) {
                    continue;
                }
                if (item.getQuantity() <= 0) {
                    throw new IllegalArgumentException("Quantity must be greater than zero for all items");
                }

                int productId = item.getProductId();
                int quantity = item.getQuantity();

                // Check available stock
                int currentQty = 0;
                String sel = "SELECT quantity FROM Inventory WHERE product_id = ? AND is_active = 1";
                try (PreparedStatement ps = conn.prepareStatement(sel)) {
                    ps.setInt(1, productId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) currentQty = rs.getInt(1);
                    }
                }
                if (currentQty < quantity) {
                    throw new IllegalArgumentException("Export quantity (" + quantity + ") exceeds available stock (" + currentQty + ") for product ID " + productId);
                }

                String updateSql = "UPDATE Inventory SET quantity = quantity - ? WHERE product_id = ? AND is_active = 1";
                try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                    ps.setInt(1, quantity);
                    ps.setInt(2, productId);
                    int updated = ps.executeUpdate();
                    if (updated == 0) {
                        throw new IllegalArgumentException("No inventory record found for product ID " + productId);
                    }
                }

                String txSql = "INSERT INTO `Transaction` (product_id, contract_id, type, quantity, transaction_date, note, is_active) VALUES (?, NULL, 'EXPORT', ?, ?, ?, 1)";
                try (PreparedStatement pst = conn.prepareStatement(txSql)) {
                    pst.setInt(1, productId);
                    pst.setInt(2, quantity);
                    pst.setTimestamp(3, effectiveDate);
                    pst.setString(4, buildExportNote(generalNote, item));
                    pst.executeUpdate();
                }
            }

            conn.commit();
            success = true;
        } catch (SQLException | RuntimeException ex) {
            try { conn.rollback(); } catch (SQLException ignored) {}
            System.err.println("Error creating export batch: " + ex.getMessage());
        } finally {
            try { conn.setAutoCommit(originalAutoCommit); } catch (SQLException ignored) {}
        }

        return success;
    }

    private String buildExportNote(String generalNote, InventoryTransactionItem item) {
        List<String> parts = new ArrayList<>();
        if (item.getUnit() != null && !item.getUnit().trim().isEmpty()) {
            parts.add("Unit: " + item.getUnit().trim());
        }
        if (item.getItemNote() != null && !item.getItemNote().trim().isEmpty()) {
            parts.add(item.getItemNote().trim());
        }
        if (generalNote != null && !generalNote.trim().isEmpty()) {
            parts.add(generalNote.trim());
        }
        if (parts.isEmpty()) {
            return null;
        }
        return String.join(" | ", parts);
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


