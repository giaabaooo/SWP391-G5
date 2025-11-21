/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.warestaff;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
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
import dal.BrandDAO;
import dal.CategoryDAO;
import dal.ProductDAO;
import data.Brand;
import data.Category;
import data.Product;

/**
 *
 * @author vttrung
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024 * 1024, maxRequestSize = 6 * 1024 * 1024)
public class AddNewProductController extends HttpServlet {

    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AddNewProductController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddNewProductController at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Bước 1: Lấy sẵn dữ liệu thương hiệu/nhóm hàng (tận dụng cache session nếu có)
            loadDropdownData(request);

            request.getRequestDispatcher("/warehouse/addProduct.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error loading brands and categories: " + e.getMessage());
            e.printStackTrace();

            request.setAttribute("error", "Unable to load brand and category list. Please try again later.");

            request.getRequestDispatcher("/warehouse/addProduct.jsp").forward(request, response);
        }
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Bước 1: Thu thập toàn bộ tham số người dùng nhập trên form
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
                throw new IllegalArgumentException("Image must be smaller than 5 MB");
            }
            
            // Bước 2: Kiểm tra ràng buộc tối thiểu để tránh dữ liệu trống hoặc sai định dạng
            if (name == null || name.trim().isEmpty()) {
                throw new IllegalArgumentException("Product name is required");
            }
            
            if (categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Category is required");
            }
            
            if (purchasePriceStr == null || purchasePriceStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Purchase price is required");
            }
            
            int categoryId;
            Integer brandId = null;
            BigDecimal purchasePrice;
            BigDecimal sellingPrice = null;
            
            // Bước 3: Chuyển đổi chuỗi sang kiểu số, đồng thời xác thực giá trị hợp lệ
            try {
                categoryId = Integer.parseInt(categoryIdStr);
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Invalid category selection");
            }
            
            if (brandIdStr != null && !brandIdStr.trim().isEmpty()) {
                try {
                    brandId = Integer.parseInt(brandIdStr);
                } catch (NumberFormatException e) {
                    throw new IllegalArgumentException("Invalid brand selection");
                }
            }
            
            try {
                purchasePrice = new BigDecimal(purchasePriceStr);
                if (purchasePrice.compareTo(BigDecimal.ZERO) < 0) {
                    throw new IllegalArgumentException("Purchase price cannot be negative");
                }
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Invalid purchase price format");
            }
            
            if (sellingPriceStr != null && !sellingPriceStr.trim().isEmpty()) {
                try {
                    sellingPrice = new BigDecimal(sellingPriceStr);
                    if (sellingPrice.compareTo(BigDecimal.ZERO) < 0) {
                        throw new IllegalArgumentException("Selling price cannot be negative");
                    }
                } catch (NumberFormatException e) {
                    throw new IllegalArgumentException("Invalid selling price format");
                }
            }
            
            boolean isActive = isActiveStr != null;
            
            // Bước 4: Nếu người dùng tải lên ảnh mới thì lưu file vào thư mục server
            String storedImagePath = null;
            if (imagePart != null && imagePart.getSize() > 0) {
                if (imagePart.getContentType() == null || !imagePart.getContentType().startsWith("image/")) {
                    throw new IllegalArgumentException("Uploaded file must be an image");
                }
                if (imagePart.getSize() > (5L * 1024L * 1024L)) {
                    throw new IllegalArgumentException("Image must be smaller than 5 MB");
                }

                String submittedFileName = imagePart.getSubmittedFileName();
                if (submittedFileName == null) {
                    throw new IllegalArgumentException("Invalid image file");
                }

                String cleanFileName = Paths.get(submittedFileName).getFileName().toString();
                int dotIndex = cleanFileName.lastIndexOf('.');
                String extension = dotIndex >= 0 ? cleanFileName.substring(dotIndex).toLowerCase() : "";
                List<String> allowedExtensions = Arrays.asList(".png", ".jpg", ".jpeg", ".gif", ".webp", ".svg");
                if (extension.isEmpty() || !allowedExtensions.contains(extension)) {
                    throw new IllegalArgumentException("Unsupported image file type. Allowed: PNG, JPG, JPEG, GIF, SVG, WEBP");
                }

                String uploadRoot = request.getServletContext().getRealPath("/img/products");
                if (uploadRoot == null) {
                    throw new IllegalStateException("Unable to resolve upload directory for product images");
                }

                File uploadDir = new File(uploadRoot);
                if (!uploadDir.exists() && !uploadDir.mkdirs()) {
                    throw new IllegalStateException("Unable to create directory for product images");
                }

                String newFileName = "product-" + System.currentTimeMillis() + "-" + UUID.randomUUID() + extension;
                File savedFile = new File(uploadDir, newFileName);
                imagePart.write(savedFile.getAbsolutePath());
                imagePart.delete();

                storedImagePath = "img/products/" + newFileName;
            }

            // Bước 5: Gán dữ liệu đã chuẩn hóa vào đối tượng Product để chuẩn bị ghi DB
            Product product = new Product();
            product.setName(name.trim());
            product.setDescription(description != null ? description.trim() : "");
            product.setPurchasePrice(purchasePrice);
            product.setSellingPrice(sellingPrice);
            product.setCategoryId(categoryId);
            product.setBrandId(brandId);
            product.setUnit(unit != null ? unit.trim() : null);
            if (storedImagePath != null) {
                product.setImageUrl(storedImagePath);
            } else {
                product.setImageUrl(imageUrl != null ? imageUrl.trim() : "");
            }
            product.setActive(isActive);
            
            ProductDAO productDAO = null;
            try {
                productDAO = new ProductDAO();
                // Bước 6: Gọi DAO để lưu sản phẩm mới và điều hướng khi thành công
                int generatedId = productDAO.addProduct(product);
                if (generatedId > 0) {
                    response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?success=" + java.net.URLEncoder.encode("Product '" + name.trim() + "' added successfully!", java.nio.charset.StandardCharsets.UTF_8));
                    return;
                } else {
                    request.setAttribute("error", "Failed to save product to database. Please try again.");
                }
            } finally {
                if (productDAO != null) {
                    productDAO.close();
                }
            }

			loadDropdownData(request);
            request.getRequestDispatcher("/warehouse/addProduct.jsp").forward(request, response);
            
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Validation error: " + e.getMessage());
			loadDropdownData(request);
            request.getRequestDispatcher("/warehouse/addProduct.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error adding product: " + e.getMessage());
            e.printStackTrace();

            request.setAttribute("error", "An unexpected error occurred. Please try again later.");
			loadDropdownData(request);
            request.getRequestDispatcher("/warehouse/addProduct.jsp").forward(request, response);
        }
    }

    /**
     * Helper method to load dropdown data (brands and categories) with session caching
     * This prevents redundant database calls on every request
     */
    private void loadDropdownData(HttpServletRequest request) {
        BrandDAO brandDAO = null;
        CategoryDAO categoryDAO = null;

        try {
            List<Brand> brands = null;
            List<Category> categories = null;

            // Ưu tiên sử dụng dữ liệu đã cache trong session để giảm truy vấn
            if (request.getSession().getAttribute("cachedBrands") != null &&
                request.getSession().getAttribute("cachedCategories") != null) {
                // Lấy trực tiếp từ session
                brands = (List<Brand>) request.getSession().getAttribute("cachedBrands");
                categories = (List<Category>) request.getSession().getAttribute("cachedCategories");
            } else {
                // Nếu chưa có thì truy vấn DB và ghi đệm cho các lần dùng sau
                brandDAO = new BrandDAO();
                categoryDAO = new CategoryDAO();

                brands = brandDAO.getAllActiveBrands();
                categories = categoryDAO.getAllActiveCategories();

                // Lưu lại vào session
                request.getSession().setAttribute("cachedBrands", brands);
                request.getSession().setAttribute("cachedCategories", categories);
            }

            // Gắn vào request để JSP hiển thị dropdown
            request.setAttribute("brands", brands);
            request.setAttribute("categories", categories);

        } catch (Exception e) {
            System.err.println("Error loading dropdown data: " + e.getMessage());
            request.setAttribute("dropdownError", "Unable to refresh brand/category options.");
        } finally {
            // Luôn đóng DAO để tránh rò rỉ kết nối
            if (brandDAO != null) {
                try {
                    brandDAO.close();
                } catch (Exception e) {
                    System.err.println("Error closing BrandDAO: " + e.getMessage());
                }
            }
            if (categoryDAO != null) {
                try {
                    categoryDAO.close();
                } catch (Exception e) {
                    System.err.println("Error closing CategoryDAO: " + e.getMessage());
                }
            }
        }
    }


    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
