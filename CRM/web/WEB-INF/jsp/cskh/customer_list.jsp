<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/jsp/layout/header.jsp" %>
<%@ include file="/WEB-INF/jsp/layout/sidebar_cskh.jsp" %>

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
        <div class="col-md-4">
            <input type="text" name="keyword" value="${param.keyword}" placeholder="Search username/email" class="form-control"/>
        </div>
        <div class="col-md-3">
            <select name="status" class="form-control">
                <option value="">--Status--</option>
                <option value="active" ${param.status=='active'?'selected':''}>Active</option>
                <option value="inactive" ${param.status=='inactive'?'selected':''}>Inactive</option>
            </select>
        </div>
        <div class="col-md-5">
            <button type="submit" class="btn btn-primary">Filter</button>
            <a href="${pageContext.request.contextPath}/cskh/customer" class="btn btn-secondary">Clear</a>
            <a href="${pageContext.request.contextPath}/cskh/customer/create" class="btn btn-success">Add New Customer</a>
        </div>
    </form>

    <!-- Customer table -->
    <div class="box">
        <div class="box-body table-responsive">
            <table class="table table-bordered table-striped">
                <thead>
                    <tr>
                        <th>No.</th>
                        <th>Username</th>
                        <th>Full Name</th>
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
                                    ${u.isActive?'Active':'Inactive'}
                                </span>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/cskh/customer/view?id=${u.id}" class="btn btn-info btn-sm">View</a>
                                <a href="${pageContext.request.contextPath}/cskh/customer/edit?id=${u.id}" class="btn btn-warning btn-sm">Edit</a>
                                <a href="${pageContext.request.contextPath}/cskh/customer/delete?id=${u.id}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?')">Delete</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty customers}">
                        <tr>
                            <td colspan="7" class="text-center">No data found</td>
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
                    <a href="${pageContext.request.contextPath}/cskh/customer?page=${page-1}&keyword=${param.keyword}&status=${param.status}">&laquo;</a>
                </li>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="${i==page?'active':''}">
                        <a href="${pageContext.request.contextPath}/cskh/customer?page=${i}&keyword=${param.keyword}&status=${param.status}">${i}</a>
                    </li>
                </c:forEach>
                <li class="${page==totalPages?'disabled':''}">
                    <a href="${pageContext.request.contextPath}/cskh/customer?page=${page+1}&keyword=${param.keyword}&status=${param.status}">&raquo;</a>
                </li>
            </ul>
        </nav>
    </c:if>

</section>

<%@ include file="/WEB-INF/jsp/layout/footer.jsp" %>
