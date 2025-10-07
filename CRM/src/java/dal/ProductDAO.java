/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import data.Product;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author vttrung
 */
public class ProductDAO extends DBContext {
    
    /**
     * Get all active products
     * @return List of active products
     */
    public List<Product> getAllActiveProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT id, category_id, brand_id, image_url, name, description, purchase_price, selling_price, is_active FROM Product WHERE is_active = 1 ORDER BY name";
        
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                Product product = new Product(
                    rs.getInt("id"),
                    rs.getInt("category_id"),
                    rs.getObject("brand_id", Integer.class),
                    rs.getString("image_url"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getBigDecimal("purchase_price"),
                    rs.getBigDecimal("selling_price"),
                    rs.getBoolean("is_active")
                );
                products.add(product);
            }
            
            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.err.println("Error getting products: " + e.getMessage());
        }
        
        return products;
    }
    
    /**
     * Get all products (active and inactive)
     * @return List of all products
     */
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT id, category_id, brand_id, image_url, name, description, purchase_price, selling_price, is_active FROM Product ORDER BY name";
        
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                Product product = new Product(
                    rs.getInt("id"),
                    rs.getInt("category_id"),
                    rs.getObject("brand_id", Integer.class),
                    rs.getString("image_url"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getBigDecimal("purchase_price"),
                    rs.getBigDecimal("selling_price"),
                    rs.getBoolean("is_active")
                );
                products.add(product);
            }
            
            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.err.println("Error getting all products: " + e.getMessage());
        }
        
        return products;
    }
    
    /**
     * Get product by ID
     * @param id Product ID
     * @return Product object or null if not found
     */
    public Product getProductById(int id) {
        String sql = "SELECT id, category_id, brand_id, image_url, name, description, purchase_price, selling_price, is_active FROM Product WHERE id = ?";
        Product product = null;
        
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                product = new Product(
                    rs.getInt("id"),
                    rs.getInt("category_id"),
                    rs.getObject("brand_id", Integer.class),
                    rs.getString("image_url"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getBigDecimal("purchase_price"),
                    rs.getBigDecimal("selling_price"),
                    rs.getBoolean("is_active")
                );
            }
            
            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.err.println("Error getting product by ID: " + e.getMessage());
        }
        
        return product;
    }
    
    /**
     * Add a new product
     * @param product Product object
     * @return Generated ID of the new product
     */
    public int addProduct(Product product) {
        String sql = "INSERT INTO Product (category_id, brand_id, image_url, name, description, purchase_price, selling_price, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        int generatedId = -1;
        
        try {
            PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, product.getCategoryId());
            statement.setObject(2, product.getBrandId());
            statement.setString(3, product.getImageUrl());
            statement.setString(4, product.getName());
            statement.setString(5, product.getDescription());
            statement.setBigDecimal(6, product.getPurchasePrice());
            statement.setBigDecimal(7, product.getSellingPrice());
            statement.setBoolean(8, product.isActive());
            
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
            System.err.println("Error adding product: " + e.getMessage());
        }
        
        return generatedId;
    }
    
    /**
     * Get products by category
     * @param categoryId Category ID
     * @return List of products in the category
     */
    public List<Product> getProductsByCategory(int categoryId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT id, category_id, brand_id, image_url, name, description, purchase_price, selling_price, is_active FROM Product WHERE category_id = ? AND is_active = 1 ORDER BY name";
        
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, categoryId);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                Product product = new Product(
                    rs.getInt("id"),
                    rs.getInt("category_id"),
                    rs.getObject("brand_id", Integer.class),
                    rs.getString("image_url"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getBigDecimal("purchase_price"),
                    rs.getBigDecimal("selling_price"),
                    rs.getBoolean("is_active")
                );
                products.add(product);
            }
            
            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.err.println("Error getting products by category: " + e.getMessage());
        }
        
        return products;
    }
    
    /**
     * Get products by brand
     * @param brandId Brand ID
     * @return List of products from the brand
     */
    public List<Product> getProductsByBrand(int brandId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT id, category_id, brand_id, image_url, name, description, purchase_price, selling_price, is_active FROM Product WHERE brand_id = ? AND is_active = 1 ORDER BY name";
        
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, brandId);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                Product product = new Product(
                    rs.getInt("id"),
                    rs.getInt("category_id"),
                    rs.getObject("brand_id", Integer.class),
                    rs.getString("image_url"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getBigDecimal("purchase_price"),
                    rs.getBigDecimal("selling_price"),
                    rs.getBoolean("is_active")
                );
                products.add(product);
            }
            
            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.err.println("Error getting products by brand: " + e.getMessage());
        }
        
        return products;
    }
    
    /**
     * Get total count of all products
     * @return Total number of products
     */
    public int getTotalProducts() {
        String sql = "SELECT COUNT(*) as total FROM Product";
        int total = 0;
        
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                total = rs.getInt("total");
            }
            
            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.err.println("Error getting total products: " + e.getMessage());
        }
        
        return total;
    }
    
    /**
     * Get products with pagination
     * @param page Page number (starting from 1)
     * @param pageSize Number of products per page
     * @return List of products for the specified page
     */
    public List<Product> getProductsPaginated(int page, int pageSize) {
        List<Product> products = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "SELECT id, category_id, brand_id, image_url, name, description, purchase_price, selling_price, is_active " +
                     "FROM Product " +
                     "ORDER BY id DESC " +
                     "LIMIT ? OFFSET ?";
        
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, pageSize);
            statement.setInt(2, offset);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                Product product = new Product(
                    rs.getInt("id"),
                    rs.getInt("category_id"),
                    rs.getObject("brand_id", Integer.class),
                    rs.getString("image_url"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getBigDecimal("purchase_price"),
                    rs.getBigDecimal("selling_price"),
                    rs.getBoolean("is_active")
                );
                products.add(product);
            }
            
            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.err.println("Error getting paginated products: " + e.getMessage());
        }
        
        return products;
    }
    
    /**
     * Get total count of products matching search query
     * @param searchQuery Search term
     * @return Total number of matching products
     */
    public int getTotalProductsWithSearch(String searchQuery) {
        String sql = "SELECT COUNT(*) as total FROM Product WHERE name LIKE ? OR description LIKE ?";
        int total = 0;
        
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            String searchPattern = "%" + searchQuery + "%";
            statement.setString(1, searchPattern);
            statement.setString(2, searchPattern);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                total = rs.getInt("total");
            }
            
            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.err.println("Error getting total products with search: " + e.getMessage());
        }
        
        return total;
    }
    
    /**
     * Get products with pagination and search
     * @param page Page number (starting from 1)
     * @param pageSize Number of products per page
     * @param searchQuery Search term
     * @return List of products matching search for the specified page
     */
    public List<Product> getProductsPaginatedWithSearch(int page, int pageSize, String searchQuery) {
        List<Product> products = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "SELECT id, category_id, brand_id, image_url, name, description, purchase_price, selling_price, is_active " +
                     "FROM Product " +
                     "WHERE name LIKE ? OR description LIKE ? " +
                     "ORDER BY id DESC " +
                     "LIMIT ? OFFSET ?";
        
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            String searchPattern = "%" + searchQuery + "%";
            statement.setString(1, searchPattern);
            statement.setString(2, searchPattern);
            statement.setInt(3, pageSize);
            statement.setInt(4, offset);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                Product product = new Product(
                    rs.getInt("id"),
                    rs.getInt("category_id"),
                    rs.getObject("brand_id", Integer.class),
                    rs.getString("image_url"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getBigDecimal("purchase_price"),
                    rs.getBigDecimal("selling_price"),
                    rs.getBoolean("is_active")
                );
                products.add(product);
            }
            
            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.err.println("Error getting paginated products with search: " + e.getMessage());
        }
        
        return products;
    }
    
    /**
     * Get total count of products with filters
     * @param searchQuery Search term (can be null)
     * @param categoryId Category ID (can be null)
     * @param brandId Brand ID (can be null)
     * @return Total number of matching products
     */
    public int getTotalProductsWithFilters(String searchQuery, Integer categoryId, Integer brandId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) as total FROM Product WHERE 1=1");
        
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR description LIKE ?)");
        }
        if (categoryId != null && categoryId > 0) {
            sql.append(" AND category_id = ?");
        }
        if (brandId != null && brandId > 0) {
            sql.append(" AND brand_id = ?");
        }
        
        int total = 0;
        
        try {
            PreparedStatement statement = connection.prepareStatement(sql.toString());
            int paramIndex = 1;
            
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                String searchPattern = "%" + searchQuery + "%";
                statement.setString(paramIndex++, searchPattern);
                statement.setString(paramIndex++, searchPattern);
            }
            if (categoryId != null && categoryId > 0) {
                statement.setInt(paramIndex++, categoryId);
            }
            if (brandId != null && brandId > 0) {
                statement.setInt(paramIndex++, brandId);
            }
            
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                total = rs.getInt("total");
            }
            
            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.err.println("Error getting total products with filters: " + e.getMessage());
        }
        
        return total;
    }
    
    /**
     * Get products with pagination and filters
     * @param page Page number (starting from 1)
     * @param pageSize Number of products per page
     * @param searchQuery Search term (can be null)
     * @param categoryId Category ID (can be null)
     * @param brandId Brand ID (can be null)
     * @return List of products matching filters for the specified page
     */
    public List<Product> getProductsWithFilters(int page, int pageSize, String searchQuery, Integer categoryId, Integer brandId) {
        List<Product> products = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        StringBuilder sql = new StringBuilder(
            "SELECT id, category_id, brand_id, image_url, name, description, purchase_price, selling_price, is_active " +
            "FROM Product WHERE 1=1"
        );
        
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR description LIKE ?)");
        }
        if (categoryId != null && categoryId > 0) {
            sql.append(" AND category_id = ?");
        }
        if (brandId != null && brandId > 0) {
            sql.append(" AND brand_id = ?");
        }
        
        sql.append(" ORDER BY id DESC LIMIT ? OFFSET ?");
        
        try {
            PreparedStatement statement = connection.prepareStatement(sql.toString());
            int paramIndex = 1;
            
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                String searchPattern = "%" + searchQuery + "%";
                statement.setString(paramIndex++, searchPattern);
                statement.setString(paramIndex++, searchPattern);
            }
            if (categoryId != null && categoryId > 0) {
                statement.setInt(paramIndex++, categoryId);
            }
            if (brandId != null && brandId > 0) {
                statement.setInt(paramIndex++, brandId);
            }
            
            statement.setInt(paramIndex++, pageSize);
            statement.setInt(paramIndex++, offset);
            
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                Product product = new Product(
                    rs.getInt("id"),
                    rs.getInt("category_id"),
                    rs.getObject("brand_id", Integer.class),
                    rs.getString("image_url"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getBigDecimal("purchase_price"),
                    rs.getBigDecimal("selling_price"),
                    rs.getBoolean("is_active")
                );
                products.add(product);
            }
            
            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.err.println("Error getting products with filters: " + e.getMessage());
        }
        
        return products;
    }
}
