# un.s - LLVM-MinGW v1.0.0
param([String]$Name = "llvm-mingw", [String]$Version = "all")

$B2P_APPS = Join-Path $env:USERPROFILE ".b2p\apps"
$localUn = Join-Path $B2P_APPS "$Name\$Version\uninstall.ps1"

if ($Version -eq "all") {
    # Se for 'all', tenta achar o uninstall na pasta 'latest' ou na primeira que encontrar
    $firstVer = (Get-ChildItem (Join-Path $B2P_APPS $Name) -Directory | Select-Object -First 1).Name
    $localUn = Join-Path $B2P_APPS "$Name\$firstVer\uninstall.ps1"
}

if (Test-Path $localUn) {
    Write-Host "[un.s] Redirecionando para desinstalador local..." -ForegroundColor Gray
    & $localUn -Name $Name -Version $Version
} else {
    Write-Host "[un.s] Local não encontrado. Carregando motor remoto..." -ForegroundColor Cyan
    $core = irm "https://raw.githubusercontent.com/b2p-pw/b2p/main/windows/core.ps1" | iex
    Uninstall-B2PApp -Name $Name -Version $Version
}