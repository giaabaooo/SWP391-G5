<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="wrapper row-offcanvas row-offcanvas-left">

            <!-- SIDEBAR -->
            <aside class="left-side sidebar-offcanvas">
                <section class="sidebar">
                    <div class="user-panel">
                        <!--                <div class="pull-left image">
                                            <img src="img/26115.jpg" class="img-circle" alt="User Image" />
                                        </div>-->
                        <div class="pull-left info">
                            <p> ${sessionScope.user.fullName}</p>

                        </div>
                    </div>
                    <!--            <form action="#" method="get" class="sidebar-form">
                                    <div class="input-group">
                                        <input type="text" name="q" class="form-control" placeholder="Search..."/>
                                        <span class="input-group-btn">
                                            <button type='submit' id='search-btn' class="btn btn-flat"><i class="fa fa-search"></i></button>
                                        </span>
                                    </div>
                                </form>-->
                    <ul class="sidebar-menu">
                        <!-- Home -->
                        <li class="active">
                            <a href="dashboard.jsp"> <span>Home</span></a>
                        </li>

                        <li>
                            <a href="profile.jsp"> <span>My Profile</span></a>
                        </li>
                        
                        <li>
                            <a href="technician_list.jsp"> View List Technican</a>
                        </li>
                        
                        <li>
                            <a href="task_list.jsp"> View List Task</a>
                        </li>

                        <li>
                            <a href="logout">Sign Out</a>
                        </li>
                    </ul>

                </section>
            </aside>
    