/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import data.Category;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author vttrung
 */
public class CategoryDAO extends DBContext {

    /**
     * Get all active categories
     *
     * @return List of active categories
     */
    public List<Category> getAllActiveCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT id, name, description, is_active FROM Category WHERE is_active = 1 ORDER BY name";

        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                Category category = new Category(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getBoolean("is_active")
                );
                categories.add(category);
            }

            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.err.println("Error getting categories: " + e.getMessage());
        }

        return categories;
    }

    /**
     * Get all categories (active and inactive)
     *
     * @return List of all categories
     */
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT id, name, description, is_active FROM Category ORDER BY name";

        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                Category category = new Category(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getBoolean("is_active")
                );
                categories.add(category);
            }

            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.err.println("Error getting all categories: " + e.getMessage());
        }

        return categories;
    }

    /**
     * Get category by ID
     *
     * @param id Category ID
     * @return Category object or null if not found
     */
    public Category getCategoryById(int id) {
        String sql = "SELECT id, name, description, is_active FROM Category WHERE id = ?";
        Category category = null;

        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            ResultSet rs = statement.executeQuery();

            if (rs.next()) {
                category = new Category(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getBoolean("is_active")
                );
            }

            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.err.println("Error getting category by ID: " + e.getMessage());
        }

        return category;
    }

    /**
     * Add a new category
     *
     * @param category Category object with name and description
     * @return Generated ID of the new category
     */
    public int addCategory(Category category) {
        String sql = "INSERT INTO Category (name, description, is_active) VALUES (?, ?, ?)";
        int generatedId = -1;

        try {
            PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, category.getName());
            statement.setString(2, category.getDescription());
            statement.setBoolean(3, category.isActive());

            int rowsAffected = statement.executeUpdate();

            if (rowsAffected > 0) {
                ResultSet generatedKeys = statement.getGeneratedKeys();
                if (generatedKeys.next()) {
                    generatedId = generatedKeys.getInt(1);
                }
                generatedKeys.close();
            }

            statement.close();
        } catch (SQLException e) {
            System.err.println("Error adding category: " + e.getMessage());
        }

        return generatedId;
    }

    /**
     * Update an existing category
     *
     * @param category Category object with updated fields
     * @return true if update succeeded
     */
    public boolean updateCategory(Category category) {
        String sql = "UPDATE Category SET name = ?, description = ?, is_active = ? WHERE id = ?";
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, category.getName());
            statement.setString(2, category.getDescription());
            statement.setBoolean(3, category.isActive());
            statement.setInt(4, category.getId());
            int rows = statement.executeUpdate();
            statement.close();
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("Error updating category: " + e.getMessage());
            return false;
        }
    }

    /**
     * Soft delete a category (set is_active = 0)
     */
    public boolean deactivateCategory(int id) {
        String sql = "UPDATE Category SET is_active = 0 WHERE id = ?";
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            int rows = statement.executeUpdate();
            statement.close();
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("Error deactivating category: " + e.getMessage());
            return false;
        }
    }

    /**
     * Activate a category (set is_active = 1)
     */
    public boolean activateCategory(int id) {
        String sql = "UPDATE Category SET is_active = 1 WHERE id = ?";
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            int rows = statement.executeUpdate();
            statement.close();
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("Error activating category: " + e.getMessage());
            return false;
        }
    }

    /**
     * Hard delete a category
     */
    public boolean deleteCategory(int id) {
        String sql = "DELETE FROM Category WHERE id = ?";
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            int rows = statement.executeUpdate();
            statement.close();
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting category: " + e.getMessage());
            return false;
        }
    }

    /**
     * Get total categories with optional search and active filter
     */
    public int getTotalCategoriesWithFilters(String searchQuery, Integer isActive) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) AS total FROM Category WHERE 1=1");
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR description LIKE ?)");
        }
        if (isActive != null) {
            sql.append(" AND is_active = ?");
        }
        int total = 0;
        try {
            PreparedStatement statement = connection.prepareStatement(sql.toString());
            int idx = 1;
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                String like = "%" + searchQuery.trim() + "%";
                statement.setString(idx++, like);
                statement.setString(idx++, like);
            }
            if (isActive != null) {
                statement.setInt(idx++, isActive);
            }
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                total = rs.getInt("total");
            }
            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.err.println("Error counting categories: " + e.getMessage());
        }
        return total;
    }

    /**
     * List categories with pagination, search and active filter
     */
    public List<Category> getCategoriesWithFilters(int page, int pageSize, String searchQuery, Integer isActive) {
        List<Category> categories = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        StringBuilder sql = new StringBuilder("SELECT id, name, description, is_active FROM Category WHERE 1=1");
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR description LIKE ?)");
        }
        if (isActive != null) {
            sql.append(" AND is_active = ?");
        }
        sql.append(" LIMIT ? OFFSET ?");
        try {
            PreparedStatement statement = connection.prepareStatement(sql.toString());
            int idx = 1;
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                String like = "%" + searchQuery.trim() + "%";
                statement.setString(idx++, like);
                statement.setString(idx++, like);
            }
            if (isActive != null) {
                statement.setInt(idx++, isActive);
            }
            statement.setInt(idx++, pageSize);
            statement.setInt(idx++, offset);
            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                Category category = new Category(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getBoolean("is_active")
                );
                categories.add(category);
            }
            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.err.println("Error listing categories: " + e.getMessage());
        }
        return categories;
    }
}