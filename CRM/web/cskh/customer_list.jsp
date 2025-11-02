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
    
    <div class="content-card">
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/cskh/customer" class="row">
                <div class="col-md-4 mb-2 mb-md-0">
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-search"></i></span>
                        <input type="text" name="keyword" value="${param.keyword}" placeholder="Search username/email" class="form-control"/>
                    </div>
                </div>
                <div class="col-md-3 mb-2 mb-md-0">
                    <select name="status" class="form-control">
                        <option value="">-- Select Status --</option>
                        <option value="active" ${param.status=='active'?'selected':''}>Active</option>
                        <option value="inactive" ${param.status=='inactive'?'selected':''}>Inactive</option>
                    </select>
                </div>
                <div class="col-md-5">
                    <button type="submit" class="btn btn-primary"><i class="fa fa-filter"></i> Filter</button>
                    <a href="${pageContext.request.contextPath}/cskh/customer" class="btn btn-secondary"><i class="fa fa-times"></i> Clear</a>
                </div>
            </form>
        </div>
    </div>

    <div class="content-card">
        <div class="card-body" style="padding: 0;">
            <div class="table-responsive">
                <table class="table modern-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Username
                                <a href="${pageContext.request.contextPath}/cskh/customer?page=1&sort=username_asc&keyword=${param.keyword}&status=${param.status}">
                                    <i class="fa fa-arrow-up ${sort=='username_asc'?'text-primary':''}" title="Sort A-Z"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/cskh/customer?page=1&sort=username_desc&keyword=${param.keyword}&status=${param.status}">
                                    <i class="fa fa-arrow-down ${sort=='username_desc'?'text-primary':''}" title="Sort Z-A"></i>
                                </a>
                            </th>
                            <th>Full Name
                                <a href="${pageContext.request.contextPath}/cskh/customer?page=1&sort=fullname_asc&keyword=${param.keyword}&status=${param.status}">
                                    <i class="fa fa-arrow-up ${sort=='fullname_asc'?'text-primary':''}" title="Sort A-Z"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/cskh/customer?page=1&sort=fullname_desc&keyword=${param.keyword}&status=${param.status}">
                                    <i class="fa fa-arrow-down ${sort=='fullname_desc'?'text-primary':''}" title="Sort Z-A"></i>
                                </a>
                            </th>
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
                                    <span class="status-label ${u.isActive?'status-success':'status-critical'}">
                                        <i class="fa ${u.isActive?'fa-check-circle':'fa-times-circle'}"></i> ${u.isActive?'Active':'Inactive'}
                                    </span>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/cskh/customer/view?id=${u.id}" class="btn btn-info btn-sm">
                                        <i class="fa fa-eye"></i> View
                                    </a>
                                    <form action="${pageContext.request.contextPath}/cskh/customer" method="post" style="display:inline;">
                                        <input type="hidden" name="id" value="${u.id}" />
                                        <button type="submit" class="btn btn-${u.isActive?'danger':'success'} btn-sm">
                                            <i class="fa ${u.isActive?'fa-times-circle':'fa-check-circle'}"></i>
                                            ${u.isActive?'Inactive':'Active'}
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty customers}">
                            <tr>
                                <td colspan="7" style="text-align: center; padding: 2.5rem; color: #718096;">
                                    <i class="fa fa-inbox" style="font-size: 2.5rem; margin-bottom: 1rem; color: #667eea;"></i>
                                    <p>No customers found.</p>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <c:if test="${totalPages > 1}">
        <div class="pagination-controls">
            <span style="font-size: 0.9rem; color: #718096; margin-right: 1rem; align-self: center;">
                Showing ${(page-1)*pageSize + 1} to ${page*pageSize > totalItems ? totalItems : page*pageSize} of ${totalItems} customers
            </span>
            <div style="display: flex; gap: 8px; align-items: center;">
                <button class="pagination-btn" ${page == 1 ? 'disabled' : ''}
                        onclick="window.location = '${pageContext.request.contextPath}/cskh/customer?page=${page - 1}&keyword=${param.keyword}&status=${param.status}&sort=${param.sort}'">
                    <i class="fa fa-angle-left"></i>
                </button>

                <button class="pagination-btn ${page == 1 ? 'active' : ''}"
                        onclick="window.location = '${pageContext.request.contextPath}/cskh/customer?page=1&keyword=${param.keyword}&status=${param.status}&sort=${param.sort}'">1</button>

                <c:if test="${page > 4}">
                    <span style="padding: 0.5rem; color: #718096;">...</span>
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
                            onclick="window.location = '${pageContext.request.contextPath}/cskh/customer?page=${i}&keyword=${param.keyword}&status=${param.status}&sort=${param.sort}'">${i}</button>
                </c:forEach>

                <c:if test="${page < totalPages - 3}">
                    <span style="padding: 0.5rem; color: #718096;">...</span>
                </c:if>

                <c:if test="${totalPages > 1}">
                    <button class="pagination-btn ${page == totalPages ? 'active' : ''}"
                            onclick="window.location = '${pageContext.request.contextPath}/cskh/customer?page=${totalPages}&keyword=${param.keyword}&status=${param.status}&sort=${param.sort}'">${totalPages}</button>
                </c:if>

                <button class="pagination-btn" ${page == totalPages ? 'disabled' : ''}
                        onclick="window.location = '${pageContext.request.contextPath}/cskh/customer?page=${page + 1}&keyword=${param.keyword}&status=${param.status}&sort=${param.sort}'">
                    <i class="fa fa-angle-right"></i>
                </button>
            </div>
        </div>
    </c:if>
</section>

<%@ include file="/jsp/layout/footer2.jsp" %>