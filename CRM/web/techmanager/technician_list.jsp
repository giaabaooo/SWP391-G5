<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/techmanager/layout/header.jsp" %>
<%@ include file="/techmanager/layout/sidebar_cskh.jsp" %>

<section class="content-header">
    <h1>Technician Management</h1>
    <ol class="breadcrumb">
        <li><a href="${pageContext.request.contextPath}/techmanager/dashboard.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
        <li class="active"><a href="${pageContext.request.contextPath}/techmanager/technician_list.jsp">Technician List</a></li>
    </ol>
</section>

<section class="content">

    <!-- Filter -->
    <form method="get" action="${pageContext.request.contextPath}/techmanager/technician" class="row mb-3">
        <input type="hidden" name="action" value="list"/>
        <div class="col-md-3">
            <input type="text" name="keyword" value="${param.keyword}" placeholder="Search username/email" class="form-control"/>
        </div>
<!--        <div class="col-md-3">
            <select name="role" class="form-control">
                <option value="">--Select Role--</option>
                <c:forEach var="r" items="${roles}">
                    <option value="${r.name}" ${param.role==r.name?"selected":""}>
                        ${r.name}
                    </option>
                </c:forEach>
            </select>
        </div>-->
        <div class="col-md-2">
            <select name="status" class="form-control">
                <option value="">--Status--</option>
                <option value="active" ${param.status=="active"?"selected":""}>Active</option>
                <option value="inactive" ${param.status=="inactive"?"selected":""}>Inactive</option>
            </select>
        </div>
        <div class="col-md-4">
            <button type="submit" class="btn btn-primary">Filter</button>
<!--            <a href="${pageContext.request.contextPath}/cskh/user?action=new" class="btn btn-success">+ Add User</a>-->
            <a href="${pageContext.request.contextPath}/cskh/user?action=list" class="btn btn-secondary">Clear</a>
        </div>
    </form>

    <!-- User table -->
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
<!--                        <th>Role</th>-->
                        <th>Status</th>
                        <th style="width:150px;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="u" items="${users}" varStatus="st">
                        <tr>
                            <td>${(page-1)*pageSize + st.index + 1}</td>
                            <td>${u.username}</td>
                            <td>${u.fullName}</td>
                            <td>${u.email}</td>
                            <td>${u.phone}</td>
<!--                            <td>${u.role.name}</td>-->
                            <td>
                                <span class="label ${u.isActive?'label-success':'label-danger'}">
                                    ${u.isActive?'Active':'Inactive'}
                                </span>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/cskh/user?action=edit&id=${u.id}" class="btn btn-xs btn-warning">
                                    <i class="fa fa-pencil"></i> Edit
                                </a>
                                <a href="${pageContext.request.contextPath}/cskh/user?action=delete&id=${u.id}" 
                                   class="btn btn-xs btn-danger"
                                   onclick="return confirm('Delete this user?');">
                                    <i class="fa fa-trash"></i> Delete
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty users}">
                        <tr><td colspan="8" class="text-center">No data found</td></tr>
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
                    <a href="${pageContext.request.contextPath}/cskh/user?action=list&page=${page-1}&keyword=${param.keyword}&role=${param.role}&status=${param.status}">&laquo;</a>
                </li>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="${i==page?'active':''}">
                        <a href="${pageContext.request.contextPath}/cskh/user?action=list&page=${i}&keyword=${param.keyword}&role=${param.role}&status=${param.status}">
                            ${i}
                        </a>
                    </li>
                </c:forEach>
                <li class="${page==totalPages?'disabled':''}">
                    <a href="${pageContext.request.contextPath}/cskh/user?action=list&page=${page+1}&keyword=${param.keyword}&role=${param.role}&status=${param.status}">&raquo;</a>
                </li>
            </ul>
        </nav>
    </c:if>

</section>

<%@ include file="/WEB-INF/jsp/layout/footer.jsp" %>
