<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/jsp/layout/header2.jsp" %>
<%@ include file="/jsp/layout/sidebar2.jsp" %>

<section class="content-header">
    <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">Customer Details</h1>
    <ol class="breadcrumb">
        <li><a href="${pageContext.request.contextPath}/cskh/home"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="${pageContext.request.contextPath}/cskh/customer">Customer List</a></li>
        <li class="active">Customer Details</li>
    </ol>
</section>

<section class="content">

    <div style="margin-bottom: 15px;">
        <a href="${pageContext.request.contextPath}/cskh/customer" class="btn btn-secondary">
            <i class="fa fa-arrow-left"></i> Back to list
        </a>
    </div>

    <div class="content-card">
        <div class="card-header">
            <h3>Customer Information</h3>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-6">
                    <p><strong>Username:</strong> ${customer.username}</p>
                    <p><strong>Full Name:</strong> ${customer.fullName}</p>
                    <p><strong>Email:</strong> ${customer.email}</p>
                </div>
                <div class="col-md-6">
                    <p><strong>Phone:</strong> ${customer.phone}</p>
                    <p><strong>Address:</strong> ${customer.address}</p>

                    <p><strong>Status:</strong>
                        <span class="status-label ${customer.isIsActive()?'status-success':'status-critical'}">
                            <i class="fa ${customer.isIsActive()?'fa-check-circle':'fa-times-circle'}"></i> 
                            ${customer.isIsActive()?'Active':'Inactive'}
                        </span>
                    </p>
                </div>
            </div>
        </div>
    </div>

    <div class="content-card">
        <div class="card-header">
            <h3>Contract List</h3>
        </div>
        <div class="card-body" style="padding: 0;">
            <div class="table-responsive">
                <table class="table modern-table table-bordered table-hover">
                    <thead>
                        <tr>
                            <th>Contract Code</th>
                            <th>Contract Date</th>
                            <th>Total Amount</th>
                            <th>Description</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty contracts}">
                            <tr>
                                <td colspan="5" class="text-center">This customer does not have any contracts yet.</td>
                            </tr>
                        </c:if>

                        <c:forEach var="c" items="${contracts}">
                            <tr>
                                <td>${c.contractCode}</td>
                                <td>
                                    <fmt:formatDate value="${c.contractDate}" pattern="dd/MM/yyyy" />
                                </td>
                                <td>
                                    <fmt:formatNumber value="${c.totalAmount}" type="currency" currencyCode="VND" />
                                </td>
                                <td>${c.description}</td>
                                <td>
                                    <span class="status-label ${c.isIsActive()?'status-success':'status-critical'}">
                                        <i class="fa ${c.isIsActive()?'fa-check-circle':'fa-times-circle'}"></i> 
                                        ${c.isIsActive()?'Active':'Inactive'}
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</section>
<%@ include file="/jsp/layout/footer2.jsp" %>