<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="/jsp/layout/header2.jsp" %>
<%@ include file="/jsp/layout/sidebar2.jsp" %>

<style>
    :root {
        --primary-color: #4a90e2;
        --success-color: #38a169;
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
        transition: transform 0.2s ease;
    }

    .box:hover {
        transform: translateY(-2px);
    }

    .box-header {
        padding: 1.5rem;
        background-color: #ffffff;
        border-bottom: 1px solid #e2e8f0;
    }

    .box-title {
        font-size: 1.25rem;
        font-weight: 500;
        color: var(--text-color);
        margin: 0;
    }

    .box-body {
        padding: 1.5rem;
    }

    .box-body p {
        margin: 0.5rem 0;
        font-size: 1rem;
        color: var(--text-color);
    }

    .box-body p strong {
        color: var(--primary-color);
        margin-right: 0.5rem;
    }

    .badge-contract-code {
        background-color: var(--primary-color);
        color: #ffffff;
        padding: 0.25rem 0.5rem;
        border-radius: 4px;
        font-size: 0.9rem;
        margin-left: 0.5rem;
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

    .btn-back {
        background-color: var(--primary-color);
        color: #ffffff;
        padding: 0.75rem 1.5rem;
        border-radius: 6px;
        font-size: 1rem;
        transition: background-color 0.2s ease;
    }

    .btn-back:hover {
        background-color: #3b82f6;
        color: #ffffff;
        text-decoration: none;
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
        .box-body p {
            font-size: 0.9rem;
        }

        .table-responsive {
            overflow-x: auto;
        }

        .table th, .table td {
            font-size: 0.85rem;
            padding: 0.75rem;
        }

        .btn-back {
            width: 100%;
            padding: 0.75rem;
        }
    }
</style>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Contract Detail <span class="badge-contract-code">${contract.contractCode}</span></h1>
        <ol class="breadcrumb">
            <li><a href="${pageContext.request.contextPath}/cskh/dashboard"><i class="fa fa-dashboard"></i> Home</a></li>
            <li><a href="${pageContext.request.contextPath}/cskh/contract_list">Contracts</a></li>
            <li class="active">Detail</li>
        </ol>
    </section>

    <section class="content">
        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title"><i class="fa fa-file-text-o" style="margin-right: 0.5rem;"></i> Contract Information</h3>
            </div>
            <div class="box-body">
                <p><strong><i class="fa fa-barcode"></i> Contract Code:</strong> ${contract.contractCode}</p>
                <p><strong><i class="fa fa-user"></i> Customer:</strong> ${contract.customerName}</p>
                <p><strong><i class="fa fa-calendar"></i> Date:</strong> <fmt:formatDate value="${contract.contractDate}" pattern="yyyy-MM-dd" /></p>
                <p><strong><i class="fa fa-dollar"></i> Total Amount:</strong> $<fmt:formatNumber value="${contract.totalAmount}" type="number" /></p>
                <p><strong><i class="fa fa-info-circle"></i> Description:</strong> 
                    <c:choose>
                        <c:when test="${not empty contract.description}">${contract.description}</c:when>
                        <c:otherwise><span style="color: var(--muted-color);">No description provided</span></c:otherwise>
                    </c:choose>
                </p>
            </div>
        </div>

        <div class="box box-success">
            <div class="box-header with-border">
                <h3 class="box-title"><i class="fa fa-cubes" style="margin-right: 0.5rem;"></i> Contract Items</h3>
            </div>
            <div class="box-body table-responsive">
                <table class="table table-bordered table-striped">
                    <thead>
                        <tr class="text-center">
                            <th>#</th>
                            <th>Product</th>
                            <th>Brand</th>
                            <th>Category</th>
                            <th>Quantity</th>
                            <th>Unit Price</th>
                            <th>Warranty (months)</th>
                            <th>Maintenance (months)</th>
                            <th>Frequency (months)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty items}">
                            <tr>
                                <td colspan="9" class="empty-state">
                                    <i class="fa fa-inbox"></i>
                                    <p>No contract items found.</p>
                                </td>
                            </tr>
                        </c:if>
                        <c:forEach var="i" items="${items}" varStatus="loop">
                            <tr>
                                <td>${loop.index + 1}</td>
                                <td>${i.productName}</td>
                                <td>${i.brandName}</td>
                                <td>${i.categoryName}</td>
                                <td>${i.quantity}</td>
                                <td>$<fmt:formatNumber value="${i.unitPrice}" type="number" /></td>
                                <td>${i.warrantyMonths}</td>
                                <td>${i.maintenanceMonths}</td>
                                <td>${i.maintenanceFrequencyMonths}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="text-center" style="margin-top: 20px;">
            <a href="${pageContext.request.contextPath}/cskh/contract" class="btn btn-back">
                <i class="fa fa-arrow-left" style="margin-right: 0.5rem;"></i> Back to List
            </a>
        </div>
    </section>
</div>

<%@ include file="/jsp/layout/footer2.jsp" %>