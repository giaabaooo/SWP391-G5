<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="data.CustomerRequest" %>
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

        <!-- HEADER -->
        <header class="header">
            <a href="dashboard" class="logo" style="color: #ffffff; font-weight: 600; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">${sessionScope.user.role.name}</a>
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

                        <div class="pull-left info">
                            <p>${sessionScope.user.fullName}</p>
                            <a href="#"><i class="fa fa-circle text-success"></i> Online</a>
                        </div>
                    </div>

                    <ul class="sidebar-menu">
                        <li><a href="dashboard"><i class="fa fa-dashboard"></i> Dashboard</a></li>


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
                    <!-- Page Header -->
                    <div class="row">
                        <div class="col-md-12">
                            <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;"> Dashboard</h1>
                            <p style="color: #718096; margin-bottom: 2rem;"></p>
                        </div>
                    </div>

                    <div class="row">                      
                        <div class="col-md-6">
                            <!-- Quick Actions -->
                            <div class="content-card">
                                <div class="card-header">
                                    <h3><i class="fa fa-bolt"></i> Quick Actions</h3>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <a href="../customer/createRequest" class="action-btn">
                                                <i class="fa fa-plus"></i> Create New Request
                                            </a>
                                        </div>
                                        <div class="col-md-6">
                                            <a href="../customer/listRequest" class="action-btn info">
                                                <i class="fa fa-list"></i> List Request
                                            </a>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <a href="../customer/devices" class="action-btn warning">
                                                <i class="fa fa-clipboard"></i> Device
                                            </a>
                                        </div>
                                        <div class="col-md-6">
                                            <a href="../customer/listFeedback" class="action-btn success">
                                                <i class="fa fa-bar-chart"></i> Feedback
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
                                    <h3><i class="fa fa-history"></i> Recent Feedback</h3>
                                </div>
                                <div class="card-body">
                                    <c:choose>
                                        <c:when test="${not empty recentFeedbacks}">
                                            <ul class="activity-list">
                                                <c:forEach var="meta" items="${recentFeedbacks}">
                                                    <li class="activity-item">
                                                        <div class="activity-content">
                                                            <div class="activity-text">
                                                                <strong>${meta.request.title}</strong> <br/>
                                                                <c:if test="${not empty meta.customer_comment}">
                                                                    <span class="text-muted">Customer:</span> ${meta.customer_comment} <br/>
                                                                </c:if>
                                                                <c:if test="${not empty meta.customer_service_response}">
                                                                    <span class="text-muted">CS Response:</span> ${meta.customer_service_response}
                                                                </c:if>
                                                            </div>
                                                            <span class="activity-time text-secondary">
                                                                <fmt:formatDate value="${meta.request.request_date}" pattern="dd/MM/yyyy HH:mm" />
                                                            </span>
                                                        </div>
                                                    </li>
                                                </c:forEach>
                                            </ul>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-center mb-3">No feedback found.</p>
                                        </c:otherwise>
                                    </c:choose>
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
                                    <c:choose>
                                        <c:when test="${not empty pendingRequests}">
                                            <c:forEach var="req" items="${pendingRequests}">
                                                <div class="request-item">
                                                    <div class="row">
                                                        <div class="col-md-8">
                                                            <div class="request-header">Request #${req.id}</div>
                                                            <div class="request-description">${req.title}</div>
                                                            <div class="text-muted small">
                                                                ${req.request_type} | 
                                                                <fmt:formatDate value="${req.request_date}" pattern="dd/MM/yyyy HH:mm" />
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4 text-right">
                                                            <a href="detailRequest?id=${req.id}" class="btn btn-sm btn-outline-primary">View</a>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-center mb-3">No pending requests found.</p>
                                        </c:otherwise>
                                    </c:choose>

                                    <div class="text-center mt-3">
                                        <a href="listRequest" class="btn btn-outline-primary">View All Requests</a>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Right Column: Low Stock Alert -->
<!--                        <div class="col-md-6">
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
                        </div>-->
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