param([String]$v = "all")
$core = irm "https://raw.githubusercontent.com/b2p-pw/b2p/main/win/core.ps1" | iex
Uninstall-B2PApp -Name "llvm-mingw" -Version $v