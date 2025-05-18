<?php
session_start();

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $language = isset($_POST['language']) ? $_POST['language'] : 'ar';
    
    // Validate language
    $validLanguages = ['ar', 'fr', 'en'];
    if (!in_array($language, $validLanguages)) {
        $language = 'ar';
    }
    
    // Store language preference in session
    $_SESSION['language'] = $language;
    
    // Set cookie for persistent language preference
    setcookie('preferred_language', $language, time() + (86400 * 30), "/"); // 30 days
    
    echo json_encode(['status' => 'success', 'language' => $language]);
} else {
    // Return current language preference
    $language = $_SESSION['language'] ?? ($_COOKIE['preferred_language'] ?? 'ar');
    echo json_encode(['status' => 'success', 'language' => $language]);
}