<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!-- SIDEBAR -->
<aside class="left-side sidebar-offcanvas">
    <section class="sidebar">
        <div class="user-panel">
            <div class="pull-left info">
                <p>${sessionScope.user.fullName}</p>
                <a href="#"><i class="fa fa-circle text-success"></i> Online</a>
            </div>
        </div>

        <ul class="sidebar-menu">
            <li>
                <a href="${pageContext.request.contextPath}/admin/dashboard.jsp"><i class="fa fa-dashboard"></i> Dashboard</a>
            </li>
            
            <li>
                <a href="${pageContext.request.contextPath}/admin/user?action=list"><i class="fa fa-plus"></i> User Manager </a>
            </li>
            
            <li>
                <a href="${pageContext.request.contextPath}/admin/permissions"><i class="fa fa-shield"></i> Permission Manager </a>
            </li>
            
            <li>
                <a href="${pageContext.request.contextPath}/admin/user-permissions"><i class="fa fa-user-secret"></i> User Overrides</a>
            </li>
        </ul>
    </section>
</aside>

