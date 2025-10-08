package data;

import java.math.BigDecimal;
import java.util.Date;

public class Device {
    private int id;
    private int contractItemId;
    private int productId;
    private String productName;
    private String brandName;
    private String categoryName;
    private String serialNumber;
    private Date warrantyExpiration;
    private String status;
    private String imageUrl;
    private BigDecimal purchasePrice;
    private BigDecimal sellingPrice;

    public Device() {}

    public Device(int id, int contractItemId, int productId, String productName,
                  String brandName, String categoryName, String serialNumber,
                  Date warrantyExpiration, String status, String imageUrl) {
        this.id = id;
        this.contractItemId = contractItemId;
        this.productId = productId;
        this.productName = productName;
        this.brandName = brandName;
        this.categoryName = categoryName;
        this.serialNumber = serialNumber;
        this.warrantyExpiration = warrantyExpiration;
        this.status = status;
        this.imageUrl = imageUrl;
        this.purchasePrice = purchasePrice;
        this.sellingPrice = sellingPrice;
        
    }

    // Getter & Setter
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public int getContractItemId() {
        return contractItemId;
    }
    public void setContractItemId(int contractItemId) {
        this.contractItemId = contractItemId;
    }

    public int getProductId() {
        return productId;
    }
    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }
    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getBrandName() {
        return brandName;
    }
    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    public String getCategoryName() {
        return categoryName;
    }
    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getSerialNumber() {
        return serialNumber;
    }
    public void setSerialNumber(String serialNumber) {
        this.serialNumber = serialNumber;
    }

    public Date getWarrantyExpiration() {
        return warrantyExpiration;
    }
    public void setWarrantyExpiration(Date warrantyExpiration) {
        this.warrantyExpiration = warrantyExpiration;
    }

    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }

    public String getImageUrl() {
        return imageUrl;
    }
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    // Kiểm tra bảo hành
    public boolean isUnderWarranty() {
        return "InWarranty".equalsIgnoreCase(status)
                && warrantyExpiration != null
                && warrantyExpiration.after(new Date());
    }

    public BigDecimal getPurchasePrice() {
        return purchasePrice;
    }

    public void setPurchasePrice(BigDecimal purchasePrice) {
        this.purchasePrice = purchasePrice;
    }

    public BigDecimal getSellingPrice() {
        return sellingPrice;
    }

    public void setSellingPrice(BigDecimal sellingPrice) {
        this.sellingPrice = sellingPrice;
    }
    
}
