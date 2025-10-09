<%-- 
    Document   : sidebar2
    Created on : Oct 3, 2025, 7:14:46 AM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div class="wrapper row-offcanvas row-offcanvas-left">

    <!-- SIDEBAR -->
    <aside class="left-side sidebar-offcanvas">
        <section class="sidebar">
            <div class="user-panel">
                <div class="pull-left image">
                    <img src="../img/warehouse-user.png" class="img-circle" alt="User Image" onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iMjAiIGN5PSIyMCIgcj0iMjAiIGZpbGw9IiM2NzdFRUEiLz4KPHN2ZyB4PSI4IiB5PSI4IiB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTEyIDEyQzE0LjIwOTEgMTIgMTYgMTAuMjA5MSAxNiA4QzE2IDUuNzkwODYgMTQuMjA5MSA0IDEyIDRDOS43OTA4NiA0IDggNS43OTA4NiA4IDhDOCAxMC4yMDkxIDkuNzkwODYgMTIgMTIgMTJaIiBmaWxsPSJ3aGl0ZSIvPgo8cGF0aCBkPSJNMTIgMTRDOC42ODYyOSAxNCA2IDE2LjY4NjMgNiAyMEgxOEMxOCAxNi42ODYzIDE1LjMxMzcgMTQgMTIgMTRaIiBmaWxsPSJ3aGl0ZSIvPgo8L3N2Zz4KPC9zdmc+'" />
                </div>
                <div class="pull-left info">
                    <p>${sessionScope.user.fullName}</p>
                    <a href="#"><i class="fa fa-circle text-success"></i> Online</a>
                </div>
            </div>

            <!--            <ul class="sidebar-menu">
                            <li class="active"><a href="dashboard.jsp"><i class="fa fa-dashboard"></i> Dashboard</a></li>
                            
                             Inventory Management 
                            <li class="treeview">
                                <a href="#inventoryMenu" data-toggle="collapse" aria-expanded="false">
                                    <i class="fa fa-cubes"></i> <span>Inventory Management</span>
                                </a>
                                <ul class="collapse" id="inventoryMenu">
                                    <li><a href="inventory.jsp"><i class="fa fa-list"></i> View Inventory</a></li>
                                    <li><a href="../addNewProduct"><i class="fa fa-plus"></i> Add Product</a></li>
                                    <li><a href="updateItem.jsp"><i class="fa fa-edit"></i> Update Product</a></li>
                                    <li><a href="deleteItem.jsp"><i class="fa fa-trash"></i> Delete Product</a></li>
                                </ul>
                            </li>
                            
                             Categories 
                            <li class="treeview">
                                <a href="#categoryMenu" data-toggle="collapse" aria-expanded="false">
                                    <i class="fa fa-tags"></i> <span>Categories</span>
                                </a>
                                <ul class="collapse" id="categoryMenu">
                                    <li><a href="viewCategories.jsp"><i class="fa fa-eye"></i> View Categories</a></li>
                                    <li><a href="addCategory.jsp"><i class="fa fa-plus"></i> Add Category</a></li>
                                    <li><a href="updateCategory.jsp"><i class="fa fa-edit"></i> Update Category</a></li>
                                    <li><a href="deleteCategory.jsp"><i class="fa fa-trash"></i> Delete Category</a></li>
                                </ul>
                            </li>
                            
                             Transactions 
                            <li class="treeview">
                                <a href="#transactionMenu" data-toggle="collapse" aria-expanded="false">
                                    <i class="fa fa-exchange"></i> <span>Transactions</span>
                                </a>
                                <ul class="collapse" id="transactionMenu">
                                    <li><a href="transactions.jsp"><i class="fa fa-list"></i> View Transactions</a></li>
                                    <li><a href="spareParts.jsp"><i class="fa fa-cogs"></i> Manage Spare Parts</a></li>
                                    <li><a href="importExport.jsp"><i class="fa fa-upload"></i> Import/Export</a></li>
                                </ul>
                            </li>
                            
                             Requests 
                            <li><a href="requests.jsp"><i class="fa fa-clipboard"></i> Inventory Requests</a></li>
                            
                             Reports 
                            <li><a href="reports.jsp"><i class="fa fa-bar-chart"></i> Inventory Reports</a></li>
                        </ul>-->

            <ul class="sidebar-menu">
                <li>
                    <a href="${pageContext.request.contextPath}/cskh/user?action=list">
                        <i class="fa fa-users"></i> <span>User Manager</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/cskh/customer?action=list">
                        <i class="fa fa-user"></i> <span>Customer Manager</span>
                    </a>
                </li>
            </ul>
        </section>
    </aside>

    <!-- MAIN CONTENT -->
    <aside class="right-side">
        <section class="content">
