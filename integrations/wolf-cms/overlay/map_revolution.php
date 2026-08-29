<?php
if (!isset($_SESSION['kalaazu_account']) || !is_array($_SESSION['kalaazu_account'])) {
    header('Location: ' . DOMAIN);
    exit;
}

$payload = json_encode($_SESSION['kalaazu_account'], JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
$handoff = rtrim(strtr(base64_encode($payload), '+/', '-_'), '=');

header('Cache-Control: no-store');
header('Location: ' . KALAAZU_PUBLIC_URL . '/?handoff=' . rawurlencode($handoff));
exit;
?>
