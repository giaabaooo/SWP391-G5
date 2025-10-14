<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Category</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
</head>
<body class="skin-black">
<div class="container" style="margin-top:24px;">
    <h2>Add Category</h2>
    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
    <% } %>
    <form method="post" action="../warestaff/addCategory">
        <div class="form-group">
            <label>Name</label>
            <input name="name" class="form-control" required />
        </div>
        <div class="form-group">
            <label>Description</label>
            <textarea name="description" class="form-control" rows="4"></textarea>
        </div>
        <div class="checkbox">
            <label><input type="checkbox" name="is_active" checked /> Active</label>
        </div>
        <button type="submit" class="btn btn-primary">Create</button>
        <a class="btn btn-default" href="../warestaff/categoryList">Cancel</a>
    </form>
    <hr/>
    <a href="${pageContext.request.contextPath}/warehouse/dashboard.jsp">Back to Dashboard</a>
    <script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
</div>
</body>
</html>


