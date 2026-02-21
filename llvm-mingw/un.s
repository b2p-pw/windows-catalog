# un.s - Repositório W
param([String]$v = "all")

# Se o appName não foi injetado pelo b2p.ps1, define o padrão do repo
if (-not $appName) { $appName = "llvm-mingw" }

$coreUrl = "https://raw.githubusercontent.com/b2p-pw/b2p/main/win/core.ps1"
if (Test-Path "$env:USERPROFILE\.b2p\bin\core.ps1") { . "$env:USERPROFILE\.b2p\bin\core.ps1" }
else { . { $(irm $coreUrl) } }

Uninstall-B2PApp -Name $appName -Version $v