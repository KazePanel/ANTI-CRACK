<?php
header("Content-Type: text/plain");

$valid_keys = [
    "KAZE-VIP-12345" => "ACTIVE"
];

$user_key = $_POST['key'] ?? '';

// Check kung valid ang key
if (isset($valid_keys[$user_key])) {
    
    // Hanapin ang login.lua sa loob ng folder
    $file = 'login.lua';
    
    if (file_exists($file)) {
        // I-echo ang laman ng file pabalik sa app
        echo file_get_contents($file);
    } else {
        echo "Error: File login.lua not found on server.";
    }
    
    exit();
} else {
    http_response_code(403);
    echo "ACCESS DENIED";
    exit();
}
?>
