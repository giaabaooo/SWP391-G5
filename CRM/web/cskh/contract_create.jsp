<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/cskh/layout/header.jsp" %>
<%@ include file="/cskh/layout/sidebar.jsp" %>

<div class="content-wrapper">
    <section class="content p-4">
        <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">Create New Contract</h1>
        <ol class="breadcrumb" style="background: none; padding: 0; margin-bottom: 2rem;">
            <li><a href="${pageContext.request.contextPath}/cskh/dashboard"><i class="fa fa-dashboard"></i> Home</a></li>
            <li><a href="${pageContext.request.contextPath}/cskh/contract">Contracts</a></li>
            <li class="active">Create Contract</li>
        </ol>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                ${error}
            </div>
        </c:if>

        <div class="content-card">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/cskh/createContract" 
                      method="post">

                    <fieldset style="border: 1px solid #ddd; padding: 15px; margin-bottom: 20px; border-radius: 5px;">
                        <legend style="width: auto; padding: 0 10px; margin-bottom: 10px; border-bottom: none;">Contract Information</legend>

                        <div class="form-group">
                            <label>Customer:</label>
                            <select name="customerId" required class="form-control" id="customerSelect">
                                <option value="">-- Select a Customer --</option>
                                <c:forEach var="cus" items="${customers}">
                                    <option value="${cus.id}">${cus.fullName} - (${cus.email})</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>Contract Date:</label>
                                    <input type="date" name="contractDate" required class="form-control">
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Total Amount:</label>
                            <input type="number" step="0.01" name="totalAmount" id="totalAmount" required class="form-control" readonly>
                        </div>

                        <div class="form-group">
                            <label>Description:</label>
                            <textarea name="description" rows="3" class="form-control" placeholder="Notes..."></textarea>
                        </div>
                    </fieldset>

                    <fieldset style="border: 1px solid #ddd; padding: 15px; border-radius: 5px;">
                        <legend style="width: auto; padding: 0 10px; margin-bottom: 10px; border-bottom: none;">Contract Items</legend>

                        <div id="itemContainer">
                            <div class="item-row" style="margin-bottom: 10px; padding: 15px; border: 1px solid #eee; border-radius: 5px; background: #fdfdfd;">

                                <div class="row">
                                    <div class="col-xs-12">
                                        <button type="button" class="btn btn-danger btn-sm remove-item pull-right">
                                            <i class="fa fa-trash"></i> Remove
                                        </button>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Product:</label>
                                            <select name="productId" required class="form-control product-select">
                                                <option value="">-- Select a Product --</option>
                                                <c:forEach var="prod" items="${products}">
                                                    <option value="${prod.id}" data-price="${prod.sellingPrice}">${prod.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Price:</label>
                                            <input type="number" step="0.01" name="unitPrice" required class="form-control price" readonly>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Qty:</label>
                                            <input type="number" name="quantity" required class="form-control qty" value="1" min="1">
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Warranty (months):</label>
                                            <input type="number" name="warrantyMonths" value="12" class="form-control" min="0">
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Maintenance (months):</label>
                                            <input type="number" name="maintenanceMonths" value="24" class="form-control" min="0">
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Frequency (months):</label>
                                            <input type="number" name="maintenanceFrequencyMonths" value="6" class="form-control" min="1">
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-12">
                                        <div class="serial-container" style="margin-top: 10px;"></div>
                                    </div>
                                </div>

                            </div>
                        </div>

                        <button type="button" id="addItemBtn" class="btn btn-success mt-2">
                            <i class="fa fa-plus"></i> Add Another Item
                        </button>
                    </fieldset>

                    <div style="margin-top: 20px;">
                        <button type="submit" class="btn btn-primary">
                            <i class="fa fa-check"></i> Create Contract
                        </button>
                        <a href="${pageContext.request.contextPath}/cskh/contract" class="btn btn-default">
                            <i class="fa fa-times"></i> Cancel
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </section>
</div>

<script>
    document.getElementById("addItemBtn").addEventListener("click", function () {
        const container = document.getElementById("itemContainer");
        const originalItem = container.firstElementChild.cloneNode(true);

        originalItem.querySelector(".serial-container").innerHTML = "";

        $(originalItem).find('.select2-container').remove();
        const productSelect = originalItem.querySelector(".product-select");
        productSelect.selectedIndex = 0;

        originalItem.querySelector(".qty").value = "1";
        originalItem.querySelector(".price").value = "";
        originalItem.querySelector(".qty").dataset.initialized = false;

        container.appendChild(originalItem);

        $(productSelect).select2({
            placeholder: "-- Select a Product --",
            allowClear: true,
            width: '100%'
        });

        attachAllListeners();
        const newQtyInput = originalItem.querySelector(".qty");
        newQtyInput.dispatchEvent(new Event('input'));
        newQtyInput.dataset.initialized = true;
    });

    function attachRemoveHandlers() {
        document.querySelectorAll(".remove-item").forEach(btn => {
            const newBtn = btn.cloneNode(true);
            btn.parentNode.replaceChild(newBtn, btn);

            newBtn.onclick = function () {
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
            $(select).on('change', function () {
                const selectedOption = this.options[this.selectedIndex];
                const price = selectedOption.getAttribute('data-price') || 0;

                const row = this.closest(".item-row");
                const priceInput = row.querySelector(".price");

                priceInput.value = parseFloat(price).toFixed(2);
                updateTotal();
            });
        });
    }

    function attachSerialGenerator() {
        document.querySelectorAll(".qty").forEach(qtyInput => {

            const triggerSerialUpdate = function () {
                let qty = parseInt(this.value) || 0;
                if (qty < 1)
                    qty = 0;

                const row = this.closest(".item-row");
                const serialContainer = row.querySelector(".serial-container");

                serialContainer.innerHTML = "";

                if (qty > 0) {
                    const label = document.createElement('label');
                    label.innerText = "Serial Numbers (Required):";
                    label.style = "display: block; margin-top: 5px; font-weight: 500;";
                    serialContainer.appendChild(label);
                }

                for (let i = 0; i < qty; i++) {
                    const input = document.createElement("input");
                    input.type = "text";
                    input.name = "serialNumber";
                    input.className = "form-control serial-input";
                    input.placeholder = "Serial for Device #" + (i + 1);
                    input.style = "margin-top: 5px; max-width: 350px;";
                    input.required = true;
                    serialContainer.appendChild(input);
                }
                updateTotal();
            };

            qtyInput.oninput = null;
            qtyInput.onchange = null;

            qtyInput.oninput = triggerSerialUpdate;
            qtyInput.onchange = triggerSerialUpdate;
        });
    }

    function attachAllListeners() {
        attachRemoveHandlers();
        attachAutoSum();
        attachProductPriceChange();
        attachSerialGenerator();
    }

    $(document).ready(function () {
        $('#customerSelect').select2({
            placeholder: "-- Select a Customer --",
            allowClear: true,
            width: '100%'
        });

        $('.product-select').select2({
            placeholder: "-- Select a Product --",
            allowClear: true,
            width: '100%'
        });

        attachAllListeners();

        document.querySelectorAll(".qty").forEach(qtyInput => {
            if (!qtyInput.dataset.initialized) {
                qtyInput.dispatchEvent(new Event('input'));
                qtyInput.dataset.initialized = true;
            }
        });

        updateTotal();

        const dateInput = document.querySelector('input[name="contractDate"]');
        const today = new Date().toISOString().split('T')[0];
        dateInput.value = today;
        dateInput.setAttribute('max', today);

        $('form').on('submit', function (e) {
            let isValid = true;
            let errorMsg = "";

            const selectedDate = new Date(dateInput.value);
            const now = new Date(today);

            if (selectedDate > now) {
                isValid = false;
                errorMsg += "- Contract date cannot be in the future.\n";
            }

            document.querySelectorAll('.qty').forEach((qtyInput, index) => {
                const qty = parseFloat(qtyInput.value);
                if (isNaN(qty) || qty < 1) {
                    isValid = false;
                    errorMsg += `- Item #${index + 1}: Quantity must be at least 1.\n`;
                }
            });

            document.querySelectorAll('.serial-input').forEach((serialInput, index) => {
                if (!serialInput.value.trim()) {
                    isValid = false;
                    errorMsg += `- Serial number is required (${serialInput.placeholder}).\n`;
                }
            });

            if (!isValid) {
                alert("Please fix the following errors:\n\n" + errorMsg);
                e.preventDefault();
            }
        });
    });
</script>


<%@ include file="/cskh/layout/footer2.jsp" %>