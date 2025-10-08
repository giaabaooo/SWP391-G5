/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import data.Brand;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author vttrung
 */
public class BrandDAO extends DBContext {
    
    /**
     * Get all active brands
     * @return List of active brands
     */
    public List<Brand> getAllActiveBrands() {
        List<Brand> brands = new ArrayList<>();
        String sql = "SELECT id, name, description, is_active FROM Brand WHERE is_active = 1 ORDER BY name";
        
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                Brand brand = new Brand(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getBoolean("is_active")
                );
                brands.add(brand);
            }
            
            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.err.println("Error getting brands: " + e.getMessage());
        }
        
        return brands;
    }
    
    /**
     * Get all brands (active and inactive)
     * @return List of all brands
     */
    public List<Brand> getAllBrands() {
        List<Brand> brands = new ArrayList<>();
        String sql = "SELECT id, name, description, is_active FROM Brand ORDER BY name";
        
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                Brand brand = new Brand(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getBoolean("is_active")
                );
                brands.add(brand);
            }
            
            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.err.println("Error getting all brands: " + e.getMessage());
        }
        
        return brands;
    }
    
    /**
     * Get brand by ID
     * @param id Brand ID
     * @return Brand object or null if not found
     */
    public Brand getBrandById(int id) {
        String sql = "SELECT id, name, description, is_active FROM Brand WHERE id = ?";
        Brand brand = null;
        
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                brand = new Brand(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getBoolean("is_active")
                );
            }
            
            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.err.println("Error getting brand by ID: " + e.getMessage());
        }
        
        return brand;
    }
    
    /**
     * Add a new brand
     * @param brand Brand object with name and description
     * @return Generated ID of the new brand
     */
    public int addBrand(Brand brand) {
        String sql = "INSERT INTO Brand (name, description, is_active) VALUES (?, ?, ?)";
        int generatedId = -1;
        
        try {
            PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, brand.getName());
            statement.setString(2, brand.getDescription());
            statement.setBoolean(3, brand.isActive());
            
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
            System.err.println("Error adding brand: " + e.getMessage());
        }
        
        return generatedId;
    }
}
