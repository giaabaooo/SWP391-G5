<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/jsp/layout/header2.jsp" %>
<%@ include file="/jsp/layout/sidebar2.jsp" %>

<div class="content-wrapper">
    <section class="content p-4">
        <h2>Create New Contract</h2>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/cskh/createContract" 
              method="post" style="max-width: 900px; background: #fff; padding: 20px; border-radius: 8px;">

            <fieldset style="border: 1px solid #ddd; padding: 15px; margin-bottom: 20px;">
                <legend>Contract Information</legend>

                <label>Customer:</label>
                <select name="customerId" required class="form-control" id="customerSelect">
                    <option value="">-- Select a Customer --</option>
                    <c:forEach var="cus" items="${customers}">
                        <option value="${cus.id}">${cus.fullName} - (${cus.email})</option>
                    </c:forEach>
                </select><br>

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
                    <div class="item-row" style="margin-bottom: 10px; padding: 10px; border: 1px solid #eee; border-radius: 5px;">

                        <label>Product:</label>
                        <select name="productId" required class="form-control product-select" style="display: inline-block; width: 200px;">
                            <option value="">-- Select a Product --</option>
                            <c:forEach var="prod" items="${products}">
                                <option value="${prod.id}" data-price="${prod.sellingPrice}">${prod.name}</option>
                            </c:forEach>
                        </select>

                        <label>Qty:</label>
                        <input type="number" name="quantity" required class="form-control qty" style="width: 80px; display: inline-block;" value="1">

                        <label>Price:</label>
                        <input type="number" step="0.01" name="unitPrice" required class="form-control price" style="width: 120px; display: inline-block;" readonly>

                        <div class="serial-container" style="margin-top: 10px; padding-left: 15px; width: 100%;"></div>

                        <label>Warranty (months):</label>
                        <input type="number" name="warrantyMonths" value="12" class="form-control" style="width: 90px; display: inline-block;">

                        <label>Maintenance (months):</label>
                        <input type="number" name="maintenanceMonths" value="24" class="form-control" style="width: 90px; display: inline-block;">

                        <label>Frequency (months):</label>
                        <input type="number" name="maintenanceFrequencyMonths" value="6" class="form-control" style="width: 90px; display: inline-block;">

                        <button type="button" class="btn btn-danger btn-sm remove-item" style="float: right;">X</button>
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

<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

<script>
    document.getElementById("addItemBtn").addEventListener("click", function () {
        const container = document.getElementById("itemContainer");

        const originalItem = container.firstElementChild.cloneNode(true);
        
        originalItem.querySelector(".serial-container").innerHTML = "";

        $(originalItem).find('.select2').remove();

        const productSelect = originalItem.querySelector(".product-select");
        productSelect.selectedIndex = 0;
originalItem.querySelector(".qty").value = "1";
        originalItem.querySelector(".price").value = "";
        originalItem.querySelector(".qty").dataset.initialized = false;
        container.appendChild(originalItem);

        $(productSelect).select2({
            placeholder: "-- Select a Product --",
            allowClear: true,
            width: '200px'
        });

        attachAllListeners();
    });

    function attachRemoveHandlers() {
        document.querySelectorAll(".remove-item").forEach(btn => {
            btn.onclick = function () {
                const rows = document.querySelectorAll(".item-row");
                if (rows.length > 1) {
                    this.closest(".item-row").remove();
                    updateTotal();
                } else {
                    alert("At least one item is required.");
                }
            };
        });
    }

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

        document.querySelectorAll(".qty").forEach(qtyInput => {
            qtyInput.addEventListener("input", function () {
                if (this.value < 1) {
                    this.value = 1;
                }
                updateTotal();
            });
            qtyInput.addEventListener("change", function () {
                if (this.value < 1) {
                    this.value = 1;
                }
                updateTotal();
            });
        });
    }


    function attachProductPriceChange() {
        document.querySelectorAll(".product-select").forEach(select => {
            select.onchange = function () {
                const selectedOption = this.options[this.selectedIndex];
                const price = selectedOption.getAttribute('data-price') || 0;

                const row = this.closest(".item-row");
                const priceInput = row.querySelector(".price");

                priceInput.value = parseFloat(price).toFixed(2);
                updateTotal();
            };
        });
    }

    function attachAllListeners() {
        attachRemoveHandlers();
        attachAutoSum();
        attachProductPriceChange();
        attachSerialGenerator();
    }

    attachAllListeners();
    updateTotal();

    $(document).ready(function () {
        $('#customerSelect').select2({
            placeholder: "-- Select a Customer --",
            allowClear: true,
            width: '100%'
        });

        $('.product-select').select2({
            placeholder: "-- Select a Product --",
            allowClear: true,
            width: '200px'
        });

        const dateInput = document.querySelector('input[name="contractDate"]');
        const today = new Date().toISOString().split('T')[0];
        dateInput.setAttribute('max', today);

        $('form').on('submit', function (e) {
            let isValid = true;
            let errorMsg = "";

            const selectedDate = new Date(dateInput.value);
            const now = new Date();
            if (selectedDate > now) {
                isValid = false;
                errorMsg += "- Contract date cannot be in the future.\n";
            }

            document.querySelectorAll('.qty').forEach(qtyInput => {
                const qty = parseFloat(qtyInput.value);
                if (isNaN(qty) || qty < 1) {
                    isValid = false;
                    errorMsg += "- Quantity must be at least 1.\n";
                }
            });

            if (!isValid) {
                alert("Please fix the following errors:\n\n" + errorMsg);
                e.preventDefault();
            }
        });
    });
    
    // HÀM M?I: T? ??ng t?o ô nh?p serial d?a trên s? l??ng
    function attachSerialGenerator() {
        document.querySelectorAll(".qty").forEach(qtyInput => {
            
            // Dùng 'oninput' ?? ph?n h?i ngay l?p t?c
            qtyInput.oninput = function() {
                const qty = parseInt(this.value) || 0;
                const row = this.closest(".item-row");
                const serialContainer = row.querySelector(".serial-container");
                
                serialContainer.innerHTML = ""; // Xóa các ô input c?
                
                if (qty > 0) {
                    const label = document.createElement('label');
                    label.innerText = "Serial Numbers:";
                    label.style = "display: block; margin-top: 5px;";
                    serialContainer.appendChild(label);
                }

                for (let i = 0; i < qty; i++) {
                    const input = document.createElement("input");
                    input.type = "text";
                    // Tên 'serialNumber' (s? ít) kh?p v?i controller
                    input.name = "serialNumber"; 
                    input.className = "form-control serial-input";
                    input.placeholder = "Serial for Device #" + (i + 1);
                    input.style = "margin-top: 5px; width: 280px;";
                    input.required = true; // B?t bu?c nh?p serial
                    serialContainer.appendChild(input);
                }
            };
            
            // Kích ho?t hàm này 1 l?n khi t?i trang cho hàng ??u tiên
            if (!qtyInput.dataset.initialized) {
                 qtyInput.dispatchEvent(new Event('input'));
                 qtyInput.dataset.initialized = true;
            }
        });
    }
</script>


<%@ include file="/jsp/layout/footer2.jsp" %>