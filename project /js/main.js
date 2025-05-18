// Document Ready Function
document.addEventListener('DOMContentLoaded', function() {
    // Initialize Search Tabs
    initSearchTabs();
    
    // Initialize Mobile Menu
    initMobileMenu();
    
    // Add Animation Classes to Elements
    addAnimations();
    
    // Initialize Date Inputs with Today and Tomorrow
    initDateInputs();
});

/**
 * Search Tabs Functionality
 */
function initSearchTabs() {
    const tabButtons = document.querySelectorAll('.search-tabs li');
    const searchForms = document.querySelectorAll('.search-form');
    
    tabButtons.forEach(button => {
        button.addEventListener('click', () => {
            // Remove active class from all buttons and forms
            tabButtons.forEach(btn => btn.classList.remove('active'));
            searchForms.forEach(form => form.classList.remove('active'));
            
            // Add active class to clicked button
            button.classList.add('active');
            
            // Show the corresponding form
            const formId = button.getAttribute('data-tab') + '-search';
            document.getElementById(formId).classList.add('active');
        });
    });
}

/**
 * Mobile Menu Toggle
 */
function initMobileMenu() {
    const menuToggle = document.querySelector('.mobile-menu-toggle');
    const mainNav = document.querySelector('.main-nav');
    
    if (menuToggle && mainNav) {
        menuToggle.addEventListener('click', () => {
            // Toggle active class on main nav
            mainNav.classList.toggle('active');
            
            // Toggle hamburger to X animation
            const spans = menuToggle.querySelectorAll('span');
            spans.forEach(span => span.classList.toggle('active'));
            
            if (mainNav.classList.contains('active')) {
                spans[0].style.transform = 'rotate(45deg) translate(5px, 5px)';
                spans[1].style.opacity = '0';
                spans[2].style.transform = 'rotate(-45deg) translate(7px, -6px)';
            } else {
                spans[0].style.transform = 'none';
                spans[1].style.opacity = '1';
                spans[2].style.transform = 'none';
            }
        });
        
        // Close menu when clicking outside
        document.addEventListener('click', (event) => {
            if (!event.target.closest('.main-nav') && 
                !event.target.closest('.mobile-menu-toggle') && 
                mainNav.classList.contains('active')) {
                mainNav.classList.remove('active');
                
                const spans = menuToggle.querySelectorAll('span');
                spans.forEach(span => span.classList.remove('active'));
                spans[0].style.transform = 'none';
                spans[1].style.opacity = '1';
                spans[2].style.transform = 'none';
            }
        });
    }
}

/**
 * Add Animation Classes to Elements on Scroll
 */
