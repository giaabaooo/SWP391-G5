<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
                                           value="${contract.contractCode}" readonly style="background-color: #eee;">
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
                                <c:set var="currentItemSerial" value="${currentSerialsMap[item.id][0]}" />
                                
                                <div class="item-row" style="margin-bottom: 10px; padding: 15px; border: 1px solid #eee; border-radius: 5px; background: #fdfdfd;"
                                     data-current-serial="${currentItemSerial}">
                                    
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
                                                        <fmt:formatNumber value="${prod.sellingPrice}" pattern="0.00" var="formattedPrice" groupingUsed="false" />
                                                        
                                                        <option value="${prod.id}" data-price="${formattedPrice}" 
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
                                                       value="1" min="1" readonly style="background-color: #eee;">
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

<%@ include file="/cskh/layout/footer.jsp" %>

<script>
    const rawJsonString = '${not empty availableSerialsJson ? availableSerialsJson : "{}"}';
    const availableSerialsByProduct = JSON.parse(rawJsonString);
    
    let itemTemplateHtml = '';

    function createItemTemplate() {
        const container = document.getElementById("itemContainer");
        if (container.children.length > 0) {
            const templateNode = container.firstElementChild.cloneNode(true);
            templateNode.querySelector(".serial-container").innerHTML = "";
            $(templateNode).find('.select2-container').remove();
            
            const productSelect = templateNode.querySelector(".product-select");
            productSelect.selectedIndex = 0;
            templateNode.querySelector(".price").value = "";
            templateNode.querySelector('input[name="warrantyMonths"]').value = "12";
            templateNode.querySelector('input[name="maintenanceMonths"]').value = "24";
            templateNode.querySelector('input[name="maintenanceFrequencyMonths"]').value = "6";
            
            templateNode.removeAttribute('data-current-serial');
            
            itemTemplateHtml = templateNode.innerHTML;
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

        $(newItemRow).find('.product-select').select2({
            placeholder: "-- Select a Product --",
            allowClear: true,
            width: '100%'
        });
        
        attachRowListeners(newItemRow);
        buildSerialDropdown(newItemRow, null); 
    });

    function updateTotal() {
        let total = 0;
        document.querySelectorAll(".item-row").forEach(row => {
            const qty = 1; 
            const price = parseFloat(row.querySelector(".price").value) || 0;
            total += qty * price;
        });
        document.getElementById("totalAmount").value = total.toFixed(2);
    }
    
    function validateAllSerials() {
        const allSerialSelects = document.querySelectorAll('.serial-select');
        const selectedValues = new Map(); 
        let hasDuplicates = false;

        document.querySelectorAll('.serial-error').forEach(el => el.remove());

        allSerialSelects.forEach(select => {
            const value = select.value;
            if (value) { 
                selectedValues.set(value, (selectedValues.get(value) || 0) + 1);
            }
        });

        allSerialSelects.forEach(select => {
            const value = select.value;
            if (value && selectedValues.get(value) > 1) {
                hasDuplicates = true;
                const errorEl = document.createElement('span');
                errorEl.className = 'serial-error'; 
                errorEl.style = "color: red; font-size: 0.85em; display: block;";
                errorEl.textContent = 'This serial is already selected in another row.';
                select.parentNode.insertBefore(errorEl, select.nextSibling);
            }
        });
        return !hasDuplicates; 
    }

    function buildSerialDropdown(row, currentSerialToSelect) {
        const qty = 1; 
        const serialContainer = row.querySelector(".serial-container");
        const productId = row.querySelector(".product-select").value;

        serialContainer.innerHTML = ""; 

        if (!productId) {
            serialContainer.innerHTML = "<p class='text-info'>Please select a product first.</p>";
            return;
        }

        const availableSerials = availableSerialsByProduct[productId];

        if (!availableSerials || availableSerials.length === 0) {
            if(currentSerialToSelect) {
                serialContainer.innerHTML = "<p class='text-danger'>Serial mismatch. Please re-select a serial for this (new) product.</p>";
            } else {
                serialContainer.innerHTML = "<p class='text-danger'>No serials in stock for this product.</p>";
            }
            return;
        }

        for (let i = 0; i < qty; i++) {
            const selectElement = document.createElement('select');
            selectElement.name = 'serialNumber';
            selectElement.className = 'form-control serial-select';
            selectElement.style = "margin-top: 5px; max-width: 350px;";
            selectElement.required = true;

            const defaultOption = document.createElement('option');
            defaultOption.value = '';
            defaultOption.text = `-- Select Serial --`;
            selectElement.appendChild(defaultOption);

            availableSerials.forEach(function(serial) {
                const option = document.createElement('option');
                option.value = serial.serialNumber;
                option.text = serial.serialNumber;
                
                if (serial.serialNumber === currentSerialToSelect) {
                    option.selected = true;
                }
                
                selectElement.appendChild(option);
            });
            
            selectElement.addEventListener('change', validateAllSerials);
            serialContainer.appendChild(selectElement);
        }
        updateTotal(); 
    }

    function attachRowListeners(rowElement) {
        $(rowElement).find('.product-select').select2({
            placeholder: "-- Select a Product --",
            allowClear: true,
            width: '100%'
        }).on('change', function () {
            const selectedOption = this.options[this.selectedIndex];
            const price = selectedOption.getAttribute('data-price');
            const row = this.closest(".item-row");
            row.querySelector(".price").value = parseFloat(price).toFixed(2);
            updateTotal();
            
            buildSerialDropdown(row, null); 
            validateAllSerials();
        });

        $(rowElement).find(".remove-item").on('click', function () {
            const rows = document.querySelectorAll(".item-row");
            if (rows.length > 1) {
                this.closest(".item-row").remove();
                updateTotal();
                validateAllSerials();
            } else {
                alert("At least one item is required.");
            }
        });
        
        $(rowElement).find(".price").on('input', updateTotal);
    }


    $(document).ready(function () {
        createItemTemplate(); 
        
        $('#customerSelect').select2({
            placeholder: "-- Select a Customer --",
            allowClear: true,
            width: '100%'
        });

        document.querySelectorAll(".item-row").forEach(row => {
            attachRowListeners(row);
            
            const currentSerial = row.getAttribute('data-current-serial');
            buildSerialDropdown(row, currentSerial); 
        });

        const dateInput = document.querySelector('input[name="contractDate"]');
        const today = new Date().toISOString().split('T')[0];
        dateInput.setAttribute('max', today);

        updateTotal();

        $('form').on('submit', function (e) {
            let isValid = true;
            let errorMsg = "";

            const selectedDate = new Date(dateInput.value);
            const now = new Date(today);
            if (selectedDate > now) {
                isValid = false;
                errorMsg += "- Contract date cannot be in the future.\n";
            }

            let totalQty = 0;
            document.querySelectorAll('.qty').forEach((qtyInput, index) => {
                totalQty++;
            });

            let totalSerialSelects = 0;
            document.querySelectorAll('.serial-select').forEach((serialSelect, index) => {
                totalSerialSelects++;
                if (!serialSelect.value.trim()) {
                    isValid = false;
                    errorMsg += `- Serial number is not selected (${serialSelect.options[0].text}).\n`;
                }
            });

            if (!validateAllSerials()) {
                isValid = false;
                errorMsg += "- Duplicate serial numbers are selected. Please check the red error messages.\n";
            }

            if (totalSerialSelects !== totalQty) {
                isValid = false;
                errorMsg += `- Mismatch: Total products are ${totalQty} but ${totalSerialSelects} serials are selected.\n`;
            }

            if (!isValid) {
                alert("Please fix the following errors:\n\n" + errorMsg);
                e.preventDefault();
            }
        });
    });
</script>