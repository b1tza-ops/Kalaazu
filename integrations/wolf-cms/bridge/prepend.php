<?php
$uri = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH) ?: '/';
$nonHtmlPrefixes = ['/api', '/flashAPI', '/bridge'];
$isHtmlPage = true;

foreach ($nonHtmlPrefixes as $prefix) {
    if (str_starts_with($uri, $prefix)) {
        $isHtmlPage = false;
        break;
    }
}

if ($isHtmlPage) {
    ob_start(static function (string $buffer): string {
        $tag = '<script src="/bridge/bridge.js" defer></script>';
        if (str_contains($buffer, $tag)) {
            return $buffer;
        }

        $position = strripos($buffer, '</body>');
        if ($position === false) {
            return $buffer . $tag;
        }

        return substr($buffer, 0, $position) . $tag . substr($buffer, $position);
    });
}
?>
