<%-- 
    Document   : detailContract
    Created on : Nov 8, 2025, 5:34:37 PM
    Author     : admin
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="data.Product" %>
<%@ page import="data.Contract" %>
<%@ page import="data.ContractItem" %>
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
            .contract-details p {
            font-size: 16px;
            margin-bottom: 12px;
        }
            .contract-details p strong {
                display: inline-block;
                width: 150px;
                color: #555;
            }
            .contract-details .badge {
            font-size: 16px;
            padding: 6px 12px;
            background-color: #3c8dbc;
            color: white;
        }

        /* ======= THÊM 8 DÒNG SAU VÀO ĐÂY ======== */
        /* Fix lỗi CSS bị xô lệch do dùng chung file productList.css */
       .contract-item-table {
            width: 100%;
            border-collapse: collapse; /* Gộp viền lại cho đẹp */
            margin-bottom: 20px;
            font-size: 14px;
        }
        
        /* Định dạng cho header (th) và ô (td) */
        .contract-item-table th,
        .contract-item-table td {
            border: 1px solid #ddd; /* Viền mỏng màu xám */
            padding: 10px 12px;
            text-align: left;
            vertical-align: top; /* Căn chữ lên trên */
        }
        
        /* Định dạng riêng cho hàng tiêu đề */
        .contract-item-table thead th {
            background-color: #f4f4f4; /* Màu nền xám nhạt */
            font-weight: 600; /* In đậm (giống theme) */
            color: #333;
        }
        
        /* Tùy chọn: Thêm sọc vằn (zebra-striping) cho dễ đọc */
        .contract-item-table tbody tr:nth-child(even) {
            background-color: #f9f9f9;
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
                            <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">Contract Detail</h1>
                            <p style="color: #718096; margin-bottom: 1rem;">View full details for contract: <strong>${contract.contractCode}</strong></p>
                        </div>
                    </div>
                    
                    

                    <div class="row">
                        <div class="col-md-12">
                            <div class="content-card">
                                <div class="card-header">
                                    <h3><i class="fa fa-file-text-o"></i> Contract Summary</h3>
                                </div>
                                <div class="card-body">
                                    <c:if test="${not empty contract}">
                                        <div class="contract-details">
                                            <p><strong>Contract Code:</strong> <span class="badge">${contract.contractCode}</span></p>
                                            <p><strong>Customer:</strong> ${contract.customerName}</p>
                                            <p><strong>Contract Date:</strong> <fmt:formatDate value="${contract.contractDate}" pattern="yyyy-MM-dd" /></p>
                                            
                                            <%-- Thông tin này có từ getContractDetail, không có ở list --%>
                                            <p><strong>Total Amount:</strong> 
                                                <fmt:formatNumber value="${contract.totalAmount}" type="currency" currencySymbol="$" maxFractionDigits="2" />
                                            </p>
                                            
                                            <%-- Thông tin này có từ getContractDetail, không có ở list --%>
                                            <p><strong>Description:</strong></p>
                                            <p>${not empty contract.description ? contract.description : 'N/A'}</p>
                                        </div>
                                    </c:if>
                                    <c:if test="${empty contract}">
                                        <div class="alert alert-danger">Contract details not found.</div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-12">
                            <div class="content-card">
                                <div class="card-header">
                                    <h3><i class="fa fa-cubes"></i> Devices in this Contract</h3>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="contract-item-table">
                                            <thead>
                                                <tr>
                                                    <th>No</th>
                                                    <th>Product Name</th>
                                                    <th>Category</th>
                                                    <th>Brand</th>
                                                    <th>Quantity</th>
                                                    <th>Unit Price</th>
                                                    <th>Warranty</th>
                                                    <th>Maintenance</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="item" items="${items}" varStatus="loop">
                                                    <tr>
                                                        <td>${loop.count}</td>
                                                        <td><strong>${item.productName}</strong></td>
                                                        <td>${item.categoryName}</td>
                                                        <td>${item.brandName}</td>
                                                        <td>${item.quantity}</td>
                                                        <td><fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="$" maxFractionDigits="2" /></td>
                                                        
                                                        <%-- Đây là các thông tin chi tiết --%>
                                                        <td>${item.warrantyMonths} months</td>
                                                        <td>${item.maintenanceMonths} months</td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty items}">
                                                    <tr>
                                                        <td colspan="8">No items found for this contract.</td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                        <div class="row" style="margin-bottom: 15px;">
                        <div class="col-md-12">
                            <a href="${pageContext.request.contextPath}/customer/contract" class="btn btn-default">
                                <i class="fa fa-arrow-left"></i> Back to Contract List
                            </a>
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
