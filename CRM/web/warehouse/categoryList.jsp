<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="data.Category" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Warehouse Staff | Categories</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/admin/style.css" rel="stylesheet" type="text/css" />
</head>
<body class="skin-black">
<header class="header">
    <a href="${pageContext.request.contextPath}/warehouse/dashboard.jsp" class="logo" style="color: #ffffff; font-weight: 600;">Warehouse Staff</a>
</header>
<div class="wrapper row-offcanvas row-offcanvas-left">
    <aside class="left-side sidebar-offcanvas">
        <section class="sidebar">
            <ul class="sidebar-menu">
                <li><a href="${pageContext.request.contextPath}/warehouse/dashboard.jsp"><i class="fa fa-dashboard"></i> Dashboard</a></li>
                <li><a href="../warestaff/viewListProduct"><i class="fa fa-list"></i> View List Product</a></li>
                <li><a href="../warestaff/addNewProduct"><i class="fa fa-plus"></i> Add Product</a></li>
                <li class="active"><a href="../warestaff/categoryList"><i class="fa fa-tags"></i> Categories</a></li>
            </ul>
        </section>
    </aside>
    <aside class="right-side">
        <section class="content">
            <div class="row">
                <div class="col-md-12">
                    <h1 style="margin: 0;">Categories</h1>
                    <p style="color:#718096">Manage product categories</p>
                    <% if (request.getParameter("success") != null) { %>
                        <div class="alert alert-success"><i class="fa fa-check"></i> <%= request.getParameter("success") %></div>
                    <% } %>
                    <% if (request.getParameter("error") != null || request.getAttribute("error") != null) { %>
                        <div class="alert alert-danger"><i class="fa fa-exclamation-circle"></i> <%= request.getParameter("error") != null ? request.getParameter("error") : request.getAttribute("error") %></div>
                    <% } %>
                    <div class="content-card">
                        <div class="card-header">
                            <h3><i class="fa fa-list"></i> Category List</h3>
                            <a href="../warestaff/addCategory" class="btn btn-primary"><i class="fa fa-plus"></i> Add Category</a>
                        </div>
                        <div class="filter-bar">
                            <form method="get" action="../warestaff/categoryList" class="form-inline" style="display:flex; gap:8px; align-items:center;">
                                <input name="search" type="text" class="form-control" placeholder="Search name/description..." value="<%= request.getAttribute("searchQuery") != null ? request.getAttribute("searchQuery") : "" %>" />
                                <select name="active" class="form-control">
                                    <option value="all" <%= "all".equals(request.getAttribute("activeFilter")) || request.getAttribute("activeFilter") == null ? "selected" : "" %>>All</option>
                                    <option value="1" <%= "1".equals(request.getAttribute("activeFilter")) ? "selected" : "" %>>Active</option>
                                    <option value="0" <%= "0".equals(request.getAttribute("activeFilter")) ? "selected" : "" %>>Inactive</option>
                                </select>
                                <select name="pageSize" class="form-control">
                                    <option value="10">10</option>
                                    <option value="25">25</option>
                                    <option value="50">50</option>
                                </select>
                                <button class="btn btn-primary" type="submit"><i class="fa fa-filter"></i> Filter</button>
                            </form>
                        </div>
                        <div class="card-body">
                            <%
                                List<Category> categories = (List<Category>) request.getAttribute("categories");
                                if (categories != null && !categories.isEmpty()) {
                            %>
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Description</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <% for (Category c : categories) { %>
                                    <tr>
                                        <td>#<%= c.getId() %></td>
                                        <td><%= c.getName() %></td>
                                        <td><%= c.getDescription() != null ? c.getDescription() : "" %></td>
                                        <td>
                                            <% if (c.isActive()) { %>
                                                <span class="badge" style="background:#10B981">Active</span>
                                            <% } else { %>
                                                <span class="badge" style="background:#EF4444">Inactive</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <a href="../warestaff/editCategory?id=<%= c.getId() %>" class="btn btn-default"><i class="fa fa-edit"></i> Edit</a>
                                            <form action="../warestaff/deleteCategory" method="post" style="display:inline" onsubmit="return confirm('Delete this category?');">
                                                <input type="hidden" name="id" value="<%= c.getId() %>" />
                                                <input type="hidden" name="mode" value="soft" />
                                                <button class="btn btn-danger" type="submit"><i class="fa fa-trash"></i> Delete</button>
                                            </form>
                                        </td>
                                    </tr>
                                    <% } %>
                                    </tbody>
                                </table>
                            </div>
                            <div class="pagination-container">
                                <div>Page <%= request.getAttribute("currentPage") %> / <%= request.getAttribute("totalPages") %> — Total <%= request.getAttribute("totalCategories") %> categories</div>
                                <div style="margin-top:8px; display:flex; gap:6px;">
                                    <a class="btn btn-default" href="../warestaff/categoryList?page=1&search=<%= request.getAttribute("searchQuery") != null ? request.getAttribute("searchQuery") : "" %>&active=<%= request.getAttribute("activeFilter") != null ? request.getAttribute("activeFilter") : "all" %>"><i class="fa fa-angle-double-left"></i></a>
                                    <a class="btn btn-default" href="../warestaff/categoryList?page=<%= Math.max(1, ((Integer)request.getAttribute("currentPage")) - 1) %>&search=<%= request.getAttribute("searchQuery") != null ? request.getAttribute("searchQuery") : "" %>&active=<%= request.getAttribute("activeFilter") != null ? request.getAttribute("activeFilter") : "all" %>"><i class="fa fa-angle-left"></i></a>
                                    <a class="btn btn-default" href="../warestaff/categoryList?page=<%= Math.min(((Integer)request.getAttribute("totalPages")), ((Integer)request.getAttribute("currentPage")) + 1) %>&search=<%= request.getAttribute("searchQuery") != null ? request.getAttribute("searchQuery") : "" %>&active=<%= request.getAttribute("activeFilter") != null ? request.getAttribute("activeFilter") : "all" %>"><i class="fa fa-angle-right"></i></a>
                                    <a class="btn btn-default" href="../warestaff/categoryList?page=<%= request.getAttribute("totalPages") %>&search=<%= request.getAttribute("searchQuery") != null ? request.getAttribute("searchQuery") : "" %>&active=<%= request.getAttribute("activeFilter") != null ? request.getAttribute("activeFilter") : "all" %>"><i class="fa fa-angle-double-right"></i></a>
                                </div>
                            </div>
                            <% } else { %>
                            <div class="empty-state">
                                <i class="fa fa-inbox"></i>
                                <h4>No Categories Found</h4>
                                <a href="../warestaff/addCategory" class="btn btn-primary" style="margin-top: 1rem;">
                                    <i class="fa fa-plus"></i> Add Category
                                </a>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </aside>
</div>
<script src="${pageContext.request.contextPath}/js/jquery.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js" type="text/javascript"></script>
</body>
</html>


