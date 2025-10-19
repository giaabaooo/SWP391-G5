<%-- 
    Document   : updateRequest
    Created on : Oct 17, 2025, 3:24:28 PM
    Author     : admin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="data.Device" %>
<%@ page import="data.CustomerRequest" %> 

<%
    
    CustomerRequest requestData = (CustomerRequest) request.getAttribute("requestData");
    List<Device> devices = (List<Device>) request.getAttribute("devices");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer | Update Request</title>
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
    

</head>
<body class="skin-black">

   
    <header class="header">
        <a href="dashboard.jsp" class="logo" style="color: #ffffff; font-weight: 600;">${sessionScope.user.role.name}</a>
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
                            <li><a href="#"><i class="fa fa-user fa-fw pull-right"></i> Profile</a></li>
                            <li class="divider"></li>
                            <li><a href="${pageContext.request.contextPath}/logout"><i class="fa fa-ban fa-fw pull-right"></i> Logout</a></li>
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
                    <div class="pull-left info">
                        <p>${sessionScope.user.fullName}</p>
                        <a href="#"><i class="fa fa-circle text-success"></i> Online</a>
                    </div>
                </div>
                <ul class="sidebar-menu">
                    <li><a href="${pageContext.request.contextPath}/customer/dashboard"><i class="fa fa-dashboard"></i> Dashboard</a></li>
                    <li class="treeview active">
                        <a href="#">
                            <i class="fa fa-tags"></i> <span>Request</span>
                            <i class="fa fa-angle-left pull-right"></i>
                        </a>
                        <ul class="treeview-menu">
                            <li><a href="${pageContext.request.contextPath}/customer/createRequest"><i class="fa fa-plus"></i> Create Request</a></li>
                            <li><a href="${pageContext.request.contextPath}/customer/listRequest"><i class="fa fa-eye"></i> View List Request</a></li>
                        </ul>
                    </li>
                    <li><a href="${pageContext.request.contextPath}/customer/devices"><i class="fa fa-cube"></i> My Devices</a></li>
                    <li><a href="${pageContext.request.contextPath}/customer/contract"><i class="fa fa-file-text"></i> Contract</a></li>
                    <li><a href="feedback.jsp"><i class="fa fa-edit"></i> <span>Feedback</span></a></li>
                </ul>
            </section>
        </aside>

        <aside class="right-side">
            <section class="content">
                <div class="row">
                    <div class="col-md-12">
                        <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">Update Request</h1>
                        <p style="color: #718096; margin-bottom: 2rem;">Edit the details of your request.</p>
                        <% if (request.getAttribute("error") != null) { %>
                        <div class="alert alert-danger" style="background-color: #fed7d7; border: 1px solid #fc8181; color: #742a2a; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;">
                            <i class="fa fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
                        </div>
                        <% } %>
                    </div>
                </div>
                
                <% if (requestData != null) { %>
                <div class="row">
                    <div class="col-md-12">
                        <div class="content-card">
                            <div class="card-header">
                                <h3><i class="fa fa-pencil"></i> Edit Request</h3>
                            </div>
                            <div class="card-body">
                                <form method="post" action="${pageContext.request.contextPath}/customer/updateRequest" novalidate>
                                    <input type="hidden" name="id" value="<%= requestData.getId() %>">

                                    <div class="form-group">
                                        <label>Title<span style="color:red">*</span></label>
                                        <input type="text" name="title" class="form-control" placeholder="Enter issue title" 
                                               value="<%= requestData.getTitle() != null ? requestData.getTitle() : "" %>" required>
                                    </div>

                                    <div class="form-group">
                                        <label>Select Device<span style="color:red">*</span></label>
                                        <select name="device_id" id="deviceSelect" class="form-control" onchange="fillDeviceInfo()" required>
                                            <option value="">-- Choose Device --</option>
                                            <% if (devices != null) {
                                                for (Device d : devices) {
                                                    String selected = (d.getId() == requestData.getDevice_id()) ? "selected" : "";
                                            %>
                                            <option value="<%= d.getId() %>" 
                                                data-serial_number="<%= d.getSerialNumber() %>"
                                                data-brand="<%= d.getBrandName() %>"
                                                data-category="<%= d.getCategoryName() %>"
                                                data-status="<%= d.getStatus() %>"
                                                <%= selected %>>
                                                <%= d.getProductName() %> (S/N: <%= d.getSerialNumber() %>)
                                            </option>
                                            <% }} %>
                                        </select>
                                    </div>

                                   
                                    <div class="form-group mt-3"><label>Serial Number</label><input type="text" id="deviceSerialNumber" class="form-control" readonly></div>
                                    <div class="form-group mt-3"><label>Brand</label><input type="text" id="deviceBrand" class="form-control" readonly></div>
                                    <div class="form-group mt-2"><label>Category</label><input type="text" id="deviceCategory" class="form-control" readonly></div>
                                    <div class="form-group mt-3"><label>Status</label><input type="text" id="deviceStatus" class="form-control" readonly></div>

                                    <div class="form-group">
                                        <label>Issue Description</label>
                                        <textarea name="description" class="form-control" rows="4" placeholder="Describe the issue..."><%= requestData.getDescription() != null ? requestData.getDescription() : "" %></textarea>
                                    </div>

                                    <div class="form-group">
                                        <label>Request Type<span style="color:red">*</span></label>
                                        <select name="request_type" class="form-control" required>
                                            <option value="">-- Choose Type --</option>
                                            <option value="WARRANTY" <%= "WARRANTY".equals(requestData.getRequest_type()) ? "selected" : "" %>>Warranty</option>
                                            
                                            <option value="REPAIR" <%= "REPAIR".equals(requestData.getRequest_type()) ? "selected" : "" %>>Repair</option>
                                        </select>
                                    </div>
                                        
                                        <!-- Success Message -->
                                        <% if (request.getAttribute("success") != null) { %>
                                        <div class="success-message" style="margin-top: 2rem; background-color: #d1fae5 !important; border: 1px solid #86efac !important; color: #059669 !important; padding: 1rem !important; border-radius: 8px !important; text-align: center !important;">
                                            <i class="fa fa-check-circle" style="color: #10b981 !important; margin-right: 0.5rem !important; font-size: 1.1rem !important;"></i> <%= request.getAttribute("success") %>
                                        </div>
                                        <% } %>
                                    
                                    <div class="form-row" style="margin-top: 2rem; padding-top: 1.5rem; border-top: 1px solid #e2e8f0; margin-bottom: 0;">
                                        <div class="form-col-full text-center">
                                            <button type="submit" class="btn btn-primary" style="margin-right: 1rem; min-width: 150px;"><i class="fa fa-save"></i> Update</button>
                                            <a href="${pageContext.request.contextPath}/customer/listRequest" class="btn btn-default" style="min-width: 150px;"><i class="fa fa-times"></i> Cancel</a>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <% } else { %>
                    <div class="alert alert-warning">Request not found or you do not have permission to edit it.</div>
                <% } %>
            </section>
            <div class="footer-main">Copyright &copy; Customer Management System, 2024</div>
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
    <script src="${pageContext.request.contextPath}/js/warehouse/addProduct.js" type="text/javascript"></script>
    
    
    <script>
        function fillDeviceInfo() {
            const deviceSelect = document.getElementById("deviceSelect");
            const selectedOption = deviceSelect.options[deviceSelect.selectedIndex];

            document.getElementById("deviceBrand").value = selectedOption.getAttribute("data-brand") || "";
            document.getElementById("deviceCategory").value = selectedOption.getAttribute("data-category") || "";
            document.getElementById("deviceSerialNumber").value = selectedOption.getAttribute("data-serial_number") || "";
            document.getElementById("deviceStatus").value = selectedOption.getAttribute("data-status") || "";
        }
        
        document.addEventListener("DOMContentLoaded", function() {
            fillDeviceInfo();
        });
    </script>
</body>
</html>
