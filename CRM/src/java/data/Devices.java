package data;

import java.util.Date;

public class Devices {
    private int deviceId;
    private int deviceDetailId;
    private String productName;
    private String serialNumber;
    private String imageUrl;
    private Date warrantyExpiration;
    private String status;
    private String brandName;

    public Devices() {
    }

    public Devices(int deviceId, int deviceDetailId, String productName, String serialNumber,
                   String imageUrl, Date warrantyExpiration, String status) {
        this.deviceId = deviceId;
        this.deviceDetailId = deviceDetailId;
        this.productName = productName;
        this.serialNumber = serialNumber;
        this.imageUrl = imageUrl;
        this.warrantyExpiration = warrantyExpiration;
        this.status = status;
        this.brandName = brandName;
        
    }

    // Method kiểm tra bảo hành
    public boolean isUnderWarranty() {
        return "ACTIVE".equalsIgnoreCase(status)
                && warrantyExpiration != null
                && warrantyExpiration.after(new Date());
    }

    // Getters & Setters
    public int getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(int deviceId) {
        this.deviceId = deviceId;
    }

    public int getDeviceDetailId() {
        return deviceDetailId;
    }

    public void setDeviceDetailId(int deviceDetailId) {
        this.deviceDetailId = deviceDetailId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getSerialNumber() {
        return serialNumber;
    }

    public void setSerialNumber(String serialNumber) {
        this.serialNumber = serialNumber;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
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
    public String getBrandName() { return brandName; }
    public void setBrandName(String brandName) { this.brandName = brandName; }
}
