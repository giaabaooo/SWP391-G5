<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="data.Product" %>
<%@ page import="data.Category" %>
<%@ page import="data.Brand" %>
<%@ page import="data.Device" %>
<!DOCTYPE html>
<html>
    <head>
    <meta charset="UTF-8">
    <title>Customer |  Details</title>
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
    <link href="${pageContext.request.contextPath}/css/warehouse/productDetail.css" rel="stylesheet" type="text/css" />
</head>
    <body class="skin-black">

        <!-- HEADER -->
        <header class="header">
            <a href="dashboard.jsp" class="logo" style="color: #ffffff; font-weight: 600; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">${sessionScope.user.role.name}</a>
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

                        <div class="pull-left info">
                            <p>${sessionScope.user.fullName}</p>
                            <a href="#"><i class="fa fa-circle text-success"></i> Online</a>
                        </div>
                    </div>

                   <ul class="sidebar-menu">
                        <li><a href="dashboard.jsp"><i class="fa fa-dashboard"></i> Dashboard</a></li>


                        <li class="treeview">
                            <a href="#categoryMenu" data-toggle="collapse" aria-expanded="false">
                                <i class="fa fa-tags"></i> <span>Request</span>
                            </a>
                            <ul class="collapse" id="categoryMenu">
                                <li><a href="${pageContext.request.contextPath}/customer/createRequest"><i class="fa fa-plus"></i> Create Request</a></li>
                                <li><a href="${pageContext.request.contextPath}/customer/listRequest"><i class="fa fa-eye"></i> View List Request</a></li>
                                

                            </ul>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/customer/devices"><i class="fa fa-cube"></i>My Devices </a>
                        </li>


                        <li>
                        <li><a href="${pageContext.request.contextPath}/customer/contract"><i class="fa fa-file-text"></i> Contract</a></li>
                        </li>




                       
                        <li class="treeview">
                            <a href="#feedbackMenu" data-toggle="collapse" aria-expanded="false">
                                <i class="fa fa-tags"></i> <span>Feedback</span>
                            </a>
                            <ul class="collapse" id="feedbackMenu">
                                <li><a href="${pageContext.request.contextPath}/customer/createFeedback"><i class="fa fa-plus"></i> Create Feedback</a></li>
                                <li><a href="${pageContext.request.contextPath}/customer/listFeedback"><i class="fa fa-eye"></i> View List Feedback</a></li>
                                

                            </ul>
                        </li>
                    </ul>
                </section>
            </aside>
            <!-- MAIN CONTENT -->
            <aside class="right-side">
                <section class="content">
                    <%
                        Device device = (Device) request.getAttribute("device");
                Product product = (Product) request.getAttribute("product");
                        
                    %>

                    
                    <div class="row">
                        <div class="col-md-12">
                            <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">Device Details</h1>
                            <p style="color: #718096; margin-bottom: 2rem;">View detailed information about this device</p>
                        </div>
                    </div>

                    <!-- Product Detail Card -->
                    <div class="row">
                        <div class="col-md-12">
                            <% if (device != null) { %>
                            <div class="card product-detail-card">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h3><i class="fa fa-cube"></i> <%= device.getProductName() %></h3>
                                    <span class="status-badge <%= device.getStatus().equals("InWarranty") ? "status-active" : "status-inactive" %>">
                                        <i class="fa <%= device.getStatus().equals("InWarranty") ? "fa-check-circle" : "fa-exclamation-circle" %>"></i> <%= device.getStatus() %>
                                    </span>
                                </div>
                                <div class="card-body">

                                    <h4 style="color: #2d3748; font-weight: 600; margin-bottom: 1.5rem; padding-bottom: 0.5rem; border-bottom: 2px solid #e2e8f0;">
                                        <i class="fa fa-info-circle" style="color: #667eea;"></i> Device Information
                                    </h4>

                                    <div class="info-row">
                                        <div class="info-label">
                                            <i class="fa fa-hashtag"></i>ID
                                        </div>
                                        <div class="info-row">
                                            <strong><%= device.getId() %></strong>
                                        </div>
                                    </div>

                                    <div class="info-row">
                                        <div class="info-label">
                                            <i class="fa fa-tag"></i> Device
                                        </div>
                                        <div class="info-row">
                                            <%= device.getProductName() %>
                                        </div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label">
                                            <i class="fa fa-align-left"></i> Description
                                        </div>
                                        <div class="info-row">
                                            <%= product.getDescription() != null && !product.getDescription().isEmpty() 
                                                ? product.getDescription() 
                                                : "<em style='color: #a0aec0;'>No description available</em>" %>
                                        </div>
                                    </div>

                                    <div class="info-row">
                                        <div class="info-label">
                                            <i class="fa fa-folder"></i> Category
                                        </div>
                                        <div class="info-row">
                                            <%= device.getCategoryName() != null ? device.getCategoryName() : "N/A" %>
                                        </div>
                                    </div>

                                    <div class="info-row">
                                        <div class="info-label">
                                            <i class="fa fa-bookmark"></i> Brand
                                        </div>
                                        <div class="info-row">
                                            <%= device.getBrandName() != null ? device.getBrandName() : "N/A" %>
                                        </div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label">
                                            <i class="fa fa-barcode"></i> Serial Number
                                        </div>
                                        <div class="info-row">
                                            <%= device.getSerialNumber() != null ? device.getSerialNumber() : "N/A" %>
                                        </div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label">
                                            <i class="fa fa-dollar"></i> Purchase Price (Cost)
                                        </div>
                                        <div class="info-row">
                                            <span class="price-display">$<%= String.format("%,.2f", product.getPurchasePrice()) %></span>
                                        </div>
                                    </div>

                                    <div class="info-row">
                                        <div class="info-label">
                                            <i class="fa fa-money"></i> Selling Price
                                        </div>
                                        <div class="info-row">
                                            <% if (product.getSellingPrice() != null) { %>
                                            <span class="price-display">$<%= String.format("%,.2f", product.getSellingPrice()) %></span>
                                            <% } else { %>
                                            <em style="color: #a0aec0;">Not set</em>
                                            <% } %>
                                        </div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label">
                                            <i class="fa fa-calendar"></i> Warranty Expiration
                                        </div>
                                        <div class="info-row">
                                            <%= device.getWarrantyExpiration() != null ? device.getWarrantyExpiration() : "N/A" %>
                                        </div>
                                    </div>

                                    <div class="mt-3 text-center">
                                        <a href="devices" class="btn btn-secondary"><i class="fa fa-arrow-left"></i> Back to Devices</a>
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
                                    <a href="../customer/devices" class="btn btn-primary">
                                        <i class="fa fa-arrow-left"></i> Back to Product List
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% } %>

                </section>
                <div class="footer-main">Copyright &copy; Customer Management System, 2024</div>
            </aside>
        </div>

        
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-ui-1.10.3.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/daterangepicker.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/chart.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/icheck.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/fullcalendar.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/app.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/dashboard.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/customer/productDetail.js" type="text/javascript"></script>
    </body>
</html>