/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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
            BrandDAO brandDAO = new BrandDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            
            List<Brand> brands = brandDAO.getAllActiveBrands();
            List<Category> categories = categoryDAO.getAllActiveCategories();
            
            request.setAttribute("brands", brands);
            request.setAttribute("categories", categories);
            
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
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String purchasePriceStr = request.getParameter("purchase_price");
            String sellingPriceStr = request.getParameter("selling_price");
            String categoryIdStr = request.getParameter("category_id");
            String brandIdStr = request.getParameter("brand_id");
            String imageUrl = request.getParameter("image_url");
            String isActiveStr = request.getParameter("is_active");
            
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
            
            Product product = new Product();
            product.setName(name.trim());
            product.setDescription(description != null ? description.trim() : "");
            product.setPurchasePrice(purchasePrice);
            product.setSellingPrice(sellingPrice);
            product.setCategoryId(categoryId);
            product.setBrandId(brandId);
            product.setImageUrl(imageUrl != null ? imageUrl.trim() : "");
            product.setActive(isActive);
            
            ProductDAO productDAO = new ProductDAO();
            int generatedId = productDAO.addProduct(product);
            
            if (generatedId > 0) {
                request.setAttribute("success", "Product '" + name.trim() + "' added successfully!");
                
                // Reload brands and categories for fresh form
                BrandDAO brandDAO = new BrandDAO();
                CategoryDAO categoryDAO = new CategoryDAO();
                
                List<Brand> brands = brandDAO.getAllActiveBrands();
                List<Category> categories = categoryDAO.getAllActiveCategories();
                
                request.setAttribute("brands", brands);
                request.setAttribute("categories", categories);
                
                request.getRequestDispatcher("/warehouse/addProduct.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Failed to save product to database. Please try again.");
                
                BrandDAO brandDAO = new BrandDAO();
                CategoryDAO categoryDAO = new CategoryDAO();
                
                List<Brand> brands = brandDAO.getAllActiveBrands();
                List<Category> categories = categoryDAO.getAllActiveCategories();
                
                request.setAttribute("brands", brands);
                request.setAttribute("categories", categories);
                
                request.getRequestDispatcher("/warehouse/addProduct.jsp").forward(request, response);
            }
            
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Validation error: " + e.getMessage());
            
            BrandDAO brandDAO = new BrandDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            
            List<Brand> brands = brandDAO.getAllActiveBrands();
            List<Category> categories = categoryDAO.getAllActiveCategories();
            
            request.setAttribute("brands", brands);
            request.setAttribute("categories", categories);
            
            request.getRequestDispatcher("/warehouse/addProduct.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error adding product: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "An unexpected error occurred. Please try again later.");
            
            BrandDAO brandDAO = new BrandDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            
            List<Brand> brands = brandDAO.getAllActiveBrands();
            List<Category> categories = categoryDAO.getAllActiveCategories();
            
            request.setAttribute("brands", brands);
            request.setAttribute("categories", categories);
            
            request.getRequestDispatcher("/warehouse/addProduct.jsp").forward(request, response);
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
