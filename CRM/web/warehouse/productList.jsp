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
    <link href="${pageContext.request.contextPath}/css/warehouse/productList.css" rel="stylesheet" type="text/css" />
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
            <!-- Hidden div for server data -->
            <div id="paginationData" style="display:none;"
                 data-total-products="<%= request.getAttribute("totalProducts") != null ? request.getAttribute("totalProducts") : 0 %>"
                 data-total-pages="<%= request.getAttribute("totalPages") != null ? request.getAttribute("totalPages") : 1 %>">
            </div>
            
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
                    
                    <%-- Display success message if any --%>
                    <% if (request.getParameter("success") != null) { %>
                        <div class="alert alert-success" style="background-color: #d1fae5; border: 1px solid #86efac; color: #059669; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;">
                            <i class="fa fa-check-circle"></i> <%= request.getParameter("success") %>
                        </div>
                    <% } %>
                    
                    <%-- Display error message from URL parameter --%>
                    <% if (request.getParameter("error") != null) { %>
                        <div class="alert alert-danger" style="background-color: #fed7d7; border: 1px solid #fc8181; color: #742a2a; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;">
                            <i class="fa fa-exclamation-circle"></i> <%= request.getParameter("error") %>
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
                            <input type="text" id="searchInput" class="search-input" placeholder="Search by product name..." 
                                   value="<%= request.getAttribute("searchQuery") != null ? request.getAttribute("searchQuery") : "" %>">
                            
                            <select id="categoryFilter" class="search-input" style="min-width: 150px;">
                                <option value="">All Categories</option>
                                <% 
                                    java.util.List<data.Category> categories = (java.util.List<data.Category>) request.getAttribute("categories");
                                    Integer selectedCategoryId = (Integer) request.getAttribute("selectedCategoryId");
                                    if (categories != null) {
                                        for (data.Category category : categories) {
                                            String selected = (selectedCategoryId != null && selectedCategoryId.equals(category.getId())) ? "selected" : "";
                                %>
                                    <option value="<%= category.getId() %>" <%= selected %>><%= category.getName() %></option>
                                <% 
                                        }
                                    }
                                %>
                            </select>
                            
                            <select id="brandFilter" class="search-input" style="min-width: 150px;">
                                <option value="">All Brands</option>
                                <% 
                                    java.util.List<data.Brand> brands = (java.util.List<data.Brand>) request.getAttribute("brands");
                                    Integer selectedBrandId = (Integer) request.getAttribute("selectedBrandId");
                                    if (brands != null) {
                                        for (data.Brand brand : brands) {
                                            String selected = (selectedBrandId != null && selectedBrandId.equals(brand.getId())) ? "selected" : "";
                                %>
                                    <option value="<%= brand.getId() %>" <%= selected %>><%= brand.getName() %></option>
                                <% 
                                        }
                                    }
                                %>
                            </select>
                            
                            <button class="btn btn-primary" onclick="applyFilters()">
                                <i class="fa fa-filter"></i> Filter
                            </button>
                            <button class="btn btn-primary" onclick="clearFilters()" style="background: #6c757d; border-color: #6c757d;">
                                <i class="fa fa-times"></i> Clear
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
                                                <a href="../warestaff/viewProductDetail?id=<%= product.getId() %>" class="btn btn-action btn-view" style="text-decoration: none;">
                                                    <i class="fa fa-eye"></i> View
                                                </a>
                                                <a href="../warestaff/editProduct?id=<%= product.getId() %>" class="btn btn-action btn-edit" style="text-decoration: none;">
                                                    <i class="fa fa-edit"></i> Edit
                                                </a>
                                                <button class="btn btn-action btn-delete" data-product-id="<%= product.getId() %>" data-product-name="<%= product.getName() %>">
                                                    <i class="fa fa-trash"></i> Delete
                                                </button>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                            
                            <!-- Pagination Controls -->
                            <div class="pagination-container">
                                <div class="pagination-info">
                                    <span id="paginationInfo">Showing 1 to 10 of 0 products</span>
                                </div>
                                
                                <div class="page-size-selector">
                                    <label for="pageSize">Show:</label>
                                    <select id="pageSize" onchange="changePageSize()">
                                        <option value="5">5</option>
                                        <option value="10" selected>10</option>
                                        <option value="25">25</option>
                                        <option value="50">50</option>
                                        <option value="100">100</option>
                                    </select>
                                    <span>per page</span>
                                </div>
                                
                                <div class="pagination-controls">
                                    <button class="pagination-btn" id="firstPageBtn" onclick="goToFirstPage()">
                                        <i class="fa fa-angle-double-left"></i>
                                    </button>
                                    <button class="pagination-btn" id="prevPageBtn" onclick="goToPrevPage()">
                                        <i class="fa fa-angle-left"></i>
                                    </button>
                                    
                                    <div id="pageNumbers"></div>
                                    
                                    <button class="pagination-btn" id="nextPageBtn" onclick="goToNextPage()">
                                        <i class="fa fa-angle-right"></i>
                                    </button>
                                    <button class="pagination-btn" id="lastPageBtn" onclick="goToLastPage()">
                                        <i class="fa fa-angle-double-right"></i>
                                    </button>
                                </div>
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
    </aside>
</div>

<!-- Delete Confirmation Modal -->
<div id="deleteModal" class="modal-overlay">
    <div class="delete-modal">
        <div class="modal-header-custom">
            <div class="modal-icon">
                <i class="fa fa-trash"></i>
            </div>
            <h3>Delete Product</h3>
        </div>
        <div class="modal-body-custom">
            <p class="warning-text">Are you sure you want to delete this product?</p>
            <div class="product-name-display" id="modalProductName">Product Name</div>
            <p class="warning-text">This will permanently remove the product from your inventory.</p>
            <span class="warning-badge">
                <i class="fa fa-exclamation-triangle"></i> This action cannot be undone!
            </span>
        </div>
        <div class="modal-footer-custom">
            <button class="modal-btn modal-btn-cancel" onclick="closeDeleteModal()">
                <i class="fa fa-times"></i> Cancel
            </button>
            <button class="modal-btn modal-btn-delete" id="confirmDeleteBtn">
                <i class="fa fa-trash"></i> Delete Product
            </button>
        </div>
    </div>
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
<script src="${pageContext.request.contextPath}/js/warehouse/productList.js" type="text/javascript"></script>
</body>
</html>

