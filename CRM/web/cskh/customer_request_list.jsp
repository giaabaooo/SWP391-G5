<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="/jsp/layout/header2.jsp" %>
<%@ include file="/jsp/layout/sidebar2.jsp" %>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Customer Requests</h1>
        <ol class="breadcrumb">
            <li><a href="${pageContext.request.contextPath}/cskh/dashboard"><i class="fa fa-dashboard"></i> Home</a></li>
            <li class="active">Customer Requests</li>
        </ol>
    </section>

    <section class="content">

        <!-- Filter -->
        <div class="box box-primary">
            <div class="box-header with-border">    
            </div>
            <div class="box-body">
                <form method="get" action="${pageContext.request.contextPath}/cskh/customer-request" class="form-inline">
                    <div class="form-group mr-3">
                        <label>Request Type:</label>
                        <select name="type" class="form-control ml-2">
                            <option value="">-- All --</option>
                            <option value="WARRANTY" ${param.type eq 'WARRANTY' ? 'selected' : ''}>Warranty</option>
                            <option value="MAINTENANCE" ${param.type eq 'MAINTENANCE' ? 'selected' : ''}>Maintenance</option>
                            <option value="REPAIR" ${param.type eq 'REPAIR' ? 'selected' : ''}>Repair</option>
                        </select>
                    </div>

                    <div class="form-group mr-3">
                        <label>Status:</label>
                        <select name="status" class="form-control ml-2">
                            <option value="">-- All --</option>
                            <option value="PENDING" ${param.status eq 'PENDING' ? 'selected' : ''}>Pending</option>
                            <option value="TRANSFERRED" ${param.status eq 'TRANSFERRED' ? 'selected' : ''}>Transferred</option>
                            <option value="ASSIGNED" ${param.status eq 'ASSIGNED' ? 'selected' : ''}>Assigned</option>
                            <option value="IN_PROGRESS" ${param.status eq 'IN_PROGRESS' ? 'selected' : ''}>In Progress</option>
                            <option value="COMPLETED" ${param.status eq 'COMPLETED' ? 'selected' : ''}>Completed</option>
                            <option value="CANCELLED" ${param.status eq 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-primary ml-2">
                        <i class="fa fa-filter"></i> Filter
                    </button>
                </form>
            </div>
        </div>

        <!-- List -->
        <div class="box box-success">
            <div class="box-body table-responsive">
                <table class="table table-bordered table-striped">
                    <thead>
                        <tr class="text-center">
                            <th>#</th>
                            <th>Customer</th>
                            <th>Device</th>
                            <th>Title</th>
                            <th>Description</th>
                            <th>Request Type</th>
                            <th>Request Date</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty requests}">
                            <tr>
                                <td colspan="9" class="text-center text-muted">No requests found.</td>
                            </tr>
                        </c:if>

                        <c:forEach var="r" items="${requests}" varStatus="loop">
                            <tr>
                                <td>${(currentPage - 1) * pageSize + loop.index + 1}</td>
                                <td>${r.customer.fullName}</td>
                                <td>${r.device.productName}</td>
                                <td>${r.title}</td>
                                <td>${r.description}</td>
                                <td>${r.request_type}</td>
                                <td><fmt:formatDate value="${r.request_date}" pattern="yyyy-MM-dd HH:mm" /></td>
                                <td>
                                    <span class="label
                                          ${r.status eq 'PENDING' ? 'label-warning' :
                                            r.status eq 'TRANSFERRED' ? 'label-info' :
                                            r.status eq 'COMPLETED' ? 'label-success' :
                                            r.status eq 'CANCELLED' ? 'label-danger' :
                                            'label-default'}">
                                              ${r.status}
                                          </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${r.status eq 'PENDING'}">
                                                <form method="post" action="${pageContext.request.contextPath}/cskh/customer-request" style="display:inline;">
                                                    <input type="hidden" name="action" value="transferToTechManager" />
                                                    <input type="hidden" name="id" value="${r.id}" />
                                                    <button type="submit" class="btn btn-xs btn-primary">
                                                        Transfer
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="btn btn-xs btn-default" disabled>Transferred</button>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <c:if test="${totalPages > 1}">
                        <div class="pagination-controls" style="display: flex; justify-content: center; align-items: center; gap: 6px; margin-top: 20px;">

                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <a class="btn btn-sm btn-default"
                                       href="?page=${currentPage - 1}&type=${type}&status=${status}">
                                        &laquo; Previous
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn btn-sm btn-default" disabled>&laquo; Previous</button>
                                </c:otherwise>
                            </c:choose>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <a href="?page=${i}&type=${type}&status=${status}"
                                   class="btn btn-sm ${i == currentPage ? 'btn-primary' : 'btn-default'}">
                                    ${i}
                                </a>
                            </c:forEach>

                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <a class="btn btn-sm btn-default"
                                       href="?page=${currentPage + 1}&type=${type}&status=${status}">
                                        Next &raquo;
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn btn-sm btn-default" disabled>Next &raquo;</button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                </div>
            </div>
        </section>
    </div>

    <%@ include file="/jsp/layout/footer2.jsp" %>
