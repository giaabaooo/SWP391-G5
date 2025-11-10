<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="/cskh/layout/header.jsp" %>
<%@ include file="/cskh/layout/sidebar.jsp" %>

<div class="content-wrapper" style="background: #ffffff;">
    <section class="content-header">
        <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">Feedback Inbox</h1>
        <ol class="breadcrumb" style="background: none; padding: 0; margin-bottom: 2rem;">
            <li><a href="${pageContext.request.contextPath}/cskh/dashboard"><i class="fa fa-dashboard"></i> Home</a></li>
            <li class="active">Feedback List</li>
        </ol>
    </section>

    <section class="content">
        <c:if test="${param.message == 'responseSaved'}">
            <div class="alert alert-success" style="display: flex; align-items: center;">
                <i class="fa fa-check-circle" style="margin-right: 10px; font-size: 1.2rem;"></i> 
                Feedback response saved successfully!
            </div>
        </c:if>
        <div class="content-card">
            <div class="card-header">
                <h3><i class="fa fa-filter" style="margin-right: 0.5rem;"></i> Filter Feedbacks</h3>
            </div>

            <div class="filter-bar">
                <form method="get" action="${pageContext.request.contextPath}/cskh/feedback">

                    <label for="responseStatusFilter" style="font-weight: 500;">Response Status:</label>
                    <select name="responseStatus" id="responseStatusFilter" class="search-input" style="min-width: 150px;">
                        <option value="">-- All --</option>
                        <option value="not_responded" ${param.responseStatus eq 'not_responded' ? 'selected' : ''}>Not Responded</option>
                        <option value="responded" ${param.responseStatus eq 'responded' ? 'selected' : ''}>Responded</option>
                    </select>

                    <label for="ratingFilter" style="font-weight: 500;">Rating:</label>
                    <select name="rating" id="ratingFilter" class="search-input" style="min-width: 150px;">
                        <option value="">-- All --</option>
                        <option value="1" ${param.rating eq '1' ? 'selected' : ''}>1 Star</option>
                        <option value="2" ${param.rating eq '2' ? 'selected' : ''}>2 Stars</option>
                        <option value="3" ${param.rating eq '3' ? 'selected' : ''}>3 Stars</option>
                        <option value="4" ${param.rating eq '4' ? 'selected' : ''}>4 Stars</option>
                        <option value="5" ${param.rating eq '5' ? 'selected' : ''}>5 Stars</option>
                    </select>

                    <button type="submit" class="btn btn-primary">
                        <i class="fa fa-filter"></i> Filter
                    </button>
                    <a href="${pageContext.request.contextPath}/cskh/feedback" class="btn btn-primary" style="background: #6c757d; border-color: #6c757d;">
                        <i class="fa fa-times"></i> Clear
                    </a>
                </form>
            </div>
        </div>

        <div class="content-card">
            <div class="card-header">
                <h3><i class="fa fa-table" style="margin-right: 0.5rem;"></i> Feedback List</h3>
            </div>

            <div class="card-body">
                <div class="table-responsive">
                    <table class="inventory-table" style="font-size: 14px;">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th><i class="fa fa-user"></i> Customer</th>
                                <th><i class="fa fa-calendar"></i> Date</th>
                                <th><i class="fa fa-star"></i> Rating</th>
                                <th><i class="fa fa-comment"></i> Comment</th>
                                <th><i class="fa fa-reply"></i> Response Status</th>
                                <th><i class="fa fa-cogs"></i> Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty feedbacks}">
                                <tr>
                                    <td colspan="7">
                                        <div class="empty-state" style="padding: 3rem; text-align: center; color: #718096;">
                                            <i class="fa fa-inbox" style="font-size: 3rem; margin-bottom: 1rem; color: #6366f1;"></i>
                                            <h4 style="font-size: 1.25rem; margin: 0;">No feedback found.</h4>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>

                            <c:forEach var="fb" items="${feedbacks}" varStatus="loop">
                                <tr>
                                    <td>${(page-1)*pageSize + loop.index + 1}</td>  
                                    <td>${fb.customerName}</td>
                                    <td><fmt:formatDate value="${fb.requestDate}" pattern="yyyy-MM-dd" /></td>
                                    <td>
                                        <c:if test="${fb.rating > 0}">
                                            <span style="color: #f59e0b;">
                                                <c:forEach begin="1" end="${fb.rating}"><i class="fa fa-star"></i></c:forEach>
                                                </span>
                                        </c:if>
                                        <c:if test="${fb.rating == 0}">N/A</c:if>
                                        </td>
                                        <td>
                                        <c:out value="${fb.comment}" default="No comment"/>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty fb.customerServiceResponse}">
                                                <span class="status-label status-success">
                                                    <i class="fa fa-check-circle"></i> Responded
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-label status-warning">
                                                    <i class="fa fa-clock-o"></i> Not Responded
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/cskh/customer-request/detail?id=${fb.requestId}" 
                                           class="btn btn-action btn-view" style="text-decoration: none;">
                                            <c:choose>
                                                <c:when test="${not empty fb.customerServiceResponse}">
                                                    <i class="fa fa-eye"></i> View/Edit
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fa fa-reply"></i> Respond
                                                </c:otherwise>
                                            </c:choose>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <c:if test="${totalPages > 0}">
                    <div class="pagination-controls" style="display: flex; justify-content: space-between; align-items: center; width: 100%;">
                        <div class="pagination-info">
                            Showing ${(page-1)*pageSize + 1} to ${page*pageSize > totalItems ? totalItems : page*pageSize} of ${totalItems} feedbacks
                        </div>

                        <div class="pagination-controls">
                            <button class="pagination-btn" ${page == 1 ? 'disabled' : ''}
                                    onclick="window.location = '${pageContext.request.contextPath}/cskh/feedback?page=${page - 1}&responseStatus=${param.responseStatus}&rating=${param.rating}'">
                                <i class="fa fa-angle-left"></i>
                            </button>

                            <button class="pagination-btn ${page == 1 ? 'active' : ''}"
                                    onclick="window.location = '${pageContext.request.contextPath}/cskh/feedback?page=1&responseStatus=${param.responseStatus}&rating=${param.rating}'">1</button>

                            <c:if test="${page > 4}"><span>...</span></c:if>

                            <c:set var="startPage" value="${page - 2}" />
                            <c:set var="endPage" value="${page + 2}" />
                            <c:if test="${startPage < 2}"><c:set var="startPage" value="2" /></c:if>
                            <c:if test="${endPage > totalPages - 1}"><c:set var="endPage" value="${totalPages - 1}" /></c:if>

                            <c:forEach var="i" begin="${startPage}" end="${endPage}">
                                <button class="pagination-btn ${i == page ? 'active' : ''}"
                                        onclick="window.location = '${pageContext.request.contextPath}/cskh/feedback?page=${i}&responseStatus=${param.responseStatus}&rating=${param.rating}'">${i}</button>
                            </c:forEach>

                            <c:if test="${page < totalPages - 3}"><span>...</span></c:if>

                            <c:if test="${totalPages > 1}">
                                <button class="pagination-btn ${page == totalPages ? 'active' : ''}"
                                        onclick="window.location = '${pageContext.request.contextPath}/cskh/feedback?page=${totalPages}&responseStatus=${param.responseStatus}&rating=${param.rating}'">${totalPages}</button>
                            </c:if>

                            <button class="pagination-btn" ${page == totalPages ? 'disabled' : ''}
                                    onclick="window.location = '${pageContext.request.contextPath}/cskh/feedback?page=${page + 1}&responseStatus=${param.responseStatus}&rating=${param.rating}'">
                                <i class="fa fa-angle-right"></i>
                            </button>
                        </div>
                    </div>
                </c:if>

            </div> 
        </div> 
    </section>
</div>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const alerts = document.querySelectorAll('.alert');
        if (alerts.length > 0) {
            setTimeout(() => {
                alerts.forEach(a => {
                    a.style.transition = 'opacity 0.5s ease';
                    a.style.opacity = '0';
                    setTimeout(() => a.remove(), 500);
                });
            }, 4000);
        }
    });
</script>
<%@ include file="/cskh/layout/footer.jsp" %>