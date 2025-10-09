<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="main">
    <aside class="left-side sidebar-offcanvas">
        <!-- sidebar: style can be found in sidebar.less -->
        <section class="sidebar">
            <!-- Sidebar user panel -->
            <div class="user-panel">
                <div class="pull-left image">
                    <img src="${pageContext.request.contextPath}/img/26115.jpg" class="img-circle" alt="User Image" />
                </div>
                <div class="pull-left info">
                    <p>Hello, Jane</p>
                    <a href="#"><i class="fa fa-circle text-success"></i> Online</a>
                </div>
            </div>
            <!-- sidebar menu: : style can be found in sidebar.less -->
            <ul class="sidebar-menu">
                <li>
                    <a href="${pageContext.request.contextPath}/techmanager/dashboard.jsp">
                        <i class="fa fa-users"></i> <span>Home</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/techmanager/technician?action=list">
                        <i class="fa fa-users"></i> <span>My Profile</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/techmanager/technician?action=list">
                        <i class="fa fa-users"></i> <span>Technician Manager</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/cskh/customer?action=list">
                        <i class="fa fa-user"></i> <span>Task Manager</span>
                    </a>
                </li>
                <li>
                    <a href="logout">
                        <i class="fa fa-user"></i> <span>Logout</span>
                    </a>
                </li>
            </ul>
        </section>
        <!-- /.sidebar -->
    </aside>
     <aside class="right-side">
        <section class="content">