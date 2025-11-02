<%--
    Document   : contract_list
    Created on : Oct 10, 2025, 1:15:09 AM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/jsp/layout/header2.jsp" %>
<%@ include file="/jsp/layout/sidebar2.jsp" %>

<section class="content-header">
    <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">Contract Management</h1>
    <ol class="breadcrumb" style="background: none; padding: 0; margin-bottom: 2rem;">
        <li><a href="${pageContext.request.contextPath}/cskh/home"><i class="fa fa-dashboard"></i> CSKH</a></li>
        <li class="active">Contract List</li>
    </ol>
</section>

<section class="content">
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

    <div class="content-card">
        <div class="filter-bar">
            <form method="get" action="${pageContext.request.contextPath}/cskh/contract">
                
                <label for="keywordFilter" style="font-weight: 500;">Search:</label>
                <input type="text" name="keyword" id="keywordFilter" value="${param.keyword}" placeholder="Search by Contract code or Customer name" class="search-input" />

                <label for="fromDateFilter" style="font-weight: 500;">From Date:</label>
                <input type="date" name="fromDate" id="fromDateFilter" value="${param.fromDate}" class="search-input" />

                <label for="toDateFilter" style="font-weight: 500;">To Date:</label>
                <input type="date" name="toDate" id="toDateFilter" value="${param.toDate}" class="search-input" />

                <button type="submit" class="btn btn-primary"><i class="fa fa-filter"></i> Filter</button>
                <a href="${pageContext.request.contextPath}/cskh/contract" class="btn btn-primary" style="background: #6c757d; border-color: #6c757d;"><i class="fa fa-times"></i> Clear</a>
            </form>
        </div>
    </div>

    <div class="content-card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h3 style="margin: 0; font-size: 1.1rem; font-weight: 600;"><i class="fa fa-file-text-o" style="margin-right: 0.5rem;"></i> Contract List</h3>
            <a href="${pageContext.request.contextPath}/cskh/createContract" class="btn btn-success" style="background-color: #10b981; border-color: #10b981;">
                <i class="fa fa-plus"></i> Add New Contract
            </a>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="inventory-table">
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
                                                <c:otherwise><span style="color: #a0aec0;">No description</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/cskh/contract_detail?id=${c.id}" class="btn btn-action btn-view" style="text-decoration: none;">
                                                <i class="fa fa-eye"></i> View
                                            </a>
                                            <button class="btn btn-action btn-delete"
                                                    onclick="openDeleteModal('${c.id}', '${c.contractCode}')">
                                                <i class="fa fa-trash"></i> Delete
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7">
                                        <div class="empty-state" style="padding: 3rem; text-align: center; color: #718096;">
                                            <i class="fa fa-inbox" style="font-size: 3rem; margin-bottom: 1rem; color: #6366f1;"></i>
                                            <h4 style="font-size: 1.25rem; margin: 0;">No contracts found.</h4>
                                        </div>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div> </div> </div> <c:if test="${totalPages > 1}">
        <div class="pagination-container">
            <span class="pagination-info">
                Showing ${(page-1)*pageSize + 1} to ${page*pageSize > totalItems ? totalItems : page*pageSize} of ${totalItems} contracts
            </span>
            <div class="pagination-controls">
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