# un.s - B2P Smart Uninstaller
param([String]$v = "latest")

# 1. Lógica de Core Adaptativo (Local > Web)
$B2P_BIN = "$env:USERPROFILE\.b2p\bin"
$localCore = Join-Path $B2P_BIN "core.ps1"

if (Test-Path $localCore) {
    . $localCore
    Write-Host "[un.s] Usando motor Core local." -ForegroundColor Gray
} else {
    $coreCode = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/b2p-pw/b2p/main/win/core.ps1"
    Invoke-Expression $coreCode
    Write-Host "[un.s] Usando motor Core via Web." -ForegroundColor Yellow
}

# 2. Identificar o App (baseado na pasta onde o script está)
# Se estiver rodando local, ele descobre o nome pela pasta pai
$scriptPath = Split-Path $MyInvocation.MyCommand.Path
$appName = (Get-Item (Split-Path $scriptPath -Parent)).Name

if ([string]::IsNullOrWhiteSpace($appName)) {
    # Se rodar via Web, o nome deve ser passado ou inferido (exemplo fixo no repo)
    $appName = "llvm-mingw" 
}

# 3. Chamar a função de remoção do Core
# O Core cuidará de: remover teleports, shims, entradas no PATH real e deletar os arquivos.
Uninstall-B2PApp -Name $appName -Version $v