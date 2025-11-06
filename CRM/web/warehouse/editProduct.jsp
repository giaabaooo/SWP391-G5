<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="data.Product" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Warehouse Staff | Edit Product</title>
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
    <link href="${pageContext.request.contextPath}/css/warehouse/editProduct.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/warehouse/responsive.css" rel="stylesheet" type="text/css" />
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
                <li><a href="${pageContext.request.contextPath}/warestaff/dashboard"><i class="fa fa-dashboard"></i> Dashboard</a></li>

                <!-- Products -->
                <li class="treeview">
                    <a href="#inventoryMenu" data-toggle="collapse" aria-expanded="false">
                        <i class="fa fa-cubes"></i> <span>Products</span>
                    </a>
                    <ul class="collapse" id="inventoryMenu">
                        <li><a href="../warestaff/viewListProduct"><i class="fa fa-list"></i> View List Product</a></li>
                        <li class="active"><a href="../warestaff/addNewProduct"><i class="fa fa-plus"></i> Add Product</a></li>
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
                        <li><a href="transactions.jsp"><i class="fa fa-list"></i> View Transactions</a></li>
                        <li><a href="spareParts.jsp"><i class="fa fa-cogs"></i> Manage Spare Parts</a></li>
                        <li><a href="importExport.jsp"><i class="fa fa-upload"></i> Import/Export</a></li>
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
                    <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">Edit Product</h1>
                    <p style="color: #718096; margin-bottom: 2rem;">Update product information in the warehouse inventory</p>
                    
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
                    <%
                        Product product = (Product) request.getAttribute("product");
                        if (product != null) {
                    %>
                    <div class="content-card">
                        <div class="card-header">
                            <h3><i class="fa fa-edit"></i> Product Information</h3>
                        </div>
                        <div class="card-body">
                            <form method="post" action="../warestaff/editProduct" novalidate>
                                <!-- Hidden field for product ID -->
                                <input type="hidden" name="id" value="<%= product.getId() %>" />
                                
                                <!-- Row 1: Product Name and Purchase Price -->
                                <div class="form-row">
                                    <div class="form-col">
                                        <div class="form-group">
                                            <label class="control-label">Product Name<span style="color:red">*</span></label>
                                            <input type="text" name="name" id="productName" class="form-control" placeholder="Enter product name" value="<%= product.getName() %>" />
                                            <div class="validation-error" id="nameError" style="display: none;">Product name is required</div>
                                        </div>
                                    </div>
                                    <div class="form-col">
                                        <div class="form-group">
                                            <label class="control-label">Purchase Price (Cost)<span style="color:red">*</span></label>
                                            <input type="number" step="0.01" min="0" name="purchase_price" id="purchasePrice" class="form-control" placeholder="($) 0.00" value="<%= product.getPurchasePrice() %>" />
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
                                            <textarea name="description" class="form-control" rows="4" placeholder="Enter product description"><%= product.getDescription() != null ? product.getDescription() : "" %></textarea>
                                        </div>
                                    </div>
                                    <div class="form-col">
                                        <div class="form-group">
                                            <label class="control-label">Selling Price</label>
                                            <input type="number" step="0.01" min="0" name="selling_price" id="sellingPrice" class="form-control" placeholder="($) 0.00" value="<%= product.getSellingPrice() != null ? product.getSellingPrice() : "" %>" />
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
                                                        <option value="<%= c.getId() %>" <%= (product.getCategoryId() == c.getId()) ? "selected" : "" %>><%= c.getName() %></option>
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
                                                        <option value="<%= b.getId() %>" <%= (product.getBrandId() != null && product.getBrandId() == b.getId()) ? "selected" : "" %>><%= b.getName() %></option>
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
                                            <input type="url" name="image_url" class="form-control" placeholder="https://example.com/image.jpg" value="<%= product.getImageUrl() != null ? product.getImageUrl() : "" %>" />
                                            <small class="help-block">Optional: Enter a URL for the product image</small>
                                        </div>
                                    </div>
                                    <div class="form-col">
                                        <div class="form-group">
                                            <label class="control-label">Status</label>
                                            <div class="checkbox-container">
                                                <label class="checkbox-label">
                                                    <input type="checkbox" name="is_active" <%= product.isActive() ? "checked" : "" %> />
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
                                            <i class="fa fa-save"></i> Update Product
                                        </button>
                                        <a href="../warestaff/viewListProduct" class="btn btn-default" style="min-width: 150px;">
                                            <i class="fa fa-arrow-left"></i> Back to List
                                        </a>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                    <%
                        } else {
                    %>
                    <div class="content-card">
                        <div class="card-body">
                            <p style="color: #e53e3e; text-align: center; padding: 2rem;">
                                <i class="fa fa-exclamation-triangle"></i> Product not found or invalid product ID.
                            </p>
                            <div style="text-align: center; margin-top: 1rem;">
                                <a href="../warestaff/viewListProduct" class="btn btn-default">
                                    <i class="fa fa-arrow-left"></i> Back to Product List
                                </a>
                            </div>
                        </div>
                    </div>
                    <%
                        }
                    %>
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
<script src="${pageContext.request.contextPath}/js/warehouse/editProduct.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/warehouse/warehouse-responsive.js" type="text/javascript"></script>

</body>
</html>


