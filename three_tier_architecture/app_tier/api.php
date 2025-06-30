<?php
// Application Tier - Business Logic Layer
header('Content-Type: application/json');

// Database configuration
$db_host = getenv('DB_HOST') ?: 'localhost';
$db_name = getenv('DB_NAME') ?: 'lamp_app';
$db_user = getenv('DB_USER') ?: 'app_user';
$db_pass = getenv('DB_PASSWORD') ?: 'secure_password';

function connectDatabase() {
    global $db_host, $db_name, $db_user, $db_pass;
    try {
        $pdo = new PDO("mysql:host=$db_host;dbname=$db_name", $db_user, $db_pass);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        return $pdo;
    } catch(PDOException $e) {
        return null;
    }
}

function handleVisits() {
    $pdo = connectDatabase();
    if (!$pdo) {
        return ['status' => 'error', 'message' => 'Database connection failed'];
    }
    
    try {
        // Record visit
        $pdo->exec("INSERT INTO visitors (visit_time) VALUES (NOW())");
        
        // Get visit count
        $stmt = $pdo->query("SELECT COUNT(*) as count FROM visitors");
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        
        return [
            'status' => 'success',
            'visit_count' => $result['count'],
            'timestamp' => date('Y-m-d H:i:s')
        ];
    } catch(PDOException $e) {
        return ['status' => 'error', 'message' => $e->getMessage()];
    }
}

// Route handling
$request_uri = $_SERVER['REQUEST_URI'];
$path = parse_url($request_uri, PHP_URL_PATH);

switch ($path) {
    case '/api/visits':
        echo json_encode(handleVisits());
        break;
    case '/api/health':
        $pdo = connectDatabase();
        echo json_encode([
            'status' => $pdo ? 'healthy' : 'unhealthy',
            'timestamp' => date('Y-m-d H:i:s')
        ]);
        break;
    default:
        http_response_code(404);
        echo json_encode(['status' => 'error', 'message' => 'Endpoint not found']);
}
?>