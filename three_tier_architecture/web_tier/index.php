<?php
// Web Tier - Presentation Layer
$app_tier_url = 'http://localhost:8080'; // App tier endpoint

function callAppTier($endpoint) {
    global $app_tier_url;
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $app_tier_url . $endpoint);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_TIMEOUT, 10);
    $response = curl_exec($ch);
    curl_close($ch);
    return json_decode($response, true);
}

$data = callAppTier('/api/visits');
?>
<!DOCTYPE html>
<html>
<head>
    <title>Three-Tier LAMP Application</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 600px; margin: 0 auto; }
        .status { padding: 10px; margin: 10px 0; border-radius: 5px; }
        .success { background-color: #d4edda; color: #155724; }
        .error { background-color: #f8d7da; color: #721c24; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Three-Tier LAMP Stack Application</h1>
        
        <?php if ($data && $data['status'] === 'success'): ?>
            <div class="status success">
                <p>✓ Application is running successfully!</p>
                <p><strong>Total Visits:</strong> <?= $data['visit_count'] ?></p>
                <p><strong>Database Status:</strong> Connected</p>
            </div>
        <?php else: ?>
            <div class="status error">
                <p>✗ Application Error</p>
                <p><?= $data['message'] ?? 'Unable to connect to application tier' ?></p>
            </div>
        <?php endif; ?>
        
        <p><a href="javascript:location.reload()">Refresh Page</a></p>
    </div>
</body>
</html>