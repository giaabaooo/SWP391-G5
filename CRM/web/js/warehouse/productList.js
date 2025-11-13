/**
 * Product List Page - JavaScript
 * Handles pagination, filtering, search, and product deletion
 */

$(function() {
    // Pagination variables
    let currentPage = 1;
    let pageSize = 10;
    let allRows = [];
    let filteredRows = [];
    
    // Get server data from data attributes
    function getServerData() {
        var paginationData = document.getElementById('paginationData');
        if (paginationData) {
            return {
                totalProducts: parseInt(paginationData.dataset.totalProducts) || 0,
                totalPages: parseInt(paginationData.dataset.totalPages) || 1
            };
        }
        return { totalProducts: 0, totalPages: 1 };
    }
    
    // Helper function to get current URL parameters
    function getUrlParams() {
        var params = new URLSearchParams(window.location.search);
        var urlParams = {};

        if (params.get('search')) {
            urlParams.search = params.get('search');
        }
        if (params.get('categoryId')) {
            urlParams.categoryId = params.get('categoryId');
        }
        if (params.get('brandId')) {
            urlParams.brandId = params.get('brandId');
        }
        if (params.get('status')) {
            urlParams.status = params.get('status');
        }
        if (params.get('pageSize')) {
            urlParams.pageSize = params.get('pageSize');
        }

        return urlParams;
    }
    
    // Helper function to build URL with parameters
    function buildUrlWithParams(params) {
        var url = window.location.pathname + '?';
        var paramArray = [];
        
        for (var key in params) {
            if (params[key] && params[key] !== '') {
                paramArray.push(key + '=' + encodeURIComponent(params[key]));
            }
        }
        
        return url + paramArray.join('&');
    }
    
    // Initialize pagination (server-side)
    function initPagination() {
        renderPagination();
        updatePaginationInfo();
    }
    
    // Update pagination info text (from server data)
    function updatePaginationInfo() {
        var urlParams = new URLSearchParams(window.location.search);
        var currentPageFromUrl = parseInt(urlParams.get('page')) || 1;
        var pageSizeFromUrl = parseInt(urlParams.get('pageSize')) || 10;
        var serverData = getServerData();
        var totalProducts = serverData.totalProducts;
        
        var startIndex = (currentPageFromUrl - 1) * pageSizeFromUrl + 1;
        var endIndex = Math.min(currentPageFromUrl * pageSizeFromUrl, totalProducts);
        
        var infoElement = document.getElementById('paginationInfo');
        if (infoElement) {
            if (totalProducts === 0) {
                infoElement.textContent = 'No products to display';
            } else {
                infoElement.textContent = 
                    'Showing ' + startIndex + ' to ' + endIndex + ' of ' + totalProducts + ' products';
            }
        }
    }
    
    // Render pagination buttons
    function renderPagination() {
        var urlParams = new URLSearchParams(window.location.search);
        var currentPageFromUrl = parseInt(urlParams.get('page')) || 1;
        var serverData = getServerData();
        var totalPages = serverData.totalPages;
        var pageNumbersDiv = document.getElementById('pageNumbers');
        
        if (!pageNumbersDiv) return;
        
        pageNumbersDiv.innerHTML = '';
        
        // Determine which pages to show
        var startPage = Math.max(1, currentPageFromUrl - 2);
        var endPage = Math.min(totalPages, currentPageFromUrl + 2);
        
        // Adjust if near the beginning
        if (currentPageFromUrl <= 3) {
            endPage = Math.min(5, totalPages);
        }
        
        // Adjust if near the end
        if (currentPageFromUrl > totalPages - 3) {
            startPage = Math.max(1, totalPages - 4);
        }
        
        // Create page buttons
        for (var i = startPage; i <= endPage; i++) {
            var btn = document.createElement('button');
            btn.className = 'pagination-btn' + (i === currentPageFromUrl ? ' active' : '');
            btn.textContent = i;
            btn.onclick = (function(pageNum) {
                return function() { goToPage(pageNum); };
            })(i);
            pageNumbersDiv.appendChild(btn);
        }
        
        updatePaginationButtons();
    }
    
    // Update pagination button states
    function updatePaginationButtons() {
        var urlParams = new URLSearchParams(window.location.search);
        var currentPageFromUrl = parseInt(urlParams.get('page')) || 1;
        var serverData = getServerData();
        var totalPages = serverData.totalPages;
        
        var firstBtn = document.getElementById('firstPageBtn');
        var prevBtn = document.getElementById('prevPageBtn');
        var nextBtn = document.getElementById('nextPageBtn');
        var lastBtn = document.getElementById('lastPageBtn');
        
        if (firstBtn) firstBtn.disabled = currentPageFromUrl === 1;
        if (prevBtn) prevBtn.disabled = currentPageFromUrl === 1;
        if (nextBtn) nextBtn.disabled = currentPageFromUrl === totalPages || totalPages === 0;
        if (lastBtn) lastBtn.disabled = currentPageFromUrl === totalPages || totalPages === 0;
    }
    
    // Pagination navigation functions (with URL parameters preserved)
    window.goToPage = function(page) {
        var params = getUrlParams();
        params.page = page;
        window.location.href = buildUrlWithParams(params);
    };
    
    window.goToFirstPage = function() {
        goToPage(1);
    };
    
    window.goToPrevPage = function() {
        var urlParams = new URLSearchParams(window.location.search);
        var currentPage = parseInt(urlParams.get('page')) || 1;
        if (currentPage > 1) {
            goToPage(currentPage - 1);
        }
    };
    
    window.goToNextPage = function() {
        var urlParams = new URLSearchParams(window.location.search);
        var currentPage = parseInt(urlParams.get('page')) || 1;
        var serverData = getServerData();
        var totalPages = serverData.totalPages;
        if (currentPage < totalPages) {
            goToPage(currentPage + 1);
        }
    };
    
    window.goToLastPage = function() {
        var serverData = getServerData();
        var totalPages = serverData.totalPages;
        goToPage(totalPages);
    };
    
    window.changePageSize = function() {
        var newPageSize = document.getElementById('pageSize').value;
        var params = getUrlParams();
        params.pageSize = newPageSize;
        params.page = 1; // Reset to first page when changing page size
        window.location.href = buildUrlWithParams(params);
    };
    
    // Status change button click handler
    var currentDeleteProductId = null;
    var currentAction = null;

    // Handle both activate and deactivate buttons
    $(document).on('click', '.btn-delete, .btn-action[data-action]', function() {
        var $btn = $(this);
        var productId = $btn.data('product-id');
        var productName = $btn.data('product-name');
        var action = $btn.data('action');

        // Store product info
        currentDeleteProductId = productId;
        currentAction = action;

        // Update modal content based on action
        $('#modalProductName').text(productName);

        if (action === 'deactivate') {
            $('#modalTitle').text('Deactivate Product');
            $('#modalMessage').text('Are you sure you want to deactivate this product?');
            $('#modalDescription').text('This will mark the product as inactive.');
            $('#modalWarning').parent().hide();
            $('#modalIcon').removeClass('fa-check').addClass('fa-ban');
            $('#confirmIcon').removeClass('fa-check').addClass('fa-ban');
            $('#confirmText').text('Deactivate');
            $('#confirmDeleteBtn').removeClass('modal-btn-activate').addClass('modal-btn-delete');
            $('#deleteModal').removeClass('activate-mode');
        } else if (action === 'activate') {
            $('#modalTitle').text('Activate Product');
            $('#modalMessage').text('Are you sure you want to activate this product?');
            $('#modalDescription').text('This will mark the product as active.');
            $('#modalWarning').parent().hide();
            $('#modalIcon').removeClass('fa-ban').addClass('fa-check');
            $('#confirmIcon').removeClass('fa-ban').addClass('fa-check');
            $('#confirmText').text('Activate');
            $('#confirmDeleteBtn').removeClass('modal-btn-delete').addClass('modal-btn-activate');
            $('#deleteModal').addClass('activate-mode');
        }

        // Show modal
        $('#deleteModal').addClass('active');
    });

    // Close modal function
    window.closeDeleteModal = function() {
        $('#deleteModal').removeClass('active');
        currentDeleteProductId = null;
        currentAction = null;
    };

    // Close modal when clicking outside
    $('#deleteModal').on('click', function(e) {
        if ($(e.target).is('#deleteModal')) {
            closeDeleteModal();
        }
    });

    // Close modal on ESC key
    $(document).on('keydown', function(e) {
        if (e.key === 'Escape' && $('#deleteModal').hasClass('active')) {
            closeDeleteModal();
        }
    });

    // Confirm status change button
    $('#confirmDeleteBtn').on('click', function() {
        if (currentDeleteProductId && currentAction) {
            var actionUrl = currentAction === 'activate' ? '../warestaff/activateProduct' : '../warestaff/deleteProduct';

            // Create and submit form
            var form = $('<form>', {
                'method': 'POST',
                'action': actionUrl
            });

            var input = $('<input>', {
                'type': 'hidden',
                'name': 'id',
                'value': currentDeleteProductId
            });

            form.append(input);
            $('body').append(form);
            form.submit();
        }
    });

    // Handle collapsible menu
    $('.treeview > a').click(function(e) {
        e.preventDefault();
        var target = $(this).attr('href');
        $(target).collapse('toggle');
    });

    // Auto-expand Products menu since we're on view list product page
    $('#inventoryMenu').addClass('in');
    
    // Set page size from URL parameter
    var urlParams = new URLSearchParams(window.location.search);
    var pageSizeFromUrl = urlParams.get('pageSize');
    if (pageSizeFromUrl) {
        var pageSizeSelect = document.getElementById('pageSize');
        if (pageSizeSelect) {
            pageSizeSelect.value = pageSizeFromUrl;
        }
    }
    
    // Initialize pagination on page load
    initPagination();
    
    // Auto-hide success and error messages after 3 seconds
    setTimeout(function() {
        $('.alert-success').fadeOut(500, function() {
            $(this).remove();
        });
        $('.alert-danger').fadeOut(500, function() {
            $(this).remove();
        });
    }, 3000);
    
    // Apply filters function
    window.applyFilters = function() {
        var searchQuery = document.getElementById('searchInput').value;
        var categoryId = document.getElementById('categoryFilter').value;
        var brandId = document.getElementById('brandFilter').value;
        var status = document.getElementById('statusFilter').value;

        // Build URL with parameters
        var url = window.location.pathname + '?';
        var params = [];

        if (searchQuery && searchQuery.trim() !== '') {
            params.push('search=' + encodeURIComponent(searchQuery));
        }
        if (categoryId && categoryId !== '') {
            params.push('categoryId=' + categoryId);
        }
        if (brandId && brandId !== '') {
            params.push('brandId=' + brandId);
        }
        if (status && status !== '') {
            params.push('status=' + status);
        }

        url += params.join('&');

        // Redirect to filtered URL
        window.location.href = url;
    };
    
    // Clear filters function
    window.clearFilters = function() {
        // Redirect to page without parameters
        window.location.href = window.location.pathname;
    };
    
    // Handle Enter key in search input
    $('#searchInput').on('keypress', function(e) {
        if (e.which === 13) { // Enter key
            applyFilters();
        }
    });
    
    // Handle change event for dropdowns
    $('#categoryFilter, #brandFilter, #statusFilter').on('change', function() {
        applyFilters();
    });
});

