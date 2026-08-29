<?php
define('ROOT', realpath(dirname(__FILE__)) . DIRECTORY_SEPARATOR);

ini_set('log_errors', 1);
ini_set('error_log', ROOT . 'error_logs' . DIRECTORY_SEPARATOR . 'php_error.log');
ini_set('display_errors', 0);
ini_set('error_reporting', E_ALL);

$sessions_path = ROOT . 'sessions';
ini_set('session.save_path', $sessions_path);

if (!file_exists($sessions_path)) {
    mkdir($sessions_path, 0770, true);
}

if (session_status() !== PHP_SESSION_ACTIVE) {
    session_start();
}

setcookie(session_name(), session_id(), [
    'path' => '/',
    'httponly' => true,
    'samesite' => 'Lax'
]);

define('SERVER_NAME', 'Kalaazu');
define('MAINTENANCE', false);

define('MYSQL_HOST', getenv('WOLF_CMS_DB_HOST') ?: 'wolf-cms-db');
define('MYSQL_USER', getenv('WOLF_CMS_DB_USER') ?: 'kalaazu_cms');
define('MYSQL_PASSWORD', getenv('WOLF_CMS_DB_PASSWORD') ?: '');
define('MYSQL_DATABASE', getenv('WOLF_CMS_DB_NAME') ?: 'darkorbit');
define('MYSQL_PORT', 3306);

$scheme = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';
$httpHost = $_SERVER['HTTP_HOST'] ?? '127.0.0.1:8082';
define('DOMAIN', $scheme . '://' . $httpHost . '/');
define('KALAAZU_PUBLIC_URL', rtrim(getenv('KALAAZU_PUBLIC_URL') ?: 'http://127.0.0.1:8081', '/'));

define('CLASSES', ROOT . 'classes' . DIRECTORY_SEPARATOR);
define('EXTERNALS', ROOT . 'external' . DIRECTORY_SEPARATOR);
define('INCLUDES', EXTERNALS . 'includes' . DIRECTORY_SEPARATOR);
define('CRONJOBS', EXTERNALS . 'cronjobs' . DIRECTORY_SEPARATOR);

require_once(CLASSES . 'SMTP.php');
require_once(CLASSES . 'Functions.php');
require_once(CLASSES . 'Database.php');
require_once(CLASSES . 'Socket.php');
?>
