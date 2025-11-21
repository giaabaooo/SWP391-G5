<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="data.Product" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Warehouse | Stock In</title>
    <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
    <!-- bootstrap 3.0.2 + icons + theme styles to match warehouse pages -->
    <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/ionicons.min.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/morris/morris.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/jvectormap/jquery-jvectormap-1.2.2.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/daterangepicker/daterangepicker-bs3.css" rel="stylesheet" type="text/css" />
    <link href='http://fonts.googleapis.com/css?family=Lato' rel='stylesheet' type='text/css'>
    <link href="${pageContext.request.contextPath}/css/admin/style.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/warehouse/addProduct.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/warehouse/responsive.css" rel="stylesheet" type="text/css" />
    <style>
        /* Use the same pattern as addProduct.css: hidden by default, show via .show */
        .validation-error {
            display: none;
            color: #dc3545;
            font-style: italic;
            font-size: 12px;
            margin-top: 4px;
        }
        .validation-error.show { display: block; }
        .form-control.error {
            border-color: #dc3545;
            box-shadow: inset 0 1px 1px rgba(0,0,0,0.075), 0 0 0 2px rgba(220,53,69,0.1);
        }

        /* Compact table styling */
        .table-responsive {
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }

        #importItemsTable {
            font-size: 12px;
        }

        #importItemsTable thead th {
            font-size: 11px;
            padding: 6px 4px;
            white-space: nowrap;
            vertical-align: middle;
        }

        #importItemsTable tbody td {
            padding: 6px 4px;
            vertical-align: middle;
        }

        #importItemsTable .form-control,
        #importItemsTable .form-control select {
            font-size: 12px;
            padding: 4px 6px;
            height: auto;
        }

        #importItemsTable .category-label {
            font-size: 11px;
            display: block;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 120px;
        }

        #importItemsTable .serial-inputs-container {
            max-width: 280px;
        }

        #importItemsTable .serial-inputs-container small {
            font-size: 10px;
        }

        #importItemsTable .btn {
            padding: 4px 8px;
            font-size: 12px;
        }

        #importItemsTable .row-index {
            font-size: 11px;
        }
    </style>
</head>
<body class="skin-black">

<!-- Mobile Menu Toggle -->
<button class="mobile-menu-toggle" onclick="toggleMobileMenu()">
    <i class="fa fa-bars"></i>
    </button>

<!-- HEADER -->
<header class="header">
    <a href="${pageContext.request.contextPath}/warestaff/dashboard" class="logo" style="color: #ffffff; font-weight: 600; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">Warehouse Staff</a>
    <nav class="navbar navbar-static-top" role="navigation">
        <div class="navbar-right">
            <ul class="nav navbar-nav">
                <li class="dropdown user user-menu">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        <i class="fa fa-user"></i>
                        <span>${sessionScope.user.fullName} <i class="caret"></i></span>
                    </a>
                    <ul class="dropdown-menu dropdown-custom dropdown-menu-right">
                        <li class="dropdown-header text-center">Account</li>
                        <li>
                            <a href="#"><i class="fa fa-user fa-fw pull-right"></i> Profile</a>
                            <a data-toggle="modal" href="#modal-user-settings"><i class="fa fa-cog fa-fw pull-right"></i> Settings</a>
                        </li>
                        <li class="divider"></li>
                        <li><a href="${pageContext.request.contextPath}/user/logout"><i class="fa fa-ban fa-fw pull-right"></i> Logout</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </nav>
</header>

