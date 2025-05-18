<?php
// Include necessary files
require_once 'config.php';
require_once 'functions.php';

// Start session
start_session();

// Check if user is logged in
if (is_logged_in()) {
    // Record logout activity
    $pdo = db_connect();
    $stmt = $pdo->prepare('
        INSERT INTO user_activities (user_id, activity_type, details, created_at)
        VALUES (:user_id, :activity_type, :details, NOW())
    ');
    $stmt->execute([
        'user_id' => $_SESSION['user_id'],
        'activity_type' => 'logout',
        'details' => 'User logged out'
    ]);
    
    // Logout user
    logout_user();
}

// Redirect to home page
redirect('../index.html');