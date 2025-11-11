/**
 * Add Product Page - JavaScript
 * Handles form validation and image file handling
 *
 * NOTE: This version does NOT include live image preview to avoid reload loops.
 * The image preview error event was causing infinite page reloads.
 */

console.log("addProduct.js loaded");

$(function() {
    console.log("jQuery ready");

    const MAX_IMAGE_SIZE = 5 * 1024 * 1024; // 5 MB

    // Validation helper functions
    function showError(errorId, message) {
        $('#' + errorId).text(message).addClass('show').css({
            'color': '#dc3545',
            'font-style': 'italic',
            'font-size': '0.75rem',
            'font-weight': '500',
            'display': 'block',
            'margin-top': '0.25rem'
        });
    }

    function hideError(errorId) {
        $('#' + errorId).removeClass('show').css('display', 'none');
    }

    // Real-time validation
    $('#productName').on('input', function() {
        var name = $(this).val().trim();
        if (name.length >= 2) {
            hideError('nameError');
        }
    });

    $('#purchasePrice').on('input', function() {
        var price = parseFloat($(this).val());
        if (!isNaN(price) && price >= 0) {
            hideError('purchasePriceError');
        }
    });

    $('#sellingPrice').on('input', function() {
        var price = $(this).val();
        if (price === '' || (!isNaN(parseFloat(price)) && parseFloat(price) >= 0)) {
            hideError('sellingPriceError');
        }
    });

    $('#categoryId').on('change', function() {
        if ($(this).val() !== '') {
            hideError('categoryError');
        }
    });

    // Safe image file handling - NO error event listener to avoid reload loop
    $('#imageFile').on('change', function() {
        hideError('imageError');
        var file = this.files && this.files[0] ? this.files[0] : null;

        if (!file) return;

        if (!file.type || !file.type.startsWith('image/')) {
            showError('imageError', 'Please choose a valid image file');
            this.value = '';
            return;
        }

        if (file.size > MAX_IMAGE_SIZE) {
            showError('imageError', 'Image must be smaller than 5 MB');
            this.value = '';
            return;
        }

        // Clear imageUrl when file is selected
        $('#imageUrl').val('');
    });

    // Safe image URL handling
    $('#imageUrl').on('input', function() {
        hideError('imageError');
        var urlValue = $(this).val().trim();

        if (urlValue !== '') {
            // Clear file input when URL is entered
            $('#imageFile').val('');
        }
    });

    // Reset image button
    $('#resetImage').on('click', function() {
        $('#imageFile').val('');
        $('#imageUrl').val('');
        hideError('imageError');
    });

    // Form submission validation
    $('form').on('submit', function(e) {
        console.log("Form submitting...");

        var isValid = true;

        // Validate product name
        var productName = $('#productName').val().trim();
        if (productName === '') {
            showError('nameError', 'Product name is required');
            isValid = false;
        } else if (productName.length < 2) {
            showError('nameError', 'Product name must be at least 2 characters');
            isValid = false;
        }

        // Validate purchase price
        var purchasePrice = parseFloat($('#purchasePrice').val());
        if (isNaN(purchasePrice)) {
            showError('purchasePriceError', 'Purchase price is required');
            isValid = false;
        } else if (purchasePrice < 0) {
            showError('purchasePriceError', 'Purchase price cannot be negative');
            isValid = false;
        }

        // Validate selling price (optional)
        var sellingPrice = $('#sellingPrice').val();
        if (sellingPrice !== '') {
            var numPrice = parseFloat(sellingPrice);
            if (isNaN(numPrice)) {
                showError('sellingPriceError', 'Selling price must be a valid number');
                isValid = false;
            } else if (numPrice < 0) {
                showError('sellingPriceError', 'Selling price cannot be negative');
                isValid = false;
            }
        }

        // Validate category
        var categoryId = $('#categoryId').val();
        if (categoryId === '' || categoryId === null) {
            showError('categoryError', 'Please select a category');
            isValid = false;
        }

        // Validate image if provided
        var imageFile = $('#imageFile')[0].files[0];
        var imageUrl = $('#imageUrl').val().trim();

        if (imageFile) {
            if (!imageFile.type || !imageFile.type.startsWith('image/')) {
                showError('imageError', 'Please choose a valid image file');
                isValid = false;
            } else if (imageFile.size > MAX_IMAGE_SIZE) {
                showError('imageError', 'Image must be smaller than 5 MB');
                isValid = false;
            }
        } else if (imageUrl !== '') {
            try {
                var parsedUrl = new URL(imageUrl);
                var extension = parsedUrl.pathname.split('.').pop().toLowerCase();
                var supported = ['png', 'jpg', 'jpeg', 'gif', 'webp', 'svg'];
                if (!supported.includes(extension)) {
                    showError('imageError', 'Image URL must end with PNG, JPG, JPEG, GIF, SVG, or WEBP');
                    isValid = false;
                }
            } catch (err) {
                showError('imageError', 'Please enter a valid image URL');
                isValid = false;
            }
        }

        if (!isValid) {
            e.preventDefault();
            console.log("Form validation failed");
            return false;
        }

        // Disable submit button to prevent double submission
        var submitBtn = $(this).find('button[type="submit"]');
        submitBtn.prop('disabled', true).html('<i class="fa fa-spinner fa-spin"></i> Saving...');

        // Let form submit normally
        console.log("Form validation passed");
        return true;
    });

    console.log("Validation initialized");
});
