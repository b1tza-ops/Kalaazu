$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$envFile = Join-Path $repoRoot ".env"
$composeFile = Join-Path $repoRoot "docker-compose.wolf-cms.yml"
$sourcePath = Join-Path $repoRoot "integrations\wolf-cms\source"

if (-not (Test-Path -LiteralPath (Join-Path $sourcePath "server.sql"))) {
    throw "Wolf_Fr CMS is not installed. Run .\scripts\windows\setup-wolf-cms.ps1 first."
}

Push-Location $repoRoot
try {
    docker compose --env-file $envFile -f $composeFile up -d --wait
    if ($LASTEXITCODE -ne 0) {
        throw "The Wolf_Fr CMS containers did not become healthy."
    }
}
finally {
    Pop-Location
}

Write-Host "Wolf_Fr CMS is running at http://127.0.0.1:8082"
