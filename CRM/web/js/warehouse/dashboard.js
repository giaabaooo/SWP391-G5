/**
 * Warehouse Dashboard Page - JavaScript
 * Handles dashboard interactions, requests approval/rejection
 */

$(function() {
    // Initialize iCheck for checkboxes
    $('input[type="checkbox"].flat-grey').iCheck({
        checkboxClass: 'icheckbox_flat-grey'
    });

    // Handle checkbox events
    $('input').on('ifChecked', function(event) {
        $(this).parents('li').addClass("task-done");
    });
    $('input').on('ifUnchecked', function(event) {
        $(this).parents('li').removeClass("task-done");
    });

    // Handle approve/reject buttons
    $('.btn-approve').click(function() {
        var requestId = $(this).closest('.request-item').find('.request-header').text();
        if (confirm('Are you sure you want to approve ' + requestId + '?')) {
            // Add AJAX call to approve request
            $(this).closest('.request-item').fadeOut();
        }
    });

    $('.btn-reject').click(function() {
        var requestId = $(this).closest('.request-item').find('.request-header').text();
        if (confirm('Are you sure you want to reject ' + requestId + '?')) {
            // Add AJAX call to reject request
            $(this).closest('.request-item').fadeOut();
        }
    });

    // Auto-refresh statistics every 30 seconds
    setInterval(function() {
        // You can add AJAX calls here to refresh data
        console.log('Refreshing warehouse data...');
    }, 30000);
});

