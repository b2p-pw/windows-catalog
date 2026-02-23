# up.s - LLVM-MinGW v1.0.0
param([Switch]$s = $false)

$sf = if ($s) { "-s" } else { "" }
$baseUrl = "https://raw.githubusercontent.com/b2p-pw/windows-catalog/main/llvm-mingw"

Write-Host "[up.s] Iniciando limpeza do slot 'latest'..." -ForegroundColor Gray
# 1. Desinstala a versão que estiver no slot latest agora
iex "& { $(Invoke-RestMethod -Uri "$baseUrl/un.s") } -Version 'latest'"

Write-Host "[up.s] Slot limpo. Instalando nova versão..." -ForegroundColor Cyan
# 2. Instala a nova versão no slot latest
iex "& { $(Invoke-RestMethod -Uri "$baseUrl/i.s") } -v 'latest' $sf"