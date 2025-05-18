<?php
/**
 * User Login Process
 * 
 * This file handles the login functionality for the Morocco Travels application.
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
    $email = isset($_POST['email']) ? sanitize($_POST['email']) : '';
    $password = isset($_POST['password']) ? $_POST['password'] : ''; // Don't sanitize password before verification
    $remember = isset($_POST['remember']) ? true : false;
    
    // Validate input
    if (empty($email) || empty($password)) {
        $response['message'] = 'يرجى إدخال البريد الإلكتروني وكلمة المرور';
    } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $response['message'] = 'يرجى إدخال بريد إلكتروني صالح';
    } else {
        // Check if user exists
        $query = "SELECT id, email, password, first_name, last_name, role FROM users WHERE email = ?";
        $stmt = $conn->prepare($query);
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $result = $stmt->get_result();
        
        if ($result->num_rows === 1) {
            $user = $result->fetch_assoc();
            
            // Verify password
            if (password_verify($password, $user['password'])) {
                // Password is correct, set session
                $_SESSION['user_id'] = $user['id'];
                $_SESSION['user_email'] = $user['email'];
                $_SESSION['user_name'] = $user['first_name'] . ' ' . $user['last_name'];
                $_SESSION['user_role'] = $user['role'];
                $_SESSION['logged_in'] = true;
                
                // Set remember-me cookie if requested
                if ($remember) {
                    // Generate a secure token
                    $token = bin2hex(random_bytes(32));
                    $expires = time() + (30 * 24 * 60 * 60); // 30 days
                    
                    // Store token in database
                    $tokenHash = password_hash($token, PASSWORD_DEFAULT);
                    $updateQuery = "UPDATE users SET remember_token = ?, token_expires = ? WHERE id = ?";
                    $updateStmt = $conn->prepare($updateQuery);
                    $updateStmt->bind_param("ssi", $tokenHash, $expires, $user['id']);
                    $updateStmt->execute();
                    
                    // Set cookie
                    setcookie('remember_token', $token, $expires, '/', '', true, true);
                    setcookie('remember_user', $user['id'], $expires, '/', '', true, true);
                }
                
                // Update last login time
                $updateLoginQuery = "UPDATE users SET last_login = NOW() WHERE id = ?";
                $updateLoginStmt = $conn->prepare($updateLoginQuery);
                $updateLoginStmt->bind_param("i", $user['id']);
                $updateLoginStmt->execute();
                
                // Set response
                $response['success'] = true;
                $response['message'] = 'تم تسجيل الدخول بنجاح';
                
                // Redirect based on user role
                if ($user['role'] === 'admin') {
                    $response['redirect'] = 'admin/dashboard.php';
                } else {
                    $response['redirect'] = 'user/dashboard.php';
                }
            } else {
                $response['message'] = 'كلمة المرور غير صحيحة';
            }
        } else {
            $response['message'] = 'البريد الإلكتروني غير مسجل';
        }
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
        
        // Redirect back to login page
        header('Location: ../login.html');
        exit;
    }
}

// If accessed directly without POST
header('Location: ../login.html');
exit;