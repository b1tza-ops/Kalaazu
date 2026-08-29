$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$envFile = Join-Path $repoRoot ".env"
$composeFile = Join-Path $repoRoot "docker-compose.wolf-cms.yml"
$sourcePath = Join-Path $repoRoot "integrations\wolf-cms\source"
$sourceRepository = "https://github.com/WolfFr1/DarkOrbit-CMS-Wolf_Fr.git"
$sourceCommit = "3bbee2ef72c2417494a5f0d67d3a51fe3006959c"

function Assert-Command {
    param([Parameter(Mandatory = $true)][string]$Name)

    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "Required command '$Name' was not found."
    }
}

Assert-Command "git"
Assert-Command "docker"

if (-not (Test-Path -LiteralPath $envFile)) {
    throw "Missing .env. Run .\scripts\windows\setup-local.ps1 first."
}

docker info *> $null
if ($LASTEXITCODE -ne 0) {
    throw "Docker Desktop is installed but not running. Start it and retry."
}

if (-not (Test-Path -LiteralPath (Join-Path $sourcePath ".git"))) {
    Write-Host "Downloading the exact Wolf_Fr CMS source..."
    git clone $sourceRepository $sourcePath
    if ($LASTEXITCODE -ne 0) {
        throw "Could not clone the Wolf_Fr CMS repository."
    }
}

$sourceChanges = git -C $sourcePath status --porcelain
if ($LASTEXITCODE -ne 0) {
    throw "The Wolf_Fr CMS source directory is not a valid Git checkout."
}
if ($sourceChanges) {
    throw "The generated Wolf_Fr source has local changes. Preserve or remove them before setup continues."
}

$currentCommit = git -C $sourcePath rev-parse HEAD
if ($currentCommit -ne $sourceCommit) {
    Write-Host "Selecting the tested Wolf_Fr CMS revision..."
    git -C $sourcePath fetch --depth 1 origin $sourceCommit
    git -C $sourcePath checkout --detach $sourceCommit
    if ($LASTEXITCODE -ne 0) {
        throw "Could not select the tested Wolf_Fr CMS revision."
    }
}

Push-Location $repoRoot
try {
    Write-Host "Building and starting the Wolf_Fr CMS bridge..."
    docker compose --env-file $envFile -f $composeFile up -d --build --wait
    if ($LASTEXITCODE -ne 0) {
        throw "The Wolf_Fr CMS containers did not become healthy."
    }
}
finally {
    Pop-Location
}

Write-Host ""
Write-Host "Wolf_Fr CMS is ready at http://127.0.0.1:8082"
Write-Host "Keep Kalaazu running with .\scripts\windows\run-local.ps1"
