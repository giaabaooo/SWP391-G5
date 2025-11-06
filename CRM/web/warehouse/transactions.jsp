<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="data.Transaction" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Warehouse Staff | Transactions History</title>
    <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
    <meta name="description" content="Warehouse Management System">
    <meta name="keywords" content="Warehouse, Inventory, Management">
    <!-- bootstrap 3.0.2 -->
    <link href="../css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="../css/ionicons.min.css" rel="stylesheet" type="text/css" />
    <link href="../css/morris/morris.css" rel="stylesheet" type="text/css" />
    <link href="../css/jvectormap/jquery-jvectormap-1.2.2.css" rel="stylesheet" type="text/css" />
    <link href="../css/daterangepicker/daterangepicker-bs3.css" rel="stylesheet" type="text/css" />
    <link href="../css/iCheck/all.css" rel="stylesheet" type="text/css" />
    <link href='http://fonts.googleapis.com/css?family=Lato' rel='stylesheet' type='text/css'>
    <link href="../css/admin/style.css" rel="stylesheet" type="text/css" />
    <link href="../css/warehouse/productList.css" rel="stylesheet" type="text/css" />
    <link href="../css/warehouse/responsive.css" rel="stylesheet" type="text/css" />
</head>
<body class="skin-black">

<!-- HEADER -->
<header class="header">
    <a href="${pageContext.request.contextPath}/warestaff/dashboard" class="logo" style="color: #ffffff; font-weight: 600; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">Warehouse Staff</a>
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
                        <li><a href="../user/logout"><i class="fa fa-ban fa-fw pull-right"></i> Logout</a></li>
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
                    <img src="../img/warehouse-user.png" class="img-circle" alt="User Image" onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iMjAiIGN5PSIyMCIgcj0iMjAiIGZpbGw9IiM2NzdFRUEiLz4KPHN2ZyB4PSI4IiB5PSI4IiB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTEyIDEyQzE0LjIwOTEgMTIgMTYgMTAuMjA5MSAxNiA4QzE2IDUuNzkwODYgMTQuMjA5MSA0IDEyIDRDOS43OTA4NiA0IDggNS43OTA4NiA4IDhDOCAxMC4yMDkxIDkuNzkwODYgMTIgMTIgMTJaIiBmaWxsPSJ3aGl0ZSIvPgo8cGF0aCBkPSJNMTIgMTRDOC42ODYyOSAxNCA2IDE2LjY4NjMgNiAyMEgxOEMxOCAxNi42ODYzIDE1LjMxMzcgMTQgMTIgMTRaIiBmaWxsPSJ3aGl0ZSIvPgo8L3N2Zz4KPC9zdmc+'" />
                </div>
                <div class="pull-left info">
                    <p>${sessionScope.user.fullName}</p>
                    <a href="#"><i class="fa fa-circle text-success"></i> Online</a>
                </div>
            </div>

            <ul class="sidebar-menu">
                <li><a href="${pageContext.request.contextPath}/warestaff/dashboard"><i class="fa fa-dashboard"></i> Dashboard</a></li>

                <!-- Product -->
                <li class="treeview">
                    <a href="#inventoryMenu" data-toggle="collapse" aria-expanded="false">
                        <i class="fa fa-cubes"></i> <span>Products</span>
                    </a>
                    <ul class="collapse" id="inventoryMenu">
                        <li><a href="../warestaff/viewListProduct"><i class="fa fa-list"></i> View List Product</a></li>
                        <li><a href="../warestaff/addNewProduct"><i class="fa fa-plus"></i> Add Product</a></li>
                    </ul>
                </li>

                <!-- Categories -->
                <li class="treeview">
                    <a href="#categoryMenu" data-toggle="collapse" aria-expanded="false">
                        <i class="fa fa-tags"></i> <span>Categories</span>
                    </a>
                    <ul class="collapse" id="categoryMenu">
                        <li><a href="../warestaff/categoryList"><i class="fa fa-eye"></i> View Categories</a></li>
                        <li><a href="../warestaff/addCategory"><i class="fa fa-plus"></i> Add Category</a></li>
                    </ul>
                </li>

                <!-- Brands -->
                <li class="treeview">
                    <a href="#brandMenu" data-toggle="collapse" aria-expanded="false">
                        <i class="fa fa-bookmark"></i> <span>Brands</span>
                    </a>
                    <ul class="collapse" id="brandMenu">
                        <li><a href="../warestaff/brandList"><i class="fa fa-eye"></i> View Brands</a></li>
                        <li><a href="../warestaff/addBrand"><i class="fa fa-plus"></i> Add Brand</a></li>
                    </ul>
                </li>

                <!-- Transactions -->
                <li class="treeview">
                    <a href="#transactionMenu" data-toggle="collapse" aria-expanded="false">
                        <i class="fa fa-exchange"></i> <span>Transactions</span>
                    </a>
                    <ul class="collapse" id="transactionMenu">
                        <li><a href="../warestaff/transactions"><i class="fa fa-list"></i> View Transactions</a></li>
                        <li><a href="../warestaff/addImportTransaction"><i class="fa fa-plus"></i> Add Stock In</a></li>
                        <li><a href="../warestaff/addExportTransaction"><i class="fa fa-minus"></i> Add Stock Out</a></li>
                    </ul>
                </li>



                
            </ul>
        </section>
    </aside>

    <!-- MAIN CONTENT -->
    <aside class="right-side">
        <section class="content">
            <!-- Page Header -->
            <div class="row">
                <div class="col-md-12">
                    <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">Transactions History</h1>
                    <p style="color: #718096; margin-bottom: 2rem;">View and manage all import/export transactions</p>
                </div>
            </div>

            <!-- Filter Section -->
            <div class="row">
                <div class="col-md-12">
                    <div class="content-card" style="margin-bottom: 1.5rem;">
                        <div class="card-header">
                            <h3><i class="fa fa-filter"></i> Filter Transactions</h3>
                        </div>

                        <!-- Filter Bar -->
                        <div class="filter-bar">
                            <form method="get" action="<%= request.getContextPath() %>/warestaff/transactions" style="display: flex; align-items: center; gap: 10px; flex-wrap: wrap;">
                                <select name="type" class="search-input" style="min-width: 150px;">
                                    <option value="">All Types</option>
                                    <option value="IMPORT" <%= "IMPORT".equals(request.getAttribute("typeFilter"))?"selected":"" %>>Import (Stock In)</option>
                                    <option value="EXPORT" <%= "EXPORT".equals(request.getAttribute("typeFilter"))?"selected":"" %>>Export (Stock Out)</option>
                                </select>

                                <input type="text" name="q" class="search-input" placeholder="Search in notes..." value="<%= request.getAttribute("searchNote")!=null?request.getAttribute("searchNote"):"" %>" style="min-width: 250px;"/>

                                <button type="submit" class="btn btn-primary">
                                    <i class="fa fa-filter"></i> Filter
                                </button>
                                <a href="<%= request.getContextPath() %>/warestaff/transactions" class="btn btn-primary" style="background: #6c757d; border-color: #6c757d;">
                                    <i class="fa fa-times"></i> Clear
                                </a>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Transaction Table -->
            <div class="row">
                <div class="col-md-12">
                    <div class="content-card">
                        <div class="card-header">
                            <h3><i class="fa fa-list"></i> Transaction Records</h3>
                        </div>
                        <div class="card-body" style="padding:1.25rem;">
                            <%
                                List<Transaction> txs = (List<Transaction>) request.getAttribute("transactions");
                                int currentPage = (Integer) (request.getAttribute("currentPage") != null ? request.getAttribute("currentPage") : 1);
                                int totalPages = (Integer) (request.getAttribute("totalPages") != null ? request.getAttribute("totalPages") : 1);
                            %>
                            <div class="table-responsive">
                                <table class="inventory-table">
                                    <thead>
                                        <tr>
                                            <th style="width: 80px;">ID</th>
                                            <th style="width: 140px;">Type</th>
                                            <th>Product Name</th>
                                            <th style="width: 100px;">Quantity</th>
                                            <th style="width: 180px;">Transaction Date</th>
                                            <th>Note</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% if (txs != null && !txs.isEmpty()) {
                                               for (Transaction t : txs) {
                                                   String typeClass = "IMPORT".equals(t.getType()) ? "badge-active" : "badge-inactive";
                                                   String typeIcon = "IMPORT".equals(t.getType()) ? "fa-arrow-down" : "fa-arrow-up";
                                                   String typeText = "IMPORT".equals(t.getType()) ? "Stock In" : "Stock Out";
                                                   String productName = (t.getProductName() != null && !t.getProductName().isEmpty())
                                                       ? t.getProductName()
                                                       : ("Product ID: " + t.getProductId());
                                        %>
                                            <tr>
                                                <td><strong>#<%= t.getId() %></strong></td>
                                                <td>
                                                    <span class="<%= typeClass %>">
                                                        <i class="fa <%= typeIcon %>"></i> <%= typeText %>
                                                    </span>
                                                </td>
                                                <td><strong><%= productName %></strong></td>
                                                <td><strong><%= t.getQuantity() %></strong></td>
                                                <td><%= t.getTransactionDate() %></td>
                                                <td><%= t.getNote() != null && !t.getNote().isEmpty() ? t.getNote() : "<em style='color:#999;'>No note</em>" %></td>
                                            </tr>
                                        <%   }
                                           } else { %>
                                            <tr>
                                                <td colspan="6" class="text-center" style="padding: 2rem; color: #718096;">
                                                    <div class="empty-state">
                                                        <i class="fa fa-inbox"></i>
                                                        <h4>No Transactions Found</h4>
                                                        <p>There are no transactions matching your criteria.</p>
                                                    </div>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>

                            <%
                                String typeFilter = request.getAttribute("typeFilter") != null ? (String) request.getAttribute("typeFilter") : "";
                                String searchNote = request.getAttribute("searchNote") != null ? (String) request.getAttribute("searchNote") : "";
                                Integer pageSize = (Integer) request.getAttribute("pageSize");
                                Integer total = (Integer) request.getAttribute("total");
                                if (pageSize == null) pageSize = 10;
                                if (total == null) total = 0;

                                String queryString = "";
                                if (!typeFilter.isEmpty()) queryString += "&type=" + typeFilter;
                                if (!searchNote.isEmpty()) queryString += "&q=" + searchNote;

                                int startItem = total > 0 ? ((currentPage - 1) * pageSize + 1) : 0;
                                int endItem = Math.min(currentPage * pageSize, total);
                            %>

                            <!-- Pagination Controls -->
                            <div class="pagination-container">
                                <div class="pagination-info">
                                    <span>Showing <%= startItem %> to <%= endItem %> of <%= total %> transactions</span>
                                </div>

                                <div class="pagination-controls">
                                    <button class="pagination-btn <%= currentPage<=1?"disabled":"" %>"
                                            onclick="window.location.href='<%= request.getContextPath() %>/warestaff/transactions?page=1<%= queryString %>'"
                                            <%= currentPage<=1?"disabled":"" %>>
                                        <i class="fa fa-angle-double-left"></i>
                                    </button>
                                    <button class="pagination-btn <%= currentPage<=1?"disabled":"" %>"
                                            onclick="window.location.href='<%= request.getContextPath() %>/warestaff/transactions?page=<%= currentPage-1 %><%= queryString %>'"
                                            <%= currentPage<=1?"disabled":"" %>>
                                        <i class="fa fa-angle-left"></i>
                                    </button>

                                    <div id="pageNumbers">
                                        <%
                                            int startPage = Math.max(1, currentPage - 2);
                                            int endPage = Math.min(totalPages, currentPage + 2);

                                            for (int i = startPage; i <= endPage; i++) {
                                                if (i == currentPage) {
                                        %>
                                                    <button class="pagination-btn active"><%= i %></button>
                                        <%      } else { %>
                                                    <button class="pagination-btn" onclick="window.location.href='<%= request.getContextPath() %>/warestaff/transactions?page=<%= i %><%= queryString %>'"><%= i %></button>
                                        <%      }
                                            }
                                        %>
                                    </div>

                                    <button class="pagination-btn <%= currentPage>=totalPages?"disabled":"" %>"
                                            onclick="window.location.href='<%= request.getContextPath() %>/warestaff/transactions?page=<%= currentPage+1 %><%= queryString %>'"
                                            <%= currentPage>=totalPages?"disabled":"" %>>
                                        <i class="fa fa-angle-right"></i>
                                    </button>
                                    <button class="pagination-btn <%= currentPage>=totalPages?"disabled":"" %>"
                                            onclick="window.location.href='<%= request.getContextPath() %>/warestaff/transactions?page=<%= totalPages %><%= queryString %>'"
                                            <%= currentPage>=totalPages?"disabled":"" %>>
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

<!-- SCRIPTS -->
<script src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js"></script>
<script src="../js/jquery-ui-1.10.3.min.js" type="text/javascript"></script>
<script src="../js/bootstrap.min.js" type="text/javascript"></script>
<script src="../js/daterangepicker.js" type="text/javascript"></script>
<script src="../js/chart.js" type="text/javascript"></script>
<script src="../js/icheck.min.js" type="text/javascript"></script>
<script src="../js/fullcalendar.js" type="text/javascript"></script>
<script src="../js/app.js" type="text/javascript"></script>
<script src="../js/dashboard.js" type="text/javascript"></script>

</body>
</html>


