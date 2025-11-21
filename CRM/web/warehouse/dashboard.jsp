<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Warehouse Staff | Dashboard</title>
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
    <link href="../css/warehouse/dashboard.css" rel="stylesheet" type="text/css" />
    <link href="../css/warehouse/responsive.css" rel="stylesheet" type="text/css" />
    <style>
        /* Pastel theme tweaks */
        body.skin-black { background-color:#f8fafc; }
        .content-card { background:#ffffff; border:1px solid #e9ecff; border-radius:10px; box-shadow: 0 1px 2px rgba(99,102,241,0.04); }
        .content-card .card-header { border-bottom:1px solid #eef2ff; padding:12px 16px; background:#fbfdff; }
        .content-card .card-body { padding:16px; }
        .modern-table th, .modern-table td { border-color:#eef2ff; }
        /* Reduce chart visual size */
        #summaryChart, #todayChart { max-height:260px !important; }
    </style>
</head>
<body class="skin-black">

<!-- HEADER -->
<header class="header">
    <a href="${pageContext.request.contextPath}/warestaff/dashboard" class="logo" style="color: #ffffff; font-weight: 600; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">Warehouse Staff</a>
    <nav class="navbar navbar-static-top" role="navigation">
        <a href="#" class="navbar-btn sidebar-toggle" data-toggle="offcanvas" role="button">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </a>
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
                    <img src="${pageContext.request.contextPath}/img/warehouse-user.png" class="img-circle" alt="User Image" onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iMjAiIGN5PSIyMCIgcj0iMjAiIGZpbGw9IiM2NzdFRUEiLz4KPHN2ZyB4PSI4IiB5PSI4IiB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTEyIDEyQzE0LjIwOTEgMTIgMTYgMTAuMjA5MSAxNiA4QzE2IDUuNzkwODYgMTQuMjA5MSA0IDEyIDRDOS43OTA4NiA0IDggNS43OTA4NiA4IDhDOCAxMC4yMDkxIDkuNzkwODYgMTIgMTIgMTJaIiBmaWxsPSJ3aGl0ZSIvPgo8cGF0aCBkPSJNMTIgMTRDOC42ODYyOSAxNCA2IDE2LjY4NjMgNiAyMEgxOEMxOCAxNi42ODYzIDE1LjMxMzcgMTQgMTIgMTRaIiBmaWxsPSJ3aGl0ZSIvPgo8L3N2Zz4KPC9zdmc+'" />
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
                    <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">Warehouse Dashboard</h1>
                    <p style="color: #718096; margin-bottom: 2rem;">Monitor inventory, manage requests, and track warehouse activities</p>
                </div>
            </div>

            <!-- Biểu đồ tổng quan tồn kho và nhập/xuất theo tháng -->
            <div class="row">
                <div class="col-md-6">
                    <h3 style="margin: 0 0 8px; color:#111827;"><i class="fa fa-cubes"></i> Inventory Summary (Products)</h3>
                    <canvas id="summaryChart" height="110"></canvas>
                </div>
                <div class="col-md-6">
                    <h3 style="margin: 0 0 8px; color:#111827;"><i class="fa fa-exchange"></i> Month Imports/Exports</h3>
                    <canvas id="todayChart" height="110"></canvas>
                </div>
            </div>

            <!-- Bảng giao dịch gần nhất -->
            <div class="row">
                <div class="col-md-12">
                    <div class="content-card">
                        <div class="card-header">
                            <h3><i class="fa fa-history"></i> Recent Transactions</h3>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table modern-table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Type</th>
                                            <th>Product</th>
                                            <th>Quantity</th>
                                            <th>Date</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <% java.util.List<data.Transaction> rtx = (java.util.List<data.Transaction>) request.getAttribute("recentTransactions");
                                       if (rtx != null && !rtx.isEmpty()) {
                                           for (data.Transaction t : rtx) { %>
                                        <tr>
                                            <td>#<%= t.getId() %></td>
                                            <td><%= t.getType() %></td>
                                            <td><%= t.getProductName() != null ? t.getProductName() : ("ID:"+t.getProductId()) %></td>
                                            <td><%= t.getQuantity() %></td>
                                            <td><%= t.getTransactionDate() %></td>
                                        </tr>
                                    <%   }
                                       } else { %>
                                        <tr><td colspan="5" style="color:#6b7280; text-align:center;">No recent transactions</td></tr>
                                    <% } %>
                                    </tbody>
                                </table>
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
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<script src="../js/icheck.min.js" type="text/javascript"></script>
<script src="../js/fullcalendar.js" type="text/javascript"></script>
<script src="../js/app.js" type="text/javascript"></script>
<script src="../js/dashboard.js" type="text/javascript"></script>
<script src="../js/warehouse/dashboard.js" type="text/javascript"></script>

<script>
    (function(){
        // Dữ liệu biểu đồ tuần (import/export) truyền từ controller
        var labels = <%
            java.util.List<String> lbl = (java.util.List<String>) request.getAttribute("chartLabels");
            out.print(lbl != null ? new com.google.gson.Gson().toJson(lbl) : "[]");
        %>;
        var dataImport = <%
            java.util.List<Integer> imp = (java.util.List<Integer>) request.getAttribute("chartImport");
            out.print(imp != null ? new com.google.gson.Gson().toJson(imp) : "[]");
        %>;
        var dataExport = <%
            java.util.List<Integer> exp = (java.util.List<Integer>) request.getAttribute("chartExport");
            out.print(exp != null ? new com.google.gson.Gson().toJson(exp) : "[]");
        %>;
        // removed weekly chart

        // Summary charts
        if (window.Chart && document.getElementById('summaryChart')){
            var sctx = document.getElementById('summaryChart').getContext('2d');
            var low = ${lowStockCount != null ? lowStockCount : 0};
            var active = ${activeProducts != null ? activeProducts : 0};
            var other = Math.max(active - low, 0);
            new Chart(sctx, {
                type: 'doughnut',
                data: {
                    labels: ['Low-stock products','Other active products'],
                    datasets: [{
                        data: [low, other],
                        backgroundColor: ['rgba(252,165,165,0.85)','rgba(165,180,252,0.85)']
                    }]
                },
                options: {
                    responsive: true,
                    plugins: { legend: { position: 'bottom', labels: { color: '#111827' } } }
                }
            });
        }

        if (window.Chart && document.getElementById('todayChart')){
            var tCanvas = document.getElementById('todayChart');
            var tctx = tCanvas.getContext('2d');
            var dayLabels = <%
                java.util.List<String> mdl = (java.util.List<String>) request.getAttribute("monthDayLabels");
                out.print(mdl != null ? new com.google.gson.Gson().toJson(mdl) : "[]");
            %>;
            var impSeries = <%
                java.util.List<Integer> mdi = (java.util.List<Integer>) request.getAttribute("monthDayImport");
                out.print(mdi != null ? new com.google.gson.Gson().toJson(mdi) : "[]");
            %>;
            var expSeries = <%
                java.util.List<Integer> mde = (java.util.List<Integer>) request.getAttribute("monthDayExport");
                out.print(mde != null ? new com.google.gson.Gson().toJson(mde) : "[]");
            %>;

            var totalPoints = (impSeries.reduce((a,b)=>a+b,0) + expSeries.reduce((a,b)=>a+b,0));
            if (totalPoints === 0) {
                var msg = 'No transactions recorded this month';
                tctx.clearRect(0, 0, tCanvas.width, tCanvas.height);
                tctx.fillStyle = '#6b7280';
                tctx.font = '16px Segoe UI, Arial, sans-serif';
                tctx.textAlign = 'center';
                tctx.fillText(msg, tCanvas.width/2, tCanvas.height/2);
            } else {
                new Chart(tctx, {
                    type: 'line',
                    data: {
                        labels: dayLabels.map(d => d.substring(8)), // show day only
                        datasets: [
                            { label: 'Import', data: impSeries, borderColor: 'rgba(96,165,250,1)', backgroundColor: 'rgba(96,165,250,0.25)', tension: 0.3, fill: true },
                            { label: 'Export', data: expSeries, borderColor: 'rgba(52,211,153,1)', backgroundColor: 'rgba(52,211,153,0.25)', tension: 0.3, fill: true }
                        ]
                    },
                    options: {
                        responsive: true,
                        plugins: { legend: { position:'bottom', labels: { color:'#111827' } } },
                        scales: {
                            x: { ticks: { color: '#374151' }, grid: { display:false } },
                            y: { ticks: { color: '#374151' }, grid: { color:'#eef2ff' }, beginAtZero:true, precision:0 }
                        }
                    }
                });
            }
        }
    })();
</script>

</body>
</html>