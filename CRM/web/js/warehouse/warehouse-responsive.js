// Mobile menu toggle function
function toggleMobileMenu() {
    const sidebar = document.querySelector('.left-side');
    sidebar.classList.toggle('show');
}

// Close mobile menu when clicking outside
document.addEventListener('click', function(event) {
    const sidebar = document.querySelector('.left-side');
    const toggleButton = document.querySelector('.mobile-menu-toggle');
    
    if (window.innerWidth <= 768 && 
        !sidebar.contains(event.target) && 
        !toggleButton.contains(event.target)) {
        sidebar.classList.remove('show');
    }
});

// Handle window resize
window.addEventListener('resize', function() {
    const sidebar = document.querySelector('.left-side');
    if (window.innerWidth > 768) {
        sidebar.classList.remove('show');
    }
});

// Improve table responsiveness
function adjustTableForMobile() {
    if (window.innerWidth <= 768) {
        const table = document.querySelector('.inventory-table');
        if (table) {
            table.style.fontSize = '12px';
        }
    }
}

// Call on page load and resize
document.addEventListener('DOMContentLoaded', adjustTableForMobile);
window.addEventListener('resize', adjustTableForMobile);
