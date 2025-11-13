<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/cskh/layout/header.jsp" %>
<%@ include file="/cskh/layout/sidebar.jsp" %>

<section class="content-header" style="padding: 15px 15px 15px 20px; background: #f9f9f9; border-bottom: 1px solid #eee;">
    <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">Guest Contact Inbox</h1>
    <ol class="breadcrumb" style="background: none; padding: 0; margin-bottom: 2rem;">
        <li><a href="${pageContext.request.contextPath}/cskh/dashboard"><i class="fa fa-dashboard"></i> Home</a></li>
        <li class="active">Guest Contact</li>
    </ol>
</section>

<c:if test="${not empty sessionScope.adminMessage}">
    <div class="alert alert-success" style="margin: 20px; border-radius: 8px;">
        <i class="fa fa-check-circle"></i> ${sessionScope.adminMessage}
    </div>
    <c:remove var="adminMessage" scope="session" />
</c:if>
<c:if test="${not empty sessionScope.adminError}">
    <div class="alert alert-danger" style="margin: 20px; border-radius: 8px;">
        <i class="fa fa-exclamation-triangle"></i> ${sessionScope.adminError}
    </div>
    <c:remove var="adminError" scope="session" />
</c:if>

<div class="content-card" style="margin: 20px;">
    <div class="card-header">
        <h3><i class="fa fa-filter" style="margin-right: 0.5rem;"></i> Filter Contacts</h3>
    </div>
    <div class="card-body filter-bar" style="padding: 1.5rem; background: #fafbfc;">
        <form method="get" action="${pageContext.request.contextPath}/cskh/contacts" style="display: flex; align-items: center; gap: 15px;">
            <label for="statusFilter" style="font-weight: 500; margin-bottom: 0;">Status:</label>
            <select name="status" id="statusFilter" class="form-control-modern" style="width: 150px;">
                <option value="">-- All --</option>
                <option value="NEW" ${requestScope.statusFilter eq 'NEW' ? 'selected' : ''}>NEW</option>
                <option value="READ" ${requestScope.statusFilter eq 'READ' ? 'selected' : ''}>READ</option>
            </select>

            <label for="dateFromFilter" style="font-weight: 500; margin-bottom: 0;">From:</label>
            <input type="date" name="dateFrom" id="dateFromFilter" value="${requestScope.dateFromFilter}" class="form-control-modern" style="width: 180px;">

            <label for="dateToFilter" style="font-weight: 500; margin-bottom: 0;">To:</label>
            <input type="date" name="dateTo" id="dateToFilter" value="${requestScope.dateToFilter}" class="form-control-modern" style="width: 180px;">

            <button type="submit" class="btn btn-primary" style="background: #007bff; border-color: #007bff;">
                <i class="fa fa-filter"></i> Filter
            </button>
            <a href="${pageContext.request.contextPath}/cskh/contacts" class="btn btn-primary" style="background: #6c757d; border-color: #6c757d;">
                <i class="fa fa-times"></i> Clear
            </a>
        </form>
    </div>
</div>

