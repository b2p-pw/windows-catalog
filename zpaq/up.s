# Upgrade Script - zpaq v1.0.0
param([Switch]$s = $false)

$sf = if ($s) { "-s" } else { "" }
$baseUrl = "https://raw.githubusercontent.com/b2p-pw/windows-catalog/main/zpaq"

Write-Host "[up.s] Starting cleanup and upgrade..." -ForegroundColor Gray
# 1. Uninstall current version (core now handles 'latest' -> real version resolution)
iex "& { $(Invoke-RestMethod -Uri \"$baseUrl/un.s\") } -Version 'latest'"

Write-Host "[up.s] Ready for upgrade. Installing new version..." -ForegroundColor Cyan
# 2. Install new version (i.s now installs to real version and creates symlink)
iex "& { $(Invoke-RestMethod -Uri \"$baseUrl/i.s\") } $sf"