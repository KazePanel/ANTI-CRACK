<?php
// ==========================================
// KAZE SERVER-SIDE VERIFICATION & PAYLOAD
// ==========================================

header("Content-Type: text/plain");

$valid_keys = [
    "KAZE-VIP-12345" => "ACTIVE",
    "KAZE-PRO-99999" => "ACTIVE"
];

$user_key = $_POST['key'] ?? '';
$user_hwid = $_POST['hwid'] ?? '';

// Check kung valid ang Key
if (isset($valid_keys[$user_key]) && $valid_keys[$user_key] === "ACTIVE") {
    
    // ITO ANG TOTOONG SCRIPT MO (Walang makakakita nito mula sa APK!)
    $lua_payload = <<<LUA
        print("Welcome to KAZE VIP System!")
        
        -- Dito mo ilalagay ang lahat ng UI, Injector Logic, or Features mo
        layout = {
            LinearLayout,
            layout_width="fill",
            layout_height="fill",
            orientation="vertical",
            {
                TextView,
                text="KAZE VIP SYSTEM LOADED SUCCESSFULLY!",
                textColor="0xFF00FFCC",
                textSize="18sp",
                layout_gravity="center"
            }
        }
        activity.setContentView(loadlayout(layout))
LUA;

    // Ipadala ang script pabalik sa AndLua+ app
    echo $lua_payload;
    exit();

} else {
    http_response_code(403);
    echo "Unauthorized Access!";
    exit();
}
?>
