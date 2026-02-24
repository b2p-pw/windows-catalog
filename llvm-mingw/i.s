# Install Script - LLVM-MinGW v1.0.0
param([String]$v = "latest", [Switch]$s = $false)

if (-not $OriginUrl) { $OriginUrl = "https://raw.githubusercontent.com/b2p-pw/windows-catalog/main/llvm-mingw/v/1.0.0/i.s" }
$currentDir = Split-Path $OriginUrl

$manifest = Invoke-RestMethod -Uri "$currentDir/manifest.json"

$core = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/b2p-pw/b2p/main/windows/core.ps1" | iex

$builds = @(
    @{ Name = "64-bit, UCRT (Default)";     Arch = "x86_64";    RT = "ucrt" },
    @{ Name = "64-bit, MSVCRT";              Arch = "x86_64";    RT = "msvcrt" },
    @{ Name = "32-bit, UCRT";                Arch = "i686";      RT = "ucrt" },
    @{ Name = "32-bit, MSVCRT";              Arch = "i686";      RT = "msvcrt" }
)
$selectedBuild = $builds[0] 
if (-not $s) {
    Write-Host "`n--- LLVM-MinGW Build Selection ---" -ForegroundColor Cyan
    for ($i = 0; $i -lt $builds.Count; $i++) { " [{0}] {1}" -f ($i + 1), $builds[$i].Name }
    $choice = Read-Host "`nSelect a number"
    $idx = 0
    if ([int]::TryParse($choice, [ref]$idx) -and $idx -ge 1 -and $idx -le $builds.Count) { $selectedBuild = $builds[$idx - 1] }
}
$architecture = $selectedBuild.Arch; $buildName = $selectedBuild.RT

Write-Host "Fetching version from GitHub..." -ForegroundColor Gray
$api = "https://api.github.com/repos/mstorsjo/llvm-mingw/releases/latest"
if ($v -ne "latest") { $api = "https://api.github.com/repos/mstorsjo/llvm-mingw/releases/tags/$v" }

try {
    $rel = irm $api -UserAgent "b2p"
    $asset = $rel.assets | Where-Object { $_.name -like "*$buildName*$architecture*.zip" -or $_.name -like "*$architecture*$buildName*.zip" } | Select-Object -First 1
    if (-not $asset) { throw "Binary not found." }

    $manifest | Add-Member -NotePropertyName "Url" -NotePropertyValue $asset.browser_download_url -Force
    $versionStr = if ($v -eq "latest") { $rel.tag_name } else { $v }

    Install-B2PApp -Manifest $manifest -Slot $versionStr -OriginUrl $OriginUrl -Silent:$s
    
    # Create default symlink if this is first install or being used as default
    Set-B2PLatestLink -AppName $manifest.Name.ToLower() -TargetVersion $versionStr

} catch { Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red }