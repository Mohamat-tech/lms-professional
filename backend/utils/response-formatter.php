<?php
/**
 * ============================================
 * RESPONSE FORMATTER UTILITY
 * Format standardized API responses
 * ============================================
 */

class ResponseFormatter {
    
    /**
     * Success Response
     */
    public static function success($data = null, $message = 'Success', $code = 200) {
        return self::response(true, $data, $message, $code);
    }

    /**
     * Error Response
     */
    public static function error($message = 'Error', $code = 400, $data = null) {
        return self::response(false, $data, $message, $code);
    }

    /**
     * Send Response
     */
    private static function response($success, $data, $message, $code) {
        header('Content-Type: application/json; charset=utf-8');
        http_response_code($code);
        
        echo json_encode([
            'success' => $success,
            'message' => $message,
            'data' => $data,
            'timestamp' => date('Y-m-d H:i:s'),
            'developer' => 'NDAOBA MOHAMAT 24G2687'
        ], JSON_UNESCAPED_UNICODE);
        
        exit;
    }

    /**
     * Send JSON
     */
    public static function json($data, $code = 200) {
        header('Content-Type: application/json; charset=utf-8');
        http_response_code($code);
        echo json_encode($data, JSON_UNESCAPED_UNICODE);
        exit;
    }
}
?>
