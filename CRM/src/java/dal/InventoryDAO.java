/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO for Inventory operations.
 */
public class InventoryDAO extends DBContext {

    /**
     * Get quantities for a list of product IDs in one query.
     * Returns a map of productId -> quantity (defaults to 0 when not found).
     */
    public Map<Integer, Integer> getQuantitiesByProductIds(List<Integer> productIds) {
        Map<Integer, Integer> productIdToQuantity = new HashMap<>();
        if (productIds == null || productIds.isEmpty()) {
            return productIdToQuantity;
        }

        StringBuilder placeholders = new StringBuilder();
        for (int i = 0; i < productIds.size(); i++) {
            if (i > 0) placeholders.append(", ");
            placeholders.append("?");
        }

        String sql = "SELECT product_id, quantity " +
                     "FROM Inventory " +
                     "WHERE is_active = 1 AND product_id IN (" + placeholders + ")";

        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            for (int i = 0; i < productIds.size(); i++) {
                statement.setInt(i + 1, productIds.get(i));
            }

            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                productIdToQuantity.put(rs.getInt("product_id"), rs.getInt("quantity"));
            }
            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.err.println("Error fetching inventory quantities: " + e.getMessage());
        }

        return productIdToQuantity;
    }
}


