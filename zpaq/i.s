# Install Script - zpaq v1.0.0
param([String]$v = "latest", [Switch]$s = $false)

if (-not $OriginUrl) { $OriginUrl = "https://raw.githubusercontent.com/b2p-pw/windows-catalog/main/zpaq/v/1.0.0/i.s" }

# $OriginUrl is an HTTP URL; Split-Path would convert slashes to backslashes
# which breaks URI parsing.  Use a regex to strip the last segment instead.
$currentDir = $OriginUrl -replace '/[^/]+$',''

$manifest = Invoke-RestMethod -Uri "$currentDir/manifest.json"

# this package is a single executable; we don't differentiate versions
$manifest | Add-Member -NotePropertyName "Url" -NotePropertyValue "https://www.mattmahoney.net/dc/zpaq.exe" -Force

$versionStr = if ($v -eq "latest") { "latest" } else { $v }

Install-B2PApp -Manifest $manifest -Slot $versionStr -OriginUrl $OriginUrl -Silent:$s

# ensure latest link is created
Set-B2PLatestLink -AppName $manifest.Name.ToLower() -TargetVersion $versionStr