function addAnimations() {
    // Elements to animate
    const elementsToAnimate = [
        { selector: '.destination-card', animation: 'animate-fade-in', delay: 100 },
        { selector: '.hotel-card', animation: 'animate-fade-in', delay: 100 },
        { selector: '.service-card', animation: 'animate-slide-in-right', delay: 100 },
        { selector: '.testimonial', animation: 'animate-slide-in-left', delay: 100 },
        { selector: '.cta-content', animation: 'animate-fade-in', delay: 0 },
        { selector: '.section-header', animation: 'animate-fade-in', delay: 0 }
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
 * Initialize Date Inputs with Today and Tomorrow
 */
function initDateInputs() {
    // Get all date inputs
    const dateInputs = document.querySelectorAll('input[type="date"]');
    
    if (dateInputs.length > 0) {
        // Get today and tomorrow dates
        const today = new Date();
        const tomorrow = new Date(today);
        tomorrow.setDate(tomorrow.getDate() + 1);
        
        // Format dates to YYYY-MM-DD for input
        const formatDate = (date) => {
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const day = String(date.getDate()).padStart(2, '0');
            return `${year}-${month}-${day}`;
        };
        
        const todayFormatted = formatDate(today);
        const tomorrowFormatted = formatDate(tomorrow);
        
        // Set min attribute to today for all date inputs
        dateInputs.forEach(input => {
            input.setAttribute('min', todayFormatted);
            
            // Set default values based on input id
            if (input.id.includes('check-in') || input.id.includes('departure-date') || input.id.includes('train-date')) {
                input.value = todayFormatted;
            } else if (input.id.includes('check-out') || input.id.includes('return-date')) {
                input.value = tomorrowFormatted;
            }
        });
        
        // Ensure check-out is always after check-in
        const checkInInput = document.getElementById('check-in');
        const checkOutInput = document.getElementById('check-out');
        
        if (checkInInput && checkOutInput) {
            checkInInput.addEventListener('change', () => {
                const newMinCheckout = checkInInput.value;
                checkOutInput.setAttribute('min', newMinCheckout);
                
                // If current checkout date is before new check-in, update it
                if (checkOutInput.value < newMinCheckout) {
                    const nextDay = new Date(newMinCheckout);
                    nextDay.setDate(nextDay.getDate() + 1);
                    checkOutInput.value = formatDate(nextDay);
                }
            });
        }
        
        // Same for flight dates
        const departureInput = document.getElementById('departure-date');
        const returnInput = document.getElementById('return-date');
        
        if (departureInput && returnInput) {
            departureInput.addEventListener('change', () => {
                const newMinReturn = departureInput.value;
                returnInput.setAttribute('min', newMinReturn);
                
                if (returnInput.value < newMinReturn) {
                    const nextDay = new Date(newMinReturn);
                    nextDay.setDate(nextDay.getDate() + 1);
                    returnInput.value = formatDate(nextDay);
                }
            });
        }
    }
}

/**
 * Form Validation Functions
 */
function validateForm(formId) {
    const form = document.getElementById(formId);
    
    if (form) {
        form.addEventListener('submit', function(event) {
            let isValid = true;
            const requiredInputs = form.querySelectorAll('[required]');
            
            requiredInputs.forEach(input => {
                if (!input.value.trim()) {
                    isValid = false;
                    showError(input, 'هذا الحقل مطلوب');
                } else {
                    removeError(input);
                }
            });
            
            // Email validation
            const emailInput = form.querySelector('input[type="email"]');
            if (emailInput && emailInput.value.trim()) {
                const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailPattern.test(emailInput.value)) {
                    isValid = false;
                    showError(emailInput, 'يرجى إدخال بريد إلكتروني صحيح');
                }
            }
            
            if (!isValid) {
                event.preventDefault();
            }
        });
    }
}

function showError(input, message) {
    // Remove any existing error
    removeError(input);
    
    // Add error class to input
    input.classList.add('error');
    
    // Create error message element
    const errorMsg = document.createElement('div');
    errorMsg.className = 'error-message';
    errorMsg.textContent = message;
    
    // Insert error message after input
    input.parentNode.insertBefore(errorMsg, input.nextSibling);
}

function removeError(input) {
    input.classList.remove('error');
    const errorMsg = input.parentNode.querySelector('.error-message');
    if (errorMsg) {
        errorMsg.remove();
    }
}

/**
 * Newsletter Subscription
 */
document.addEventListener('DOMContentLoaded', function() {
    const newsletterForm = document.querySelector('.newsletter-form');
    
    if (newsletterForm) {
        newsletterForm.addEventListener('submit', function(event) {
            event.preventDefault();
            
            const emailInput = newsletterForm.querySelector('input[type="email"]');
            const email = emailInput.value.trim();
            
            if (email) {
                // Show success message
                const successMsg = document.createElement('div');
                successMsg.className = 'success-message';
                successMsg.textContent = 'شكرًا لاشتراكك في النشرة الإخبارية!';
                
                // Replace form with success message
                newsletterForm.innerHTML = '';
                newsletterForm.appendChild(successMsg);
                
                // In a real application, you would send this data to the server
                console.log('Newsletter subscription:', email);
            }
        });
    }
});