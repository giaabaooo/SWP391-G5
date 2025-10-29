<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ include file="/admin/layout/header.jsp" %>
<%@ include file="/admin/layout/sidebar.jsp" %>
<%@ include file="/admin/layout/footer.jsp" %>
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

            <aside class="right-side">
                <section class="content">
                    <div class="row">
                        <div class="col-md-12">
                            <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;"> Revenue Report</h1>
                            <p style="color: #718096; margin-bottom: 2rem;">Overview of sales and financial performance.</p>
                        </div>
                    </div>

                    <div class="row" style="margin-bottom: 20px;">
                        <div class="col-md-12">
                            <div class="input-group" style="width: 300px;">
                                <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                                <input type="text" class="form-control pull-right" id="revenue-date-range" placeholder="Select Date Range">
                                <input type="text" class="form-control pull-right" id="revenue-date-range" placeholder="Select Date Range">
                            </div>
                        </div>
                    </div>

                    <div class="row stats-row">
                        <div class="col-md-3">
                            <div class="stat-card green">
                                <div class="stat-icon">
                                    <i class="fa fa-dollar"></i>
                                </div>
                                <div class="stat-number">$<span id="totalRevenue">125,800.00</span></div>
                                <div class="stat-label">Total Revenue</div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="stat-card info">
                                <div class="stat-icon">
                                    <i class="fa fa-money"></i>
                                </div>
                                <div class="stat-number">$<span id="grossProfit">45,120.50</span></div>
                                <div class="stat-label">From Sell And Buy</div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="stat-card yellow">
                                <div class="stat-icon">
                                    <i class="fa fa-shopping-cart"></i>
                                </div>
                                <div class="stat-number"><span id="totalOrders">482</span></div>
                                <div class="stat-label">From Service</div>
                            </div>
                        </div>
<!--                        <div class="col-md-3">
                            <div class="stat-card red">
                                <div class="stat-icon">
                                    <i class="fa fa-percent"></i>
                                </div>
                                <div class="stat-number"><span id="profitMargin">35.86</span>%</div>
                                <div class="stat-label">Profit Margin</div>
                            </div>
                        </div>-->
                    </div>

                    <div class="row">
                        <div class="col-md-8">
                            <div class="content-card">
                                <div class="card-header">
                                    <h3><i class="fa fa-line-chart"></i> Revenue Trend (Last 30 Days)</h3>
                                </div>
                                <div class="card-body">
                                    <div id="revenue-chart" style="height: 300px;">
                                        
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="content-card">
                                <div class="card-header">
                                    <h3><i class="fa fa-star"></i> Top 5 Selling Items</h3>
                                </div>
                                <div class="card-body">
                                    <ul class="activity-list">
                                        <li class="activity-item">
                                            <div class="activity-content">
                                                <div class="activity-text">**Item Name 1**</div>
                                                <span class="activity-time status-success">Sold: 150 units</span>
                                            </div>
                                        </li>
                                        <li class="activity-item">
                                            <div class="activity-content">
                                                <div class="activity-text">**Item Name 2**</div>
                                                <span class="activity-time status-info">Sold: 120 units</span>
                                            </div>
                                        </li>
                                        <li class="activity-item">
                                            <div class="activity-content">
                                                <div class="activity-text">**Item Name 3**</div>
                                                <span class="activity-time status-warning">Sold: 85 units</span>
                                            </div>
                                        </li>
                                        </ul>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-12">
                            <div class="content-card">
                                <div class="card-header">
                                    <h3><i class="fa fa-table"></i> Detailed Sales Transactions</h3>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table modern-table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Order ID</th>
                                                    <th>Customer Name</th>
                                                    <th>Date</th>
                                                    <th>Total Amount</th>
                                                    <th>Status</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td>ORD-2024-1001</td>
                                                    <td>Nguyễn Văn A</td>
                                                    <td>28/10/2024</td>
                                                    <td>$2,500.00</td>
                                                    <td><span class="status-label status-success">Completed</span></td>
                                                </tr>
                                                <tr>
                                                    <td>ORD-2024-1002</td>
                                                    <td>Trần Thị B</td>
                                                    <td>27/10/2024</td>
                                                    <td>$850.50</td>
                                                    <td><span class="status-label status-success">Completed</span></td>
                                                </tr>
                                                <tr>
                                                    <td>ORD-2024-1003</td>
                                                    <td>Lê Văn C</td>
                                                    <td>27/10/2024</td>
                                                    <td>$1,200.00</td>
                                                    <td><span class="status-label status-warning">Pending</span></td>
                                                </tr>
                                                </tbody>
                                        </table>
                                    </div>
                                    <div class="text-center" style="margin-top: 1rem;">
                                        <a href="allSales.jsp" class="action-btn" style="width: auto; padding: 0.5rem 1.5rem;">View All Sales</a>
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