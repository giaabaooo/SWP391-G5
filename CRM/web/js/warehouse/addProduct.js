/**
 * Add Product Page - JavaScript
 * Handles form validation, dropdown scrolling, and form submission
 */

// Prevent browser from restoring scroll position on reload
if ('scrollRestoration' in history) {
    history.scrollRestoration = 'manual';
}

// Scroll to top immediately before DOM ready
window.scrollTo(0, 0);
document.documentElement.scrollTop = 0;
document.body.scrollTop = 0;

$(function() {
    // Force scroll to top again when DOM is ready
    window.scrollTo(0, 0);
    $('html, body').scrollTop(0);
    
    const MAX_IMAGE_SIZE = 5 * 1024 * 1024; // 5 MB
    const imagePreview = $('#imagePreview');
    const imagePreviewWrapper = $('#imagePreviewWrapper');
    const imagePreviewPlaceholder = $('#imagePreviewPlaceholder');
    const imageFileInput = $('#imageFile');
    const imageUrlInput = $('#imageUrl');
    const resetImageBtn = $('#resetImage');
    let imageObjectURL = null;

    // Hide all validation errors on page load and set normal border
    $('.validation-error').removeClass('show');
    $('.form-control').removeClass('error');
    
    // Real-time validation functions
    function validateProductName() {
        var name = $('#productName').val().trim();
        
        if (name.length === 0) {
            showError('nameError', 'Product name is required');
            return false;
        } else if (name.length < 2) {
            showError('nameError', 'Product name must be at least 2 characters');
            return false;
        } else {
            hideError('nameError');
            return true;
        }
    }

    function validatePurchasePrice() {
        var price = parseFloat($('#purchasePrice').val());
        
        if (isNaN(price)) {
            showError('purchasePriceError', 'Purchase price is required');
            return false;
        } else if (price < 0) {
            showError('purchasePriceError', 'Purchase price cannot be negative');
            return false;
        } else {
            hideError('purchasePriceError');
            return true;
        }
    }

    function validateSellingPrice() {
        var price = $('#sellingPrice').val();
        
        if (price === '') {
            hideError('sellingPriceError');
            return true;
        }
        
        var numPrice = parseFloat(price);
        
        if (isNaN(numPrice)) {
            showError('sellingPriceError', 'Selling price must be a valid number');
            return false;
        } else if (numPrice < 0) {
            showError('sellingPriceError', 'Selling price cannot be negative');
            return false;
        } else {
            hideError('sellingPriceError');
            return true;
        }
    }

    function validateCategory() {
        var category = $('#categoryId').val();
        
        if (category === '' || category === null) {
            showError('categoryError', 'Please select a category');
            return false;
        } else {
            hideError('categoryError');
            return true;
        }
    }

    function showError(errorId, message) {
        // Show error message
        $('#' + errorId)
            .text(message)
            .addClass('show')
            .css({
                'color': '#dc3545',
                'font-style': 'italic',
                'font-size': '0.75rem',
                'font-weight': '500'
            });
        
        // Add error class to corresponding input field
        var inputId = errorId.replace('Error', '');
        if (inputId === 'name') {
            $('#productName').addClass('error');
        } else if (inputId === 'purchasePrice') {
            $('#purchasePrice').addClass('error');
        } else if (inputId === 'sellingPrice') {
            $('#sellingPrice').addClass('error');
        } else if (inputId === 'category') {
            $('#categoryId').addClass('error');
        } else if (inputId === 'image') {
            imagePreviewWrapper.addClass('error');
        }
    }

    function hideError(errorId) {
        // Hide error message
        $('#' + errorId).removeClass('show');
        
        // Remove error class from corresponding input field
        var inputId = errorId.replace('Error', '');
        if (inputId === 'name') {
            $('#productName').removeClass('error');
        } else if (inputId === 'purchasePrice') {
            $('#purchasePrice').removeClass('error');
        } else if (inputId === 'sellingPrice') {
            $('#sellingPrice').removeClass('error');
        } else if (inputId === 'category') {
            $('#categoryId').removeClass('error');
        }
        if (inputId === 'image') {
            imagePreviewWrapper.removeClass('error');
        }
    }

    function setImagePreview(src) {
        imagePreview.attr('src', src).show();
        imagePreviewPlaceholder.hide();
        imagePreviewWrapper.addClass('has-image').removeClass('error');
        resetImageBtn.show();
    }

    function clearImagePreview() {
        if (imageObjectURL) {
            URL.revokeObjectURL(imageObjectURL);
            imageObjectURL = null;
        }
        imagePreview.attr('src', '#').hide();
        imagePreviewPlaceholder.show();
        imagePreviewWrapper.removeClass('has-image error');
        resetImageBtn.hide();
    }

    function validateImage() {
        var file = imageFileInput.length ? imageFileInput[0].files[0] : null;
        var urlValue = imageUrlInput.val() ? imageUrlInput.val().trim() : '';

        if (!file && urlValue === '') {
            hideError('imageError');
            return true;
        }

        if (file) {
            if (!file.type || !file.type.startsWith('image/')) {
                showError('imageError', 'Please choose a valid image file');
                return false;
            }
            if (file.size > MAX_IMAGE_SIZE) {
                showError('imageError', 'Image must be smaller than 5 MB');
                return false;
            }
        }

        if (urlValue !== '') {
            try {
                var parsedUrl = new URL(urlValue);
                var extension = parsedUrl.pathname.split('.').pop().toLowerCase();
                var supported = ['png', 'jpg', 'jpeg', 'gif', 'webp', 'svg'];
                if (!supported.includes(extension)) {
                    showError('imageError', 'Image URL must end with PNG, JPG, JPEG, GIF, SVG, or WEBP');
                    return false;
                }
            } catch (e) {
                showError('imageError', 'Please enter a valid image URL');
                return false;
            }
        }

        hideError('imageError');
        return true;
    }

    function validateAll() {
        var isValid = true;

        if (!validateProductName()) isValid = false;
        if (!validatePurchasePrice()) isValid = false;
        if (!validateSellingPrice()) isValid = false;
        if (!validateCategory()) isValid = false;
        if (!validateImage()) isValid = false;

        return isValid;
    }

    function clearForm() {
        $('form')[0].reset();
        $('.validation-error').removeClass('show');
        $('.form-control').removeClass('error');
        $('.success-message').fadeOut();
        clearImagePreview();
    }

    function clearValidationErrors() {
        $('.validation-error').removeClass('show');
        $('.form-control').removeClass('error');
        imagePreviewWrapper.removeClass('error');
    }

    // Real-time border validation (without error messages)
    $('#productName').on('input', function() {
        var name = $(this).val().trim();
        if (name.length >= 2) {
            $(this).removeClass('error');
            $('#nameError').removeClass('show');
        }
    });

    $('#purchasePrice').on('input', function() {
        var price = parseFloat($(this).val());
        if (!isNaN(price) && price >= 0) {
            $(this).removeClass('error');
            $('#purchasePriceError').removeClass('show');
        }
    });

    $('#sellingPrice').on('input', function() {
        var price = $(this).val();
        if (price === '' || (!isNaN(parseFloat(price)) && parseFloat(price) >= 0)) {
            $(this).removeClass('error');
            $('#sellingPriceError').removeClass('show');
        }
    });

    $('#categoryId').on('change', function() {
        var category = $(this).val();
        if (category !== '' && category !== null) {
            $(this).removeClass('error');
            $('#categoryError').removeClass('show');
        }
    });

    imageFileInput.on('change', function() {
        hideError('imageError');
        var file = this.files && this.files[0] ? this.files[0] : null;

        if (!file) {
            if (imageUrlInput.val().trim() === '') {
                clearImagePreview();
            }
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

        if (imageObjectURL) {
            URL.revokeObjectURL(imageObjectURL);
            imageObjectURL = null;
        }

        imageObjectURL = URL.createObjectURL(file);
        setImagePreview(imageObjectURL);
        imageUrlInput.val('');
    });

    imageUrlInput.on('input', function() {
        hideError('imageError');
        var urlValue = $(this).val().trim();

        if (urlValue === '') {
            if (!imageFileInput[0].files.length) {
                clearImagePreview();
            }
            return;
        }

        if (imageObjectURL) {
            URL.revokeObjectURL(imageObjectURL);
            imageObjectURL = null;
        }

        imageFileInput.val('');
        setImagePreview(urlValue);
    });

    imageUrlInput.on('blur', function() {
        validateImage();
    });

    imagePreview.on('error', function() {
        if (imageUrlInput.val().trim() !== '') {
            showError('imageError', 'Unable to load image from the provided URL');
            imageUrlInput.val('');
        }
        clearImagePreview();
    });

    resetImageBtn.on('click', function() {
        imageFileInput.val('');
        imageUrlInput.val('');
        clearImagePreview();
        hideError('imageError');
    });

    clearImagePreview();

    // Form submission
    $('form').on('submit', function(e) {
        // Clear previous validation states
        clearValidationErrors();
        
        // Run validation
        if (!validateAll()) {
            e.preventDefault();
            
            // Scroll to first error
            var firstError = $('.validation-error.show').first();
            if (firstError.length) {
                $('html, body').animate({
                    scrollTop: firstError.closest('.form-group').offset().top - 100
                }, 500);
            }
            return false;
        }

        // Show loading state
        var submitBtn = $(this).find('button[type="submit"]');
        submitBtn.prop('disabled', true).html('<i class="fa fa-spinner fa-spin"></i> Saving...');

        // Re-enable button after 5 seconds in case of server issues
        setTimeout(function() {
            submitBtn.prop('disabled', false).html('<i class="fa fa-save"></i> Save Product');
        }, 5000);
    });

    // Clear form automatically after 3 seconds on successful submission
    if ($('.success-message').length > 0) {
        setTimeout(clearForm, 3000);
    }

    // Handle collapsible menu
    $('.treeview > a').click(function(e) {
        e.preventDefault();
        var target = $(this).attr('href');
        $(target).collapse('toggle');
    });

    // Auto-expand inventory menu since we're on add product page
    $('#inventoryMenu').addClass('in');
    $('.treeview').first().addClass('active');

    // Add scroll to dropdowns (Category and Brand) - show max 5 items
    function initializeScrollableDropdowns() {
        const categorySelect = $('#categoryId');
        const brandSelect = $('select[name="brand_id"]');
        
        // Create custom dropdown wrappers
        [categorySelect, brandSelect].forEach(function(selectElement) {
            if (selectElement.length === 0) return;
            
            const options = selectElement.find('option');
            if (options.length > 6) { // 1 placeholder + 5 items
                // Add custom class for styling
                selectElement.addClass('scrollable-dropdown');
                
                // Handle click to show dropdown
                selectElement.on('mousedown', function(e) {
                    const self = $(this);
                    if (!self.hasClass('expanded')) {
                        self.attr('size', Math.min(6, options.length)); // Show max 6 (including placeholder)
                        self.addClass('expanded');
                        e.preventDefault();
                        setTimeout(function() {
                            self.focus();
                        }, 0);
                    }
                });
                
                // Handle selection
                selectElement.on('change blur', function() {
                    const self = $(this);
                    if (self.hasClass('expanded')) {
                        self.removeAttr('size');
                        self.removeClass('expanded');
                    }
                });
                
                // Close on outside click
                $(document).on('click', function(e) {
                    if (!$(e.target).closest('.scrollable-dropdown').length) {
                        $('.scrollable-dropdown.expanded').each(function() {
                            $(this).removeAttr('size').removeClass('expanded');
                        });
                    }
                });
            }
        });
    }
    
    // Initialize scrollable dropdowns
    initializeScrollableDropdowns();
});

