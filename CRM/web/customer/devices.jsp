<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="data.Product" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
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
                    <!-- Hidden div for server data -->
                    <div id="paginationData" style="display:none;"
                         data-total-devices="<%= request.getAttribute("totalDevices") != null ? request.getAttribute("totalDevices") : 0 %>"
                         data-total-pages="<%= request.getAttribute("totalPages") != null ? request.getAttribute("totalPages") : 1 %>">
                    </div>

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
                                               value="<%= request.getAttribute("search") != null ? request.getAttribute("search") : "" %>" minlength="10" maxlength="80">

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
                                                        <th>Serial</th>
                   
                                     <th>Category</th>
                                                        <th>Brand</th>       
                                                
                                                    
    <th>Status</th>
                                                        <th>Actions</th>
                                        
            </tr>
                                                </thead>

                                        
<tbody>
    <% 
        List<data.Device> devices = (List<data.Device>) request.getAttribute("devices");
        
        // (MỚI) Lấy Set các request đang hoạt động
        Set<String> activeKeys = (Set<String>) request.getAttribute("activeRequestKeys");
        if (activeKeys == null) {
            activeKeys = new HashSet<String>();
        }

        if (devices != null && !devices.isEmpty()) {
            Date currentDate = new Date();
            Calendar cal = Calendar.getInstance();
            
            for (data.Device d : devices) {  
                // (MỚI) Tạo các khóa cho thiết bị này
                String warrantyKey = d.getId() + "_WARRANTY";
                String maintKey = d.getId() + "_MAINTENANCE";
                String repairKey = d.getId() + "_REPAIR";

                // (MỚI) Kiểm tra xem có request đang hoạt động không
                boolean hasActiveWarranty = activeKeys.contains(warrantyKey);
                boolean hasActiveMaintenance = activeKeys.contains(maintKey);
                boolean hasActiveRepair = activeKeys.contains(repairKey);
    %>
    <tr>
        <td><%= d.getId() %></td>
        <td><%= d.getProductName() %></td>
        <td><%= d.getSerialNumber() %></td>
        <td><%= d.getCategoryName() %></td>
        <td><%= d.getBrandName() %></td>
        <td><%= d.getStatus() %></td>
        
        <td>
            <a href="detailDevice?id=<%= d.getId() %>" class="btn btn-action btn-view" style="text-decoration: none;">
                <i class="fa fa-eye"></i> Detail
            </a>

            <%
                boolean isWarrantyValid = false;
                Date warrantyExp = d.getWarrantyExpiration(); 
                if (warrantyExp != null && warrantyExp.after(currentDate)) {
                    isWarrantyValid = true;
                }

                if (isWarrantyValid) {
                    if (hasActiveWarranty) {
            %>
                <button class="btn btn-action btn-success" style="margin-left: 5px;" disabled 
                        title="An active warranty request already exists for this device.">
                    <i class="fa fa-shield"></i> Warranty
                </button>
            <%      } else { %>
                <a href="createRequest?deviceId=<%= d.getId() %>&type=WARRANTY" class="btn btn-action btn-success" style="text-decoration: none; margin-left: 5px;">
                    <i class="fa fa-shield"></i> Warranty
                </a>
            <%
                    } 
                } // Đóng if (isWarrantyValid)
            %>

            <%
                boolean isMaintenanceValid = false;
                Date contractDate = d.getContractDate(); 
                int maintenanceMonths = d.getMaintenanceMonths();
                if (contractDate != null && maintenanceMonths > 0) {
                    cal.setTime(contractDate);
                    cal.add(Calendar.MONTH, maintenanceMonths); 
                    Date maintenanceExp = cal.getTime(); 
                    if (maintenanceExp.after(currentDate)) {
                        isMaintenanceValid = true;
                    }
                }
            
                if (isMaintenanceValid) {
                    if (hasActiveMaintenance) {
            %>
                <button class="btn btn-action btn-info" style="margin-left: 5px;" disabled 
                        title="An active maintenance request already exists for this device.">
                    <i class="fa fa-wrench"></i> Maintenance
                </button>
            <%      } else { %>
                <a href="createRequest?deviceId=<%= d.getId() %>&type=MAINTENANCE" class="btn btn-action btn-info" style="text-decoration: none; margin-left: 5px;">
                    <i class="fa fa-wrench"></i> Maintenance
                </a>
            <%
                    }
                } // Đóng if (isMaintenanceValid)
            %>

            <%
                if (hasActiveRepair) {
            %>
                <button class="btn btn-action btn-danger" style="margin-left: 5px;" disabled 
                        title="An active repair request already exists for this device.">
                    <i class="fa fa-exclamation-triangle"></i> Repair
                </button>
            <%  } else { %>
                <a href="createRequest?deviceId=<%= d.getId() %>&type=REPAIR" class="btn btn-action btn-danger" style="text-decoration: none; margin-left: 5px;">
                    <i class="fa fa-exclamation-triangle"></i> Repair
                </a>
            <%
                } // Đóng if (hasActiveRepair)
            %>
        </td>
    </tr>
    <%
            } // Đóng vòng lặp for
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
                                                <span id="paginationInfo">Showing 1 to 10 of 0 devices</span>
                                            </div>

                                            <div class="page-size-selector">
                                                <label for="pageSize">Show:</label>
                                                <select id="pageSize" onchange="changePageSize()">
                                                    <%
                                                        int currentPageSize = request.getAttribute("pageSize") != null ? 
                                                            (Integer) request.getAttribute("pageSize") : 10;
                                                    %>
                                                    <option value="2" <%= currentPageSize == 2 ? "selected" : "" %>>2</option>
                                                    <option value="5" <%= currentPageSize == 5 ? "selected" : "" %>>5</option>
                                                    <option value="10" <%= currentPageSize == 10 ? "selected" : "" %>>10</option>
                                                    <option value="25" <%= currentPageSize == 25 ? "selected" : "" %>>25</option>
                                                    <option value="50" <%= currentPageSize == 50 ? "selected" : "" %>>50</option>
                                                    <option value="100" <%= currentPageSize == 100 ? "selected" : "" %>>100</option>
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

                                                        // Get server data from data attributes
                                                        function getServerData() {
                                                            var paginationData = document.getElementById('paginationData');
                                                            if (paginationData) {
                                                                return {
                                                                    totalDevices: parseInt(paginationData.dataset.totalDevices) || 0,
                                                                    totalPages: parseInt(paginationData.dataset.totalPages) || 1
                                                                };
                                                            }
                                                            return {totalDevices: 0, totalPages: 1};
                                                        }

                                                        // Helper function to get current URL parameters
                                                        function getUrlParams() {
                                                            var params = new URLSearchParams(window.location.search);
                                                            var urlParams = {};

                                                            if (params.get('search')) {
                                                                urlParams.search = params.get('search');
                                                            }
                                                            if (params.get('category')) {
                                                                urlParams.category = params.get('category');
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
                                                            // Always preserve pageSize if not set, use default
                                                            if (!urlParams.pageSize) {
                                                                urlParams.pageSize = '10';
                                                            }

                                                            return urlParams;
                                                        }

                                                        // Helper function to build URL with parameters
                                                        function buildUrlWithParams(params) {
                                                            var url = window.location.pathname;
                                                            var paramArray = [];

                                                            for (var key in params) {
                                                                var value = params[key];
                                                                if (value !== null && value !== undefined && value !== '') {
                                                                    paramArray.push(key + '=' + encodeURIComponent(String(value)));
                                                                }
                                                            }

                                                            if (paramArray.length > 0) {
                                                                url += '?' + paramArray.join('&');
                                                            }

                                                            return url;
                                                        }

                                                        // Pagination navigation functions (with URL parameters preserved) - Define first
                                                        window.goToPage = function (page) {
                                                            var params = getUrlParams();
                                                            params.page = String(page);
                                                            var newUrl = buildUrlWithParams(params);
                                                            window.location.href = newUrl;
                                                        };

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
                                                            var serverData = getServerData();
                                                            var totalDevices = serverData.totalDevices;

                                                            var startIndex = (currentPageFromUrl - 1) * pageSizeFromUrl + 1;
                                                            var endIndex = Math.min(currentPageFromUrl * pageSizeFromUrl, totalDevices);

                                                            var infoElement = document.getElementById('paginationInfo');
                                                            if (infoElement) {
                                                                if (totalDevices === 0) {
                                                                    infoElement.textContent = 'No devices to display';
                                                                } else {
                                                                    infoElement.textContent =
                                                                            'Showing ' + startIndex + ' to ' + endIndex + ' of ' + totalDevices + ' devices';
                                                                }
                                                            }
                                                        }

                                                        // Render pagination buttons
                                                        function renderPagination() {
                                                            var urlParams = new URLSearchParams(window.location.search);
                                                            var currentPageFromUrl = parseInt(urlParams.get('page')) || 1;
                                                            var serverData = getServerData();
                                                            var totalPages = serverData.totalPages;
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
                                                                btn.setAttribute('type', 'button');
                                                                btn.onclick = (function (pageNum) {
                                                                    return function () {
                                                                        window.goToPage(pageNum);
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
                                                            var serverData = getServerData();
                                                            var totalPages = serverData.totalPages;

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

                                                        window.goToFirstPage = function () {
                                                            window.goToPage(1);
                                                        };

                                                        window.goToPrevPage = function () {
                                                            var urlParams = new URLSearchParams(window.location.search);
                                                            var currentPage = parseInt(urlParams.get('page')) || 1;
                                                            if (currentPage > 1) {
                                                                window.goToPage(currentPage - 1);
                                                            }
                                                        };

                                                        window.goToNextPage = function () {
                                                            var urlParams = new URLSearchParams(window.location.search);
                                                            var currentPage = parseInt(urlParams.get('page')) || 1;
                                                            var serverData = getServerData();
                                                            var totalPages = serverData.totalPages;
                                                            if (currentPage < totalPages) {
                                                                window.goToPage(currentPage + 1);
                                                            }
                                                        };

                                                        window.goToLastPage = function () {
                                                            var serverData = getServerData();
                                                            var totalPages = serverData.totalPages;
                                                            window.goToPage(totalPages);
                                                        };

                                                        window.changePageSize = function () {
                                                            var newPageSize = document.getElementById('pageSize').value;
                                                            var params = getUrlParams();
                                                            params.pageSize = newPageSize;
                                                            params.page = 1; // Reset to first page when changing page size
                                                            window.location.href = buildUrlWithParams(params);
                                                        };

                                                        // Handle collapsible menu
                                                        $('.treeview > a').click(function (e) {
                                                            e.preventDefault();
                                                            var target = $(this).attr('href');
                                                            $(target).collapse('toggle');
                                                        });

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

                                                            // Get current pageSize to preserve it
                                                            var urlParams = new URLSearchParams(window.location.search);
                                                            var currentPageSize = urlParams.get('pageSize');

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
                                                            if (currentPageSize) {
                                                                params.push('pageSize=' + currentPageSize);
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
                                                    });

        </script>   
    </body>
</html>

