<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="data.Product" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Customer | View List Customer</title>
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
                    <form method="get" action="${pageContext.request.contextPath}/customer/devices" class="form-inline mb-3">
                        <!-- Page Header -->
                        <div class="row">
                            <div class="col-md-12">
                                <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">View List Device</h1>


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
                                        <h3><i class="fa fa-list"></i> Device List</h3>
                                        <a href="../customer/createRequest" class="btn btn-primary">
                                            <i class="fa fa-plus"></i> Add New Request
                                        </a>

                                    </div>

                                    <!-- Filter Bar -->
                                    <div class="filter-bar">
                                        <input type="text" id="searchInput" class="search-input" placeholder="Search by device name..." 
                                               value="<%= request.getAttribute("search") != null ? request.getAttribute("search") : "" %>">

                                        <select id="categoryFilter" class="search-input" style="min-width: 150px;">

                                            <option value="ALL" ${param.category == 'ALL' ? 'selected' : ''}>All Category</option>
                                            <c:forEach var="c" items="${categories}">
                                                <option value="${c}" ${param.category == c ? 'selected' : ''}>${c}</option>
                                            </c:forEach>

                                        </select>

                                        <select id="brandFilter" class="search-input" style="min-width: 150px;">
                                            <option value="ALL" ${param.brand == 'ALL' ? 'selected' : ''}>All Brand</option>
                                            <c:forEach var="b" items="${brands}">
                                                <option value="${b}" ${param.brand == b ? 'selected' : ''}>${b}</option>
                                            </c:forEach>

                                        </select>
                                        <select id="statusFilter" class="search-input" style="min-width: 150px;">
                                            <option value="ALL" ${param.status == 'ALL' ? 'selected' : ''}>All </option>
                                            <c:forEach var="d" items="${statuses}">
                                                <option value="${d}" ${param.status == d ? 'selected' : ''}>${d}</option>
                                            </c:forEach>

                                        </select>

                                        <button type="button" class="btn btn-primary" onclick="applyFilters()">
                                            <i class="fa fa-filter"></i> Filter
                                        </button>
                                        <button class="btn btn-primary" onclick="clearFilters()" style="background: #6c757d; border-color: #6c757d;">
                                            <i class="fa fa-times"></i> Clear
                                        </button>
                                    </div>

                                    <div class="card-body">

                                        <div class="table-responsive">
                                            <table class="inventory-table">
                                                <thead>
                                                    <tr>
                                                        <th>ID</th>
                                                        <th>Name</th>
                                                        <th>Category</th>
                                                        <th>Brand</th>                                                       
                                                        <th>Status</th>
                                                        <th>Actions</th>
                                                    </tr>
                                                </thead>

                                                <tbody>
                                                    <% 
                                                        List<data.Device> devices = (List<data.Device>) request.getAttribute("devices");
                                                        if (devices != null) {
                                                            for (data.Device d : devices) {
                                                    %>
                                                    <tr>
                                                        <td><%= d.getId() %></td>
                                                        <td><%= d.getProductName() %></td>
                                                        <td><%= d.getCategoryName() %></td>
                                                        <td><%= d.getBrandName() %></td>
                                                        <td><%= d.getStatus() %></td>
                                                        <td>
                                                            <a href="detailDevice?id=<%= d.getId() %>" class="btn btn-action btn-view" style="text-decoration: none;">
                                                                <i class="fa fa-eye"></i> Detail
                                                            </a>
                                                            <a href="createRequest?deviceId=<%= d.getId() %>&type=Warranty" class="btn btn-action btn-edit" style="text-decoration: none;">
                                                                <i class="fa fa-edit"></i> Warranty
                                                            </a>
                                                            <a href="createRequest?deviceId=<%= d.getId() %>&type=Maintenance" class="btn btn-action btn-edit" style="text-decoration: none;">
                                                                <i class="fa fa-edit"></i> Maintenance
                                                            </a>
                                                            <a href="createRequest?deviceId=<%= d.getId() %>&type=Repair" class="btn btn-action btn-edit" style="text-decoration: none;">
                                                                <i class="fa fa-edit"></i> Repair
                                                            </a>
                                                        </td>
                                                    </tr>
                                                    <%
                                                            }
                                                        } else {
                                                    %>
                                                    <tr>
                                                        <td colspan="8">No devices found.</td>
                                                    </tr>
                                                    <% } %>

                                                </tbody>
                                            </table>
                                        </div>

                                        <!-- Pagination Controls -->
                                        <div class="pagination-container">
                                            <div class="pagination-info">
                                                <span id="paginationInfo">Showing 1 to 10 of 0 products</span>
                                            </div>

                                            <div class="page-size-selector">
                                                <label for="pageSize">Show:</label>
                                                <select id="pageSize" onchange="changePageSize()">
                                                    <option value="5">5</option>
                                                    <option value="10" selected>10</option>
                                                    <option value="25">25</option>
                                                    <option value="50">50</option>
                                                    <option value="100">100</option>
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
                    </form>
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
                                                            if (params.get('category')) {
                                                                urlParams.categories = params.get('category');
                                                            }
                                                            if (params.get('brand')) {
                                                                urlParams.brand = params.get('brand');
                                                            }
                                                            if (params.get('status')) {
                                                                urlParams.status = params.get('status');
                                                            }
                                                            if (params.get('pageSize')) {
                                                                urlParams.pageSize = params.get('pageSize');
                                                            }

                                                            return urlParams;
                                                        }

                                                        // Helper function to build URL with parameters
                                                        function buildUrlWithParams(params) {
                                                            var url = window.location.pathname + '?';
                                                            var paramArray = [];

                                                            for (var key in params) {
                                                                if (params[key] && params[key] !== '') {
                                                                    paramArray.push(key + '=' + encodeURIComponent(params[key]));
                                                                }
                                                            }

                                                            return url + paramArray.join('&');
                                                        }

                                                        // Initialize pagination (server-side)
                                                        function initPagination() {
                                                            renderPagination();
                                                            updatePaginationInfo();
                                                        }

                                                        // Update pagination info text (from server data)
                                                        function updatePaginationInfo() {
                                                            var urlParams = new URLSearchParams(window.location.search);
                                                            var currentPageFromUrl = parseInt(urlParams.get('page')) || 1;
                                                            var pageSizeFromUrl = parseInt(urlParams.get('pageSize')) || 10;
                                                            var totalProducts = <%= request.getAttribute("totalProducts") != null ? request.getAttribute("totalProducts") : 0 %>;

                                                            var startIndex = (currentPageFromUrl - 1) * pageSizeFromUrl + 1;
                                                            var endIndex = Math.min(currentPageFromUrl * pageSizeFromUrl, totalProducts);

                                                            var infoElement = document.getElementById('paginationInfo');
                                                            if (infoElement) {
                                                                if (totalProducts === 0) {
                                                                    infoElement.textContent = '';
                                                                } else {
                                                                    infoElement.textContent =
                                                                            'Showing ' + startIndex + ' to ' + endIndex + ' of ' + totalProducts + ' products';
                                                                }
                                                            }
                                                        }

                                                        // Render pagination buttons
                                                        function renderPagination() {
                                                            var urlParams = new URLSearchParams(window.location.search);
                                                            var currentPageFromUrl = parseInt(urlParams.get('page')) || 1;
                                                            var totalPages = <%= request.getAttribute("totalPages") != null ? request.getAttribute("totalPages") : 1 %>;
                                                            var pageNumbersDiv = document.getElementById('pageNumbers');

                                                            if (!pageNumbersDiv)
                                                                return;

                                                            pageNumbersDiv.innerHTML = '';

                                                            // Determine which pages to show
                                                            var startPage = Math.max(1, currentPageFromUrl - 2);
                                                            var endPage = Math.min(totalPages, currentPageFromUrl + 2);

                                                            // Adjust if near the beginning
                                                            if (currentPageFromUrl <= 3) {
                                                                endPage = Math.min(5, totalPages);
                                                            }

                                                            // Adjust if near the end
                                                            if (currentPageFromUrl > totalPages - 3) {
                                                                startPage = Math.max(1, totalPages - 4);
                                                            }

                                                            // Create page buttons
                                                            for (var i = startPage; i <= endPage; i++) {
                                                                var btn = document.createElement('button');
                                                                btn.className = 'pagination-btn' + (i === currentPageFromUrl ? ' active' : '');
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
                                                            var urlParams = new URLSearchParams(window.location.search);
                                                            var currentPageFromUrl = parseInt(urlParams.get('page')) || 1;
                                                            var totalPages = <%= request.getAttribute("totalPages") != null ? request.getAttribute("totalPages") : 1 %>;

                                                            var firstBtn = document.getElementById('firstPageBtn');
                                                            var prevBtn = document.getElementById('prevPageBtn');
                                                            var nextBtn = document.getElementById('nextPageBtn');
                                                            var lastBtn = document.getElementById('lastPageBtn');

                                                            if (firstBtn)
                                                                firstBtn.disabled = currentPageFromUrl === 1;
                                                            if (prevBtn)
                                                                prevBtn.disabled = currentPageFromUrl === 1;
                                                            if (nextBtn)
                                                                nextBtn.disabled = currentPageFromUrl === totalPages || totalPages === 0;
                                                            if (lastBtn)
                                                                lastBtn.disabled = currentPageFromUrl === totalPages || totalPages === 0;
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
                                                            var urlParams = new URLSearchParams(window.location.search);
                                                            var currentPage = parseInt(urlParams.get('page')) || 1;
                                                            if (currentPage > 1) {
                                                                goToPage(currentPage - 1);
                                                            }
                                                        };

                                                        window.goToNextPage = function () {
                                                            var urlParams = new URLSearchParams(window.location.search);
                                                            var currentPage = parseInt(urlParams.get('page')) || 1;
                                                            var totalPages = <%= request.getAttribute("totalPages") != null ? request.getAttribute("totalPages") : 1 %>;
                                                            if (currentPage < totalPages) {
                                                                goToPage(currentPage + 1);
                                                            }
                                                        };

                                                        window.goToLastPage = function () {
                                                            var totalPages = <%= request.getAttribute("totalPages") != null ? request.getAttribute("totalPages") : 1 %>;
                                                            goToPage(totalPages);
                                                        };

                                                        window.changePageSize = function () {
                                                            var newPageSize = document.getElementById('pageSize').value;
                                                            var params = getUrlParams();
                                                            params.pageSize = newPageSize;
                                                            params.page = 1; // Reset to first page when changing page size
                                                            window.location.href = buildUrlWithParams(params);
                                                        };

                                                        // Note: Search is now handled server-side via applyFilters() function

                                                        // Delete product button click handler
                                                        var currentDeleteProductId = null;

                                                        $('.btn-delete').on('click', function () {
                                                            var productId = $(this).data('product-id');
                                                            var productName = $(this).closest('tr').find('td:eq(1) strong').text();

                                                            // Store product info
                                                            currentDeleteProductId = productId;

                                                            // Update modal content
                                                            $('#modalProductName').text(productName);

                                                            // Show modal
                                                            $('#deleteModal').addClass('active');
                                                        });

                                                        // Close modal function
                                                        window.closeDeleteModal = function () {
                                                            $('#deleteModal').removeClass('active');
                                                            currentDeleteProductId = null;
                                                        };

                                                        // Close modal when clicking outside
                                                        $('#deleteModal').on('click', function (e) {
                                                            if ($(e.target).is('#deleteModal')) {
                                                                closeDeleteModal();
                                                            }
                                                        });

                                                        // Close modal on ESC key
                                                        $(document).on('keydown', function (e) {
                                                            if (e.key === 'Escape' && $('#deleteModal').hasClass('active')) {
                                                                closeDeleteModal();
                                                            }
                                                        });

                                                        // Confirm delete button
                                                        $('#confirmDeleteBtn').on('click', function () {
                                                            if (currentDeleteProductId) {
                                                                // Create and submit form
                                                                var form = $('<form>', {
                                                                    'method': 'POST',
                                                                    'action': '../warestaff/deleteProduct'
                                                                });

                                                                var input = $('<input>', {
                                                                    'type': 'hidden',
                                                                    'name': 'id',
                                                                    'value': currentDeleteProductId
                                                                });

                                                                form.append(input);
                                                                $('body').append(form);
                                                                form.submit();
                                                            }
                                                        });

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

                                                        // Auto-hide success and error messages after 3 seconds
                                                        setTimeout(function () {
                                                            $('.alert-success').fadeOut(500, function () {
                                                                $(this).remove();
                                                            });
                                                            $('.alert-danger').fadeOut(500, function () {
                                                                $(this).remove();
                                                            });
                                                        }, 3000);

                                                        // Apply filters function
                                                        window.applyFilters = function () {
                                                            var searchQuery = document.getElementById('searchInput').value;
                                                            var category = document.getElementById('categoryFilter').value;
                                                            var brand = document.getElementById('brandFilter').value;
                                                            var status = document.getElementById('statusFilter').value;

                                                            // Build URL with parameters
                                                            var url = window.location.pathname + '?';
                                                            var params = [];

                                                            if (searchQuery && searchQuery.trim() !== '') {
                                                                params.push('search=' + encodeURIComponent(searchQuery));
                                                            }
                                                            if (category && category !== 'ALL') {
                                                                params.push('category=' + category);
                                                            }
                                                            if (brand && brand !== 'ALL') {
                                                                params.push('brand=' + brand);
                                                            }
                                                            if (status && status !== '' && status !== 'ALL') {
                                                                params.push('status=' + encodeURIComponent(status));
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

