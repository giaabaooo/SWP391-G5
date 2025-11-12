package util;

import data.SerialItem;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

/**
 * Utility class to parse Excel files containing SKU and serial number data
 * Expected format:
 * | sku        | serial_number |
 * |------------|---------------|
 * | SKU-1      | SN-A001       |
 * | SKU-1      | SN-A002       |
 */
public class ExcelSerialParser {
    
    /**
     * Parse Excel file and extract serial items
     * @param inputStream The Excel file input stream
     * @return List of SerialItem objects
     * @throws IOException if file cannot be read
     * @throws IllegalArgumentException if file format is invalid
     */
    public static List<SerialItem> parseExcelFile(InputStream inputStream) throws IOException {
        List<SerialItem> items = new ArrayList<>();
        
        try (Workbook workbook = new XSSFWorkbook(inputStream)) {
            Sheet sheet = workbook.getSheetAt(0); // Read first sheet
            
            if (sheet == null || sheet.getPhysicalNumberOfRows() == 0) {
                throw new IllegalArgumentException("Excel file is empty");
            }
            
            // Read header row to find column indices
            Row headerRow = sheet.getRow(0);
            if (headerRow == null) {
                throw new IllegalArgumentException("Excel file has no header row");
            }
            
            int skuColumnIndex = -1;
            int serialColumnIndex = -1;
            
            for (Cell cell : headerRow) {
                String headerValue = getCellValueAsString(cell).trim().toLowerCase();
                if (headerValue.equals("sku")) {
                    skuColumnIndex = cell.getColumnIndex();
                } else if (headerValue.equals("serial_number") || headerValue.equals("serial number")) {
                    serialColumnIndex = cell.getColumnIndex();
                }
            }
            
            if (skuColumnIndex == -1 || serialColumnIndex == -1) {
                throw new IllegalArgumentException("Excel file must have 'sku' and 'serial_number' columns in the header row");
            }
            
            // Read data rows (skip header)
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) {
                    continue; // Skip empty rows
                }
                
                Cell skuCell = row.getCell(skuColumnIndex);
                Cell serialCell = row.getCell(serialColumnIndex);
                
                String sku = getCellValueAsString(skuCell).trim();
                String serialNumber = getCellValueAsString(serialCell).trim();
                
                // Skip rows where both values are empty
                if (sku.isEmpty() && serialNumber.isEmpty()) {
                    continue;
                }
                
                // Validate that both values are present
                if (sku.isEmpty()) {
                    throw new IllegalArgumentException("Row " + (i + 1) + ": SKU is empty");
                }
                if (serialNumber.isEmpty()) {
                    throw new IllegalArgumentException("Row " + (i + 1) + ": Serial number is empty");
                }
                
                items.add(new SerialItem(sku, serialNumber, i + 1));
            }
            
            if (items.isEmpty()) {
                throw new IllegalArgumentException("Excel file contains no data rows");
            }
        }
        
        return items;
    }
    
    /**
     * Get cell value as string, handling different cell types
     */
    private static String getCellValueAsString(Cell cell) {
        if (cell == null) {
            return "";
        }
        
        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue();
            case NUMERIC:
                // Handle numeric values (convert to string without decimal point if it's a whole number)
                double numValue = cell.getNumericCellValue();
                if (numValue == (long) numValue) {
                    return String.valueOf((long) numValue);
                } else {
                    return String.valueOf(numValue);
                }
            case BOOLEAN:
                return String.valueOf(cell.getBooleanCellValue());
            case FORMULA:
                // Try to get the cached formula result
                try {
                    return cell.getStringCellValue();
                } catch (IllegalStateException e) {
                    return String.valueOf(cell.getNumericCellValue());
                }
            case BLANK:
                return "";
            default:
                return "";
        }
    }
}

