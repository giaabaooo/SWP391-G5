<%-- 
    Document   : updateFeedback
    Created on : Oct 31, 2025, 9:49:55 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="data.Feedback" %>
<c:set var="fb" value="${requestScope.feedbackData}" />
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Customer | Update Feedback</title>
        <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
        <meta name="description" content="Warehouse Management System">
        <meta name="keywords" content="Warehouse, Inventory, Management">


        <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
        <link href="${pageContext.request.contextPath}/css/ionicons.min.css" rel="stylesheet" type="text/css" />
        <link href="${pageContext.request.contextPath}/css/morris/morris.css" rel="stylesheet" type="text/css" />
        <link href="${pageContext.request.contextPath}/css/jvectormap/jquery-jvectormap-1.2.2.css" rel="stylesheet" type="text/css" />
        <link href="${pageContext.request.contextPath}/css/daterangepicker/daterangepicker-bs3.css" rel="stylesheet" type="text/css" />
        <link href="${pageContext.request.contextPath}/css/iCheck/all.css" rel="stylesheet" type="text/css" />
        <link href='http://fonts.googleapis.com/css?family=Lato' rel='stylesheet' type='text/css'>
        <link href="${pageContext.request.contextPath}/css/admin/style.css" rel="stylesheet" type="text/css" />
        <link href="${pageContext.request.contextPath}/css/warehouse/addProduct.css" rel="stylesheet" type="text/css" />
        <style>
            .star-rating {
                display: flex;
                flex-direction: row-reverse;
                justify-content: flex-end; /* Hiển thị từ phải sang trái */
            }
            .star-rating input[type="radio"] {
                display: none;
            } /* Ẩn radio button */
            .star-rating label {
                font-size: 2rem; /* Kích thước sao */
                color: #ddd; /* Màu sao mặc định */
                cursor: pointer;
                padding: 0 0.2em;
                transition: color 0.2s;
            }
            /* Khi hover, tất cả sao bên trái (hiển thị là bên phải) sẽ sáng lên */
            .star-rating:hover label {
                color: #f5b301;
            }
            .star-rating input[type="radio"]:hover ~ label {
                color: #f5b301;
            }
            /* Khi một sao được chọn, các sao bên trái nó sẽ sáng */
            .star-rating input[type="radio"]:checked ~ label {
                color: #f5b301;
            }
            .validation-error {
                display: none;
                color: #dc3545;
                font-size: 0.875em;
                margin-top: 5px;
            }
            .has-error .form-control {
                border-color: #dc3545;
            }
            .has-error .validation-error {
                display: block;
            }
        </style>

    </head>
    <body class="skin-black">


        <header class="header">
            <a href="dashboard" class="logo" style="color: #ffffff; font-weight: 600;">${sessionScope.user.role.name}</a>
            <nav class="navbar navbar-static-top" role="navigation">
                <div class="navbar-right">
                    <ul class="nav navbar-nav">
                        <li class="dropdown user user-menu">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                <i class="fa fa-user"></i>
                                <span>${sessionScope.user.fullName} <i class="caret"></i></span>
                            </a>
                            <ul class="dropdown-menu dropdown-custom dropdown-menu-right">
                                <li class="dropdown-header text-center">Account</li>
                                <li><a href="#"><i class="fa fa-user fa-fw pull-right"></i> Profile</a></li>
                                <li class="divider"></li>
                                <li><a href="${pageContext.request.contextPath}/logout"><i class="fa fa-ban fa-fw pull-right"></i> Logout</a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </nav>
        </header>

        <div class="wrapper row-offcanvas row-offcanvas-left">
            <aside class="left-side sidebar-offcanvas">
                <section class="sidebar">
                    <div class="user-panel">

                        <div class="pull-left info">
                            <p>${sessionScope.user.fullName}</p>
                            <a href="#"><i class="fa fa-circle text-success"></i> Online</a>
                        </div>
                    </div>

                    <ul class="sidebar-menu">
                        <li><a href="dashboard"><i class="fa fa-dashboard"></i> Dashboard</a></li>


                        <li class="treeview">
                            <a href="#categoryMenu" data-toggle="collapse" aria-expanded="false">
                                <i class="fa fa-tags"></i> <span>Request</span>
                            </a>
                            <ul class="collapse" id="categoryMenu">
                                <li><a href="${pageContext.request.contextPath}/customer/createRequest"><i class="fa fa-plus"></i> Create Request</a></li>
                                <li><a href="${pageContext.request.contextPath}/customer/listRequest"><i class="fa fa-eye"></i> View List Request</a></li>


                            </ul>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/customer/devices"><i class="fa fa-cube"></i>My Devices </a>
                        </li>


                        <li>
                        <li><a href="${pageContext.request.contextPath}/customer/contract"><i class="fa fa-file-text"></i> Contract</a></li>
                        </li>





                        <li class="treeview">
                            <a href="#feedbackMenu" data-toggle="collapse" aria-expanded="false">
                                <i class="fa fa-tags"></i> <span>Feedback</span>
                            </a>
                            <ul class="collapse" id="feedbackMenu">
                                <li><a href="${pageContext.request.contextPath}/customer/createFeedback"><i class="fa fa-plus"></i> Create Feedback</a></li>
                                <li><a href="${pageContext.request.contextPath}/customer/listFeedback"><i class="fa fa-eye"></i> View List Feedback</a></li>


                            </ul>
                        </li>
                    </ul>
                </section>
            </aside>

            <aside class="right-side">
                <section class="content">
                    <div class="row">
                        <div class="col-md-12">
                            <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">Update Feedback</h1>
                            <p style="color: #718096; margin-bottom: 2rem;">Edit the details of your feedback.</p>
                            <% if (request.getAttribute("error") != null) { %>
                            <div class="alert alert-danger" style="background-color: #fed7d7; border: 1px solid #fc8181; color: #742a2a; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;">
                                <i class="fa fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
                            </div>
                            <% } %>
                        </div>
                    </div>


                    <div class="row">
                        <div class="col-md-12">
                            <div class="content-card">
                                <div class="card-header">
                                    <h3><i class="fa fa-pencil"></i> Edit Feedback</h3>
                                </div>
                                <div class="card-body">
                                    <form method="post" action="${pageContext.request.contextPath}/customer/updateFeedback" novalidate onsubmit="return validateFeedback();">
                                        <input type="hidden" name="requestId" value="${fb.requestId}">

                                        
                                            <fieldset disabled> 
                                                <div class="form-group"><label>Device</label><input type="text" value="<c:out value='${fb.productName}'/>" class="form-control"></div>
                                                <div class="form-group"><label>Request Type</label><input type="text" value="<c:out value='${fb.requestType}'/>" class="form-control"></div>
                                                <div class="form-group"><label>Issue Description</label><textarea class="form-control" rows="2"><c:out value='${fb.description}'/></textarea></div>
                                            </fieldset>
                                        

                                        <div class="form-group" id="ratingGroup">
                                            <label>Your Rating<span style="color:red">*</span></label>
                                            <div class="star-rating">
                                                <input type="radio" id="star5" name="rating" value="5" ${fb.rating == 5 ? 'checked' : ''} /><label for="star5" title="5 stars">&#9733;</label>
                                                <input type="radio" id="star4" name="rating" value="4" ${fb.rating == 4 ? 'checked' : ''} /><label for="star4" title="4 stars">&#9733;</label>
                                                <input type="radio" id="star3" name="rating" value="3" ${fb.rating == 3 ? 'checked' : ''} /><label for="star3" title="3 stars">&#9733;</label>
                                                <input type="radio" id="star2" name="rating" value="2" ${fb.rating == 2 ? 'checked' : ''} /><label for="star2" title="2 stars">&#9733;</label>
                                                <input type="radio" id="star1" name="rating" value="1" ${fb.rating == 1 ? 'checked' : ''} /><label for="star1" title="1 star">&#9733;</label>
                                            </div>
                                            <div class="validation-error">Please select a rating.</div>
                                        </div>

                                        <div class="form-group" id="commentGroup">
                                            <label>Your Feedback<span style="color:red">*</span></label>
                                            <textarea id="comment" name="comment" class="form-control" rows="4" placeholder="Tell us about your experience..." minlength="10" maxlength="1000" required><c:out value="${fb.comment}"/></textarea>
                                            <div class="validation-error">Please provide your feedback.</div>
                                        </div>


                                        <!-- Success Message -->
                                        <% if (request.getAttribute("success") != null) { %>
                                        <div class="success-message" style="margin-top: 2rem; background-color: #d1fae5 !important; border: 1px solid #86efac !important; color: #059669 !important; padding: 1rem !important; border-radius: 8px !important; text-align: center !important;">
                                            <i class="fa fa-check-circle" style="color: #10b981 !important; margin-right: 0.5rem !important; font-size: 1.1rem !important;"></i> <%= request.getAttribute("success") %>
                                        </div>
                                        <% } %>

                                        <div class="form-row" style="margin-top: 2rem; padding-top: 1.5rem; border-top: 1px solid #e2e8f0; margin-bottom: 0;">
                                            <div class="form-col-full text-center">
                                                <button type="submit" class="btn btn-primary" style="margin-right: 1rem; min-width: 150px;"><i class="fa fa-save"></i> Update</button>
                                                <a href="${pageContext.request.contextPath}/customer/listFeedback" class="btn btn-default" style="min-width: 150px;"><i class="fa fa-times"></i> Cancel</a>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                </section>
                <div class="footer-main">Copyright &copy; Customer Management System, 2024</div>
            </aside>
        </div>


        <script src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery-ui-1.10.3.min.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/bootstrap.min.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/daterangepicker.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/chart.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/icheck.min.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/fullcalendar.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/app.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/dashboard.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/warehouse/addProduct.js" type="text/javascript"></script>


        <script>
                                       

                                        function validateFeedback() {
                                            var comment = document.getElementById("comment").value.trim();
                                            var ratingSelected = document.querySelector('input[name="rating"]:checked');

                                            var commentGroup = document.getElementById("commentGroup");
                                            var ratingGroup = document.getElementById("ratingGroup");

                                            // Reset lỗi
                                            commentGroup.classList.remove("has-error");
                                            ratingGroup.classList.remove("has-error");

                                            var isValid = true;

                                            if (comment === "") {
                                                commentGroup.classList.add("has-error");
                                                isValid = false;
                                            }
                                            if (ratingSelected === null) {
                                                ratingGroup.classList.add("has-error");
                                                isValid = false;
                                            }

                                            return isValid;
                                        }
        </script>
    </body>
</html>
