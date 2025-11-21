<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="data.Brand" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Warehouse Staff | Edit Brand</title>
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
    <link href="${pageContext.request.contextPath}/css/warehouse/responsive.css" rel="stylesheet" type="text/css" />
</head>
<body class="skin-black">

<button class="mobile-menu-toggle" onclick="toggleMobileMenu()">
    <i class="fa fa-bars"></i>
  </button>

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
                        <li><a href="../login.jsp"><i class="fa fa-ban fa-fw pull-right"></i> Logout</a></li>
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
                    <a href="javascript:void(0)" data-toggle="collapse" data-target="#inventoryMenu" aria-expanded="false">
                        <i class="fa fa-cubes"></i> <span>Products</span>
                    </a>
                    <ul class="collapse" id="inventoryMenu">
                        <li><a href="../warestaff/viewListProduct"><i class="fa fa-list"></i> View List Product</a></li>
                        <li><a href="../warestaff/addNewProduct"><i class="fa fa-plus"></i> Add Product</a></li>
                    </ul>
                </li>
                <!-- Categories -->
                <li class="treeview">
                    <a href="javascript:void(0)" data-toggle="collapse" data-target="#categoryMenu" aria-expanded="false">
                        <i class="fa fa-tags"></i> <span>Categories</span>
                    </a>
                    <ul class="collapse" id="categoryMenu">
                        <li><a href="../warestaff/categoryList"><i class="fa fa-eye"></i> View Categories</a></li>
                        <li><a href="../warestaff/addCategory"><i class="fa fa-plus"></i> Add Category</a></li>
                    </ul>
                </li>
                <!-- Brands -->
                <li class="treeview">
                    <a href="javascript:void(0)" data-toggle="collapse" data-target="#brandMenu" aria-expanded="false">
                        <i class="fa fa-bookmark"></i> <span>Brands</span>
                    </a>
                    <ul class="collapse" id="brandMenu">
                        <li><a href="../warestaff/brandList"><i class="fa fa-eye"></i> View Brands</a></li>
                        <li><a href="../warestaff/addBrand"><i class="fa fa-plus"></i> Add Brand</a></li>
                    </ul>
                </li>
                <!-- Transactions -->
                <li class="treeview">
                    <a href="javascript:void(0)" data-toggle="collapse" data-target="#transactionMenu" aria-expanded="false">
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

    <aside class="right-side">
        <section class="content">
            <div class="row">
                <div class="col-md-12">
                    <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">Edit Brand</h1>
                    <p style="color: #718096; margin-bottom: 2rem;">Update brand details</p>
                    <% Brand brand = (Brand) request.getAttribute("brand"); %>
                    <!-- Thông báo lỗi trả về từ EditBrandController -->
                    <% if (request.getAttribute("error") != null && !"Brand name is required".equals(request.getAttribute("error"))) { %>
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
                            <h3><i class="fa fa-edit"></i> Brand Information</h3>
                        </div>
                        <div class="card-body">
                            <!-- Form cập nhật thông tin thương hiệu -->
                            <form method="post" action="../warestaff/editBrand" novalidate>
                                <input type="hidden" name="id" value="<%= brand != null ? brand.getId() : 0 %>" />
                                <div class="form-row">
                                    <div class="form-col">
                                        <div class="form-group">
                                            <label class="control-label">Brand Name<span style="color:red">*</span></label>
                                            <input type="text" id="brandName" name="name" class="form-control<%= "Brand name is required".equals(request.getAttribute("error")) ? " error" : "" %>" placeholder="Enter brand name" required value="<%= brand != null ? brand.getName() : "" %>" />
                                            <div class="validation-error <%= "Brand name is required".equals(request.getAttribute("error")) ? "show" : "" %>" id="brandNameError">Brand name is required</div>
                                        </div>
                                    </div>
                                    <div class="form-col">
                                        <div class="form-group">
                                            <label class="control-label">Status</label>
                                            <div class="checkbox-container">
                                                <label class="checkbox-label">
                                                    <input type="checkbox" name="is_active" <%= brand != null && brand.isActive() ? "checked" : "" %> />
                                                    <span class="checkbox-text">Active</span>
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div class="form-col-full">
                                        <div class="form-group">
                                            <label class="control-label">Description</label>
                                            <textarea name="description" class="form-control" rows="4" placeholder="Add an optional description"><%= brand != null ? brand.getDescription() : "" %></textarea>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-row" style="margin-top: 2rem; padding-top: 1.5rem; border-top: 1px solid #e2e8f0; margin-bottom: 0;">
                                    <div class="form-col-full text-center">
                                        <!-- Nút submit lưu thay đổi -->
                                        <button type="submit" class="btn btn-primary" style="margin-right: 1rem; min-width: 150px;">
                                            <i class="fa fa-save"></i> Save Changes
                                        </button>
                                        <a href="../warestaff/brandList" class="btn btn-default" style="min-width: 150px;">
                                            <i class="fa fa-arrow-left"></i> Cancel
                                        </a>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

        </section>
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
<script src="${pageContext.request.contextPath}/js/warehouse/warehouse-responsive.js" type="text/javascript"></script>
<script>
(function(){
  var form = document.querySelector('form[action="../warestaff/editBrand"]');
  var nameInput = document.getElementById('brandName');
  var nameError = document.getElementById('brandNameError');
  if (!form || !nameInput || !nameError) return;
  form.addEventListener('submit', function(e) {
    var value = (nameInput.value || '').trim();
    if (!value) {
      e.preventDefault();
      nameError.classList.add('show');
      nameInput.classList.add('error');
      nameInput.scrollIntoView({ behavior: 'smooth', block: 'center' });
      nameInput.focus();
    }
  });
  nameInput.addEventListener('input', function() {
    if ((nameInput.value || '').trim()) {
      nameError.classList.remove('show');
      nameInput.classList.remove('error');
    }
  });
})();

// auto-hide alerts after 3s
setTimeout(function(){
  $('.alert-success').fadeOut(500,function(){ $(this).remove(); });
  $('.alert-danger').fadeOut(500,function(){ $(this).remove(); });
},3000);
</script>

</body>
</html>


