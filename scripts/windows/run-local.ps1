$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$envFile = Join-Path $repoRoot ".env"
$composeFile = Join-Path $repoRoot "docker-compose.local.yml"

. (Join-Path $PSScriptRoot "Import-DotEnv.ps1")
Use-Java25
Import-DotEnv -Path $envFile

Push-Location $repoRoot
try {
    docker compose --env-file $envFile -f $composeFile up -d --wait
    if ($LASTEXITCODE -ne 0) {
        throw "MariaDB did not become healthy."
    }

    & (Join-Path $repoRoot "gradlew.bat") run
    if ($LASTEXITCODE -ne 0) {
        throw "Kalaazu exited with an error."
    }
}
finally {
    Pop-Location
}
