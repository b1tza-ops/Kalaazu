# Windows local setup

This setup runs Kalaazu privately on one Windows computer. MariaDB is bound to `127.0.0.1`, so it is not exposed to
the local network or the internet.

## What this proves

The local milestone verifies that the database initializes, the Java project builds, the JavaFX launcher opens, and the
web and game servers listen on their configured ports. The included clean HTML5 test client uses original code-drawn
graphics and connects to the real V4 game simulation through a loopback WebSocket gateway.

## Prerequisites

Install these before continuing:

1. Git for Windows.
2. Eclipse Temurin JDK 25 (Windows x64, JDK package). Ensure the installer adds Java to `PATH` and sets `JAVA_HOME`.
3. Docker Desktop using the WSL 2 backend.

Open a new PowerShell window and verify:

```powershell
git --version
java -version
docker version
```

`java -version` must report Java 25. Docker Desktop must be running.

## First setup

Clone the `develop` branch from your fork:

```powershell
git clone --branch develop --single-branch https://github.com/b1tza-ops/Kalaazu.git
cd Kalaazu
```

Allow scripts only for the current PowerShell process, then run setup:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\windows\setup-local.ps1
```

The script creates an ignored `.env` file with random local passwords, starts MariaDB, imports
`Persistence/database/dump.sql`, and builds all Gradle modules. The first build can take several minutes.

## Start Kalaazu

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\windows\run-local.ps1
```

The JavaFX server dashboard should open. With `AUTO_START=true`, the backend starts automatically.

## Local ports

| Service | Address |
| --- | --- |
| MariaDB | `127.0.0.1:3306` |
| Game server | `127.0.0.1:8080` |
| Web API | `http://127.0.0.1:8081` |
| Browser game gateway | `ws://127.0.0.1:8083/game` |
| Flash policy server | `127.0.0.1:843` |
| Chat server | Port `8082` is reserved but not implemented yet |

Verify the web backend after the launcher starts:

```powershell
Invoke-RestMethod http://127.0.0.1:8081/actuator/health
Test-NetConnection 127.0.0.1 -Port 8080
```

The health response should contain `status: UP`, and the game-server TCP test should succeed.

Open `http://127.0.0.1:8081` in a modern browser. Create a pilot or log in, then click the map to move. The browser
client, API, database, raw game port, and WebSocket gateway all bind to `127.0.0.1` in the local configuration.

## Reset the local database

This permanently removes only Kalaazu's Docker database volume. The next setup recreates and reimports it:

```powershell
docker compose --env-file .env -f docker-compose.local.yml down -v
.\scripts\windows\setup-local.ps1
```

## Client scope

The HTML5 client is an original minimal test client. It currently supports registration, login, V4 session
authentication, map/entity rendering, ship status, and movement. It deliberately contains no copied DarkOrbit client
files, SWFs, artwork, sounds, or other proprietary assets.
