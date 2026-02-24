param([String]$Name = "zpaq", [String]$Version = "all")

# This file is kept in the catalog so that Install-B2PApp can sync it during install.
# It simply invokes the shared core uninstall functionality.

$core = . "https://raw.githubusercontent.com/b2p-pw/b2p/main/windows/core.ps1"
Uninstall-B2PApp -Name $Name -Version $Version