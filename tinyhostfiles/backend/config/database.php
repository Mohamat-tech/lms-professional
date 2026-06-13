<?php
/**
 * ============================================
 * DATABASE CONFIGURATION
 * LMS Sophisti qué
 * ============================================
 */

// Database Settings
define('DB_HOST', 'localhost');
define('DB_USER', 'root');
define('DB_PASS', '');
define('DB_NAME', 'lms_professional');

// API Settings
define('API_URL', 'http://localhost/backend/api');
define('FRONTEND_URL', 'http://localhost/frontend');

// App Settings
define('APP_NAME', 'LMS Professionnel');
define('APP_VERSION', '1.0.0');
define('DEVELOPER', 'NDAOBA MOHAMAT 24G2687');

// Security
define('JWT_SECRET', 'your-secret-key-change-in-production-' . md5(APP_NAME));
define('JWT_EXPIRATION', 86400 * 7); // 7 days
define('TOKEN_EXPIRATION', time() + JWT_EXPIRATION);

// File Upload Settings
define('MAX_FILE_SIZE', 50 * 1024 * 1024); // 50 MB
define('UPLOAD_DIR', __DIR__ . '/../uploads/');
define('ALLOWED_EXTENSIONS', ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'jpg', 'jpeg', 'png', 'gif', 'mp4', 'avi', 'mov']);

// Email Settings
define('MAIL_FROM', 'noreply@lms.local');
define('MAIL_FROM_NAME', APP_NAME);

// Mode
define('DEBUG_MODE', true);

// Ensure upload directory exists
if (!file_exists(UPLOAD_DIR)) {
    mkdir(UPLOAD_DIR, 0755, true);
}

// Database Connection Function
function getDBConnection() {
    try {
        $conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
        
        if ($conn->connect_error) {
            throw new Exception('Database Connection Error: ' . $conn->connect_error);
        }
        
        $conn->set_charset('utf8mb4');
        return $conn;
    } catch (Exception $e) {
        if (DEBUG_MODE) {
            echo json_encode(['success' => false, 'message' => $e->getMessage()]);
        } else {
            echo json_encode(['success' => false, 'message' => 'Database error']);
        }
        exit;
    }
}
?>
