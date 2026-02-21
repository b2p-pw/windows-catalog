param(
    [String]$Name = "llvm-mingw",
    [String]$Version = "all"
)

$coreUrl = "https://raw.githubusercontent.com/b2p-pw/b2p/main/win/core.ps1"

if (Test-Path "$env:USERPROFILE\.b2p\bin\core.ps1") { . "$env:USERPROFILE\.b2p\bin\core.ps1" }
else { . { $(Invoke-RestMethod -Uri $coreUrl) } }

Uninstall-B2PApp -Name $Name -Version $Version