package Controller.warestaff;

import dal.TransactionDAO;
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
import java.util.List;
import java.util.Map;

/**
 * Controller for importing products with serial numbers via Excel file
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
        // Redirect to the main import stock page (which now has tabs)
        response.sendRedirect(request.getContextPath() + "/warestaff/addImportTransaction");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get form parameters
        String dateParam = request.getParameter("transactionDate");
        String supplier = request.getParameter("supplier");
        String note = request.getParameter("note");
        Part filePart = request.getPart("excelFile");
        
        // Validate required fields
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
        
        // Validate file type
        String fileName = getFileName(filePart);
        if (!fileName.toLowerCase().endsWith(".xlsx")) {
            request.setAttribute("error", "Only .xlsx Excel files are supported.");
            doGet(request, response);
            return;
        }
        
        // Parse transaction date
        Timestamp txTime;
        try {
            LocalDateTime parsed = LocalDateTime.parse(dateParam);
            txTime = Timestamp.valueOf(parsed);
        } catch (DateTimeParseException ex) {
            request.setAttribute("error", "Invalid transaction date format.");
            doGet(request, response);
            return;
        }
        
        // Parse Excel file
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
        
        // Process import with serials
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
        String contentDisposition = part.getHeader("content-disposition");
        for (String content : contentDisposition.split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return "unknown";
    }
}

