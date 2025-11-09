<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="/jsp/layout/header2.jsp" %>
<%@ include file="/jsp/layout/sidebar2.jsp" %>

<div class="content-wrapper">
    <section class="content-header">
        <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">Request Detail: <c:out value="#${requestDetail.id}"/></h1>
        <ol class="breadcrumb" style="background: none; padding: 0; margin-bottom: 2rem;">
            <li><a href="${pageContext.request.contextPath}/cskh/dashboard"><i class="fa fa-dashboard"></i> Home</a></li>
            <li><a href="${backUrl}">${backPageName}</a></li>
            <li class="active">Detail</li>
        </ol>
    </section>

    <section class="content">

        <c:if test="${param.message == 'transferred'}">
            <div class="alert alert-success"><i class="fa fa-check-circle"></i> Request successfully transferred to Tech Manager.</div>
        </c:if>
        <c:if test="${param.message == 'cancelled'}">
            <div class="alert alert-success"><i class="fa fa-check-circle"></i> Request has been cancelled.</div>
        </c:if>
        <c:if test="${param.message == 'closed'}">
            <div class="alert alert-success"><i class="fa fa-check-circle"></i> Request has been closed.</div>
        </c:if>
        <c:if test="${param.error == 'actionFailed'}">
            <div class="alert alert-danger"><i class="fa fa-exclamation-triangle"></i> Action failed. Please try again.</div>
        </c:if>

        <div class="row">
            <div class="col-md-7">

                <div class="content-card">
                    <div class="card-header" style="display: flex; justify-content: space-between; align-items: center;">
                        <h3><i class="fa fa-info-circle"></i> Request Information</h3>

                        <c:if test="${not empty requestDetail.status}">
                            <span class="status-label ${requestDetail.status eq 'PENDING' ? 'status-warning' : requestDetail.status eq 'TRANSFERRED' ? 'status-info' : requestDetail.status eq 'ASSIGNED' ? 'status-info' : requestDetail.status eq 'IN_PROGRESS' ? 'status-info' : requestDetail.status eq 'COMPLETED' ? 'status-success' : requestDetail.status eq 'AWAITING_PAYMENT' ? 'status-warning' : requestDetail.status eq 'PAID' ? 'status-success' : requestDetail.status eq 'CLOSED' ? '' : requestDetail.status eq 'CANCELLED' ? 'status-critical' : ''}">
                                <c:out value="${requestDetail.status}"/>
                            </span>
                        </c:if>
                    </div>
                    <div class="card-body">
                        <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                            <strong><i class="fa fa-hashtag" style="color: #6366f1; width: 20px;"></i> Request ID:</strong> <c:out value="#${requestDetail.id}"/>
                        </div>
                        <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                            <strong><i class="fa fa-tag" style="color: #6366f1; width: 20px;"></i> Title:</strong> <c:out value="${requestDetail.title}"/>
                        </div>
                        <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                            <strong><i class="fa fa-list" style="color: #6366f1; width: 20px;"></i> Request Type:</strong> <c:out value="${requestDetail.request_type}"/>
                        </div>
                        <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                            <strong><i class="fa fa-calendar" style="color: #6366f1; width: 20px;"></i> Request Date:</strong> <fmt:formatDate value="${requestDetail.request_date}" pattern="yyyy-MM-dd HH:mm"/>
                        </div>
                        <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                            <strong><i class="fa fa-file-text-o" style="color: #6366f1; width: 20px;"></i> Description:</strong>
                            <c:if test="${empty requestDetail.description}"><span style="color: #a0aec0;">No description</span></c:if>
                            <p style="white-space: pre-wrap; margin: 0; padding-left: 25px;"><c:out value="${requestDetail.description}"/></p>
                        </div>
                    </div>
                </div>

                <div class="content-card">
                    <div class="card-header"><h3><i class="fa fa-user-circle"></i> Customer & Device</h3></div>
                    <div class="card-body">
                        <h4 style="font-weight: 600; color: #2d3748; border-bottom: 1px solid #eee; padding-bottom: 5px;">Customer Details</h4>
                        <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                            <strong><i class="fa fa-user" style="color: #6366f1; width: 20px;"></i> Name:</strong> <c:out value="${customerDetail.fullName}" default="N/A"/>
                        </div>
                        <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                            <strong><i class="fa fa-envelope" style="color: #6366f1; width: 20px;"></i> Email:</strong> <c:out value="${customerDetail.email}" default="N/A"/>
                        </div>
                        <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                            <strong><i class="fa fa-phone" style="color: #6366f1; width: 20px;"></i> Phone:</strong> <c:out value="${customerDetail.phone}" default="N/A"/>
                        </div>

                        <h4 style="font-weight: 600; color: #2d3748; border-bottom: 1px solid #eee; padding-bottom: 5px; margin-top: 20px;">Device Details</h4>
                        <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                            <strong><i class="fa fa-cube" style="color: #6366f1; width: 20px;"></i> Product:</strong> <c:out value="${requestDetail.device.productName}" default="N/A"/>
                        </div>
                        <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                            <strong><i class="fa fa-barcode" style="color: #6366f1; width: 20px;"></i> Serial:</strong> <c:out value="${requestDetail.device.serialNumber}" default="N/A"/>
                        </div>
                        <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                            <strong><i class="fa fa-bookmark" style="color: #6366f1; width: 20px;"></i> Brand:</strong> <c:out value="${requestDetail.device.brandName}" default="N/A"/>
                        </div>
                        <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                            <strong><i class="fa fa-tags" style="color: #6366f1; width: 20px;"></i> Category:</strong> <c:out value="${requestDetail.device.categoryName}" default="N/A"/>
                        </div>
                        <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                            <strong><i class="fa fa-shield" style="color: #6366f1; width: 20px;"></i> Warranty:</strong>
                            <fmt:formatDate value="${requestDetail.device.warrantyExpiration}" pattern="yyyy-MM-dd"/>
                            <c:if test="${requestDetail.device.underWarranty}"><span class="status-label status-success" style="margin-left: 10px;">Under Warranty</span></c:if>
                            <c:if test="${!requestDetail.device.underWarranty}"><span class="status-label status-critical" style="margin-left: 10px;">Expired</span></c:if>
                            </div>
                        </div>      
                    </div>
                </div> 

                <div class="col-md-5">
                    <div class="content-card">
                        <div class="card-header"><h3><i class="fa fa-users"></i> Assignment Details</h3></div>
                        <div class="card-body">
                        <c:if test="${empty assignmentDetail}">
                            <div class="empty-state" style="padding: 1rem; text-align: center; color: #718096;">
                                <i class="fa fa-user-times" style="font-size: 2rem; margin-bottom: 0.5rem; color: #6366f1;"></i>
                                <p style="font-size: 1rem; margin: 0;">Not yet assigned.</p>
                            </div>
                        </c:if>
                        <c:if test="${not empty assignmentDetail}">
                            <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                                <strong><i class="fa fa-calendar-check-o" style="color: #6366f1; width: 20px;"></i> Assigned:</strong> <fmt:formatDate value="${assignmentDetail.assigned_date}" pattern="yyyy-MM-dd"/>
                            </div>
                            <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                                <strong><i class="fa fa-wrench" style="color: #6366f1; width: 20px;"></i> Technicians:</strong>
                                <ul style="margin: 0; padding-left: 45px; list-style-type: disc;">
                                    <c:forEach var="tech" items="${assignmentDetail.technician}">
                                        <li>
                                            <c:out value="${tech.fullName}"/>
                                            <c:if test="${tech.id == assignmentDetail.technician_id && assignmentDetail.is_main == 1}">
                                                <strong>(Main)</strong>
                                            </c:if>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </c:if>
                    </div>
                </div>

                <div class="content-card">
                    <div class="card-header"><h3><i class="fa fa-money"></i> Meta, Payment & Feedback</h3></div>
                    <div class="card-body">
                        <c:if test="${empty metaDetail}">
                            <div class="empty-state" style="padding: 1rem; text-align: center; color: #718096;">
                                <i class="fa fa-file-o" style="font-size: 2rem; margin-bottom: 0.5rem; color: #6366f1;"></i>
                                <p style="font-size: 1rem; margin: 0;">No meta-information added.</p>
                            </div>
                        </c:if>
                        <c:if test="${not empty metaDetail}">
                            <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                                <strong><i class="fa fa-sort-amount-asc" style="color: #6366f1; width: 20px;"></i> Priority:</strong> <c:out value="${metaDetail.priority}" default="N/A"/>
                            </div>
                            <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                                <strong><i class="fa fa-dollar" style="color: #6366f1; width: 20px;"></i> Total Cost:</strong> <fmt:formatNumber value="${metaDetail.total_cost}" type="CURRENCY" currencySymbol="$"/>
                            </div>
                            <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                                <strong><i class="fa fa-credit-card" style="color: #6366f1; width: 20px;"></i> Paid Amount:</strong> <fmt:formatNumber value="${metaDetail.paid_amount}" type="CURRENCY" currencySymbol="$"/>
                            </div>
                            <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                                <strong><i class="fa fa-check" style="color: #6366f1; width: 20px;"></i> Pay Status:</strong> <c:out value="${metaDetail.payment_status}" default="N/A"/>
                            </div>
                            <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                                <strong><i class="fa fa-calendar-times-o" style="color: #6366f1; width: 20px;"></i> Due Date:</strong> <fmt:formatDate value="${metaDetail.payment_due_date}" pattern="yyyy-MM-dd"/>
                            </div>
                            <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                                <strong><i class="fa fa-commenting-o" style="color: #6366f1; width: 20px;"></i> Reason:</strong> <c:out value="${metaDetail.reject_reason}" default="N/A"/>
                            </div>
                            <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                                <strong><i class="fa fa-comments" style="color: #6366f1; width: 20px;"></i> Feedback:</strong> <c:out value="${metaDetail.customer_comment}" default="N/A"/>
                            </div>
                            <div class="form-group" style="font-size: 1.1rem; color: #2d3748;">
                                <strong><i class="fa fa-star" style="color: #6366f1; width: 20px;"></i> Rating:</strong> <c:out value="${metaDetail.rating > 0 ? metaDetail.rating : 'N/A'}"/>
                            </div>
                            <c:if test="${not empty metaDetail.customer_comment || metaDetail.rating > 0}">
                                <div class="content-card">
                                    <div class="card-header"><h3><i class="fa fa-reply"></i> CSKH Feedback Response</h3></div>
                                    <div class="card-body">

                                        <c:if test="${param.message == 'responseSaved'}">
                                            <div class="alert alert-success">Response saved successfully!</div>
                                        </c:if>

                                        <form action="" method="POST">
                                            <input type="hidden" name="action" value="save_response">
                                            <input type="hidden" name="requestId" value="${requestDetail.id}">
                                            <input type="hidden" name="returnUrl" value="${backUrl}">

                                            <div class="form-group">
                                                <textarea name="cskhResponse" id="cskhResponseText" class="form-control-modern" rows="5" 
                                                          placeholder="Enter your response here...">${metaDetail.customer_service_response}</textarea>
                                            </div>
                                            <button type="submit" class="btn btn-primary" style="margin-top: 10px;">
                                                <i class="fa fa-save"></i> 
                                                <c:choose>
                                                    <c:when test="${not empty metaDetail.customer_service_response}">
                                                        Update Response
                                                    </c:when>
                                                    <c:otherwise>
                                                        Save Response
                                                    </c:otherwise>
                                                </c:choose>
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </c:if>

                        </c:if>
                    </div>
                </div>

            </div> 
        </div> 

        <div class="content-card">
            <div class="card-body">
                <form action="" method="POST" class="form-inline" style="justify-content: flex-end; gap: 10px;">
                    <a href="${backUrl}" class="btn btn-default" style="margin-right: auto;">
                        <i class="fa fa-arrow-left"></i> Back to List
                    </a>

                    <c:if test="${requestDetail.status == 'PENDING'}">
                        <button type="button" class="btn btn-danger" onclick="openCancelModal()">
                            <i class="fa fa-times-circle"></i> Cancel Request
                        </button>

                        <input type="hidden" name="action" value="transfer">
                        <input type="hidden" name="requestId" value="${requestDetail.id}">

                        <div class="form-group">
                            <label for="prioritySelect" style="margin-right: 5px;">Set Priority:</label>
                            <select name="priority" id="prioritySelect" class="form-control" style="height: 38px;"> <option value="Medium">Medium (Default)</option>
                                <option value="Low">Low</option>
                                <option value="High">High</option>
                                <option value="URGENT">URGENT</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-success">
                            <i class="fa fa-share"></i> Transfer
                        </button>
                    </c:if>

                    <c:if test="${requestDetail.status == 'PAID' || (requestDetail.status == 'COMPLETED' && (metaDetail == null || metaDetail.total_cost == 0))}">
                        <form action="" method="POST" style="margin: 0; padding: 0;">
                            <input type="hidden" name="action" value="close">
                            <input type="hidden" name="requestId" value="${requestDetail.id}">
                            <button type="submit" class="btn btn-primary">
                                <i class="fa fa-check-square-o"></i> Close Request
                            </button>
                        </form>
                    </c:if>
                </form>
            </div>
        </div>
    </section>

    <div id="cancelModal" class="modal">
        <div class="modal-content">
            <form action="" method="POST">
                <div class="modal-header" style="background-color: #d9534f;"> <h2 style="margin: 0; font-size: 1.25rem; color: white;">Cancel Request</h2>
                </div>
                <div class="modal-body">
                    <p>Please provide a reason for cancelling this request:</p>
                    <input type="hidden" name="action" value="cancel">
                    <input type="hidden" name="requestId" value="${requestDetail.id}">
                    <textarea name="cancelReason" class="form-control" rows="4" placeholder="Reason for cancellation..." required></textarea>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" onclick="closeCancelModal()">Abort</button>
                    <button type="submit" class="btn btn-danger">Confirm Cancellation</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    var modal = document.getElementById('cancelModal');

    function openCancelModal() {
        modal.style.display = "block";
    }

    function closeCancelModal() {
        modal.style.display = "none";
    }

    window.onclick = function (event) {
        if (event.target == modal) {
            closeCancelModal();
        }
    }

    document.addEventListener('DOMContentLoaded', function () {
        const alerts = document.querySelectorAll('.alert');
        if (alerts.length > 0) {
            setTimeout(() => {
                alerts.forEach(a => {
                    a.style.transition = 'opacity 0.5s ease';
                    a.style.opacity = '0';
                    setTimeout(() => a.remove(), 500);
                });
            }, 4000);
        }
    });
</script>

<%@ include file="/jsp/layout/footer2.jsp" %>