<div class="wrapper row-offcanvas row-offcanvas-left">

    <!-- SIDEBAR -->
    <aside class="left-side sidebar-offcanvas">
        <section class="sidebar">
            <div class="user-panel">
                <div class="pull-left image">
                    <img src="${pageContext.request.contextPath}/img/warehouse-user.png" class="img-circle" alt="User Image" onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iMjAiIGN5PSIyMCIgcj0iMjAiIGZpbGw9IiM2NzdFRUEiLz4KPHN2ZyB4PSI4IiB5PSI4IiB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTEyIDEyQzE0LjIwOTEgMTIgMTYgMTAuMjA5MSAxNiA4QzE2IDUuNzkwODYgMTQuMjA5MSA0IDEyIDRDOS43OTA4NiA0IDggNS43OTA4NiA4IDhDOCAxMC4yMDkxIDkuNzkwODYgMTIgMTIgMTJaIiBmaWxsPSJ3aGl0ZSIvPgo8cGF0aCBkPSJNMTIgMTRDOC42ODYyOSAxNCA2IDE2LjY4NjMgNiAyMEgxOEMxOCAxNi42ODYzIDE1LjMxMzcgMTQgMTIgMTRaIiBmaWxsPSJ3aGl0ZSIvPgo8L3N2Zz4KPC9zdmc+'" />
                </div>
                <div class="pull-left info">
                    <p>${sessionScope.user.fullName}</p>
                    <a href="#"><i class="fa fa-circle text-success"></i> Online</a>
                </div>
            </div>

            <ul class="sidebar-menu">
                <li><a href="${pageContext.request.contextPath}/warestaff/dashboard"><i class="fa fa-dashboard"></i> Dashboard</a></li>

                <!-- Products -->
                <li class="treeview">
                    <a href="#inventoryMenu" data-toggle="collapse" aria-expanded="false">
                        <i class="fa fa-cubes"></i> <span>Products</span>
                    </a>
                    <ul class="collapse" id="inventoryMenu">
                        <li><a href="../warestaff/viewListProduct"><i class="fa fa-list"></i> View List Product</a></li>
                        <li><a href="../warestaff/addNewProduct"><i class="fa fa-plus"></i> Add Product</a></li>
                    </ul>
                </li>

                <!-- Categories -->
                <li class="treeview">
                    <a href="#categoryMenu" data-toggle="collapse" aria-expanded="false">
                        <i class="fa fa-tags"></i> <span>Categories</span>
                    </a>
                    <ul class="collapse" id="categoryMenu">
                        <li><a href="../warestaff/categoryList"><i class="fa fa-eye"></i> View Categories</a></li>
                        <li><a href="../warestaff/addCategory"><i class="fa fa-plus"></i> Add Category</a></li>
                    </ul>
                </li>

                <!-- Brands -->
                <li class="treeview">
                    <a href="#brandMenu" data-toggle="collapse" aria-expanded="false">
                        <i class="fa fa-bookmark"></i> <span>Brands</span>
                    </a>
                    <ul class="collapse" id="brandMenu">
                        <li><a href="../warestaff/brandList"><i class="fa fa-eye"></i> View Brands</a></li>
                        <li><a href="../warestaff/addBrand"><i class="fa fa-plus"></i> Add Brand</a></li>
                    </ul>
                </li>

                <!-- Transactions -->
                <li class="treeview">
                    <a href="#transactionMenu" data-toggle="collapse" aria-expanded="false">
                        <i class="fa fa-exchange"></i> <span>Transactions</span>
                    </a>
                    <ul class="collapse" id="transactionMenu">
                        <li><a href="../warestaff/transactions"><i class="fa fa-list"></i> View Transactions</a></li>
                        <li><a href="../warestaff/addImportTransaction"><i class="fa fa-plus"></i> Add Stock In</a></li>
                        <li><a href="../warestaff/addExportTransaction"><i class="fa fa-minus"></i> Add Stock Out</a></li>
                    </ul>
                </li>

                
            </ul>
        </section>
    </aside>

    <!-- MAIN CONTENT -->
    <aside class="right-side">
        <section class="content">
            <!-- Page Header -->
            <div class="row">
                <div class="col-md-12">
                    <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">Stock In</h1>
                    <p style="color: #718096; margin-bottom: 2rem;">Record product imports and update inventory</p>

                    <!-- Thông báo lỗi server nếu có -->
                    <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger" style="background-color: #fed7d7; border: 1px solid #fc8181; color: #742a2a; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;">
                        <i class="fa fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
                    </div>
                    <% } %>
                </div>
            </div>

            <!-- Content Card -->
            <div class="row">
                <div class="col-md-12">
                    <div class="content-card">
                        <div class="card-header">
                            <h3><i class="fa fa-upload"></i> Stock In Form</h3>
                        </div>

                        <!-- Mode Selection Tabs -->
                        <div style="padding: 1.25rem 1.25rem 0 1.25rem;">
                            <ul class="nav nav-tabs" role="tablist">
                                <li class="active">
                                    <a href="#manualEntry" data-toggle="tab">
                                        <i class="fa fa-edit"></i> Manual Entry
                                    </a>
                                </li>
                                <li>
                                    <a href="#excelUpload" data-toggle="tab">
                                        <i class="fa fa-file-excel-o"></i> Upload Excel with Serials
                                    </a>
                                </li>
                            </ul>
                        </div>

                        <div class="tab-content" style="padding:1.25rem;">
                            <!-- Manual Entry Tab -->
                            <div class="tab-pane active" id="manualEntry">
                            <%
                                List<Product> products = (List<Product>) request.getAttribute("products");
                                List<data.Category> categories = (List<data.Category>) request.getAttribute("categories");
                                java.util.Map<Integer, String> categoryMap = new java.util.HashMap<>();
                                if (categories != null) {
                                    for (data.Category c : categories) {
                                        categoryMap.put(c.getId(), c.getName());
                                    }
                                }
                                java.util.Map<Integer, String> productCategoryMap = new java.util.HashMap<>();
                                if (products != null) {
                                    for (Product p : products) {
                                        String catName = categoryMap.get(p.getCategoryId());
                                        productCategoryMap.put(p.getId(), catName != null ? catName : "—");
                                    }
                                }
                                java.util.List<String> unitOptions = (java.util.List<String>) request.getAttribute("unitOptions");
                                java.util.Map<String, String> unitTranslations = new java.util.LinkedHashMap<>();
                                unitTranslations.put("Bộ", "Set");
                                unitTranslations.put("Cái", "Piece");
                                unitTranslations.put("Chiếc", "Item");
                                unitTranslations.put("Mét", "Meter");
                                unitTranslations.put("Kilogram", "Kilogram");
                                unitTranslations.put("Kg", "Kilogram");
                                unitTranslations.put("Lít", "Liter");
                                unitTranslations.put("Litre", "Liter");
                                unitTranslations.put("Thùng", "Crate");
                                unitTranslations.put("Hộp", "Box");
                                unitTranslations.put("Set", "Set");
                                unitTranslations.put("Piece", "Piece");
                                unitTranslations.put("Item", "Item");
                                unitTranslations.put("Unit", "Unit");
                                unitTranslations.put("Meter", "Meter");
                                unitTranslations.put("Liter", "Liter");
                                unitTranslations.put("Crate", "Crate");
                                unitTranslations.put("Box", "Box");

                                java.util.LinkedHashSet<String> englishUnits = new java.util.LinkedHashSet<>();
                                if (unitOptions != null) {
                                    for (String unit : unitOptions) {
                                        if (unit == null) { continue; }
                                        String trimmed = unit.trim();
                                        if (trimmed.isEmpty()) { continue; }
                                        String translated = unitTranslations.get(trimmed);
                                        englishUnits.add(translated != null ? translated : trimmed);
                                    }
                                }
                                if (englishUnits.isEmpty()) {
                                    englishUnits.add("Set");
                                    englishUnits.add("Piece");
                                    englishUnits.add("Item");
                                    englishUnits.add("Unit");
                                    englishUnits.add("Meter");
                                    englishUnits.add("Kilogram");
                                    englishUnits.add("Liter");
                                    englishUnits.add("Crate");
                                    englishUnits.add("Box");
                                }
                                unitOptions = new java.util.ArrayList<>(englishUnits);
                                String[] submittedProductIds = (String[]) request.getAttribute("submittedProductIds");
                                String[] submittedQuantities = (String[]) request.getAttribute("submittedQuantities");
                                String[] submittedUnits = (String[]) request.getAttribute("submittedUnits");
                                String[] submittedItemNotes = (String[]) request.getAttribute("submittedItemNotes");
                                String prefillProductId = (String) request.getAttribute("prefillProductId");
                                if ((submittedProductIds == null || submittedProductIds.length == 0) && prefillProductId != null) {
                                    submittedProductIds = new String[]{prefillProductId};
                                    submittedQuantities = new String[]{""};
                                    submittedUnits = new String[]{""};
                                    submittedItemNotes = new String[]{""};
                                }
                                int rowCount = (submittedProductIds != null && submittedProductIds.length > 0) ? submittedProductIds.length : 1;
                                String submittedDate = (String) request.getAttribute("submittedDate");
                                if (submittedDate == null || submittedDate.isEmpty()) {
                                    submittedDate = request.getParameter("transactionDate");
                                }
                                String transactionDateValue = (submittedDate != null && !submittedDate.isEmpty())
                                        ? submittedDate
                                        : new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm").format(new java.util.Date());
                                String supplierValue = (String) request.getAttribute("submittedSupplier");
                                if (supplierValue == null) {
                                    supplierValue = request.getParameter("supplier");
                                }
                                if (supplierValue == null) {
                                    supplierValue = "";
                                }
                                String noteValue = (String) request.getAttribute("submittedNote");
                                if (noteValue == null) {
                                    noteValue = request.getParameter("note");
                                }
                                if (noteValue == null) {
                                    noteValue = "";
                                }
                            %>
                            <!-- Form nhập thủ công từng dòng nhập kho -->
                            <form method="post" action="<%= request.getContextPath() %>/warestaff/addImportTransaction" id="stockInForm" novalidate>
                                <div class="form-group">
                                    <label class="control-label">Transaction time<span style="color:red">*</span></label>
                                    <input type="datetime-local" name="transactionDate" class="form-control" required value="<%= transactionDateValue %>" />
                                </div>
                                <div class="form-group">
                                    <label class="control-label">Supplier (optional)</label>
                                    <input type="text" name="supplier" id="supplier" class="form-control" placeholder="Supplier name" value="<%= supplierValue %>" />
                                </div>
                                <div class="form-group">
                                    <label class="control-label">General note (optional)</label>
                                    <textarea name="note" class="form-control" rows="3" placeholder="Additional notes"><%= noteValue %></textarea>
                                </div>

                                <div class="form-group">
                                    <label class="control-label">Import items<span style="color:red">*</span></label>
                                    <!-- Bảng thêm sản phẩm nhập và serial tương ứng -->
                                    <div class="table-responsive">
                                        <table class="table table-bordered" id="importItemsTable">
                                            <thead>
                                                <tr>
                                                    <th style="width:40px;">#</th>
                                                    <th style="min-width:180px;">Product<span style="color:red">*</span></th>
                                                    <th style="min-width:100px;">Category</th>
                                                    <th style="min-width:90px;">Unit</th>
                                                    <th style="min-width:80px;">Quantity<span style="color:red">*</span></th>
                                                    <th style="min-width:280px;">Serial Numbers<span style="color:red">*</span></th>
                                                    <th style="min-width:150px;">Item note</th>
                                                    <th style="width:50px;" class="text-center">Action</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            <%
                                                for (int i = 0; i < rowCount; i++) {
                                                    String selectedProductId = (submittedProductIds != null && i < submittedProductIds.length && submittedProductIds[i] != null) ? submittedProductIds[i] : "";
                                                    String quantityValue = (submittedQuantities != null && i < submittedQuantities.length && submittedQuantities[i] != null) ? submittedQuantities[i] : "";
                                                    String unitValue = (submittedUnits != null && i < submittedUnits.length && submittedUnits[i] != null) ? submittedUnits[i] : "";
                                                    String itemNoteValue = (submittedItemNotes != null && i < submittedItemNotes.length && submittedItemNotes[i] != null) ? submittedItemNotes[i] : "";
                                                    String categoryText = "—";
                                                    if (selectedProductId != null && !selectedProductId.isEmpty()) {
                                                        try {
                                                            int pid = Integer.parseInt(selectedProductId);
                                                            String catName = productCategoryMap.get(pid);
                                                            if (catName != null && !catName.trim().isEmpty()) {
                                                                categoryText = catName;
                                                            }
                                                        } catch (NumberFormatException ignored) {}
                                                    }
                                            %>
                                                <tr class="import-item-row">
                                                    <td class="row-index text-center"><%= i + 1 %></td>
                                                    <td>
                                                        <select name="productId" class="form-control product-select" required>
                                                            <option value="">-- Select --</option>
                                                            <% if (products != null) {
                                                                   for (Product p : products) {
                                                                       String catName = productCategoryMap.get(p.getId());
                                                                       String selectedAttr = (selectedProductId != null && selectedProductId.equals(String.valueOf(p.getId()))) ? "selected" : "";
                                                            %>
                                                            <option value="<%= p.getId() %>" data-category="<%= catName != null ? catName : "" %>" <%= selectedAttr %>><%= p.getName() %></option>
                                                            <%     }
                                                               } %>
                                                        </select>
                                                        <div class="validation-error product-error">Please select a product</div>
                                                    </td>
                                                    <td><span class="category-label"><%= categoryText %></span></td>
                                                    <td>
                                                        <select name="unit" class="form-control unit-select">
                                                            <option value="">-- Unit --</option>
                                                            <% for (String unit : unitOptions) { %>
                                                            <option value="<%= unit %>" <%= unit.equals(unitValue) ? "selected" : "" %>><%= unit %></option>
                                                            <% } %>
                                                        </select>
                                                    </td>
                                                    <td>
                                                        <input type="number" name="quantity" class="form-control quantity-input" min="1" required value="<%= quantityValue %>" />
                                                        <div class="validation-error quantity-error">Quantity must be a positive number</div>
                                                    </td>
                                                    <td>
                                                        <div class="serial-inputs-container"></div>
                                                        <small class="text-muted">Enter quantity first to generate serial number fields</small>
                                                    </td>
                                                    <td>
                                                        <input type="text" name="itemNote" class="form-control" placeholder="Optional note" value="<%= itemNoteValue %>" />
                                                    </td>
                                                    <td class="text-center">
                                                        <button type="button" class="btn btn-default remove-row-btn" title="Remove item"><i class="fa fa-trash"></i></button>
                                                    </td>
                                                </tr>
                                            <%
                                                }
                                            %>
                                            </tbody>
                                        </table>
                                    </div>
                                    <div class="validation-error" id="itemListError">Please add at least one product line.</div>
                                    <button type="button" class="btn btn-default" id="addRowBtn" style="margin-top:0.75rem;"><i class="fa fa-plus"></i> Add product line</button>
                                </div>

                                <div class="form-group" style="margin-top:1.5rem;">
                                    <!-- Nút submit lưu phiếu nhập thủ công -->
                                    <button type="submit" class="btn btn-primary" id="submitBtn"><i class="fa fa-upload"></i> Save</button>
                                    <a href="<%= request.getContextPath() %>/warestaff/viewListProduct" class="btn btn-default">Cancel</a>
                                </div>
                            </form>

                            <template id="importRowTemplate">
                                <tr class="import-item-row">
                                    <td class="row-index text-center">1</td>
                                    <td>
                                        <select name="productId" class="form-control product-select" required>
                                            <option value="">-- Select --</option>
                                            <% if (products != null) {
                                                   for (Product p : products) {
                                                       String catName = productCategoryMap.get(p.getId());
                                            %>
                                            <option value="<%= p.getId() %>" data-category="<%= catName != null ? catName : "" %>"><%= p.getName() %></option>
                                            <%     }
                                               } %>
                                        </select>
                                        <div class="validation-error product-error">Please select a product</div>
                                    </td>
                                    <td><span class="category-label">—</span></td>
                                    <td>
                                        <select name="unit" class="form-control unit-select">
                                            <option value="">-- Unit --</option>
                                            <% for (String unit : unitOptions) { %>
                                            <option value="<%= unit %>"><%= unit %></option>
                                            <% } %>
                                        </select>
                                    </td>
                                    <td>
                                        <input type="number" name="quantity" class="form-control quantity-input" min="1" required />
                                        <div class="validation-error quantity-error">Quantity must be a positive number</div>
                                    </td>
                                    <td>
                                        <div class="serial-inputs-container"></div>
                                        <small class="text-muted">Enter quantity first to generate serial number fields</small>
                                    </td>
                                    <td>
                                        <input type="text" name="itemNote" class="form-control" placeholder="Optional note" />
                                    </td>
                                    <td class="text-center">
                                        <button type="button" class="btn btn-default remove-row-btn" title="Remove item"><i class="fa fa-trash"></i></button>
                                    </td>
                                </tr>
                            </template>
                            </div>
                            <!-- End Manual Entry Tab -->

                            <!-- Excel Upload Tab -->
                            <div class="tab-pane" id="excelUpload">
                                <!-- Form tải Excel để nhập serial hàng loạt -->
                                <div class="alert alert-info" style="background-color: #e6f7ff; border: 1px solid #91d5ff; color: #0050b3; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem;">
                                    <i class="fa fa-info-circle"></i> <strong>Excel Format:</strong> Your Excel file must have 2 columns: <code>sku</code> and <code>serial_number</code>
                                </div>

                                <form method="post" action="<%= request.getContextPath() %>/warestaff/importWithSerials" enctype="multipart/form-data" id="excelImportForm">
                                    <div class="form-group">
                                        <label class="control-label">Excel File (.xlsx)<span style="color:red">*</span></label>
                                        <input type="file" name="excelFile" class="form-control" accept=".xlsx" required />
                                        <small class="help-block">Upload an Excel file with columns: sku, serial_number</small>
                                    </div>

                                    <div class="form-group">
                                        <label class="control-label">Transaction time<span style="color:red">*</span></label>
                                        <input type="datetime-local" name="transactionDate" class="form-control" required id="excelTransactionDate" />
                                    </div>

                                    <div class="form-group">
                                        <label class="control-label">Supplier (optional)</label>
                                        <input type="text" name="supplier" class="form-control" placeholder="Supplier name" />
                                    </div>

                                    <div class="form-group">
                                        <label class="control-label">General note (optional)</label>
                                        <textarea name="note" class="form-control" rows="3" placeholder="Additional notes"></textarea>
                                    </div>

                                    <div class="form-group" style="margin-top:1.5rem;">
                                        <!-- Nút gửi file Excel để ghi nhận serial -->
                                        <button type="submit" class="btn btn-primary"><i class="fa fa-upload"></i> Import with Serials</button>
                                        <a href="<%= request.getContextPath() %>/warestaff/viewListProduct" class="btn btn-default">Cancel</a>
                                    </div>
                                </form>
                            </div>
                            <!-- End Excel Upload Tab -->
                        </div>
                        </div>
                    </div>
                </div>
            </div>

        </section>
    </aside>
