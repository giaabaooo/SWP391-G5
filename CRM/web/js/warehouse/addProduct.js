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
    const imagePreview = $('#imagePreview');
    const imagePreviewWrapper = $('#imagePreviewWrapper');
    const imagePreviewPlaceholder = $('#imagePreviewPlaceholder');
    const imageFileInput = $('#imageFile');
    const imageUrlInput = $('#imageUrl');
    const resetImageBtn = $('#resetImage');
    let imageObjectURL = null;

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

    // Image preview functions
    function setImagePreview(src) {
        if (!src) {
            clearImagePreview();
            return;
        }
        imagePreview.attr('src', src).show();
        imagePreviewPlaceholder.hide();
        imagePreviewWrapper.addClass('has-image');
        resetImageBtn.show();
        hideError('imageError');
    }

    function clearImagePreview() {
        if (imageObjectURL) {
            URL.revokeObjectURL(imageObjectURL);
            imageObjectURL = null;
        }
        imagePreview.attr('src', 'data:image/gif;base64,R0lGODlhAQABAAD/ACwAAAAAAQABAAACADs=').hide();
        imagePreviewWrapper.removeClass('has-image');
        imagePreviewPlaceholder.show();
        resetImageBtn.hide();
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

    // Image file handling with preview
    imageFileInput.on('change', function() {
        hideError('imageError');
        var file = this.files && this.files[0] ? this.files[0] : null;

        if (!file) {
            clearImagePreview();
            return;
        }

        if (!file.type || !file.type.startsWith('image/')) {
            showError('imageError', 'Please choose a valid image file');
            this.value = '';
            clearImagePreview();
            return;
        }

        if (file.size > MAX_IMAGE_SIZE) {
            showError('imageError', 'Image must be smaller than 5 MB');
            this.value = '';
            clearImagePreview();
            return;
        }

        // Create preview
        if (imageObjectURL) {
            URL.revokeObjectURL(imageObjectURL);
            imageObjectURL = null;
        }
        imageObjectURL = URL.createObjectURL(file);
        setImagePreview(imageObjectURL);

        // Clear imageUrl when file is selected
        imageUrlInput.val('');
    });

    // Image URL handling with preview
    imageUrlInput.on('input', function() {
        hideError('imageError');
        var urlValue = $(this).val().trim();

        if (urlValue === '') {
            if (!imageFileInput[0].files.length) {
                clearImagePreview();
            }
            return;
        }

        // Clear file input and set preview
        if (imageObjectURL) {
            URL.revokeObjectURL(imageObjectURL);
            imageObjectURL = null;
        }
        imageFileInput.val('');
        setImagePreview(urlValue);
    });

    // Handle image load errors
    imagePreview.on('error', function() {
        var currentSrc = imagePreview.attr('src');
        if (imageUrlInput.val().trim() !== '') {
            showError('imageError', 'Unable to load image from the provided URL');
            imageUrlInput.val('');
            clearImagePreview();
        } else if (imageObjectURL && currentSrc === imageObjectURL) {
            showError('imageError', 'Unable to preview the selected image file');
            imageFileInput.val('');
            clearImagePreview();
        }
    });

    // Reset image button
    resetImageBtn.on('click', function() {
        imageFileInput.val('');
        imageUrlInput.val('');
        clearImagePreview();
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
