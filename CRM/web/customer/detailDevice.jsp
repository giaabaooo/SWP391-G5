<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="data.Product" %>
<%@ page import="data.Category" %>
<%@ page import="data.Brand" %>
<%@ page import="data.Device" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Customer | Device Details</title>
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
                        <li class="active"><a href="dashboard.jsp"><i class="fa fa-dashboard"></i> Dashboard</a></li>


                        <li class="treeview">
                            <a href="#categoryMenu" data-toggle="collapse" aria-expanded="false">
                                <i class="fa fa-tags"></i> <span>Request</span>
                            </a>
                            <ul class="collapse" id="categoryMenu">
                                <li><a href="createRequest.jsp"><i class="fa fa-plus"></i> Create Request</a></li>
                                <li><a href="listRequest.jsp"><i class="fa fa-eye"></i> View List Request</a></li>
                                <li><a href="statusRequest.jsp"><i class="fa fa-edit"></i> Track Status Request</a></li>

                            </ul>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/customer/devices"><i class="fa fa-cube"></i>My Devices </a>
                        </li>


                        <li>
                        <li><a href="contract.jsp"><i class="fa fa-plus"></i> Contract</a></li>
                        </li>




                        <li>
                            <a href="feedback.jsp"><i class="fa fa-edit"></i>  <span>Feedback</span></a>
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

                    <!-- Page Header -->
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
            $(function () {
                // Handle collapsible menu
                $('.treeview > a').click(function (e) {
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