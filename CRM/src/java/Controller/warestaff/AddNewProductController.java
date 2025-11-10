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
import java.util.Collections;
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
        String successMessage = request.getParameter("success");
        if (successMessage != null && !successMessage.isEmpty()) {
            request.setAttribute("success", successMessage);
        }
        String errorMessage = request.getParameter("error");
        if (errorMessage != null && !errorMessage.isEmpty()) {
            request.setAttribute("error", errorMessage);
        }
        populateDropdownData(request);
        request.getRequestDispatcher("/warehouse/addProduct.jsp").forward(request, response);
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

            populateDropdownData(request);
            request.getRequestDispatcher("/warehouse/addProduct.jsp").forward(request, response);
            
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Validation error: " + e.getMessage());
            populateDropdownData(request);
            request.getRequestDispatcher("/warehouse/addProduct.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error adding product: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "An unexpected error occurred. Please try again later.");
            populateDropdownData(request);
            request.getRequestDispatcher("/warehouse/addProduct.jsp").forward(request, response);
        }
    }

    private void populateDropdownData(HttpServletRequest request) {
        BrandDAO brandDAO = null;
        CategoryDAO categoryDAO = null;
        try {
            brandDAO = new BrandDAO();
            categoryDAO = new CategoryDAO();
            request.setAttribute("brands", brandDAO.getAllActiveBrands());
            request.setAttribute("categories", categoryDAO.getAllActiveCategories());
        } catch (IllegalStateException ex) {
            System.err.println("Database connection unavailable: " + ex.getMessage());
            request.setAttribute("brands", Collections.emptyList());
            request.setAttribute("categories", Collections.emptyList());
            if (request.getAttribute("dropdownError") == null) {
                request.setAttribute("dropdownError", "Unable to load brand and category list right now. Please try again later.");
            }
        } catch (Exception ex) {
            System.err.println("Unexpected error loading dropdown data: " + ex.getMessage());
            ex.printStackTrace();
            request.setAttribute("brands", Collections.emptyList());
            request.setAttribute("categories", Collections.emptyList());
            if (request.getAttribute("dropdownError") == null) {
                request.setAttribute("dropdownError", "An unexpected error occurred while loading dropdown data.");
            }
        } finally {
            if (brandDAO != null) {
                brandDAO.close();
            }
            if (categoryDAO != null) {
                categoryDAO.close();
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
