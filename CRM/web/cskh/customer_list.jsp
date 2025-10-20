<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/jsp/layout/header2.jsp" %>
<%@ include file="/jsp/layout/sidebar2.jsp" %>

<style>
    :root {
        --primary-color: #4a90e2;
        --success-color: #38a169;
        --danger-color: #e53e3e;
        --text-color: #2d3748;
        --muted-color: #718096;
        --background-color: #f7fafc;
    }

    .content-wrapper {
        background-color: var(--background-color);
        padding: 20px;
    }

    .content-header h1 {
        color: var(--text-color);
        font-weight: 600;
        font-size: 2rem;
        margin-bottom: 0.5rem;
    }

    .breadcrumb {
        background-color: transparent;
        padding: 0;
        margin-bottom: 1.5rem;
    }

    .box {
        border-radius: 8px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        margin-bottom: 1.5rem;
        background-color: #ffffff;
        transition: transform 0.2s ease;
    }

    .box:hover {
        transform: translateY(-2px);
    }

    .box-body {
        padding: 1.5rem;
    }

    .form-control {
        border-radius: 6px;
        border: 1px solid #e2e8f0;
        padding: 0.75rem;
        font-size: 0.95rem;
    }

    .form-control:focus {
        border-color: var(--primary-color);
        box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1);
    }

    .btn {
        border-radius: 6px;
        padding: 0.75rem 1.25rem;
        font-size: 0.95rem;
        transition: background-color 0.2s ease;
    }

    .btn-primary {
        background-color: var(--primary-color);
        border-color: var(--primary-color);
    }

    .btn-primary:hover {
        background-color: #3b82f6;
        border-color: #3b82f6;
    }

    .btn-secondary {
        background-color: #6b7280;
        border-color: #6b7280;
    }

    .btn-secondary:hover {
        background-color: #5a6268;
        border-color: #5a6268;
    }

    .btn-success {
        background-color: var(--success-color);
        border-color: var(--success-color);
    }

    .btn-success:hover {
        background-color: #2f855a;
        border-color: #2f855a;
    }

    .table {
        background-color: #ffffff;
        border-radius: 8px;
        overflow: hidden;
    }

    .table thead th {
        background-color: var(--primary-color);
        color: #ffffff;
        font-weight: 500;
        position: sticky;
        top: 0;
        z-index: 1;
    }

    .table tbody tr:nth-child(odd) {
        background-color: #f8fafc;
    }

    .table tbody tr:hover {
        background-color: #edf2f7;
    }

    .table td, .table th {
        padding: 1rem;
        vertical-align: middle;
        font-size: 0.95rem;
    }

    .label {
        padding: 0.4rem 0.8rem;
        border-radius: 4px;
        font-size: 0.85rem;
    }

    .label-success {
        background-color: var(--success-color);
        color: #ffffff;
    }

    .label-danger {
        background-color: var(--danger-color);
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
        margin-right: 1rem;
    }

    .empty-state {
        text-align: center;
        padding: 2rem;
        color: var(--muted-color);
    }

    .empty-state i {
        font-size: 2.5rem;
        margin-bottom: 1rem;
        color: var(--primary-color);
    }

    @media (max-width: 768px) {
        .form-control, .btn {
            font-size: 0.85rem;
            padding: 0.5rem;
        }

        .table-responsive {
            overflow-x: auto;
        }

        .table td, .table th {
            padding: 0.75rem;
            font-size: 0.85rem;
        }

        .pagination-controls {
            flex-wrap: wrap;
            justify-content: center;
        }
    }
</style>

<section class="content-header">
    <h1>Customer Management</h1>
    <ol class="breadcrumb">
        <li><a href="${pageContext.request.contextPath}/cskh/home"><i class="fa fa-dashboard"></i> CSKH</a></li>
        <li class="active">Customer List</li>
    </ol>
</section>

