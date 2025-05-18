/**
 * Authentication Pages JavaScript
 */
document.addEventListener('DOMContentLoaded', function() {
    // Password Visibility Toggle
    initPasswordToggle();
    
    // Password Strength Meter
    initPasswordStrengthMeter();
    
    // Form Validation
    initFormValidation();
});

/**
 * Initialize Password Visibility Toggle
 */
function initPasswordToggle() {
    const toggleButtons = document.querySelectorAll('.toggle-password');
    
    toggleButtons.forEach(button => {
        button.addEventListener('click', function() {
            const input = this.previousElementSibling.previousElementSibling;
            const icon = this.querySelector('i');
            
            // Toggle password visibility
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        });
    });
}

/**
 * Initialize Password Strength Meter
 */
function initPasswordStrengthMeter() {
    const passwordInput = document.querySelector('#password');
    const strengthMeter = document.querySelector('.password-strength');
    
    if (passwordInput && strengthMeter) {
        passwordInput.addEventListener('input', function() {
            const password = this.value;
            const strength = calculatePasswordStrength(password);
            updateStrengthMeter(strength);
        });
    }
}

/**
 * Calculate Password Strength
 * @param {string} password - The password to evaluate
 * @returns {number} - Strength score (0-4)
 */
function calculatePasswordStrength(password) {
    let score = 0;
    
    // No password
    if (!password) {
        return 0;
    }
    
    // Length check
    if (password.length >= 8) {
        score += 1;
    }
    if (password.length >= 12) {
        score += 1;
    }
    
    // Complexity checks
    const hasLowercase = /[a-z]/.test(password);
    const hasUppercase = /[A-Z]/.test(password);
    const hasNumbers = /\d/.test(password);
    const hasSpecialChars = /[!@#$%^&*(),.?":{}|<>]/.test(password);
    
    if (hasLowercase && hasUppercase) {
        score += 1;
    }
    if (hasNumbers) {
        score += 0.5;
    }
    if (hasSpecialChars) {
        score += 1.5;
    }
    
    return Math.min(Math.floor(score), 4);
}

/**
 * Update Strength Meter UI
 * @param {number} strength - Strength score (0-4)
 */
function updateStrengthMeter(strength) {
    const strengthBar = document.querySelector('.strength-bar');
    const strengthText = document.querySelector('.strength-text');
    const strengthContainer = document.querySelector('.password-strength');
    
    // Remove all classes
    strengthContainer.classList.remove('strength-weak', 'strength-medium', 'strength-good', 'strength-strong');
    
    // Add appropriate class and text based on strength
    let text = '';
    let className = '';
    
    switch (strength) {
        case 0:
            text = 'غير كافية';
            className = '';
            break;
        case 1:
            text = 'ضعيفة';
            className = 'strength-weak';
            break;
        case 2:
            text = 'متوسطة';
            className = 'strength-medium';
            break;
        case 3:
            text = 'جيدة';
            className = 'strength-good';
            break;
        case 4:
            text = 'قوية';
            className = 'strength-strong';
            break;
    }
    
    strengthText.textContent = `قوة كلمة المرور: ${text}`;
    if (className) {
        strengthContainer.classList.add(className);
    }
}

/**
 * Initialize Form Validation
 */
function initFormValidation() {
    // Login Form Validation
    const loginForm = document.getElementById('login-form');
    if (loginForm) {
        loginForm.addEventListener('submit', function(event) {
            event.preventDefault();
            
            let isValid = true;
            const email = document.getElementById('email');
            const password = document.getElementById('password');
            
            // Validate email
            if (!validateEmail(email.value)) {
                showError(email, 'الرجاء إدخال بريد إلكتروني صالح');
                isValid = false;
            } else {
                removeError(email);
            }
            
            // Validate password
            if (password.value.length < 6) {
                showError(password, 'كلمة المرور يجب أن تكون 6 أحرف على الأقل');
                isValid = false;
            } else {
                removeError(password);
            }
            
            if (isValid) {
                // In a real application, this would submit to the server
                // For now, we'll just redirect to a success page or show a message
                showSuccess(loginForm, 'تم تسجيل الدخول بنجاح!');
                
                // Simulate redirect
                setTimeout(() => {
                    window.location.href = 'dashboard.html';
                }, 1500);
            }
        });
    }
    
    // Signup Form Validation
    const signupForm = document.getElementById('signup-form');
    if (signupForm) {
        signupForm.addEventListener('submit', function(event) {
            event.preventDefault();
            
            let isValid = true;
            const firstname = document.getElementById('firstname');
            const lastname = document.getElementById('lastname');
            const email = document.getElementById('email');
            const phone = document.getElementById('phone');
            const password = document.getElementById('password');
            const confirmPassword = document.getElementById('confirm-password');
            const terms = document.getElementById('terms');
            
            // Validate first name
            if (firstname.value.trim() === '') {
                showError(firstname, 'الرجاء إدخال الاسم الأول');
                isValid = false;
            } else {
                removeError(firstname);
            }
            
            // Validate last name
            if (lastname.value.trim() === '') {
                showError(lastname, 'الرجاء إدخال الاسم الأخير');
                isValid = false;
            } else {
                removeError(lastname);
            }
            
            // Validate email
            if (!validateEmail(email.value)) {
                showError(email, 'الرجاء إدخال بريد إلكتروني صالح');
                isValid = false;
            } else {
                removeError(email);
            }
            
            // Validate phone
            if (!validatePhone(phone.value)) {
                showError(phone, 'الرجاء إدخال رقم هاتف صالح');
                isValid = false;
            } else {
                removeError(phone);
            }
            
            // Validate password
            if (password.value.length < 8) {
                showError(password, 'كلمة المرور يجب أن تكون 8 أحرف على الأقل');
                isValid = false;
            } else {
                removeError(password);
            }
            
            // Validate confirm password
            if (password.value !== confirmPassword.value) {
                showError(confirmPassword, 'كلمات المرور غير متطابقة');
                isValid = false;
            } else {
                removeError(confirmPassword);
            }
            
            // Validate terms
            if (!terms.checked) {
                showError(terms, 'يجب الموافقة على الشروط والأحكام');
                isValid = false;
            } else {
                removeError(terms);
            }
            
            if (isValid) {
                // In a real application, this would submit to the server
                // For now, we'll just redirect to a success page or show a message
                showSuccess(signupForm, 'تم إنشاء الحساب بنجاح!');
                
                // Simulate redirect
                setTimeout(() => {
                    window.location.href = 'dashboard.html';
                }, 1500);
            }
        });
    }
}

/**
 * Validate Email Format
 * @param {string} email - Email to validate
 * @returns {boolean} - True if valid
 */
function validateEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
}

