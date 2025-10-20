<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<%@ include file="/jsp/layout/header2.jsp" %>
<%@ include file="/jsp/layout/sidebar2.jsp" %>

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

    <c:if test="${totalPages > 1}">
        <div class="pagination-controls" style="display: flex; justify-content: end; align-items: center; gap: 6px; margin-top: 20px;">

            <button class="pagination-btn" ${page == 1 ? 'disabled' : ''}
                    onclick="window.location = '${pageContext.request.contextPath}/cskh/customer?page=${page - 1}&keyword=${param.keyword}&status=${param.status}'">
                <i class="fa fa-angle-left"></i>
            </button>

            <div id="pageNumber" style="display: flex; gap: 6px; align-items: center;">


                <button class="pagination-btn ${page == 1 ? 'active' : ''}"
                        onclick="window.location = '${pageContext.request.contextPath}/cskh/customer?page=1&keyword=${param.keyword}&status=${param.status}'">1</button>


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
                            onclick="window.location = '${pageContext.request.contextPath}/cskh/customer?page=${i}&keyword=${param.keyword}&status=${param.status}'">${i}</button>
                </c:forEach>

                <c:if test="${page < totalPages - 3}">
                    <span>...</span>
                </c:if>

                <c:if test="${totalPages > 1}">
                    <button class="pagination-btn ${page == totalPages ? 'active' : ''}"
                            onclick="window.location = '${pageContext.request.contextPath}/cskh/customer?page=${totalPages}&keyword=${param.keyword}&status=${param.status}'">${totalPages}</button>
                </c:if>
            </div>

            <button class="pagination-btn" ${page == totalPages ? 'disabled' : ''}
                    onclick="window.location = '${pageContext.request.contextPath}/cskh/customer?page=${page + 1}&keyword=${param.keyword}&status=${param.status}'">
                <i class="fa fa-angle-right"></i>
            </button>
        </div>
    </c:if>

</section>

<%@ include file="/jsp/layout/footer2.jsp" %>
