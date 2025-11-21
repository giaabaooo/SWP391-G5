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
 * Chỉnh sửa sản phẩm, bao gồm cập nhật ảnh và thông tin giá
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024 * 1024, maxRequestSize = 6 * 1024 * 1024)
public class EditProductController extends HttpServlet {
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Bước 1: Lấy ID sản phẩm cần chỉnh sửa từ query string
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

                // Bước 2: Lấy chi tiết sản phẩm và danh sách danh mục/thương hiệu để đổ vào form
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
            
            // Bước 3: Chuyển tiếp tới trang chỉnh sửa
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
            // Bước 1: Lấy ID sản phẩm từ form và đảm bảo tồn tại
            String productIdParam = request.getParameter("id");
            if (productIdParam == null || productIdParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?error=Product ID is required");
                return;
            }
            
            int productId = Integer.parseInt(productIdParam);
            
            // Bước 2: Thu thập các trường dữ liệu người dùng nhập
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
            
            // Bước 3: Kiểm tra các trường bắt buộc
            if (name == null || name.trim().isEmpty() || 
                purchasePriceStr == null || purchasePriceStr.trim().isEmpty() ||
                categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
                
                request.setAttribute("error", "Please fill in all required fields");
                doGet(request, response);
                return;
            }
            
            // Bước 4: Parse các giá trị số và ID cần thiết
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
            
            // Bước 5: Nếu người dùng tải ảnh mới thì xử lý lưu xuống thư mục img/products
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
                // Bước 6: Lấy dữ liệu hiện tại để giữ lại ảnh cũ nếu không có ảnh mới
                Product existingProduct = productDAO.getProductById(productId);
                if (existingProduct == null) {
                    response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?error=Product not found");
                    return;
                }
                
                // Bước 7: Đóng gói dữ liệu đã chuẩn hóa vào model Product
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
                
                // Ưu tiên ảnh mới, nếu không có thì dùng URL người dùng nhập hoặc giữ ảnh cũ
                if (storedImagePath != null) {
                    product.setImageUrl(storedImagePath);
                } else if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                    product.setImageUrl(imageUrl.trim());
                } else {
                    product.setImageUrl(existingProduct.getImageUrl());
                }
                
                // Bước 8: Cập nhật DB và phản hồi kết quả
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

