<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="/jsp/layout/header2.jsp" %>
<%@ include file="/jsp/layout/sidebar2.jsp" %>

<style>
    :root {
        --primary-color: #4a90e2;
        --success-color: #38a169;
        --danger-color: #e53e3e;
        --warning-color: #d69e2e;
        --info-color: #3182ce;
        --default-color: #6b7280;
        --text-color: #2d3748;
        --muted-color: #718096;
        --background-color: #f7fafc;
        --border-color: #e2e8f0;
        --hover-color: #3b82f6;
        --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }

    .content-wrapper {
        background-color: var(--background-color);
        padding: 24px;
        min-height: 100vh;
    }

    .content-header h1 {
        color: var(--text-color);
        font-weight: 700;
        font-size: 2.25rem;
        margin-bottom: 0.75rem;
    }

    .breadcrumb {
        background-color: transparent;
        padding: 0;
        margin-bottom: 2rem;
        font-size: 0.9rem;
    }

    .breadcrumb a {
        color: var(--primary-color);
        text-decoration: none;
    }

    .breadcrumb a:hover {
        color: var(--hover-color);
    }

    .box {
        border-radius: 10px;
        box-shadow: var(--shadow);
        margin-bottom: 2rem;
        background-color: #ffffff;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    .box-header {
        padding: 1.5rem;
        border-bottom: 1px solid var(--border-color);
    }

    .box-title {
        font-size: 1.25rem;
        font-weight: 600;
        color: var(--text-color);
        margin: 0;
    }

    .box-body {
        padding: 1.5rem;
    }

    .box-footer {
        padding: 1.25rem;
        border-top: 1px solid var(--border-color);
        background-color: #f8fafc;
        display: flex;
        justify-content: flex-end;
    }

    .table {
        background-color: #ffffff;
        border-radius: 10px;
        overflow: hidden;
        width: 100%;
    }

    .table tr:nth-child(odd) {
        background-color: #f8fafc;
    }

    .table tr:hover {
        background-color: #e2e8f0;
    }

    .table th, .table td {
        padding: 1rem;
        font-size: 0.95rem;
        vertical-align: middle;
    }

    .table th {
        background-color: var(--primary-color);
        color: #fff;
        width: 30%;
    }

    .label {
        padding: 0.4rem 0.8rem;
        border-radius: 4px;
        font-size: 0.85rem;
        font-weight: 500;
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
    }

    .label-success { background-color: var(--success-color); color: #fff; }
    .label-danger { background-color: var(--danger-color); color: #fff; }
    .label-warning { background-color: var(--warning-color); color: #fff; }
    .label-info { background-color: var(--info-color); color: #fff; }
    .label-default { background-color: var(--default-color); color: #fff; }

    .btn-back {
        background-color: var(--primary-color);
        color: #fff;
        padding: 0.75rem 1.5rem;
        border-radius: 6px;
        font-size: 1rem;
        text-decoration: none;
    }

    .btn-back:hover {
        background-color: #3b82f6;
        color: #fff;
    }

</style>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Request Detail</h1>
        <ol class="breadcrumb">
            <li><a href="${pageContext.request.contextPath}/cskh/dashboard"><i class="fa fa-dashboard"></i> Home</a></li>
            <li><a href="${pageContext.request.contextPath}/cskh/customer-request">Customer Requests</a></li>
            <li class="active">Detail</li>
        </ol>
    </section>

    <section class="content">
        <div class="box box-primary">
            <div class="box-header">
                <h3 class="box-title"><i class="fa fa-info-circle"></i> Request Information</h3>
            </div>
            <div class="box-body">
                <table class="table table-bordered">
                    <tr>
                        <th>Request ID</th>
                        <td><c:out value="${requestDetail.id}" default="N/A"/></td>
                    </tr>
                    <tr>
                        <th>Customer</th>
                        <td>
                            <c:choose>
                                <c:when test="${not empty requestDetail.customer}">
                                    <c:out value="${requestDetail.customer.fullName}" default="Unknown Customer"/>
                                </c:when>
                                <c:otherwise>
                                    Unknown Customer
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr>
                        <th>Device</th>
                        <td>
                            <c:choose>
                                <c:when test="${not empty requestDetail.device}">
                                    <c:out value="${requestDetail.device.productName}" default="Unknown Device"/>
                                </c:when>
                                <c:otherwise>
                                    Unknown Device
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr>
                        <th>Title</th>
                        <td><c:out value="${requestDetail.title}" default="N/A"/></td>
                    </tr>
                    <tr>
                        <th>Description</th>
                        <td>
                            <c:choose>
                                <c:when test="${not empty requestDetail.description}">
                                    <c:out value="${requestDetail.description}"/>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: var(--muted-color);">No description</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr>
                        <th>Request Type</th>
                        <td><c:out value="${requestDetail.request_type}" default="N/A"/></td>
                    </tr>
                    <tr>
                        <th>Status</th>
                        <td>
                            <c:choose>
                                <c:when test="${not empty requestDetail.status}">
                                    <span class="label
                                        ${requestDetail.status eq 'PENDING' ? 'label-warning' :
                                          requestDetail.status eq 'TRANSFERRED' ? 'label-info' :
                                          requestDetail.status eq 'ASSIGNED' ? 'label-info' :
                                          requestDetail.status eq 'IN_PROGRESS' ? 'label-info' :
                                          requestDetail.status eq 'COMPLETED' ? 'label-success' :
                                          requestDetail.status eq 'CANCELLED' ? 'label-danger' : 'label-default'}">
                                        <i class="fa
                                            ${requestDetail.status eq 'PENDING' ? 'fa-clock-o' :
                                              requestDetail.status eq 'TRANSFERRED' ? 'fa-share' :
                                              requestDetail.status eq 'ASSIGNED' ? 'fa-user-plus' :
                                              requestDetail.status eq 'IN_PROGRESS' ? 'fa-cog' :
                                              requestDetail.status eq 'COMPLETED' ? 'fa-check-circle' :
                                              requestDetail.status eq 'CANCELLED' ? 'fa-times-circle' : 'fa-circle'}"></i>
                                        <c:out value="${requestDetail.status}"/>
                                    </span>
                                </c:when>
                                <c:otherwise>N/A</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr>
                        <th>Request Date</th>
                        <td>
                            <c:choose>
                                <c:when test="${not empty requestDetail.request_date}">
                                    <fmt:formatDate value="${requestDetail.request_date}" pattern="yyyy-MM-dd HH:mm"/>
                                </c:when>
                                <c:otherwise>N/A</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="box-footer">
                <a href="${pageContext.request.contextPath}/cskh/customer-request" class="btn-back">
                    <i class="fa fa-arrow-left"></i> Back to List
                </a>
            </div>
        </div>
    </section>
</div>

<%@ include file="/jsp/layout/footer2.jsp" %>
