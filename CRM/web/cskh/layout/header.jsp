<%--<%@page contentType="text/html" pageEncoding="UTF-8"%>--%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>CSKH | Dashboard</title>
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
        <!-- Select2 CSS & JS -->
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
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

        <style>
            .pagination-controls {
                margin-top: 16px;
            }

            .pagination-btn {
                border: 1px solid #ddd;
                background-color: white;
                color: #333;
                padding: 6px 12px;
                border-radius: 6px;
                cursor: pointer;
                transition: all 0.2s ease;
            }

            .pagination-btn:hover:not(:disabled) {
                background-color: #007bff;
                color: white;
            }

            .pagination-btn.active {
                background-color: #007bff;
                color: white;
                font-weight: bold;
            }

            .pagination-btn:disabled {
                opacity: 0.5;
                cursor: not-allowed;
            }

            .form-label {
                display: block;
                font-size: 1rem;
                font-weight: 600;
                color: #4a5568;
                margin-bottom: 0.5rem;
            }
            .form-control-modern {
                display: block;
                width: 100%;
                padding: 0.75rem 1rem;
                font-size: 1rem;
                line-height: 1.5;
                color: #2d3748;
                background-color: #ffffff;
                border: 1px solid #e2e8f0;
                border-radius: 0.375rem;
                box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
                transition: all 0.2s ease-in-out;
            }

            .form-control-modern:focus {
                color: #2d3748;
                background-color: #ffffff;
                border-color: #6366f1;
                outline: 0;
                box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.25);
            }
        </style>

    </head>
    <body class="skin-black">

        <!-- HEADER -->
        <header class="header">
            <a href="${pageContext.request.contextPath}/cskh/dashboard" class="logo" style="color: #ffffff; font-weight: 600; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">Customer Service</a>
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
                                    <a href="${pageContext.request.contextPath}/user/profile"><i class="fa fa-user fa-fw pull-right"></i> Profile</a>
                                    <a data-toggle="modal" href="#modal-user-settings"><i class="fa fa-cog fa-fw pull-right"></i> Settings</a>
                                </li>
                                <li class="divider"></li>
                                <li><a href="${pageContext.request.contextPath}/user/logout"><i class="fa fa-ban fa-fw pull-right"></i> Logout</a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </nav>
        </header>