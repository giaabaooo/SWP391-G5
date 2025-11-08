<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/admin/layout/header.jsp" %>
<%@ include file="/admin/layout/sidebar.jsp" %>

<style>
    .permission-container {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
        gap: 15px;
    }
    .permission-item {
        display: flex;
        align-items: center;
        background: #fdfdfd;
        border: 1px solid #eee;
        padding: 10px 15px;
        border-radius: 5px;
        transition: all 0.2s ease;
    }
    .permission-item:hover {
        border-color: #667eea;
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }
    .permission-item input[type="checkbox"] {
        margin-right: 10px;
        transform: scale(1.2);
    }
    .permission-item label {
        margin: 0;
        font-weight: 500;
        color: #333;
    }
    .permission-item small {
        display: block;
        font-size: 12px;
        color: #777;
    }
    .permission-header {
        color: #2d3748;
        font-weight: 600;
        margin-bottom: 1.5rem;
        padding-bottom: 0.5rem;
        border-bottom: 2px solid #e2e8f0;
    }
    .btn-load {
        background: #f8f9fa;
        border: 1px solid #e2e8f0;
        color: #4a5568;
    }
</style>

<div class="wrapper row-offcanvas row-offcanvas-left">
    <aside class="right-side">
        <section class="content">

            <div class="row">
                <div class="col-md-12">
                    <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">Role Permission Management</h1>
                    <p style="color: #718096; margin-bottom: 2rem;">Assign permissions (features) to specific roles.</p>

                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success">${successMessage}</div>
                    </c:if>
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger">${errorMessage}</div>
                    </c:if>
                </div>
            </div>

            <div class="row">
                <div class="col-md-12">
                    <div class="card product-detail-card" style="margin-bottom: 20px;">
                        <div class="card-body">
                            <h4 class="permission-header">Step 1: Select a Role</h4>
                            <form action="${pageContext.request.contextPath}/admin/permissions" method="GET" class="form-inline">
                                <div class="form-group" style="margin-right: 10px; flex-grow: 1;">
                                    <label for="role_id" style="margin-right: 10px;">Role:</label>
                                    <select name="role_id" id="role_id" class="form-control" style="width: 300px;">
                                        <option value="">-- Select a Role --</option>
                                        <c:forEach var="role" items="${allRoles}">
                                            <option value="${role.id}" ${role.id == selectedRoleId ? 'selected' : ''}>
                                                ${role.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <button type="submit" class="btn btn-load">
                                    <i class="fa fa-refresh"></i> Load Permissions
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <c:if test="${not empty selectedRole}">
                <div class="row">
                    <div class="col-md-12">
                        <div class="card product-detail-card">
                            <form action="${pageContext.request.contextPath}/admin/permissions" method="POST">
                                <input type="hidden" name="role_id" value="${selectedRole.id}">

                                <div class="card-body">
                                    <h4 class="permission-header">Step 2: Assign Permissions for Role: ${selectedRole.name}</h4>

                                    <div class="permission-container">
                                        <c:forEach var="perm" items="${allPermissions}">

                                            <c:set var="isChecked" value="${currentRolePermissions.contains(perm.id) ? 'checked' : ''}" />

                                            <div class="permission-item">
                                                <input type="checkbox" name="permission_id" value="${perm.id}" id="perm_${perm.id}" ${isChecked}>

                                                <label for="perm_${perm.id}" style="margin-left: 10px;">
                                                    <strong>${perm.name}</strong>
                                                    <small>${perm.description}</small>
                                                </label>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>

                                <div class="card-footer" style="padding: 1.5rem; text-align: right;">
                                    <button type="submit" class="btn btn-primary" style="min-width: 150px;">
                                        <i class="fa fa-save"></i> Save Changes
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </c:if>

        </section>
        <%@ include file="/admin/layout/footer.jsp" %>
    </aside>
</div>

<script src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/app.js" type="text/javascript"></script>

</body>
</html>