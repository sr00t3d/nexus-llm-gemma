<#
.SYNOPSIS
    Runs llama-server with gemma270m.gguf on Windows.
.DESCRIPTION
    PowerShell script (compatible with 5.1 and 7+) to start llama-server.
#>
[CmdletBinding()]
param (
    [string]$ModelFile = "gemma270m.gguf",
    [int]$Port = 8080,
    [string]$HostAddress = "127.0.0.1",
    [int]$CtxSize = 2048,
    [int]$GpuLayers = 99
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -Path $ModelFile)) {
    Write-Host "[INFO] Model file '$ModelFile' not found. Fetching..." -ForegroundColor Cyan
    & "$PSScriptRoot\fetch-model.ps1" -TargetDir (Split-Path -Path $ModelFile -Parent)
}

$llamaCmd = Get-Command "llama-server.exe" -ErrorAction SilentlyContinue
if (-not $llamaCmd) {
    $llamaCmd = Get-Command "llama-server" -ErrorAction SilentlyContinue
}

if (-not $llamaCmd) {
    Write-Error "llama-server binary was not found in PATH. Please install llama.cpp Windows binaries."
    exit 1
}

Write-Host "[INFO] Launching llama-server on http://${HostAddress}:${Port}..." -ForegroundColor Green
& $llamaCmd.Source --model $ModelFile --host $HostAddress --port $Port --ctx-size $CtxSize --n-gpu-layers $GpuLayers --alias "gemma-270m"
