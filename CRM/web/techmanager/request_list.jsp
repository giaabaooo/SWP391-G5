<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/techmanager/layout/header.jsp" %>
<%@ include file="/techmanager/layout/sidebar.jsp" %>
<html>
    <head>
        <style>
            /* Professional Dashboard Styles */
            html, body {
                height: 100%;
                overflow: hidden;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: #ffffff;
            }

            .wrapper {
                height: 100vh;
                display: flex;
                flex-direction: column;
                overflow: hidden;
            }

            .right-side {
                flex: 1;
                display: flex;
                flex-direction: column;
                overflow: hidden;
                position: relative;
                height: 100%;
                background: #ffffff;
                min-height: 100vh;
            }

            .content {
                flex: 1;
                padding: 2rem;
                background: #ffffff;
                overflow-y: auto;
                min-height: 0;
                padding-bottom: 2rem;
            }

            .footer-main {
                background-color: #ffffff;
                padding: 1rem;
                border-top: 1px solid #e8ecef;
                text-align: center;
                position: relative;
                margin-top: auto;
                z-index: 1000;
                font-size: 0.875rem;
                color: #6c757d;
                font-weight: 400;
                box-shadow: 0 -1px 3px rgba(0,0,0,0.05);
                flex-shrink: 0;
            }

            /* Remove sidebar dots and search */
            .sidebar-menu li {
                list-style: none;
            }

            .sidebar-menu li:before {
                display: none;
            }

            .sidebar-form {
                display: none;
            }

            /* Modern Card Styles */
            .content-card {
                background: #ffffff;
                border-radius: 12px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
                margin-bottom: 1.5rem;
                border: 1px solid #f1f3f4;
            }

            .card-header {
                padding: 1.25rem 1.5rem;
                border-bottom: 1px solid #f1f3f4;
                background: #fafbfc;
                border-radius: 12px 12px 0 0;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .card-header h3 {
                margin: 0;
                font-size: 1.1rem;
                font-weight: 600;
                color: #2d3748;
                display: flex;
                align-items: center;
            }

            .card-header h3 i {
                margin-right: 0.5rem;
                color: #667eea;
            }

            .card-body {
                padding: 0;
            }

            /* Table Styles */
            .table-responsive {
                overflow-x: auto;
            }

            .inventory-table {
                width: 100%;
                margin: 0;
            }

            .inventory-table thead {
                background: #f8f9fa;
            }

            .inventory-table thead th {
                padding: 1rem;
                font-weight: 600;
                color: #2d3748;
                font-size: 0.875rem;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                border-bottom: 2px solid #e2e8f0;
            }

            .inventory-table tbody td {
                padding: 1rem;
                color: #4a5568;
                font-size: 0.9rem;
                border-bottom: 1px solid #f1f3f4;
                vertical-align: middle;
            }

            .inventory-table tbody tr:hover {
                background-color: #f7fafc;
            }

            /* Badge Styles */
            .badge-active {
                background-color: #d1fae5;
                color: #059669;
                padding: 0.35rem 0.75rem;
                border-radius: 12px;
                font-size: 0.75rem;
                font-weight: 600;
            }

            .badge-inactive {
                background-color: #fee2e2;
                color: #dc2626;
                padding: 0.35rem 0.75rem;
                border-radius: 12px;
                font-size: 0.75rem;
                font-weight: 600;
            }

            /* Action Buttons */
            .btn-action {
                padding: 0.4rem 0.8rem;
                font-size: 0.8rem;
                border-radius: 6px;
                margin: 0 0.2rem;
                transition: all 0.3s ease;
            }

            .btn-edit {
                background-color: #3b82f6;
                color: white;
                border: 1px solid #3b82f6;
            }

            .btn-edit:hover {
                background-color: #2563eb;
                color: white;
            }

            .btn-delete {
                background-color: #ef4444;
                color: white;
                border: 1px solid #ef4444;
            }

            .btn-delete:hover {
                background-color: #dc2626;
                color: white;
            }

            .btn-view {
                background-color: #8b5cf6;
                color: white;
                border: 1px solid #8b5cf6;
            }

            .btn-view:hover {
                background-color: #7c3aed;
                color: white;
            }

            /* Search & Filter Bar */
            .filter-bar {
                padding: 1.5rem;
                background: #f8f9fa;
                border-bottom: 1px solid #e2e8f0;
                display: flex;
                gap: 0.75rem;
                align-items: center;
                flex-wrap: wrap;
            }

            .search-input {
                flex: 1;
                min-width: 150px;
                padding: 0.6rem 1rem;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                font-size: 0.9rem;
                transition: all 0.3s ease;
            }

            .search-input:focus {
                outline: none;
                border-color: #667eea;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            }

            select.search-input {
                cursor: pointer;
                background: white;
            }

            select.search-input:hover {
                border-color: #cbd5e0;
            }

            .btn-primary {
                background: #6366f1;
                border: 1px solid #6366f1;
                border-radius: 8px;
                padding: 0.6rem 1.5rem;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .btn-primary:hover {
                background: #5b5ff5;
                border-color: #5b5ff5;
                transform: translateY(-1px);
                box-shadow: 0 4px 15px rgba(99, 102, 241, 0.3);
            }

            /* Empty State */
            .empty-state {
                text-align: center;
                padding: 3rem 2rem;
                color: #718096;
            }

            .empty-state i {
                font-size: 4rem;
                color: #cbd5e0;
                margin-bottom: 1rem;
            }

            .empty-state h4 {
                color: #4a5568;
                margin-bottom: 0.5rem;
            }

            /* Pagination Styles */
            .pagination-container {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 1.5rem;
                border-top: 1px solid #f1f3f4;
                background: #fafbfc;
                flex-wrap: wrap;
                gap: 1rem;
            }

            .pagination-info {
                color: #4a5568;
                font-size: 0.875rem;
            }

            .pagination-controls {
                display: flex;
                gap: 0.5rem;
                align-items: center;
            }

            .pagination-btn {
                padding: 0.5rem 0.75rem;
                border: 1px solid #e2e8f0;
                background: white;
                color: #4a5568;
                border-radius: 6px;
                cursor: pointer;
                transition: all 0.3s ease;
                font-size: 0.875rem;
                min-width: 40px;
                text-align: center;
            }

            .pagination-btn:hover:not(:disabled) {
                background: #6366f1;
                color: white;
                border-color: #6366f1;
            }

            .pagination-btn:disabled {
                opacity: 0.5;
                cursor: not-allowed;
            }

            .pagination-btn.active {
                background: #6366f1;
                color: white;
                border-color: #6366f1;
                font-weight: 600;
            }

            .page-size-selector {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                font-size: 0.875rem;
                color: #4a5568;
            }

            .page-size-selector select {
                padding: 0.5rem;
                border: 1px solid #e2e8f0;
                border-radius: 6px;
                background: white;
                color: #4a5568;
                cursor: pointer;
            }

            /* Responsive pagination */
            @media (max-width: 768px) {
                .pagination-container {
                    flex-direction: column;
                    align-items: stretch;
                }

                .pagination-info,
                .page-size-selector {
                    text-align: center;
                    justify-content: center;
                }

                .pagination-controls {
                    justify-content: center;
                    flex-wrap: wrap;
                }

                .pagination-btn {
                    font-size: 0.75rem;
                    padding: 0.4rem 0.6rem;
                    min-width: 35px;
                }

                .filter-bar {
                    flex-direction: column;
                    align-items: stretch;
                }

                .search-input {
                    width: 100%;
                    min-width: 100%;
                }

                .filter-bar .btn-primary {
                    width: 100%;
                }
            }

            /* Active menu highlighting */
            .sidebar-menu li.active > a {
                background-color: #667eea !important;
                color: #ffffff !important;
                border-left: 4px solid #5b5ff5;
                font-weight: 600;
            }

            .sidebar-menu li.active > a i {
                color: #ffffff !important;
            }

            .sidebar-menu .treeview.active > a {
                background-color: rgba(102, 126, 234, 0.1) !important;
                color: #667eea !important;
                font-weight: 600;
            }

            /* Custom Delete Modal */
            .modal-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.6);
                display: none;
                justify-content: center;
                align-items: center;
                z-index: 10000;
                backdrop-filter: blur(4px);
                animation: fadeIn 0.3s ease;
            }

            .modal-overlay.active {
                display: flex;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }

            @keyframes slideDown {
                from {
                    opacity: 0;
                    transform: translateY(-50px) scale(0.9);
                }
                to {
                    opacity: 1;
                    transform: translateY(0) scale(1);
                }
            }

            .delete-modal {
                background: white;
                border-radius: 16px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                max-width: 480px;
                width: 90%;
                animation: slideDown 0.3s ease;
                overflow: hidden;
            }

            .modal-header-custom {
                padding: 2rem;
                background: #ffc107;
                color: #2d3748;
                text-align: center;
            }

            .modal-icon {
                width: 80px;
                height: 80px;
                margin: 0 auto 1rem;
                background: rgba(220, 53, 69, 0.2);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 2.5rem;
                color: #dc3545;
            }

            @keyframes pulse {
                0%, 100% {
                    transform: scale(1);
                }
                50% {
                    transform: scale(1.05);
                }
            }

            .modal-header-custom h3 {
                margin: 0;
                font-size: 1.5rem;
                font-weight: 600;
            }

            .modal-body-custom {
                padding: 2rem;
                text-align: center;
            }

            .product-name-display {
                font-size: 1.1rem;
                font-weight: 600;
                color: #dc3545;
                background: #fff5f5;
                padding: 0.75rem 1rem;
                border-radius: 8px;
                margin: 1rem 0;
                word-break: break-word;
                border: 1px solid #fecaca;
            }

            .warning-text {
                color: #4a5568;
                font-size: 0.95rem;
                line-height: 1.6;
                margin: 1rem 0;
            }

            .warning-badge {
                background: #fff5f5;
                color: #dc3545;
                padding: 0.5rem 1rem;
                border-radius: 8px;
                font-size: 0.875rem;
                font-weight: 500;
                display: inline-block;
                margin-top: 0.5rem;
                border: 1px solid #fecaca;
            }

            .modal-footer-custom {
                padding: 1.5rem 2rem;
                background: #f8f9fa;
                display: flex;
                gap: 1rem;
                justify-content: center;
            }

            .modal-btn {
                padding: 0.75rem 2rem;
                border-radius: 8px;
                font-weight: 600;
                font-size: 0.95rem;
                border: 1px solid #e2e8f0;
                cursor: pointer;
                transition: all 0.2s ease;
                min-width: 120px;
            }

            .modal-btn-cancel {
                background: white;
                color: #4a5568;
            }

            .modal-btn-cancel:hover {
                background: #f8f9fa;
                border-color: #cbd5e0;
            }

            .modal-btn-delete {
                background: #dc3545;
                color: white;
                border-color: #dc3545;
            }

            .modal-btn-delete:hover {
                background: #c82333;
                border-color: #c82333;
            }

            /* Remove sidebar dots and search */
            .sidebar-menu li {
                list-style: none;
            }

            .sidebar-menu li:before {
                display: none;
            }

            .sidebar-form {
                display: none;
            }
        </style>
    </head>
    <body class="skin-black">
        <div class="wrapper row-offcanvas row-offcanvas-left">
            <aside class="right-side">
                <section class="content">
                    <!-- Page Header -->
                    <div class="row">
                        <div class="col-md-12">
                            <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">View List Task</h1>
                            <p style="color: #718096; margin-bottom: 2rem;">View and manage all task </p>

                            <c:if test="${not empty error}">
                                <div class="alert alert-danger" style="margin: 10px;">
                                    ${error}
                                </div>
                            </c:if>

                        </div>
                    </div>

                    <!-- Request Table -->
                    <div class="row">
                        <div class="col-md-12">
                            <div class="content-card">
                                <div class="card-header">
                                    <h3><i class="fa fa-list"></i> Request List</h3>
                                    <a href="../warestaff/addNewProduct" class="btn btn-primary">
                                        <i class="fa fa-plus"></i> Assign Task
                                    </a>
                                </div>

                                <!-- Filter Bar -->
                                <form method="get" action="${pageContext.request.contextPath}/techmanager/request" >
                                    <div class="filter-bar">
                                        <input type="hidden" name="action" value="list"/>
                                        <input type="text" name="keyword" class="search-input" placeholder="Search ..." 
                                               value="${param.keyword}">

                                        <input type="date" name="fromDate" class="search-input" value="${param.fromDate}" style="min-width:160px;">
                                        <input type="date" name="toDate" class="search-input" value="${param.toDate}" style="min-width:160px;">


                                        <select name="status" class="search-input" style="min-width: 150px;">
                                            <option value="">--Is Active--</option>
                                            <option value="active" ${param.status=="active"?"selected":""}>Active</option>
                                            <option value="inactive" ${param.status=="inactive"?"selected":""}>Inactive</option>
                                        </select>

                                        <button class="btn btn-primary" type="submit" >
                                            <i class="fa fa-filter"></i> Filter
                                        </button>
                                        <a href="${pageContext.request.contextPath}/techmanager/request?action=list" class="btn btn-primary" style="background: #6c757d; border-color: #6c757d;"><i class="fa fa-times"></i>Clear</a>

                                    </div>
                                </form>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="inventory-table">
                                            <thead>
                                                <tr>
                                                    <th>No.</th>
                                                    <th>Customer</th>
                                                    <th>Device</th>
                                                    <th>Request Type</th>
                                                    <th>Title</th>
                                                    <th>Description</th>
                                                    <th>Request Date</th>
                                                    <th>Status</th>
                                                    <th>Is Active</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="u" items="${requests}" varStatus="st">
                                                    <tr>
                                                        <td>${(page-1)*pageSize + st.index + 1}</td>
                                                        <td>${u.customer.fullName}</td>
                                                        <td>${u.device.productName}</td>
                                                        <td>${u.request_type}</td>
                                                        <td>${u.title}</td>
                                                        <td>${u.description}</td>
                                                        <td>${u.request_date}</td>
                                                        <td>${u.status}</td>
                                                        <td>
                                                            <span class="label ${u.isActive?'label-success':'label-danger'}">
                                                                ${u.isActive?'Active':'Inactive'}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <a href="${pageContext.request.contextPath}/techmanager/request?action=detail&id=${u.id}" class="btn btn-action btn-view">
                                                                <i class="fa fa-eye"></i> Detail
                                                            </a>
                                                            <c:if test="${u.status ne 'REJECTED'}">
                                                                <a href="${pageContext.request.contextPath}/techmanager/request?action=reject&id=${u.id}" class="btn btn-action btn-delete">
                                                                    <i class="fa fa-trash"></i> Reject
                                                                </a>

                                                                <a href="${pageContext.request.contextPath}/cskh/user?action=delete&id=${u.id}" class="btn btn-action btn-edit">
                                                                    <i class="fa fa-angle-right"></i> Assign
                                                                </a>
                                                            </c:if>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty requests}">
                                                    <tr><td colspan="8" class="text-center">No data found</td></tr>
                                                </c:if>
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

                </section>
            </aside>
        </div>
    </body>

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
                                                        if (params.get('categoryId')) {
                                                            urlParams.categoryId = params.get('categoryId');
                                                        }
                                                        if (params.get('brandId')) {
                                                            urlParams.brandId = params.get('brandId');
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
                                                                infoElement.textContent = 'No products to display';
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
                                                        var categoryId = document.getElementById('categoryFilter').value;
                                                        var brandId = document.getElementById('brandFilter').value;

                                                        // Build URL with parameters
                                                        var url = window.location.pathname + '?';
                                                        var params = [];

                                                        if (searchQuery && searchQuery.trim() !== '') {
                                                            params.push('search=' + encodeURIComponent(searchQuery));
                                                        }
                                                        if (categoryId && categoryId !== '') {
                                                            params.push('categoryId=' + categoryId);
                                                        }
                                                        if (brandId && brandId !== '') {
                                                            params.push('brandId=' + brandId);
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
                                                    $('#categoryFilter, #brandFilter').on('change', function () {
                                                        applyFilters();
                                                    });
                                                });
    </script>

</html>