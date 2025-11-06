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
                                                <div class="form-group payment-options" id="paymentOptionGroup">
                                                    <label>Select Amount to Pay:<span style="color:red">*</span></label>
                                                    <c:if test="${paymentStatus == 'UNPAID'}"> 
                                                        <label for="pct50">
                                                            <input type="radio" name="amountToPay" id="pct50" value="${totalCost * 0.5}"> 
                                                            Pay 50% (<fmt:formatNumber value="${totalCost * 0.5}" type="currency" currencyCode="VND" maxFractionDigits="0"/>)
                                                        </label>
                                                    </c:if>
                                                    <label for="pctFullDue">
                                                        <%-- SỬA LỖI: THÊM "checked" VÀO ĐÂY --%>
                                                        <input type="radio" name="amountToPay" id="pctFullDue" value="${amountDue}" checked> 
                                                        Pay Full Amount Due (<fmt:formatNumber value="${amountDue}" type="currency" currencyCode="VND" maxFractionDigits="0"/>)
                                                    </label>
                                                    <div class="validation-error">Please select a payment option.</div>
                                                </div>
                                                <hr>
                                                <button type="button" id="generateQrBtn" class="btn btn-info btn-block" style="background-color: #17a2b8; margin-bottom: 20px;">
                                                    <i class="fa fa-qrcode"></i> QR Code to Pay
                                                </button>
                                                <div id="qrSection" style="text-align:center; display:none; margin-top:20px; border: 1px solid #eee; padding: 20px; border-radius: 5px;">
                                                    <h5>Scan to Pay</h5>
                                                    <img id="qrImage" src="" alt="VietQR" style="max-width:300px; border:1px solid #ddd; border-radius:10px; padding:10px;">
                                                    <p style="margin-top:10px; color:#666;">Use your banking app to scan and pay</p>
                                                    <button type="submit" class="btn btn-success" style="margin-top:10px;">
                                                        <i class="fa fa-check"></i> Confirm
                                                    </button>
                                                    <a href="${pageContext.request.contextPath}/customer/listRequest" class="btn btn-default" style="margin-top: 10px;">
                                                        <i class="fa fa-arrow-left"></i> Back to List
                                                    </a>
                                                </div>
                                            </c:when>
                                            <%-- TRƯỜNG HỢP 2: ĐÃ TRẢ ĐỦ (PAID) --%>
                                            <c:otherwise>
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
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js"></script>
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
                                        (function () {
                                            // Lấy các biến từ JSTL
                                            const requestId = "${reqInfo.id}";
                                            const accountName = "Nguyen Gia Bao";
                                            const bankId = "VPB";
                                            const accountNo = "1230007122003";

                                            // Hàm hiển thị QR
                                            function showQR(amount) {
                                                const qrImage = document.getElementById("qrImage");
                                                const qrSection = document.getElementById("qrSection");

                                                if (!amount || parseFloat(amount) <= 0) {
                                                    qrSection.style.display = "none";
                                                    return;
                                                }
                                                const desc = encodeURIComponent(`Payment for Request #${requestId}`);
                                                const qrUrl = "https://img.vietqr.io/image/"
                                                        + bankId + "-" + accountNo + "-compact2.jpg"
                                                        + "?amount=" + amount
                                                        + "&addInfo=" + desc
                                                        + "&accountName=" + encodeURIComponent(accountName);
                                                qrImage.src = qrUrl;
                                                qrSection.style.display = "block";
                                            }

                                           

                                            

                                            // Chạy khi trang tải xong
                                            document.addEventListener("DOMContentLoaded", function () {
                                                const generateBtn = document.getElementById("generateQrBtn");
                                                const qrSection = document.getElementById("qrSection");
                                                const radios = document.getElementsByName('amountToPay');

                                                // 1. Hiển thị QR cho lựa chọn mặc định
                                                const defaultSelected = document.querySelector('input[name="amountToPay"]:checked');
                                                if (defaultSelected) {
                                                    showQR(defaultSelected.value);
                                                }

                                                // 2. Gắn sự kiện cho nút "Generate QR"
                                                if (generateBtn) {
                                                    generateBtn.addEventListener('click', function () {
                                                        const paymentSelected = document.querySelector('input[name="amountToPay"]:checked');
                                                        const paymentGroup = document.getElementById("paymentOptionGroup");
                                                        const errorDiv = paymentGroup.querySelector(".validation-error");

                                                        paymentGroup.classList.remove("has-error");
                                                        errorDiv.style.display = "none";

                                                        if (paymentSelected) {
                                                            showQR(paymentSelected.value);
                                                        } else {
                                                            errorDiv.style.display = "block";
                                                            paymentGroup.classList.add("has-error");
                                                        }
                                                    });
                                                }

                                                // 3. Ẩn QR khi người dùng đổi radio
                                                for (let i = 0; i < radios.length; i++) {
                                                    radios[i].addEventListener('change', function () {
                                                        if (qrSection) {
                                                            qrSection.style.display = "none"; // Ẩn QR
                                                        }
                                                        // Bỏ highlight label
                                                        document.querySelectorAll('.payment-options label.selected').forEach(label => {
                                                            label.classList.remove('selected');
                                                        });
                                                        // Highlight label được chọn
                                                        if (this.checked) {
                                                            this.parentElement.classList.add('selected');
                                                        }
                                                    });
                                                }

                                                // Highlight label mặc định
                                                if (defaultSelected) {
                                                    defaultSelected.parentElement.classList.add('selected');
                                                }
                                            });
                                        })(); // Chạy hàm ng
        </script>
    </body>
</html>
