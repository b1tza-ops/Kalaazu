<?php
declare(strict_types=1);

header('Content-Type: application/json');
header('Cache-Control: no-store');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['status' => 'ERROR', 'message' => 'POST required']);
    exit;
}

require_once __DIR__ . '/../files/config.php';

try {
    $input = json_decode(file_get_contents('php://input'), true, 512, JSON_THROW_ON_ERROR);
    $account = $input['account'] ?? null;

    if (!is_array($account)) {
        throw new RuntimeException('Missing Kalaazu account');
    }

    $required = ['id', 'usersId', 'sessionId', 'name'];
    foreach ($required as $field) {
        if (!isset($account[$field]) || $account[$field] === '') {
            throw new RuntimeException('Invalid Kalaazu account response');
        }
    }

    $userId = (int) $account['usersId'];
    $sessionId = substr((string) $account['sessionId'], 0, 32);
    $pilotName = substr((string) $account['name'], 0, 20);
    $factionId = (int) ($account['factionsId'] ?? 1);
    $clanId = (int) ($account['clansId'] ?? 0);
    $rankId = (int) ($account['ranksId'] ?? 1);
    $data = json_encode([
        'uridium' => (int) ($account['uridium'] ?? 0),
        'credits' => (int) ($account['credits'] ?? 0),
        'honor' => (int) ($account['honor'] ?? 0),
        'experience' => (int) ($account['experience'] ?? 0),
        'jackpot' => (int) ($account['jackpot'] ?? 0)
    ], JSON_THROW_ON_ERROR);
    $info = json_encode(['bridge' => 'kalaazu', 'accountId' => (int) $account['id']], JSON_THROW_ON_ERROR);
    $verification = json_encode(['verified' => true, 'hash' => $sessionId], JSON_THROW_ON_ERROR);
    $placeholderPassword = password_hash(bin2hex(random_bytes(16)), PASSWORD_DEFAULT);
    $placeholderEmail = 'local-' . $userId . '@kalaazu.invalid';

    mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
    $mysqli = Database::GetInstance();
    $mysqli->begin_transaction();

    $statement = $mysqli->prepare(
        'INSERT INTO player_accounts '
        . '(userId, sessionId, data, info, username, pilotName, password, email, factionId, clanId, rankId, verification) '
        . 'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) '
        . 'ON DUPLICATE KEY UPDATE sessionId = VALUES(sessionId), data = VALUES(data), info = VALUES(info), '
        . 'username = VALUES(username), pilotName = VALUES(pilotName), factionId = VALUES(factionId), '
        . 'clanId = VALUES(clanId), rankId = VALUES(rankId), verification = VALUES(verification)'
    );
    $statement->bind_param(
        'isssssssiiis',
        $userId,
        $sessionId,
        $data,
        $info,
        $pilotName,
        $pilotName,
        $placeholderPassword,
        $placeholderEmail,
        $factionId,
        $clanId,
        $rankId,
        $verification
    );
    $statement->execute();

    foreach (['player_equipment', 'player_settings', 'player_titles'] as $table) {
        $idColumn = $table === 'player_titles' ? 'userID' : 'userId';
        $mysqli->query("INSERT IGNORE INTO {$table} ({$idColumn}) VALUES ({$userId})");
    }

    $mysqli->commit();
    $_SESSION['account'] = ['id' => $userId, 'session' => $sessionId];
    $_SESSION['kalaazu_account'] = $account;

    echo json_encode(['status' => 'OK']);
} catch (Throwable $error) {
    if (isset($mysqli)) {
        try {
            $mysqli->rollback();
        } catch (Throwable) {
        }
    }

    http_response_code(400);
    echo json_encode(['status' => 'ERROR', 'message' => $error->getMessage()]);
}
?>
