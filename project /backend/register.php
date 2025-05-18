<?php
/**
 * User Registration Process
 * 
 * This file handles the registration functionality for the Morocco Travels application.
 */

// Include configuration file
require_once 'config.php';

// Initialize response array
$response = [
    'success' => false,
    'message' => '',
    'redirect' => ''
];

// Check if form is submitted
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    
    // Get and sanitize user input
    $firstname = isset($_POST['firstname']) ? sanitize($_POST['firstname']) : '';
    $lastname = isset($_POST['lastname']) ? sanitize($_POST['lastname']) : '';
    $email = isset($_POST['email']) ? sanitize($_POST['email']) : '';
    $phone = isset($_POST['phone']) ? sanitize($_POST['phone']) : '';
    $password = isset($_POST['password']) ? $_POST['password'] : ''; // Don't sanitize password before hashing
    $confirmPassword = isset($_POST['confirm-password']) ? $_POST['confirm-password'] : '';
    
    // Validate input
    $errors = [];
    
    if (empty($firstname)) {
        $errors[] = 'الاسم الأول مطلوب';
    }
    
    if (empty($lastname)) {
        $errors[] = 'الاسم الأخير مطلوب';
    }
    
    if (empty($email)) {
        $errors[] = 'البريد الإلكتروني مطلوب';
    } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $errors[] = 'يرجى إدخال بريد إلكتروني صالح';
    }
    
    if (empty($phone)) {
        $errors[] = 'رقم الهاتف مطلوب';
    } elseif (!preg_match('/^\+?[0-9]{8,15}$/', $phone)) {
        $errors[] = 'يرجى إدخال رقم هاتف صالح';
    }
    
    if (empty($password)) {
        $errors[] = 'كلمة المرور مطلوبة';
    } elseif (strlen($password) < 8) {
        $errors[] = 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
    }
    
    if ($password !== $confirmPassword) {
        $errors[] = 'كلمات المرور غير متطابقة';
    }
    
    if (!isset($_POST['terms'])) {
        $errors[] = 'يجب الموافقة على الشروط والأحكام';
    }
    
    // Check if email already exists
    $checkEmailQuery = "SELECT id FROM users WHERE email = ?";
    $checkEmailStmt = $conn->prepare($checkEmailQuery);
    $checkEmailStmt->bind_param("s", $email);
    $checkEmailStmt->execute();
    $checkEmailResult = $checkEmailStmt->get_result();
    
    if ($checkEmailResult->num_rows > 0) {
        $errors[] = 'البريد الإلكتروني مسجل بالفعل';
    }
    
    if (empty($errors)) {
        // Hash password
        $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
        
        // Generate activation token
        $activationToken = bin2hex(random_bytes(32));
        $activationExpires = date('Y-m-d H:i:s', strtotime('+24 hours'));
        
        // Insert user into database
        $insertQuery = "INSERT INTO users (first_name, last_name, email, phone, password, activation_token, activation_expires, created_at) 
                       VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";
        $insertStmt = $conn->prepare($insertQuery);
        $insertStmt->bind_param("sssssss", $firstname, $lastname, $email, $phone, $hashedPassword, $activationToken, $activationExpires);
        
        if ($insertStmt->execute()) {
            $userId = $insertStmt->insert_id;
            
            // Send activation email (in real application)
            // sendActivationEmail($email, $firstname, $activationToken);
            
            // Set session for logged in user
            $_SESSION['user_id'] = $userId;
            $_SESSION['user_email'] = $email;
            $_SESSION['user_name'] = $firstname . ' ' . $lastname;
            $_SESSION['user_role'] = 'user'; // Default role
            $_SESSION['logged_in'] = true;
            
            // Set response
            $response['success'] = true;
            $response['message'] = 'تم إنشاء الحساب بنجاح';
            $response['redirect'] = 'user/dashboard.php';
        } else {
            $response['message'] = 'حدث خطأ أثناء إنشاء الحساب. يرجى المحاولة مرة أخرى.';
        }
    } else {
        $response['message'] = implode('<br>', $errors);
    }
    
    // Return JSON response for AJAX requests
    if (isset($_SERVER['HTTP_X_REQUESTED_WITH']) && $_SERVER['HTTP_X_REQUESTED_WITH'] === 'XMLHttpRequest') {
        header('Content-Type: application/json');
        echo json_encode($response);
        exit;
    }
    
    // For normal form submissions
    if ($response['success']) {
        // Set success message in session
        $_SESSION['flash_message'] = [
            'type' => 'success',
            'message' => $response['message']
        ];
        
        // Redirect
        header('Location: ' . $response['redirect']);
        exit;
    } else {
        // Set error message in session
        $_SESSION['flash_message'] = [
            'type' => 'error',
            'message' => $response['message']
        ];
        
        // Redirect back to signup page
        header('Location: ../signup.html');
        exit;
    }
}

// If accessed directly without POST
header('Location: ../signup.html');
exit;