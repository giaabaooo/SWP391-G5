<%@ include file="/customer/layout/header.jsp" %>
<%@ include file="/customer/layout/sidebar.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="content-wrapper">
    <section class="content-header">
        <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">My Profile</h1>
        <ol class="breadcrumb" style="background: none; padding: 0; margin-bottom: 2rem;">
            <li><a href="${pageContext.request.contextPath}/cskh/dashboard"><i class="fa fa-dashboard"></i> Home</a></li>
            <li class="active">Profile</li>
        </ol>
    </section>

    <section class="content">

        <c:if test="${param.message == 'infoUpdated'}">
            <div class="alert alert-success"><i class="fa fa-check-circle"></i> Profile information updated successfully.</div>
        </c:if>
        <c:if test="${param.message == 'passUpdated'}">
            <div class="alert alert-success"><i class="fa fa-check-circle"></i> Password changed successfully.</div>
        </c:if>

        <div class="row">
            <div class="col-md-8">
                <div class="content-card">
                    <div class="card-header">
                        <h3><i class="fa fa-user"></i> Account Details</h3>
                    </div>
                    <div class="card-body">
                        <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                            <strong><i class="fa fa-id-badge" style="color: #6366f1; width: 20px;"></i> Username:</strong>
                            <c:out value="${user.username}" /> (Cannot be changed)
                        </div>
                        <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                            <strong><i class="fa fa-envelope" style="color: #6366f1; width: 20px;"></i> Email:</strong>
                            <c:out value="${user.email}" /> (Cannot be changed)
                        </div>
                        <hr>
                        <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                            <strong><i class="fa fa-user-circle" style="color: #6366f1; width: 20px;"></i> Full Name:</strong>
                            <c:out value="${user.fullName}" />
                        </div>
                        <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                            <strong><i class="fa fa-phone" style="color: #6366f1; width: 20px;"></i> Phone:</strong>
                            <c:out value="${user.phone}" default="N/A" />
                        </div>
                        <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                            <strong><i class="fa fa-map-marker" style="color: #6366f1; width: 20px;"></i> Address:</strong>
                            <c:out value="${user.address}" default="N/A" />
                        </div>
                        <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                            <strong><i class="fa fa-briefcase" style="color: #6366f1; width: 20px;"></i> Role:</strong>
                            <c:out value="${user.role.name}" />
                        </div>
                    </div>
                    <div class="card-footer" style="padding: 1.5rem;">
                        <a href="${pageContext.request.contextPath}/user/profile?action=edit" class="btn btn-primary">
                            <i class="fa fa-pencil"></i> Edit Profile & Password
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>

<%@ include file="/customer/layout/footer.jsp" %>