/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.api;


import com.google.gson.Gson;
import dal.ProductDAO;
import data.Product;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 *
 * @author admin
 */
@WebServlet("/api/products/search")
public class ProductSearchController extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String keyword = req.getParameter("keyword");
        String brand = req.getParameter("brand");
        String category = req.getParameter("category");

        Integer brandId = (brand != null && !brand.isEmpty()) ? Integer.parseInt(brand) : null;
        Integer categoryId = (category != null && !category.isEmpty()) ? Integer.parseInt(category) : null;

        List<Product> products = productDAO.searchProducts(keyword, brandId, categoryId);

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        new Gson().toJson(products, resp.getWriter());
    }
}