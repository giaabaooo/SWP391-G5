<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="/cskh/layout/header.jsp" %>
<%@ include file="/cskh/layout/sidebar.jsp" %>

<div class="content-wrapper">
    <section class="content-header">
        <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">
            Contract Detail <span class="badge" style="background-color: #6366f1; font-size: 1rem; vertical-align: middle;">${contract.contractCode}</span>
        </h1>
        <ol class="breadcrumb" style="background: none; padding: 0; margin-bottom: 2rem;">
            <li><a href="${pageContext.request.contextPath}/cskh/dashboard"><i class="fa fa-dashboard"></i> Home</a></li>
            <li><a href="${pageContext.request.contextPath}/cskh/contract">Contracts</a></li>
            <li class="active">Detail</li>
        </ol>
    </section>

    <section class="content">
        <div class="content-card">
            <div class="card-header">
                <h3><i class="fa fa-file-text-o" style="margin-right: 0.5rem;"></i> Contract Information</h3>
            </div>

            <div class="card-body">
                <c:if test="${param.message == 'updated'}">
                    <div class="alert alert-success">
                        <i class="fa fa-check-circle"></i> Contract updated successfully!
                    </div>
                </c:if>
            
                <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                    <strong><i class="fa fa-barcode" style="color: #6366f1; width: 20px;"></i> Contract Code:</strong> ${contract.contractCode}
                </div>
                <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                    <strong><i class="fa fa-user" style="color: #6366f1; width: 20px;"></i> Customer:</strong> ${contract.customerName}
                </div>
                <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                    <strong><i class="fa fa-calendar" style="color: #6366f1; width: 20px;"></i> Date:</strong> <fmt:formatDate value="${contract.contractDate}" pattern="yyyy-MM-dd" />
                </div>
                <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                    <strong><i class="fa fa-dollar" style="color: #6366f1; width: 20px;"></i> Total Amount:</strong> $<fmt:formatNumber value="${contract.totalAmount}" type="number" />
                </div>
                <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                    <strong><i class="fa fa-info-circle" style="color: #6366f1; width: 20px;"></i> Description:</strong> 
                    <c:choose>
                        <c:when test="${not empty contract.description}">${contract.description}</c:when>
                        <c:otherwise><span style="color: #a0aec0;">No description provided</span></c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <div class="content-card">
            <div class="card-header">
                <h3><i class="fa fa-cubes" style="margin-right: 0.5rem;"></i> Contract Items</h3>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="inventory-table">
                        <thead>
                            <tr>
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
                                    <td colspan="9">
                                        <div class="empty-state" style="padding: 3rem; text-align: center; color: #718096;">
                                            <i class="fa fa-inbox" style="font-size: 3rem; margin-bottom: 1rem; color: #6366f1;"></i>
                                            <h4 style="font-size: 1.25rem; margin: 0;">No contract items found.</h4>
                                        </div>
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
        </div>

        <div class="text-center" style="margin-top: 20px;">
            <a href="${pageContext.request.contextPath}/cskh/contract" class="btn btn-default">
                <i class="fa fa-arrow-left" style="margin-right: 0.5rem;"></i> Back to List
            </a>

            <a href="${pageContext.request.contextPath}/cskh/updateContract?id=${contract.id}" 
               class="btn btn-warning">
                <i class="fa fa-pencil" style="margin-right: 0.5rem;"></i> Edit Contract
            </a>
        </div>
    </section>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
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

<%@ include file="/cskh/layout/footer.jsp" %>