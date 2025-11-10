<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="/cskh/layout/header.jsp" %>
<%@ include file="/cskh/layout/sidebar.jsp" %>

<div class="content-wrapper" style="background: #ffffff;">
    <section class="content-header">
        <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">CSKH Dashboard</h1>
        <ol class="breadcrumb" style="background: none; padding: 0; margin-bottom: 2rem;">
            <li><a href="${pageContext.request.contextPath}/cskh/dashboard"><i class="fa fa-dashboard"></i> Home</a></li>
            <li class="active">Dashboard</li>
        </ol>
    </section>

    <section class="content">

        <div class="row">
            <div class="col-md-3">
                <a href="${pageContext.request.contextPath}/cskh/customer-request?status=PENDING" style="text-decoration: none;">
                    <div class="stat-card red">
                        <div class="stat-icon"><i class="fa fa-clock-o"></i></div>
                        <div class="stat-number">${pendingRequestsCount}</div>
                        <div class="stat-label">New Pending Requests</div>
                    </div>
                </a>
            </div>
            <div class="col-md-3">
                <a href="${pageContext.request.contextPath}/cskh/feedback?responseStatus=not_responded" style="text-decoration: none;">
                    <div class="stat-card yellow">
                        <div class="stat-icon"><i class="fa fa-comments-o"></i></div>
                        <div class="stat-number">${newFeedbacksCount}</div>
                        <div class="stat-label">New Feedbacks to Respond</div>
                    </div>
                </a>
            </div>
            <div class="col-md-3">
                <a href="${pageContext.request.contextPath}/cskh/customer?status=active" style="text-decoration: none;">
                    <div class="stat-card">
                        <div class="stat-icon"><i class="fa fa-users"></i></div>
                        <div class="stat-number">${activeCustomerCount}</div>
                        <div class="stat-label">Active Customers</div>
                    </div>
                </a>
            </div>
            <div class="col-md-3">
                <a href="${pageContext.request.contextPath}/cskh/contract" style="text-decoration: none;">
                    <div class="stat-card green">
                        <div class="stat-icon"><i class="fa fa-file-text-o"></i></div>
                        <div class="stat-number">${activeContractCount}</div>
                        <div class="stat-label">Active Contracts</div>
                    </div>
                </a>
            </div>
        </div>

        <div class="row">

            <div class="col-md-8">
                <div class="content-card">
                    <div class="card-header">
                        <h3><i class="fa fa-bar-chart"></i> New Requests (Last 7 Days)</h3>
                    </div>
                    <div class="card-body">
                        <canvas id="requestChart" width="100%" height="330"></canvas>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="content-card">
                    <div class="card-header">
                        <h3><i class="fa fa-comments-o"></i> Recent Feedbacks (To Respond)</h3>
                    </div>
                    <div class="card-body" style="padding: 0 1.5rem;">
                        <ul class="activity-list">
                            <c:if test="${empty recentFeedbacks}">
                                <li class="activity-item" style="text-align: center; color: #718096; padding: 2rem 0;">
                                    <i class="fa fa-check-circle" style="font-size: 2rem; display: block; margin-bottom: 0.5rem; color: #10b981;"></i>
                                    All caught up! No new feedback.
                                </li>
                            </c:if>
                            <c:forEach var="fb" items="${recentFeedbacks}">
                                <li class="activity-item">
                                    <div class="activity-content">
                                        <div class="activity-text">
                                            <strong>${fb.customerName}</strong> rated <strong style="color: #f59e0b;">${fb.rating} <i class="fa fa-star"></i></strong>
                                        </div>
                                        <span style="color: #718096; font-size: 13px;">
                                            <c:out value="${fn:substring(fb.comment, 0, 50)}..."/>
                                        </span>
                                        <a href="${pageContext.request.contextPath}/cskh/customer-request/detail?id=${fb.requestId}" 
                                           class="btn btn-xs btn-primary pull-right" style="margin-top: -5px;">
                                            <i class="fa fa-reply"></i> Respond
                                        </a>
                                    </div>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
            </div>

        </div>

        <div class="row">
            <div class="col-md-12">
                <div class="content-card">
                    <div class="card-header">
                        <h3><i class="fa fa-tasks"></i> Newest Pending Requests</h3>
                    </div>
                    <div class="card-body" style="padding: 0;">
                        <div class="table-responsive">
                            <table class="table modern-table table-hover"> 
                                <thead>
                                    <tr>
                                        <th>#ID</th>
                                        <th>Customer</th>
                                        <th>Title</th>
                                        <th>Type</th>
                                        <th>Priority</th>
                                        <th>Date</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:if test="${empty recentPendingRequests}">
                                        <tr>
                                            <td colspan="7" style="text-align: center; padding: 2rem; color: #718096;">
                                                <i class="fa fa-inbox" style="font-size: 2rem; display: block; margin-bottom: 0.5rem;"></i> No pending requests.
                                            </td>
                                        </tr>
                                    </c:if>
                                    <c:forEach var="r" items="${recentPendingRequests}">
                                        <tr>
                                            <td>#${r.id}</td>
                                            <td>${r.customer.fullName}</td>
                                            <td>${r.title}</td>
                                            <td>
                                                <span class="status-label ${r.request_type eq 'REPAIR' ? 'status-warning' : r.request_type eq 'WARRANTY' ? 'status-info' : r.request_type eq 'MAINTENANCE' ? 'status-success' : ''}">
                                                    ${r.request_type}
                                                </span>
                                            </td>
                                            <td>
                                                <span class="status-label ${r.priority eq 'URGENT' ? 'status-critical' : r.priority eq 'HIGH' ? 'status-warning' : r.priority eq 'MEDIUM' ? 'status-info' : r.priority eq 'LOW' ? 'status-success' : ''}">
                                                    <c:out value="${r.priority}" default="N/A"/>
                                                </span>
                                            </td>
                                            <td><fmt:formatDate value="${r.request_date}" pattern="yyyy-MM-dd"/></td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/cskh/customer-request/detail?id=${r.id}" 
                                                   class="btn btn-sm btn-primary">
                                                    <i class="fa fa-share"></i> View/Transfer
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

    </section>
</div>

<script type="text/javascript">
    $(function () {
        "use strict";

        var chartLabels = [<c:forEach var='label' items='${chartLabels}'>"${label}"<c:if test='${!loop.last}'>,</c:if></c:forEach>];
                var chartData = [<c:forEach var='data' items='${chartData}'>${data}<c:if test='${!loop.last}'>,</c:if></c:forEach>];

        var data = {
            labels: chartLabels,
            datasets: [
                {
                    label: "New Requests",
                    fillColor: "rgba(99, 102, 241, 0.2)",
                    strokeColor: "rgba(99, 102, 241, 1)",
                    pointColor: "rgba(99, 102, 241, 1)",
                    pointStrokeColor: "#fff",
                    pointHighlightFill: "#fff",
                    pointHighlightStroke: "rgba(99, 102, 241, 1)",
                    data: chartData
                }
            ]
        };

        var ctx = document.getElementById("requestChart").getContext("2d");
        new Chart(ctx).Line(data, {
            responsive: true,
            maintainAspectRatio: false,
            scaleGridLineColor: "rgba(0,0,0,.05)"
        });
    });
        </script>

<%@ include file="/cskh/layout/footer.jsp" %>