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
 * Xuất kho bằng cách tải file Excel chứa danh sách serial
 */
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class ExportWithSerialsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng về trang export chính (nơi có tab tải Excel) để tránh duplicate form
        response.sendRedirect(request.getContextPath() + "/warestaff/addExportTransaction");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Bước 1: Thu thập dữ liệu từ form tải Excel
        String dateParam = request.getParameter("transactionDate");
        String note = request.getParameter("note");
        Part filePart = request.getPart("excelFile");
        String exportType = request.getParameter("exportType");

        // Bước 2: Kiểm tra ngày giao dịch và loại phiếu xuất
        if (dateParam == null || dateParam.trim().isEmpty()) {
            request.setAttribute("error", "Transaction date/time is required.");
            doGet(request, response);
            return;
        }

        if (exportType == null || exportType.trim().isEmpty()) {
            request.setAttribute("error", "Export type is required.");
            doGet(request, response);
            return;
        }
        if (!"DELIVERED".equals(exportType) && !"WRITTEN_OFF".equals(exportType)) {
            request.setAttribute("error", "Invalid export type specified.");
            doGet(request, response);
            return;
        }

        if (filePart == null || filePart.getSize() == 0) {
            request.setAttribute("error", "Please select an Excel file to upload.");
            doGet(request, response);
            return;
        }

        // Bước 3: Đảm bảo file Excel hợp lệ
        String fileName = getFileName(filePart);
        if (!fileName.toLowerCase().endsWith(".xlsx")) {
            request.setAttribute("error", "Only .xlsx Excel files are supported.");
            doGet(request, response);
            return;
        }

        // Bước 4: Chuyển chuỗi ngày giờ sang Timestamp
        Timestamp txTime;
        try {
            LocalDateTime parsed = LocalDateTime.parse(dateParam);
            txTime = Timestamp.valueOf(parsed);
        } catch (DateTimeParseException ex) {
            request.setAttribute("error", "Invalid transaction date format.");
            doGet(request, response);
            return;
        }

        // Bước 5: Đọc file Excel và biến đổi thành danh sách SerialItem
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

        // Bước 6: Gọi DAO để tạo phiếu xuất dựa trên danh sách serial đọc được
        TransactionDAO transactionDAO = null;
        try {
            transactionDAO = new TransactionDAO();
            Map<String, Object> result = transactionDAO.exportWithSerials(serialItems, txTime, note, exportType);

            Boolean success = (Boolean) result.get("success");
            if (success != null && success) {
                String message = (String) result.get("message");
                response.sendRedirect(request.getContextPath() + "/warestaff/viewListProduct?success="
                        + java.net.URLEncoder.encode(message, "UTF-8"));
            } else {
                @SuppressWarnings("unchecked")
                List<String> errors = (List<String>) result.get("errors");
                StringBuilder errorMsg = new StringBuilder("Export failed:<br>");
                for (String error : errors) {
                    errorMsg.append("- ").append(error).append("<br>");
                }
                request.setAttribute("error", errorMsg.toString());
                doGet(request, response);
            }
        } finally {
            if (transactionDAO != null) {
                transactionDAO.close();
            }
        }
    }

    /**
     * Extract file name from Part header
     */
    private String getFileName(Part part) {
        // Hàm tiện ích để lấy tên file từ header content-disposition
        String contentDisposition = part.getHeader("content-disposition");
        for (String content : contentDisposition.split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return "unknown";
    }
}
