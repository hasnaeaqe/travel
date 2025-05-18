<?php
/**
 * Database Configuration
 * 
 * This file contains the database connection settings for the Morocco Travels application.
 */

// Database credentials
define('DB_HOST', 'localhost');
define('DB_USER', 'morocco_travels_user');
define('DB_PASS', 'your_secure_password');
define('DB_NAME', 'morocco_travels_db');

// Establish database connection
try {
    $conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
    
    // Check connection
    if ($conn->connect_error) {
        throw new Exception("Connection failed: " . $conn->connect_error);
    }
    
    // Set charset to utf8mb4 to support Arabic characters
    $conn->set_charset("utf8mb4");
    
} catch (Exception $e) {
    error_log($e->getMessage());
    exit('خطأ في الاتصال بقاعدة البيانات. يرجى المحاولة لاحقًا.');
}

/**
 * Helper function to sanitize user input
 * 
 * @param string $data - The data to be sanitized
 * @return string - Sanitized data
 */
function sanitize($data) {
    global $conn;
    
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    $data = $conn->real_escape_string($data);
    
    return $data;
}

/**
 * Get settings from database
 * 
 * @return array - Array of application settings
 */
function getSettings() {
    global $conn;
    
    $settings = [];
    
    $query = "SELECT setting_key, setting_value FROM settings";
    $result = $conn->query($query);
    
    if ($result && $result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $settings[$row['setting_key']] = $row['setting_value'];
        }
    }
    
    return $settings;
}

/**
 * Start session if not already started
 */
if (session_status() === PHP_SESSION_NONE) {
    // Set session parameters for better security
    $session_params = [
        'cookie_httponly' => true,     // Prevent JavaScript access to session cookie
        'cookie_secure' => true,       // Only transmit cookie over HTTPS
        'cookie_samesite' => 'Strict', // Prevent CSRF attacks
        'use_strict_mode' => true      // Enforce strict session ID mode
    ];
    
    session_set_cookie_params($session_params);
    session_start();
}

/**
 * Define base URL
 */
$base_url = isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http";
$base_url .= "://" . $_SERVER['HTTP_HOST'];
$base_url .= dirname($_SERVER['PHP_SELF']);

define('BASE_URL', $base_url);