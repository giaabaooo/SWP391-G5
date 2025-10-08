<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/techmanager/layout/header.jsp" %>
<%@ include file="/techmanager/layout/sidebar_cskh.jsp" %>
<!DOCTYPE html>
<html>
    <body class="skin-black">
        <div class="wrapper row-offcanvas row-offcanvas-left">
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
        <!-- Bootstrap 5 Bundle JS (gồm cả Popper.js) -->
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>


        <script>
            $(function () {
                $('input[type="checkbox"].flat-grey').iCheck({
                    checkboxClass: 'icheckbox_flat-grey'
                });

                $('input').on('ifChecked', function (event) {
                    $(this).parents('li').addClass("task-done");
                });
                $('input').on('ifUnchecked', function (event) {
                    $(this).parents('li').removeClass("task-done");
                });
            });
        </script>

    </body>
</html>
<%@ include file="/WEB-INF/jsp/layout/footer.jsp" %>