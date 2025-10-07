<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin | Dashboard</title>
    <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
    <meta name="description" content="Developed By M Abdur Rokib Promy">
    <meta name="keywords" content="Admin, Bootstrap 3, Template, Theme, Responsive">
    <!-- bootstrap 3.0.2 -->
    <link href="../css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="../css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="../css/ionicons.min.css" rel="stylesheet" type="text/css" />
    <link href="../css/morris/morris.css" rel="stylesheet" type="text/css" />
    <link href="../css/jvectormap/jquery-jvectormap-1.2.2.css" rel="stylesheet" type="text/css" />
    <link href="../css/datepicker/datepicker3.css" rel="stylesheet" type="text/css" />
    <link href="../css/daterangepicker/daterangepicker-bs3.css" rel="stylesheet" type="text/css" />
    <link href="css/iCheck/all.css" rel="stylesheet" type="text/css" />
    <link href='http://fonts.googleapis.com/css?family=Lato' rel='stylesheet' type='text/css'>
    <link href="../css/admin/style.css" rel="stylesheet" type="text/css" />
</head>
<body class="skin-black">

<!-- HEADER -->
<header class="header">
    <a href="dashboard.jsp" class="logo">Admin</a>
    <nav class="navbar navbar-static-top" role="navigation">
        <a href="#" class="navbar-btn sidebar-toggle" data-toggle="offcanvas" role="button">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </a>
        <div class="navbar-right">
            <ul class="nav navbar-nav">
                <!-- Messages, Tasks, User Account -->
                <li class="dropdown user user-menu">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        <i class="fa fa-user"></i>
                        <span>Jane Doe <i class="caret"></i></span>
                    </a>
                    <ul class="dropdown-menu dropdown-custom dropdown-menu-right">
                        <li class="dropdown-header text-center">Account</li>
                        <li>
                            <a href="#"><i class="fa fa-user fa-fw pull-right"></i> Profile</a>
                            <a data-toggle="modal" href="#modal-user-settings"><i class="fa fa-cog fa-fw pull-right"></i> Settings</a>
                        </li>
                        <li class="divider"></li>
                        <li><a href="#"><i class="fa fa-ban fa-fw pull-right"></i> Logout</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </nav>
</header>

<div class="wrapper row-offcanvas row-offcanvas-left">

    <!-- SIDEBAR -->
    <aside class="left-side sidebar-offcanvas">
        <section class="sidebar">
            <div class="user-panel">
                <div class="pull-left image">
                    <img src="img/26115.jpg" class="img-circle" alt="User Image" />
                </div>
                <div class="pull-left info">
                    <p>Hello, Jane</p>
                    <a href="#"><i class="fa fa-circle text-success"></i> Online</a>
                </div>
            </div>
            <form action="#" method="get" class="sidebar-form">
                <div class="input-group">
                    <input type="text" name="q" class="form-control" placeholder="Search..."/>
                    <span class="input-group-btn">
                        <button type='submit' id='search-btn' class="btn btn-flat"><i class="fa fa-search"></i></button>
                    </span>
                </div>
            </form>
            <ul class="sidebar-menu">
                <li class="active"><a href="dashboard.jsp"><i class="fa fa-dashboard"></i> Dashboard</a></li>
                <li><a href="general.jsp"><i class="fa fa-gavel"></i> General</a></li>
                <li><a href="basic_form.jsp"><i class="fa fa-globe"></i> Basic Elements</a></li>
                <li><a href="simple.jsp"><i class="fa fa-glass"></i> Simple tables</a></li>
            </ul>
        </section>
    </aside>

    <!-- MAIN CONTENT -->
    <aside class="right-side">
        <section class="content">
            <div class="row" style="margin-bottom:5px;">
                <!-- Statistics boxes -->
                <div class="col-md-3">
                    <div class="sm-st clearfix">
                        <span class="sm-st-icon st-red"><i class="fa fa-check-square-o"></i></span>
                        <div class="sm-st-info">
                            <span>3200</span> Total Tasks
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="sm-st clearfix">
                        <span class="sm-st-icon st-violet"><i class="fa fa-envelope-o"></i></span>
                        <div class="sm-st-info">
                            <span>2200</span> Total Messages
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="sm-st clearfix">
                        <span class="sm-st-icon st-blue"><i class="fa fa-dollar"></i></span>
                        <div class="sm-st-info">
                            <span>100,320</span> Total Profit
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="sm-st clearfix">
                        <span class="sm-st-icon st-green"><i class="fa fa-paperclip"></i></span>
                        <div class="sm-st-info">
                            <span>4567</span> Total Documents
                        </div>
                    </div>
                </div>
            </div>

            <!-- Teammates and Todo List -->
            <div class="row">
                <!-- Teammates -->
                <div class="col-md-5">
                    <div class="panel">
                        <header class="panel-heading">Technician</header>
                        <ul class="list-group teammates">
                            <li class="list-group-item">
                                <a href=""><img src="img/26115.jpg" width="50" height="50"></a>
                                <span class="pull-right label label-danger inline m-t-15">Admin</span>
                                <a href="">Damon Parker</a>
                            </li>
                            <li class="list-group-item">
                                <a href=""><img src="img/26115.jpg" width="50" height="50"></a>
                                <span class="pull-right label label-info inline m-t-15">Member</span>
                                <a href="">Joe Waston</a>
                            </li>
                            <li class="list-group-item">
                                <a href=""><img src="img/26115.jpg" width="50" height="50"></a>
                                <span class="pull-right label label-warning inline m-t-15">Editor</span>
                                <a href="">Jannie Dvis</a>
                            </li>
                        </ul>
                        <div class="panel-footer bg-white">
                            <button class="btn btn-primary btn-addon btn-sm">
                                <i class="fa fa-plus"></i> Add Teammate
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Todo list placeholder -->
                <div class="col-md-7">
                    <section class="panel tasks-widget">
                        <header class="panel-heading">Todo list</header>
                        <div class="panel-body">
                            <div class="task-content">
                                <ul class="task-list">
                                    <li>
                                        <div class="task-checkbox">
                                            <input type="checkbox" class="flat-grey list-child"/>
                                        </div>
                                        <div class="task-title">
                                            <span class="task-title-sp">Director is Modern Dashboard</span>
                                            <span class="label label-success">2 Days</span>
                                        </div>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </section>
                </div>
            </div>

        </section>
        <div class="footer-main">Copyright &copy Director, 2014</div>
    </aside>
</div>

<!-- SCRIPTS -->
<script src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js"></script>

<script src="js/jquery-ui-1.10.3.min.js" type="text/javascript"></script>
<script src="js/bootstrap.min.js" type="text/javascript"></script>
<script src="js/daterangepicker.js" type="text/javascript"></script>
<script src="js/chart.js" type="text/javascript"></script>
<script src="js/icheck.min.js" type="text/javascript"></script>
<script src="js/fullcalendar.js" type="text/javascript"></script>
<script src="js/app.js" type="text/javascript"></script>
<script src="js/dashboard.js" type="text/javascript"></script>

<script>
    $(function() {
        $('input[type="checkbox"].flat-grey').iCheck({
            checkboxClass: 'icheckbox_flat-grey'
        });

        $('input').on('ifChecked', function(event) {
            $(this).parents('li').addClass("task-done");
        });
        $('input').on('ifUnchecked', function(event) {
            $(this).parents('li').removeClass("task-done");
        });
    });
</script>

</body>
</html>
