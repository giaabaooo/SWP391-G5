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
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;

public class AddExportTransactionController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        ProductDAO productDAO = null;
        CategoryDAO categoryDAO = null;
        try {
            productDAO = new ProductDAO();
            categoryDAO = new CategoryDAO();
            List<Product> products = productDAO.getAllActiveProducts();
            request.setAttribute("products", products);

            List<Category> categories = categoryDAO.getAllActiveCategories();
            request.setAttribute("categories", categories);
        } finally {
            if (productDAO != null) productDAO.close();
            if (categoryDAO != null) categoryDAO.close();
        }

        request.setAttribute("unitOptions", getDefaultUnitOptions());

        request.getRequestDispatcher("/warehouse/exportStock.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String[] productIds = request.getParameterValues("productId");
        String[] quantities = request.getParameterValues("quantity");
        String[] units = request.getParameterValues("unit");
        String[] itemNotes = request.getParameterValues("itemNote");
        String dateParam = request.getParameter("transactionDate");
        String note = request.getParameter("note");

        if (dateParam == null || dateParam.trim().isEmpty()) {
            request.setAttribute("error", "Transaction date/time is required.");
            storeSubmittedItems(request, productIds, quantities, units, itemNotes, note, dateParam);
            doGet(request, response);
            return;
        }

        Timestamp txTime;
        try {
            LocalDateTime parsed = LocalDateTime.parse(dateParam);
            txTime = Timestamp.valueOf(parsed);
        } catch (DateTimeParseException ex) {
            request.setAttribute("error", "Invalid transaction date format.");
            storeSubmittedItems(request, productIds, quantities, units, itemNotes, note, dateParam);
            doGet(request, response);
            return;
        }

        if (productIds == null || quantities == null) {
            request.setAttribute("error", "Please add at least one product line to the export slip.");
            storeSubmittedItems(request, productIds, quantities, units, itemNotes, note, dateParam);
            doGet(request, response);
            return;
        }

        TransactionDAO stockDao = null;
        try {
            stockDao = new TransactionDAO();
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
                    storeSubmittedItems(request, productIds, quantities, units, itemNotes, note, dateParam);
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
                    storeSubmittedItems(request, productIds, quantities, units, itemNotes, note, dateParam);
                    doGet(request, response);
                    return;
                }

                if (quantity <= 0) {
                    request.setAttribute("error", "Quantity must be greater than zero (row " + (i + 1) + ").");
                    storeSubmittedItems(request, productIds, quantities, units, itemNotes, note, dateParam);
                    doGet(request, response);
                    return;
                }

                // Pre-check available stock
                Integer available = stockDao.getCurrentInventoryQuantity(productId);
                int availableQty = available != null ? available : 0;
                if (quantity > availableQty) {
                    request.setAttribute("error", "Export quantity (" + quantity + ") exceeds available stock (" + availableQty + ") for product on row " + (i + 1) + ".");
                    storeSubmittedItems(request, productIds, quantities, units, itemNotes, note, dateParam);
                    doGet(request, response);
                    return;
                }

                items.add(new InventoryTransactionItem(productId, quantity, unit != null ? unit.trim() : null, itemNote != null ? itemNote.trim() : null));
            }

            if (items.isEmpty()) {
                request.setAttribute("error", "Please add at least one product line to the export slip.");
                storeSubmittedItems(request, productIds, quantities, units, itemNotes, note, dateParam);
                doGet(request, response);
                return;
            }

            boolean ok = stockDao.createExportBatchAndUpdateInventory(items, txTime, note);
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?success=Export%20recorded%20successfully");
            } else {
                request.setAttribute("error", "Failed to record export. Please check values and try again.");
                storeSubmittedItems(request, productIds, quantities, units, itemNotes, note, dateParam);
                doGet(request, response);
            }
        } finally {
            if (stockDao != null) stockDao.close();
        }
    }

    private void storeSubmittedItems(HttpServletRequest request, String[] productIds, String[] quantities,
                                     String[] units, String[] itemNotes, String note, String dateParam) {
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
        request.setAttribute("submittedNote", note);
        request.setAttribute("submittedDate", dateParam);
    }

    private List<String> getDefaultUnitOptions() {
        return Collections.unmodifiableList(Arrays.asList("Bộ", "Cái", "Chiếc", "Mét", "Kilogram", "Lít", "Thùng", "Hộp"));
    }
}


