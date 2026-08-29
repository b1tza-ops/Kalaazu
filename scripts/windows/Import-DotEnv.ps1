function Import-DotEnv {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        throw "Environment file not found: $Path"
    }

    foreach ($line in Get-Content -LiteralPath $Path) {
        $trimmed = $line.Trim()
        if (-not $trimmed -or $trimmed.StartsWith("#")) {
            continue
        }

        $separator = $trimmed.IndexOf("=")
        if ($separator -lt 1) {
            continue
        }

        $name = $trimmed.Substring(0, $separator).Trim()
        $value = $trimmed.Substring($separator + 1).Trim()
        [Environment]::SetEnvironmentVariable($name, $value, "Process")
    }
}

function Use-Java25 {
    $candidateHomes = @()

    if ($env:JAVA_HOME) {
        $candidateHomes += $env:JAVA_HOME
    }

    $adoptiumRoot = Join-Path $env:ProgramFiles "Eclipse Adoptium"
    if (Test-Path -LiteralPath $adoptiumRoot) {
        $adoptiumHomes = @(
            Get-ChildItem -LiteralPath $adoptiumRoot -Directory -Filter "jdk-25*" |
                Sort-Object Name -Descending |
                Select-Object -ExpandProperty FullName
        )
        $candidateHomes += $adoptiumHomes
    }

    $candidateHomes = $candidateHomes | Select-Object -Unique
    foreach ($candidateHome in $candidateHomes) {
        $javaExecutable = Join-Path $candidateHome "bin\java.exe"
        if (-not (Test-Path -LiteralPath $javaExecutable)) {
            continue
        }

        $versionOutput = (& $javaExecutable -version 2>&1 | Out-String)
        if ($versionOutput -match 'version "25([\."])') {
            $env:JAVA_HOME = $candidateHome
            $env:Path = "$(Join-Path $candidateHome 'bin');$env:Path"
            Write-Host "Using Java 25 from $candidateHome"
            return
        }
    }

    throw "Eclipse Temurin JDK 25 was not found. Install package EclipseAdoptium.Temurin.25.JDK and retry."
}
