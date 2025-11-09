<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ include file="/jsp/layout/header2.jsp" %>
<%@ include file="/jsp/layout/sidebar2.jsp" %>

<div class="content-wrapper">
    <section class="content-header">
        <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">Edit Profile</h1>
        <ol class="breadcrumb" style="background: none; padding: 0; margin-bottom: 2rem;">
            <li><a href="${pageContext.request.contextPath}/cskh/dashboard"><i class="fa fa-dashboard"></i> Home</a></li>
            <li><a href="${pageContext.request.contextPath}/user/profile">Profile</a></li>
            <li class="active">Edit</li>
        </ol>
    </section>

    <section class="content">
        <div class="row">
            <div class="col-md-6">
                <div class="content-card">
                    <div class="card-header">
                        <h3><i class="fa fa-address-card"></i> Update Information</h3>
                    </div>
                    <form action="${pageContext.request.contextPath}/user/profile" method="POST" id="infoForm">
                        <input type="hidden" name="action" value="updateInfo">
                        <div class="card-body">
                            
                            <c:if test="${not empty errorInfo}">
                                <div class="alert alert-danger">${errorInfo}</div>
                            </c:if>

                            <div class="form-group">
                                <label class="form-label">Username:</label>
                                <input type="text" class="form-control-modern" value="${user.username}" readonly>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Email:</label>
                                <input type="email" class="form-control-modern" value="${user.email}" readonly>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="fullName">Full Name:</label>
                                <input type="text" class="form-control-modern" id="fullName" name="fullName" value="${user.fullName}" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="phone">Phone:</label>
                                <input type="text" class="form-control-modern" id="phone" name="phone" value="${user.phone}" required>
                                <small class="form-text text-muted">Vietnamese format only (e.g., 0912345678, 84912345678, or +84912345678).</small>
                            </div>

                            <hr>
                            <label class="form-label">Address:</label>
                            
                            <div class="form-group">
                                <label class="form-label" style="font-weight: 500;">Current Full Address (for reference):</label>
                                <input type="text" class="form-control-modern" value="<c:out value="${user.address}" default="Not set"/>" readonly disabled>
                                <small class="form-text text-muted">Please re-select your full address below to update.</small>
                            </div>
                
                            <div class="form-group">
                                <label class="form-label" for="province">Province/City:</label>
                                <select class="form-control-modern" id="province" required>
                                    <option value="">-- Select Province/City --</option>
                                </select>
                                <input type="hidden" name="provinceName" id="provinceName">
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label" for="district">District:</label>
                                <select class="form-control-modern" id="district" required>
                                    <option value="">-- Select District --</option>
                                </select>
                                <input type="hidden" name="districtName" id="districtName">
                            </div>
                
                            <div class="form-group">
                                <label class="form-label" for="ward">Ward/Commune:</label>
                                <select class="form-control-modern" id="ward" required>
                                    <option value="">-- Select Ward/Commune --</option>
                                </select>
                                <input type="hidden" name="wardName" id="wardName">
                            </div>
                
                            <div class="form-group">
                                <label class="form-label" for="street">Street Address, House Number:</label>
                                <input type="text" class="form-control-modern" id="street" name="street" value="${streetDetail}" required>
                            </div>
                            </div>
                        <div class="card-footer" style="padding: 1.5rem;">
                            <button type="submit" class="btn btn-primary"><i class="fa fa-save"></i> Save Info</button>
                            <a href="${pageContext.request.contextPath}/user/profile" class="btn btn-default">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>

            <div class="col-md-6">
                <div class="content-card">
                    <div class="card-header">
                        <h3><i class="fa fa-key"></i> Change Password</h3>
                    </div>
                    <form action="${pageContext.request.contextPath}/user/profile" method="POST">
                        <input type="hidden" name="action" value="changePass">
                        <div class="card-body">
                            
                            <c:if test="${not empty errorPass}">
                                <div class="alert alert-danger">${errorPass}</div>
                            </c:if>
                            
                            <div class="form-group">
                                <label class="form-label" for="currentPassword">Current Password:</label>
                                <input type="password" class="form-control-modern" id="currentPassword" name="currentPassword" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="newPassword">New Password:</label>
                                <input type="password" class="form-control-modern" id="newPassword" name="newPassword" required>
                                <small class="form-text text-muted">At least 8 chars, with uppercase, lowercase, number, and special character.</small>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="confirmPassword">Confirm New Password:</label>
                                <input type="password" class="form-control-modern" id="confirmPassword" name="confirmPassword" required>
                            </div>
                        </div>
                        <div class="card-footer" style="padding: 1.5rem;">
                            <button type="submit" class="btn btn-primary"><i class="fa fa-lock"></i> Change Password</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </section>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const provinceSelect = document.getElementById("province");
        const districtSelect = document.getElementById("district");
        const wardSelect = document.getElementById("ward");

        const provinceNameInput = document.getElementById("provinceName");
        const districtNameInput = document.getElementById("districtName");
        const wardNameInput = document.getElementById("wardName");

        const apiHost = "https://provinces.open-api.vn/api/";

        fetch(apiHost + "?depth=1")
            .then(response => response.json())
            .then(provinces => {
                provinces.forEach(province => {
                    const option = new Option(province.name, province.code);
                    provinceSelect.add(option);
                });
            });

        provinceSelect.addEventListener("change", function () {
            const selectedCode = this.value;
            const selectedName = this.options[this.selectedIndex].text;
            
            provinceNameInput.value = (selectedCode) ? selectedName : "";

            districtSelect.innerHTML = '<option value="">-- Select District --</option>';
            wardSelect.innerHTML = '<option value="">-- Select Ward/Commune --</option>';
            districtNameInput.value = "";
            wardNameInput.value = "";

            if (selectedCode) {
                fetch(apiHost + "p/" + selectedCode + "?depth=2")
                    .then(response => response.json())
                    .then(provinceData => {
                        provinceData.districts.forEach(district => {
                            const option = new Option(district.name, district.code);
                            districtSelect.add(option);
                        });
                    });
            }
        });

        districtSelect.addEventListener("change", function () {
            const selectedCode = this.value;
            const selectedName = this.options[this.selectedIndex].text;

            districtNameInput.value = (selectedCode) ? selectedName : "";

            wardSelect.innerHTML = '<option value="">-- Select Ward/Commune --</option>';
            wardNameInput.value = "";

            if (selectedCode) {
                fetch(apiHost + "d/" + selectedCode + "?depth=2")
                    .then(response => response.json())
                    .then(districtData => {
                        districtData.wards.forEach(ward => {
                            const option = new Option(ward.name, ward.code);
                            wardSelect.add(option);
                        });
                    });
            }
        });

        wardSelect.addEventListener("change", function () {
            const selectedCode = this.value;
            const selectedName = this.options[this.selectedIndex].text;
            wardNameInput.value = (selectedCode) ? selectedName : "";
        });
    });
</script>

<%@ include file="/jsp/layout/footer2.jsp" %>