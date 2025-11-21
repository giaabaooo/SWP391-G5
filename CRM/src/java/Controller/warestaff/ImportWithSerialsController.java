package Controller.warestaff;

import dal.CategoryDAO;
import dal.ProductDAO;
import dal.TransactionDAO;
import data.Category;
import data.Product;
import data.SerialItem;
import util.ExcelSerialParser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

/**
 * Nhập kho bằng file Excel chứa danh sách serial
 */
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class ImportWithSerialsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Tải danh sách sản phẩm và danh mục để hiển thị sẵn trên form
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

        // Thiết lập danh sách đơn vị mặc định
        request.setAttribute("unitOptions", Arrays.asList("Piece", "Box", "Set", "Kg", "Liter", "Meter"));

        // Chuyển tiếp đến trang nhập kho
        request.getRequestDispatcher("/warehouse/importStock.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Bước 1: Lấy các tham số từ form upload Excel
        String dateParam = request.getParameter("transactionDate");
        String supplier = request.getParameter("supplier");
        String note = request.getParameter("note");
        Part filePart = request.getPart("excelFile");
        
        // Bước 2: Kiểm tra ngày nhập và file đính kèm
        if (dateParam == null || dateParam.trim().isEmpty()) {
            request.setAttribute("error", "Transaction date/time is required.");
            doGet(request, response);
            return;
        }
        
        if (filePart == null || filePart.getSize() == 0) {
            request.setAttribute("error", "Please select an Excel file to upload.");
            doGet(request, response);
            return;
        }
        
        // Bước 3: Kiểm tra định dạng file Excel
        String fileName = getFileName(filePart);
        if (!fileName.toLowerCase().endsWith(".xlsx")) {
            request.setAttribute("error", "Only .xlsx Excel files are supported.");
            doGet(request, response);
            return;
        }
        
        // Bước 4: Chuyển chuỗi ngày sang Timestamp để lưu DB
        Timestamp txTime;
        try {
            LocalDateTime parsed = LocalDateTime.parse(dateParam);
            txTime = Timestamp.valueOf(parsed);
        } catch (DateTimeParseException ex) {
            request.setAttribute("error", "Invalid transaction date format.");
            doGet(request, response);
            return;
        }
        
        // Bước 5: Đọc file Excel và biến thành danh sách SerialItem
        List<SerialItem> serialItems;
        try (InputStream fileContent = filePart.getInputStream()) {
            serialItems = ExcelSerialParser.parseExcelFile(fileContent);
        } catch (IllegalArgumentException ex) {
            request.setAttribute("error", "Excel file format error: " + ex.getMessage());
            doGet(request, response);
            return;
        } catch (Exception ex) {
            request.setAttribute("error", "Failed to read Excel file: " + ex.getMessage());
            doGet(request, response);
            return;
        }
        
        // Bước 6: Gọi DAO để tạo phiếu nhập dựa trên danh sách serial
        TransactionDAO transactionDAO = null;
        try {
            transactionDAO = new TransactionDAO();
            Map<String, Object> result = transactionDAO.importWithSerials(serialItems, txTime, supplier, note);
            
            Boolean success = (Boolean) result.get("success");
            if (success != null && success) {
                String message = (String) result.get("message");
                response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?success=" + 
                    java.net.URLEncoder.encode(message, "UTF-8"));
            } else {
                @SuppressWarnings("unchecked")
                List<String> errors = (List<String>) result.get("errors");
                StringBuilder errorMsg = new StringBuilder("Import failed:<br>");
                for (String error : errors) {
                    errorMsg.append("- ").append(error).append("<br>");
                }
                request.setAttribute("error", errorMsg.toString());
                doGet(request, response);
            }
        } finally {
            if (transactionDAO != null) transactionDAO.close();
        }
    }
    
    /**
     * Extract file name from Part header
     */
    private String getFileName(Part part) {
        // Hàm tiện ích tách tên file khỏi header upload
        String contentDisposition = part.getHeader("content-disposition");
        for (String content : contentDisposition.split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return "unknown";
    }
}

