<?php
header("Content-Type: text/plain");

// Listahan ng mga valid license key
$valid_keys = [
    "KAZE-VIP-12345" => "ACTIVE"
];

// Kukunin ang key na ipinasa mula sa Http.post ng app
$user_key = $_POST['key'] ?? '';

// Verifier logic
if (isset($valid_keys[$user_key])) {
    
    $file = 'log1.lua';
    
    if (file_exists($file)) {
        // Ipapadala ang laman ng log1.lua pabalik sa client
        echo file_get_contents($file);
    } else {
        http_response_code(404);
        echo "Error: File log1.lua not found on server.";
    }
    
    exit();
} else {
    // Kapag mali o wala ang key
    http_response_code(403);
    echo "ACCESS DENIED";
    exit();
}
?>
