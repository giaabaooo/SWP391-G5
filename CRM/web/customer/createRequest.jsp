<%-- 
    Document   : createRequest
    Created on : Oct 14, 2025, 2:13:40 PM
    Author     : admin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="data.Product" %>
<%@ page import="java.util.List" %>
<%@ page import="data.Device" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Customer | Create Request</title>
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
        <link href="${pageContext.request.contextPath}/css/warehouse/addProduct.css" rel="stylesheet" type="text/css" />
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
                    <!-- Page Header -->
                    <div class="row">
                        <div class="col-md-12">
                            <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">Create New Request</h1>
                            <p style="color: #718096; margin-bottom: 2rem;">Create a new request to Warranty and Repair</p>


                            <% if (request.getAttribute("error") != null) { %>
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
                                    <h3><i class="fa fa-plus"></i> Request</h3>
                                </div>
                                <div class="card-body">
                                    <form method="post" action="${pageContext.request.contextPath}/customer/createRequest" novalidate onsubmit="return validateForm();">



                                        <div class="form-group" id="titleGroup">
                                            <label>Title<span style="color:red">*</span></label>
                                            <input type="text" id="title" name="title" class="form-control" placeholder="Enter issue title" required>
                                            <div class="validation-error" >Title blank</div>
                                        </div>



                                        <div class="form-group" id="deviceGroup">
                                            <label >Select Device<span style="color:red">*</span></label>
                                            <select name="product_id" id="productSelect" class="form-control" onchange="fillProductInfo()" required>
                                                <option value="">-- Choose Device --</option>
                                                <% 
                                                    List<data.Device> devices = (List<data.Device>) request.getAttribute("devices");
                                                    if (devices != null) {
                                                        for (data.Device d : devices) {
                                                %>
                                                <option 
                                                    value="<%= d.getId() %>"   
                                                    data-serial_number="<%= d.getSerialNumber() %>"                                                      
                                                    data-brand="<%= d.getBrandName() %>"
                                                    data-category="<%= d.getCategoryName() %>"
                                                    data-status="<%= d.getStatus() %>" 
                                                    >
                                                    <%= d.getProductName() %>
                                                </option>

                                                <% 
                                                        }
                                                    }
                                                %>
                                            </select>  
                                            <div class="validation-error" >Device is required</div>
                                        </div>
                                        <div class="form-group mt-3">
                                            <label>Serial Number</label>
                                            <input type="text" id="productSerialNumber" class="form-control" readonly>
                                        </div>  

                                        <div class="form-group mt-3">
                                            <label>Brand</label>
                                            <input type="text" id="productBrand" class="form-control" readonly>
                                        </div>

                                        <div class="form-group mt-2">
                                            <label>Category</label>
                                            <input type="text" id="productCategory" class="form-control" readonly>
                                        </div>

                                        <div class="form-group mt-3">
                                            <label>Status</label>
                                            <input type="text" id="productStatus" class="form-control" readonly>
                                        </div>
                                        <div class="form-group">
                                            <label>Issue Description</label>
                                            <textarea name="description" class="form-control" rows="4" placeholder="Describe the issue..."></textarea>
                                        </div>

                                        <div class="form-group">
                                            <label>Desired Completion Date (Optional)</label>
                                            <input type="date" name="desired_date" class="form-control" 
                                                   min="${java.time.LocalDate.now().plusDays(1)}">
                                        </div>
                                        <div class="form-group" style="border-top: 1px solid #f0f0f0; padding-top: 15px;">
                                            <div class="checkbox">
                                                <label style="font-size: 1.1em;">
                                                    <input type="checkbox" name="isUrgent" value="true">
                                                    <strong>Urgent Request (Prioritized)</strong>
                                                </label>
                                                <p class="help-block" style="color: #c94a4a; margin-top: 7px; font-size: 13px;">
                                                    <i class="fa fa-exclamation-triangle"></i>
                                                    By checking this, your request will be prioritized. This may incur a 
                                                    <strong>+5% surcharge</strong> on the final repair/service bill.
                                                </p>
                                            </div>
                                        </div>


                                        <div class="form-group" id="typeGroup">
                                            <label >Request Type<span style="color:red">*</span></label>
                                            <select id="requestTypeSelect" name="request_type" class="form-control" required>
                                                <option value="">-- Choose Type --</option>
                                                <option value="REPAIR">Repair</option>
                                                <option value="WARRANTY">Warranty</option>
                                                <option value="MAINTENANCE">Maintenance</option>
                                            </select>
                                            <div class="validation-error" >Request Type is required</div>
                                        </div>


                                        <% if (request.getAttribute("success") != null) { %>
                                        <div class="success-message" style="margin-top: 2rem; background-color: #d1fae5 !important; border: 1px solid #86efac !important; color: #059669 !important; padding: 1rem !important; border-radius: 8px !important; text-align: center !important;">
                                            <i class="fa fa-check-circle" style="color: #10b981 !important; margin-right: 0.5rem !important; font-size: 1.1rem !important;"></i> <%= request.getAttribute("success") %>
                                        </div>
                                        <% } %>


                                        <div class="form-row" style="margin-top: 2rem; padding-top: 1.5rem; border-top: 1px solid #e2e8f0; margin-bottom: 0;">
                                            <div class="form-col-full text-center">
                                                <button type="submit" class="btn btn-primary" style="margin-right: 1rem; min-width: 150px;">
                                                    <i class="fa fa-save"></i> Save 
                                                </button>
                                                <a href="${pageContext.request.contextPath}/customer/dashboard" class="btn btn-default" style="min-width: 150px;">
                                                    <i class="fa fa-arrow-left"></i> Back to Dashboard
                                                </a>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                </section>
                <div class="footer-main">Copyright &copy; Customer Management System, 2024</div>
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
        <script src="${pageContext.request.contextPath}/js/warehouse/addProduct.js" type="text/javascript"></script>
        <script>
                                                document.addEventListener("DOMContentLoaded", function () {
                                                    const urlParams = new URLSearchParams(window.location.search);
                                                    const deviceId = urlParams.get("deviceId");
                                                    const type = urlParams.get("type");

                                                    if (deviceId) {
                                                        const productSelect = document.getElementById("productSelect");
                                                        const options = productSelect.options;

                                                        for (let i = 0; i < options.length; i++) {
                                                            if (options[i].value === deviceId) {
                                                                options[i].selected = true;
                                                                fillProductInfo(); // Gọi hàm có sẵn để fill các input khác
                                                                break;
                                                            }
                                                        }
                                                    }

                                                    if (type) {
                                                        const requestTypeSelect = document.getElementById("requestTypeSelect");
                                                        requestTypeSelect.value = type;
                                                    }
                                                });
                                                function fillProductInfo() {
                                                    const productSelect = document.getElementById("productSelect");
                                                    const selectedOption = productSelect.options[productSelect.selectedIndex];


                                                    document.getElementById("productBrand").value = selectedOption.getAttribute("data-brand") || "";
                                                    document.getElementById("productCategory").value = selectedOption.getAttribute("data-category") || "";
                                                    document.getElementById("productSerialNumber").value = selectedOption.getAttribute("data-serial_number") || "";
                                                    document.getElementById("productStatus").value = selectedOption.getAttribute("data-status") || "";



                                                }

                                                function validateForm() {
                                                    // Lấy giá trị từ các trường
                                                    var title = document.getElementById('title').value.trim();
                                                    var device = document.getElementById('productSelect').value;
                                                    var requestType = document.getElementById('requestTypeSelect').value;


                                                    var titleGroup = document.getElementById('titleGroup');
                                                    var deviceGroup = document.getElementById('deviceGroup');
                                                    var typeGroup = document.getElementById('typeGroup');


                                                    titleGroup.classList.remove('has-error');
                                                    deviceGroup.classList.remove('has-error');
                                                    typeGroup.classList.remove('has-error');

                                                    var isValid = true;


                                                    if (title === "") {
                                                        titleGroup.classList.add('has-error');
                                                        isValid = false;
                                                    }


                                                    if (device === "") {
                                                        deviceGroup.classList.add('has-error');
                                                        isValid = false;
                                                    }


                                                    if (requestType === "") {
                                                        typeGroup.classList.add('has-error');
                                                        isValid = false;
                                                    }

                                                    return isValid;
                                                }
        </script>
    </body>
</html>



