<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/techmanager/layout/header.jsp" %>
<%@ include file="/techmanager/layout/sidebar.jsp" %>
<!DOCTYPE html>
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

            /* Product Detail Card */
            .product-detail-card {
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
                padding: 2rem;
            }

            /* Product Image */
            .product-image-container {
                text-align: center;
                padding: 2rem;
                background: #f8f9fa;
                border-radius: 12px;
                margin-bottom: 2rem;
            }

            .product-image {
                max-width: 100%;
                max-height: 400px;
                border-radius: 8px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }

            .no-image {
                width: 300px;
                height: 300px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border-radius: 12px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 5rem;
            }

            /* Product Info */
            .info-row {
                display: flex;
                padding: 1rem 0;
                border-bottom: 1px solid #f1f3f4;
            }

            .info-row:last-child {
                border-bottom: none;
            }

            .info-label {
                flex: 0 0 200px;
                font-weight: 600;
                color: #4a5568;
                display: flex;
                align-items: center;
            }

            .info-label i {
                margin-right: 0.5rem;
                color: #667eea;
                width: 20px;
            }

            .info-value {
                flex: 1;
                color: #2d3748;
                font-size: 1rem;
            }

            /* Status Badge */
            .status-badge {
                padding: 0.5rem 1rem;
                border-radius: 20px;
                font-weight: 600;
                font-size: 0.875rem;
                display: inline-block;
            }

            .status-active {
                background: #d1fae5;
                color: #059669;
            }

            .status-inactive {
                background: #fee2e2;
                color: #dc2626;
            }

            /* Price Display */
            .price-display {
                font-size: 1.5rem;
                font-weight: 700;
                color: #667eea;
            }

            /* Action Buttons */
            .btn-primary {
                background: #6366f1;
                border: 1px solid #6366f1;
                border-radius: 8px;
                padding: 0.75rem 1.5rem;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .btn-primary:hover {
                background: #5b5ff5;
                border-color: #5b5ff5;
                transform: translateY(-1px);
                box-shadow: 0 4px 15px rgba(99, 102, 241, 0.3);
            }

            .btn-default {
                background: #f8f9fa;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                padding: 0.75rem 1.5rem;
                font-weight: 500;
                color: #4a5568;
                transition: all 0.3s ease;
            }

            .btn-default:hover {
                background: #e2e8f0;
                border-color: #cbd5e0;
                transform: translateY(-1px);
                color: #2d3748;
            }

            .btn-danger {
                background: #ef4444;
                border: 1px solid #ef4444;
                border-radius: 8px;
                padding: 0.75rem 1.5rem;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .btn-danger:hover {
                background: #dc2626;
                border-color: #dc2626;
                transform: translateY(-1px);
                box-shadow: 0 4px 15px rgba(239, 68, 68, 0.3);
            }

            /* Responsive */
            @media (max-width: 768px) {
                .content {
                    padding: 1rem;
                }

                .info-row {
                    flex-direction: column;
                }

                .info-label {
                    margin-bottom: 0.5rem;
                }

                .card-body {
                    padding: 1.5rem;
                }
            }
        </style>
    </head>
    <body class="skin-black">
        <div class="wrapper row-offcanvas row-offcanvas-left">
            <aside class="right-side">
                <section class="content">

                    <div class="row">
                        <div class="col-md-12">
                            <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">Request Details</h1>
                            <p style="color: #718096; margin-bottom: 2rem;">View detailed information about this request</p>
                            <c:if test="${not empty error}" >
                                <div class="alert alert-danger" style="margin: 10px;">
                                    ${error}
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-12">
                            <div class="card product-detail-card">
                                <div class="card-body">

                                    <h4 style="color: #2d3748; font-weight: 600; margin-bottom: 1.5rem; padding-bottom: 0.5rem; border-bottom: 2px solid #e2e8f0;">
                                        <i class="fa fa-edit" style="color: #667eea;"></i> Edit Task 
                                    </h4>

                                    <form method="post" action="${pageContext.request.contextPath}/techmanager/task?action=update">
                                        <input type="hidden" name="originalRequestId" value="${tasks.customerRequest.id}" /> 

                                        <input type="hidden" name="id" value="${tasks.id}" /> 


                                        <div class="info-row" style="margin-bottom: 1rem;">
                                            <div class="info-label">
                                                <i class="fa fa-tasks"></i> Task
                                            </div>
                                            <div class="info-value">
                                                <span>${tasks.customerRequest.request_type} ${tasks.customerRequest.device.productName} for ${tasks.customerRequest.customer.fullName}</span>
                                                <input type="hidden" name="taskId" value="${tasks.customerRequest.id}" />
                                            </div>
                                        </div>

                                        <div class="info-row" style="margin-bottom: 1rem;">
                                            <div class="info-label">
                                                <i class="fa fa-user-cog"></i> Technician(s)
                                            </div>
                                            <div class="info-value">
                                                <div id="technicianContainer">
                                                    <c:forEach var="techAssign" items="${tasks.technician}">
                                                        <div class="tech-row" style="display:flex; align-items:center; gap:8px; margin-bottom:8px;">
                                                            <select name="technicianIds" class="form-control technician-select" required>
                                                                <option value="">-- Select Technician --</option>
                                                                <c:forEach var="t" items="${technicianList}">
                                                                    <option value="${t.id}"
                                                                            <c:if test="${t.id == techAssign.id}">selected</c:if>>
                                                                        ${t.fullName}
                                                                    </option>
                                                                </c:forEach>
                                                            </select>

                                                            <label style="margin:0 8px; white-space:nowrap;">
                                                                <input type="radio" name="leaderId" class="leader-radio"
                                                                       value="${techAssign.id}"
                                                                       <c:if test="${techAssign.id == leaderId}">checked</c:if> required/> Leader
                                                                </label>

                                                                <button type="button" class="btn btn-primary btn-sm addTechBtn">
                                                                    <i class="fa fa-plus"></i>
                                                                </button>
                                                                <button type="button" class="btn btn-danger btn-sm removeTechBtn">
                                                                    <i class="fa fa-minus"></i>
                                                                </button>
                                                            </div>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="info-row" style="margin-bottom: 1.5rem;">
                                            <div class="info-label">
                                                <i class="fa fa-calendar"></i> Assign Date
                                            </div>
                                            <div class="info-value">
                                                <input type="date" name="assignedDate" class="form-control"
                                                       value="${tasks.assigned_date}" required>
                                            </div>
                                        </div>

                                        <div class="mt-3 text-center">
                                            <a href="${pageContext.request.contextPath}/techmanager/task" class="btn btn-default" style="min-width: 150px;">
                                                <i class="fa fa-arrow-left"></i> Back to List
                                            </a>
                                            <button type="submit" class="btn btn-primary" style="margin-right: 1rem; min-width: 150px;">
                                                <i class="fa fa-save"></i> Update
                                            </button>
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
                $('.treeview > a').click(function (e) {
                    e.preventDefault();
                    var target = $(this).attr('href');
                    $(target).collapse('toggle');
                });

                $('#inventoryMenu').addClass('in');
            });

            document.addEventListener('DOMContentLoaded', function () {
                const container = document.getElementById('technicianContainer');

                // Cập nhật các option select để không trùng
                function updateTechnicianOptions() {
                    const selected = Array.from(container.querySelectorAll('.technician-select'))
                            .map(s => s.value)
                            .filter(v => v !== "");

                    container.querySelectorAll('.technician-select').forEach(select => {
                        const currentValue = select.value;
                        Array.from(select.options).forEach(opt => {
                            if (opt.value === "" || opt.value === currentValue) {
                                opt.hidden = false;
                            } else {
                                opt.hidden = selected.includes(opt.value);
                            }
                        });
                    });
                }


                // Xử lý nút + và - và thay đổi select
                container.addEventListener('click', function (e) {
                    // Add Technician Row
                    if (e.target.closest('.addTechBtn')) {
                        const row = e.target.closest('.tech-row');
                        const clone = row.cloneNode(true);

                        // Reset selection and radio
                        clone.querySelector('.technician-select').selectedIndex = 0;
                        const radio = clone.querySelector('.leader-radio');
                        radio.checked = false;
                        radio.value = ""; // Reset value for the new row

                        container.appendChild(clone);
                        updateTechnicianOptions();
                    }

                    // Remove Technician Row
                    if (e.target.closest('.removeTechBtn')) {
                        const rows = container.querySelectorAll('.tech-row');
                        if (rows.length > 1) { // Ensure at least one row remains
                            const removedRow = e.target.closest('.tech-row');
                            const removedRadio = removedRow.querySelector('.leader-radio');

                            // If the removed technician was the leader, uncheck all, forcing a re-selection on submit
                            if (removedRadio.checked) {
                                document.querySelectorAll('.leader-radio').forEach(radio => radio.checked = false);
                            }

                            removedRow.remove();
                            updateTechnicianOptions();
                        }
                    }
                });

                // Khi chọn kỹ thuật viên, tự gán value cho radio leader & cập nhật options
                container.addEventListener('change', function (e) {
                    if (e.target.classList.contains('technician-select')) {
                        const selectedTechId = e.target.value;
                        const radio = e.target.closest('.tech-row').querySelector('.leader-radio');
                        radio.value = selectedTechId;
                        updateTechnicianOptions();
                    }
                });

                // Cập nhật ban đầu: Ensure pre-selected techs are hidden from other dropdowns
                updateTechnicianOptions();
            });
        </script>
    </body>
</html>