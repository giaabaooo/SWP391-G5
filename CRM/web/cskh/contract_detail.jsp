<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="/jsp/layout/header2.jsp" %>
<%@ include file="/jsp/layout/sidebar2.jsp" %>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Contract Detail</h1>
        <ol class="breadcrumb">
            <li><a href="${pageContext.request.contextPath}/cskh/dashboard"><i class="fa fa-dashboard"></i> Home</a></li>
            <li><a href="${pageContext.request.contextPath}/cskh/contract_list">Contracts</a></li>
            <li class="active">Detail</li>
        </ol>
    </section>

    <section class="content">
        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title">Contract Information</h3>
            </div>
            <div class="box-body">
                <p><strong>Contract Code:</strong> ${contract.contractCode}</p>
                <p><strong>Customer:</strong> ${contract.customerName}</p>
                <p><strong>Date:</strong> <fmt:formatDate value="${contract.contractDate}" pattern="yyyy-MM-dd" /></p>
                <p><strong>Total Amount:</strong> $<fmt:formatNumber value="${contract.totalAmount}" type="number" /></p>
                <p><strong>Description:</strong> ${contract.description}</p>
            </div>
        </div>

        <div class="box box-success">
            <div class="box-header with-border">
                <h3 class="box-title">Contract Items</h3>
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
                            <tr><td colspan="9" class="text-center text-muted">No contract items.</td></tr>
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
            <a href="${pageContext.request.contextPath}/cskh/contract" class="btn btn-default">
                <i class="fa fa-arrow-left"></i> Back to List
            </a>
        </div>
    </section>
</div>

<%@ include file="/jsp/layout/footer2.jsp" %>