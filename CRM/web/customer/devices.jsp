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
                    <h1>My Devices</h1>
                    <form method="get" action="${pageContext.request.contextPath}/customer/devices" class="form-inline mb-3">
                        <input type="text" name="search" value="${param.search}" placeholder="Search by name or serial..." class="form-control" />

                        <select name="brand" class="form-control">
                            <option value="ALL" ${param.brand == 'ALL' ? 'selected' : ''}>All Brands</option>
                            <c:forEach var="b" items="${brands}">
                                <option value="${b}" ${param.brand == b ? 'selected' : ''}>${b}</option>
                            </c:forEach>
                        </select>

                        <select name="warranty" class="form-control">
                            <option value="ALL" ${param.warranty == 'ALL' ? 'selected' : ''}>All</option>
                            <option value="UNDER" ${param.warranty == 'UNDER' ? 'selected' : ''}>Under Warranty</option>
                            <option value="EXPIRED" ${param.warranty == 'EXPIRED' ? 'selected' : ''}>Expired</option>
                        </select>

                        <button type="submit" class="btn btn-primary">Filter</button>
                    </form>
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


                                        <div class="btn-group" style="margin-top:10px;">
                                            <c:choose>
                                                
                                                <c:when test="${device.underWarranty}">
                                                    <button class="btn btn-info" onclick="location.href='${pageContext.request.contextPath}/customer/detailDevice?deviceId=${device.deviceId}'">Detail</button>

                                                    <button class="btn btn-success">Warranty</button>
                                                    <button class="btn btn-primary">Repair</button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn btn-info" onclick="location.href='${pageContext.request.contextPath}/customer/detailDevice?deviceId=${device.deviceId}'">Detail</button>
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
        <!-- Pagination -->
        <div class="row">
            <div class="col-md-12 text-center">
                <ul class="pagination">
                    <!-- Previous -->
                    <c:choose>
                        <c:when test="${currentPage > 1}">
                            <li>
                                <a href="${pageContext.request.contextPath}/customer/devices?page=${currentPage - 1}&search=${fn:escapeXml(search)}&brand=${fn:escapeXml(brand)}&warranty=${fn:escapeXml(warranty)}">Previous</a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="disabled"><a href="#">Previous</a></li>
                            </c:otherwise>
                        </c:choose>

                    <!-- Page numbers -->
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <li class="${i == currentPage ? 'active' : ''}">
                            <a href="${pageContext.request.contextPath}/customer/devices?page=${i}&search=${fn:escapeXml(search)}&brand=${fn:escapeXml(brand)}&warranty=${fn:escapeXml(warranty)}">${i}</a>
                        </li>
                    </c:forEach>

                    <!-- Next -->
                    <c:choose>
                        <c:when test="${currentPage < totalPages}">
                            <li>
                                <a href="${pageContext.request.contextPath}/customer/devices?page=${currentPage + 1}&search=${fn:escapeXml(search)}&brand=${fn:escapeXml(brand)}&warranty=${fn:escapeXml(warranty)}">Next</a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="disabled"><a href="#">Next</a></li>
                            </c:otherwise>
                        </c:choose>
                </ul>
            </div>
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
