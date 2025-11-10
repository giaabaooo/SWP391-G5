package Controller.warestaff;

import dal.ProductDAO;
import dal.TransactionDAO;
import dal.CategoryDAO;
import data.Product;
import data.Category;
import data.InventoryTransactionItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class AddImportTransactionController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        ProductDAO productDAO = null;
        try {
            productDAO = new ProductDAO();
            List<Product> products = productDAO.getAllActiveProducts();
            request.setAttribute("products", products);
        } finally {
            if (productDAO != null) productDAO.close();
        }

        CategoryDAO categoryDAO = null;
        try {
            categoryDAO = new CategoryDAO();
            List<Category> categories = categoryDAO.getAllActiveCategories();
            request.setAttribute("categories", categories);
        } finally {
            if (categoryDAO != null) categoryDAO.close();
        }

        request.setAttribute("unitOptions", getDefaultUnitOptions());

        String productIdParam = request.getParameter("productId");
        if (productIdParam != null && !productIdParam.isEmpty()) {
            request.setAttribute("prefillProductId", productIdParam);
        }

        request.getRequestDispatcher("/warehouse/importStock.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String[] productIds = request.getParameterValues("productId");
        String[] quantities = request.getParameterValues("quantity");
        String[] units = request.getParameterValues("unit");
        String[] itemNotes = request.getParameterValues("itemNote");
        String dateParam = request.getParameter("transactionDate");
        String supplier = request.getParameter("supplier");
        String note = request.getParameter("note");

        if (dateParam == null || dateParam.trim().isEmpty()) {
            request.setAttribute("error", "Transaction date/time is required.");
            storeSubmittedItems(request, productIds, quantities, units, itemNotes, supplier, note, dateParam);
            doGet(request, response);
            return;
        }

        Timestamp txTime;
        try {
            LocalDateTime parsed = LocalDateTime.parse(dateParam);
            txTime = Timestamp.valueOf(parsed);
        } catch (DateTimeParseException ex) {
            request.setAttribute("error", "Invalid transaction date format.");
            storeSubmittedItems(request, productIds, quantities, units, itemNotes, supplier, note, dateParam);
            doGet(request, response);
            return;
        }

        if (productIds == null || quantities == null) {
            request.setAttribute("error", "Please add at least one product line to the import slip.");
            storeSubmittedItems(request, productIds, quantities, units, itemNotes, supplier, note, dateParam);
            doGet(request, response);
            return;
        }

        List<InventoryTransactionItem> items = new ArrayList<>();
        for (int i = 0; i < productIds.length; i++) {
            String productIdStr = productIds[i];
            String quantityStr = i < quantities.length ? quantities[i] : null;
            String unit = (units != null && i < units.length) ? units[i] : null;
            String itemNote = (itemNotes != null && i < itemNotes.length) ? itemNotes[i] : null;

            boolean hasProduct = productIdStr != null && !productIdStr.trim().isEmpty();
            boolean hasQuantity = quantityStr != null && !quantityStr.trim().isEmpty();

            if (!hasProduct && !hasQuantity) {
                continue; // skip completely empty rows
            }

            if (!hasProduct || !hasQuantity) {
                request.setAttribute("error", "Each product line must include both a product and a quantity (row " + (i + 1) + ").");
                storeSubmittedItems(request, productIds, quantities, units, itemNotes, supplier, note, dateParam);
                doGet(request, response);
                return;
            }

            int productId;
            int quantity;
            try {
                productId = Integer.parseInt(productIdStr);
                quantity = Integer.parseInt(quantityStr);
            } catch (NumberFormatException ex) {
                request.setAttribute("error", "Invalid number format on row " + (i + 1) + ".");
                storeSubmittedItems(request, productIds, quantities, units, itemNotes, supplier, note, dateParam);
                doGet(request, response);
                return;
            }

            if (quantity <= 0) {
                request.setAttribute("error", "Quantity must be greater than zero (row " + (i + 1) + ").");
                storeSubmittedItems(request, productIds, quantities, units, itemNotes, supplier, note, dateParam);
                doGet(request, response);
                return;
            }

            items.add(new InventoryTransactionItem(productId, quantity, unit != null ? unit.trim() : null, itemNote != null ? itemNote.trim() : null));
        }

        if (items.isEmpty()) {
            request.setAttribute("error", "Please add at least one product line to the import slip.");
            storeSubmittedItems(request, productIds, quantities, units, itemNotes, supplier, note, dateParam);
            doGet(request, response);
            return;
        }

        TransactionDAO transactionDAO = null;
        try {
            transactionDAO = new TransactionDAO();
            boolean ok = transactionDAO.createImportBatchAndUpdateInventory(items, txTime, supplier, note);
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?success=Import%20recorded%20successfully");
            } else {
                request.setAttribute("error", "Failed to record import. Please check values and try again.");
                storeSubmittedItems(request, productIds, quantities, units, itemNotes, supplier, note, dateParam);
                doGet(request, response);
            }
        } finally {
            if (transactionDAO != null) transactionDAO.close();
        }
    }

    private void storeSubmittedItems(HttpServletRequest request, String[] productIds, String[] quantities,
                                     String[] units, String[] itemNotes, String supplier, String note, String dateParam) {
        if (productIds != null) {
            request.setAttribute("submittedProductIds", productIds);
        }
        if (quantities != null) {
            request.setAttribute("submittedQuantities", quantities);
        }
        if (units != null) {
            request.setAttribute("submittedUnits", units);
        }
        if (itemNotes != null) {
            request.setAttribute("submittedItemNotes", itemNotes);
        }
        request.setAttribute("submittedSupplier", supplier);
        request.setAttribute("submittedNote", note);
        request.setAttribute("submittedDate", dateParam);
    }

    private List<String> getDefaultUnitOptions() {
        return Collections.unmodifiableList(Arrays.asList("Bộ", "Cái", "Chiếc", "Mét", "Kilogram", "Lít", "Thùng", "Hộp"));
    }
}


