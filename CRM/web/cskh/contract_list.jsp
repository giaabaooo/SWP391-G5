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

<section class="content-header">
    <h1>Contract Management</h1>
    <ol class="breadcrumb">
        <li><a href="${pageContext.request.contextPath}/cskh/home"><i class="fa fa-dashboard"></i> CSKH</a></li>
        <li class="active">Contract List</li>
    </ol>
</section>

<section class="content">
    <c:if test="${param.message == 'deleted'}">
        <div class="alert alert-success" style="
             margin-bottom: 20px;
             color: #155724;
             background-color: #d4edda;
             border: 1px solid #c3e6cb;
             padding: 10px;
             border-radius: 6px;">
            Contract deleted successfully!
        </div>
    </c:if>

    <c:if test="${param.error == 'delete_failed'}">
        <div class="alert alert-danger" style="
             margin-bottom: 20px;
             color: #721c24;
             background-color: #f8d7da;
             border: 1px solid #f5c6cb;
             padding: 10px;
             border-radius: 6px;">
            Failed to delete the contract. Please try again.
        </div>
    </c:if>

    <c:if test="${param.error == 'missing_id'}">
        <div class="alert alert-warning" style="
             margin-bottom: 20px;
             color: #856404;
             background-color: #fff3cd;
             border: 1px solid #ffeeba;
             padding: 10px;
             border-radius: 6px;">
            Missing contract ID to delete!
        </div>
    </c:if>

    <!-- Filter form -->
    <div class="box box-primary">
        <div class="box-body">
            <form method="get" action="${pageContext.request.contextPath}/cskh/contract" class="row g-3">
                <div class="col-md-4">
                    <input type="text" name="keyword" value="${param.keyword}" placeholder="Search by Contract code or Customer name" class="form-control" />
                </div>
                <div class="col-md-3">
                    <input type="date" name="fromDate" value="${param.fromDate}" class="form-control" />
                </div>
                <div class="col-md-3">
                    <input type="date" name="toDate" value="${param.toDate}" class="form-control" />
                </div>
                <div class="col-md-2 text-end">
                    <button type="submit" class="btn btn-primary"><i class="fa fa-search"></i> Filter</button>
                    <a href="${pageContext.request.contextPath}/cskh/contract" class="btn btn-default"><i class="fa fa-undo"></i> Clear</a>
                </div>
            </form>
        </div>
    </div>

    <!-- Contract table -->
    <div class="box">
        <div class="box-header with-border d-flex justify-content-between align-items-center">
            <a href="${pageContext.request.contextPath}/cskh/createContract" class="btn btn-success">
                <i class="fa fa-plus"></i> Add New Contract
            </a>
        </div>
        <div class="box-body table-responsive">
            <table class="table table-bordered table-striped table-hover align-middle">
                <thead class="bg-primary">
                    <tr>
                        <th style="width:5%">#</th>
                        <th style="width:15%">Contract Code</th>
                        <th style="width:15%">Customer</th>
                        <th style="width:15%">Contract Date</th>
                        <th style="width:15%">Total Amount</th>
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
                                    <td><fmt:formatNumber value="${c.totalAmount}" type="number" minFractionDigits="0" /></td>
                                    <td>${c.description}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/cskh/contract_detail?id=${c.id}" class="btn btn-info btn-sm">
                                            <i class="fa fa-eye"></i> View
                                        </a>
                                        <button class="btn btn-danger btn-xs"
                                                onclick="openDeleteModal('${c.id}', '${c.contractCode}')">
                                            <i class="fa fa-trash"></i> Delete
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7" class="text-center text-muted py-3">No contracts found</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Pagination -->

    <c:if test="${totalPages > 1}">
        <div class="pagination-controls" style="display: flex; justify-content: end; align-items: center; gap: 6px; margin-top: 20px;">
            <button class="pagination-btn" ${page == 1 ? 'disabled' : ''}
                    onclick="window.location = '${pageContext.request.contextPath}/cskh/contract?page=${page - 1}&keyword=${param.keyword}&fromDate=${param.fromDate}&toDate=${param.toDate}'">
                <i class="fa fa-angle-left"></i>
            </button>

            <div id="pageNumber" style="display: flex; gap: 6px; align-items: center;">

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
            </div>

            <button class="pagination-btn" ${page == totalPages ? 'disabled' : ''}
                    onclick="window.location = '${pageContext.request.contextPath}/cskh/contract?page=${page + 1}&keyword=${param.keyword}&fromDate=${param.fromDate}&toDate=${param.toDate}'">
                <i class="fa fa-angle-right"></i>
            </button>
        </div>
    </c:if>
    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal-overlay" style="display: none;">
        <div class="delete-modal">
            <div class="modal-header-custom">
                <div class="modal-icon">
                    <i class="fa fa-trash"></i>
                </div>
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
                <button class="modal-btn modal-btn-cancel" onclick="closeDeleteModal()">
                    <i class="fa fa-times"></i> Cancel
                </button>
                <button class="modal-btn modal-btn-delete" id="confirmDeleteBtn">
                    <i class="fa fa-trash"></i> Delete Contract
                </button>
            </div>
        </div>
    </div>
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
        });

        document.addEventListener('DOMContentLoaded', function () {
            const alerts = document.querySelectorAll('.alert');
            if (alerts.length > 0) {
                setTimeout(() => {
                    alerts.forEach(a => a.style.display = 'none');
                }, 3000);
            }
        });
    </script>
</section>

<%@ include file="/jsp/layout/footer2.jsp" %>

