<%-- 
    Document   : listFeedback
    Created on : Oct 30, 2025, 6:21:37 PM
    Author     : admin
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="data.Feedback" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Customer | View List Feedback</title>
        <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
        <meta name="description" content="Warehouse Management System">
        <meta name="keywords" content="Warehouse, Inventory, Management">
        <!-- bootstrap 3.0.2 -->
        <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
        <link href="${pageContext.request.contextPath}/css/ionicons.min.css" rel="stylesheet" type="text/css" />
        <link href="${pageContext.request.contextPath}/css/morris/morris.css" rel="stylesheet" type="text/css" />
        <link href="${pageContext.request.contextPath}/css/jvectormap/jquery-jvectormap-1.2.2.css" rel="stylesheet" type="text/css" />
        <link href="${pageContext.request.contextPath}/css/daterangepicker/daterangepicker-bs3.css" rel="stylesheet" type="text/css" />
        <link href="${pageContext.request.contextPath}/css/iCheck/all.css" rel="stylesheet" type="text/css" />
        <link href='http://fonts.googleapis.com/css?family=Lato' rel='stylesheet' type='text/css'>
        <link href="${pageContext.request.contextPath}/css/admin/style.css" rel="stylesheet" type="text/css" />
        <link href="${pageContext.request.contextPath}/css/warehouse/productList.css" rel="stylesheet" type="text/css" />
    </head>
    <body class="skin-black">

        <!-- HEADER -->
        <header class="header">
            <a href="dashboard" class="logo" style="color: #ffffff; font-weight: 600; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">${sessionScope.user.role.name}</a>
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
                                <li>
                                    <a href="#"><i class="fa fa-user fa-fw pull-right"></i> Profile</a>
                                    <a data-toggle="modal" href="#modal-user-settings"><i class="fa fa-cog fa-fw pull-right"></i> Settings</a>
                                </li>
                                <li class="divider"></li>
                                <li><a href="../login.jsp"><i class="fa fa-ban fa-fw pull-right"></i> Logout</a></li>
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

            <!-- MAIN CONTENT -->
            <aside class="right-side">
                <section class="content">
                    <form method="get" action="${pageContext.request.contextPath}/customer/listFeedback" class="form-inline mb-3">
                        <!-- Page Header -->
                        <div class="row">
                            <div class="col-md-12">
                                <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">View List Feedback</h1>


                                <%-- Display error message if any --%>
                                <% if (request.getAttribute("error") != null) { %>
                                <div class="alert alert-danger" style="background-color: #fed7d7; border: 1px solid #fc8181; color: #742a2a; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;">
                                    <i class="fa fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
                                </div>
                                <% } %>

                                <%-- Display success message if any --%>
                                <% if (request.getParameter("success") != null) { %>
                                <div class="alert alert-success" style="background-color: #d1fae5; border: 1px solid #86efac; color: #059669; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;">
                                    <i class="fa fa-check-circle"></i> <%= request.getParameter("success") %>
                                </div>
                                <% } %>

                                <%-- Display error message from URL parameter --%>
                                <% if (request.getParameter("error") != null) { %>
                                <div class="alert alert-danger" style="background-color: #fed7d7; border: 1px solid #fc8181; color: #742a2a; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;">
                                    <i class="fa fa-exclamation-circle"></i> <%= request.getParameter("error") %>
                                </div>
                                <% } %>
                            </div>
                        </div>

                        <!-- Inventory Table -->
                        <div class="row">
                            <div class="col-md-12">
                                <div class="content-card">
                                    <div class="card-header">
                                        <h3><i class="fa fa-list"></i> Feedback List</h3>
                                        <a href="../customer/createFeedback" class="btn btn-primary">
                                            <i class="fa fa-plus"></i> Add New Feedback
                                        </a>

                                    </div>

                                    <!-- Filter Bar -->
                                    <div class="filter-bar">
                                        <input type="text" id="searchInput" class="search-input" placeholder="Search by device name..." 
                                               value="<%= request.getAttribute("search") != null ? request.getAttribute("search") : "" %>">

                                        <select id="typeFilter" name="type" class="search-input" style="min-width: 150px;">
                                            <option value="ALL" ${empty param.type || param.type == 'ALL' ? 'selected' : ''}>All Types</option>
                                            <c:forEach var="t" items="${types}">
                                                <option value="${t}" ${param.type == t ? 'selected' : ''}>${t}</option>
                                            </c:forEach>
                                        </select>

                                        <select id="ratingFilter" name="rating" class="search-input" style="min-width: 150px;">
                                            <option value="ALL" ${empty param.rating || param.rating == 'ALL' ? 'selected' : ''}>All Ratings</option>
                                            <option value="5" ${param.rating == '5' ? 'selected' : ''}>★★★★★ (5)</option>
                                            <option value="4" ${param.rating == '4' ? 'selected' : ''}>★★★★☆ (4)</option>
                                            <option value="3" ${param.rating == '3' ? 'selected' : ''}>★★★☆☆ (3)</option>
                                            <option value="2" ${param.rating == '2' ? 'selected' : ''}>★★☆☆☆ (2)</option>
                                            <option value="1" ${param.rating == '1' ? 'selected' : ''}>★☆☆☆☆ (1)</option>
                                        </select>



                                        <button type="button" class="btn btn-primary" onclick="applyFilters()">
                                            <i class="fa fa-filter"></i> Filter
                                        </button>
                                        <button class="btn btn-primary" onclick="clearFilters()" style="background: #6c757d; border-color: #6c757d;">
                                            <i class="fa fa-times"></i> Clear
                                        </button>
                                    </div>
                                    </form>
                                    <div class="card-body">

                                        <div class="table-responsive">
                                            <table class="inventory-table">
                                                <thead>
                                                    <tr>
                                                        <th>ID</th>
                                                        <th>Title</th>
                                                        <th>Type</th>
                                                        <th>Device</th>
                                                        <th>Issue Description</th>
                                                        <th>Rating</th>
                                                        <th>Feedback</th>
                                                        <th>Date</th>
                                                        <th>Action</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <%
                                                        List<data.Feedback> feedbacks = (List<data.Feedback>) request.getAttribute("feedbacks");
                                                        if (feedbacks != null ) {
                                                        int no = 1;
                                                            for (data.Feedback f : feedbacks) {
                                                        
                                                    %>
                                                    <tr>
                                                        <td><%= no++ %></td>
                                                        <td><%= f.getTitle() %></td>
                                                        <td><%= f.getRequestType() %></td>
                                                        <td><%= f.getProductName() %></td>
                                                        <td><%= f.getDescription() %></td>
                                                        <td>
                                                            <% for (int i = 1; i <= 5; i++) { %>
                                                            <i class="fa <%= i <= f.getRating() ? "fa-star text-warning" : "fa-star-o text-muted" %>"></i>
                                                            <% } %>
                                                        </td>
                                                        <td><%= f.getComment() %></td>
                                                        <td><%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(f.getRequestDate()) %></td>
                                                        <td>

                                                            <a href="${pageContext.request.contextPath}/customer/updateFeedback?id=<%= f.getRequestId() %>" class="btn btn-action btn-edit" style="text-decoration: none;">
                                                                <i class="fa fa-edit"></i> Update
                                                            </a>

                                                        </td>
                                                    </tr>
                                                    <%
                                                            }
                                                        } else {
                                                    %>
                                                    <tr><td colspan="8" style="text-align:center;">No feedback found.</td></tr>
                                                    <% } %>
                                                </tbody>
                                            </table>
                                        </div>

                                        <!-- Pagination Controls -->
                                        <div class="pagination-container">
                                            <div class="pagination-info">
                                                
                                            </div>

                                            <div class="page-size-selector">
                                                <label for="pageSize">Show:</label>
                                                <select id="pageSize" onchange="changePageSize()">
                                                    <%-- Dùng JSTL để kiểm tra và chọn đúng giá trị --%>
                                                    <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                                                    <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                                                    <option value="25" ${pageSize == 25 ? 'selected' : ''}>25</option>
                                                    <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                                                    <option value="100" ${pageSize == 100 ? 'selected' : ''}>100</option>
                                                </select>
                                                <span>per page</span>
                                            </div>

                                            <div class="pagination-controls">
                                                <button class="pagination-btn" id="firstPageBtn" onclick="goToFirstPage()">
                                                    <i class="fa fa-angle-double-left"></i>
                                                </button>
                                                <button class="pagination-btn" id="prevPageBtn" onclick="goToPrevPage()">
                                                    <i class="fa fa-angle-left"></i>
                                                </button>

                                                <div id="pageNumbers"></div>

                                                <button class="pagination-btn" id="nextPageBtn" onclick="goToNextPage()">
                                                    <i class="fa fa-angle-right"></i>
                                                </button>
                                                <button class="pagination-btn" id="lastPageBtn" onclick="goToLastPage()">
                                                    <i class="fa fa-angle-double-right"></i>
                                                </button>
                                            </div>
                                        </div>


                                    </div>
                                </div>
                            </div>
                        </div>

                </section>
                <div class="footer-main">Copyright &copy; Customer Management System, 2024</div>
            </aside>
        </div>

        <!-- Delete Confirmation Modal -->


        <!-- SCRIPTS -->
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery-ui-1.10.3.min.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/bootstrap.min.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/daterangepicker.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/chart.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/icheck.min.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/fullcalendar.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/app.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/dashboard.js" type="text/javascript"></script>
        <!--<script src="${pageContext.request.contextPath}/js/warehouse/productList.js" type="text/javascript"></script>-->
        <script>
                                                    $(function () {
                                                        // Pagination variables
                                                        let currentPage = 1;
                                                        let pageSize = 10;
                                                        let allRows = [];
                                                        let filteredRows = [];

                                                        // Helper function to get current URL parameters
                                                        function getUrlParams() {
                                                            var params = new URLSearchParams(window.location.search);
                                                            var urlParams = {};

                                                            if (params.get('search')) {
                                                                urlParams.search = params.get('search');
                                                            }
                                                            if (params.get('type')) {
                                                                urlParams.type = params.get('type');
                                                            }
                                                            if (params.get('rating')) {
                                                                urlParams.rating = params.get('rating');
                                                            }


                                                            return urlParams;
                                                        }

                                                        // Helper function to build URL with parameters
                                                        function buildUrlWithParams(params) {
                                                            var url = window.location.pathname;
                                                            var paramArray = [];
                                                            for (var key in params) {
                                                                if (params[key] && params[key] !== '' && params[key] !== 'ALL') {
                                                                    paramArray.push(key + '=' + encodeURIComponent(params[key]));
                                                                }
                                                            }
                                                            if (paramArray.length > 0) {
                                                                url += '?' + paramArray.join('&');
                                                            }
                                                            return url;
                                                        }

                                                        // Initialize pagination (server-side)
                                                        function initPagination() {
                                                            renderPagination();
                                                            updatePaginationInfo();
                                                        }

                                                        // Update pagination info text (from server data)
                                                        function updatePaginationInfo() {
                                                            // Dùng các biến toàn cục đã lấy từ server
                                                            var startIndex = (currentPage - 1) * currentLimit + 1;
                                                            var endIndex = Math.min(currentPage * currentLimit, totalProducts);
                                                            var infoElement = document.getElementById('paginationInfo');
                                                            if (infoElement) {
                                                                if (totalProducts === 0) {
                                                                    infoElement.textContent = 'No requests found.';
                                                                } else {
                                                                    infoElement.textContent = 'Showing ' + startIndex + ' to ' + endIndex + ' of ' + totalProducts + ' requests';
                                                                }
                                                            }
                                                        }

                                                        // Render pagination buttons
                                                        function renderPagination() {
                                                            var pageNumbersDiv = document.getElementById('pageNumbers');
                                                            if (!pageNumbersDiv)
                                                                return;
                                                            pageNumbersDiv.innerHTML = '';

                                                            var startPage = Math.max(1, currentPage - 2);
                                                            var endPage = Math.min(totalPages, currentPage + 2);
                                                            if (currentPage <= 3) {
                                                                endPage = Math.min(5, totalPages);
                                                            }
                                                            if (currentPage > totalPages - 3) {
                                                                startPage = Math.max(1, totalPages - 4);
                                                            }

                                                            for (var i = startPage; i <= endPage; i++) {
                                                                var btn = document.createElement('button');
                                                                btn.className = 'pagination-btn' + (i === currentPage ? ' active' : '');
                                                                btn.textContent = i;
                                                                btn.onclick = (function (pageNum) {
                                                                    return function () {
                                                                        goToPage(pageNum);
                                                                    };
                                                                })(i);
                                                                pageNumbersDiv.appendChild(btn);
                                                            }
                                                            updatePaginationButtons();
                                                        }

                                                        // Update pagination button states
                                                        function updatePaginationButtons() {
                                                            var firstBtn = document.getElementById('firstPageBtn');
                                                            var prevBtn = document.getElementById('prevPageBtn');
                                                            var nextBtn = document.getElementById('nextPageBtn');
                                                            var lastBtn = document.getElementById('lastPageBtn');

                                                            if (firstBtn)
                                                                firstBtn.disabled = (currentPage === 1);
                                                            if (prevBtn)
                                                                prevBtn.disabled = (currentPage === 1);
                                                            if (nextBtn)
                                                                nextBtn.disabled = (currentPage === totalPages || totalPages === 0);
                                                            if (lastBtn)
                                                                lastBtn.disabled = (currentPage === totalPages || totalPages === 0);
                                                        }

                                                        // Pagination navigation functions (with URL parameters preserved)
                                                        window.goToPage = function (page) {
                                                            var params = getUrlParams();
                                                            params.page = page;
                                                            window.location.href = buildUrlWithParams(params);
                                                        };
                                                        window.goToFirstPage = function () {
                                                            goToPage(1);
                                                        };
                                                        window.goToPrevPage = function () {
                                                            if (currentPage > 1)
                                                                goToPage(currentPage - 1);
                                                        };
                                                        window.goToNextPage = function () {
                                                            if (currentPage < totalPages)
                                                                goToPage(currentPage + 1);
                                                        };
                                                        window.goToLastPage = function () {
                                                            goToPage(totalPages);
                                                        };

                                                        window.changePageSize = function () {
                                                            var newPageSize = document.getElementById('pageSize').value;
                                                            var params = getUrlParams();
                                                            params.pageSize = newPageSize;
                                                            params.page = 1;
                                                            window.location.href = buildUrlWithParams(params);
                                                        };


                                                        setTimeout(function () {
                                                            $('.alert-success, .alert-danger').fadeOut(500, function () {
                                                                $(this).remove();
                                                            });
                                                        }, 3000);

                                                        // Handle collapsible menu
                                                        $('.treeview > a').click(function (e) {
                                                            e.preventDefault();
                                                            var target = $(this).attr('href');
                                                            $(target).collapse('toggle');
                                                        });

                                                        // Auto-expand Products menu since we're on view list product page
                                                        $('#inventoryMenu').addClass('in');

                                                        // Set page size from URL parameter
                                                        var urlParams = new URLSearchParams(window.location.search);
                                                        var pageSizeFromUrl = urlParams.get('pageSize');
                                                        if (pageSizeFromUrl) {
                                                            var pageSizeSelect = document.getElementById('pageSize');
                                                            if (pageSizeSelect) {
                                                                pageSizeSelect.value = pageSizeFromUrl;
                                                            }
                                                        }

                                                        // Initialize pagination on page load
                                                        initPagination();

                                                        // Apply filters function
                                                        window.applyFilters = function () {
                                                            var searchQuery = document.getElementById('searchInput').value;
                                                            var type = document.getElementById('typeFilter').value;
                                                            var rating = document.getElementById('ratingFilter').value;


                                                            // Build URL with parameters
                                                            var url = window.location.pathname + '?';
                                                            var params = [];

                                                            if (searchQuery && searchQuery.trim() !== '') {
                                                                params.push('search=' + encodeURIComponent(searchQuery));
                                                            }
                                                            if (type && type !== 'ALL') {
                                                                params.push('type=' + encodeURIComponent(type));
                                                            }
                                                            if (rating && rating !== 'ALL') {
                                                                params.push('rating=' + encodeURIComponent(rating));
                                                            }


                                                            url += params.join('&');

                                                            // Redirect to filtered URL
                                                            window.location.href = url;
                                                        };

                                                        // Clear filters function
                                                        window.clearFilters = function () {
                                                            // Redirect to page without parameters
                                                            window.location.href = window.location.pathname;
                                                        };

                                                        // Handle Enter key in search input
                                                        $('#searchInput').on('keypress', function (e) {
                                                            if (e.which === 13) { // Enter key
                                                                applyFilters();
                                                            }
                                                        });

                                                        // Handle change event for dropdowns
//                                                        $('#categoryFilter, #brandFilter, #statusFilter').on('change', function () {
//                                                            applyFilters();
//                                                        });
                                                    });

        </script>   
    </body>
</html>
