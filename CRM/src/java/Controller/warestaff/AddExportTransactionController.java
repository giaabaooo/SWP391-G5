package Controller.warestaff;

import dal.ProductDAO;
import dal.TransactionDAO;
import data.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

public class AddExportTransactionController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String productIdParam = request.getParameter("productId");
        ProductDAO productDAO = new ProductDAO();

        if (productIdParam != null && !productIdParam.isEmpty()) {
            try {
                int productId = Integer.parseInt(productIdParam);
                Product product = productDAO.getProductById(productId);
                if (product != null) {
                    request.setAttribute("product", product);
                }
            } catch (NumberFormatException ignored) {}
        } else {
            List<Product> products = productDAO.getAllActiveProducts();
            request.setAttribute("products", products);
        }

        request.getRequestDispatcher("/warehouse/exportStock.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String productIdParam = request.getParameter("productId");
        String quantityParam = request.getParameter("quantity");
        String dateParam = request.getParameter("transactionDate");
        String note = request.getParameter("note");

        int productId;
        int quantity;
        try {
            productId = Integer.parseInt(productIdParam);
            quantity = Integer.parseInt(quantityParam);
        } catch (Exception e) {
            request.setAttribute("error", "Invalid input values");
            doGet(request, response);
            return;
        }

        Timestamp txTime = null;
        try {
            if (dateParam != null && !dateParam.trim().isEmpty()) {
                txTime = Timestamp.valueOf(dateParam.replace("T", " ") + ":00");
            }
        } catch (Exception ignored) {}

        TransactionDAO transactionDAO = new TransactionDAO();
        boolean ok = transactionDAO.createExportAndUpdateInventory(productId, quantity, txTime, note);
        if (ok) {
            response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?success=Export%20recorded%20successfully");
        } else {
            request.setAttribute("error", "Failed to record export. Check stock and try again.");
            doGet(request, response);
        }
    }
}


