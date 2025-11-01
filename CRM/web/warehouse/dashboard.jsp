<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Warehouse Staff | Dashboard</title>
    <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
    <meta name="description" content="Warehouse Management System">
    <meta name="keywords" content="Warehouse, Inventory, Management">
    <!-- bootstrap 3.0.2 -->
    <link href="../css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="../css/ionicons.min.css" rel="stylesheet" type="text/css" />
    <link href="../css/morris/morris.css" rel="stylesheet" type="text/css" />
    <link href="../css/jvectormap/jquery-jvectormap-1.2.2.css" rel="stylesheet" type="text/css" />
    <link href="../css/daterangepicker/daterangepicker-bs3.css" rel="stylesheet" type="text/css" />
    <link href="../css/iCheck/all.css" rel="stylesheet" type="text/css" />
    <link href='http://fonts.googleapis.com/css?family=Lato' rel='stylesheet' type='text/css'>
    <link href="../css/admin/style.css" rel="stylesheet" type="text/css" />
    <link href="../css/warehouse/dashboard.css" rel="stylesheet" type="text/css" />
    <link href="../css/warehouse/responsive.css" rel="stylesheet" type="text/css" />
</head>
<body class="skin-black">

<!-- HEADER -->
<header class="header">
    <a href="dashboard.jsp" class="logo" style="color: #ffffff; font-weight: 600; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">Warehouse Staff</a>
    <nav class="navbar navbar-static-top" role="navigation">
        <a href="#" class="navbar-btn sidebar-toggle" data-toggle="offcanvas" role="button">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </a>
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
                        <li><a href="../user/logout"><i class="fa fa-ban fa-fw pull-right"></i> Logout</a></li>
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
                
                <!-- Product -->
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
                    <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">Warehouse Dashboard</h1>
                    <p style="color: #718096; margin-bottom: 2rem;">Monitor inventory, manage requests, and track warehouse activities</p>
                </div>
            </div>

            <!-- Statistics Cards -->
            <div class="row stats-row">
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fa fa-cubes"></i>
                        </div>
                        <div class="stat-number">1,247</div>
                        <div class="stat-label">Total Items</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card red">
                        <div class="stat-icon">
                            <i class="fa fa-exclamation-triangle"></i>
                        </div>
                        <div class="stat-number">23</div>
                        <div class="stat-label">Low Stock Items</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card yellow">
                        <div class="stat-icon">
                            <i class="fa fa-clock-o"></i>
                        </div>
                        <div class="stat-number">8</div>
                        <div class="stat-label">Pending Requests</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card green">
                        <div class="stat-icon">
                            <i class="fa fa-check-circle"></i>
                        </div>
                        <div class="stat-number">156</div>
                        <div class="stat-label">Completed Today</div>
                    </div>
                </div>
            </div>

            <!-- Quick Actions and Pending Requests -->
            <div class="row">
                <!-- Left Column: Quick Actions + Pending Requests -->
                <div class="col-md-6">
                    <!-- Quick Actions -->
                    <div class="content-card">
                        <div class="card-header">
                            <h3><i class="fa fa-bolt"></i> Quick Actions</h3>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <a href="../warestaff/addNewProduct" class="action-btn">
                                        <i class="fa fa-plus"></i> Add New Item
                                    </a>
                                </div>
                                <div class="col-md-6">
                                    <a href="../warestaff/viewListProduct" class="action-btn info">
                                        <i class="fa fa-list"></i> View List Product
                                    </a>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <a href="requests.jsp" class="action-btn warning">
                                        <i class="fa fa-clipboard"></i> Manage Requests
                                    </a>
                                </div>
                                <div class="col-md-6">
                                    <a href="reports.jsp" class="action-btn success">
                                        <i class="fa fa-bar-chart"></i> Generate Reports
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

                <!-- Right Column: Recent Activities -->
                <div class="col-md-6">
                    <div class="content-card">
                        <div class="card-header">
                            <h3><i class="fa fa-history"></i> Recent Activities</h3>
                        </div>
                        <div class="card-body">
                            <ul class="activity-list">
                                <li class="activity-item">
                                    <div class="activity-checkbox">
                                        <input type="checkbox" class="flat-grey list-child" checked/>
                                    </div>
                                    <div class="activity-content">
                                        <div class="activity-text">Added 50 units of "Dell XPS 13"</div>
                                        <span class="activity-time status-success">2 hours ago</span>
                                    </div>
                                </li>
                                <li class="activity-item">
                                    <div class="activity-checkbox">
                                        <input type="checkbox" class="flat-grey list-child" checked/>
                                    </div>
                                    <div class="activity-content">
                                        <div class="activity-text">Removed 5 units of "iPhone 15" for repair</div>
                                        <span class="activity-time status-info">4 hours ago</span>
                                    </div>
                                </li>
                                <li class="activity-item">
                                    <div class="activity-checkbox">
                                        <input type="checkbox" class="flat-grey list-child"/>
                                    </div>
                                    <div class="activity-content">
                                        <div class="activity-text">Approved inventory request #IR-2024-001</div>
                                        <span class="activity-time status-warning">6 hours ago</span>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Pending Requests and Low Stock Alert -->
            <div class="row">
                <!-- Left Column: Pending Requests -->
                <div class="col-md-6">
                    <div class="content-card">
                        <div class="card-header">
                            <h3><i class="fa fa-clock-o"></i> Pending Requests</h3>
                        </div>
                        <div class="card-body">
                            <div class="request-item">
                                <div class="row">
                                    <div class="col-md-8">
                                        <div class="request-header">Request #IR-2024-008</div>
                                        <div class="request-description">Technician needs 2x "RAM 16GB DDR4"</div>
                                        <span class="status-label priority-high">High Priority</span>
                                    </div>
                                    <div class="col-md-4 text-right">
                                        <div class="request-actions">
                                            <button class="btn-sm btn-approve">Approve</button>
                                            <button class="btn-sm btn-reject">Reject</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="request-item">
                                <div class="row">
                                    <div class="col-md-8">
                                        <div class="request-header">Request #IR-2024-009</div>
                                        <div class="request-description">Customer service needs 1x "iPhone Screen"</div>
                                        <span class="status-label priority-medium">Medium Priority</span>
                                    </div>
                                    <div class="col-md-4 text-right">
                                        <div class="request-actions">
                                            <button class="btn-sm btn-approve">Approve</button>
                                            <button class="btn-sm btn-reject">Reject</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="request-item">
                                <div class="row">
                                    <div class="col-md-8">
                                        <div class="request-header">Request #IR-2024-010</div>
                                        <div class="request-description">Repair center needs 3x "Laptop Battery"</div>
                                        <span class="status-label priority-low">Low Priority</span>
                                    </div>
                                    <div class="col-md-4 text-right">
                                        <div class="request-actions">
                                            <button class="btn-sm btn-approve">Approve</button>
                                            <button class="btn-sm btn-reject">Reject</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="text-center" style="margin-top: 1rem;">
                                <a href="requests.jsp" class="action-btn" style="width: auto; padding: 0.5rem 1.5rem;">View All Requests</a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Column: Low Stock Alert -->
                <div class="col-md-6">
                    <div class="content-card low-stock-card">
                        <div class="card-header">
                            <h3><i class="fa fa-exclamation-triangle"></i> Low Stock Alert</h3>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table modern-table">
                                    <thead>
                                        <tr>
                                            <th>Item Name</th>
                                            <th>Current</th>
                                            <th>Min</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>Dell XPS 13</td>
                                            <td>3</td>
                                            <td>10</td>
                                            <td><span class="status-label status-critical">Critical</span></td>
                                        </tr>
                                        <tr>
                                            <td>iPhone 15 Screen</td>
                                            <td>7</td>
                                            <td>15</td>
                                            <td><span class="status-label status-warning">Low</span></td>
                                        </tr>
                                        <tr>
                                            <td>RAM 16GB DDR4</td>
                                            <td>12</td>
                                            <td>20</td>
                                            <td><span class="status-label status-warning">Low</span></td>
                                        </tr>
                                        <tr>
                                            <td>MacBook Pro M3</td>
                                            <td>2</td>
                                            <td>8</td>
                                            <td><span class="status-label status-critical">Critical</span></td>
                                        </tr>
                                        <tr>
                                            <td>Samsung Galaxy S24</td>
                                            <td>5</td>
                                            <td>12</td>
                                            <td><span class="status-label status-warning">Low</span></td>
                                        </tr>
                                        <tr>
                                            <td>NVIDIA RTX 4090</td>
                                            <td>1</td>
                                            <td>5</td>
                                            <td><span class="status-label status-critical">Critical</span></td>
                                        </tr>
                                        <tr>
                                            <td>iPad Pro 12.9"</td>
                                            <td>4</td>
                                            <td>10</td>
                                            <td><span class="status-label status-warning">Low</span></td>
                                        </tr>
                                        <tr>
                                            <td>AirPods Pro 2nd Gen</td>
                                            <td>6</td>
                                            <td>15</td>
                                            <td><span class="status-label status-warning">Low</span></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="text-center" style="margin-top: 1rem;">
                                <button class="action-btn warning" style="width: auto; padding: 0.5rem 1.5rem;">Reorder Items</button>
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
<script src="../js/jquery-ui-1.10.3.min.js" type="text/javascript"></script>
<script src="../js/bootstrap.min.js" type="text/javascript"></script>
<script src="../js/daterangepicker.js" type="text/javascript"></script>
<script src="../js/chart.js" type="text/javascript"></script>
<script src="../js/icheck.min.js" type="text/javascript"></script>
<script src="../js/fullcalendar.js" type="text/javascript"></script>
<script src="../js/app.js" type="text/javascript"></script>
<script src="../js/dashboard.js" type="text/javascript"></script>
<script src="../js/warehouse/dashboard.js" type="text/javascript"></script>

</body>
</html>