<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ include file="/techmanager/layout/header.jsp" %>
<%@ include file="/techmanager/layout/sidebar.jsp" %>
<!DOCTYPE html>
<html>
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
                                    <i class="fa fa-users"></i>
                                </div>
                                <div class="stat-number">${tech}</div>
                                <div class="stat-label">Technician</div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="stat-card">
                                <div class="stat-icon">
                                    <i class="fa fa-tasks"></i>
                                </div>
                                <div class="stat-number">${total}</div>
                                <div class="stat-label">Total request</div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="stat-card yellow">
                                <div class="stat-icon">
                                    <i class="fa fa-clock-o"></i>
                                </div>
                                <div class="stat-number">${pending}</div>
                                <div class="stat-label">Unprocessed Requests</div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="stat-card green">
                                <div class="stat-icon">
                                    <i class="fa fa-check-circle"></i>
                                </div>
                                <div class="stat-number">${finish}</div>
                                <div class="stat-label">Processed Requests</div>
                            </div>
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
                                            <a href="../techmanager/technician" class="action-btn">
                                                <i class="fa fa-list"></i> View List Technician
                                            </a>
                                        </div>
                                        <div class="col-md-6">
                                            <a href="../techmanager/request" class="action-btn info">
                                                <i class="fa fa-list"></i> View List Request
                                            </a>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <a href="../techmanager/task" class="action-btn">
                                                <i class="fa fa-list"></i> View List Task
                                            </a>
                                        </div>
                                        <div class="col-md-6">
                                            <a href="../techmanager/request?action=assignTask" class="action-btn success">
                                                <i class="fa fa-angle-right"></i> Assign Task
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>


                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="content-card low-stock-card">
                                <div class="card-header">
                                    <h3><i class="fa fa-exclamation-triangle"></i> List Technician</h3>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table modern-table">
                                            <thead>
                                                <tr>
                                                    <th>Full Name</th>
                                                    <th>Email</th>
                                                    <th>Phone</th>
                                                    <th>Status</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="u" items="${techList}" varStatus="st">
                                                    <tr>
                                                        <td>${u.fullName}</td>
                                                        <td>${u.email}</td>
                                                        <td>${u.phone}</td>
                                                        <td>
                                                            <span class="status-label ${u.isActive?'status-success':'status-warning'}">
                                                                ${u.isActive?'Active':'Inactive'}
                                                            </span>
                                                        </td>
                                                    </tr>
                                                </c:forEach>

                                            </tbody>
                                        </table>
                                    </div>
                                    <div class="text-center" style="margin-top: 1rem;">
                                        
                                        <a href="technician" class="action-btn warning" style="width: auto; padding: 0.5rem 1.5rem;">View List Technician</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Left Column: Pending Requests -->
                        <div class="col-md-6">
                            <div class="content-card">
                                <div class="card-header">
                                    <h3><i class="fa fa-clock-o"></i> Transferred Requests</h3>
                                </div>
                                <div class="card-body">
                                    <c:forEach var="u" items="${pendingList}">
                                        <div class="request-item">
                                            <div class="row">
                                                <div class="col-md-8">
                                                    <div class="request-header">Request #${u.id}</div>
                                                    <div class="request-description">${u.request_type} " ${u.device.productName} " for ${u.customer.fullName}</div>
                                                    <span class="status-label priority-low">${u.request_date}</span>
                                                </div>
                                                <div class="col-md-4 text-right">
                                                    <div class="request-actions">


                                                        <a href="${pageContext.request.contextPath}/techmanager/request?action=detail&id=${u.id}" class="btn-sm btn-approve">
                                                            Detail
                                                        </a>
                                                        <c:if test="${u.status ne 'REJECTED'}">
                                                            <a href="${pageContext.request.contextPath}/techmanager/request?action=reject&id=${u.id}" class="btn-sm btn-reject">
                                                                Reject
                                                            </a>
                                                            <c:if test="${u.status == 'PENDING'}">
                                                                <a href="${pageContext.request.contextPath}/cskh/user?action=delete&id=${u.id}" class="btn-sm btn-success">
                                                                    Assign
                                                                </a>
                                                            </c:if>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>

                                    <div class="text-center" style="margin-top: 1rem;">
                                        <a href="request" class="action-btn" style="width: auto; padding: 0.5rem 1.5rem;">View All Requests</a>
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



    </body>
</html>
<%@ include file="/techmanager/layout/footer.jsp" %>