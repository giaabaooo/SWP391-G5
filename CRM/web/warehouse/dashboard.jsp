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

        /* Statistics Cards */
        .stats-row {
            margin-bottom: 2rem;
        }

        .stat-card {
            background: #6366f1;
            border-radius: 12px;
            padding: 1.5rem;
            color: white;
            margin-bottom: 1rem;
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.2);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(99, 102, 241, 0.3);
        }

        .stat-card.red {
            background: #ef4444;
            box-shadow: 0 4px 15px rgba(239, 68, 68, 0.2);
        }

        .stat-card.red:hover {
            box-shadow: 0 8px 25px rgba(239, 68, 68, 0.3);
        }

        .stat-card.yellow {
            background: #f59e0b;
            box-shadow: 0 4px 15px rgba(245, 158, 11, 0.2);
        }

        .stat-card.yellow:hover {
            box-shadow: 0 8px 25px rgba(245, 158, 11, 0.3);
        }

        .stat-card.green {
            background: #10b981;
            box-shadow: 0 4px 15px rgba(16, 185, 129, 0.2);
        }

        .stat-card.green:hover {
            box-shadow: 0 8px 25px rgba(16, 185, 129, 0.3);
        }

        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
            opacity: 0.9;
            text-align: center;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.25rem;
            text-align: center;
        }

        .stat-label {
            font-size: 0.9rem;
            opacity: 0.9;
            font-weight: 500;
            text-align: center;
        }

        /* Content Cards */
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

        /* Low Stock Alert specific styling */
        .low-stock-card .card-body {
            padding: 1.3rem;
        }

        /* Quick Action Buttons */
        .action-btn {
            background: #f0f4ff;
            border: 1px solid #a5b4fc;
            border-radius: 8px;
            padding: 2.3rem 1rem;
            color: #6366f1;
            font-weight: 500;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            width: 100%;
            text-align: center;
        }

        .action-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.15);
            color: #6366f1;
            text-decoration: none;
            background: #f0f4ff;
            border-color: #a5b4fc;
        }

        .action-btn.info {
            background: #ecfeff;
            border: 1px solid #67e8f9;
            color: #0891b2;
        }

        .action-btn.info:hover {
            background: #ecfeff;
            border-color: #67e8f9;
            box-shadow: 0 4px 15px rgba(6, 182, 212, 0.15);
            color: #0891b2;
        }

        .action-btn.warning {
            background: #fffbeb;
            border: 1px solid #fbbf24;
            color: #d97706;
        }

        .action-btn.warning:hover {
            background: #fffbeb;
            border-color: #fbbf24;
            box-shadow: 0 4px 15px rgba(245, 158, 11, 0.15);
            color: #d97706;
        }

        .action-btn.success {
            background: #f0fdf4;
            border: 1px solid #86efac;
            color: #059669;
        }

        .action-btn.success:hover {
            background: #f0fdf4;
            border-color: #86efac;
            box-shadow: 0 4px 15px rgba(16, 185, 129, 0.15);
            color: #059669;
        }

        /* Special styling for bottom action buttons */
        .action-btn[style*="width: auto"] {
            background: #6366f1 !important;
            border: 1px solid #6366f1 !important;
            color: white !important;
        }

        .action-btn[style*="width: auto"]:hover {
            background: #5b5ff5 !important;
            border-color: #5b5ff5 !important;
            color: white !important;
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.3) !important;
        }

        .action-btn.warning[style*="width: auto"] {
            background: #f59e0b !important;
            border: 1px solid #f59e0b !important;
            color: white !important;
        }

        .action-btn.warning[style*="width: auto"]:hover {
            background: #d97706 !important;
            border-color: #d97706 !important;
            color: white !important;
            box-shadow: 0 4px 15px rgba(245, 158, 11, 0.3) !important;
        }

        /* Activity List */
        .activity-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .activity-item {
            display: flex;
            align-items: center;
            padding: 0.75rem 0;
            border-bottom: 1px solid #f1f3f4;
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-checkbox {
            margin-right: 1rem;
        }

        .activity-content {
            flex: 1;
        }

        .activity-text {
            font-size: 0.9rem;
            color: #4a5568;
            margin-bottom: 0.25rem;
        }

        .activity-time {
            font-size: 0.75rem;
            padding: 0.25rem 0.5rem;
            border-radius: 12px;
            color: white;
        }

        /* Request Cards */
        .request-item {
            background: #fafbfc;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 0.75rem;
            transition: all 0.3s ease;
        }

        .request-item:hover {
            border-color: #667eea;
            box-shadow: 0 2px 8px rgba(102, 126, 234, 0.1);
        }

        .request-header {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 0.25rem;
        }

        .request-description {
            font-size: 0.85rem;
            color: #718096;
            margin-bottom: 0.75rem;
        }

        .request-actions {
            display: flex;
            gap: 0.5rem;
        }

        .btn-sm {
            padding: 0.375rem 0.75rem;
            font-size: 0.8rem;
            border-radius: 6px;
            border: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-approve {
            background: #48cab2;
            color: white;
        }

        .btn-approve:hover {
            background: #38a89d;
            transform: translateY(-1px);
        }

        .btn-reject {
            background: #ff6b6b;
            color: white;
        }

        .btn-reject:hover {
            background: #ff5252;
            transform: translateY(-1px);
        }

        /* Table Styles */
        .modern-table {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .modern-table th {
            background: #f8f9fa;
            color: #495057;
            font-weight: 600;
            font-size: 0.85rem;
            padding: 0.75rem;
            border: none;
        }

        .modern-table td {
            padding: 0.75rem;
            border: none;
            border-bottom: 1px solid #f1f3f4;
            font-size: 0.85rem;
            color: #4a5568;
        }

        .modern-table tbody tr:hover {
            background: #f8f9fa;
        }

        /* Status Labels */
        .status-label {
            padding: 0.25rem 0.75rem;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-critical {
            background: #fee2e2;
            color: #dc2626;
        }

        .status-warning {
            background: #fef3c7;
            color: #d97706;
        }

        .status-success {
            background: #d1fae5;
            color: #059669;
        }

        .status-info {
            background: #dbeafe;
            color: #2563eb;
        }

        /* Priority Labels */
        .priority-high {
            background: #fee2e2;
            color: #dc2626;
        }

        .priority-medium {
            background: #fef3c7;
            color: #d97706;
        }

        .priority-low {
            background: #d1fae5;
            color: #059669;
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

            .stat-card {
                margin-bottom: 1rem;
            }

            .stat-number {
                font-size: 1.5rem;
            }

            .stat-icon {
                font-size: 2rem;
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
                    <img src="../img/warehouse-user.png" class="img-circle" alt="User Image" onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iMjAiIGN5PSIyMCIgcj0iMjAiIGZpbGw9IiM2NzdFRUEiLz4KPHN2ZyB4PSI4IiB5PSI4IiB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTEyIDEyQzE0LjIwOTEgMTIgMTYgMTAuMjA5MSAxNiA4QzE2IDUuNzkwODYgMTQuMjA5MSA0IDEyIDRDOS43OTA4NiA0IDggNS43OTA4NiA4IDhDOCAxMC4yMDkxIDkuNzkwODYgMTIgMTIgMTJaIiBmaWxsPSJ3aGl0ZSIvPgo8cGF0aCBkPSJNMTIgMTRDOC42ODYyOSAxNCA2IDE2LjY4NjMgNiAyMEgxOEMxOCAxNi42ODYzIDE1LjMxMzcgMTQgMTIgMTRaIiBmaWxsPSJ3aGl0ZSIvPgo8L3N2Zz4KPC9zdmc+'" />
                </div>
                <div class="pull-left info">
                    <p>${sessionScope.user.fullName}</p>
                    <a href="#"><i class="fa fa-circle text-success"></i> Online</a>
                </div>
            </div>

            <ul class="sidebar-menu">
                <li class="active"><a href="dashboard.jsp"><i class="fa fa-dashboard"></i> Dashboard</a></li>
                
                <!-- Inventory Management -->
                <li class="treeview">
                    <a href="#inventoryMenu" data-toggle="collapse" aria-expanded="false">
                        <i class="fa fa-cubes"></i> <span>Inventory Management</span>
                    </a>
                    <ul class="collapse" id="inventoryMenu">
                        <li><a href="inventory.jsp"><i class="fa fa-list"></i> View Inventory</a></li>
                        <li><a href="../addNewProduct"><i class="fa fa-plus"></i> Add Product</a></li>
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
                                    <a href="../addNewProduct" class="action-btn">
                                        <i class="fa fa-plus"></i> Add New Item
                                    </a>
                                </div>
                                <div class="col-md-6">
                                    <a href="inventory.jsp" class="action-btn info">
                                        <i class="fa fa-list"></i> View Inventory
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
        <div class="footer-main">Copyright &copy; Warehouse Management System, 2024</div>
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

<script>
    $(function() {
        // Initialize iCheck for checkboxes
        $('input[type="checkbox"].flat-grey').iCheck({
            checkboxClass: 'icheckbox_flat-grey'
        });

        // Handle checkbox events
        $('input').on('ifChecked', function(event) {
            $(this).parents('li').addClass("task-done");
        });
        $('input').on('ifUnchecked', function(event) {
            $(this).parents('li').removeClass("task-done");
        });

        // Handle approve/reject buttons
        $('.btn-approve').click(function() {
            var requestId = $(this).closest('.request-item').find('.request-header').text();
            if (confirm('Are you sure you want to approve ' + requestId + '?')) {
                // Add AJAX call to approve request
                $(this).closest('.request-item').fadeOut();
            }
        });

        $('.btn-reject').click(function() {
            var requestId = $(this).closest('.request-item').find('.request-header').text();
            if (confirm('Are you sure you want to reject ' + requestId + '?')) {
                // Add AJAX call to reject request
                $(this).closest('.request-item').fadeOut();
            }
        });

        // Auto-refresh statistics every 30 seconds
        setInterval(function() {
            // You can add AJAX calls here to refresh data
            console.log('Refreshing warehouse data...');
        }, 30000);
    });
</script>

</body>
</html>