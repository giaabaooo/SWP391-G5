/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package data;

/**
 *
 * @author admin
 */
public class ContractItem {

    private int id;
    private int contractId;
    private int productId;
    private int quantity;
    private double unitPrice;
    private int warrantyMonths;
    private int maintenanceMonths;
    private int maintenanceFrequencyMonths;
    private String productName;
    private String brandName;
    private String categoryName;
    private boolean isActive;

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
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

    // Getter & Setter
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getContractId() {
        return contractId;
    }

    public void setContractId(int contractId) {
        this.contractId = contractId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }

    public int getWarrantyMonths() {
        return warrantyMonths;
    }

    public void setWarrantyMonths(int warrantyMonths) {
        this.warrantyMonths = warrantyMonths;
    }

    public int getMaintenanceMonths() {
        return maintenanceMonths;
    }

    public void setMaintenanceMonths(int maintenanceMonths) {
        this.maintenanceMonths = maintenanceMonths;
    }

    public int getMaintenanceFrequencyMonths() {
        return maintenanceFrequencyMonths;
    }

    public void setMaintenanceFrequencyMonths(int maintenanceFrequencyMonths) {
        this.maintenanceFrequencyMonths = maintenanceFrequencyMonths;
    }
}
