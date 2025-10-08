<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="data.Product" %>
<%@ page import="data.Category" %>
<%@ page import="data.Brand" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Warehouse Staff | Product Details</title>
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

        /* Product Detail Card */
        .product-detail-card {
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
            padding: 2rem;
        }

        /* Product Image */
        .product-image-container {
            text-align: center;
            padding: 2rem;
            background: #f8f9fa;
            border-radius: 12px;
            margin-bottom: 2rem;
        }

        .product-image {
            max-width: 100%;
            max-height: 400px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .no-image {
            width: 300px;
            height: 300px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 12px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 5rem;
        }

        /* Product Info */
        .info-row {
            display: flex;
            padding: 1rem 0;
            border-bottom: 1px solid #f1f3f4;
        }

        .info-row:last-child {
            border-bottom: none;
        }

        .info-label {
            flex: 0 0 200px;
            font-weight: 600;
            color: #4a5568;
            display: flex;
            align-items: center;
        }

        .info-label i {
            margin-right: 0.5rem;
            color: #667eea;
            width: 20px;
        }

        .info-value {
            flex: 1;
            color: #2d3748;
            font-size: 1rem;
        }

        /* Status Badge */
        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.875rem;
            display: inline-block;
        }

        .status-active {
            background: #d1fae5;
            color: #059669;
        }

        .status-inactive {
            background: #fee2e2;
            color: #dc2626;
        }

        /* Price Display */
        .price-display {
            font-size: 1.5rem;
            font-weight: 700;
            color: #667eea;
        }

        /* Action Buttons */
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

        .btn-danger {
            background: #ef4444;
            border: 1px solid #ef4444;
            border-radius: 8px;
            padding: 0.75rem 1.5rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-danger:hover {
            background: #dc2626;
            border-color: #dc2626;
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(239, 68, 68, 0.3);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .content {
                padding: 1rem;
            }

            .info-row {
                flex-direction: column;
            }

            .info-label {
                margin-bottom: 0.5rem;
            }

            .card-body {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body class="skin-black">

<!-- HEADER -->
<header class="header">
    <a href="${pageContext.request.contextPath}/warehouse/dashboard.jsp" class="logo" style="color: #ffffff; font-weight: 600; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">Warehouse Staff</a>
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

                <!-- Brands -->
                <li class="treeview">
                    <a href="#brandMenu" data-toggle="collapse" aria-expanded="false">
                        <i class="fa fa-bookmark"></i> <span>Brands</span>
                    </a>
                    <ul class="collapse" id="brandMenu">
                        <li><a href="viewBrands.jsp"><i class="fa fa-eye"></i> View Brands</a></li>
                        <li><a href="addBrand.jsp"><i class="fa fa-plus"></i> Add Brand</a></li>
                        <li><a href="updateBrand.jsp"><i class="fa fa-edit"></i> Update Brand</a></li>
                        <li><a href="deleteBrand.jsp"><i class="fa fa-trash"></i> Delete Brand</a></li>
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
            <%
                Product product = (Product) request.getAttribute("product");
                Category category = (Category) request.getAttribute("category");
                Brand brand = (Brand) request.getAttribute("brand");
                
                if (product != null) {
            %>
            
            <!-- Page Header -->
            <div class="row">
                <div class="col-md-12">
                    <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">Product Details</h1>
                    <p style="color: #718096; margin-bottom: 2rem;">View detailed information about this product</p>
                </div>
            </div>

            <!-- Product Detail Card -->
            <div class="row">
                <div class="col-md-12">
                    <div class="product-detail-card">
                        <div class="card-header">
                            <h3><i class="fa fa-cube"></i> <%= product.getName() %></h3>
                            <div>
                                <% if (product.isActive()) { %>
                                    <span class="status-badge status-active"><i class="fa fa-check-circle"></i> Active</span>
                                <% } else { %>
                                    <span class="status-badge status-inactive"><i class="fa fa-times-circle"></i> Inactive</span>
                                <% } %>
                            </div>
                        </div>
                        <div class="card-body">
                            <!-- Product Image -->
                            <div class="product-image-container">
                                <% if (product.getImageUrl() != null && !product.getImageUrl().isEmpty()) { %>
                                    <img src="<%= product.getImageUrl() %>" alt="<%= product.getName() %>" class="product-image" 
                                         onerror="this.style.display='none'; this.nextElementSibling.style.display='inline-flex';">
                                    <div class="no-image" style="display: none;">
                                        <i class="fa fa-cube"></i>
                                    </div>
                                <% } else { %>
                                    <div class="no-image">
                                        <i class="fa fa-cube"></i>
                                    </div>
                                <% } %>
                            </div>

                            <!-- Product Information -->
                            <h4 style="color: #2d3748; font-weight: 600; margin-bottom: 1.5rem; padding-bottom: 0.5rem; border-bottom: 2px solid #e2e8f0;">
                                <i class="fa fa-info-circle" style="color: #667eea;"></i> Product Information
                            </h4>

                            <div class="info-row">
                                <div class="info-label">
                                    <i class="fa fa-hashtag"></i> Product ID
                                </div>
                                <div class="info-value">
                                    <strong>#<%= product.getId() %></strong>
                                </div>
                            </div>

                            <div class="info-row">
                                <div class="info-label">
                                    <i class="fa fa-tag"></i> Product Name
                                </div>
                                <div class="info-value">
                                    <%= product.getName() %>
                                </div>
                            </div>

                            <div class="info-row">
                                <div class="info-label">
                                    <i class="fa fa-align-left"></i> Description
                                </div>
                                <div class="info-value">
                                    <%= product.getDescription() != null && !product.getDescription().isEmpty() 
                                        ? product.getDescription() 
                                        : "<em style='color: #a0aec0;'>No description available</em>" %>
                                </div>
                            </div>

                            <div class="info-row">
                                <div class="info-label">
                                    <i class="fa fa-folder"></i> Category
                                </div>
                                <div class="info-value">
                                    <%= category != null ? category.getName() : "<em style='color: #a0aec0;'>Unknown</em>" %>
                                </div>
                            </div>

                            <div class="info-row">
                                <div class="info-label">
                                    <i class="fa fa-bookmark"></i> Brand
                                </div>
                                <div class="info-value">
                                    <%= brand != null ? brand.getName() : "<em style='color: #a0aec0;'>N/A</em>" %>
                                </div>
                            </div>

                            <div class="info-row">
                                <div class="info-label">
                                    <i class="fa fa-dollar"></i> Purchase Price (Cost)
                                </div>
                                <div class="info-value">
                                    <span class="price-display">$<%= String.format("%,.2f", product.getPurchasePrice()) %></span>
                                </div>
                            </div>

                            <div class="info-row">
                                <div class="info-label">
                                    <i class="fa fa-money"></i> Selling Price
                                </div>
                                <div class="info-value">
                                    <% if (product.getSellingPrice() != null) { %>
                                        <span class="price-display">$<%= String.format("%,.2f", product.getSellingPrice()) %></span>
                                    <% } else { %>
                                        <em style="color: #a0aec0;">Not set</em>
                                    <% } %>
                                </div>
                            </div>

                            <div class="info-row">
                                <div class="info-label">
                                    <i class="fa fa-image"></i> Image URL
                                </div>
                                <div class="info-value" style="word-break: break-all;">
                                    <%= product.getImageUrl() != null && !product.getImageUrl().isEmpty() 
                                        ? product.getImageUrl() 
                                        : "<em style='color: #a0aec0;'>No image</em>" %>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <div style="margin-top: 2rem; padding-top: 1.5rem; border-top: 1px solid #e2e8f0; text-align: center;">
                                <a href="../warestaff/viewListProduct" class="btn btn-default" style="margin-right: 1rem;">
                                    <i class="fa fa-arrow-left"></i> Back to List
                                </a>
                                <a href="../warestaff/editProduct?id=<%= product.getId() %>" class="btn btn-primary" style="margin-right: 1rem; text-decoration: none;">
                                    <i class="fa fa-edit"></i> Edit Product
                                </a>
                                <button class="btn btn-danger" onclick="deleteProduct(<%= product.getId() %>)">
                                    <i class="fa fa-trash"></i> Delete Product
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <% } else { %>
                <!-- Error State -->
                <div class="row">
                    <div class="col-md-12">
                        <div class="product-detail-card">
                            <div class="card-body" style="text-align: center; padding: 3rem;">
                                <i class="fa fa-exclamation-triangle" style="font-size: 4rem; color: #ef4444; margin-bottom: 1rem;"></i>
                                <h3 style="color: #2d3748; margin-bottom: 1rem;">Product Not Found</h3>
                                <p style="color: #718096; margin-bottom: 2rem;">The product you are looking for does not exist or has been removed.</p>
                                <a href="../warestaff/viewListProduct" class="btn btn-primary">
                                    <i class="fa fa-arrow-left"></i> Back to Product List
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            <% } %>

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
        // Handle collapsible menu
        $('.treeview > a').click(function(e) {
            e.preventDefault();
            var target = $(this).attr('href');
            $(target).collapse('toggle');
        });

        // Auto-expand Products menu
        $('#inventoryMenu').addClass('in');
    });

    // Delete product function
    function deleteProduct(id) {
        if (confirm('Are you sure you want to delete this product? This action cannot be undone.')) {
            // TODO: Implement delete functionality
            alert('Delete product ID: ' + id);
        }
    }
</script>
</body>
</html>

