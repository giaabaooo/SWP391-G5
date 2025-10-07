<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="data.Product" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Warehouse Staff | View List Product</title>
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

        /* Modern Card Styles */
        .content-card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
            margin-bottom: 1.5rem;
            border: 1px solid #f1f3f4;
        }

        .card-header {
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid #f1f3f4;
            background: #fafbfc;
            border-radius: 12px 12px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
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
            padding: 0;
        }

        /* Table Styles */
        .table-responsive {
            overflow-x: auto;
        }

        .inventory-table {
            width: 100%;
            margin: 0;
        }

        .inventory-table thead {
            background: #f8f9fa;
        }

        .inventory-table thead th {
            padding: 1rem;
            font-weight: 600;
            color: #2d3748;
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 2px solid #e2e8f0;
        }

        .inventory-table tbody td {
            padding: 1rem;
            color: #4a5568;
            font-size: 0.9rem;
            border-bottom: 1px solid #f1f3f4;
            vertical-align: middle;
        }

        .inventory-table tbody tr:hover {
            background-color: #f7fafc;
        }

        /* Badge Styles */
        .badge-active {
            background-color: #d1fae5;
            color: #059669;
            padding: 0.35rem 0.75rem;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .badge-inactive {
            background-color: #fee2e2;
            color: #dc2626;
            padding: 0.35rem 0.75rem;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        /* Action Buttons */
        .btn-action {
            padding: 0.4rem 0.8rem;
            font-size: 0.8rem;
            border-radius: 6px;
            margin: 0 0.2rem;
            transition: all 0.3s ease;
        }

        .btn-edit {
            background-color: #3b82f6;
            color: white;
            border: 1px solid #3b82f6;
        }

        .btn-edit:hover {
            background-color: #2563eb;
            color: white;
        }

        .btn-delete {
            background-color: #ef4444;
            color: white;
            border: 1px solid #ef4444;
        }

        .btn-delete:hover {
            background-color: #dc2626;
            color: white;
        }

        /* Search & Filter Bar */
        .filter-bar {
            padding: 1.5rem;
            background: #f8f9fa;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            gap: 1rem;
            align-items: center;
            flex-wrap: wrap;
        }

        .search-input {
            flex: 1;
            min-width: 250px;
            padding: 0.6rem 1rem;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 0.9rem;
        }

        .search-input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .btn-primary {
            background: #6366f1;
            border: 1px solid #6366f1;
            border-radius: 8px;
            padding: 0.6rem 1.5rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background: #5b5ff5;
            border-color: #5b5ff5;
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.3);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 3rem 2rem;
            color: #718096;
        }

        .empty-state i {
            font-size: 4rem;
            color: #cbd5e0;
            margin-bottom: 1rem;
        }

        .empty-state h4 {
            color: #4a5568;
            margin-bottom: 0.5rem;
        }

        /* Active menu highlighting */
        .sidebar-menu li.active > a {
            background-color: #667eea !important;
            color: #ffffff !important;
            border-left: 4px solid #5b5ff5;
            font-weight: 600;
        }

        .sidebar-menu li.active > a i {
            color: #ffffff !important;
        }

        .sidebar-menu .treeview.active > a {
            background-color: rgba(102, 126, 234, 0.1) !important;
            color: #667eea !important;
            font-weight: 600;
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
    </style>
</head>
<body class="skin-black">

<!-- HEADER -->
<header class="header">
    <a href="${pageContext.request.contextPath}/warehouse/dashboard.jsp" class="logo" style="color: #ffffff; font-weight: 600; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">Warehouse Staff</a>
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
                <li><a href="${pageContext.request.contextPath}/warehouse/dashboard.jsp"><i class="fa fa-dashboard"></i> Dashboard</a></li>

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
                    <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">View List Product</h1>
                    <p style="color: #718096; margin-bottom: 2rem;">View and manage all products in warehouse</p>
                    
                    <%-- Display error message if any --%>
                    <% if (request.getAttribute("error") != null) { %>
                        <div class="alert alert-danger" style="background-color: #fed7d7; border: 1px solid #fc8181; color: #742a2a; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;">
                            <i class="fa fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
                        </div>
                    <% } %>
                </div>
            </div>

            <!-- Inventory Table -->
            <div class="row">
                <div class="col-md-12">
                    <div class="content-card">
                        <div class="card-header">
                            <h3><i class="fa fa-list"></i> Product List</h3>
                            <a href="../warestaff/addNewProduct" class="btn btn-primary">
                                <i class="fa fa-plus"></i> Add New Product
                            </a>
                        </div>

                        <!-- Filter Bar -->
                        <div class="filter-bar">
                            <input type="text" id="searchInput" class="search-input" placeholder="Search by product name...">
                            <button class="btn btn-primary" onclick="searchProducts()">
                                <i class="fa fa-search"></i> Search
                            </button>
                        </div>

                        <div class="card-body">
                            <% 
                                List<Product> products = (List<Product>) request.getAttribute("products");
                                Map<Integer, String> categoryMap = (Map<Integer, String>) request.getAttribute("categoryMap");
                                Map<Integer, String> brandMap = (Map<Integer, String>) request.getAttribute("brandMap");
                                
                                if (products != null && !products.isEmpty()) {
                            %>
                            <div class="table-responsive">
                                <table class="inventory-table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Product Name</th>
                                            <th>Category</th>
                                            <th>Brand</th>
                                            <th>Purchase Price</th>
                                            <th>Selling Price</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody id="productTableBody">
                                        <% for (Product product : products) { 
                                            String categoryName = categoryMap.get(product.getCategoryId());
                                            String brandName = product.getBrandId() != null ? brandMap.get(product.getBrandId()) : "N/A";
                                        %>
                                        <tr>
                                            <td><strong>#<%= product.getId() %></strong></td>
                                            <td>
                                                <strong><%= product.getName() %></strong>
                                                <% if (product.getDescription() != null && !product.getDescription().isEmpty()) { %>
                                                <br><small style="color: #718096;"><%= product.getDescription().length() > 50 ? product.getDescription().substring(0, 50) + "..." : product.getDescription() %></small>
                                                <% } %>
                                            </td>
                                            <td><%= categoryName != null ? categoryName : "Unknown" %></td>
                                            <td><%= brandName %></td>
                                            <td>$<%= String.format("%,.2f", product.getPurchasePrice()) %></td>
                                            <td>
                                                <% if (product.getSellingPrice() != null) { %>
                                                    $<%= String.format("%,.2f", product.getSellingPrice()) %>
                                                <% } else { %>
                                                    <span style="color: #a0aec0;">Not set</span>
                                                <% } %>
                                            </td>
                                            <td>
                                                <% if (product.isActive()) { %>
                                                    <span class="badge-active">Active</span>
                                                <% } else { %>
                                                    <span class="badge-inactive">Inactive</span>
                                                <% } %>
                                            </td>
                                            <td>
                                                <button class="btn btn-action btn-edit" data-product-id="<%= product.getId() %>">
                                                    <i class="fa fa-edit"></i> Edit
                                                </button>
                                                <button class="btn btn-action btn-delete" data-product-id="<%= product.getId() %>">
                                                    <i class="fa fa-trash"></i> Delete
                                                </button>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                            <% } else { %>
                            <div class="empty-state">
                                <i class="fa fa-inbox"></i>
                                <h4>No Products Found</h4>
                                <p>There are no products in the inventory yet.</p>
                                <a href="../warestaff/addNewProduct" class="btn btn-primary" style="margin-top: 1rem;">
                                    <i class="fa fa-plus"></i> Add Your First Product
                                </a>
                            </div>
                            <% } %>
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
    // Search functionality
    function searchProducts() {
        var input = document.getElementById('searchInput');
        var filter = input.value.toLowerCase();
        var table = document.getElementById('productTableBody');
        var rows = table.getElementsByTagName('tr');

        for (var i = 0; i < rows.length; i++) {
            var productName = rows[i].getElementsByTagName('td')[1];
            if (productName) {
                var textValue = productName.textContent || productName.innerText;
                if (textValue.toLowerCase().indexOf(filter) > -1) {
                    rows[i].style.display = '';
                } else {
                    rows[i].style.display = 'none';
                }
            }
        }
    }

    // Search on Enter key
    document.getElementById('searchInput').addEventListener('keypress', function(event) {
        if (event.key === 'Enter') {
            searchProducts();
        }
    });

    // Real-time search
    document.getElementById('searchInput').addEventListener('input', searchProducts);

    // Edit product button click handler
    $('.btn-edit').on('click', function() {
        var productId = $(this).data('product-id');
        // TODO: Navigate to edit page
        alert('Edit product ID: ' + productId);
    });

    // Delete product button click handler
    $('.btn-delete').on('click', function() {
        var productId = $(this).data('product-id');
        if (confirm('Are you sure you want to delete this product?')) {
            // TODO: Implement delete functionality
            alert('Delete product ID: ' + productId);
        }
    });

    // Handle collapsible menu
    $('.treeview > a').click(function(e) {
        e.preventDefault();
        var target = $(this).attr('href');
        $(target).collapse('toggle');
    });

    // Auto-expand Products menu since we're on view list product page
    $('#inventoryMenu').addClass('in');
    });
</script>
</body>
</html>

