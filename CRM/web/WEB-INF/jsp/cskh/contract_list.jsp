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
    <form method="get" action="${pageContext.request.contextPath}/cskh/contract" class="row mb-3">
        <div class="col-md-4">
            <input type="text" name="keyword" value="${param.keyword}" placeholder="Search contract code / description" class="form-control"/>
        </div>
        <div class="col-md-3">
            <input type="date" name="fromDate" value="${param.fromDate}" class="form-control" placeholder="From date" />
        </div>
        <div class="col-md-3">
            <input type="date" name="toDate" value="${param.toDate}" class="form-control" placeholder="To date" />
        </div>
        <div class="col-md-2">
            <button type="submit" class="btn btn-primary">Filter</button>
            <a href="${pageContext.request.contextPath}/cskh/contract" class="btn btn-secondary">Clear</a>
        </div>
    </form>

    <!-- Contract table -->
    <div class="box">
        <div class="box-body table-responsive">
            <table class="table table-bordered table-striped">
                <thead>
                    <tr>
                        <th>No.</th>
                        <th>Contract Code</th>
                        <th>Customer ID</th>
                        <th>Contract Date</th>
                        <th>Total Amount</th>
                        <th>Description</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="c" items="${contracts}" varStatus="st">
                        <tr>
                            <td>${(page - 1) * pageSize + st.index + 1}</td>
                            <td>${c.contractCode}</td>
                            <td>${c.customerId}</td>
                            <td><fmt:formatDate value="${c.contractDate}" pattern="yyyy-MM-dd"/></td>
                            <td><fmt:formatNumber value="${c.totalAmount}" type="number" minFractionDigits="0"/></td>
                            <td>${c.description}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/cskh/contract/view?id=${c.id}" class="btn btn-info btn-sm">View</a>
                                <a href="${pageContext.request.contextPath}/cskh/contract/edit?id=${c.id}" class="btn btn-warning btn-sm">Edit</a>
                                <a href="${pageContext.request.contextPath}/cskh/contract/delete?id=${c.id}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure to delete this contract?')">Delete</a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty contracts}">
                        <tr>
                            <td colspan="7" class="text-center">No contract found</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Pagination -->
    <c:set var="totalPages" value="${total div pageSize}" />
    <c:if test="${total mod pageSize > 0}">
        <c:set var="totalPages" value="${totalPages + 1}" />
    </c:if>

    <c:if test="${totalPages > 1}">
        <nav aria-label="Page navigation">
            <ul class="pagination">
                <li class="${page==1?'disabled':''}">
                    <a href="${pageContext.request.contextPath}/cskh/contract?page=${page-1}&keyword=${param.keyword}&fromDate=${param.fromDate}&toDate=${param.toDate}">&laquo;</a>
                </li>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="${i==page?'active':''}">
                        <a href="${pageContext.request.contextPath}/cskh/contract?page=${i}&keyword=${param.keyword}&fromDate=${param.fromDate}&toDate=${param.toDate}">${i}</a>
                    </li>
                </c:forEach>
                <li class="${page==totalPages?'disabled':''}">
                    <a href="${pageContext.request.contextPath}/cskh/contract?page=${page+1}&keyword=${param.keyword}&fromDate=${param.fromDate}&toDate=${param.toDate}">&raquo;</a>
                </li>
            </ul>
        </nav>
    </c:if>

</section>

<%@ include file="/WEB-INF/jsp/layout/footer2.jsp" %>

