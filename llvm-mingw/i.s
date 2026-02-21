# i.s - LLVM-MinGW Installer
param([String]$v = "latest", [Switch]$s = $false)

$core = irm "https://raw.githubusercontent.com/b2p-pw/b2p/main/win/core.ps1" | iex
$manifest = irm "https://raw.githubusercontent.com/b2p-pw/w/main/llvm-mingw/manifest.json"

# Lógica herdada do seu script: Seleção de Build
$arch = "x86_64"; $rt = "msvcrt" # Defaults
if (-not $s) {
    Write-Host "--- LLVM-MinGW Build Selection ---"
    $arch = Read-Host "Arquitetura (x86_64 / i686)"
    $rt = Read-Host "Runtime (ucrt / msvcrt)"
}

# Busca URL no GitHub
$api = "https://api.github.com/repos/mstorsjo/llvm-mingw/releases/latest"
if ($v -ne "latest") { $api = "https://api.github.com/repos/mstorsjo/llvm-mingw/releases/tags/v$v" }

$rel = irm $api -UserAgent "b2p"
$asset = $rel.assets | Where-Object { $_.name -like "*-$rt-$arch.zip" } | Select-Object -First 1

$manifest.Url = $asset.browser_download_url
$versionStr = if ($v -eq "latest") { $rel.tag_name -replace 'v','' } else { $v }

Install-B2PApp -Manifest $manifest -Version $versionStr -Silent:$s