<section class="content">
    <!-- Filter form -->
    <form method="get" action="${pageContext.request.contextPath}/cskh/customer" class="row mb-3">
        <div class="col-md-4 mb-2 mb-md-0">
            <div class="input-group">
                <span class="input-group-addon"><i class="fa fa-search"></i></span>
                <input type="text" name="keyword" value="${param.keyword}" placeholder="Search username/email" class="form-control"/>
            </div>
        </div>
        <div class="col-md-3 mb-2 mb-md-0">
            <select name="status" class="form-control">
                <option value="">-- Select Status --</option>
                <option value="active" ${param.status=='active'?'selected':''}>Active</option>
                <option value="inactive" ${param.status=='inactive'?'selected':''}>Inactive</option>
            </select>
        </div>
        <div class="col-md-5">
            <button type="submit" class="btn btn-primary"><i class="fa fa-filter"></i> Filter</button>
            <a href="${pageContext.request.contextPath}/cskh/customer" class="btn btn-secondary"><i class="fa fa-times"></i> Clear</a>
        </div>
    </form>

    <!-- Customer table -->
    <div class="box">
        <div class="box-body table-responsive">
            <table class="table table-bordered table-striped">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Username
                            <a href="${pageContext.request.contextPath}/cskh/customer?page=1&sort=username_asc&keyword=${param.keyword}&status=${param.status}">
                                <i class="fa fa-arrow-up ${sort=='username_asc'?'text-primary':''}" title="Sort A-Z"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/cskh/customer?page=1&sort=username_desc&keyword=${param.keyword}&status=${param.status}">
                                <i class="fa fa-arrow-down ${sort=='username_desc'?'text-primary':''}" title="Sort Z-A"></i>
                            </a>
                        </th>
                        <th>Full Name
                            <a href="${pageContext.request.contextPath}/cskh/customer?page=1&sort=fullname_asc&keyword=${param.keyword}&status=${param.status}">
                                <i class="fa fa-arrow-up ${sort=='fullname_asc'?'text-primary':''}" title="Sort A-Z"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/cskh/customer?page=1&sort=fullname_desc&keyword=${param.keyword}&status=${param.status}">
                                <i class="fa fa-arrow-down ${sort=='fullname_desc'?'text-primary':''}" title="Sort Z-A"></i>
                            </a>
                        </th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="u" items="${customers}" varStatus="st">
                        <tr>
                            <td>${(page-1)*pageSize + st.index + 1}</td>
                            <td>${u.username}</td>
                            <td>${u.fullName}</td>
                            <td>${u.email}</td>
                            <td>${u.phone}</td>
                            <td>
                                <span class="label ${u.isActive?'label-success':'label-danger'}">
                                    <i class="fa ${u.isActive?'fa-check-circle':'fa-times-circle'}"></i> ${u.isActive?'Active':'Inactive'}
                                </span>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/cskh/customer/view?id=${u.id}" class="btn btn-info btn-sm">
                                    <i class="fa fa-eye"></i> View
                                </a>
                                <form action="${pageContext.request.contextPath}/cskh/customer" method="post" style="display:inline;">
                                    <input type="hidden" name="id" value="${u.id}" />
                                    <button type="submit" class="btn btn-${u.isActive?'danger':'success'} btn-sm">
                                        <i class="fa ${u.isActive?'fa-times-circle':'fa-check-circle'}"></i>
                                        ${u.isActive?'Inactive':'Active'}
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty customers}">
                        <tr>
                            <td colspan="7" class="empty-state">
                                <i class="fa fa-inbox"></i>
                                <p>No customers found.</p>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Pagination -->
    <c:if test="${totalPages > 1}">
        <div class="pagination-controls">
            <span class="pagination-info">
                Showing ${(page-1)*pageSize + 1} to ${page*pageSize > totalItems ? totalItems : page*pageSize} of ${totalItems} customers
            </span>
            <div style="display: flex; gap: 8px; align-items: center;">
                <button class="pagination-btn" ${page == 1 ? 'disabled' : ''}
                        onclick="window.location = '${pageContext.request.contextPath}/cskh/customer?page=${page - 1}&keyword=${param.keyword}&status=${param.status}'">
                    <i class="fa fa-angle-left"></i>
                </button>

                <button class="pagination-btn ${page == 1 ? 'active' : ''}"
                        onclick="window.location = '${pageContext.request.contextPath}/cskh/customer?page=1&keyword=${param.keyword}&status=${param.status}'">1</button>

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
                            onclick="window.location = '${pageContext.request.contextPath}/cskh/customer?page=${i}&keyword=${param.keyword}&status=${param.status}'">${i}</button>
                </c:forEach>

                <c:if test="${page < totalPages - 3}">
                    <span>...</span>
                </c:if>

                <c:if test="${totalPages > 1}">
                    <button class="pagination-btn ${page == totalPages ? 'active' : ''}"
                            onclick="window.location = '${pageContext.request.contextPath}/cskh/customer?page=${totalPages}&keyword=${param.keyword}&status=${param.status}'">${totalPages}</button>
                </c:if>

                <button class="pagination-btn" ${page == totalPages ? 'disabled' : ''}
                        onclick="window.location = '${pageContext.request.contextPath}/cskh/customer?page=${page + 1}&keyword=${param.keyword}&status=${param.status}'">
                    <i class="fa fa-angle-right"></i>
                </button>
            </div>
        </div>
    </c:if>
</section>

<%@ include file="/jsp/layout/footer2.jsp" %>