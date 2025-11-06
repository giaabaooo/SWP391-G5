<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="data.Product" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Warehouse | Stock In</title>
    <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
    <!-- bootstrap 3.0.2 + icons + theme styles to match warehouse pages -->
    <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/ionicons.min.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/morris/morris.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/jvectormap/jquery-jvectormap-1.2.2.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/daterangepicker/daterangepicker-bs3.css" rel="stylesheet" type="text/css" />
    <link href='http://fonts.googleapis.com/css?family=Lato' rel='stylesheet' type='text/css'>
    <link href="${pageContext.request.contextPath}/css/admin/style.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/warehouse/addProduct.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/warehouse/responsive.css" rel="stylesheet" type="text/css" />
    <style>
        /* Use the same pattern as addProduct.css: hidden by default, show via .show */
        .validation-error {
            display: none;
            color: #dc3545;
            font-style: italic;
            font-size: 12px;
            margin-top: 4px;
        }
        .validation-error.show { display: block; }
        .form-control.error {
            border-color: #dc3545;
            box-shadow: inset 0 1px 1px rgba(0,0,0,0.075), 0 0 0 2px rgba(220,53,69,0.1);
        }
    </style>
</head>
<body class="skin-black">

<!-- Mobile Menu Toggle -->
<button class="mobile-menu-toggle" onclick="toggleMobileMenu()">
    <i class="fa fa-bars"></i>
    </button>

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
                        <li><a href="${pageContext.request.contextPath}/user/logout"><i class="fa fa-ban fa-fw pull-right"></i> Logout</a></li>
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

                <!-- Products -->
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
                    <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">Stock In</h1>
                    <p style="color: #718096; margin-bottom: 2rem;">Record product imports and update inventory</p>

                    <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger" style="background-color: #fed7d7; border: 1px solid #fc8181; color: #742a2a; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;">
                        <i class="fa fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
                    </div>
                    <% } %>
                </div>
            </div>

            <!-- Content Card -->
            <div class="row">
                <div class="col-md-12">
                    <div class="content-card">
                        <div class="card-header">
                            <h3><i class="fa fa-upload"></i> Stock In Form</h3>
                        </div>
                        <div class="card-body" style="padding:1.25rem;">
                            <%
                                Product product = (Product) request.getAttribute("product");
                                List<Product> products = (List<Product>) request.getAttribute("products");
                            %>
                            <form method="post" action="<%= request.getContextPath() %>/warestaff/addImportTransaction" id="stockInForm" novalidate>
                                <% if (product != null) { %>
                                <input type="hidden" name="productId" value="<%= product.getId() %>"/>
                                <div class="form-group">
                                    <label class="control-label">Product</label>
                                    <input type="text" class="form-control" value="<%= product.getName() %>" disabled />
                                </div>
                                <% } else { %>
                                <div class="form-group">
                                    <label class="control-label">Select product<span style="color:red">*</span></label>
                                    <select name="productId" id="productId" class="form-control" required>
                                        <option value="">-- Select --</option>
                                        <% if (products != null) {
                                               for (Product p : products) { %>
                                            <option value="<%= p.getId() %>"><%= p.getName() %></option>
                                        <%   }
                                           } %>
                                    </select>
                                    <div class="validation-error" id="productError">Please select a product</div>
                                </div>
                                <% } %>

                                <div class="form-group">
                                    <label class="control-label">Quantity<span style="color:red">*</span></label>
                                    <input type="number" name="quantity" id="quantity" class="form-control" min="1" placeholder="Quantity" required />
                                    <div class="validation-error" id="quantityError">Quantity must be a positive number</div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label">Transaction time</label>
                                    <input type="datetime-local" name="transactionDate" class="form-control" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm").format(new java.util.Date()) %>" />
                                </div>
                                <div class="form-group">
                                    <label class="control-label">Supplier (optional)</label>
                                    <input type="text" name="supplier" id="supplier" class="form-control" placeholder="Supplier name" />
                                </div>
                                <div class="form-group">
                                    <label class="control-label">Note (optional)</label>
                                    <textarea name="note" class="form-control" rows="3" placeholder="Additional notes"></textarea>
                                </div>
                                <div class="form-group" style="margin-top:1rem;">
                                    <button type="submit" class="btn btn-primary" id="submitBtn"><i class="fa fa-upload"></i> Save</button>
                                    <a href="<%= request.getContextPath() %>/warestaff/viewListProduct" class="btn btn-default">Cancel</a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

        </section>
    </aside>
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
<script>
    function toggleMobileMenu(){
        var left = document.querySelector('.left-side');
        if(left){ left.classList.toggle('show'); }
    }
    // Simple validation similar to addProduct.js style
    (function(){
        function showError(id, message){
            var el = document.getElementById(id);
            if(el){
                el.textContent = message;
                el.classList.add('show');
            }
        }
        function hideError(id){
            var el = document.getElementById(id);
            if(el){ el.classList.remove('show'); }
        }
        function clearErrors(){
            document.getElementById('quantity').classList.remove('error');
            hideError('quantityError');
            var pid = document.getElementById('productId');
            if(pid){ pid.classList.remove('error'); }
            hideError('productError');
        }
        document.getElementById('stockInForm').addEventListener('submit', function(e){
            clearErrors();
            var pid = document.getElementById('productId');
            var qty = document.getElementById('quantity');
            var valid = true;
            if (pid && (pid.value === '' || pid.value === null)) {
                valid = false;
                pid.classList.add('error');
                showError('productError', 'Please select a product');
            }
            var q = parseInt(qty.value, 10);
            if (isNaN(q) || q <= 0) {
                valid = false;
                qty.classList.add('error');
                showError('quantityError', 'Quantity must be a positive number');
            }
            if (!valid) {
                e.preventDefault();
                return false;
            }
            var btn = document.getElementById('submitBtn');
            if (btn) { btn.disabled = true; btn.innerHTML = '<i class="fa fa-spinner fa-spin"></i> Saving...'; }
            setTimeout(function(){ if(btn){ btn.disabled = false; btn.innerHTML = '<i class="fa fa-upload"></i> Save'; } }, 5000);
        });
        // Live clear
        var pidSel = document.getElementById('productId');
        if(pidSel){ pidSel.addEventListener('change', function(){ if(this.value){ this.classList.remove('error'); hideError('productError'); } }); }
        var qtyInp = document.getElementById('quantity');
        if(qtyInp){ qtyInp.addEventListener('input', function(){ var v = parseInt(this.value,10); if(!isNaN(v) && v>0){ this.classList.remove('error'); hideError('quantityError'); } }); }
    })();
</script>
</body>
</html>


