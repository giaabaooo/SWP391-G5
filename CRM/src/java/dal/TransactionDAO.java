package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import data.Transaction;
import data.InventoryTransactionItem;
import data.SerialItem;
import data.ProductSerial;

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

    /**
     * Import products with serial numbers from Excel file
     * This method handles the complete import flow with serial tracking
     *
     * @param serialItems List of serial items from Excel (sku + serial_number)
     * @param transactionDate The transaction timestamp
     * @param supplier Supplier name (optional)
     * @param generalNote General note for the transaction
     * @return Map with "success" (Boolean) and "errors" (List<String>) or "message" (String)
     */
    public Map<String, Object> importWithSerials(List<SerialItem> serialItems, Timestamp transactionDate, String supplier, String generalNote) {
        Map<String, Object> result = new HashMap<>();
        List<String> errors = new ArrayList<>();

        if (serialItems == null || serialItems.isEmpty()) {
            result.put("success", false);
            result.put("errors", Collections.singletonList("No serial items provided"));
            return result;
        }

        Connection conn = this.connection;
        if (conn == null) {
            result.put("success", false);
            result.put("errors", Collections.singletonList("Database connection failed"));
            return result;
        }

        // Phase 1: Validation
        ProductDAO productDAO = new ProductDAO();
        ProductSerialDAO serialDAO = new ProductSerialDAO();
        Map<String, Integer> skuToProductId = new HashMap<>();
        Map<Integer, Integer> productCounts = new HashMap<>();

        try {
            for (SerialItem item : serialItems) {
                String sku = item.getSku();
                String serialNumber = item.getSerialNumber();
                int rowNum = item.getRowNumber();

                // Validation 1: Check if SKU exists and get product_id
                Integer productId = skuToProductId.get(sku);
                if (productId == null) {
                    productId = productDAO.getProductIdBySku(sku);
                    if (productId == null) {
                        errors.add("Row " + rowNum + ": SKU '" + sku + "' not found in database");
                        continue;
                    }
                    skuToProductId.put(sku, productId);
                }

                // Validation 2: Check if serial_number already exists
                if (serialDAO.serialNumberExists(serialNumber)) {
                    errors.add("Row " + rowNum + ": Serial number '" + serialNumber + "' already exists");
                    continue;
                }

                // Count quantities per product
                productCounts.put(productId, productCounts.getOrDefault(productId, 0) + 1);
            }
        } finally {
            productDAO.close();
            serialDAO.close();
        }

        // If there are validation errors, return them without executing
        if (!errors.isEmpty()) {
            result.put("success", false);
            result.put("errors", errors);
            return result;
        }

        // Phase 2: Execute Transaction
        boolean originalAutoCommit = true;
        Timestamp effectiveDate = transactionDate != null ? transactionDate : new Timestamp(System.currentTimeMillis());

        try {
            originalAutoCommit = conn.getAutoCommit();
            conn.setAutoCommit(false);

            ProductSerialDAO serialDAOTx = new ProductSerialDAO();

            // Insert all serial numbers
            for (SerialItem item : serialItems) {
                String sku = item.getSku();
                String serialNumber = item.getSerialNumber();
                Integer productId = skuToProductId.get(sku);

                // Insert into ProductSerial with status IN_STOCK
                String insertSerial = "INSERT INTO ProductSerial (product_id, serial_number, status) VALUES (?, ?, 'IN_STOCK')";
                try (PreparedStatement ps = conn.prepareStatement(insertSerial)) {
                    ps.setInt(1, productId);
                    ps.setString(2, serialNumber);
                    ps.executeUpdate();
                }
            }

            serialDAOTx.close();

            // Update Inventory for each product
            for (Map.Entry<Integer, Integer> entry : productCounts.entrySet()) {
                int productId = entry.getKey();
                int quantity = entry.getValue();

                // Update or insert inventory
                String updateInv = "UPDATE Inventory SET quantity = quantity + ? WHERE product_id = ? AND is_active = 1";
                try (PreparedStatement ps = conn.prepareStatement(updateInv)) {
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

                // Insert Transaction record
                String note = buildSerialImportNote(supplier, generalNote, quantity);
                String txSql = "INSERT INTO `Transaction` (product_id, contract_id, type, quantity, transaction_date, note, is_active) VALUES (?, NULL, 'IMPORT', ?, ?, ?, 1)";
                try (PreparedStatement pst = conn.prepareStatement(txSql)) {
                    pst.setInt(1, productId);
                    pst.setInt(2, quantity);
                    pst.setTimestamp(3, effectiveDate);
                    pst.setString(4, note);
                    pst.executeUpdate();
                }
            }

            conn.commit();
            result.put("success", true);
            result.put("message", "Successfully imported " + serialItems.size() + " items with serial numbers");

        } catch (SQLException | RuntimeException ex) {
            try { conn.rollback(); } catch (SQLException ignored) {}
            System.err.println("Error importing with serials: " + ex.getMessage());
            ex.printStackTrace();
            result.put("success", false);
            result.put("errors", Collections.singletonList("Database error: " + ex.getMessage()));
        } finally {
            try { conn.setAutoCommit(originalAutoCommit); } catch (SQLException ignored) {}
        }

        return result;
    }

    private String buildSerialImportNote(String supplier, String generalNote, int quantity) {
        List<String> parts = new ArrayList<>();
        parts.add("Import with serial tracking (" + quantity + " units)");
        if (supplier != null && !supplier.trim().isEmpty()) {
            parts.add("Supplier: " + supplier.trim());
        }
        if (generalNote != null && !generalNote.trim().isEmpty()) {
            parts.add(generalNote.trim());
        }
        return String.join(" | ", parts);
    }

    /**
     * Import products with serial numbers from manual entry (uses product_id instead of SKU)
     * This method handles the complete import flow with serial tracking for manual form submission
     *
     * @param productIds List of product IDs
     * @param serialNumbers List of serial numbers (must match productIds length)
     * @param transactionDate The transaction timestamp
     * @param supplier Supplier name (optional)
     * @param generalNote General note for the transaction
     * @return Map with "success" (Boolean) and "errors" (List<String>) or "message" (String)
     */
    public Map<String, Object> importWithSerialsManual(List<Integer> productIds, List<String> serialNumbers,
                                                        Timestamp transactionDate, String supplier, String generalNote) {
        Map<String, Object> result = new HashMap<>();
        List<String> errors = new ArrayList<>();

        if (productIds == null || productIds.isEmpty() || serialNumbers == null || serialNumbers.isEmpty()) {
            result.put("success", false);
            result.put("errors", Collections.singletonList("No products or serial numbers provided"));
            return result;
        }

        if (productIds.size() != serialNumbers.size()) {
            result.put("success", false);
            result.put("errors", Collections.singletonList("Product IDs and serial numbers count mismatch"));
            return result;
        }

        Connection conn = this.connection;
        if (conn == null) {
            result.put("success", false);
            result.put("errors", Collections.singletonList("Database connection failed"));
            return result;
        }

        // Phase 1: Validation
        ProductSerialDAO serialDAO = new ProductSerialDAO();
        ProductDAO productDAO = new ProductDAO();
        Map<Integer, Integer> productCounts = new HashMap<>();
        Map<Integer, String> productNames = new HashMap<>(); // Cache product names

        try {
            // Pre-load product names for better error messages
            for (Integer productId : productIds) {
                if (!productNames.containsKey(productId)) {
                    data.Product product = productDAO.getProductById(productId);
                    if (product != null) {
                        productNames.put(productId, product.getName());
                    }
                }
            }

            for (int i = 0; i < productIds.size(); i++) {
                Integer productId = productIds.get(i);
                String serialNumber = serialNumbers.get(i);
                String productName = productNames.getOrDefault(productId, "Product ID " + productId);
                int rowNum = i + 1;

                // Validation 1: Check if serial number already exists
                if (serialDAO.serialNumberExists(serialNumber)) {
                    ProductSerial existingSerial = serialDAO.getSerialByNumber(serialNumber);
                    String existingProductName = productNames.get(existingSerial.getProductId());
                    if (existingProductName == null) {
                        data.Product existingProduct = productDAO.getProductById(existingSerial.getProductId());
                        existingProductName = existingProduct != null ? existingProduct.getName() : "Product ID " + existingSerial.getProductId();
                    }
                    errors.add("Row " + rowNum + ": Serial number '" + serialNumber + "' already exists (belongs to '" + existingProductName + "', Status: " + existingSerial.getStatus() + ")");
                    continue;
                }

                // Count products
                productCounts.put(productId, productCounts.getOrDefault(productId, 0) + 1);
            }

            if (!errors.isEmpty()) {
                result.put("success", false);
                result.put("errors", errors);
                productDAO.close();
                return result;
            }

            // Phase 2: Execute transaction
            conn.setAutoCommit(false);

            System.out.println("DEBUG: Starting manual import transaction with " + productIds.size() + " serial numbers");

            // Insert serial numbers
            for (int i = 0; i < productIds.size(); i++) {
                Integer productId = productIds.get(i);
                String serialNumber = serialNumbers.get(i);

                serialDAO.insertSerial(productId, serialNumber, "IN_STOCK");
                System.out.println("DEBUG: Inserted serial: " + serialNumber + " for product_id=" + productId);
            }

            // Update Inventory for each product
            for (Map.Entry<Integer, Integer> entry : productCounts.entrySet()) {
                int productId = entry.getKey();
                int quantity = entry.getValue();

                System.out.println("DEBUG: Updating inventory for product_id=" + productId + ", quantity=" + quantity);

                String updateInv = "UPDATE Inventory SET quantity = quantity + ? WHERE product_id = ? AND is_active = 1";
                try (PreparedStatement ps = conn.prepareStatement(updateInv)) {
                    ps.setInt(1, quantity);
                    ps.setInt(2, productId);
                    int updated = ps.executeUpdate();
                    System.out.println("DEBUG: UPDATE affected " + updated + " rows");

                    if (updated == 0) {
                        System.out.println("DEBUG: No existing inventory found, inserting new record");
                        String insertInv = "INSERT INTO Inventory (product_id, quantity, is_active) VALUES (?, ?, 1)";
                        try (PreparedStatement psi = conn.prepareStatement(insertInv)) {
                            psi.setInt(1, productId);
                            psi.setInt(2, quantity);
                            int inserted = psi.executeUpdate();
                            System.out.println("DEBUG: INSERT affected " + inserted + " rows");
                        }
                    }
                }
            }

            // Create Transaction records
            for (int i = 0; i < productIds.size(); i++) {
                Integer productId = productIds.get(i);
                String serialNumber = serialNumbers.get(i);

                String note = buildSerialImportNote(supplier, generalNote, 1);
                String insertTx = "INSERT INTO `Transaction` (product_id, type, quantity, transaction_date, note) VALUES (?, 'IMPORT', 1, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(insertTx)) {
                    ps.setInt(1, productId);
                    ps.setTimestamp(2, transactionDate);
                    ps.setString(3, note + " | Serial: " + serialNumber);
                    ps.executeUpdate();
                }
            }

            conn.commit();
            System.out.println("DEBUG: Transaction committed successfully!");

            result.put("success", true);
            result.put("message", "Successfully imported " + productIds.size() + " items with serial numbers");
            return result;

        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException rollbackEx) {
                System.err.println("Rollback failed: " + rollbackEx.getMessage());
            }
            e.printStackTrace();
            result.put("success", false);
            result.put("errors", Collections.singletonList("Import failed: " + e.getMessage()));
            return result;
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
            } catch (SQLException ex) {
                System.err.println("Failed to reset auto-commit: " + ex.getMessage());
            }
            if (serialDAO != null) serialDAO.close();
            if (productDAO != null) productDAO.close();
        }
    }

    /**
     * Export products with serial numbers from Excel file
     * This method handles the complete export flow with serial tracking
     *
     * @param serialItems List of serial items from Excel (sku + serial_number)
     * @param transactionDate The transaction timestamp
     * @param generalNote General note for the transaction
     * @return Map with "success" (Boolean) and "errors" (List<String>) or "message" (String)
     */
    public Map<String, Object> exportWithSerials(List<SerialItem> serialItems, Timestamp transactionDate, String generalNote) {
        Map<String, Object> result = new HashMap<>();
        List<String> errors = new ArrayList<>();

        if (serialItems == null || serialItems.isEmpty()) {
            result.put("success", false);
            result.put("errors", Collections.singletonList("No serial items provided"));
            return result;
        }

        Connection conn = this.connection;
        if (conn == null) {
            result.put("success", false);
            result.put("errors", Collections.singletonList("Database connection failed"));
            return result;
        }

        // Phase 1: Validation
        ProductDAO productDAO = new ProductDAO();
        ProductSerialDAO serialDAO = new ProductSerialDAO();
        Map<String, Integer> skuToProductId = new HashMap<>();
        Map<Integer, Integer> productCounts = new HashMap<>();

        try {
            for (SerialItem item : serialItems) {
                String sku = item.getSku();
                String serialNumber = item.getSerialNumber();
                int rowNum = item.getRowNumber();

                // Validation 1: Check if SKU exists and get product_id
                Integer productId = skuToProductId.get(sku);
                if (productId == null) {
                    productId = productDAO.getProductIdBySku(sku);
                    if (productId == null) {
                        errors.add("Row " + rowNum + ": SKU '" + sku + "' not found in database");
                        continue;
                    }
                    skuToProductId.put(sku, productId);
                }

                // Validation 2: Check if serial exists and is IN_STOCK
                if (!serialDAO.isSerialInStock(productId, serialNumber)) {
                    errors.add("Row " + rowNum + ": Serial number '" + serialNumber + "' not found or already sold for SKU '" + sku + "'");
                    continue;
                }

                // Count quantities per product
                productCounts.put(productId, productCounts.getOrDefault(productId, 0) + 1);
            }
        } finally {
            productDAO.close();
            serialDAO.close();
        }

        // If there are validation errors, return them without executing
        if (!errors.isEmpty()) {
            result.put("success", false);
            result.put("errors", errors);
            return result;
        }

        // Phase 2: Execute Transaction
        boolean originalAutoCommit = true;
        Timestamp effectiveDate = transactionDate != null ? transactionDate : new Timestamp(System.currentTimeMillis());

        try {
            originalAutoCommit = conn.getAutoCommit();
            conn.setAutoCommit(false);

            // Mark all serial numbers as SOLD
            for (SerialItem item : serialItems) {
                String serialNumber = item.getSerialNumber();

                // Update ProductSerial status to SOLD
                String updateSerial = "UPDATE ProductSerial SET status = 'SOLD' WHERE serial_number = ?";
                try (PreparedStatement ps = conn.prepareStatement(updateSerial)) {
                    ps.setString(1, serialNumber);
                    int updated = ps.executeUpdate();
                    if (updated == 0) {
                        throw new SQLException("Failed to update serial: " + serialNumber);
                    }
                }
            }

            // Update Inventory for each product
            for (Map.Entry<Integer, Integer> entry : productCounts.entrySet()) {
                int productId = entry.getKey();
                int quantity = entry.getValue();

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

                // Update inventory
                String updateInv = "UPDATE Inventory SET quantity = quantity - ? WHERE product_id = ? AND is_active = 1";
                try (PreparedStatement ps = conn.prepareStatement(updateInv)) {
                    ps.setInt(1, quantity);
                    ps.setInt(2, productId);
                    int updated = ps.executeUpdate();

                    if (updated == 0) {
                        throw new IllegalArgumentException("No inventory record found for product ID " + productId);
                    }
                }

                // Insert Transaction record
                String note = buildSerialExportNote(generalNote, quantity);
                String txSql = "INSERT INTO `Transaction` (product_id, contract_id, type, quantity, transaction_date, note, is_active) VALUES (?, NULL, 'EXPORT', ?, ?, ?, 1)";
                try (PreparedStatement pst = conn.prepareStatement(txSql)) {
                    pst.setInt(1, productId);
                    pst.setInt(2, quantity);
                    pst.setTimestamp(3, effectiveDate);
                    pst.setString(4, note);
                    pst.executeUpdate();
                }
            }

            conn.commit();
            result.put("success", true);
            result.put("message", "Successfully exported " + serialItems.size() + " items with serial numbers");

        } catch (SQLException | RuntimeException ex) {
            try { conn.rollback(); } catch (SQLException ignored) {}
            System.err.println("Error exporting with serials: " + ex.getMessage());
            ex.printStackTrace();
            result.put("success", false);
            result.put("errors", Collections.singletonList("Database error: " + ex.getMessage()));
        } finally {
            try { conn.setAutoCommit(originalAutoCommit); } catch (SQLException ignored) {}
        }

        return result;
    }

    private String buildSerialExportNote(String generalNote, int quantity) {
        List<String> parts = new ArrayList<>();
        parts.add("Export with serial tracking (" + quantity + " units)");
        if (generalNote != null && !generalNote.trim().isEmpty()) {
            parts.add(generalNote.trim());
        }
        return String.join(" | ", parts);
    }

    /**
     * Export products with serial numbers from manual entry (uses product_id instead of SKU)
     * This method handles the complete export flow with serial tracking for manual form submission
     *
     * @param productIds List of product IDs
     * @param serialNumbers List of serial numbers (must match productIds length)
     * @param transactionDate The transaction timestamp
     * @param generalNote General note for the transaction
     * @return Map with "success" (Boolean) and "errors" (List<String>) or "message" (String)
     */
    public Map<String, Object> exportWithSerialsManual(List<Integer> productIds, List<String> serialNumbers,
                                                        Timestamp transactionDate, String generalNote) {
        Map<String, Object> result = new HashMap<>();
        List<String> errors = new ArrayList<>();

        if (productIds == null || productIds.isEmpty() || serialNumbers == null || serialNumbers.isEmpty()) {
            result.put("success", false);
            result.put("errors", Collections.singletonList("No products or serial numbers provided"));
            return result;
        }

        if (productIds.size() != serialNumbers.size()) {
            result.put("success", false);
            result.put("errors", Collections.singletonList("Product IDs and serial numbers count mismatch"));
            return result;
        }

        Connection conn = this.connection;
        if (conn == null) {
            result.put("success", false);
            result.put("errors", Collections.singletonList("Database connection failed"));
            return result;
        }

        // Phase 1: Validation
        ProductSerialDAO serialDAO = new ProductSerialDAO();
        ProductDAO productDAO = new ProductDAO();
        Map<Integer, Integer> productCounts = new HashMap<>();
        Map<Integer, String> productNames = new HashMap<>(); // Cache product names

        try {
            // Pre-load product names for better error messages
            for (Integer productId : productIds) {
                if (!productNames.containsKey(productId)) {
                    data.Product product = productDAO.getProductById(productId);
                    if (product != null) {
                        productNames.put(productId, product.getName());
                    }
                }
            }

            for (int i = 0; i < productIds.size(); i++) {
                Integer productId = productIds.get(i);
                String serialNumber = serialNumbers.get(i);
                String productName = productNames.getOrDefault(productId, "Product ID " + productId);
                int rowNum = i + 1;

                // Validation 1: Check if serial number exists and is IN_STOCK
                ProductSerial serial = serialDAO.getSerialByNumber(serialNumber);
                if (serial == null) {
                    errors.add("Row " + rowNum + ": Serial number '" + serialNumber + "' not found in system");
                    continue;
                }

                if (!"IN_STOCK".equals(serial.getStatus())) {
                    errors.add("Row " + rowNum + ": Serial number '" + serialNumber + "' is not available (Status: " + serial.getStatus() + ")");
                    continue;
                }

                // Validation 2: Check if serial belongs to the specified product
                if (serial.getProductId() != productId) {
                    String actualProductName = productNames.get(serial.getProductId());
                    if (actualProductName == null) {
                        data.Product actualProduct = productDAO.getProductById(serial.getProductId());
                        actualProductName = actualProduct != null ? actualProduct.getName() : "Product ID " + serial.getProductId();
                    }
                    errors.add("Row " + rowNum + ": Serial number '" + serialNumber + "' belongs to '" + actualProductName + "', not '" + productName + "'");
                    continue;
                }

                // Count products
                productCounts.put(productId, productCounts.getOrDefault(productId, 0) + 1);
            }

            if (!errors.isEmpty()) {
                result.put("success", false);
                result.put("errors", errors);
                productDAO.close();
                return result;
            }

            // Phase 2: Execute transaction
            conn.setAutoCommit(false);

            System.out.println("DEBUG: Starting manual export transaction with " + productIds.size() + " serial numbers");

            // Update serial status to SOLD
            for (int i = 0; i < productIds.size(); i++) {
                String serialNumber = serialNumbers.get(i);

                serialDAO.updateSerialStatus(serialNumber, "SOLD");
                System.out.println("DEBUG: Updated serial: " + serialNumber + " to SOLD");
            }

            // Update Inventory for each product
            for (Map.Entry<Integer, Integer> entry : productCounts.entrySet()) {
                int productId = entry.getKey();
                int quantity = entry.getValue();

                System.out.println("DEBUG: Updating inventory for product_id=" + productId + ", quantity=-" + quantity);

                String updateInv = "UPDATE Inventory SET quantity = quantity - ? WHERE product_id = ? AND is_active = 1";
                try (PreparedStatement ps = conn.prepareStatement(updateInv)) {
                    ps.setInt(1, quantity);
                    ps.setInt(2, productId);
                    int updated = ps.executeUpdate();
                    System.out.println("DEBUG: UPDATE affected " + updated + " rows");

                    if (updated == 0) {
                        throw new SQLException("No inventory record found for product_id=" + productId);
                    }
                }
            }

            // Create Transaction records
            for (int i = 0; i < productIds.size(); i++) {
                Integer productId = productIds.get(i);
                String serialNumber = serialNumbers.get(i);

                String note = buildSerialExportNote(generalNote, 1);
                String insertTx = "INSERT INTO `Transaction` (product_id, type, quantity, transaction_date, note) VALUES (?, 'EXPORT', 1, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(insertTx)) {
                    ps.setInt(1, productId);
                    ps.setTimestamp(2, transactionDate);
                    ps.setString(3, note + " | Serial: " + serialNumber);
                    ps.executeUpdate();
                }
            }

            conn.commit();
            System.out.println("DEBUG: Transaction committed successfully!");

            result.put("success", true);
            result.put("message", "Successfully exported " + productIds.size() + " items with serial numbers");
            return result;

        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException rollbackEx) {
                System.err.println("Rollback failed: " + rollbackEx.getMessage());
            }
            e.printStackTrace();
            result.put("success", false);
            result.put("errors", Collections.singletonList("Export failed: " + e.getMessage()));
            return result;
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
            } catch (SQLException ex) {
                System.err.println("Failed to reset auto-commit: " + ex.getMessage());
            }
            if (serialDAO != null) serialDAO.close();
            if (productDAO != null) productDAO.close();
        }
    }
}


