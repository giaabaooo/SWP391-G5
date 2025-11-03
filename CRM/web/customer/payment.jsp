<%-- 
    Document   : payment
    Created on : Nov 2, 2025, 2:39:10 PM
    Author     : admin
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 


<c:set var="reqInfo" value="${requestScope.requestPaymentInfo}" />
<c:set var="amountDue" value="${requestScope.amountDue}" />
<c:set var="totalCost" value="${requestScope.totalCost}" />
<c:set var="paidAmount" value="${requestScope.paidAmount}" />
<c:set var="paymentStatus" value="${reqInfo.requestMeta.payment_status}" />
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Customer | Payment</title>
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
        <style>
            .validation-error {
                display: none;
                color: #dc3545;
                font-size: 0.875em;
                margin-top: 5px;
            }
            .has-error .form-control {
                border-color: #dc3545;
            }
            .has-error .validation-error {
                display: block;
            }
            .percent-options label {
                margin-right: 15px;
                font-weight: normal;
            }
            .percent-options input {
                margin-right: 5px;
            }
            .payment-summary {
                margin-bottom: 25px;
            }
            .payment-summary .summary-row {
                display: flex;
                justify-content: space-between; /* Đẩy label và value ra 2 bên */
                padding: 10px 0;
                font-size: 1.1em;
                border-bottom: 1px dashed #eee; /* Ngăn cách mờ */
            }
            .payment-summary .summary-row .label {
                color: #6c757d; /* Màu xám */
            }
            .payment-summary .summary-row .value {
                font-weight: 600; /* In đậm giá trị */
                color: #2d3748;
            }

            /* CSS cho dòng Amount Due (Nổi bật) */
            .payment-summary .amount-due-row {
                display: flex;
                justify-content: space-between;
                padding: 15px 0;
                font-size: 1.6em;
                font-weight: 700;
                /* Không cần gán màu ở thẻ cha nữa */
                /* color: #dc3545; */
                border-top: 1px solid #ccc;
                margin-top: 10px;
            }
            .payment-summary .amount-due-row.unpaid .value {
                color: #dc3545;
            } /* Đỏ (chưa trả) */
            .payment-summary .amount-due-row.paid .value {
                color: #28a745;
            } /* Xanh (đã trả) */

            .payment-summary .amount-due-row .label {
                color: #2d3748;  /* Đặt lại màu nhãn (ví dụ: màu đen/xám đậm) */
                background: none !important; /* Xóa mọi background */
            }

            /* Quy tắc cho giá trị (số tiền) */
            .payment-summary .amount-due-row .value {
                color: #dc3545 !important; /* Gán màu đỏ (như bạn muốn) */
                background: none !important; /* Xóa mọi background */
            }
        </style>
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
                            <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">Payment</h1>



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
                                    <h3><i class="fa fa-plus"></i> Payment</h3>
                                </div>
                                <div class="card-body">
                                    <form method="post" action="${pageContext.request.contextPath}/customer/payment" novalidate onsubmit="return validatePayment();">
                                        <input type="hidden" name="requestId" value="${reqInfo.id}">

                                        <div class="form-group" id="requestGroup">

                                            <fieldset disabled> 
                                                <div class="form-group">
                                                    <label>Device:</label>
                                                    <input type="text" value="<c:out value='${reqInfo.device.productName}'/>" class="form-control">
                                                </div>
                                                <div class="form-group">
                                                    <label>Request Type:</label>
                                                    <input type="text" value="<c:out value='${reqInfo.request_type}'/>" class="form-control">
                                                </div>
                                            </fieldset>
                                            
                                        </div>

                                        <div class="payment-summary">
                                            <div class="summary-row">
                                                <span class="label">Total Cost:</span>
                                                <span class="value"><fmt:formatNumber value="${reqInfo.requestMeta.total_cost}" type="currency" currencyCode="VND" maxFractionDigits="0"/></span>
                                            </div>
                                            <div class="summary-row">
                                                <span class="label">Already Paid:</span>
                                                <span class="value"><fmt:formatNumber value="${reqInfo.requestMeta.paid_amount}" type="currency" currencyCode="VND" maxFractionDigits="0"/></span>
                                            </div>

                                            <div class="amount-due-row ${paymentStatus == 'PAID' ? 'paid' : 'unpaid'}">
                                                <span class="label">Amount Due:</span>
                                                <span class="value"><fmt:formatNumber value="${amountDue}" type="currency" currencyCode="VND" maxFractionDigits="0"/></span>
                                            </div>
                                            <input type="hidden" id="amountDueValue" value="${amountDue}">
                                        </div>

                                        <%-- 3. LOGIC HIỂN THỊ ĐỘNG --%>
                                        <c:choose>
                                            <%-- TRƯỜNG HỢP 1: CHƯA TRẢ HOẶC TRẢ MỘT PHẦN --%>
                                            <c:when test="${paymentStatus == 'UNPAID' || paymentStatus == 'PARTIALLY_PAID'}">
                                                <%-- Hiển thị Form chọn tiền và nút Pay --%>
                                                <input type="hidden" id="amountDueValue" value="${amountDue}">
                                                <div class="form-group payment-options">
                                                    <label>Select Amount to Pay:<span style="color:red">*</span></label>
                                                    <c:if test="${paymentStatus == 'UNPAID'}"> <%-- Chỉ hiện 50% nếu là lần đầu --%>
                                                        <label for="pct50">
                                                            <input type="radio" name="amountToPay" id="pct50" value="${totalCost * 0.5}"> 
                                                            Pay 50% (<fmt:formatNumber value="${totalCost * 0.5}" type="currency" currencyCode="VND" maxFractionDigits="0"/>)
                                                        </label>
                                                    </c:if>
                                                    <label for="pctFullDue">
                                                        <input type="radio" name="amountToPay" id="pctFullDue" value="${amountDue}" checked> 
                                                        Pay Full Amount Due (<fmt:formatNumber value="${amountDue}" type="currency" currencyCode="VND" maxFractionDigits="0"/>)
                                                    </label>
                                                </div>
                                                <hr>
                                                <button type="submit" class="btn btn-primary" style="margin-right: 1rem; min-width: 150px;">
                                                    <i class="fa fa-save"></i> Payment 
                                                </button>
                                                <a href="${pageContext.request.contextPath}/customer/listRequest" class="btn btn-default" style="min-width: 150px;">
                                                    <i class="fa fa-arrow-left"></i> Back to List Request
                                                </a>
                                            </c:when>
                                            
                                            <%-- TRƯỜNG HỢP 2: ĐÃ TRẢ ĐỦ (PAID) --%>
                                            <c:otherwise>
                                                <%-- Chỉ hiển thị thông báo thành công và nút Back --%>
                                                <div class="alert alert-success text-center">
                                                    <i class="fa fa-check-circle fa-lg"></i> 
                                                    <strong>Payment Successful!</strong>
                                                    <p style="margin-top: 5px;">This invoice has been fully paid. Thank you!</p>
                                                </div>
                                                <a href="${pageContext.request.contextPath}/customer/listRequest" class="btn btn-default btn-block" style="margin-top: 10px;">
                                                    <i class="fa fa-arrow-left"></i> Back to List
                                                </a>
                                            </c:otherwise>
                                        </c:choose>

                                        <% if (request.getAttribute("success") != null) { %>
                                        <div class="success-message" style="margin-top: 2rem; background-color: #d1fae5 !important; border: 1px solid #86efac !important; color: #059669 !important; padding: 1rem !important; border-radius: 8px !important; text-align: center !important;">
                                            <i class="fa fa-check-circle" style="color: #10b981 !important; margin-right: 0.5rem !important; font-size: 1.1rem !important;"></i> <%= request.getAttribute("success") %>
                                        </div>
                                        <% } %>


