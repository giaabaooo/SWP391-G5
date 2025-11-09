package data;

import java.sql.Timestamp;

public class Transaction {
    private int id;
    private int productId;
    private String productName; // Product name for display
    private Integer contractId; // nullable
    private String type; // IMPORT or EXPORT
    private int quantity;
    private Timestamp transactionDate;
    private String note;
    private boolean isActive;

    public Transaction() {}

    public Transaction(int id, int productId, Integer contractId, String type, int quantity, Timestamp transactionDate, String note, boolean isActive) {
        this.id = id;
        this.productId = productId;
        this.contractId = contractId;
        this.type = type;
        this.quantity = quantity;
        this.transactionDate = transactionDate;
        this.note = note;
        this.isActive = isActive;
    }

    public Transaction(int id, int productId, String productName, Integer contractId, String type, int quantity, Timestamp transactionDate, String note, boolean isActive) {
        this.id = id;
        this.productId = productId;
        this.productName = productName;
        this.contractId = contractId;
        this.type = type;
        this.quantity = quantity;
        this.transactionDate = transactionDate;
        this.note = note;
        this.isActive = isActive;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public Integer getContractId() { return contractId; }
    public void setContractId(Integer contractId) { this.contractId = contractId; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public Timestamp getTransactionDate() { return transactionDate; }
    public void setTransactionDate(Timestamp transactionDate) { this.transactionDate = transactionDate; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
}