</div>

<!-- SCRIPTS -->
<script src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-ui-1.10.3.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/daterangepicker.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/chart.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/icheck.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/fullcalendar.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/app.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/dashboard.js" type="text/javascript"></script>
<script>
    function toggleMobileMenu(){
        var left = document.querySelector('.left-side');
        if(left){ left.classList.toggle('show'); }
    }
    (function(){
        var form = document.getElementById('stockInForm');
        if (!form) { return; }

        var tableBody = document.querySelector('#importItemsTable tbody');
        var addRowBtn = document.getElementById('addRowBtn');
        var itemListError = document.getElementById('itemListError');
        var template = document.getElementById('importRowTemplate');

        function updateCategory(select){
            if (!select) return;
            var row = select.closest('.import-item-row');
            if (!row) return;
            var categoryLabel = row.querySelector('.category-label');
            if (!categoryLabel) return;
            var option = select.options[select.selectedIndex];
            var category = option && option.getAttribute('data-category') ? option.getAttribute('data-category').trim() : '';
            categoryLabel.textContent = category !== '' ? category : '—';
        }

        function showRowError(row, type, message){
            if (!row) return;
            var errorEl = row.querySelector('.' + type + '-error');
            if (errorEl) {
                if (message) { errorEl.textContent = message; }
                errorEl.classList.add('show');
            }
            var field = type === 'product' ? row.querySelector('.product-select') : row.querySelector('.quantity-input');
            if (field) { field.classList.add('error'); }
        }

        function clearRowError(row, type){
            if (!row) return;
            var errorEl = row.querySelector('.' + type + '-error');
            if (errorEl) { errorEl.classList.remove('show'); }
            var field = type === 'product' ? row.querySelector('.product-select') : row.querySelector('.quantity-input');
            if (field) { field.classList.remove('error'); }
        }

        function generateSerialInputs(row, quantity){
            if (!row) return;
            var container = row.querySelector('.serial-inputs-container');
            if (!container) return;

            // Clear existing inputs
            container.innerHTML = '';

            if (quantity <= 0 || isNaN(quantity)) {
                return;
            }

            // Create input fields for each serial number
            for (var i = 0; i < quantity; i++) {
                var inputGroup = document.createElement('div');
                inputGroup.style.marginBottom = '5px';

                var label = document.createElement('span');
                label.textContent = 'Serial ' + (i + 1) + ': ';
                label.style.display = 'inline-block';
                label.style.width = '70px';
                label.style.fontSize = '12px';

                var input = document.createElement('input');
                input.type = 'text';
                input.name = 'serialNumber';
                input.className = 'form-control serial-input';
                input.placeholder = 'Enter serial number';
                input.required = true;
                input.style.display = 'inline-block';
                input.style.width = 'calc(100% - 75px)';
                input.style.fontSize = '13px';
                input.style.padding = '4px 8px';

                inputGroup.appendChild(label);
                inputGroup.appendChild(input);
                container.appendChild(inputGroup);
            }
        }

        function reindexRows(){
            var rows = tableBody.querySelectorAll('.import-item-row');
            rows.forEach(function(row, idx){
                var indexCell = row.querySelector('.row-index');
                if (indexCell) {
                    indexCell.textContent = idx + 1;
                }
                var removeBtn = row.querySelector('.remove-row-btn');
                if (removeBtn) {
                    var disable = rows.length === 1;
                    removeBtn.disabled = disable;
                    removeBtn.classList.toggle('disabled', disable);
                }
            });
        }

        function attachRowHandlers(row){
            if (!row) return;
            row.querySelectorAll('.form-control').forEach(function(ctrl){ ctrl.classList.remove('error'); });
            row.querySelectorAll('.validation-error').forEach(function(err){ err.classList.remove('show'); });

            var productSelect = row.querySelector('.product-select');
            if (productSelect) {
                productSelect.addEventListener('change', function(){
                    updateCategory(productSelect);
                    clearRowError(row, 'product');
                });
                updateCategory(productSelect);
            }

            var quantityInput = row.querySelector('.quantity-input');
            if (quantityInput) {
                quantityInput.addEventListener('input', function(){
                    var value = parseInt(quantityInput.value, 10);
                    if (!isNaN(value) && value > 0) {
                        clearRowError(row, 'quantity');
                        generateSerialInputs(row, value);
                    } else {
                        generateSerialInputs(row, 0);
                    }
                });
                // Generate serial inputs on page load if quantity exists
                var initialQty = parseInt(quantityInput.value, 10);
                if (!isNaN(initialQty) && initialQty > 0) {
                    generateSerialInputs(row, initialQty);
                }
            }

            var removeBtn = row.querySelector('.remove-row-btn');
            if (removeBtn) {
                removeBtn.addEventListener('click', function(){
                    var rows = tableBody.querySelectorAll('.import-item-row');
                    if (rows.length > 1) {
                        row.remove();
                        reindexRows();
                        if (itemListError) { itemListError.classList.remove('show'); }
                    }
                });
            }
        }

        function addRow(){
            if (!template) return;
            var clone = template.content.firstElementChild.cloneNode(true);
            tableBody.appendChild(clone);
            attachRowHandlers(clone);
            reindexRows();
            if (itemListError) { itemListError.classList.remove('show'); }
        }

        tableBody.querySelectorAll('.import-item-row').forEach(function(row){ attachRowHandlers(row); });
        reindexRows();

        if (addRowBtn) {
            addRowBtn.addEventListener('click', function(){ addRow(); });
        }

        form.addEventListener('submit', function(e){
            var valid = true;
            var rows = Array.prototype.slice.call(tableBody.querySelectorAll('.import-item-row'));

            if (rows.length === 0) {
                valid = false;
                if (itemListError) { itemListError.classList.add('show'); }
            } else if (itemListError) {
                itemListError.classList.remove('show');
            }

            var allSerials = [];

            rows.forEach(function(row){
                var productSelect = row.querySelector('.product-select');
                var quantityInput = row.querySelector('.quantity-input');
                var productValue = productSelect ? productSelect.value.trim() : '';
                var quantityValue = quantityInput ? parseInt(quantityInput.value, 10) : NaN;

                if (productValue === '') {
                    showRowError(row, 'product', 'Please select a product');
                    valid = false;
                } else {
                    clearRowError(row, 'product');
                }

                if (isNaN(quantityValue) || quantityValue <= 0) {
                    showRowError(row, 'quantity', 'Quantity must be a positive number');
                    valid = false;
                } else {
                    clearRowError(row, 'quantity');
                }

                // Validate serial numbers
                var serialInputs = row.querySelectorAll('.serial-input');
                if (serialInputs.length !== quantityValue) {
                    alert('Please enter quantity first to generate serial number fields');
                    valid = false;
                    return;
                }

                serialInputs.forEach(function(input){
                    var serialValue = input.value.trim();
                    if (serialValue === '') {
                        input.style.borderColor = 'red';
                        valid = false;
                    } else {
                        input.style.borderColor = '';
                        // Check for duplicates
                        if (allSerials.indexOf(serialValue) !== -1) {
                            alert('Duplicate serial number: ' + serialValue);
                            input.style.borderColor = 'red';
                            valid = false;
                        } else {
                            allSerials.push(serialValue);
                        }
                    }
                });
            });

            if (!valid) {
                e.preventDefault();
                return false;
            }

            var submitBtn = document.getElementById('submitBtn');
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<i class="fa fa-spinner fa-spin"></i> Saving...';
            }
        });
    })();

    // Set default datetime for Excel upload form
    (function() {
        var excelDateInput = document.getElementById('excelTransactionDate');
        if (excelDateInput) {
            var now = new Date();
            var year = now.getFullYear();
            var month = String(now.getMonth() + 1).padStart(2, '0');
            var day = String(now.getDate()).padStart(2, '0');
            var hours = String(now.getHours()).padStart(2, '0');
            var minutes = String(now.getMinutes()).padStart(2, '0');
            excelDateInput.value = year + '-' + month + '-' + day + 'T' + hours + ':' + minutes;
        }
    })();
</script>
</body>
</html>


