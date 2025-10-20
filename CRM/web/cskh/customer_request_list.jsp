<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="/jsp/layout/header2.jsp" %>
<%@ include file="/jsp/layout/sidebar2.jsp" %>

<style>
    :root {
        --primary-color: #4a90e2;
        --success-color: #38a169;
        --danger-color: #e53e3e;
        --warning-color: #d69e2e;
        --info-color: #3182ce;
        --default-color: #6b7280;
        --text-color: #2d3748;
        --muted-color: #718096;
        --background-color: #f7fafc;
        --border-color: #e2e8f0;
        --hover-color: #3b82f6;
        --disabled-color: #cbd5e0;
        --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }

    .content-wrapper {
        background-color: var(--background-color);
        padding: 24px;
        min-height: 100vh;
    }

    .content-header h1 {
        color: var(--text-color);
        font-weight: 700;
        font-size: 2.25rem;
        margin-bottom: 0.75rem;
        letter-spacing: -0.025em;
    }

    .breadcrumb {
        background-color: transparent;
        padding: 0;
        margin-bottom: 2rem;
        font-size: 0.9rem;
    }

    .breadcrumb a {
        color: var(--primary-color);
        text-decoration: none;
        transition: color 0.2s ease;
    }

    .breadcrumb a:hover {
        color: var(--hover-color);
    }

    .box {
        border-radius: 10px;
        box-shadow: var(--shadow);
        margin-bottom: 2rem;
        background-color: #ffffff;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    .box:hover {
        transform: translateY(-4px);
        box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
    }

    .box-header {
        padding: 1.75rem;
        border-bottom: 1px solid var(--border-color);
    }

    .box-title {
        font-size: 1.25rem;
        font-weight: 600;
        color: var(--text-color);
        margin: 0;
    }

    .box-body {
        padding: 1.75rem;
    }

    .form-inline {
        display: flex;
        flex-wrap: wrap;
        gap: 1rem;
        align-items: center;
    }

    .form-group {
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .form-group label {
        font-size: 0.95rem;
        color: var(--text-color);
        font-weight: 500;
        white-space: nowrap;
    }

    .form-control {
        border-radius: 8px;
        border: 1px solid var(--border-color);
        padding: 0.75rem 1rem;
        font-size: 0.95rem;
        transition: border-color 0.2s ease, box-shadow 0.2s ease;
    }

    .form-control:focus {
        border-color: var(--primary-color);
        box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.2);
        outline: none;
    }

    .btn {
        border-radius: 8px;
        padding: 0.75rem 1.5rem;
        font-size: 0.95rem;
        font-weight: 500;
        transition: background-color 0.2s ease, transform 0.2s ease;
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
    }

    .btn-primary {
        background-color: var(--primary-color);
        border-color: var(--primary-color);
    }

    .btn-primary:hover {
        background-color: var(--hover-color);
        border-color: var(--hover-color);
        transform: translateY(-2px);
    }

    .btn-default {
        background-color: var(--default-color);
        border-color: var(--default-color);
        color: #ffffff;
    }

    .btn-default:hover {
        background-color: #5a6268;
        border-color: #5a6268;
        transform: translateY(-2px);
    }

    .btn:disabled {
        background-color: var(--disabled-color);
        border-color: var(--disabled-color);
        color: #a0aec0;
        cursor: not-allowed;
    }

    .table {
        background-color: #ffffff;
        border-radius: 10px;
        overflow: hidden;
        box-shadow: var(--shadow);
    }

    .table thead th {
        background-color: var(--primary-color);
        color: #ffffff;
        font-weight: 600;
        position: sticky;
        top: 0;
        z-index: 1;
        padding: 1.25rem;
    }

    .table tbody tr:nth-child(odd) {
        background-color: #f8fafc;
    }

    .table tbody tr:hover {
        background-color: #e2e8f0;
        transition: background-color 0.2s ease;
    }

    .table td, .table th {
        padding: 1.25rem;
        vertical-align: middle;
        font-size: 0.95rem;
    }

    .label {
        padding: 0.4rem 0.8rem;
        border-radius: 4px;
        font-size: 0.85rem;
        font-weight: 500;
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
    }

    .label-warning {
        background-color: var(--warning-color);
        color: #ffffff;
    }

    .label-info {
        background-color: var(--info-color);
        color: #ffffff;
    }

    .label-success {
        background-color: var(--success-color);
        color: #ffffff;
    }

    .label-danger {
        background-color: var(--danger-color);
        color: #ffffff;
    }

    .label-default {
        background-color: var(--default-color);
        color: #ffffff;
    }

    .pagination-controls {
        display: flex;
        justify-content: flex-end;
        align-items: center;
        gap: 8px;
        margin-top: 1.5rem;
    }

    .pagination-btn {
        background-color: #ffffff;
        border: 1px solid #e2e8f0;
        border-radius: 6px;
        padding: 0.5rem 1rem;
        font-size: 0.9rem;
        color: var(--text-color);
        cursor: pointer;
        transition: background-color 0.2s ease, border-color 0.2s ease;
    }

    .pagination-btn:hover:not(:disabled) {
        background-color: var(--primary-color);
        border-color: var(--primary-color);
        color: #ffffff;
    }

    .pagination-btn.active {
        background-color: var(--primary-color);
        border-color: var(--primary-color);
        color: #ffffff;
        font-weight: 600;
    }

    .pagination-btn:disabled {
        background-color: #f7fafc;
        border-color: #e2e8f0;
        color: var(--muted-color);
        cursor: not-allowed;
    }

    .pagination-info {
        font-size: 0.9rem;
        color: var(--muted-color);
        margin-right: 1.5rem;
    }

    .empty-state {
        text-align: center;
        padding: 3rem;
        color: var(--muted-color);
    }

    .empty-state i {
        font-size: 3rem;
        margin-bottom: 1.25rem;
        color: var(--primary-color);
    }

    .empty-state p {
        font-size: 1rem;
        margin: 0;
    }

    @media (max-width: 768px) {
        .content-wrapper {
            padding: 16px;
        }

        .content-header h1 {
            font-size: 1.75rem;
        }

        .form-inline {
            flex-direction: column;
            align-items: stretch;
        }

        .form-group {
            width: 100%;
            margin-bottom: 1rem;
        }

        .form-control, .btn {
            font-size: 0.9rem;
            padding: 0.6rem;
        }

        .table-responsive {
            overflow-x: auto;
        }

        .table td, .table th {
            padding: 0.9rem;
            font-size: 0.9rem;
        }

        .pagination-controls {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 8px;
            margin-top: 1.5rem;
        }

        .pagination-btn {
            padding: 0.5rem 0.9rem;
            font-size: 0.85rem;
        }
    }

    @media (max-width: 576px) {
        .content-header h1 {
            font-size: 1.5rem;
        }

        .box-header {
            padding: 1rem;
        }

        .box-body {
            padding: 1rem;
        }
    }
