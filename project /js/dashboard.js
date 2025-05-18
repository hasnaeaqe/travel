/**
 * Dashboard JavaScript
 */
document.addEventListener('DOMContentLoaded', function() {
    // Initialize Mobile Sidebar Toggle
    initSidebarToggle();
    
    // Initialize Dropdown Menus
    initDropdowns();
    
    // Add Animation to Cards
    addCardAnimations();
});

/**
 * Mobile Sidebar Toggle
 */
function initSidebarToggle() {
    const sidebarToggle = document.getElementById('sidebar-toggle');
    const sidebarClose = document.getElementById('sidebar-close');
    const sidebar = document.querySelector('.dashboard-sidebar');
    
    if (sidebarToggle && sidebar) {
        sidebarToggle.addEventListener('click', function() {
            sidebar.classList.add('active');
        });
    }
    
    if (sidebarClose && sidebar) {
        sidebarClose.addEventListener('click', function() {
            sidebar.classList.remove('active');
        });
    }
    
    // Close sidebar when clicking outside
    document.addEventListener('click', function(event) {
        if (sidebar && 
            sidebar.classList.contains('active') && 
            !event.target.closest('.dashboard-sidebar') && 
            !event.target.closest('#sidebar-toggle')) {
            sidebar.classList.remove('active');
        }
    });
}

/**
 * Dropdown Menus
 */
function initDropdowns() {
    const dropdownButtons = document.querySelectorAll('.notification-btn');
    
    dropdownButtons.forEach(button => {
        const dropdown = button.nextElementSibling;
        
        if (!dropdown) return;
        
        // Show dropdown on click
        button.addEventListener('click', function(event) {
            event.stopPropagation();
            
            // Close all other dropdowns
            document.querySelectorAll('.dropdown-menu').forEach(menu => {
                if (menu !== dropdown && menu.classList.contains('show')) {
                    menu.classList.remove('show');
                }
            });
            
            // Toggle current dropdown
            dropdown.classList.toggle('show');
        });
        
        // Prevent dropdown from closing when clicking inside it
        dropdown.addEventListener('click', function(event) {
            event.stopPropagation();
        });
    });
    
    // Close dropdowns when clicking elsewhere on the page
    document.addEventListener('click', function() {
        document.querySelectorAll('.dropdown-menu').forEach(menu => {
            if (menu.classList.contains('show')) {
                menu.classList.remove('show');
            }
        });
    });
}

/**
 * Add Animations to Cards
 */
function addCardAnimations() {
    // Elements to animate
    const elementsToAnimate = [
        { selector: '.card', animation: 'animate-fade-in', delay: 100 },
        { selector: '.booking-card', animation: 'animate-slide-in-right', delay: 100 },
        { selector: '.offer-card', animation: 'animate-fade-in', delay: 100 },
        { selector: '.destination-card', animation: 'animate-slide-in-left', delay: 100 },
        { selector: '.activity-item', animation: 'animate-fade-in', delay: 50 }
    ];
    
    // Create intersection observer
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                // Calculate delay based on index of the element among its siblings
                const index = Array.from(entry.target.parentNode.children).indexOf(entry.target);
                const delay = index * (entry.target.dataset.delay || 0);
                
                // Apply animation with delay
                setTimeout(() => {
                    entry.target.classList.add(entry.target.dataset.animation);
                }, delay);
                
                // Unobserve after animating
                observer.unobserve(entry.target);
            }
        });
    }, {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    });
    
    // Observe elements
    elementsToAnimate.forEach(item => {
        document.querySelectorAll(item.selector).forEach((element, index) => {
            element.dataset.animation = item.animation;
            element.dataset.delay = item.delay;
            element.style.opacity = '0';
            observer.observe(element);
        });
    });
}

/**
 * Notification Badge Update
 */
function updateNotificationBadge(count) {
    const badge = document.querySelector('.notification-btn .badge');
    
    if (badge) {
        if (count > 0) {
            badge.textContent = count > 9 ? '9+' : count;
            badge.style.display = 'flex';
        } else {
            badge.style.display = 'none';
        }
    }
}

/**
 * Mark Notification as Read
 */
function markNotificationAsRead(notificationId) {
    // In a real application, this would make an AJAX call to the server
    console.log(`Marking notification ${notificationId} as read`);
    
    // For demo purposes, let's just remove the unread class
    const notification = document.querySelector(`.notification-item[data-id="${notificationId}"]`);
    
    if (notification) {
        notification.classList.remove('unread');
        
        // Update the badge count
        const unreadCount = document.querySelectorAll('.notification-item.unread').length;
        updateNotificationBadge(unreadCount);
    }
}

/**
 * Chart Initialization
 * Note: This function would use a charting library like Chart.js in a real application
 */
function initCharts() {
    console.log('Charts would be initialized here in a real application');
    
    // Example of what this might look like with Chart.js
    /*
    const bookingsCtx = document.getElementById('bookingsChart').getContext('2d');
    const bookingsChart = new Chart(bookingsCtx, {
        type: 'line',
        data: {
            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
            datasets: [{
                label: 'Bookings',
                data: [12, 19, 3, 5, 2, 3],
                borderColor: '#1D3557',
                backgroundColor: 'rgba(69, 123, 157, 0.1)',
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false
        }
    });
    */
}