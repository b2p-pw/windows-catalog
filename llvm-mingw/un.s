# un.s - Repositório W
param([String]$Name = "llvm-mingw", [String]$Version = "all")

$coreUrl = "https://raw.githubusercontent.com/b2p-pw/b2p/main/win/core.ps1"
$B2P_HOME = Join-Path $env:USERPROFILE ".b2p"
$localCore = Join-Path $B2P_HOME "bin\core.ps1"

if (Test-Path $localCore) { . $localCore } 
else { . ([ScriptBlock]::Create((Invoke-RestMethod -Uri $coreUrl))) }

Uninstall-B2PApp -Name $Name -Version $Version