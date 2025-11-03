<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="/jsp/layout/header2.jsp" %>
<%@ include file="/jsp/layout/sidebar2.jsp" %>

<div class="content-wrapper" style="background: #ffffff;"> <section class="content-header">
        <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">Customer Requests</h1>
        <ol class="breadcrumb" style="background: none; padding: 0; margin-bottom: 2rem;">
            <li><a href="${pageContext.request.contextPath}/cskh/dashboard"><i class="fa fa-dashboard"></i> Home</a></li>
            <li class="active">Customer Requests</li>
        </ol>
    </section>

    <section class="content">
        <div class="content-card">
            <div class="card-header">
                <h3><i class="fa fa-filter" style="margin-right: 0.5rem;"></i> Filter Requests</h3>
            </div>

            <div class="filter-bar">
                <form method="get" action="${pageContext.request.contextPath}/cskh/customer-request">

                    <label for="typeFilter" style="font-weight: 500;">Request Type:</label>
                    <select name="type" id="typeFilter" class="search-input" style="min-width: 150px;">
                        <option value="">-- All --</option>
                        <option value="WARRANTY" ${param.type eq 'WARRANTY' ? 'selected' : ''}>Warranty</option>
                        <option value="MAINTENANCE" ${param.type eq 'MAINTENANCE' ? 'selected' : ''}>Maintenance</option>
                        <option value="REPAIR" ${param.type eq 'REPAIR' ? 'selected' : ''}>Repair</option>
                    </select>

                    <label for="statusFilter" style="font-weight: 500;">Status:</label>
                    <select name="status" id="statusFilter" class="search-input" style="min-width: 150px;">
                        <option value="">-- All --</option>
                        <option value="PENDING" ${param.status eq 'PENDING' ? 'selected' : ''}>Pending</option>
                        <option value="TRANSFERRED" ${param.status eq 'TRANSFERRED' ? 'selected' : ''}>Transferred</option>
                        <option value="ASSIGNED" ${param.status eq 'ASSIGNED' ? 'selected' : ''}>Assigned</option>
                        <option value="IN_PROGRESS" ${param.status eq 'IN_PROGRESS' ? 'selected' : ''}>In Progress</option>
                        <option value="COMPLETED" ${param.status eq 'COMPLETED' ? 'selected' : ''}>Completed</option>
                        <option value="CANCELLED" ${param.status eq 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                    </select>

                    <label for="priorityFilter" style="font-weight: 500;">Priority:</label>
                    <select name="priority" id="priorityFilter" class="search-input" style="min-width: 150px;">
                        <option value="">-- All --</option>
                        <option value="LOW" ${param.priority eq 'LOW' ? 'selected' : ''}>Low</option>
                        <option value="MEDIUM" ${param.priority eq 'MEDIUM' ? 'selected' : ''}>Medium</option>
                        <option value="HIGH" ${param.priority eq 'HIGH' ? 'selected' : ''}>High</option>
                        <option value="URGENT" ${param.priority eq 'URGENT' ? 'selected' : ''}>Urgent</option>
                    </select>

                    <label for="paymentFilter" style="font-weight: 500;">Payment Status:</label>
                    <select name="paymentStatus" id="paymentFilter" class="search-input" style="min-width: 150px;">
                        <option value="">-- All --</option>
                        <option value="UNPAID" ${param.paymentStatus eq 'UNPAID' ? 'selected' : ''}>Unpaid</option>
                        <option value="PARTIALLY_PAID" ${param.paymentStatus eq 'PARTIALLY_PAID' ? 'selected' : ''}>Partially Paid</option>
                        <option value="PAID" ${param.paymentStatus eq 'PAID' ? 'selected' : ''}>Paid</option>
                    </select>

                    <button type="submit" class="btn btn-primary">
                        <i class="fa fa-filter"></i> Filter
                    </button>
                    <a href="${pageContext.request.contextPath}/cskh/customer-request" class="btn btn-primary" style="background: #6c757d; border-color: #6c757d;">
                        <i class="fa fa-times"></i> Clear
                    </a>        
                </form>
            </div>
        </div>

        <div class="content-card">
            <div class="card-header">
                <h3><i class="fa fa-table" style="margin-right: 0.5rem;"></i> Request List</h3>
            </div>

            <div class="card-body">
                <div class="table-responsive">
                    <table class="inventory-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th><i class="fa fa-user" style="margin-right: 0.5rem;"></i>Customer</th>
                                <th><i class="fa fa-cube" style="margin-right: 0.5rem;"></i>Device</th>
                                <th><i class="fa fa-tag" style="margin-right: 0.5rem;"></i>Title</th>
                                <th><i class="fa fa-list" style="margin-right: 0.5rem;"></i>Request Type</th>
                                <th><i class="fa fa-calendar" style="margin-right: 0.5rem;"></i>Request Date</th>
                                <th><i class="fa fa-info" style="margin-right: 0.5rem;"></i>Status</th>
                                <th><i class="fa fa-sort-amount-asc" style="margin-right: 0.5rem;"></i>Priority</th>
                                <th><i class="fa fa-cogs" style="margin-right: 0.5rem;"></i>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty requests}">
                                <tr>
                                    <td colspan="13">
                                        <div class="empty-state" style="padding: 3rem; text-align: center; color: #718096;">
                                            <i class="fa fa-inbox" style="font-size: 3rem; margin-bottom: 1rem; color: #6366f1;"></i>
                                            <h4 style="font-size: 1.25rem; margin: 0;">No requests found.</h4>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>

                            <c:forEach var="r" items="${requests}" varStatus="loop">
                                <tr>
                                    <td>${(page-1)*pageSize + loop.index + 1}</td>
                                    <td>${r.customer.fullName}</td>
                                    <td>${r.device.productName}</td>
                                    <td>${r.title}</td>
                                    <td>
                                        <span class="status-label
                                              ${r.request_type eq 'REPAIR' ? 'status-warning' :
                                                r.request_type eq 'WARRANTY' ? 'status-info' :
                                                r.request_type eq 'MAINTENANCE' ? 'status-success' : ''}">
                                                  ${r.request_type}
                                              </span>
                                        </td>
                                        <td><fmt:formatDate value="${r.request_date}" pattern="yyyy-MM-dd HH:mm" /></td>
                                        <td>
                                            <span class="status-label
                                                  ${r.status eq 'PENDING' ? 'status-warning' :
                                                    r.status eq 'TRANSFERRED' ? 'status-info' :
                                                    r.status eq 'ASSIGNED' ? 'status-info' :
                                                    r.status eq 'IN_PROGRESS' ? 'status-info' :
                                                    r.status eq 'COMPLETED' ? 'status-success' :
                                                    r.status eq 'CANCELLED' ? 'status-critical' : ''}">
                                                <i class="fa ${r.status eq 'PENDING' ? 'fa-clock-o' :
                                                               r.status eq 'TRANSFERRED' ? 'fa-share' :
                                                               r.status eq 'ASSIGNED' ? 'fa-user-plus' :
                                                               r.status eq 'IN_PROGRESS' ? 'fa-cog' :
                                                               r.status eq 'COMPLETED' ? 'fa-check-circle' :
                                                               r.status eq 'CANCELLED' ? 'fa-times-circle' : 'fa-circle'}"></i>
                                                   ${r.status}
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty r.priority}">
                                                        <span class="status-label
                                                              ${r.priority eq 'URGENT' ? 'status-critical' :
                                                                r.priority eq 'HIGH' ? 'status-warning' :
                                                                r.priority eq 'MEDIUM' ? 'status-info' :
                                                                r.priority eq 'LOW' ? 'status-success' : ''}">
                                                                  ${r.priority}
                                                              </span>
                                                        </c:when>
                                                        <c:otherwise>N/A</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${r.status eq 'PENDING'}">
                                                            <form method="post" action="${pageContext.request.contextPath}/cskh/customer-request" style="display:inline;">
                                                                <input type="hidden" name="action" value="transferToTechManager" />
                                                                <input type="hidden" name="id" value="${r.id}" />
                                                                <button type="submit" class="btn btn-action btn-edit" style="text-decoration: none;">
                                                                    <i class="fa fa-share"></i> Transfer
                                                                </button>
                                                            </form>
                                                        </c:when>
                                                        <c:when test="${r.status eq 'PAID' || (r.status eq 'COMPLETED' && (empty r.requestMeta || r.requestMeta.total_cost == 0))}">
                                                            <form method="post" action="${pageContext.request.contextPath}/cskh/customer-request" style="display:inline;">
                                                                <input type="hidden" name="action" value="closeRequest" />
                                                                <input type="hidden" name="id" value="${r.id}" />
                                                                <button type="submit" class="btn btn-action" style="text-decoration: none; background-color: #059669; color: white;">
                                                                    <i class="fa fa-check-square-o"></i> Close
                                                                </button>
                                                            </form>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button class="btn btn-action" disabled>
                                                                <c:choose>
                                                                    <c:when test="${r.status eq 'CLOSED' || r.status eq 'CANCELLED'}">
                                                                        <i class="fa fa-ban"></i> ${r.status}
                                                                    </c:when>
                                                                    <c:when test="${r.status eq 'TRANSFERRED' || r.status eq 'ASSIGNED' || r.status eq 'IN_PROGRESS'}">
                                                                        <i class="fa fa-cog"></i> In Progress
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <i class="fa fa-clock-o"></i> ${r.status}
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <a href="${pageContext.request.contextPath}/cskh/customer-request/detail?id=${r.id}" class="btn btn-action btn-view" style="text-decoration: none;">
                                                        <i class="fa fa-eye"></i> View
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div> <c:if test="${totalPages > 0}">
                                <div class="pagination-controls" style="display: flex; justify-content: space-between; align-items: center; width: 100%;">
                                    <div class="pagination-info">
                                        Showing ${(page-1)*pageSize + 1} to ${page*pageSize > totalItems ? totalItems : page*pageSize} of ${totalItems} requests
                                    </div>

                                    <div class="pagination-controls">
                                        <button class="pagination-btn" ${page == 1 ? 'disabled' : ''}
                                                onclick="window.location = '${pageContext.request.contextPath}/cskh/customer-request?page=${page - 1}&type=${param.type}&status=${param.status}&priority=${param.priority}&paymentStatus=${param.paymentStatus}'">
                                            <i class="fa fa-angle-left"></i>
                                        </button>

                                        <button class="pagination-btn ${page == 1 ? 'active' : ''}"
                                                onclick="window.location = '${pageContext.request.contextPath}/cskh/customer-request?page=1&type=${param.type}&status=${param.status}&priority=${param.priority}&paymentStatus=${param.paymentStatus}'">1</button>

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
                                                    onclick="window.location = '${pageContext.request.contextPath}/cskh/customer-request?page=${i}&type=${param.type}&status=${param.status}&priority=${param.priority}&paymentStatus=${param.paymentStatus}'">${i}</button>
                                        </c:forEach>

                                        <c:if test="${page < totalPages - 3}">
                                            <span>...</span>
                                        </c:if>

                                        <c:if test="${totalPages > 1}">
                                            <button class="pagination-btn ${page == totalPages ? 'active' : ''}"
                                                    onclick="window.location = '${pageContext.request.contextPath}/cskh/customer-request?page=${totalPages}&type=${param.type}&status=${param.status}&priority=${param.priority}&paymentStatus=${param.paymentStatus}'">${totalPages}</button>
                                        </c:if>

                                        <button class="pagination-btn" ${page == totalPages ? 'disabled' : ''}
                                                onclick="window.location = '${pageContext.request.contextPath}/cskh/customer-request?page=${page + 1}&type=${param.type}&status=${param.status}&priority=${param.priority}&paymentStatus=${param.paymentStatus}'">
                                            <i class="fa fa-angle-right"></i>
                                        </button>
                                    </div>
                                </div>
                            </c:if>

                        </div> </div> </section>
            </div>

            <%@ include file="/jsp/layout/footer2.jsp" %>