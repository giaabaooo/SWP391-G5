<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="data.Brand" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Warehouse Staff | View Brands</title>
    <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
    <meta name="description" content="Warehouse Management System">
    <meta name="keywords" content="Warehouse, Inventory, Management">
    <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/ionicons.min.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/morris/morris.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/jvectormap/jquery-jvectormap-1.2.2.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/daterangepicker/daterangepicker-bs3.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/iCheck/all.css" rel="stylesheet" type="text/css" />
    <link href='http://fonts.googleapis.com/css?family=Lato' rel='stylesheet' type='text/css'>
    <link href="${pageContext.request.contextPath}/css/admin/style.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/warehouse/productList.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/warehouse/responsive.css" rel="stylesheet" type="text/css" />
</head>
<body class="skin-black">

<button class="mobile-menu-toggle" onclick="toggleMobileMenu()">
    <i class="fa fa-bars"></i>
</button>

<header class="header">
    <a href="${pageContext.request.contextPath}/warestaff/dashboard" class="logo" style="color: #ffffff; font-weight: 600; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">Warehouse Staff</a>
    <nav class="navbar navbar-static-top" role="navigation">
        <div class="navbar-right">
            <ul class="nav navbar-nav">
                <li class="dropdown user user-menu">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        <i class="fa fa-user"></i>
                        <span>${sessionScope.user.fullName} <i class="caret"></i></span>
                    </a>
                    <ul class="dropdown-menu dropdown-custom dropdown-menu-right">
                        <li class="dropdown-header text-center">Account</li>
                        <li>
                            <a href="#"><i class="fa fa-user fa-fw pull-right"></i> Profile</a>
                            <a data-toggle="modal" href="#modal-user-settings"><i class="fa fa-cog fa-fw pull-right"></i> Settings</a>
                        </li>
                        <li class="divider"></li>
                        <li><a href="../login.jsp"><i class="fa fa-ban fa-fw pull-right"></i> Logout</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </nav>
