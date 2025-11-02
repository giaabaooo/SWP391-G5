<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ include file="/admin/layout/header.jsp" %>
<%@ include file="/admin/layout/sidebar.jsp" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Customer | Dashboard</title>
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
    </head>
    <body class="skin-black">


        <div class="wrapper row-offcanvas row-offcanvas-left">

            <!-- MAIN CONTENT -->
            <aside class="right-side">
                <section class="content">
                    <!-- Page Header -->
                    <div class="row">
                        <div class="col-md-12">
                            <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;"> Dashboard</h1>
                            <p style="color: #718096; margin-bottom: 2rem;"></p>
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
                <div class="footer-main">Copyright &copy; Customer Management System, 2024</div>
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
        <script src="../js/customer/dashboard.js" type="text/javascript"></script>


    </body>
</html>
<%@ include file="/admin/layout/footer.jsp" %>