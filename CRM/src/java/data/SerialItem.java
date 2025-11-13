package data;

/**
 * Represents a single serial item from Excel import/export
 */
public class SerialItem {
    private String sku;
    private String serialNumber;
    private int rowNumber; // For error reporting
    
    public SerialItem() {
    }
    
    public SerialItem(String sku, String serialNumber, int rowNumber) {
        this.sku = sku;
        this.serialNumber = serialNumber;
        this.rowNumber = rowNumber;
    }
    
    public String getSku() {
        return sku;
    }
    
    public void setSku(String sku) {
        this.sku = sku;
    }
    
    public String getSerialNumber() {
        return serialNumber;
    }
    
    public void setSerialNumber(String serialNumber) {
        this.serialNumber = serialNumber;
    }
    
    public int getRowNumber() {
        return rowNumber;
    }
    
    public void setRowNumber(int rowNumber) {
        this.rowNumber = rowNumber;
    }
    
    @Override
    public String toString() {
        return "SerialItem{" +
                "sku='" + sku + '\'' +
                ", serialNumber='" + serialNumber + '\'' +
                ", rowNumber=" + rowNumber +
                '}';
    }
}