</style>

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
                <h3 class="box-title"><i class="fa fa-filter" style="margin-right: 0.5rem;"></i> Filter Requests</h3>
            </div>
            <div class="box-body">
                <form method="get" action="${pageContext.request.contextPath}/cskh/customer-request" class="form-inline">
                    <div class="form-group mr-3">
                        <div class="input-group">
                            <span class="input-group-addon"><i class="fa fa-list"></i> Request Type</span>
                            <select name="type" class="form-control">
                                <option value="">-- All --</option>
                                <option value="WARRANTY" ${param.type eq 'WARRANTY' ? 'selected' : ''}>Warranty</option>
                                <option value="MAINTENANCE" ${param.type eq 'MAINTENANCE' ? 'selected' : ''}>Maintenance</option>
                                <option value="REPAIR" ${param.type eq 'REPAIR' ? 'selected' : ''}>Repair</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group mr-3">
                        <div class="input-group">
                            <span class="input-group-addon"><i class="fa fa-info-circle"></i> Status</span>
                            <select name="status" class="form-control">
                                <option value="">-- All --</option>
                                <option value="PENDING" ${param.status eq 'PENDING' ? 'selected' : ''}>Pending</option>
                                <option value="TRANSFERRED" ${param.status eq 'TRANSFERRED' ? 'selected' : ''}>Transferred</option>
                                <option value="ASSIGNED" ${param.status eq 'ASSIGNED' ? 'selected' : ''}>Assigned</option>
                                <option value="IN_PROGRESS" ${param.status eq 'IN_PROGRESS' ? 'selected' : ''}>In Progress</option>
                                <option value="COMPLETED" ${param.status eq 'COMPLETED' ? 'selected' : ''}>Completed</option>
                                <option value="CANCELLED" ${param.status eq 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                            </select>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary">
                        <i class="fa fa-filter"></i> Filter
                    </button>
                    <a href="${pageContext.request.contextPath}/cskh/customer-request" class="btn btn-default">
                        <i class="fa fa-times"></i> Clear
                    </a>        
                </form>
            </div>
        </div>

        <!-- List -->
        <div class="box box-success">
            <div class="box-header with-border">
                <h3 class="box-title"><i class="fa fa-table" style="margin-right: 0.5rem;"></i> Request List</h3>
            </div>
            <div class="box-body table-responsive">
                <table class="table table-bordered table-striped">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th><i class="fa fa-user" style="margin-right: 0.5rem;"></i>Customer</th>
                            <th><i class="fa fa-cube" style="margin-right: 0.5rem;"></i>Device</th>
                            <th><i class="fa fa-tag" style="margin-right: 0.5rem;"></i>Title</th>
                            <th><i class="fa fa-info-circle" style="margin-right: 0.5rem;"></i>Description</th>
                            <th><i class="fa fa-list" style="margin-right: 0.5rem;"></i>Request Type</th>
                            <th><i class="fa fa-calendar" style="margin-right: 0.5rem;"></i>Request Date</th>
                            <th><i class="fa fa-info" style="margin-right: 0.5rem;"></i>Status</th>
                            <th><i class="fa fa-cogs" style="margin-right: 0.5rem;"></i>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty requests}">
                            <tr>
                                <td colspan="9" class="empty-state">
                                    <i class="fa fa-inbox"></i>
                                    <p>No requests found.</p>
                                </td>
                            </tr>
                        </c:if>

                        <c:forEach var="r" items="${requests}" varStatus="loop">
                            <tr>
                                <td>${(page-1)*pageSize + st.index + 1}</td>
                                <td>${r.customer.fullName}</td>
                                <td>${r.device.productName}</td>
                                <td>${r.title}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty r.description}">${r.description}</c:when>
                                        <c:otherwise><span style="color: var(--muted-color);">No description</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${r.request_type}</td>
                                <td><fmt:formatDate value="${r.request_date}" pattern="yyyy-MM-dd HH:mm" /></td>
                                <td>
                                    <span class="label
                                          ${r.status eq 'PENDING' ? 'label-warning' :
                                            r.status eq 'TRANSFERRED' ? 'label-info' :
                                            r.status eq 'ASSIGNED' ? 'label-primary' :
                                            r.status eq 'IN_PROGRESS' ? 'label-info' :
                                            r.status eq 'COMPLETED' ? 'label-success' :
                                            r.status eq 'CANCELLED' ? 'label-danger' : 'label-default'}">
                                        <i class="fa ${r.status eq 'PENDING' ? 'fa-clock-o' :
                                                       r.status eq 'TRANSFERRED' ? 'fa-share' :
                                                       r.status eq 'ASSIGNED' ? 'fa-user-plus' :
                                                       r.status eq 'IN_PROGRESS' ? 'fa-cog' :
                                                       r.status eq 'COMPLETED' ? 'fa-check-circle' :
                                                       r.status eq 'CANCELLED' ? 'fa-times-circle' : 'fa-circle'}"></i>
                                           ${r.status}
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${r.status eq 'PENDING'}">
                                                <form method="post" action="${pageContext.request.contextPath}/cskh/customer-request" style="display:inline;">
                                                    <input type="hidden" name="action" value="transferToTechManager" />
                                                    <input type="hidden" name="id" value="${r.id}" />
                                                    <button type="submit" class="btn btn-primary btn-sm">
                                                        <i class="fa fa-share"></i> Transfer
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="btn btn-default btn-sm" disabled>
                                                    <i class="fa fa-check"></i> Transferred
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                        <a href="${pageContext.request.contextPath}/cskh/customer-request/detail?id=${r.id}" class="btn btn-info btn-sm">
                                            <i class="fa fa-eye"></i> View
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="pagination-controls">
                            <span class="pagination-info">
                                Showing ${(page-1)*pageSize + 1} to ${page*pageSize > totalItems ? totalItems : page*pageSize} of ${totalItems} requests
                            </span>
                            <div style="display: flex; gap: 8px; align-items: center;">
                                <button class="pagination-btn" ${page == 1 ? 'disabled' : ''}
                                        onclick="window.location = '${pageContext.request.contextPath}/cskh/customer-request?page=${page - 1}&type=${param.type}&status=${param.status}'">
                                    <i class="fa fa-angle-left"></i>
                                </button>

                                <button class="pagination-btn ${page == 1 ? 'active' : ''}"
                                        onclick="window.location = '${pageContext.request.contextPath}/cskh/customer-request?page=1&type=${param.type}&status=${param.status}'">1</button>

                                <c:if test="${page > 4}">
                                    <span>...</span>
                                </c:if>

                                <c:set var="startPage" value="${page - 2}" />
                                <c:set var="endPage" value="${page + 2}" />

                                <c:if test="${startPage < 2}">
                                    <c:set var="startPage" value="2" />
                                </c:if>
                                <c:if test="${endPage > totalPages - 1}">
                                    <c:set var="endPage" value="${totalPages - 1}" />
                                </c:if>

                                <c:forEach var="i" begin="${startPage}" end="${endPage}">
                                    <button class="pagination-btn ${i == page ? 'active' : ''}"
                                            onclick="window.location = '${pageContext.request.contextPath}/cskh/customer-request?page=${i}&type=${param.type}&status=${param.status}'">${i}</button>
                                </c:forEach>

                                <c:if test="${page < totalPages - 3}">
                                    <span>...</span>
                                </c:if>

                                <c:if test="${totalPages > 1}">
                                    <button class="pagination-btn ${page == totalPages ? 'active' : ''}"
                                            onclick="window.location = '${pageContext.request.contextPath}/cskh/customer-request?page=${totalPages}&type=${param.type}&status=${param.status}'">${totalPages}</button>
                                </c:if>

                                <button class="pagination-btn" ${page == totalPages ? 'disabled' : ''}
                                        onclick="window.location = '${pageContext.request.contextPath}/cskh/customer-request?page=${page + 1}&type=${param.type}&status=${param.status}'">
                                    <i class="fa fa-angle-right"></i>
                                </button>
                            </div>
                        </div>
                    </c:if>

                </div>
            </div>
        </section>
    </div>

    <%@ include file="/jsp/layout/footer2.jsp" %>