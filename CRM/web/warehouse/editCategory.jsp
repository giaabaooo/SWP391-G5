<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="data.Category" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Category</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
</head>
<body class="skin-black">
<div class="container" style="margin-top:24px;">
    <h2>Edit Category</h2>
    <% Category category = (Category) request.getAttribute("category"); %>
    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
    <% } %>
    <form method="post" action="../warestaff/editCategory">
        <input type="hidden" name="id" value="<%= category != null ? category.getId() : 0 %>" />
        <div class="form-group">
            <label>Name</label>
            <input name="name" class="form-control" required value="<%= category != null ? category.getName() : "" %>" />
        </div>
        <div class="form-group">
            <label>Description</label>
            <textarea name="description" class="form-control" rows="4"><%= category != null ? category.getDescription() : "" %></textarea>
        </div>
        <div class="checkbox">
            <label><input type="checkbox" name="is_active" <%= category != null && category.isActive() ? "checked" : "" %> /> Active</label>
        </div>
        <button type="submit" class="btn btn-primary">Save</button>
        <a class="btn btn-default" href="../warestaff/categoryList">Cancel</a>
    </form>
    <hr/>
    <a href="${pageContext.request.contextPath}/warehouse/dashboard.jsp">Back to Dashboard</a>
    <script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
    </div>
</body>
</html>


