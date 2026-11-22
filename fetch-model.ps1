<#
.SYNOPSIS
    Downloads and verifies the Gemma 270M GGUF model asset from GitHub.
.DESCRIPTION
    Native PowerShell script (compatible with 5.1 and 7+) with SHA-256 integrity verification.
.PARAMETER TargetDir
    The target directory where gemma270m.gguf should be saved (default: current directory).
.PARAMETER Force
    Force re-download even if an existing file passes verification.
#>
[CmdletBinding()]
param (
    [string]$TargetDir = ".",
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$ModelName = "gemma270m.gguf"
$ExpectedSha256 = "5F4B2E17722E510122C464573B880587F4983347A40E5472B858D5A3C1AB8095"
$ModelVersion = "v1.0.0"
$ReleaseUrl = "https://github.com/sr00t3d/nexus-llm-gemma/releases/download/$ModelVersion/$ModelName"
$RawLfsUrl = "https://media.githubusercontent.com/media/sr00t3d/nexus-llm-gemma/main/$ModelName"

if (-not (Test-Path -Path $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}

$TargetFile = Join-Path -Path $TargetDir -ChildPath $ModelName

function Test-ModelIntegrity {
    param ([string]$FilePath)
    if (-not (Test-Path -Path $FilePath)) { return $false }
    Write-Host "[INFO] Computing SHA-256 hash for $FilePath..." -ForegroundColor Cyan
    $hash = (Get-FileHash -Path $FilePath -Algorithm SHA256).Hash.ToUpper()
    if ($hash -eq $ExpectedSha256) {
        return $true
    } else {
        Write-Warning "Hash mismatch! Expected: $ExpectedSha256 | Actual: $hash"
        return $false
    }
}

if ((Test-Path -Path $TargetFile) -and (-not $Force)) {
    if (Test-ModelIntegrity -FilePath $TargetFile) {
        Write-Host "[OK] $TargetFile is already present and verified healthy." -ForegroundColor Green
        exit 0
    } else {
        Write-Warning "Existing file is corrupted. Re-downloading..."
        Remove-Item -Path $TargetFile -Force -ErrorAction SilentlyContinue
    }
}

Write-Host "[INFO] Downloading $ModelName from GitHub Release ($ModelVersion)..." -ForegroundColor Cyan

$downloaded = $false
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $ReleaseUrl -OutFile $TargetFile -UseBasicParsing
    $downloaded = $true
} catch {
    Write-Warning "Primary release URL download failed: $_. Falling back to Git LFS media endpoint..."
    try {
        Invoke-WebRequest -Uri $RawLfsUrl -OutFile $TargetFile -UseBasicParsing
        $downloaded = $true
    } catch {
        Write-Error "Failed to download $ModelName from both endpoints: $_"
        exit 1
    }
}

if (-not (Test-ModelIntegrity -FilePath $TargetFile)) {
    Write-Error "Downloaded model failed SHA-256 integrity check!"
    Remove-Item -Path $TargetFile -Force -ErrorAction SilentlyContinue
    exit 2
}

Write-Host "[OK] Model successfully downloaded and verified: $TargetFile" -ForegroundColor Green
exit 0
