<%-- 
    Document   : contract_list
    Created on : Oct 10, 2025, 1:15:09 AM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/WEB-INF/jsp/layout/header2.jsp" %>
<%@ include file="/WEB-INF/jsp/layout/sidebar2.jsp" %>

<section class="content-header">
    <h1>Contract Management</h1>
    <ol class="breadcrumb">
        <li><a href="${pageContext.request.contextPath}/cskh/home"><i class="fa fa-dashboard"></i> CSKH</a></li>
        <li class="active">Contract List</li>
    </ol>
</section>

<section class="content">

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
            <a href="${pageContext.request.contextPath}/cskh/contract/add" class="btn btn-success">
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
                                        <a href="${pageContext.request.contextPath}/cskh/contract/view?id=${c.id}" class="btn btn-info btn-sm">
                                            <i class="fa fa-eye"></i> View
                                        </a>
                                        <a href="${pageContext.request.contextPath}/cskh/contract/edit?id=${c.id}" class="btn btn-warning btn-sm">
                                            <i class="fa fa-edit"></i> Edit
                                        </a>
                                        <a href="${pageContext.request.contextPath}/cskh/contract/delete?id=${c.id}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure to delete this contract?')">
                                            <i class="fa fa-trash"></i> Delete
                                        </a>
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
    <c:set var="totalPages" value="${(total + pageSize - 1) / pageSize}" />
    <c:if test="${totalPages > 1}">
        <nav aria-label="Page navigation" class="text-center mt-3">
            <ul class="pagination justify-content-center">
                <li class="${page==1?'disabled':''}">
                    <a href="${pageContext.request.contextPath}/cskh/contract?page=${page-1}&keyword=${param.keyword}&fromDate=${param.fromDate}&toDate=${param.toDate}" aria-label="Previous">
                        <span aria-hidden="true">&laquo;</span>
                    </a>
                </li>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="${i==page?'active':''}">
                        <a href="${pageContext.request.contextPath}/cskh/contract?page=${i}&keyword=${param.keyword}&fromDate=${param.fromDate}&toDate=${param.toDate}">${i}</a>
                    </li>
                </c:forEach>
                <li class="${page==totalPages?'disabled':''}">
                    <a href="${pageContext.request.contextPath}/cskh/contract?page=${page+1}&keyword=${param.keyword}&fromDate=${param.fromDate}&toDate=${param.toDate}" aria-label="Next">
                        <span aria-hidden="true">&raquo;</span>
                    </a>
                </li>
            </ul>
        </nav>
    </c:if>

</section>

<%@ include file="/WEB-INF/jsp/layout/footer2.jsp" %>

