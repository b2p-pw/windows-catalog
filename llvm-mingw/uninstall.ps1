# uninstall.ps1 - A lógica fixa de remoção
param([String]$Name = "llvm-mingw", [String]$Version = "latest")

$B2P_HOME = Join-Path $env:USERPROFILE ".b2p"
$coreLocal = Join-Path $B2P_HOME "bin\core.ps1"

# 1. Carrega o motor (prioriza local)
if (Test-Path $coreLocal) { . $coreLocal } 
else { . ([ScriptBlock]::Create((Invoke-RestMethod -Uri "https://raw.githubusercontent.com/b2p-pw/b2p/main/windows/core.ps1"))) }

# 2. Executa a limpeza
Uninstall-B2PApp -Name $Name -Version $Version