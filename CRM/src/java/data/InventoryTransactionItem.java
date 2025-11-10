package data;

/**
 * Represents a single product line within an inventory import/export slip.
 */
public class InventoryTransactionItem {
    private final int productId;
    private final int quantity;
    private final String unit;
    private final String itemNote;

    public InventoryTransactionItem(int productId, int quantity, String unit, String itemNote) {
        this.productId = productId;
        this.quantity = quantity;
        this.unit = unit;
        this.itemNote = itemNote;
    }

    public int getProductId() {
        return productId;
    }

    public int getQuantity() {
        return quantity;
    }

    public String getUnit() {
        return unit;
    }

    public String getItemNote() {
        return itemNote;
    }
}


