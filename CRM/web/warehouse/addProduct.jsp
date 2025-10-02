<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Warehouse Staff | Add Product</title>
    <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
    <meta name="description" content="Warehouse Management System">
    <meta name="keywords" content="Warehouse, Inventory, Management">
    <!-- bootstrap 3.0.2 -->
    <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/ionicons.min.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/morris/morris.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/jvectormap/jquery-jvectormap-1.2.2.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/daterangepicker/daterangepicker-bs3.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/iCheck/all.css" rel="stylesheet" type="text/css" />
    <link href='http://fonts.googleapis.com/css?family=Lato' rel='stylesheet' type='text/css'>
    <link href="${pageContext.request.contextPath}/css/admin/style.css" rel="stylesheet" type="text/css" />
    <style>
        /* Professional Dashboard Styles */
        html, body {
            height: 100%;
            overflow: hidden;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #ffffff;
        }

        .wrapper {
            height: 100vh;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        .right-side {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            position: relative;
            height: 100%;
            background: #ffffff;
            min-height: 100vh;
        }

        .content {
            flex: 1;
            padding: 2rem;
            background: #ffffff;
            overflow-y: auto;
            min-height: 0;
            padding-bottom: 2rem;
        }

        .footer-main {
            background-color: #ffffff;
            padding: 1rem;
            border-top: 1px solid #e8ecef;
            text-align: center;
            position: relative;
            margin-top: auto;
            z-index: 1000;
            font-size: 0.875rem;
            color: #6c757d;
            font-weight: 400;
            box-shadow: 0 -1px 3px rgba(0,0,0,0.05);
            flex-shrink: 0;
        }

        /* Remove sidebar dots and search */
        .sidebar-menu li {
            list-style: none;
        }

        .sidebar-menu li:before {
            display: none;
        }

        .sidebar-form {
            display: none;
        }

        /* Modern Form Styles */
        .content-card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
            margin-bottom: 1.5rem;
            border: 1px solid #f1f3f4;
            transition: box-shadow 0.3s ease;
        }

        .content-card:hover {
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.12);
        }

        .card-header {
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid #f1f3f4;
            background: #fafbfc;
            border-radius: 12px 12px 0 0;
        }

        .card-header h3 {
            margin: 0;
            font-size: 1.1rem;
            font-weight: 600;
            color: #2d3748;
            display: flex;
            align-items: center;
        }

        .card-header h3 i {
            margin-right: 0.5rem;
            color: #667eea;
        }

        .card-body {
            padding: 1.5rem;
        }

        /* Form Styling */
        .form-group {
            margin-bottom: 1.5rem;
            clear: both;
        }

        .form-control {
            border: 1px solid #e2e8f0 !important;
            border-radius: 6px;
            padding: 0.75rem;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            background: #ffffff;
            width: 100%;
            box-sizing: border-box;
        }

        .form-control.error {
            border-color: #dc3545 !important;
            box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.1) !important;
        }

        .form-control:focus {
            border-color: #667eea !important;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1) !important;
            outline: none;
        }

        .control-label {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 0.5rem;
            display: block;
            font-size: 0.9rem;
        }

        /* Form layout */
        .form-row {
            display: flex;
            flex-wrap: wrap;
            margin: 0 -15px 1.5rem -15px;
        }

        .form-col {
            flex: 0 0 50%;
            max-width: 50%;
            padding: 0 15px;
            box-sizing: border-box;
        }

        .form-col-full {
            flex: 0 0 100%;
            max-width: 100%;
            padding: 0 15px;
            box-sizing: border-box;
        }

        /* Align form groups in rows */
        .form-row .form-group {
            margin-bottom: 0;
        }

        /* Section headers */
        .section-header {
            font-size: 1rem;
            font-weight: 600;
            color: #4a5568;
            margin-bottom: 1.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #e2e8f0;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .section-header i {
            margin-right: 0.5rem;
            color: #667eea;
        }

        /* Remove input group styling - using placeholders instead */

        /* Help text styling */
        .help-block {
            font-size: 0.8rem;
            margin-top: 0.25rem;
            color: #718096;
            font-style: italic;
        }

        /* Checkbox styling */
        .checkbox-container {
            margin-top: 8px;
        }

        .checkbox-label {
            display: flex;
            align-items: center;
            font-weight: normal;
            margin: 0;
            cursor: pointer;
        }

        .checkbox-label input[type="checkbox"] {
            margin-right: 8px;
            transform: scale(1.2);
        }

        .checkbox-text {
            color: #4a5568;
            font-weight: 500;
        }

        /* Button Styling */
        .btn-primary {
            background: #6366f1;
            border: 1px solid #6366f1;
            border-radius: 8px;
            padding: 0.75rem 1.5rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background: #5b5ff5;
            border-color: #5b5ff5;
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.3);
        }

        .btn-default {
            background: #f8f9fa;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 0.75rem 1.5rem;
            font-weight: 500;
            color: #4a5568;
            transition: all 0.3s ease;
        }

        .btn-default:hover {
            background: #e2e8f0;
            border-color: #cbd5e0;
            transform: translateY(-1px);
            color: #2d3748;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .content {
                padding: 1rem;
                padding-bottom: 2rem;
            }

            .footer-main {
                position: relative;
                margin-top: auto;
                flex-shrink: 0;
            }

            /* Stack columns on mobile */
            .form-col {
                flex: 0 0 100%;
                max-width: 100%;
            }

            .form-row {
                margin-bottom: 1.5rem;
            }

            /* Adjust form buttons on mobile */
            .btn {
                width: 100%;
                margin-bottom: 0.5rem;
                margin-right: 0 !important;
            }



        /* Validation Error Messages */
        .validation-error {
            color: #dc3545 !important;
            font-size: 0.75rem !important;
            margin-top: 0.25rem !important;
            font-weight: 500 !important;
            font-style: italic !important;
            display: none !important;
        }

        .validation-error.show {
            display: block !important;
        }


        /* Success Message */
        .success-message {
            background-color: #d1fae5 !important;
            border: 1px solid #86efac !important;
            color: #059669 !important;
            padding: 1rem !important;
            border-radius: 8px !important;
            margin-bottom: 1rem !important;
            font-weight: 500 !important;
            text-align: center !important;
        }

        .success-message i {
            margin-right: 0.5rem !important;
            color: #10b981 !important;
            font-size: 1.1rem !important;
        }

            .text-center .btn {
                margin-bottom: 0.5rem;
            }
        }
    </style>
