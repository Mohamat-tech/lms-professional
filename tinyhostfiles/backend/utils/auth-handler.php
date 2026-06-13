<?php
/**
 * ============================================
 * AUTHENTICATION HANDLER
 * JWT token management and user validation
 * ============================================
 */

require_once __DIR__ . '/../config/database.php';

class AuthHandler {
    
    /**
     * Generate JWT Token
     */
    public static function generateToken($userId, $email, $role) {
        $header = [
            'typ' => 'JWT',
            'alg' => 'HS256'
        ];

        $payload = [
            'sub' => $userId,
            'email' => $email,
            'role' => $role,
            'iat' => time(),
            'exp' => TOKEN_EXPIRATION
        ];

        $header_encoded = self::base64Encode(json_encode($header));
        $payload_encoded = self::base64Encode(json_encode($payload));

        $signature = hash_hmac('SHA256', "$header_encoded.$payload_encoded", JWT_SECRET, true);
        $signature_encoded = self::base64Encode($signature);

        return "$header_encoded.$payload_encoded.$signature_encoded";
    }

    /**
     * Verify JWT Token
     */
    public static function verifyToken($token) {
        $parts = explode('.', $token);
        
        if (count($parts) !== 3) {
            return false;
        }

        list($header_encoded, $payload_encoded, $signature_encoded) = $parts;

        $signature = hash_hmac('SHA256', "$header_encoded.$payload_encoded", JWT_SECRET, true);
        $signature_expected = self::base64Encode($signature);

        if ($signature_encoded !== $signature_expected) {
            return false;
        }

        $payload = json_decode(self::base64Decode($payload_encoded), true);

        if (!$payload || isset($payload['exp']) && $payload['exp'] < time()) {
            return false;
        }

        return $payload;
    }

    /**
     * Get Current User from Token
     */
    public static function getCurrentUser() {
        $token = self::getTokenFromHeader();
        
        if (!$token) {
            return null;
        }

        return self::verifyToken($token);
    }

    /**
     * Get Token from Authorization Header
     */
    private static function getTokenFromHeader() {
        $headers = getallheaders();
        
        if (isset($headers['Authorization'])) {
            $matches = [];
            if (preg_match('/Bearer\s(\S+)/', $headers['Authorization'], $matches)) {
                return $matches[1];
            }
        }

        // Check in POST/GET parameters
        if (isset($_POST['token'])) {
            return $_POST['token'];
        }

        if (isset($_GET['token'])) {
            return $_GET['token'];
        }

        return null;
    }

    /**
     * Hash Password
     */
    public static function hashPassword($password) {
        return password_hash($password, PASSWORD_BCRYPT, ['cost' => 12]);
    }

    /**
     * Verify Password
     */
    public static function verifyPassword($password, $hash) {
        return password_verify($password, $hash);
    }

    /**
     * Base64 Encode (URL-safe)
     */
    private static function base64Encode($data) {
        return rtrim(strtr(base64_encode($data), '+/', '-_'), '=');
    }

    /**
     * Base64 Decode (URL-safe)
     */
    private static function base64Decode($data) {
        $data = strtr($data, '-_', '+/');
        $data .= str_repeat('=', (4 - strlen($data) % 4) % 4);
        return base64_decode($data);
    }
}
?>
