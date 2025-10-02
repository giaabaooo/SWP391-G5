<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
                <form action="#" method="get" class="sidebar-form">
                    <div class="input-group">
                        <input type="text" name="q" class="form-control" placeholder="Search..."/>
                        <span class="input-group-btn">
                            <button type='submit' id='search-btn' class="btn btn-flat"><i class="fa fa-search"></i></button>
                        </span>
                    </div>
                </form>
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
                    <h2>My Devices</h2>
                    <div class="row">
                        <c:forEach var="device" items="${devices}">
                            <div class="col-md-4">
                                <div class="panel panel-default">
                                    <div class="panel-heading text-center">
                                        <strong>${device.productName}</strong>
                                    </div>
                                    <div class="panel-body text-center">
                                        <img src="${pageContext.request.contextPath}/${device.imageUrl}" 
                                             alt="${device.productName}" 
                                             class="img-responsive img-thumbnail"
                                             style="max-height:200px; margin:auto;">

                                        <p><strong>Serial:</strong> ${device.serialNumber}</p>
                                        <p><strong>Warranty Expiration:</strong>
                                            <fmt:formatDate value="${device.warrantyExpiration}" pattern="dd/MM/yyyy"/>
                                        </p>
                                        <c:if test="${!device.underWarranty}">
                                            <p style="color:red; font-weight:bold;">⚠ This device is out of warranty!</p>
                                        </c:if>

                                        <div class="btn-group" style="margin-top:10px;">
                                            <c:choose>
                                                <c:when test="${device.underWarranty}">
                                                    <button class="btn btn-success">Warranty</button>
                                                    <button class="btn btn-primary">Repair</button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn btn-default" disabled>Warranty</button>
                                                    <button class="btn btn-primary" >Repair</button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
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
