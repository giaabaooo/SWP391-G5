<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="/admin/layout/header.jsp" %>
<%@ include file="/admin/layout/sidebar.jsp" %>

<style>
    .permission-header {
        color: #2d3748; 
        font-weight: 600; 
        margin: 0; border: none; padding: 0;
    }
    .matrix-container {
        max-height: 65vh; 
        overflow: auto;
        border-top: 1px solid #e2e8f0;
        border-bottom: 1px solid #e2e8f0;
    }
    .matrix-table {
        width: 100%;
        border-collapse: collapse;
        table-layout: fixed; 
    }
    .permission-radios {
        display: flex;
        justify-content: center;
        gap: 10px;
    }
    .permission-radios label {
        display: flex;
        align-items: center;
        cursor: pointer;
        font-size: 13px;
        font-weight: 500;
        margin: 0;
    }
    .permission-radios input[type="radio"] {
        margin-right: 3px;
    }
    .permission-radios label.inherit { color: #555; }
    .permission-radios label.grant { color: #059669; }
    .permission-radios label.deny { color: #dc2626; }

    .form-group label {
        display: block;
        font-weight: 500;
        margin-bottom: 5px;
    }
</style>

<div class="wrapper row-offcanvas row-offcanvas-left">
    <aside class="right-side">
        <section class="content">

            <div class="row">
                <div class="col-md-12">
                    <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">User Permission Overrides</h1>
                    <p style="color: #718096; margin-bottom: 2rem;">Grant or Deny specific permissions for an individual user.</p>
                    
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
                            <h4 class="permission-header" style="border-bottom: 2px solid #e2e8f0; padding-bottom: 0.5rem; margin-bottom: 1.5rem;">Filter Users</h4>
                            
                            <form action="${pageContext.request.contextPath}/admin/user-permissions" method="GET">
                                <div class="row">
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="search">Search:</label>
                                            <input type="text" name="search" id="search" class="form-control" 
                                                   value="<c:out value='${searchKeyword}'/>" placeholder="Username or Full Name...">
                                        </div>
                                    </div>
                                    
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="filter_role_id">Role:</label>
                                            <select name="filter_role_id" id="filter_role_id" class="form-control" style="width: 100%;">
                                                <option value="">-- All Roles --</option>
                                                <c:forEach var="role" items="${allRoles}">
                                                    <option value="${role.id}" ${role.id == filterRoleId ? 'selected' : ''}>
                                                        ${role.name}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    
                                    <div class="col-md-4">
                                        <label>&nbsp;</label> 
                                        <div class="form-group" style="display: flex; gap: 5px;">
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fa fa-filter"></i> Filter Users
                                            </button>
                                            <a href="${pageContext.request.contextPath}/admin/user-permissions" class="btn btn-default">Clear Filters</a>
                                        </div>
                                    </div>
                                </div>
                            </form>
                            </div>
                    </div>
                </div>
            </div>
            
            <div class="row">
                <div class="col-md-12">
                    <div class="card product-detail-card" style="margin-bottom: 20px;">
                        <div class="card-body">
                            <h4 class="permission-header" style="border-bottom: 2px solid #e2e8f0; padding-bottom: 0.5rem; margin-bottom: 1.5rem;">Select a User</h4>
                            
                            <form action="${pageContext.request.contextPath}/admin/user-permissions" method="GET">
                                <input type="hidden" name="search" value="<c:out value='${searchKeyword}'/>">
                                <input type="hidden" name="filter_role_id" value="<c:out value='${filterRoleId}'/>">
                                
                                <div class="row">
                                    <div class="col-md-8">
                                        <div class="form-group">
                                            <label for="user_id">User:</label>
                                            <select name="user_id" id="user_id" class="form-control" style="width: 100%;" required>
                                                <option value="">-- Select a User (Found: ${fn:length(allUsers)}) --</option>
                                                <c:forEach var="user" items="${allUsers}">
                                                    <option value="${user.id}" ${user.id == selectedUserId ? 'selected' : ''}>
                                                        ${user.fullName} (${user.username}) - [${user.role.name}]
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    
                                    <div class="col-md-4">
                                        <label>&nbsp;</label> <div class="form-group">
                                            <button type="submit" class="btn btn-load" style="width: 100%;">
                                                <i class="fa fa-refresh"></i> Load Overrides for this User
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </form>
                            </div>
                    </div>
                </div>
            </div>

            <c:if test="${not empty selectedUser}">
                <div class="row">
                    <div class="col-md-12">
                        <div class="card product-detail-card">
                            <form action="${pageContext.request.contextPath}/admin/user-permissions" method="POST">
                                <input type="hidden" name="user_id" value="${selectedUser.id}">
                                
                                <div class="card-header">
                                    <h4 class="permission-header">3: Set Overrides for User: ${selectedUser.fullName} (Role: ${selectedUser.role.name})</h4>
                                </div>

                                <div class="card-body matrix-body">
                                    <div class="matrix-container">
                                        <table class="matrix-table">
                                            <thead>
                                                <tr>
                                                    <th>Permission Feature</th>
                                                    <th style="width: 300px;">Override Setting</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:set var="totalColumns" value="2" />
                                                <c:set var="currentGroup" value="" /> 

                                                <c:forEach var="perm" items="${allPermissions}">
                                                    
                                                    <c:set var="groupName" value="${fn:split(perm.name, '_')[0]}" />

                                                    <c:if test="${groupName != currentGroup}">
                                                        <tr style="background-color: #f1f3f4;">
                                                            <td colspan="${totalColumns}" style="text-align: left; font-weight: bold; color: #007bff; padding: 10px 15px; position: sticky; left: 0; z-index: 6;">
                                                                ${groupName} Management
                                                            </td>
                                                        </tr>
                                                        <c:set var="currentGroup" value="${groupName}" />
                                                    </c:if>
                                                    
                                                    <tr>
                                                        <td>
                                                            <strong>${perm.name}</strong>
                                                            <small>${perm.description}</small>
                                                        </td>
                                                        
                                                        <td>
                                                            <c:set var="overrideStatus" value="${userOverrides.get(perm.id)}" />
                                                            
                                                            <div class="permission-radios">
                                                                <label class="inherit">
                                                                    <input type="radio" name="perm_${perm.id}" value="inherit" ${overrideStatus == null ? 'checked' : ''}>
                                                                    Inherit
                                                                </label>
                                                                <label class="grant">
                                                                    <input type="radio" name="perm_${perm.id}" value="grant" ${overrideStatus == true ? 'checked' : ''}>
                                                                    Grant
                                                                </label>
                                                                <label class="deny">
                                                                    <input type="radio" name="perm_${perm.id}" value="deny" ${overrideStatus == false ? 'checked' : ''}>
                                                                    Deny
                                                                </label>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                
                                <div class="card-footer" style="padding: 1.5rem; text-align: right;">
                                    <button type="submit" class="btn btn-primary" style="min-width: 200px;">
                                        <i class="fa fa-save"></i> Save Overrides for This User
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

<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<script>
    $(document).ready(function() {
        $('#filter_role_id').select2({
            placeholder: "-- All Roles --",
            allowClear: true
        });
        $('#user_id').select2({
            placeholder: "-- Select a User --",
            allowClear: true
        });
    });
</script>

</body>
</html>