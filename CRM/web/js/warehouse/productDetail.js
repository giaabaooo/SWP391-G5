/**
 * Product Detail Page - JavaScript
 * Handles product deletion and menu interactions
 */

$(function() {
    // Handle collapsible menu
    $('.treeview > a').click(function(e) {
        e.preventDefault();
        var target = $(this).attr('href');
        $(target).collapse('toggle');
    });

    // Auto-expand Products menu
    $('#inventoryMenu').addClass('in');
});

// Delete product function
function deleteProduct(id) {
    if (confirm('Are you sure you want to delete this product? This action cannot be undone.')) {
        // TODO: Implement delete functionality
        alert('Delete product ID: ' + id);
    }
}

