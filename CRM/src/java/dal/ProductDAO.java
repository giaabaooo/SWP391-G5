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
     *
     * @return List of active products
     */
    public List<Product> getAllActiveProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT id, category_id, brand_id, sku, image_url, name, description, purchase_price, selling_price, unit, is_active FROM Product WHERE is_active = 1 ORDER BY name";

        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                Product product = new Product(
                        rs.getInt("id"),
                        rs.getInt("category_id"),
                        rs.getObject("brand_id", Integer.class),
                        rs.getString("sku"),
                        rs.getString("image_url"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getBigDecimal("purchase_price"),
                        rs.getBigDecimal("selling_price"),
                        rs.getString("unit"),
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
     *
     * @return List of all products
     */
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT id, category_id, brand_id, sku, image_url, name, description, purchase_price, selling_price, unit, is_active FROM Product ORDER BY name";

        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                Product product = new Product(
                        rs.getInt("id"),
                        rs.getInt("category_id"),
                        rs.getObject("brand_id", Integer.class),
                        rs.getString("sku"),
                        rs.getString("image_url"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getBigDecimal("purchase_price"),
                        rs.getBigDecimal("selling_price"),
                        rs.getString("unit"),
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
     *
     * @param id Product ID
     * @return Product object or null if not found
     */
    public Product getProductById(int id) {
        String sql = "SELECT id, category_id, brand_id, sku, image_url, name, description, purchase_price, selling_price, unit, is_active FROM Product WHERE id = ?";
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
                        rs.getString("sku"),
                        rs.getString("image_url"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getBigDecimal("purchase_price"),
                        rs.getBigDecimal("selling_price"),
                        rs.getString("unit"),
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
     * Generate next available SKU
     *
     * @return Next SKU in format "SKU-{number}"
     */
    private String generateNextSku() {
        String sql = "SELECT MAX(CAST(SUBSTRING(sku, 5) AS UNSIGNED)) as max_num FROM Product WHERE sku LIKE 'SKU-%'";
        int maxNum = 0;

        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet rs = statement.executeQuery();

            if (rs.next()) {
                maxNum = rs.getInt("max_num");
            }

            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.err.println("Error generating SKU: " + e.getMessage());
        }

        return "SKU-" + (maxNum + 1);
    }

    /**
     * Add a new product
     *
     * @param product Product object
     * @return Generated ID of the new product
     */
    public int addProduct(Product product) {
        // Generate SKU if not provided
        if (product.getSku() == null || product.getSku().trim().isEmpty()) {
            product.setSku(generateNextSku());
        }

        String sql = "INSERT INTO Product (category_id, brand_id, sku, image_url, name, description, purchase_price, selling_price, unit, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        int generatedId = -1;

        try {
            PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, product.getCategoryId());
            statement.setObject(2, product.getBrandId());
            statement.setString(3, product.getSku());
            statement.setString(4, product.getImageUrl());
            statement.setString(5, product.getName());
            statement.setString(6, product.getDescription());
            statement.setBigDecimal(7, product.getPurchasePrice());
            statement.setBigDecimal(8, product.getSellingPrice());
            statement.setString(9, product.getUnit());
            statement.setBoolean(10, product.isActive());

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
            e.printStackTrace();
        }

        return generatedId;
    }

    /**
     * Get products by category
     *
     * @param categoryId Category ID
     * @return List of products in the category
     */
    public List<Product> getProductsByCategory(int categoryId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT id, category_id, brand_id, sku, image_url, name, description, purchase_price, selling_price, unit, is_active FROM Product WHERE category_id = ? AND is_active = 1 ORDER BY name";

        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, categoryId);
            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                Product product = new Product(
                        rs.getInt("id"),
                        rs.getInt("category_id"),
                        rs.getObject("brand_id", Integer.class),
                        rs.getString("sku"),
                        rs.getString("image_url"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getBigDecimal("purchase_price"),
                        rs.getBigDecimal("selling_price"),
                        rs.getString("unit"),
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
     *
     * @param brandId Brand ID
     * @return List of products from the brand
     */
    public List<Product> getProductsByBrand(int brandId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT id, category_id, brand_id, sku, image_url, name, description, purchase_price, selling_price, unit, is_active FROM Product WHERE brand_id = ? AND is_active = 1 ORDER BY name";

        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, brandId);
            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                Product product = new Product(
                        rs.getInt("id"),
                        rs.getInt("category_id"),
                        rs.getObject("brand_id", Integer.class),
                        rs.getString("sku"),
                        rs.getString("image_url"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getBigDecimal("purchase_price"),
                        rs.getBigDecimal("selling_price"),
                        rs.getString("unit"),
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
     * Get products by category ID (including inactive products)
     *
     * @param categoryId Category ID
     * @return List of products in the category
     */
    public List<Product> getProductsByCategoryId(int categoryId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT id, category_id, brand_id, sku, image_url, name, description, purchase_price, selling_price, unit, is_active FROM Product WHERE category_id = ? ORDER BY name";

        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, categoryId);
            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                Product product = new Product(
                        rs.getInt("id"),
                        rs.getInt("category_id"),
                        rs.getObject("brand_id", Integer.class),
                        rs.getString("sku"),
                        rs.getString("image_url"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getBigDecimal("purchase_price"),
                        rs.getBigDecimal("selling_price"),
                        rs.getString("unit"),
                        rs.getBoolean("is_active")
                );
                products.add(product);
            }

            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.err.println("Error getting products by category ID: " + e.getMessage());
        }

        return products;
    }

    /**
     * Get total count of products by category ID
     *
     * @param categoryId Category ID
     * @return Total number of products in the category
     */
    public int getTotalProductsByCategoryId(int categoryId) {
        String sql = "SELECT COUNT(*) as total FROM Product WHERE category_id = ?";
        int total = 0;

        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, categoryId);
            ResultSet rs = statement.executeQuery();

            if (rs.next()) {
                total = rs.getInt("total");
            }

            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.err.println("Error getting total products by category ID: " + e.getMessage());
        }

        return total;
    }

    /**
     * Get count of active products by category ID
     *
     * @param categoryId Category ID
     * @return Number of active products in the category
     */
    public int getActiveProductsByCategoryId(int categoryId) {
        String sql = "SELECT COUNT(*) as total FROM Product WHERE category_id = ? AND is_active = 1";
        int total = 0;

        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, categoryId);
            ResultSet rs = statement.executeQuery();

            if (rs.next()) {
                total = rs.getInt("total");
            }

            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.err.println("Error getting active products by category ID: " + e.getMessage());
        }

        return total;
    }

    /**
     * Get inventory statistics for products in a category
     *
     * @param categoryId Category ID
     * @return Array with [totalStock, lowStockCount] where lowStockCount is
     * products with stock < 5
     */
    public int[] getInventoryStatsByCategoryId(int categoryId) {
        String sql = "SELECT "
                + "COALESCE(SUM(i.quantity), 0) as total_stock, "
                + "COUNT(CASE WHEN i.quantity < 5 THEN 1 END) as low_stock_count "
                + "FROM Product p "
                + "LEFT JOIN Inventory i ON p.id = i.product_id AND i.is_active = 1 "
                + "WHERE p.category_id = ? AND p.is_active = 1";

        int[] stats = {0, 0};

        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, categoryId);
            ResultSet rs = statement.executeQuery();

            if (rs.next()) {
                stats[0] = rs.getInt("total_stock");
                stats[1] = rs.getInt("low_stock_count");
            }

            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.err.println("Error getting inventory stats by category ID: " + e.getMessage());
        }

        return stats;
    }

    /**
     * Get contract statistics for products in a category
     *
     * @param categoryId Category ID
     * @return Array with [totalContracts, totalRevenue]
     */
    public Object[] getContractStatsByCategoryId(int categoryId) {
        String sql = "SELECT "
                + "COUNT(DISTINCT c.id) as total_contracts, "
                + "COALESCE(SUM(ci.quantity * ci.unit_price), 0) as total_revenue "
                + "FROM Product p "
                + "JOIN ContractItem ci ON p.id = ci.product_id "
                + "JOIN Contract c ON ci.contract_id = c.id "
                + "WHERE p.category_id = ? AND p.is_active = 1";

        Object[] stats = {0, 0.0};

        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, categoryId);
            ResultSet rs = statement.executeQuery();

            if (rs.next()) {
                stats[0] = rs.getInt("total_contracts");
                stats[1] = rs.getBigDecimal("total_revenue");
            }

            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.err.println("Error getting contract stats by category ID: " + e.getMessage());
        }

        return stats;
    }

    /**
     * Get device statistics for products in a category
     *
     * @param categoryId Category ID
     * @return Array with [totalDevices, inWarrantyCount, outOfWarrantyCount]
     */
    public int[] getDeviceStatsByCategoryId(int categoryId) {
        String sql = "SELECT "
                + "COUNT(d.id) as total_devices, "
                + "COUNT(CASE WHEN d.status = 'InWarranty' THEN 1 END) as in_warranty, "
                + "COUNT(CASE WHEN d.status = 'OutOfWarranty' THEN 1 END) as out_of_warranty "
                + "FROM Product p "
                + "JOIN ContractItem ci ON p.id = ci.product_id "
                + "JOIN Device d ON ci.id = d.contract_item_id "
                + "WHERE p.category_id = ? AND p.is_active = 1";

        int[] stats = {0, 0, 0};

        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, categoryId);
            ResultSet rs = statement.executeQuery();

            if (rs.next()) {
                stats[0] = rs.getInt("total_devices");
                stats[1] = rs.getInt("in_warranty");
                stats[2] = rs.getInt("out_of_warranty");
            }

            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.err.println("Error getting device stats by category ID: " + e.getMessage());
        }

        return stats;
    }

    /**
     * Get transaction statistics for products in a category
     *
     * @param categoryId Category ID
     * @return Array with [totalImports, totalExports, lastTransactionDate]
     */
    public Object[] getTransactionStatsByCategoryId(int categoryId) {
        String sql = "SELECT "
                + "COUNT(CASE WHEN t.type = 'IMPORT' THEN 1 END) as total_imports, "
                + "COUNT(CASE WHEN t.type = 'EXPORT' THEN 1 END) as total_exports, "
                + "MAX(t.transaction_date) as last_transaction "
                + "FROM Product p "
                + "JOIN Transaction t ON p.id = t.product_id "
                + "WHERE p.category_id = ? AND p.is_active = 1 AND t.is_active = 1";

        Object[] stats = {0, 0, null};

        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, categoryId);
            ResultSet rs = statement.executeQuery();

            if (rs.next()) {
                stats[0] = rs.getInt("total_imports");
                stats[1] = rs.getInt("total_exports");
                stats[2] = rs.getTimestamp("last_transaction");
            }

            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.err.println("Error getting transaction stats by category ID: " + e.getMessage());
        }

        return stats;
    }

    /**
     * Get brand breakdown for products in a category
     *
     * @param categoryId Category ID
     * @return List of Object arrays with [brandName, productCount]
     */
    public List<Object[]> getBrandBreakdownByCategoryId(int categoryId) {
        List<Object[]> brandBreakdown = new ArrayList<>();
        String sql = "SELECT b.name as brand_name, COUNT(p.id) as product_count "
                + "FROM Product p "
                + "LEFT JOIN Brand b ON p.brand_id = b.id "
                + "WHERE p.category_id = ? AND p.is_active = 1 "
                + "GROUP BY b.id, b.name "
                + "ORDER BY product_count DESC, brand_name";

        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, categoryId);
            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                String brandName = rs.getString("brand_name");
                if (brandName == null) {
                    brandName = "No Brand";
                }
                int productCount = rs.getInt("product_count");
                brandBreakdown.add(new Object[]{brandName, productCount});
            }

            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.err.println("Error getting brand breakdown by category ID: " + e.getMessage());
        }

        return brandBreakdown;
    }

    /**
     * Get total count of all products
     *
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
     *
     * @param page Page number (starting from 1)
     * @param pageSize Number of products per page
     * @return List of products for the specified page
     */
    public List<Product> getProductsPaginated(int page, int pageSize) {
        List<Product> products = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "SELECT id, category_id, brand_id, image_url, name, description, purchase_price, selling_price, is_active "
                + "FROM Product "
                + "LIMIT ? OFFSET ?";

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
     * Get total count of products matching search query using Full-Text Search
     *
     * @param searchQuery Search term
     * @return Total number of matching products
     */
    public int getTotalProductsWithSearch(String searchQuery) {
        int total = 0;

        try {
            // Use Full-Text Search with BOOLEAN MODE for flexible searching
            String sql = "SELECT COUNT(*) as total FROM Product "
                    + "WHERE MATCH(name, description) AGAINST(? IN BOOLEAN MODE)";

            PreparedStatement statement = connection.prepareStatement(sql);

            // Prepare search string: add + before each word to require all words
            String[] keywords = searchQuery.trim().split("\\s+");
            StringBuilder ftSearchQuery = new StringBuilder();
            for (String keyword : keywords) {
                ftSearchQuery.append("+").append(keyword).append("* ");
            }

            statement.setString(1, ftSearchQuery.toString().trim());

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
     * Get products with pagination and search using Full-Text Search
     *
     * @param page Page number (starting from 1)
     * @param pageSize Number of products per page
     * @param searchQuery Search term
     * @return List of products matching search for the specified page
     */
    public List<Product> getProductsPaginatedWithSearch(int page, int pageSize, String searchQuery) {
        List<Product> products = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        try {
            // Use Full-Text Search with BOOLEAN MODE
            String sql = "SELECT id, category_id, brand_id, image_url, name, description, purchase_price, selling_price, is_active "
                    + "FROM Product "
                    + "WHERE MATCH(name, description) AGAINST(? IN BOOLEAN MODE) "
                    + "LIMIT ? OFFSET ?";

            PreparedStatement statement = connection.prepareStatement(sql);

            // Prepare search string: add + before each word to require all words
            String[] keywords = searchQuery.trim().split("\\s+");
            StringBuilder ftSearchQuery = new StringBuilder();
            for (String keyword : keywords) {
                ftSearchQuery.append("+").append(keyword).append("* ");
            }

            statement.setString(1, ftSearchQuery.toString().trim());
            statement.setInt(2, pageSize);
            statement.setInt(3, offset);

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
     * Get total count of products with filters using Full-Text Search
     *
     * @param searchQuery Search term (can be null)
     * @param categoryId Category ID (can be null)
     * @param brandId Brand ID (can be null)
     * @param status Status filter (can be null, 0 for inactive, 1 for active)
     * @return Total number of matching products
     */
    public int getTotalProductsWithFilters(String searchQuery, Integer categoryId, Integer brandId, Integer status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) as total FROM Product WHERE 1=1");

        // Add Full-Text Search condition if search query exists
        boolean hasSearch = (searchQuery != null && !searchQuery.trim().isEmpty());
        if (hasSearch) {
            sql.append(" AND MATCH(name, description) AGAINST(? IN BOOLEAN MODE)");
        }

        if (categoryId != null && categoryId > 0) {
            sql.append(" AND category_id = ?");
        }
        if (brandId != null && brandId > 0) {
            sql.append(" AND brand_id = ?");
        }
        if (status != null) {
            sql.append(" AND is_active = ?");
        }

        int total = 0;

        try {
            PreparedStatement statement = connection.prepareStatement(sql.toString());
            int paramIndex = 1;

            // Set Full-Text Search parameter
            if (hasSearch) {
                String[] keywords = searchQuery.trim().split("\\s+");
                StringBuilder ftSearchQuery = new StringBuilder();
                for (String keyword : keywords) {
                    ftSearchQuery.append("+").append(keyword).append("* ");
                }
                statement.setString(paramIndex++, ftSearchQuery.toString().trim());
            }

            if (categoryId != null && categoryId > 0) {
                statement.setInt(paramIndex++, categoryId);
            }
            if (brandId != null && brandId > 0) {
                statement.setInt(paramIndex++, brandId);
            }
            if (status != null) {
                statement.setInt(paramIndex++, status);
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
     * Get products with pagination and filters using Full-Text Search
     *
     * @param page Page number (starting from 1)
     * @param pageSize Number of products per page
     * @param searchQuery Search term (can be null)
     * @param categoryId Category ID (can be null)
     * @param brandId Brand ID (can be null)
     * @param status Status filter (can be null, 0 for inactive, 1 for active)
     * @return List of products matching filters for the specified page
     */
    public List<Product> getProductsWithFilters(int page, int pageSize, String searchQuery, Integer categoryId, Integer brandId, Integer status) {
        List<Product> products = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        StringBuilder sql = new StringBuilder(
                "SELECT id, category_id, brand_id, sku, image_url, name, description, purchase_price, selling_price, unit, is_active "
                + "FROM Product WHERE 1=1"
        );

        // Add Full-Text Search condition if search query exists
        boolean hasSearch = (searchQuery != null && !searchQuery.trim().isEmpty());
        if (hasSearch) {
            sql.append(" AND MATCH(name, description) AGAINST(? IN BOOLEAN MODE)");
        }

        if (categoryId != null && categoryId > 0) {
            sql.append(" AND category_id = ?");
        }
        if (brandId != null && brandId > 0) {
            sql.append(" AND brand_id = ?");
        }
        if (status != null) {
            sql.append(" AND is_active = ?");
        }

        sql.append(" ORDER BY id ASC LIMIT ? OFFSET ?");

        try {
            PreparedStatement statement = connection.prepareStatement(sql.toString());
            int paramIndex = 1;

            // Set Full-Text Search parameter
            if (hasSearch) {
                String[] keywords = searchQuery.trim().split("\\s+");
                StringBuilder ftSearchQuery = new StringBuilder();
                for (String keyword : keywords) {
                    ftSearchQuery.append("+").append(keyword).append("* ");
                }
                statement.setString(paramIndex++, ftSearchQuery.toString().trim());
            }

            if (categoryId != null && categoryId > 0) {
                statement.setInt(paramIndex++, categoryId);
            }
            if (brandId != null && brandId > 0) {
                statement.setInt(paramIndex++, brandId);
            }
            if (status != null) {
                statement.setInt(paramIndex++, status);
            }

            statement.setInt(paramIndex++, pageSize);
            statement.setInt(paramIndex++, offset);

            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                Product product = new Product(
                        rs.getInt("id"),
                        rs.getInt("category_id"),
                        rs.getObject("brand_id", Integer.class),
                        rs.getString("sku"),
                        rs.getString("image_url"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getBigDecimal("purchase_price"),
                        rs.getBigDecimal("selling_price"),
                        rs.getString("unit"),
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

    /**
     * Update an existing product
     *
     * @param product Product object with updated information
     * @return true if update was successful, false otherwise
     */
    public boolean updateProduct(Product product) {
        String sql = "UPDATE Product SET category_id = ?, brand_id = ?, image_url = ?, name = ?, description = ?, purchase_price = ?, selling_price = ?, unit = ?, is_active = ? WHERE id = ?";

        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, product.getCategoryId());
            statement.setObject(2, product.getBrandId());
            statement.setString(3, product.getImageUrl());
            statement.setString(4, product.getName());
            statement.setString(5, product.getDescription());
            statement.setBigDecimal(6, product.getPurchasePrice());
            statement.setBigDecimal(7, product.getSellingPrice());
            statement.setString(8, product.getUnit());
            statement.setBoolean(9, product.isActive());
            statement.setInt(10, product.getId());

            int rowsAffected = statement.executeUpdate();
            statement.close();

            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating product: " + e.getMessage());
            return false;
        }
    }

    /**
     * Delete a product by ID
     *
     * @param productId Product ID to delete
     * @return true if deletion was successful, false otherwise
     */
    public boolean deleteProduct(int productId) {
        String sql = "DELETE FROM Product WHERE id = ?";

        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, productId);

            int rowsAffected = statement.executeUpdate();
            statement.close();

            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting product: " + e.getMessage());
            return false;
        }
    }

    /**
     * Soft delete a product (set is_active to false)
     *
     * @param productId Product ID to deactivate
     * @return true if deactivation was successful, false otherwise
     */
    public boolean deactivateProduct(int productId) {
        String sql = "UPDATE Product SET is_active = 0 WHERE id = ?";

        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, productId);

            int rowsAffected = statement.executeUpdate();
            statement.close();

            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error deactivating product: " + e.getMessage());
            return false;
        }
    }

    /**
     * Activate a product (set is_active to true)
     *
     * @param productId Product ID to activate
     * @return true if activation was successful, false otherwise
     */
    public boolean activateProduct(int productId) {
        String sql = "UPDATE Product SET is_active = 1 WHERE id = ?";

        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, productId);

            int rowsAffected = statement.executeUpdate();
            statement.close();

            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error activating product: " + e.getMessage());
            return false;
        }
    }

    public List<Product> searchProducts(String keyword, Integer brandId, Integer categoryId) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Product WHERE 1=1 ");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND name LIKE ? ");
        }
        if (brandId != null) {
            sql.append("AND brand_id = ? ");
        }
        if (categoryId != null) {
            sql.append("AND category_id = ? ");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int index = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
            }
            if (brandId != null) {
                ps.setInt(index++, brandId);
            }
            if (categoryId != null) {
                ps.setInt(index++, categoryId);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setBrandId(rs.getInt("brand_id"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setSellingPrice(rs.getBigDecimal("unit_price"));
                p.setDescription(rs.getString("description"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public double getUnitPriceById(int productId) {
        String sql = "SELECT unit_price FROM Product WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("unit_price");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get product ID by SKU
     * @param sku The product SKU
     * @return Product ID or null if not found
     */
    public Integer getProductIdBySku(String sku) {
        String sql = "SELECT id FROM Product WHERE sku = ? AND is_active = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, sku);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting product ID by SKU: " + e.getMessage());
        }
        return null;
    }
}
