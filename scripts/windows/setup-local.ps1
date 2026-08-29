$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$envFile = Join-Path $repoRoot ".env"
$envExample = Join-Path $repoRoot ".env.example"
$composeFile = Join-Path $repoRoot "docker-compose.local.yml"

function Assert-Command {
    param([Parameter(Mandatory = $true)][string]$Name)

    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "Required command '$Name' was not found. See docs/WINDOWS_LOCAL_SETUP.md."
    }
}

. (Join-Path $PSScriptRoot "Import-DotEnv.ps1")
Use-Java25
Assert-Command "docker"

$javaVersion = Get-JavaVersionOutput -JavaExecutable (Join-Path $env:JAVA_HOME "bin\java.exe")
if ($javaVersion -notmatch 'version "25([\."])') {
    throw "Kalaazu requires JDK 25. Current Java output:`n$javaVersion"
}

docker info *> $null
if ($LASTEXITCODE -ne 0) {
    throw "Docker Desktop is installed but not running. Start it and retry."
}

if (-not (Test-Path -LiteralPath $envFile)) {
    $appPassword = [Guid]::NewGuid().ToString("N")
    $rootPassword = [Guid]::NewGuid().ToString("N")
    $environment = Get-Content -LiteralPath $envExample -Raw
    $environment = $environment.Replace("change-me-app-password", $appPassword)
    $environment = $environment.Replace("change-me-root-password", $rootPassword)
    Set-Content -LiteralPath $envFile -Value $environment -Encoding utf8
    Write-Host "Created .env with random local database passwords."
}

Import-DotEnv -Path $envFile

Push-Location $repoRoot
try {
    Write-Host "Starting the local MariaDB container..."
    docker compose --env-file $envFile -f $composeFile up -d --wait
    if ($LASTEXITCODE -ne 0) {
        throw "MariaDB did not become healthy."
    }

    Write-Host "Building Kalaazu. The first build downloads Gradle and dependencies..."
    & (Join-Path $repoRoot "gradlew.bat") clean build
    if ($LASTEXITCODE -ne 0) {
        throw "The Gradle build failed."
    }
}
finally {
    Pop-Location
}

Write-Host ""
Write-Host "Local setup completed. Start Kalaazu with:"
Write-Host ".\scripts\windows\run-local.ps1"
