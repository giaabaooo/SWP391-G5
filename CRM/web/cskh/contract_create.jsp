<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/jsp/layout/header2.jsp" %>
<%@ include file="/jsp/layout/sidebar2.jsp" %>

<div class="content-wrapper">
    <section class="content p-4">
        <h2>Create New Contract</h2>

        <c:if test="${not empty error}">
            <div style="color: red; font-weight: bold; margin-bottom: 15px;">
                ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/cskh/createContract" 
              method="post" style="max-width: 900px; background: #fff; padding: 20px; border-radius: 8px;">

            <fieldset style="border: 1px solid #ddd; padding: 15px; margin-bottom: 20px;">
                <legend>Contract Information</legend>

                <label>Customer ID:</label>
                <input type="number" name="customerId" required class="form-control" placeholder="Enter customer ID"><br>

                <label>Contract Code:</label>
                <input type="text" name="contractCode" required class="form-control" placeholder="E.g. CT2025-001"><br>

                <label>Contract Date:</label>
                <input type="date" name="contractDate" required class="form-control"><br>

                <label>Total Amount:</label>
                <input type="number" step="0.01" name="totalAmount" id="totalAmount" required class="form-control" readonly><br>

                <label>Description:</label>
                <textarea name="description" rows="3" class="form-control" placeholder="Notes..."></textarea>
            </fieldset>

            <fieldset style="border: 1px solid #ddd; padding: 15px;">
                <legend>Contract Items</legend>

                <div id="itemContainer">
                    <div class="item-row" style="margin-bottom: 10px;">
                        <label>Product ID:</label>
                        <input type="number" name="productId" required class="form-control" style="width: 100px; display: inline-block;">

                        <label>Qty:</label>
                        <input type="number" name="quantity" required class="form-control qty" style="width: 80px; display: inline-block;">

                        <label>Price:</label>
                        <input type="number" step="0.01" name="unitPrice" required class="form-control price" style="width: 120px; display: inline-block;">

                        <label>Warranty (months):</label>
                        <input type="number" name="warrantyMonths" value="12" class="form-control" style="width: 90px; display: inline-block;">

                        <label>Maintenance (months):</label>
                        <input type="number" name="maintenanceMonths" value="24" class="form-control" style="width: 90px; display: inline-block;">

                        <label>Frequency (months):</label>
                        <input type="number" name="maintenanceFrequencyMonths" value="6" class="form-control" style="width: 90px; display: inline-block;">

                        <button type="button" class="btn btn-danger btn-sm remove-item">X</button>
                    </div>
                </div>

                <button type="button" id="addItemBtn" class="btn btn-success mt-2">+ Add Another Item</button>
            </fieldset>

            <div style="margin-top: 20px;">
                <button type="submit" class="btn btn-primary">Create Contract</button>
                <a href="${pageContext.request.contextPath}/cskh/contract" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </section>
</div>

<script>
    document.getElementById("addItemBtn").addEventListener("click", function () {
        const container = document.getElementById("itemContainer");
        const newItem = container.firstElementChild.cloneNode(true);
        newItem.querySelectorAll("input").forEach(i => i.value = "");
        container.appendChild(newItem);
        attachRemoveHandlers();
        attachAutoSum();
    });

    function attachRemoveHandlers() {
        document.querySelectorAll(".remove-item").forEach(btn => {
            btn.onclick = function () {
                const rows = document.querySelectorAll(".item-row");
                if (rows.length > 1) {
                    this.parentElement.remove();
                    updateTotal();
                }
            };
        });
    }
    attachRemoveHandlers();

    function updateTotal() {
        let total = 0;
        document.querySelectorAll(".item-row").forEach(row => {
            const qty = parseFloat(row.querySelector(".qty").value) || 0;
            const price = parseFloat(row.querySelector(".price").value) || 0;
            total += qty * price;
        });
        document.getElementById("totalAmount").value = total.toFixed(2);
    }

    function attachAutoSum() {
        document.querySelectorAll(".qty, .price").forEach(input => {
            input.oninput = updateTotal;
        });
    }
    attachAutoSum();
</script>

<%@ include file="/jsp/layout/footer2.jsp" %>
