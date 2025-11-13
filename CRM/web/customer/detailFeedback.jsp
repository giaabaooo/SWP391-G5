<%-- 
    Document   : detailFeedback
    Created on : Nov 13, 2025, 8:55:12 AM
    Author     : admin
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="data.Feedback" %>

<c:set var="feedback" value="${requestScope.feedback}" />

<!DOCTYPE html>
<html>
    <head>
    <meta charset="UTF-8">
    <title>Customer |  Details</title>
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
    <link href="${pageContext.request.contextPath}/css/warehouse/productDetail.css" rel="stylesheet" type="text/css" />
    <style>
            /* CSS để hiển thị sao */
            .star-display { color: #f5b301; font-size: 1.2em; }
            .star-display .fa-star-o { color: #ddd; }
            .feedback-card {
                background: #fff;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.05);
                margin-bottom: 20px;
            }
            .feedback-card-header {
                padding: 1rem 1.5rem;
                border-bottom: 1px solid #e9ecef;
                background: #f8f9fa;
            }
            .feedback-card-header h4 { margin: 0; }
            .feedback-card-body { padding: 1.5rem; }
            .info-item { margin-bottom: 15px; }
            .info-item strong {
                display: block;
                color: #6c757d;
                font-weight: 600;
                margin-bottom: 5px;
            }
            .info-item span, .info-item div {
                font-size: 1.1em;
            }
            .comment-box {
                background: #f8f9fa;
                border-radius: 5px;
                padding: 15px;
                border: 1px solid #e9ecef;
            }
            /* CSS cho phản hồi của Staff */
            .response-box {
                background: #d1ecf1; /* Màu xanh nhạt */
                border-radius: 5px;
                padding: 15px;
                border: 1px solid #bee5eb;
                color: #0c5460;
            }
        </style>
</head>
    <body class="skin-black">

        <!-- HEADER -->
        <header class="header">
            <a href="dashboard" class="logo" style="color: #ffffff; font-weight: 600; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">${sessionScope.user.role.name}</a>
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
                    <div class="row">
                        <div class="col-md-12">
                            <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">Detail Feedback</h1>
                            <p style="color: #718096; margin-bottom: 2rem;">View detailed information about this feedback</p>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-8 col-md-offset-2"> <%-- Thu nhỏ cho dễ nhìn --%>
                            <c:choose>
                                <c:when test="${not empty feedback}">
                                    <!-- 1. Thẻ Feedback của bạn -->
                                    <div class="feedback-card">
                                        <div class="feedback-card-header">
                                            <h4><i class="fa fa-comment-o"></i> Feedback</h4>
                                        </div>
                                        <div class="feedback-card-body">
                                            <div class="info-item">
                                                <strong>Rating:</strong>
                                                <span class="star-display">
                                                    <c:forEach begin="1" end="5" var="i">
                                                        <i class="fa ${i <= feedback.rating ? 'fa-star' : 'fa-star-o'}"></i>
                                                    </c:forEach>
                                                </span>
                                            </div>
                                            <div class="info-item">
                                                <strong>Your Feedback</strong>
                                                <div class="comment-box">
                                                    <c:out value="${feedback.comment}"/>
                                                </div>
                                            </div>
                                            
                                        </div>
                                    </div>

                                    <!-- 2. Thẻ Phản hồi của Staff -->
                                    <div class="feedback-card">
                                        <div class="feedback-card-header">
                                            <h4><i class="fa fa-reply"></i> Staff Response</h4>
                                        </div>
                                        <div class="feedback-card-body">
                                            <c:choose>
                                                <c:when test="${not empty feedback.customerServiceResponse}">
                                                    <div class="info-item">
                                                        <strong>Message from Support Team:</strong>
                                                        <div class="response-box">
                                                            <c:out value="${feedback.customerServiceResponse}"/>
                                                        </div>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <p class="text-muted">No response from staff yet.</p>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    
                                    <!-- 3. Thông tin Request liên quan -->
                                    <div class="feedback-card">
                                        <div class="feedback-card-header">
                                            <h4><i class="fa fa-link"></i> Related Request</h4>
                                        </div>
                                        <div class="feedback-card-body">
                                            <div class="info-item">
                                                <strong>Request Title:</strong>
                                                <span><c:out value="${feedback.title}"/></span>
                                            </div>
                                            <div class="info-item">
                                                <strong>Device:</strong>
                                                <span><c:out value="${feedback.productName}"/></span>
                                            </div>
                                            <div class="info-item">
                                                <strong>Request Type:</strong>
                                                <span><c:out value="${feedback.requestType}"/></span>
                                            </div>
                                            <div class="info-item">
                                                <strong>Issue Description:</strong>
                                                <span><c:out value="${feedback.description}"/></span>
                                            </div>
                                        </div>
                                    </div>

                                    <a href="${pageContext.request.contextPath}/customer/listFeedback" class="btn btn-default" style="margin-top: 10px;">
                                        <i class="fa fa-arrow-left"></i> Back to List
                                    </a>
                                    
                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-danger">Feedback details not found.</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </section>
                <div class="footer-main">Copyright &copy; Customer Management System, 2024</div>
            </aside>
        </div>

        
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-ui-1.10.3.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/daterangepicker.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/chart.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/icheck.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/fullcalendar.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/app.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/dashboard.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/customer/productDetail.js" type="text/javascript"></script>
    </body>
</html>
