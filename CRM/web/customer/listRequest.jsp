<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="data.Product" %>
<%@ page import="data.CustomerRequest" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Customer | View List Request</title>
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
        <input type="hidden" id="baseUrl" value="${pageContext.request.contextPath}/customer/listRequest">
        <!-- HEADER -->
        <header class="header">
            <a href="dashboard.jsp" class="logo" style="color: #ffffff; font-weight: 600; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">${sessionScope.user.role.name}</a>
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
                        <li><a href="dashboard.jsp"><i class="fa fa-dashboard"></i> Dashboard</a></li>


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
                    <form method="get" action="${pageContext.request.contextPath}/customer/listRequest" class="form-inline mb-3">
                        <!-- Page Header -->
                        <div class="row">
                            <div class="col-md-12">
                                <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">View List Request</h1>


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
                                        <h3><i class="fa fa-list"></i> Request List</h3>
                                        <a href="../customer/createRequest" class="btn btn-primary">
                                            <i class="fa fa-plus"></i> Add New Request
                                        </a>

                                    </div>

                                    <!-- Filter Bar -->
                                    <div class="filter-bar">
                                        <input type="text" id="searchInput" name="search" class="search-input" placeholder="Search by device name..." 
                                               value="<c:out value='${search}'/>">

                                        <select id="typeFilter" name="type" class="search-input" style="min-width: 150px;">
                                            <option value="ALL" ${empty param.type || param.type == 'ALL' ? 'selected' : ''}>All Types</option>
                                            <c:forEach var="t" items="${types}">
                                                <option value="${t}" ${param.type == t ? 'selected' : ''}>${t}</option>
                                            </c:forEach>
                                        </select>

                                        <select id="statusFilter" name="status" class="search-input" style="min-width: 150px;">
                                            <option value="ALL" ${empty param.status || param.status == 'ALL' ? 'selected' : ''}>All Statuses</option>
                                            <c:forEach var="s" items="${statuses}">
                                                <option value="${s}" ${param.status == s ? 'selected' : ''}>${s}</option>
                                            </c:forEach>
                                        </select>

                                        <button class="btn btn-primary" onclick="applyFilters()">
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
                                                        <th>No</th>
                                                        <th>Device</th>
                                                        <th>Title</th>
                                                        <th>Type</th>
                                                        <th>Date</th>                                                       
                                                        <th>Status</th>
                                                        <th>Actions</th>
                                                    </tr>
                                                </thead>

                                                <tbody>
                                                    <% 
                                                        List<CustomerRequest> list = (List<CustomerRequest>) request.getAttribute("list");                   
                                                        int no = 1;
                                                        if (list != null) {
                                                        for (CustomerRequest req : list) {
                                                    %>
                                                    <tr>
                                                        <td><%= no++ %></td>
                                                        <td><%= req.getProductName() %></td>
                                                        <td><%= req.getTitle() %></td>
                                                        <td><%= req.getRequest_type() %></td>
                                                        <td><%= req.getRequest_date() %></td>
                                                        <td><%= req.getStatus() %></td>
                                                        <td>
                                                            <a href="detailRequest?id=<%= req.getId() %>" class="btn btn-action btn-view" style="text-decoration: none;">
                                                                <i class="fa fa-eye"></i> Detail
                                                            </a>
                                                            <a href="updateRequest?id=<%= req.getId() %>" class="btn btn-action btn-edit" style="text-decoration: none;">
                                                                <i class="fa fa-edit"></i> Update
                                                            </a>
                                                            <button type="button" class="btn btn-action btn-danger btn-delete-request"
                                                                    data-request-id="<%= req.getId() %>"
                                                                    data-request-title="<%= req.getTitle() != null ? req.getTitle() : "Request #" + req.getId() %>">
                                                                <i class="fa fa-trash"></i> Cancel
                                                            </button>
                                                            <%-- ========================================================= --%>
                                                            <%-- SỬA LẠI LOGIC NÚT "PAY" / "PAID" --%>
                                                            <% 
         // 1. Lấy trạng thái từ đối tượng 'req' (biến Java)
         String reqStatus = req.getStatus();
         String paymentStatus = req.getPaymentStatus(); // Dùng getter camelCase
    
         // 2. Kiểm tra logic
         if ("AWAITING_PAYMENT".equals(reqStatus) && 
             (paymentStatus != null && ("UNPAID".equals(paymentStatus) || "PARTIALLY_PAID".equals(paymentStatus)))) {
                                                            %>
                                                            <%-- Nếu đúng -> Hiển thị nút "Pay Now" --%>
                                                            <a href="${pageContext.request.contextPath}/customer/payment?id=<%= req.getId() %>" 
                                                               class="btn btn-action btn-success" 
                                                               style="text-decoration: none; margin-left: 5px;">
                                                                <i class="fa fa-credit-card"></i> Pay Now
                                                            </a>
                                                            <% 
                                                                } else if ("PAID".equals(paymentStatus) || "PAID".equals(reqStatus)) {
                                                            %>
                                                            <%-- Nếu đã trả tiền -> Hiển thị nút "Paid" --%>
                                                            <a href="${pageContext.request.contextPath}/customer/payment?id=<%= req.getId() %>" 
                                                               class="btn btn-action btn-info" 
                                                               style="text-decoration: none; margin-left: 5px;">
                                                                <i class="fa fa-check-circle"></i> Paid
                                                            </a>
                                                            <% 
                                                                } 
                                                                // Nếu không rơi vào 2 trường hợp trên, không hiển thị gì cả
                                                            %>
                                                            <%-- ========================================================= --%>
                                                            <%-- ========================================================= --%>
                                                        </td>
                                                    </tr>
                                                    <%
                                                            }
                                                        } else {
                                                    %>
                                                    <tr>
                                                        <td colspan="8">No request found.</td>
                                                    </tr>
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
        <div id="deleteRequestModal" class="modal-overlay">
            <div class="delete-modal">
                <div class="modal-header-custom">
                    <div class="modal-icon" style="background-color: #dc3545;">
                        <i class="fa fa-trash"></i>
                    </div>
                    <h3>Cancel Request</h3> 
                </div>
                <div class="modal-body-custom">
                    <p class="warning-text">Are you sure you want to cancel this request?</p>
                    <div class="product-name-display" id="modalRequestTitle" 
                         style="font-weight: bold; margin: 10px 0; padding: 10px; background-color: #f8f9fa; border-radius: 4px;">
                        <%-- JavaScript sẽ điền Title vào đây --%>
                    </div>                  
                    <span class="warning-badge" style="background-color: #fff3cd; color: #856404; border: 1px solid #ffeeba;">
                        <i class="fa fa-exclamation-triangle"></i> This action sets the request status to inactive.
                    </span>
                </div>
                <div class="modal-footer-custom">
                    <button class="modal-btn modal-btn-cancel" onclick="closeDeleteRequestModal()"> 
                        <i class="fa fa-times"></i> Close 
                    </button>
                    <button class="modal-btn modal-btn-delete" id="confirmDeleteRequestBtn" style="background-color: #dc3545;"> 
                        <i class="fa fa-trash"></i> Confirm  
                    </button>
                </div>
            </div>
        </div>

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
        <script src="${pageContext.request.contextPath}/js/customer/listRequest.js" type="text/javascript"></script>

        <script>
                        var totalProducts = ${not empty totalProducts ? totalProducts : 0};
                        var totalPages = ${not empty totalPages ? totalPages : 1};
                        var currentPage = ${not empty currentPage ? currentPage : 1};
                        var currentLimit = ${not empty pageSize ? pageSize : 10};
                        $(function () {

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
                                var status = document.getElementById('statusFilter').value;


                                var params = [];

                                if (searchQuery && searchQuery.trim() !== '') {
                                    params.push('search=' + encodeURIComponent(searchQuery));
                                }
                                if (type && type !== 'ALL') {
                                    params.push('type=' + encodeURIComponent(type));
                                }
                                if (status && status !== 'ALL') {
                                    params.push('status=' + encodeURIComponent(status));
                                }

                                let url = window.location.pathname;
                                if (params.length > 0) {
                                    url += '?' + params.join('&');
                                }
                                console.log("Redirect to:", url);

                                window.location.href = url;


                            };

                            // Clear filters function
                            window.clearFilters = function () {
                                var baseUrl = document.getElementById('baseUrl').value;
                                window.location.href = baseUrl;
                            };

                            // Handle Enter key in search input
                            $('#searchInput').on('keypress', function (e) {
                                if (e.which === 13) { // Enter key
                                    applyFilters();
                                }
                            });

//                                                         Handle change event for dropdowns
//                                                        $('#typeFilter, #statusFilter').on('change', function () {
//                                                            applyFilters();
//                                                        });
                        });
        </script>
    </body>
</html>

