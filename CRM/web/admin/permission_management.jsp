<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="/admin/layout/header.jsp" %>
<%@ include file="/admin/layout/sidebar.jsp" %>

<style>
    .permission-header {
        color: #2d3748; 
        font-weight: 600; 
        margin: 0;
        border: none;
        padding: 0;
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
    
    .matrix-table th {
        background-color: #fafbfc;
        border: 1px solid #e2e8f0;
        padding: 12px 10px;
        text-align: center;
        vertical-align: middle;
        font-size: 14px;
        color: #2d3748;
        position: sticky;
        top: 0; 
        z-index: 10;
        min-width: 150px;
    }

    .matrix-table td:first-child {
        text-align: left;
        font-weight: 500;
        background: #fdfdfd;
        border: 1px solid #e2e8f0;
        padding: 10px 15px;
        position: sticky;
        left: 0;
        z-index: 5;
        width: 350px;
        word-break: break-word;
    }

    .matrix-table th:first-child {
        position: sticky;
        left: 0;
        top: 0;
        z-index: 15;
        width: 350px;
    }

    .matrix-table td {
        border: 1px solid #e2e8f0;
        padding: 10px;
        text-align: center;
        vertical-align: middle;
    }

    .matrix-table td:first-child small {
        display: block;
        font-size: 12px;
        color: #777;
        font-weight: 400;
        margin-top: 2px;
    }
    .matrix-table input[type="checkbox"] {
        transform: scale(1.4);
        cursor: pointer;
    }
    
    .card-body.matrix-body {
        padding: 0;
        overflow: hidden;
    }
</style>

<div class="wrapper row-offcanvas row-offcanvas-left">
    <aside class="right-side">
        <section class="content">

            <div class="row">
                <div class="col-md-12">
                    <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">Role Permission Matrix</h1>
                    <p style="color: #718096; margin-bottom: 2rem;">Manage all permissions for all roles in one place.</p>
                    
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
                    <div class="card product-detail-card">
                        <form action="${pageContext.request.contextPath}/admin/permissions" method="POST">
                            
                            <div class="card-header">
                                <h4 class="permission-header">Permission Matrix</h4>
                            </div>

                            <div class="card-body matrix-body">
                                <div class="matrix-container">
                                    <table class="matrix-table">
                                        <thead>
                                            <tr>
                                                <th>Permission Feature</th>
                                                <c:forEach var="role" items="${allRoles}">
                                                    <th>${role.name}</th>
                                                </c:forEach>
                                            </tr>
                                        </thead>
                                    <tbody>
                                        <c:set var="totalColumns" value="${allRoles.size() + 1}" />
                                        <c:set var="currentGroup" value="" /> 

                                        <c:forEach var="perm" items="${allPermissions}">
                                            <c:set var="groupName" value="${fn:split(perm.name, '_')[0]}" />
                                            <c:if test="${groupName != currentGroup}">
                                                <tr style="background-color: #f1f3f4;">
                                                    <td colspan="${totalColumns}" style="text-align: left; font-weight: bold; color: #007bff; padding: 10px 15px;">
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
                                                <c:forEach var="role" items="${allRoles}">
                                                    <td>
                                                        <c:set var="key_check" value="${role.id}_${perm.id}" />
                                                        <c:set var="isChecked" value="${matrix.contains(key_check) ? 'checked' : ''}" />
                                                        <input type="checkbox" 
                                                               name="permission_matrix" 
                                                               value="${key_check}" 
                                                               ${isChecked}>
                                                    </td>
                                                </c:forEach>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                    </table>
                                </div>
                            </div>
                            
                            <div class="card-footer" style="padding: 1.5rem; text-align: right;">
                                <button type="submit" class="btn btn-primary" style="min-width: 200px;">
                                    <i class="fa fa-save"></i> Save Entire Matrix
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

        </section>
        <%@ include file="/admin/layout/footer.jsp" %>
    </aside>
</div>

<script src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/app.js" type="text/javascript"></script>

</body>
</html>
