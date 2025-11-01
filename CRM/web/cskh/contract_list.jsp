<%-- 
    Document   : contract_list
    Created on : Oct 10, 2025, 1:15:09 AM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/jsp/layout/header2.jsp" %>
<%@ include file="/jsp/layout/sidebar2.jsp" %>

<style>
    :root {
        --primary-color: #4a90e2;
        --success-color: #38a169;
        --danger-color: #e53e3e;
        --warning-color: #d69e2e;
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

    .alert {
        border-radius: 6px;
        padding: 1rem;
        margin-bottom: 1.5rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
        opacity: 1;
        transition: opacity 0.5s ease;
    }

    .alert-success {
        background-color: #d4edda;
        border: 1px solid #c3e6cb;
        color: #155724;
    }

    .alert-danger {
        background-color: #f8d7da;
        border: 1px solid #f5c6cb;
        color: #721c24;
    }

    .alert-warning {
        background-color: #fff3cd;
        border: 1px solid #ffeeba;
        color: #856404;
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

    .box-header {
        padding: 1.5rem;
        border-bottom: 1px solid #e2e8f0;
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

    .btn-success {
        background-color: var(--success-color);
        border-color: var(--success-color);
    }

    .btn-success:hover {
        background-color: #2f855a;
        border-color: #2f855a;
    }

    .btn-default {
        background-color: #6b7280;
        border-color: #6b7280;
    }

    .btn-default:hover {
        background-color: #5a6268;
        border-color: #5a6268;
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
        padding: 2rem;
        color: var(--muted-color);
    }

    .empty-state i {
        font-size: 2.5rem;
        margin-bottom: 1rem;
        color: var(--primary-color);
    }

    .modal-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.5);
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 1000;
        transition: opacity 0.3s ease;
    }

    .delete-modal {
        background: #ffffff;
        border-radius: 8px;
        width: 100%;
        max-width: 400px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        overflow: hidden;
    }

    .modal-header-custom {
        text-align: center;
        padding: 1.5rem;
        background-color: var(--danger-color);
        color: #ffffff;
    }

    .modal-header-custom h3 {
        margin: 0;
        font-size: 1.25rem;
        font-weight: 500;
    }

    .modal-icon {
        font-size: 1.5rem;
    }

    .modal-body-custom {
        padding: 1.5rem;
        text-align: center;
    }

    .warning-text {
        color: var(--text-color);
        font-size: 0.95rem;
        margin: 0.5rem 0;
    }

    .product-name-display {
        font-weight: 600;
        color: var(--primary-color);
        margin: 0.5rem 0;
        font-size: 1.1rem;
    }

    .warning-badge {
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        background-color: #fff3cd;
        color: #856404;
        padding: 0.5rem 1rem;
        border-radius: 4px;
        font-size: 0.85rem;
    }

    .modal-footer-custom {
        display: flex;
        justify-content: flex-end;
        gap: 0.5rem;
        padding: 1rem;
        border-top: 1px solid #e2e8f0;
    }

    .modal-btn {
        border-radius: 6px;
        padding: 0.5rem 1rem;
        font-size: 0.9rem;
        transition: background-color 0.2s ease;
    }

    .modal-btn-cancel {
        background-color: #6b7280;
        border-color: #6b7280;
        color: #ffffff;
    }

    .modal-btn-cancel:hover {
        background-color: #5a6268;
        border-color: #5a6268;
    }

    .modal-btn-delete {
        background-color: var(--danger-color);
        border-color: var(--danger-color);
        color: #ffffff;
    }

    .modal-btn-delete:hover {
        background-color: #c53030;
        border-color: #c53030;
    }
</style>

<section class="content-header">
    <h1>Contract Management</h1>
    <ol class="breadcrumb">
        <li><a href="${pageContext.request.contextPath}/cskh/home"><i class="fa fa-dashboard"></i> CSKH</a></li>
        <li class="active">Contract List</li>
    </ol>
</section>

<section class="content">
    <!-- Alerts -->
    <c:if test="${param.message == 'deleted'}">
        <div class="alert alert-success">
            <i class="fa fa-check-circle"></i> Contract deleted successfully!
        </div>
    </c:if>

    <c:if test="${param.error == 'delete_failed'}">
        <div class="alert alert-danger">
            <i class="fa fa-exclamation-circle"></i> Failed to delete the contract. Please try again.
        </div>
    </c:if>

    <c:if test="${param.error == 'missing_id'}">
        <div class="alert alert-warning">
            <i class="fa fa-exclamation-triangle"></i> Missing contract ID to delete!
        </div>
    </c:if>

    <c:if test="${param.message == 'created'}">
        <div class="alert alert-success">
            <i class="fa fa-check-circle"></i> Contract created successfully!
        </div>
    </c:if>
    <!-- Filter form -->
    <div class="box box-primary">
        <div class="box-body">
            <form method="get" action="${pageContext.request.contextPath}/cskh/contract" class="row g-3">
                <div class="col-md-4 mb-2 mb-md-0">
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-search"></i></span>
                        <input type="text" name="keyword" value="${param.keyword}" placeholder="Search by Contract code or Customer name" class="form-control" />
                    </div>
                </div>
                <div class="col-md-3 mb-2 mb-md-0">
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-calendar"></i> From Date</span>
                        <input type="date" name="fromDate" value="${param.fromDate}" class="form-control" />
                    </div>
                </div>

                <div class="col-md-3 mb-2 mb-md-0">
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-calendar"></i> To Date</span>
                        <input type="date" name="toDate" value="${param.toDate}" class="form-control" />
                    </div>
                </div>


                <div class="col-md-2 text-end">
                    <button type="submit" class="btn btn-primary"><i class="fa fa-filter"></i> Filter</button>
                    <a href="${pageContext.request.contextPath}/cskh/contract" class="btn btn-default"><i class="fa fa-times"></i> Clear</a>
                </div>
            </form>
        </div>
    </div>

    <!-- Contract table -->
    <div class="box">
        <div class="box-header with-border d-flex justify-content-between align-items-center">
            <h3 class="box-title"><i class="fa fa-file-text-o" style="margin-right: 0.5rem;"></i> Contract List</h3>
            <a href="${pageContext.request.contextPath}/cskh/createContract" class="btn btn-success">
                <i class="fa fa-plus"></i> Add New Contract
            </a>
        </div>
        <div class="box-body table-responsive">
            <table class="table table-bordered table-striped table-hover align-middle">
                <thead>
                    <tr>
                        <th style="width:5%">#</th>
                        <th style="width:15%">Contract Code
                            <a href="${pageContext.request.contextPath}/cskh/contract?page=1&sort=contractCode_asc&keyword=${param.keyword}&fromDate=${param.fromDate}&toDate=${param.toDate}">
                                <i class="fa fa-arrow-up ${sort=='contractCode_asc'?'text-primary':''}" title="Sort A-Z"></i></a>
                            <a href="${pageContext.request.contextPath}/cskh/contract?page=1&sort=contractCode_desc&keyword=${param.keyword}&fromDate=${param.fromDate}&toDate=${param.toDate}">
                                <i class="fa fa-arrow-down ${sort=='contractCode_desc'?'text-primary':''}" title="Sort Z-A"></i></a>
                        </th>
                        <th style="width:15%">Customer
                            <a href="?sort=customer_asc&keyword=${param.keyword}&fromDate=${param.fromDate}&toDate=${param.toDate}"><i class="fa fa-arrow-up ${sort=='customer_asc'?'text-primary':''}"></i></a>
                            <a href="?sort=customer_desc&keyword=${param.keyword}&fromDate=${param.fromDate}&toDate=${param.toDate}"><i class="fa fa-arrow-down ${sort=='customer_desc'?'text-primary':''}"></i></a>

                        </th>
                        <th style="width:15%">Contract Date
                            <a href="?sort=contractDate_asc&keyword=${param.keyword}&fromDate=${param.fromDate}&toDate=${param.toDate}"><i class="fa fa-arrow-up ${sort=='contractDate_asc'?'text-primary':''}"></i></a>
                            <a href="?sort=contractDate_desc&keyword=${param.keyword}&fromDate=${param.fromDate}&toDate=${param.toDate}"><i class="fa fa-arrow-down ${sort=='contractDate_desc'?'text-primary':''}"></i></a>

                        </th>
                        <th style="width:15%">Total Amount
                            <a href="?sort=totalAmount_asc&keyword=${param.keyword}&fromDate=${param.fromDate}&toDate=${param.toDate}"><i class="fa fa-arrow-up ${sort=='totalAmount_asc'?'text-primary':''}"></i></a>
                            <a href="?sort=totalAmount_desc&keyword=${param.keyword}&fromDate=${param.fromDate}&toDate=${param.toDate}"><i class="fa fa-arrow-down ${sort=='totalAmount_desc'?'text-primary':''}"></i></a>

                        </th>
                        <th>Description</th>
                        <th style="width:15%">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty contracts}">
                            <c:forEach var="c" items="${contracts}" varStatus="st">
                                <tr>
                                    <td>${(page - 1) * pageSize + st.index + 1}</td>
                                    <td><strong>${c.contractCode}</strong></td>
                                    <td>${c.customerName}</td>   
                                    <td><fmt:formatDate value="${c.contractDate}" pattern="yyyy-MM-dd" /></td>
                                    <td>$<fmt:formatNumber value="${c.totalAmount}" type="number" minFractionDigits="2" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty c.description}">${c.description}</c:when>
                                            <c:otherwise><span style="color: var(--muted-color);">No description</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/cskh/contract_detail?id=${c.id}" class="btn btn-info btn-sm">
                                            <i class="fa fa-eye"></i> View
                                        </a>
                                        <button class="btn btn-danger btn-sm"
                                                onclick="openDeleteModal('${c.id}', '${c.contractCode}')">
                                            <i class="fa fa-trash"></i> Delete
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7" class="empty-state">
                                    <i class="fa fa-inbox"></i>
                                    <p>No contracts found.</p>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Pagination -->
    <c:if test="${totalPages > 1}">
        <div class="pagination-controls">
            <span class="pagination-info">
                Showing ${(page-1)*pageSize + 1} to ${page*pageSize > totalItems ? totalItems : page*pageSize} of ${totalItems} contracts
            </span>
            <div style="display: flex; gap: 8px; align-items: center;">
                <button class="pagination-btn" ${page == 1 ? 'disabled' : ''}
                        onclick="window.location = '${pageContext.request.contextPath}/cskh/contract?page=${page - 1}&keyword=${param.keyword}&fromDate=${param.fromDate}&toDate=${param.toDate}'">
                    <i class="fa fa-angle-left"></i>
                </button>

                <button class="pagination-btn ${page == 1 ? 'active' : ''}"
                        onclick="window.location = '${pageContext.request.contextPath}/cskh/contract?page=1&keyword=${param.keyword}&fromDate=${param.fromDate}&toDate=${param.toDate}'">1</button>

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
                            onclick="window.location = '${pageContext.request.contextPath}/cskh/contract?page=${i}&keyword=${param.keyword}&fromDate=${param.fromDate}&toDate=${param.toDate}'">${i}</button>
                </c:forEach>

                <c:if test="${page < totalPages - 3}">
                    <span>...</span>
                </c:if>

                <c:if test="${totalPages > 1}">
                    <button class="pagination-btn ${page == totalPages ? 'active' : ''}"
                            onclick="window.location = '${pageContext.request.contextPath}/cskh/contract?page=${totalPages}&keyword=${param.keyword}&fromDate=${param.fromDate}&toDate=${param.toDate}'">${totalPages}</button>
                </c:if>

                <button class="pagination-btn" ${page == totalPages ? 'disabled' : ''}
                        onclick="window.location = '${pageContext.request.contextPath}/cskh/contract?page=${page + 1}&keyword=${param.keyword}&fromDate=${param.fromDate}&toDate=${param.toDate}'">
                    <i class="fa fa-angle-right"></i>
                </button>
            </div>
        </div>
    </c:if>

    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal-overlay" style="display: none;">
        <div class="delete-modal">
            <div class="modal-header-custom">
                <h3>Delete Contract</h3>
            </div>
            <div class="modal-body-custom">
                <p class="warning-text">Are you sure you want to delete this contract?</p>
                <div class="product-name-display" id="modalContractName">Contract Code</div>
                <p class="warning-text">This will permanently remove the contract from the system.</p>
                <span class="warning-badge">
                    <i class="fa fa-exclamation-triangle"></i> This action cannot be undone!
                </span>
            </div>
            <div class="modal-footer-custom">
                <button type="button" class="modal-btn modal-btn-cancel" onclick="closeDeleteModal()">
                    <i class="fa fa-times"></i> Cancel
                </button>
                <button type="button" class="modal-btn modal-btn-delete" id="confirmDeleteBtn">
                    <i class="fa fa-trash"></i> Delete Contract
                </button>
            </div>
        </div>
    </div>
