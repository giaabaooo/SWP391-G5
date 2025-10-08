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
}
