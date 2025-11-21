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

/**
 * Tạo phiếu nhập kho kèm theo danh sách serial
 */
public class AddImportTransactionController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        ProductDAO productDAO = null;
        try {
            // Lấy danh sách sản phẩm đang hoạt động để nhân viên chọn
            productDAO = new ProductDAO();
            List<Product> products = productDAO.getAllActiveProducts();
            request.setAttribute("products", products);
        } finally {
            if (productDAO != null) productDAO.close();
        }

        CategoryDAO categoryDAO = null;
        try {
            // Chuẩn bị thêm danh sách danh mục để lọc/hiển thị thông tin phụ
            categoryDAO = new CategoryDAO();
            List<Category> categories = categoryDAO.getAllActiveCategories();
            request.setAttribute("categories", categories);
        } finally {
            if (categoryDAO != null) categoryDAO.close();
        }

        // Đổ sẵn các đơn vị tính thường dùng
        request.setAttribute("unitOptions", getDefaultUnitOptions());

        String productIdParam = request.getParameter("productId");
        if (productIdParam != null && !productIdParam.isEmpty()) {
            // Nếu người dùng chuyển từ trang chi tiết sản phẩm sang, tự động chọn đúng sản phẩm
            request.setAttribute("prefillProductId", productIdParam);
        }

        request.getRequestDispatcher("/warehouse/importStock.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Bước 1: Thu thập dữ liệu từ form nhập kho
        String[] productIds = request.getParameterValues("productId");
        String[] quantities = request.getParameterValues("quantity");
        String[] units = request.getParameterValues("unit");
        String[] itemNotes = request.getParameterValues("itemNote");
        String[] serialNumbers = request.getParameterValues("serialNumber");
        String dateParam = request.getParameter("transactionDate");
        String supplier = request.getParameter("supplier");
        String note = request.getParameter("note");

        // Bước 2: Xác thực thời gian giao dịch để đảm bảo định dạng chuẩn
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

        if (serialNumbers == null || serialNumbers.length == 0) {
            request.setAttribute("error", "Serial numbers are required. Please enter quantity to generate serial number fields.");
            storeSubmittedItems(request, productIds, quantities, units, itemNotes, supplier, note, dateParam);
            doGet(request, response);
            return;
        }

        // Bước 3: Chuẩn hóa dữ liệu thành danh sách ID + serial để truyền xuống DAO
        List<Integer> productIdList = new ArrayList<>();
        List<String> serialNumberList = new ArrayList<>();

        int serialIndex = 0;

        for (int i = 0; i < productIds.length; i++) {
            String productIdStr = productIds[i];
            String quantityStr = i < quantities.length ? quantities[i] : null;

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

            // Với mỗi sản phẩm phải thu đủ serial tương ứng với số lượng nhập
            for (int j = 0; j < quantity; j++) {
                if (serialIndex >= serialNumbers.length) {
                    request.setAttribute("error", "Missing serial numbers for row " + (i + 1) + ".");
                    storeSubmittedItems(request, productIds, quantities, units, itemNotes, supplier, note, dateParam);
                    doGet(request, response);
                    return;
                }

                String serial = serialNumbers[serialIndex].trim();
                if (serial.isEmpty()) {
                    request.setAttribute("error", "Serial number cannot be empty (row " + (i + 1) + ", serial " + (j + 1) + ").");
                    storeSubmittedItems(request, productIds, quantities, units, itemNotes, supplier, note, dateParam);
                    doGet(request, response);
                    return;
                }

                productIdList.add(productId);
                serialNumberList.add(serial);
                serialIndex++;
            }
        }

        if (productIdList.isEmpty()) {
            request.setAttribute("error", "Please add at least one product line to the import slip.");
            storeSubmittedItems(request, productIds, quantities, units, itemNotes, supplier, note, dateParam);
            doGet(request, response);
            return;
        }

        // Bước 4: Gọi TransactionDAO để ghi nhận phiếu nhập cùng serial
        TransactionDAO transactionDAO = null;
        try {
            transactionDAO = new TransactionDAO();
            java.util.Map<String, Object> result = transactionDAO.importWithSerialsManual(productIdList, serialNumberList, txTime, supplier, note);

            Boolean success = (Boolean) result.get("success");
            if (success != null && success) {
                String message = (String) result.get("message");
                response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?success=" +
                    java.net.URLEncoder.encode(message != null ? message : "Import recorded successfully", "UTF-8"));
            } else {
                @SuppressWarnings("unchecked")
                List<String> errors = (List<String>) result.get("errors");
                StringBuilder errorMsg = new StringBuilder("Import failed:<br>");
                if (errors != null) {
                    for (String error : errors) {
                        errorMsg.append("- ").append(error).append("<br>");
                    }
                }
                request.setAttribute("error", errorMsg.toString());
                storeSubmittedItems(request, productIds, quantities, units, itemNotes, supplier, note, dateParam);
                doGet(request, response);
            }
        } finally {
            if (transactionDAO != null) transactionDAO.close();
        }
    }

    private void storeSubmittedItems(HttpServletRequest request, String[] productIds, String[] quantities,
                                     String[] units, String[] itemNotes, String supplier, String note, String dateParam) {
        // Lưu lại các trường đã nhập để hiển thị lại khi có lỗi
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
        // Danh sách đơn vị cơ bản để chọn nhanh
        return Collections.unmodifiableList(Arrays.asList("Bộ", "Cái", "Chiếc", "Mét", "Kilogram", "Lít", "Thùng", "Hộp"));
    }
}