<div class="content-card" style="margin: 20px;">
    <div class="card-header" style="background-color: #fafbfc;"> <h3><i class="fa fa-inbox"></i> All Messages</h3> </div>
    <div class="card-body" style="padding: 0;">
        <table class="table modern-table" style="margin-bottom: 0;">
            <thead>
                <tr>
                    <th style="width: 50px;">#</th>
                    <th style="width: 100px;">Status</th>
                    <th style="width: 150px;">Received At</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Message</th>
                    <th style="width: 150px;">Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="contact" items="${requestScope.contactList}" varStatus="loop">
                    <tr style="${contact.status == 'NEW' ? 'font-weight: 600; background-color: #fffbe6;' : ''}">
                        <td>${(page-1)*pageSize + loop.index + 1}</td>
                        <td>
                            <c:if test="${contact.status == 'NEW'}">
                                <span class="status-label status-critical">NEW</span> </c:if>
                            <c:if test="${contact.status == 'READ'}">
                                <span class="status-label status-info">READ</span> </c:if>
                            </td>
                            <td>
                            <fmt:formatDate value="${contact.submissionDate}" pattern="HH:mm' - 'dd/MM/yyyy" />
                        </td>
                        <td>${contact.fullName}</td>
                        <td>${contact.email}</td>
                        <td>${contact.phone}</td>
                        <td>
                            <div style="max-height: 100px; overflow-y: auto; white-space: pre-wrap; font-weight: 400;">
                                ${contact.message}
                            </div>
                        </td>
                        <td>
                            <c:if test="${contact.status == 'NEW'}">
                                <form action="${pageContext.request.contextPath}/cskh/contacts" method="POST" style="margin: 0;">
                                    <input type="hidden" name="contactId" value="${contact.id}">
                                    <input type="hidden" name="page" value="${page}">
                                    <input type="hidden" name="status" value="${requestScope.statusFilter}">
                                    <input type="hidden" name="dateFrom" value="${requestScope.dateFromFilter}">
                                    <input type="hidden" name="dateTo" value="${requestScope.dateToFilter}">
                                    <button type="submit" class="btn btn-sm btn-approve" style="background-color: #007bff; color: white;">
                                        <i class="fa fa-check"></i> Mark as Read
                                    </button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty requestScope.contactList}">
                    <tr>
                        <td colspan="8">
                            <div class="empty-state" style="padding: 3rem; text-align: center; color: #718096;">
                                <i class="fa fa-inbox" style="font-size: 3rem; margin-bottom: 1rem; color: #6366f1;"></i>
                                <h4 style="font-size: 1.25rem; margin: 0;">No contacts found matching your criteria.</h4>
                            </div>
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>

        <c:if test="${totalPages > 0}">
            <div class="pagination-controls" style="display: flex; justify-content: space-between; align-items: center; width: 100%; padding: 1rem 1.5rem; border-top: 1px solid #f1f3f4;">
                <div class="pagination-info">
                    Showing ${(page-1)*pageSize + 1} to ${page*pageSize > totalItems ? totalItems : page*pageSize} of ${totalItems} contacts
                </div>

                <div class="pagination-controls">
                    <c:url var="paginationUrl" value="${pageContext.request.contextPath}/cskh/contacts">
                        <c:param name="status" value="${requestScope.statusFilter}" />
                        <c:param name="dateFrom" value="${requestScope.dateFromFilter}" />
                        <c:param name="dateTo" value="${requestScope.dateToFilter}" />
                    </c:url>

                    <button class="pagination-btn" ${page == 1 ? 'disabled' : ''}
                            onclick="window.location = '${paginationUrl}&page=${page - 1}'">
                        <i class="fa fa-angle-left"></i>
                    </button>

                    <button class="pagination-btn ${page == 1 ? 'active' : ''}"
                            onclick="window.location = '${paginationUrl}&page=1'">1</button>

                    <c:if test="${page > 4}"><span>...</span></c:if>
                    <c:set var="startPage" value="${page - 2}" />
                    <c:set var="endPage" value="${page + 2}" />
                    <c:if test="${startPage < 2}"><c:set var="startPage" value="2" /></c:if>
                    <c:if test="${endPage > totalPages - 1}"><c:set var="endPage" value="${totalPages - 1}" /></c:if>

                    <c:forEach var="i" begin="${startPage}" end="${endPage}">
                        <button class="pagination-btn ${i == page ? 'active' : ''}"
                                onclick="window.location = '${paginationUrl}&page=${i}'">${i}</button>
                    </c:forEach>
                    <c:if test="${page < totalPages - 3}"><span>...</span></c:if>
                    <c:if test="${totalPages > 1}">
                        <button class="pagination-btn ${page == totalPages ? 'active' : ''}"
                                onclick="window.location = '${paginationUrl}&page=${totalPages}'">${totalPages}</button>
                    </c:if>
                    <button class="pagination-btn" ${page == totalPages ? 'disabled' : ''}
                            onclick="window.location = '${paginationUrl}&page=${page + 1}'">
                        <i class="fa fa-angle-right"></i>
                    </button>
                </div>
            </div>
        </c:if>

    </div>
</div>
<%@ include file="/cskh/layout/footer.jsp" %>