/**
 * Validate Phone Number
 * @param {string} phone - Phone number to validate
 * @returns {boolean} - True if valid
 */
function validatePhone(phone) {
    // Simple regex for international phone numbers
    // For Morocco, you might want a more specific pattern
    const re = /^\+?[0-9]{8,15}$/;
    return re.test(phone);
}

/**
 * Show Error Message
 * @param {HTMLElement} input - Input element
 * @param {string} message - Error message
 */
function showError(input, message) {
    // Remove any existing errors
    removeError(input);
    
    // Add error class
    input.classList.add('input-error');
    
    // Create error message
    const errorDiv = document.createElement('div');
    errorDiv.className = 'error-message';
    errorDiv.textContent = message;
    
    // Insert after input or its parent for checkboxes
    if (input.type === 'checkbox') {
        input.parentElement.appendChild(errorDiv);
    } else {
        input.parentElement.appendChild(errorDiv);
    }
}

/**
 * Remove Error Message
 * @param {HTMLElement} input - Input element
 */
function removeError(input) {
    input.classList.remove('input-error');
    
    // Find and remove error message
    const parent = input.type === 'checkbox' ? input.parentElement : input.parentElement;
    const errorMessage = parent.querySelector('.error-message');
    if (errorMessage) {
        errorMessage.remove();
    }
}

/**
 * Show Success Message
 * @param {HTMLElement} form - Form element
 * @param {string} message - Success message
 */
function showSuccess(form, message) {
    // Create success message
    const successDiv = document.createElement('div');
    successDiv.className = 'success-message';
    successDiv.textContent = message;
    
    // Insert at top of form
    form.prepend(successDiv);
    
    // Scroll to top of form
    successDiv.scrollIntoView({ behavior: 'smooth', block: 'start' });
}