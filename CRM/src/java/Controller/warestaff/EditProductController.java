package Controller.warestaff;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import dal.ProductDAO;
import dal.CategoryDAO;
import dal.BrandDAO;
import data.Product;

/**
 * Controller for editing products
 * @author vttrung
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024 * 1024, maxRequestSize = 6 * 1024 * 1024)
public class EditProductController extends HttpServlet {
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Get product ID from parameter
            String productIdParam = request.getParameter("id");
            
            if (productIdParam == null || productIdParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?error=Product ID is required");
                return;
            }
            
            int productId;
            try {
                productId = Integer.parseInt(productIdParam);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?error=Invalid product ID");
                return;
            }
            
            ProductDAO productDAO = null;
            CategoryDAO categoryDAO = null;
            BrandDAO brandDAO = null;
            try {
                productDAO = new ProductDAO();
                categoryDAO = new CategoryDAO();
                brandDAO = new BrandDAO();

                // Get product details
                Product product = productDAO.getProductById(productId);
                
                if (product == null) {
                    response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?error=Product not found");
                    return;
                }
                
                request.setAttribute("product", product);
                request.setAttribute("categories", categoryDAO.getAllCategories());
                request.setAttribute("brands", brandDAO.getAllBrands());
            } finally {
                if (productDAO != null) productDAO.close();
                if (categoryDAO != null) categoryDAO.close();
                if (brandDAO != null) brandDAO.close();
            }
            
            // Forward to edit page
            request.getRequestDispatcher("/warehouse/editProduct.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error loading product for edit: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?error=An error occurred");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Get product ID
            String productIdParam = request.getParameter("id");
            if (productIdParam == null || productIdParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?error=Product ID is required");
                return;
            }
            
            int productId = Integer.parseInt(productIdParam);
            
            // Get form data
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String purchasePriceStr = request.getParameter("purchase_price");
            String sellingPriceStr = request.getParameter("selling_price");
            String categoryIdStr = request.getParameter("category_id");
            String brandIdStr = request.getParameter("brand_id");
            String unit = request.getParameter("unit");
            String imageUrl = request.getParameter("image_url");
            String isActiveStr = request.getParameter("is_active");
            Part imagePart = null;
            try {
                imagePart = request.getPart("image_file");
            } catch (IllegalStateException ex) {
                // File too large, handled below
            } catch (Exception ex) {
                // No file uploaded, that's fine
            }
            
            // Validate required fields
            if (name == null || name.trim().isEmpty() || 
                purchasePriceStr == null || purchasePriceStr.trim().isEmpty() ||
                categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
                
                request.setAttribute("error", "Please fill in all required fields");
                doGet(request, response);
                return;
            }
            
            // Parse values
            BigDecimal purchasePrice = new BigDecimal(purchasePriceStr);
            BigDecimal sellingPrice = null;
            if (sellingPriceStr != null && !sellingPriceStr.trim().isEmpty()) {
                sellingPrice = new BigDecimal(sellingPriceStr);
            }
            
            int categoryId = Integer.parseInt(categoryIdStr);
            Integer brandId = null;
            if (brandIdStr != null && !brandIdStr.trim().isEmpty()) {
                brandId = Integer.parseInt(brandIdStr);
            }
            
            boolean isActive = (isActiveStr != null && isActiveStr.equals("on"));
            
            // Handle image upload
            String storedImagePath = null;
            if (imagePart != null && imagePart.getSize() > 0) {
                if (imagePart.getContentType() == null || !imagePart.getContentType().startsWith("image/")) {
                    request.setAttribute("error", "Uploaded file must be an image");
                    doGet(request, response);
                    return;
                }
                if (imagePart.getSize() > (5L * 1024L * 1024L)) {
                    request.setAttribute("error", "Image must be smaller than 5 MB");
                    doGet(request, response);
                    return;
                }

                String submittedFileName = imagePart.getSubmittedFileName();
                if (submittedFileName == null) {
                    request.setAttribute("error", "Invalid image file");
                    doGet(request, response);
                    return;
                }

                String cleanFileName = Paths.get(submittedFileName).getFileName().toString();
                int dotIndex = cleanFileName.lastIndexOf('.');
                String extension = dotIndex >= 0 ? cleanFileName.substring(dotIndex).toLowerCase() : "";
                List<String> allowedExtensions = Arrays.asList(".png", ".jpg", ".jpeg", ".gif", ".webp", ".svg");
                if (extension.isEmpty() || !allowedExtensions.contains(extension)) {
                    request.setAttribute("error", "Unsupported image file type. Allowed: PNG, JPG, JPEG, GIF, SVG, WEBP");
                    doGet(request, response);
                    return;
                }

                String uploadRoot = request.getServletContext().getRealPath("/img/products");
                if (uploadRoot == null) {
                    request.setAttribute("error", "Unable to resolve upload directory for product images");
                    doGet(request, response);
                    return;
                }

                File uploadDir = new File(uploadRoot);
                if (!uploadDir.exists() && !uploadDir.mkdirs()) {
                    request.setAttribute("error", "Unable to create directory for product images");
                    doGet(request, response);
                    return;
                }

                String newFileName = "product-" + System.currentTimeMillis() + "-" + UUID.randomUUID() + extension;
                File savedFile = new File(uploadDir, newFileName);
                imagePart.write(savedFile.getAbsolutePath());
                imagePart.delete();

                storedImagePath = "img/products/" + newFileName;
            }
            
            ProductDAO productDAO = null;
            try {
                productDAO = new ProductDAO();
                // Get existing product to preserve image if not uploading new one
                Product existingProduct = productDAO.getProductById(productId);
                if (existingProduct == null) {
                    response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?error=Product not found");
                    return;
                }
                
                // Create Product object
                Product product = new Product();
                product.setId(productId);
                product.setCategoryId(categoryId);
                product.setBrandId(brandId);
                product.setUnit(unit != null ? unit.trim() : null);
                product.setName(name.trim());
                product.setDescription(description != null ? description.trim() : "");
                product.setPurchasePrice(purchasePrice);
                product.setSellingPrice(sellingPrice);
                product.setActive(isActive);
                
                // Set image URL - use uploaded file if available, otherwise use URL input, otherwise keep existing
                if (storedImagePath != null) {
                    product.setImageUrl(storedImagePath);
                } else if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                    product.setImageUrl(imageUrl.trim());
                } else {
                    product.setImageUrl(existingProduct.getImageUrl());
                }
                
                // Update product
                boolean success = productDAO.updateProduct(product);
                
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?success=Product updated successfully");
                } else {
                    request.setAttribute("error", "Failed to update product");
                    doGet(request, response);
                }
            } finally {
                if (productDAO != null) productDAO.close();
            }
            
        } catch (NumberFormatException e) {
            System.err.println("Invalid number format: " + e.getMessage());
            request.setAttribute("error", "Invalid number format");
            doGet(request, response);
        } catch (Exception e) {
            System.err.println("Error updating product: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while updating the product");
            doGet(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Edit Product Controller";
    }
}

