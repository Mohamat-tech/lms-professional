<?php
/**
 * ============================================
 * AUTHENTICATION API ENDPOINT
 * Login, Signup, Token Verification
 * ============================================
 */

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../utils/response-formatter.php';
require_once __DIR__ . '/../utils/auth-handler.php';

// Handle OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

$action = $_POST['action'] ?? $_GET['action'] ?? null;

switch ($action) {
    case 'login':
        handleLogin();
        break;
    
    case 'signup':
        handleSignup();
        break;

    case 'verify-token':
        handleTokenVerification();
        break;

    case 'logout':
        handleLogout();
        break;

    default:
        ResponseFormatter::error('Invalid action', 400);
}

/**
 * Login Handler
 */
function handleLogin() {
    $data = json_decode(file_get_contents('php://input'), true);

    if (!isset($data['email']) || !isset($data['password'])) {
        ResponseFormatter::error('Email and password required', 400);
    }

    $email = filter_var($data['email'], FILTER_SANITIZE_EMAIL);
    $password = $data['password'];

    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        ResponseFormatter::error('Invalid email format', 400);
    }

    $conn = getDBConnection();
    $stmt = $conn->prepare('SELECT id, firstName, lastName, email, password, role, status FROM users WHERE email = ?');
    
    if (!$stmt) {
        ResponseFormatter::error('Database error', 500);
    }

    $stmt->bind_param('s', $email);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        ResponseFormatter::error('User not found', 401);
    }

    $user = $result->fetch_assoc();

    if ($user['status'] !== 'active') {
        ResponseFormatter::error('Account is inactive', 403);
    }

    if (!AuthHandler::verifyPassword($password, $user['password'])) {
        ResponseFormatter::error('Invalid password', 401);
    }

    // Generate token
    $token = AuthHandler::generateToken($user['id'], $user['email'], $user['role']);

    // Update last login
    $updateStmt = $conn->prepare('UPDATE users SET lastLogin = NOW() WHERE id = ?');
    $updateStmt->bind_param('i', $user['id']);
    $updateStmt->execute();

    ResponseFormatter::success([
        'token' => $token,
        'user' => [
            'id' => (int)$user['id'],
            'email' => $user['email'],
            'firstName' => $user['firstName'],
            'lastName' => $user['lastName'],
            'role' => $user['role']
        ]
    ], 'Login successful');
}

/**
 * Signup Handler
 */
function handleSignup() {
    $data = json_decode(file_get_contents('php://input'), true);

    // Validation
    $required = ['email', 'password', 'firstName', 'lastName', 'userType'];
    foreach ($required as $field) {
        if (!isset($data[$field]) || empty($data[$field])) {
            ResponseFormatter::error("$field is required", 400);
        }
    }

    $email = filter_var($data['email'], FILTER_SANITIZE_EMAIL);
    $password = $data['password'];
    $firstName = trim($data['firstName']);
    $lastName = trim($data['lastName']);
    $userType = trim($data['userType']);

    // Email validation
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        ResponseFormatter::error('Invalid email format', 400);
    }

    // Password validation
    if (strlen($password) < 8) {
        ResponseFormatter::error('Password must be at least 8 characters', 400);
    }

    // User type validation
    if (!in_array($userType, ['student', 'professor', 'admin'])) {
        ResponseFormatter::error('Invalid user type', 400);
    }

    $conn = getDBConnection();

    // Check if email exists
    $checkStmt = $conn->prepare('SELECT id FROM users WHERE email = ?');
    $checkStmt->bind_param('s', $email);
    $checkStmt->execute();
    
    if ($checkStmt->get_result()->num_rows > 0) {
        ResponseFormatter::error('Email already exists', 409);
    }

    // Hash password
    $hashedPassword = AuthHandler::hashPassword($password);

    // Insert user
    $stmt = $conn->prepare(
        'INSERT INTO users (email, password, firstName, lastName, role, status, createdAt) 
         VALUES (?, ?, ?, ?, ?, "active", NOW())'
    );

    $stmt->bind_param('sssss', $email, $hashedPassword, $firstName, $lastName, $userType);

    if (!$stmt->execute()) {
        ResponseFormatter::error('Signup failed', 500);
    }

    $userId = $conn->insert_id;

    // Generate token
    $token = AuthHandler::generateToken($userId, $email, $userType);

    ResponseFormatter::success([
        'token' => $token,
        'user' => [
            'id' => $userId,
            'email' => $email,
            'firstName' => $firstName,
            'lastName' => $lastName,
            'role' => $userType
        ]
    ], 'Signup successful', 201);
}

/**
 * Token Verification Handler
 */
function handleTokenVerification() {
    $user = AuthHandler::getCurrentUser();

    if (!$user) {
        ResponseFormatter::error('Invalid or expired token', 401);
    }

    ResponseFormatter::success($user, 'Token valid');
}

/**
 * Logout Handler
 */
function handleLogout() {
    // Just return success - client handles token deletion
    ResponseFormatter::success(null, 'Logout successful');
}
?>
