<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="data.Category" %>
<%@ page import="data.Product" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Warehouse Staff | Category Details</title>
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
    <link href="${pageContext.request.contextPath}/css/warehouse/responsive.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/warehouse/category-detail.css" rel="stylesheet" type="text/css" />
</head>
<body class="skin-black">

<!-- Mobile Menu Toggle -->
<button class="mobile-menu-toggle" onclick="toggleMobileMenu()">
    <i class="fa fa-bars"></i>
</button>

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
                Category category = (Category) request.getAttribute("category");
                List<Product> products = (List<Product>) request.getAttribute("products");
                Integer totalProducts = (Integer) request.getAttribute("totalProducts");
                Integer activeProducts = (Integer) request.getAttribute("activeProducts");
                int[] inventoryStats = (int[]) request.getAttribute("inventoryStats");
                Object[] contractStats = (Object[]) request.getAttribute("contractStats");
                int[] deviceStats = (int[]) request.getAttribute("deviceStats");
                
                if (category == null) {
                    response.sendRedirect(request.getContextPath() + "/warestaff/categoryList?error=Category%20not%20found");
                    return;
                }
            %>
            
            <!-- Back Button -->
            <a href="../warestaff/categoryList" class="back-button">
                <i class="fa fa-arrow-left"></i> Back to Categories
            </a>
            
            <!-- Category Detail Card -->
            <div class="category-detail-card">
                <div class="category-header">
                    <h1><%= category.getName() %></h1>
                    <div class="category-id">Category ID: #<%= category.getId() %></div>
                </div>
                
                <div class="category-info">
                    <!-- Category Information Grid -->
                    <div class="info-grid">
                        <div class="info-card">
                            <div class="icon">
                                <i class="fa fa-cubes" style="color: #667eea;"></i>
                            </div>
                            <div class="number"><%= totalProducts != null ? totalProducts : 0 %></div>
                            <div class="label">Total Products</div>
                        </div>
                        
                        <div class="info-card">
                            <div class="icon">
                                <i class="fa fa-check-circle" style="color: #10b981;"></i>
                            </div>
                            <div class="number"><%= activeProducts != null ? activeProducts : 0 %></div>
                            <div class="label">Active Products</div>
                        </div>
                        
                        <div class="info-card">
                            <div class="icon">
                                <i class="fa fa-warehouse" style="color: #f59e0b;"></i>
                            </div>
                            <div class="number"><%= inventoryStats != null ? inventoryStats[0] : 0 %></div>
                            <div class="label">Total Stock</div>
                        </div>
                        
                        <div class="info-card">
                            <div class="icon">
                                <i class="fa fa-exclamation-triangle" style="color: #ef4444;"></i>
                            </div>
                            <div class="number"><%= inventoryStats != null ? inventoryStats[1] : 0 %></div>
                            <div class="label">Low Stock Items</div>
                        </div>
                        
                        <div class="info-card">
                            <div class="icon">
                                <i class="fa fa-file-contract" style="color: #8b5cf6;"></i>
                            </div>
                            <div class="number"><%= contractStats != null ? contractStats[0] : 0 %></div>
                            <div class="label">Total Contracts</div>
                        </div>
                        
                        <div class="info-card">
                            <div class="icon">
                                <i class="fa fa-dollar-sign" style="color: #059669;"></i>
                            </div>
                            <div class="number">
                                <% if (contractStats != null && contractStats[1] != null) { %>
                                    $<%= String.format("%.0f", ((java.math.BigDecimal) contractStats[1]).doubleValue()) %>
                                <% } else { %>
                                    $0
                                <% } %>
                            </div>
                            <div class="label">Total Revenue</div>
                        </div>
                        
                        <div class="info-card">
                            <div class="icon">
                                <i class="fa fa-microchip" style="color: #06b6d4;"></i>
                            </div>
                            <div class="number"><%= deviceStats != null ? deviceStats[0] : 0 %></div>
                            <div class="label">Total Devices</div>
                        </div>
                        
                        <div class="info-card">
                            <div class="icon">
                                <i class="fa fa-shield-alt" style="color: #10b981;"></i>
                            </div>
                            <div class="number"><%= deviceStats != null ? deviceStats[1] : 0 %></div>
                            <div class="label">In Warranty</div>
                        </div>
                        
                        <div class="info-card">
                            <div class="icon">
                                <i class="fa fa-info-circle" style="color: #3b82f6;"></i>
                            </div>
                            <div class="number">
                                <span class="status-badge <%= category.isActive() ? "status-active" : "status-inactive" %>">
                                    <%= category.isActive() ? "Active" : "Inactive" %>
                                </span>
                            </div>
                            <div class="label">Category Status</div>
                        </div>
                    </div>
                    
                    <!-- Category Description -->
                    <% if (category.getDescription() != null && !category.getDescription().trim().isEmpty()) { %>
                    <div class="description-section">
                        <h3><i class="fa fa-file-text-o"></i> Description</h3>
                        <p style="color: #4a5568; line-height: 1.6; font-size: 1.1rem; background: #f7fafc; padding: 1.5rem; border-radius: 8px; border-left: 4px solid #667eea;">
                            <%= category.getDescription() %>
                        </p>
                    </div>
                    <% } else { %>
                    <div class="description-section">
                        <h3><i class="fa fa-file-text-o"></i> Description</h3>
                        <p style="color: #a0aec0; font-style: italic; background: #f7fafc; padding: 1.5rem; border-radius: 8px; border-left: 4px solid #e2e8f0;">
                            No description available for this category.
                        </p>
                    </div>
                    <% } %>
                </div>
            </div>
            
            <!-- Products in this Category -->
            <div class="products-section">
                <div class="section-title">
                    <i class="fa fa-cubes"></i>
                    Products in this Category
                </div>
                
                <% if (products != null && !products.isEmpty()) { %>
                    <% for (Product product : products) { %>
                    <div class="product-card">
                        <div class="product-name">
                            <%= product.getName() %>
                            <span class="status-badge <%= product.isActive() ? "status-active" : "status-inactive" %>" style="margin-left: 1rem;">
                                <%= product.isActive() ? "Active" : "Inactive" %>
                            </span>
                        </div>
                        <div class="product-details">
                            <div><strong>ID:</strong> #<%= product.getId() %></div>
                            <div><strong>Price:</strong> $<%= product.getSellingPrice() %></div>
                            <div><strong>Purchase Price:</strong> $<%= product.getPurchasePrice() %></div>
                            <div><strong>Category ID:</strong> <%= product.getCategoryId() %></div>
                        </div>
                        <% if (product.getDescription() != null && !product.getDescription().trim().isEmpty()) { %>
                        <div style="margin-top: 0.5rem; color: #718096; font-size: 0.9rem;">
                            <%= product.getDescription().length() > 100 ? product.getDescription().substring(0, 100) + "..." : product.getDescription() %>
                        </div>
                        <% } %>
                    </div>
                    <% } %>
                <% } else { %>
                <div class="no-products">
                    <i class="fa fa-cube"></i>
                    <h4>No Products Found</h4>
                    <p>There are no products in this category yet.</p>
                    <a href="../warestaff/addNewProduct" class="btn btn-primary" style="margin-top: 1rem;">
                        <i class="fa fa-plus"></i> Add Product to this Category
                    </a>
                </div>
                <% } %>
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
<script src="${pageContext.request.contextPath}/js/warehouse/warehouse-responsive.js" type="text/javascript"></script>

</body>
</html>
