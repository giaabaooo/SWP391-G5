<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/cskh/layout/header.jsp" %>
<%@ include file="/cskh/layout/sidebar.jsp" %>

<div class="content-wrapper">
    <section class="content-header">
        <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">Update Contract</h1>
    </section>

    <section class="content p-4">
        <div class="content-card">
            <div class="card-body">

                <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">
                        ${error}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/cskh/updateContract" method="post">
                    <input type="hidden" name="contractId" value="${contract.id}">
                    
                    <fieldset style="border: 1px solid #ddd; padding: 15px; margin-bottom: 20px; border-radius: 5px;">
                        <legend style="width: auto; padding: 0 10px; margin-bottom: 10px; border-bottom: none;">Contract Information</legend>

                        <div class="form-group">
                            <label>Customer:</label>
                            <select name="customerId" required class="form-control" id="customerSelect">
                                <option value="">-- Select a Customer --</option>
                                <c:forEach var="cus" items="${customers}">
                                    <option value="${cus.id}" ${cus.id == contract.customerId ? 'selected' : ''}>
                                        ${cus.fullName} - (${cus.email})
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>Contract Code:</label>
                                    <input type="text" name="contractCode" required class="form-control" 
                                           value="${contract.contractCode}">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>Contract Date:</label>
                                    <fmt:formatDate value="${contract.contractDate}" pattern="yyyy-MM-dd" var="formattedDate" />
                                    <input type="date" name="contractDate" required class="form-control" 
                                           value="${formattedDate}">
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Total Amount:</label>
                            <input type="number" step="0.01" name="totalAmount" id="totalAmount" required class="form-control" readonly>
                        </div>

                        <div class="form-group">
                            <label>Description:</label>
                            <textarea name="description" rows="3" class="form-control" 
                                      placeholder="Notes...">${contract.description}</textarea>
                        </div>
                    </fieldset>
                    
                    <fieldset style="border: 1px solid #ddd; padding: 15px; border-radius: 5px;">
                        <legend style="width: auto; padding: 0 10px; margin-bottom: 10px; border-bottom: none;">Contract Items</legend>

                        <div id="itemContainer">
                            <c:forEach var="item" items="${items}">
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
                                                        <option value="${prod.id}" data-price="${prod.sellingPrice}" 
                                                                ${prod.id == item.productId ? 'selected' : ''}>
                                                            ${prod.name}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label>Price:</label>
                                                <input type="number" step="0.01" name="unitPrice" required class="form-control price" 
                                                       value="${item.unitPrice}" readonly>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label>Qty:</label>
                                                <input type="number" name="quantity" required class="form-control qty" 
                                                       value="${item.quantity}" min="1">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label>Warranty (months):</label>
                                                <input type="number" name="warrantyMonths" value="${item.warrantyMonths}" class="form-control" min="0">
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label>Maintenance (months):</label>
                                                <input type="number" name="maintenanceMonths" value="${item.maintenanceMonths}" class="form-control" min="0">
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label>Frequency (months):</label>
                                                <input type="number" name="maintenanceFrequencyMonths" value="${item.maintenanceFrequencyMonths}" class="form-control" min="1">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-12">
                                            <div class="serial-container" style="margin-top: 10px;">
                                                <c:if test="${not empty serialsMap[item.id]}">
                                                    <label style="display: block; margin-top: 5px; font-weight: 500;">Serial Numbers (Required):</label>
                                                    <c:forEach var="serial" items="${serialsMap[item.id]}">
                                                        <input type="text" name="serialNumber" class="form-control serial-input"
                                                               style="margin-top: 5px; max-width: 350px;"
                                                               value="${serial}" required>
                                                    </c:forEach>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                    
                                </div>
                            </c:forEach>
                        </div>

                        <button type="button" id="addItemBtn" class="btn btn-success mt-2">
                            <i class="fa fa-plus"></i> Add Another Item
                        </button>
                    </fieldset>

                    <div style="margin-top: 20px;">
                        <button type="submit" class="btn btn-primary">
                            <i class="fa fa-save"></i> Save Changes
                        </button>
                        <a href="${pageContext.request.contextPath}/cskh/contract_detail?id=${contract.id}" class="btn btn-default">
                            <i class="fa fa-times"></i> Cancel
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </section>
</div>

<script>
    let itemTemplateHtml = '';
    
    function createItemTemplate() {
        const container = document.getElementById("itemContainer");
        if (container.children.length > 0) {
            const templateNode = container.firstElementChild.cloneNode(true);

            templateNode.querySelector(".serial-container").innerHTML = "";
            $(templateNode).find('.select2-container').remove();
            
            const productSelect = templateNode.querySelector(".product-select");
            productSelect.selectedIndex = 0;
            templateNode.querySelector(".qty").value = "1";
            templateNode.querySelector(".price").value = "";
            templateNode.querySelector('input[name="warrantyMonths"]').value = "12";
            templateNode.querySelector('input[name="maintenanceMonths"]').value = "24";
            templateNode.querySelector('input[name="maintenanceFrequencyMonths"]').value = "6";
            templateNode.querySelector(".qty").dataset.initialized = false;

            templateNode.querySelectorAll('.serial-input').forEach(input => input.remove());
            
            itemTemplateHtml = templateNode.innerHTML;
        } else {
            console.error("No items found to create a template.");
        }
    }

    document.getElementById("addItemBtn").addEventListener("click", function () {
        if (!itemTemplateHtml) {
            alert("Error: Cannot create new item template. Please refresh.");
            return;
        }
        
        const container = document.getElementById("itemContainer");
        const newItemRow = document.createElement('div');
        newItemRow.className = 'item-row';
        newItemRow.style = "margin-bottom: 10px; padding: 15px; border: 1px solid #eee; border-radius: 5px; background: #fdfdfd;";
        newItemRow.innerHTML = itemTemplateHtml;
        
        container.appendChild(newItemRow);

        const productSelect = newItemRow.querySelector(".product-select");
        $(productSelect).select2({
            placeholder: "-- Select a Product --",
            allowClear: true,
            width: '100%'
        });

        attachAllListeners();
        
        const newQtyInput = newItemRow.querySelector(".qty");
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
            const handler = function () {
                if (this.value < 1) {
                    this.value = 1;
                }
                updateTotal();
            };
            qtyInput.removeEventListener('input', handler);
            qtyInput.removeEventListener('change', handler);
            qtyInput.addEventListener('input', handler);
            qtyInput.addEventListener('change', handler);
        });
    }

    function attachProductPriceChange() {
        document.querySelectorAll(".product-select").forEach(select => {
            $(select).off('change');
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
                if (qty < 1) qty = 0;
                
                const row = this.closest(".item-row");
                const serialContainer = row.querySelector(".serial-container");
                
                const existingSerials = Array.from(serialContainer.querySelectorAll('.serial-input')).map(input => input.value);

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
                    if (existingSerials[i]) {
                        input.value = existingSerials[i];
                    }
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
        createItemTemplate();
    
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
                const row = qtyInput.closest(".item-row");
                const serialContainer = row.querySelector(".serial-container");
                
                if (serialContainer.children.length === 0) {
                    qtyInput.dispatchEvent(new Event('input'));
                }
                
                qtyInput.dataset.initialized = true;
            }
        });
        
        updateTotal();

        const dateInput = document.querySelector('input[name="contractDate"]');
        const today = new Date().toISOString().split('T')[0];
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

<%@ include file="/cskh/layout/footer.jsp" %>