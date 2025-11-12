package data;

/**
 * Represents a product serial number record
 */
public class ProductSerial {
    private int id;
    private int productId;
    private String serialNumber;
    private String status; // IN_STOCK or SOLD
    
    public ProductSerial() {
    }
    
    public ProductSerial(int id, int productId, String serialNumber, String status) {
        this.id = id;
        this.productId = productId;
        this.serialNumber = serialNumber;
        this.status = status;
    }
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getProductId() {
        return productId;
    }
    
    public void setProductId(int productId) {
        this.productId = productId;
    }
    
    public String getSerialNumber() {
        return serialNumber;
    }
    
    public void setSerialNumber(String serialNumber) {
        this.serialNumber = serialNumber;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    @Override
    public String toString() {
        return "ProductSerial{" +
                "id=" + id +
                ", productId=" + productId +
                ", serialNumber='" + serialNumber + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}