</section>

<script>
    let currentDeleteContractId = null;

    function openDeleteModal(contractId, contractCode) {
        currentDeleteContractId = contractId;
        document.getElementById('modalContractName').innerText = contractCode;
        document.getElementById('deleteModal').style.display = 'flex';
    }

    function closeDeleteModal() {
        document.getElementById('deleteModal').style.display = 'none';
        currentDeleteContractId = null;
    }

    window.addEventListener('click', function (event) {
        const modal = document.getElementById('deleteModal');
        if (event.target === modal) {
            closeDeleteModal();
        }
    });

    document.addEventListener('keydown', function (event) {
        if (event.key === 'Escape') {
            closeDeleteModal();
        }
    });

    document.addEventListener('DOMContentLoaded', function () {
        const confirmBtn = document.getElementById('confirmDeleteBtn');
        if (confirmBtn) {
            confirmBtn.addEventListener('click', function () {
                if (currentDeleteContractId) {
                    const contextPath = '<%= request.getContextPath()%>';

                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = contextPath + '/cskh/deleteContract';

                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'id';
                    input.value = currentDeleteContractId;

                    form.appendChild(input);
                    document.body.appendChild(form);

                    form.submit();
                }
            });
        }

        const alerts = document.querySelectorAll('.alert');
        if (alerts.length > 0) {
            setTimeout(() => {
                alerts.forEach(a => {
                    a.style.opacity = '0';
                    setTimeout(() => a.remove(), 500);
                });
            }, 3000);
        }
    });
</script>

<%@ include file="/jsp/layout/footer2.jsp" %>