</header>
<div class="wrapper row-offcanvas row-offcanvas-left">

    <aside class="left-side sidebar-offcanvas">
        <section class="sidebar">
            <div class="user-panel">
                <div class="pull-left image">
                    <img src="${pageContext.request.contextPath}/img/warehouse-user.png" class="img-circle" alt="User Image" onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iMjAiIGN5PSIyMCIgcj0iMjAiIGZpbGw9IiM2NzdFRUEiLz4KPHN2ZyB4PSI4IiB5PSI4IiB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTEyIDEyQzE0LjIwOTEgMTIgMTYgMTAuMjA5MSAxNiA4QzE2IDUuNzkwODYgMTQuMjA5MSA0IDEyIDRDOS43OTA4NiA0IDggNS43OTA4NiA4IDhDOCAxMC4yMDkxIDkuNzkwODYgMTIgMTIgMTJaIiBmaWxsPSJ3aGl0ZSIvPgo8cGF0aCBkPSJNMTIgMTRDOC42ODYyOSAxNCA2IDE2LjY4NjMgNiAyMEgxOEMxOCAxNi42ODYzIDE1LjMxMzcgMTQgMTIgMTRaIiBmaWxsPSJ3aGl0ZSIvPgo8L3N2Zz4KPC9zdmc+'" />
                </div>
                <div class="pull-left info">
                    <p>${sessionScope.user.fullName}</p>
                    <a href="#"><i class="fa fa-circle text-success"></i> Online</a>
                </div>
            </div>

            <ul class="sidebar-menu">
                <li><a href="${pageContext.request.contextPath}/warestaff/dashboard"><i class="fa fa-dashboard"></i> Dashboard</a></li>
                <li class="treeview">
                    <a href="javascript:void(0)" data-toggle="collapse" data-target="#inventoryMenu" aria-expanded="false">
                        <i class="fa fa-cubes"></i> <span>Products</span>
                    </a>
                    <ul class="collapse" id="inventoryMenu">
                        <li><a href="../warestaff/viewListProduct"><i class="fa fa-list"></i> View List Product</a></li>
                        <li><a href="../warestaff/addNewProduct"><i class="fa fa-plus"></i> Add Product</a></li>
                    </ul>
                </li>
                <li class="treeview">
                    <a href="javascript:void(0)" data-toggle="collapse" data-target="#categoryMenu" aria-expanded="false">
                        <i class="fa fa-tags"></i> <span>Categories</span>
                    </a>
                    <ul class="collapse" id="categoryMenu">
                        <li><a href="../warestaff/categoryList"><i class="fa fa-eye"></i> View Categories</a></li>
                        <li><a href="../warestaff/addCategory"><i class="fa fa-plus"></i> Add Category</a></li>
                    </ul>
                </li>
                <li class="treeview">
                    <a href="javascript:void(0)" data-toggle="collapse" data-target="#brandMenu" aria-expanded="false">
                        <i class="fa fa-bookmark"></i> <span>Brands</span>
                    </a>
                    <ul class="collapse" id="brandMenu">
                        <li><a href="../warestaff/brandList"><i class="fa fa-eye"></i> View Brands</a></li>
                        <li><a href="../warestaff/addBrand"><i class="fa fa-plus"></i> Add Brand</a></li>
                    </ul>
                </li>
                <!-- Transactions -->
                <li class="treeview">
                    <a href="javascript:void(0)" data-toggle="collapse" data-target="#transactionMenu" aria-expanded="false">
                        <i class="fa fa-exchange"></i> <span>Transactions</span>
                    </a>
                    <ul class="collapse" id="transactionMenu">
                        <li><a href="transactions.jsp"><i class="fa fa-list"></i> View Transactions</a></li>
                        <li><a href="spareParts.jsp"><i class="fa fa-cogs"></i> Manage Spare Parts</a></li>
                        <li><a href="importExport.jsp"><i class="fa fa-upload"></i> Import/Export</a></li>
                    </ul>
                </li>
                
            </ul>
        </section>
    </aside>

    <aside class="right-side">
        <section class="content">
            <div id="paginationData" style="display:none;"
                 data-total-brands="<%= request.getAttribute("totalBrands") != null ? request.getAttribute("totalBrands") : 0 %>"
                 data-total-pages="<%= request.getAttribute("totalPages") != null ? request.getAttribute("totalPages") : 1 %>">
            </div>

            <div class="row">
                <div class="col-md-12">
                    <h1 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0;">View Brands</h1>
                    <p style="color: #718096; margin-bottom: 2rem;">View and manage all brands</p>

                    <% if (request.getAttribute("error") != null) { %>
                        <div class="alert alert-danger" style="background-color: #fed7d7; border: 1px solid #fc8181; color: #742a2a; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;">
                            <i class="fa fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
                        </div>
                    <% } %>
                    <% if (request.getParameter("success") != null) { %>
                        <div class="alert alert-success" style="background-color: #d1fae5; border: 1px solid #86efac; color: #059669; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;">
                            <i class="fa fa-check-circle"></i> <%= request.getParameter("success") %>
                        </div>
                    <% } %>
                    <% if (request.getParameter("error") != null) { %>
                        <div class="alert alert-danger" style="background-color: #fed7d7; border: 1px solid #fc8181; color: #742a2a; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;">
                            <i class="fa fa-exclamation-circle"></i> <%= request.getParameter("error") %>
                        </div>
                    <% } %>
                </div>
            </div>

            <div class="row">
                <div class="col-md-12">
                    <div class="content-card">
                        <div class="card-header">
                            <h3><i class="fa fa-list"></i> Brand List</h3>
                            <a href="../warestaff/addBrand" class="btn btn-primary">
                                <i class="fa fa-plus"></i> Add New Brand
                            </a>
                        </div>

                        <div class="filter-bar">
                            <input type="text" id="searchInput" class="search-input" placeholder="Search by brand name..." 
                                   value="<%= request.getAttribute("searchQuery") != null ? request.getAttribute("searchQuery") : "" %>">

                            <select id="statusFilter" class="search-input" style="min-width: 150px;">
                                <option value="">All Status</option>
                                <option value="1" <%= "1".equals(request.getAttribute("activeFilter")) ? "selected" : "" %>>Active</option>
                                <option value="0" <%= "0".equals(request.getAttribute("activeFilter")) ? "selected" : "" %>>Inactive</option>
                            </select>

                            <button class="btn btn-primary" onclick="applyFilters()">
                                <i class="fa fa-filter"></i> Filter
                            </button>
                            <button class="btn btn-primary" onclick="clearFilters()" style="background: #6c757d; border-color: #6c757d;">
                                <i class="fa fa-times"></i> Clear
                            </button>
                        </div>

                        <div class="card-body">
                            <%
                                List<Brand> brands = (List<Brand>) request.getAttribute("brands");
                                if (brands != null && !brands.isEmpty()) {
                            %>
                            <div class="table-responsive">
                                <table class="inventory-table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Brand Name</th>
                                            <th>Description</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody id="brandTableBody">
                                        <% for (Brand brand : brands) { %>
                                        <tr>
                                            <td><strong>#<%= brand.getId() %></strong></td>
                                            <td><strong><%= brand.getName() %></strong></td>
                                            <td>
                                                <% if (brand.getDescription() != null && !brand.getDescription().isEmpty()) { %>
                                                    <%= brand.getDescription().length() > 50 ? brand.getDescription().substring(0, 50) + "..." : brand.getDescription() %>
                                                <% } else { %>
                                                    <span style="color: #a0aec0;">No description</span>
                                                <% } %>
                                            </td>
                                            <td>
                                                <% if (brand.isActive()) { %>
                                                    <span class="badge-active">Active</span>
                                                <% } else { %>
                                                    <span class="badge-inactive">Inactive</span>
                                                <% } %>
                                            </td>
                                            <td>
                                                <a href="../warestaff/viewBrandDetail?id=<%= brand.getId() %>" class="btn btn-action btn-view" style="text-decoration: none; background-color: #17a2b8; border-color: #17a2b8; color: white;">
                                                    <i class="fa fa-eye"></i> View Details
                                                </a>
                                                <a href="../warestaff/editBrand?id=<%= brand.getId() %>" class="btn btn-action btn-edit" style="text-decoration: none;">
                                                    <i class="fa fa-edit"></i> Edit
                                                </a>
                                                <button class="btn btn-action btn-delete" data-brand-id="<%= brand.getId() %>" data-brand-name="<%= brand.getName() %>">
                                                    <i class="fa fa-trash"></i> Delete
                                                </button>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>

                            <div class="pagination-container">
                                <div class="pagination-info">
                                    <span id="paginationInfo">Showing 1 to 10 of 0 brands</span>
                                </div>
                                <div class="page-size-selector">
                                    <label for="pageSize">Show:</label>
                                    <select id="pageSize" onchange="changePageSize()">
                                        <option value="5">5</option>
                                        <option value="10" selected>10</option>
                                        <option value="25">25</option>
                                        <option value="50">50</option>
                                        <option value="100">100</option>
                                    </select>
                                    <span>per page</span>
                                </div>
                                <div class="pagination-controls">
                                    <button class="pagination-btn" id="firstPageBtn" onclick="goToFirstPage()">
                                        <i class="fa fa-angle-double-left"></i>
                                    </button>
                                    <button class="pagination-btn" id="prevPageBtn" onclick="goToPrevPage()">
                                        <i class="fa fa-angle-left"></i>
                                    </button>
                                    <div id="pageNumbers"></div>
                                    <button class="pagination-btn" id="nextPageBtn" onclick="goToNextPage()">
                                        <i class="fa fa-angle-right"></i>
                                    </button>
                                    <button class="pagination-btn" id="lastPageBtn" onclick="goToLastPage()">
                                        <i class="fa fa-angle-double-right"></i>
                                    </button>
                                </div>
                            </div>

                            <% } else { %>
                            <div class="empty-state">
                                <i class="fa fa-inbox"></i>
                                <h4>No Brands Found</h4>
                                <p>There are no brands in the system yet.</p>
                                <a href="../warestaff/addBrand" class="btn btn-primary" style="margin-top: 1rem;">
                                    <i class="fa fa-plus"></i> Add Your First Brand
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

<div id="deleteModal" class="modal-overlay">
    <div class="delete-modal" style="max-width:380px;width:80%">
        <div class="modal-header-custom" style="background:#f8f9fa;border-bottom:1px solid #f1f3f4;">
            <div class="modal-icon">
                <i class="fa fa-trash"></i>
            </div>
            <h3>Delete Brand</h3>
        </div>
        <div class="modal-body-custom">
            <p class="warning-text">Are you sure you want to delete this brand?</p>
            <div class="category-name-display" id="modalBrandName">Brand Name</div>
            <p class="warning-text">This will deactivate the brand in your system.</p>
            <span class="warning-badge">
                <i class="fa fa-exclamation-triangle"></i> This action can be undone by re-activating!
            </span>
        </div>
        <div class="modal-footer-custom">
            <button class="modal-btn modal-btn-cancel" onclick="closeDeleteModal()">
                <i class="fa fa-times"></i> Cancel
            </button>
            <button class="modal-btn modal-btn-delete" id="confirmDeleteBtn">
                <i class="fa fa-trash"></i> Delete Brand
            </button>
        </div>
    </div>
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
(function(){
  function getParam(name){const url=new URL(window.location.href);return url.searchParams.get(name)||''}
  function buildUrl(params){const url=new URL(window.location.href);Object.keys(params).forEach(k=>{if(params[k]===null||params[k]===''){url.searchParams.delete(k)}else{url.searchParams.set(k,params[k])}});return url.pathname+url.search+url.hash}
  window.applyFilters=function(){
    const search=document.getElementById('searchInput').value.trim();
    const active=document.getElementById('statusFilter').value;
    window.location.href=buildUrl({search:search,active:active,page:1});
  }
  window.clearFilters=function(){
    document.getElementById('searchInput').value='';
    document.getElementById('statusFilter').value='';
    window.location.href=buildUrl({search:null,active:null,page:1});
  }
  function goPage(p){const pageSize=document.getElementById('pageSize').value;window.location.href=buildUrl({page:p,pageSize:pageSize})}
  window.changePageSize=function(){goPage(1)}
  window.goToFirstPage=function(){goPage(1)}
  window.goToPrevPage=function(){const cp=parseInt(getParam('page')||'1',10);if(cp>1)goPage(cp-1)}
  window.goToNextPage=function(){const cp=parseInt(getParam('page')||'1',10);const tp=parseInt(document.getElementById('paginationData').dataset.totalPages||'1',10);if(cp<tp)goPage(cp+1)}
  window.goToLastPage=function(){const tp=parseInt(document.getElementById('paginationData').dataset.totalPages||'1',10);goPage(tp)}

  // delete modal
  const modal=document.getElementById('deleteModal');
  const nameEl=document.getElementById('modalBrandName');
  const confirmBtn=document.getElementById('confirmDeleteBtn');
  let currentId=null;
  function openDelete(id,name){currentId=id;nameEl.textContent=name;modal.classList.add('active')}
  window.closeDeleteModal=function(){modal.classList.remove('active');currentId=null}
  document.getElementById('brandTableBody') && document.getElementById('brandTableBody').addEventListener('click',function(e){
    const btn=e.target.closest('.btn-delete');
    if(!btn) return; openDelete(btn.getAttribute('data-brand-id'), btn.getAttribute('data-brand-name'));
  });
  confirmBtn && confirmBtn.addEventListener('click',function(){
    if(!currentId) return;
    const form=document.createElement('form');
    form.method='POST'; form.action='${pageContext.request.contextPath}/warestaff/deleteBrand';
    const idIn=document.createElement('input'); idIn.type='hidden'; idIn.name='id'; idIn.value=currentId; form.appendChild(idIn);
    const mode=document.createElement('input'); mode.type='hidden'; mode.name='mode'; mode.value='soft'; form.appendChild(mode);
    document.body.appendChild(form); form.submit();
  });
  // pagination helpers
  function getParam(name){const url=new URL(window.location.href);return url.searchParams.get(name)||''}
  function buildUrl(params){const url=new URL(window.location.href);Object.keys(params).forEach(k=>{if(params[k]===null||params[k]===''){url.searchParams.delete(k)}else{url.searchParams.set(k,params[k])}});return url.pathname+url.search+url.hash}
  function updatePaginationInfo(){const total=parseInt(document.getElementById('paginationData').dataset.totalBrands||'0',10);const totalPages=parseInt(document.getElementById('paginationData').dataset.totalPages||'1',10);const cur=parseInt(getParam('page')||'1',10);const size=parseInt(getParam('pageSize')||document.getElementById('pageSize').value||'10',10);const start=total?((cur-1)*size+1):0;const end=Math.min(cur*size,total);const el=document.getElementById('paginationInfo');if(el){el.textContent= total===0? 'No brands to display' : ('Showing '+start+' to '+end+' of '+total+' brands');}
    // set pageSize from URL if present
    const ps=getParam('pageSize'); if(ps){const sel=document.getElementById('pageSize'); if(sel) sel.value=ps;}
  }
  function renderPageNumbers(){const cur=parseInt(getParam('page')||'1',10);const totalPages=parseInt(document.getElementById('paginationData').dataset.totalPages||'1',10);const wrap=document.getElementById('pageNumbers'); if(!wrap) return; wrap.innerHTML=''; let start=Math.max(1,cur-2); let end=Math.min(totalPages,cur+2); if(cur<=3){end=Math.min(5,totalPages);} if(cur>totalPages-3){start=Math.max(1,totalPages-4);} for(let i=start;i<=end;i++){const b=document.createElement('button'); b.className='pagination-btn'+(i===cur?' active':''); b.textContent=i; b.onclick=()=>goToPage(i); wrap.appendChild(b);} document.getElementById('firstPageBtn').disabled=cur===1; document.getElementById('prevPageBtn').disabled=cur===1; document.getElementById('nextPageBtn').disabled=cur===totalPages||totalPages===0; document.getElementById('lastPageBtn').disabled=cur===totalPages||totalPages===0; }
  window.goToPage=function(p){const pageSize=document.getElementById('pageSize').value; const search=getParam('search'); const active=getParam('active'); window.location.href=buildUrl({page:p,pageSize:pageSize,search:search,active:active});}
  window.changePageSize=function(){goToPage(1)}
  window.goToFirstPage=function(){goToPage(1)}
  window.goToPrevPage=function(){const cur=parseInt(getParam('page')||'1',10); if(cur>1) goToPage(cur-1)}
  window.goToNextPage=function(){const cur=parseInt(getParam('page')||'1',10); const totalPages=parseInt(document.getElementById('paginationData').dataset.totalPages||'1',10); if(cur<totalPages) goToPage(cur+1)}
  window.goToLastPage=function(){const totalPages=parseInt(document.getElementById('paginationData').dataset.totalPages||'1',10); goToPage(totalPages)}
  // init
  updatePaginationInfo();
  renderPageNumbers();

  // auto-hide alerts after 3s
  setTimeout(function(){
    $('.alert-success').fadeOut(500,function(){ $(this).remove(); });
    $('.alert-danger').fadeOut(500,function(){ $(this).remove(); });
  },3000);
})();
</script>
<script src="${pageContext.request.contextPath}/js/warehouse/warehouse-responsive.js" type="text/javascript"></script>

</body>
</html>


