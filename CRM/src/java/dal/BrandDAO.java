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

    /**
     * Update an existing brand
     */
    public boolean updateBrand(Brand brand) {
        String sql = "UPDATE Brand SET name = ?, description = ?, is_active = ? WHERE id = ?";
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, brand.getName());
            statement.setString(2, brand.getDescription());
            statement.setBoolean(3, brand.isActive());
            statement.setInt(4, brand.getId());
            int rows = statement.executeUpdate();
            statement.close();
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("Error updating brand: " + e.getMessage());
            return false;
        }
    }

    /**
     * Soft delete: deactivate brand
     */
    public boolean deactivateBrand(int id) {
        String sql = "UPDATE Brand SET is_active = 0 WHERE id = ?";
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            int rows = statement.executeUpdate();
            statement.close();
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("Error deactivating brand: " + e.getMessage());
            return false;
        }
    }

    /**
     * Hard delete brand (use with caution)
     */
    public boolean deleteBrand(int id) {
        String sql = "DELETE FROM Brand WHERE id = ?";
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            int rows = statement.executeUpdate();
            statement.close();
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting brand: " + e.getMessage());
            return false;
        }
    }

    /**
     * Get brands with pagination, search and active filter
     */
    public List<Brand> getBrandsWithFilters(int page, int pageSize, String search, Integer isActive) {
        List<Brand> brands = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT id, name, description, is_active FROM Brand WHERE 1=1 ");
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND name LIKE ? ");
        }
        if (isActive != null) {
            sql.append("AND is_active = ? ");
        }
        sql.append("ORDER BY name LIMIT ? OFFSET ?");

        try {
            PreparedStatement statement = connection.prepareStatement(sql.toString());
            int idx = 1;
            if (search != null && !search.trim().isEmpty()) {
                statement.setString(idx++, "%" + search.trim() + "%");
            }
            if (isActive != null) {
                statement.setInt(idx++, isActive);
            }
            statement.setInt(idx++, pageSize);
            statement.setInt(idx, (page - 1) * pageSize);

            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                brands.add(new Brand(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getBoolean("is_active")
                ));
            }
            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.err.println("Error getting brands with filters: " + e.getMessage());
        }
        return brands;
    }

    /**
     * Count total brands with filters
     */
    public int getTotalBrandsWithFilters(String search, Integer isActive) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) AS total FROM Brand WHERE 1=1 ");
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND name LIKE ? ");
        }
        if (isActive != null) {
            sql.append("AND is_active = ? ");
        }

        try {
            PreparedStatement statement = connection.prepareStatement(sql.toString());
            int idx = 1;
            if (search != null && !search.trim().isEmpty()) {
                statement.setString(idx++, "%" + search.trim() + "%");
            }
            if (isActive != null) {
                statement.setInt(idx++, isActive);
            }
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                int total = rs.getInt("total");
                rs.close();
                statement.close();
                return total;
            }
            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.err.println("Error counting brands with filters: " + e.getMessage());
        }
        return 0;
    }
}
