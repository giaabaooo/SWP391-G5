<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/cskh/layout/header.jsp" %>
<%@ include file="/cskh/layout/sidebar.jsp" %>

<section class="content-header" style="padding: 15px 15px 15px 20px; background: #f9f9f9; border-bottom: 1px solid #eee;">
    <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">Device Management</h1>
    <ol class="breadcrumb" style="background: none; padding: 0; margin-bottom: 2rem;">
        <li><a href="${pageContext.request.contextPath}/cskh/dashboard"><i class="fa fa-dashboard"></i> Home</a></li>
        <li class="active">Device List</li>
    </ol>
</section>

<div class="content-card" style="margin: 20px;">
    <div class="card-header">
        <h3><i class="fa fa-filter" style="margin-right: 0.5rem;"></i> Filter Devices</h3>
    </div>
    <div class="card-body filter-bar" style="padding: 1.5rem; background: #fafbfc;">
        <form method="get" action="${pageContext.request.contextPath}/cskh/devices" style="display: flex; flex-wrap: wrap; align-items: center; gap: 15px;">

            <div>
                <label for="customerFilter" style="font-weight: 500; display: block; margin-bottom: 5px;">Customer (Name/Email):</label>
                <input type="text" name="customer" id="customerFilter" value="${requestScope.customerFilter}" class="form-control-modern" placeholder="Customer Name or Email">
            </div>

            <div>
                <label for="keywordFilter" style="font-weight: 500; display: block; margin-bottom: 5px;">Product Name:</label>
                <input type="text" name="keyword" id="keywordFilter" value="${requestScope.keywordFilter}" class="form-control-modern" placeholder="Product Name">
            </div>

            <div style="align-self: flex-end;">
                <button type="submit" class="btn btn-primary" style="background: #007bff; border-color: #007bff;">
                    <i class="fa fa-filter"></i> Filter
                </button>
                <a href="${pageContext.request.contextPath}/cskh/devices" class="btn btn-primary" style="background: #6c757d; border-color: #6c757d;">
                    <i class="fa fa-times"></i> Clear
                </a>
            </div>
        </form>
    </div>
</div>

<div class="content-card" style="margin: 20px;">
    <div class="card-header" style="background-color: #fafbfc;"> <h3><i class="fa fa-laptop"></i> Device List</h3> </div>
    <div class="card-body" style="padding: 0;">
        <table class="table modern-table" style="margin-bottom: 0;">
            <thead>
                <tr>
                    <th style="width: 50px;">#</th>
                    <th>Customer</th>
                    <th>Product Name</th>
                    <th>Serial Number</th>
                    <th>Brand</th>
                    <th>Category</th>
                    <th style="width: 100px;">Status</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="device" items="${requestScope.deviceList}" varStatus="loop">
                    <tr>
                        <td>${(page-1)*pageSize + loop.index + 1}</td>
                        <td>${device.customerName}</td>
                        <td>${device.productName}</td>
                        <td>${device.serialNumber}</td>
                        <td>${device.brandName}</td>
                        <td>${device.categoryName}</td>
                        <td>
                            ${device.status}
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty requestScope.deviceList}">
                    <tr>
                        <td colspan="7">
                            <div class="empty-state" style="padding: 3rem; text-align: center; color: #718096;">
                                <i class="fa fa-laptop" style="font-size: 3rem; margin-bottom: 1rem; color: #6366f1;"></i>
                                <h4 style="font-size: 1.25rem; margin: 0;">No devices found matching your criteria.</h4>
                            </div>
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>

        <c:if test="${totalPages > 0}">
            <div class="pagination-controls" style="display: flex; justify-content: space-between; align-items: center; width: 100%; padding: 1rem 1.5rem; border-top: 1px solid #f1f3f4;">
                <div class="pagination-info">
                    Showing ${(page-1)*pageSize + 1} to ${page*pageSize > totalItems ? totalItems : page*pageSize} of ${totalItems} devices
                </div>

                <div class="pagination-controls">
                    <c:url var="paginationUrl" value="/cskh/devices">
                        <c:param name="customer" value="${requestScope.customerFilter}" />
                        <c:param name="keyword" value="${requestScope.keywordFilter}" />
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