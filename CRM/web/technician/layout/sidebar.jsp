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
                <a href="${pageContext.request.contextPath}/technician/dashboard.jsp"><i class="fa fa-dashboard"></i> Dashboard</a>
            </li>
            
            <li>
                <a href="${pageContext.request.contextPath}/technician/task?action=list"><i class="fa fa-plus"></i>List Task </a>
            </li>

        </ul>
    </section>
</aside>