</head>
<body class="skin-black">

<!-- HEADER -->
<header class="header">
    <a href="dashboard.jsp" class="logo" style="color: #ffffff; font-weight: 600; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">Warehouse Staff</a>
    <nav class="navbar navbar-static-top" role="navigation">
        <!-- <a href="#" class="navbar-btn sidebar-toggle" data-toggle="offcanvas" role="button">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </a> -->
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
                        <li><a href="../login.jsp"><i class="fa fa-ban fa-fw pull-right"></i> Logout</a></li>
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
                <li><a href="dashboard.jsp"><i class="fa fa-dashboard"></i> Dashboard</a></li>

                <!-- Inventory Management -->
                <li class="treeview">
                    <a href="#inventoryMenu" data-toggle="collapse" aria-expanded="false">
                        <i class="fa fa-cubes"></i> <span>Inventory Management</span>
                    </a>
                    <ul class="collapse" id="inventoryMenu">
                        <li><a href="inventory.jsp"><i class="fa fa-list"></i> View Inventory</a></li>
                        <li class="active"><a href="../addNewProduct"><i class="fa fa-plus"></i> Add Product</a></li>
                        <li><a href="updateItem.jsp"><i class="fa fa-edit"></i> Update Product</a></li>
                        <li><a href="deleteItem.jsp"><i class="fa fa-trash"></i> Delete Product</a></li>
                    </ul>
                </li>

                <!-- Categories -->
                <li class="treeview">
                    <a href="#categoryMenu" data-toggle="collapse" aria-expanded="false">
                        <i class="fa fa-tags"></i> <span>Categories</span>
                    </a>
                    <ul class="collapse" id="categoryMenu">
                        <li><a href="viewCategories.jsp"><i class="fa fa-eye"></i> View Categories</a></li>
                        <li><a href="addCategory.jsp"><i class="fa fa-plus"></i> Add Category</a></li>
                        <li><a href="updateCategory.jsp"><i class="fa fa-edit"></i> Update Category</a></li>
                        <li><a href="deleteCategory.jsp"><i class="fa fa-trash"></i> Delete Category</a></li>
                    </ul>
                </li>

                <!-- Transactions -->
                <li class="treeview">
                    <a href="#transactionMenu" data-toggle="collapse" aria-expanded="false">
                        <i class="fa fa-exchange"></i> <span>Transactions</span>
                    </a>
                    <ul class="collapse" id="transactionMenu">
                        <li><a href="transactions.jsp"><i class="fa fa-list"></i> View Transactions</a></li>
                        <li><a href="spareParts.jsp"><i class="fa fa-cogs"></i> Manage Spare Parts</a></li>
                        <li><a href="importExport.jsp"><i class="fa fa-upload"></i> Import/Export</a></li>
                    </ul>
                </li>

                <!-- Requests -->
                <li><a href="requests.jsp"><i class="fa fa-clipboard"></i> Inventory Requests</a></li>

                <!-- Reports -->
                <li><a href="reports.jsp"><i class="fa fa-bar-chart"></i> Inventory Reports</a></li>
            </ul>
        </section>
    </aside>

    <!-- MAIN CONTENT -->
    <aside class="right-side">
        <section class="content">
            <!-- Page Header -->
            <div class="row">
                <div class="col-md-12">
                    <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">Add New Product</h1>
                    <p style="color: #718096; margin-bottom: 2rem;">Add a new item to the warehouse inventory</p>
                    
                    <%-- Display error message if any --%>
                    <% if (request.getAttribute("error") != null) { %>
                        <div class="alert alert-danger" style="background-color: #fed7d7; border: 1px solid #fc8181; color: #742a2a; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;">
                            <i class="fa fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
                        </div>
                    <% } %>
                </div>
            </div>

            <!-- Add Product Form -->
            <div class="row">
                <div class="col-md-12">
                    <div class="content-card">
                        <div class="card-header">
                            <h3><i class="fa fa-plus"></i> Product Information</h3>
                        </div>
                        <div class="card-body">
                            <form method="post" action="addNewProduct" novalidate>
                                <!-- Row 1: Product Name and Purchase Price -->
                                <div class="form-row">
                                    <div class="form-col">
                                        <div class="form-group">
                                            <label class="control-label">Product Name<span style="color:red">*</span></label>
                                            <input type="text" name="name" id="productName" class="form-control" placeholder="Enter product name" />
                                            <div class="validation-error" id="nameError" style="display: none;">Product name is required</div>
                                        </div>
                                    </div>
                                    <div class="form-col">
                                        <div class="form-group">
                                            <label class="control-label">Purchase Price (Cost)<span style="color:red">*</span></label>
                                            <input type="number" step="0.01" min="0" name="purchase_price" id="purchasePrice" class="form-control" placeholder="($) 0.00" />
                                            <div class="validation-error" id="purchasePriceError" style="display: none;">Purchase price is required and must be non-negative</div>
                                            <small class="help-block">The cost price you pay for this item</small>
                                        </div>
                                    </div>
                                </div>

                                <!-- Row 2: Description and Selling Price -->
                                <div class="form-row">
                                    <div class="form-col">
                                        <div class="form-group">
                                            <label class="control-label">Description</label>
                                            <textarea name="description" class="form-control" rows="4" placeholder="Enter product description"></textarea>
                                        </div>
                                    </div>
                                    <div class="form-col">
                                        <div class="form-group">
                                            <label class="control-label">Selling Price</label>
                                            <input type="number" step="0.01" min="0" name="selling_price" id="sellingPrice" class="form-control" placeholder="($) 0.00" />
                                            <div class="validation-error" id="sellingPriceError" style="display: none;">Selling price must be non-negative</div>
                                            <small class="help-block">The price you sell this item for</small>
                                        </div>
                                    </div>
                                </div>

                                <!-- Row 3: Category and Brand -->
                                <div class="form-row">
                                    <div class="form-col">
                                        <div class="form-group">
                                            <label class="control-label">Category<span style="color:red">*</span></label>
                                            <select name="category_id" id="categoryId" class="form-control">
                                                <option value="">-- Select Category --</option>
                                                <%-- Populate categories from request attribute --%>
                                                <% if (request.getAttribute("categories") != null) { %>
                                                    <% java.util.List<data.Category> categories = (java.util.List<data.Category>) request.getAttribute("categories"); %>
                                                    <% for (data.Category c : categories) { %>
                                                        <option value="<%= c.getId() %>"><%= c.getName() %></option>
                                                    <% } %>
                                                <% } %>
                                            </select>
                                            <div class="validation-error" id="categoryError" style="display: none;">Please select a category</div>
                                        </div>
                                    </div>
                                    <div class="form-col">
                                        <div class="form-group">
                                            <label class="control-label">Brand</label>
                                            <select name="brand_id" class="form-control">
                                                <option value="">-- Select Brand --</option>
                                                <%-- Populate brands from request attribute --%>
                                                <% if (request.getAttribute("brands") != null) { %>
                                                    <% java.util.List<data.Brand> brands = (java.util.List<data.Brand>) request.getAttribute("brands"); %>
                                                    <% for (data.Brand b : brands) { %>
                                                        <option value="<%= b.getId() %>"><%= b.getName() %></option>
                                                    <% } %>
                                                <% } %>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <!-- Row 4: Product Image URL and Status -->
                                <div class="form-row">
                                    <div class="form-col">
                                        <div class="form-group">
                                            <label class="control-label">Product Image URL</label>
                                            <input type="url" name="image_url" class="form-control" placeholder="https://example.com/image.jpg" />
                                            <small class="help-block">Optional: Enter a URL for the product image</small>
                                        </div>
                                    </div>
                                    <div class="form-col">
                                        <div class="form-group">
                                            <label class="control-label">Status</label>
                                            <div class="checkbox-container">
                                                <label class="checkbox-label">
                                                    <input type="checkbox" name="is_active" checked />
                                                    <span class="checkbox-text">Active</span>
                                                </label>
                                            </div>
                                            <small class="help-block">Uncheck to disable this product</small>
                                        </div>
                                    </div>
                                </div>

                                <!-- Success Message -->
                                <% if (request.getAttribute("success") != null) { %>
                                    <div class="success-message" style="margin-top: 2rem; background-color: #d1fae5 !important; border: 1px solid #86efac !important; color: #059669 !important; padding: 1rem !important; border-radius: 8px !important; text-align: center !important;">
                                        <i class="fa fa-check-circle" style="color: #10b981 !important; margin-right: 0.5rem !important; font-size: 1.1rem !important;"></i> <%= request.getAttribute("success") %>
                                    </div>
                                <% } %>

                                <!-- Form Actions -->
                                <div class="form-row" style="margin-top: 2rem; padding-top: 1.5rem; border-top: 1px solid #e2e8f0; margin-bottom: 0;">
                                    <div class="form-col-full text-center">
                                        <button type="submit" class="btn btn-primary" style="margin-right: 1rem; min-width: 150px;">
                                            <i class="fa fa-save"></i> Save Product
                                        </button>
                                        <a href="dashboard.jsp" class="btn btn-default" style="min-width: 150px;">
                                            <i class="fa fa-arrow-left"></i> Back to Dashboard
                                        </a>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

        </section>
        <div class="footer-main">Copyright &copy; Warehouse Management System, 2024</div>
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
    $(function() {
        // Hide all validation errors on page load and set normal border
        $('.validation-error').removeClass('show');
        $('.form-control').removeClass('error');
        
        // Real-time validation functions
        function validateProductName() {
            var name = $('#productName').val().trim();
            
            if (name.length === 0) {
                showError('nameError', 'Product name is required');
                return false;
            } else if (name.length < 2) {
                showError('nameError', 'Product name must be at least 2 characters');
                return false;
            } else {
                hideError('nameError');
                return true;
            }
        }

        function validatePurchasePrice() {
            var price = parseFloat($('#purchasePrice').val());
            
            if (isNaN(price)) {
                showError('purchasePriceError', 'Purchase price is required');
                return false;
            } else if (price < 0) {
                showError('purchasePriceError', 'Purchase price cannot be negative');
                return false;
            } else {
                hideError('purchasePriceError');
                return true;
            }
        }

        function validateSellingPrice() {
            var price = $('#sellingPrice').val();
            
            if (price === '') {
                hideError('sellingPriceError');
                return true;
            }
            
            var numPrice = parseFloat(price);
            
            if (isNaN(numPrice)) {
                showError('sellingPriceError', 'Selling price must be a valid number');
                return false;
            } else if (numPrice < 0) {
                showError('sellingPriceError', 'Selling price cannot be negative');
                return false;
            } else {
                hideError('sellingPriceError');
                return true;
            }
        }

        function validateCategory() {
            var category = $('#categoryId').val();
            
            if (category === '' || category === null) {
                showError('categoryError', 'Please select a category');
                return false;
            } else {
                hideError('categoryError');
                return true;
            }
        }

        function showError(errorId, message) {
            // Show error message
            $('#' + errorId)
                .text(message)
                .addClass('show')
                .css({
                    'color': '#dc3545',
                    'font-style': 'italic',
                    'font-size': '0.75rem',
                    'font-weight': '500'
                });
            
            // Add error class to corresponding input field
            var inputId = errorId.replace('Error', '');
            if (inputId === 'name') {
                $('#productName').addClass('error');
            } else if (inputId === 'purchasePrice') {
                $('#purchasePrice').addClass('error');
            } else if (inputId === 'sellingPrice') {
                $('#sellingPrice').addClass('error');
            } else if (inputId === 'category') {
                $('#categoryId').addClass('error');
            }
        }

        function hideError(errorId) {
            // Hide error message
            $('#' + errorId).removeClass('show');
            
            // Remove error class from corrisponding input field
            var inputId = errorId.replace('Error', '');
            if (inputId === 'name') {
                $('#productName').removeClass('error');
            } else if (inputId === 'purchasePrice') {
                $('#purchasePrice').removeClass('error');
            } else if (inputId === 'sellingPrice') {
                $('#sellingPrice').removeClass('error');
            } else if (inputId === 'category') {
                $('#categoryId').removeClass('error');
            }
        }

        function validateAll() {
            var isValid = true;
            
            isValid &= validateProductName();
            isValid &= validatePurchasePrice();
            isValid &= validateSellingPrice();
            isValid &= validateCategory();
            
            return isValid;
        }

        function clearForm() {
            $('form')[0].reset();
            $('.validation-error').removeClass('show');
            $('.form-control').removeClass('error');
            $('.success-message').fadeOut();
        }

        function clearValidationErrors() {
            $('.validation-error').removeClass('show');
            $('.form-control').removeClass('error');
        }


        // Real-time border validation (without error messages)
        $('#productName').on('input', function() {
            var name = $(this).val().trim();
            if (name.length >= 2) {
                $(this).removeClass('error');
                $('#nameError').removeClass('show');
            }
        });

        $('#purchasePrice').on('input', function() {
            var price = parseFloat($(this).val());
            if (!isNaN(price) && price >= 0) {
                $(this).removeClass('error');
                $('#purchasePriceError').removeClass('show');
            }
        });

        $('#sellingPrice').on('input', function() {
            var price = $(this).val();
            if (price === '' || (!isNaN(parseFloat(price)) && parseFloat(price) >= 0)) {
                $(this).removeClass('error');
                $('#sellingPriceError').removeClass('show');
            }
        });

        $('#categoryId').on('change', function() {
            var category = $(this).val();
            if (category !== '' && category !== null) {
                $(this).removeClass('error');
                $('#categoryError').removeClass('show');
            }
        });

        // Main validation only happens on form submission

        // Form submission
        $('form').on('submit', function(e) {
            // Clear previous validation states
            clearValidationErrors();
            
            // Run validation
            if (!validateAll()) {
                e.preventDefault();
                
                // Scroll to first error
                var firstError = $('.validation-error.show').first();
                if (firstError.length) {
                    $('html, body').animate({
                        scrollTop: firstError.closest('.form-group').offset().top - 100
                    }, 500);
                }
                return false;
            }

            // Show loading state
            var submitBtn = $(this).find('button[type="submit"]');
            submitBtn.prop('disabled', true).html('<i class="fa fa-spinner fa-spin"></i> Saving...');

            // Re-enable button after 5 seconds in case of server issues
            setTimeout(function() {
                submitBtn.prop('disabled', false).html('<i class="fa fa-save"></i> Save Product');
            }, 5000);
        });

        // Clear form automatically after 3 seconds on successful submission
        setTimeout(function() {
            if ($('.success-message').length > 0) {
                setTimeout(clearForm, 3000);
            }
        }, 1000);

        // Handle collapsible menu
        $('.treeview > a').click(function(e) {
            e.preventDefault();
            var target = $(this).attr('href');
            $(target).collapse('toggle');
        });

        // Auto-expand inventory menu since we're on add product page
        $('#inventoryMenu').addClass('in');
        $('.treeview').first().addClass('active');
    });
</script>
</body>
</html>


