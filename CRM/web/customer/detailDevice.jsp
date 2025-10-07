<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>My Devices</title>
        <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
        <meta name="description" content="Developed By M Abdur Rokib Promy">
        <meta name="keywords" content="Admin, Bootstrap 3, Template, Theme, Responsive">
        <link href="../css/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <link href="../css/font-awesome.min.css" rel="stylesheet" type="text/css" />
        <link href="../css/admin/style.css" rel="stylesheet" type="text/css" />
        <link href="../css/ionicons.min.css" rel="stylesheet" type="text/css" />
        <link href="../css/morris/morris.css" rel="stylesheet" type="text/css" />
        <link href="../css/jvectormap/jquery-jvectormap-1.2.2.css" rel="stylesheet" type="text/css" />
        <link href="../css/datepicker/datepicker3.css" rel="stylesheet" type="text/css" />
        <link href="../css/daterangepicker/daterangepicker-bs3.css" rel="stylesheet" type="text/css" />
        <link href="css/iCheck/all.css" rel="stylesheet" type="text/css" />
        <link href='http://fonts.googleapis.com/css?family=Lato' rel='stylesheet' type='text/css'>
        <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="skin-black">

        <header class="header">
            <a href="dashboard.jsp" class="logo">${sessionScope.user.role.name}</a>
            <nav class="navbar navbar-static-top" role="navigation">

            </nav>
        </header>

        <div class="wrapper row-offcanvas row-offcanvas-left">
            <!-- SIDEBAR -->
            <aside class="left-side sidebar-offcanvas">
                <section class="sidebar">
                    <div class="user-panel">
                        <div class="pull-left info">
                            <p>${sessionScope.user.fullName}</p>
                        </div>
                    </div>
                    <ul class="sidebar-menu">
                        <li><a href="dashboard.jsp"><span>Home</span></a></li>
                        <li class="treeview">
                            <a href="#ticketsMenu" data-toggle="collapse" aria-expanded="false style="text-decoration:none;">
                                <span>Tickets</span>

                            </a>
                            <ul class="collapse" id="ticketsMenu">
                                <li><a href="ticket_create.jsp"> Create Ticket</a></li>
                                <li><a href="ticket_list.jsp"> View List Ticket</a></li>
                                <li><a href="ticket_status.jsp"> Track Status</a></li>
                            </ul>
                        </li>
                        <li class="active"><a href="${pageContext.request.contextPath}/customer/devices"><span>My Devices</span></a></li>
                        <li><a href="profile.jsp"><span>My Profile</span></a></li>
                        <li><a href="payments.jsp"><span>Payments</span></a></li>
                        <li><a href="feedback.jsp"><span>Feedback</span></a></li>
                        <li><a href="logout">Sign Out</a></li>
                    </ul>
                </section>
            </aside>

            <!-- MAIN CONTENT -->
    <aside class="right-side">
        <section class="content">
            <h1>Device Detail</h1>

            <c:if test="${not empty device}">
                <div class="panel panel-default" style="max-width:500px; margin:auto;">
                    <div class="panel-heading text-center">
                        <strong>${device.productName}</strong>
                    </div>
                    <div class="panel-body text-center">
                        <img src="${pageContext.request.contextPath}/${device.imageUrl}" 
                             alt="${device.productName}" 
                             class="img-responsive img-thumbnail"
                             style="max-height:300px; margin:auto;">

                        <p><strong>Serial:</strong> ${device.serialNumber}</p>
                        <p><strong>Brand:</strong> ${device.brandName}</p>
                        <p><strong>Status:</strong> ${device.status}</p>
                        <p><strong>Warranty Expiration:</strong> 
                            <fmt:formatDate value="${device.warrantyExpiration}" pattern="dd/MM/yyyy"/>
                        </p>

                        <p>
                            <a href="${pageContext.request.contextPath}/customer/devices" class="btn btn-primary">Back</a>
                        </p>
                    </div>
                </div>
            </c:if>

            <c:if test="${empty device}">
                <p class="text-center text-danger">Device not found.</p>
            </c:if>
        </section>
    </aside>
        </div>
        


        <script src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js"></script>

        <script src="js/jquery-ui-1.10.3.min.js" type="text/javascript"></script>
        <script src="js/bootstrap.min.js" type="text/javascript"></script>
        <script src="js/daterangepicker.js" type="text/javascript"></script>
        <script src="js/chart.js" type="text/javascript"></script>
        <script src="js/icheck.min.js" type="text/javascript"></script>
        <script src="js/fullcalendar.js" type="text/javascript"></script>
        <script src="js/app.js" type="text/javascript"></script>
        <script src="js/dashboard.js" type="text/javascript"></script>
        <!-- Bootstrap 5 Bundle JS (gồm cả Popper.js) -->
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    </body>
</html>