<!--                                        <div class="form-row" style="margin-top: 2rem; padding-top: 1.5rem; border-top: 1px solid #e2e8f0; margin-bottom: 0;">
                                            <div class="form-col-full text-center">
                                                <button type="submit" class="btn btn-primary" style="margin-right: 1rem; min-width: 150px;">
                                                    <i class="fa fa-save"></i> Save 
                                                </button>
                                                <a href="${pageContext.request.contextPath}/customer/listRequest" class="btn btn-default" style="min-width: 150px;">
                                                    <i class="fa fa-arrow-left"></i> Back to List Request
                                                </a>
                                            </div>
                                        </div>-->
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

                                        function calculatePercent(percentValue) {
                                            var amountDue = parseFloat(document.getElementById('amountDueValue').value);
                                            var amountToPayInput = document.getElementById('amountToPay');
                                            var calculatedAmount = Math.round(amountDue * parseFloat(percentValue));
                                            amountToPayInput.value = calculatedAmount;
                                        }

                                        document.addEventListener("DOMContentLoaded", function () {
                                            var amountToPayInput = document.getElementById('amountToPay');
                                            amountToPayInput.addEventListener('input', function () {
                                                var amountDue = parseFloat(document.getElementById('amountDueValue').value);
                                                var currentAmount = parseFloat(this.value);
                                                var radios = document.getElementsByName('percent');
                                                var matchedAPercent = false;

                                                for (var i = 0; i < radios.length; i++) {
                                                    var radio = radios[i];
                                                    var percentValue = parseFloat(radio.value);
                                                    var calculatedAmount = Math.round(amountDue * percentValue);
                                                    if (currentAmount === calculatedAmount) {
                                                        radio.checked = true;
                                                        matchedAPercent = true;
                                                    }
                                                }
                                                if (!matchedAPercent) {
                                                    for (var i = 0; i < radios.length; i++) {
                                                        radios[i].checked = false;
                                                    }
                                                }
                                            });
                                        });
                                        function validatePayment() {
                                            var amountDue = parseFloat(document.getElementById('amountDueValue').value);
                                            var amountToPayInput = document.getElementById('amountToPay');
                                            var amountToPayValue = amountToPayInput.value; // Lấy giá trị dạng chuỗi (để check trống)
                                            var amountToPayNumber = parseFloat(amountToPayValue); // Lấy giá trị dạng số (để check "abc")

                                            var amountGroup = document.getElementById("amountToPayGroup");
                                            var errorDiv = amountGroup.querySelector(".validation-error");

                                            // Reset lỗi
                                            amountGroup.classList.remove("has-error");
                                            errorDiv.style.display = "none";

                                            // --- BẮT LỖI THEO YÊU CẦU ---

                                            // 1. Check lỗi "Blank box" (để trống)
                                            if (amountToPayValue.trim() === "") {
                                                errorDiv.innerText = "Amount to pay cannot be blank.";
                                                amountGroup.classList.add("has-error");
                                                return false; // Chặn submit
                                            }

                                            // 2. Check lỗi "Nhập abc" (không phải số)
                                            // parseFloat("abc") sẽ trả về NaN (Not a Number)
                                            if (isNaN(amountToPayNumber)) {
                                                errorDiv.innerText = "Please enter a valid number (e.g., 500000).";
                                                amountGroup.classList.add("has-error");
                                                return false; // Chặn submit
                                            }

                                            // 3. Check lỗi nhập số âm hoặc 0
                                            if (amountToPayNumber <= 0) {
                                                errorDiv.innerText = "Payment amount must be greater than 0.";
                                                amountGroup.classList.add("has-error");
                                                return false;
                                            }

                                            // 4. Check lỗi "Nhập quá số tiền cost" (quá nợ)
                                            // (Thêm 0.001 làm sai số cho kiểu double/float)
                                            if (amountToPayNumber > (amountDue + 0.001)) {
                                                errorDiv.innerText = "Payment amount cannot be greater than the amount due.";
                                                amountGroup.classList.add("has-error");
                                                return false;
                                            }

                                            return true; // Tất cả đều ổn, cho phép submit
                                        }
        </script>
    </body>
</html>
