<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Warehouse | Add Product</title>
    <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
    <link href="<%=request.getContextPath()%>/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="<%=request.getContextPath()%>/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="<%=request.getContextPath()%>/css/ionicons.min.css" rel="stylesheet" type="text/css" />
    <link href="<%=request.getContextPath()%>/css/daterangepicker/daterangepicker-bs3.css" rel="stylesheet" type="text/css" />
    <link href='http://fonts.googleapis.com/css?family=Lato' rel='stylesheet' type='text/css'>
    <link href="<%=request.getContextPath()%>/css/admin/style.css" rel="stylesheet" type="text/css" />
</head>
<body class="skin-black">

<header class="header">
    <a href="<%=request.getContextPath()%>/admin/dashboard.jsp" class="logo">Warehouse</a>
    <nav class="navbar navbar-static-top" role="navigation">
        <a href="#" class="navbar-btn sidebar-toggle" data-toggle="offcanvas" role="button">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </a>
    </nav>
    </header>

<div class="wrapper row-offcanvas row-offcanvas-left">
    <aside class="left-side sidebar-offcanvas">
        <section class="sidebar">
            <div class="user-panel">
                <div class="pull-left image">
                    <img src="<%=request.getContextPath()%>/img/warehouse-user.png" class="img-circle" alt="User Image" onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iMjAiIGN5PSIyMCIgcj0iMjAiIGZpbGw9IiM2NzdFRUEiLz4KPHN2ZyB4PSI4IiB5PSI4IiB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTEyIDEyQzE0LjIwOTEgMTIgMTYgMTAuMjA5MSAxNiA4QzE2IDUuNzkwODYgMTQuMjA5MSA0IDEyIDRDOS43OTA4NiA0IDggNS43OTA4NiA4IDhDOCAxMC4yMDkxIDkuNzkwODYgMTIgMTIgMTJaIiBmaWxsPSJ3aGl0ZSIvPgo8cGF0aCBkPSJNMTIgMTRDOC42ODYyOSAxNCA2IDE2LjY4NjMgNiAyMEgxOEMxOCAxNi42ODYzIDE1LjMxMzcgMTQgMTIgMTRaIiBmaWxsPSJ3aGl0ZSIvPgo8L3N2Zz4KPC9zdmc+'" />
                </div>
                <div class="pull-left info">
                    <p>${sessionScope.user.fullName}</p>
                    <a href="#"><i class="fa fa-circle text-success"></i> Online</a>
                </div>
            </div>
            <ul class="sidebar-menu">
                <li><a href="dashboard.jsp"><i class="fa fa-dashboard"></i> Dashboard</a></li>
                <li class="active"><a href="addProduct.jsp"><i class="fa fa-plus"></i> Add Product</a></li>
            </ul>
        </section>
    </aside>

    <aside class="right-side">
        <section class="content">
            <div class="row">
                <div class="col-md-12">
                    <section class="panel">
                        <header class="panel-heading">Add Inventory Item</header>
                        <div class="panel-body">
                            <form class="form-horizontal" method="post" action="add-item">
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Name<span style="color:red">*</span></label>
                                    <div class="col-sm-6">
                                        <input type="text" name="name" class="form-control" placeholder="Item name" required />
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Description</label>
                                    <div class="col-sm-6">
                                        <textarea name="description" class="form-control" rows="3" placeholder="Item description"></textarea>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Category<span style="color:red">*</span></label>
                                    <div class="col-sm-4">
                                        <select name="category_id" class="form-control" required>
                                            <option value="">-- Select Category --</option>
                                            <%-- Expect a request attribute 'categories' (List<Category>) to populate options --%>
                                            <%-- Example: --%>
                                            <%-- for(Category c : (List<Category>)request.getAttribute("categories")) { --%>
                                            <%--     out.println("<option value='" + c.getId() + "'>" + c.getName() + "</option>"); --%>
                                            <%-- } --%>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Brand</label>
                                    <div class="col-sm-4">
                                        <select name="brand_id" class="form-control">
                                            <option value="">-- Select Brand --</option>
                                            <%-- Expect 'brands' (List<Brand>) --%>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Image URL</label>
                                    <div class="col-sm-6">
                                        <input type="url" name="image_url" class="form-control" placeholder="https://..." />
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Cost (Purchase Price)<span style="color:red">*</span></label>
                                    <div class="col-sm-3">
                                        <input type="number" step="0.01" min="0" name="purchase_price" class="form-control" placeholder="0.00" required />
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Selling Price</label>
                                    <div class="col-sm-3">
                                        <input type="number" step="0.01" min="0" name="selling_price" class="form-control" placeholder="0.00" />
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Initial Quantity</label>
                                    <div class="col-sm-2">
                                        <input type="number" min="0" name="initial_quantity" class="form-control" value="0" />
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Active</label>
                                    <div class="col-sm-6">
                                        <div class="checkbox">
                                            <label>
                                                <input type="checkbox" name="is_active" checked /> Active
                                            </label>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <div class="col-sm-offset-2 col-sm-6">
                                        <button type="submit" class="btn btn-primary"><i class="fa fa-save"></i> Save Item</button>
                                        <a href="<%=request.getContextPath()%>/admin/dashboard.jsp" class="btn btn-default">Cancel</a>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </section>
                </div>
            </div>
        </section>
        <div class="footer-main">Copyright &copy; Director, 2014</div>
    </aside>
</div>

<script src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js"></script>
<script src="<%=request.getContextPath()%>/js/jquery-ui-1.10.3.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/bootstrap.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/daterangepicker.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/app.js" type="text/javascript"></script>
</body>
</html>


