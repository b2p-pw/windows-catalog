# i.s - LLVM-MinGW Installer
param([String]$v = "latest", [Switch]$s = $false)

$core = irm "https://raw.githubusercontent.com/b2p-pw/b2p/main/win/core.ps1" | iex
$manifest = irm "https://raw.githubusercontent.com/b2p-pw/w/main/llvm-mingw/manifest.json"

if (-not $s) {
    Write-Host "Instalador: $($manifest.Name) (Script v$($manifest.ScriptVersion))" -ForegroundColor Gray
}

# 2. Definição de Builds
$builds = @(
    @{ Name = "64 bits, UCRT (Recomendado)"; Arch = "x86_64"; RT = "ucrt" },
    @{ Name = "64 bits, MSVCRT";           Arch = "x86_64"; RT = "msvcrt" },
    @{ Name = "32 bits, UCRT";           Arch = "i686";   RT = "ucrt" },
    @{ Name = "32 bits, MSVCRT";           Arch = "i686";   RT = "msvcrt" }
)

$selectedBuild = $builds[0] 

if (-not $s) {
    Write-Host "`n--- Seleção de Build: LLVM-MinGW ---" -ForegroundColor Cyan
    for ($i = 0; $i -lt $builds.Count; $i++) { " [{0}] {1}" -f ($i + 1), $builds[$i].Name }
    
    $choice = Read-Host "`nEscolha o número"
    $idx = 0
    if ([int]::TryParse($choice, [ref]$idx) -and $idx -ge 1 -and $idx -le $builds.Count) {
        $selectedBuild = $builds[$idx - 1]
    }
}

$architecture = $selectedBuild.Arch
$buildName = $selectedBuild.RT

# 3. Buscar no GitHub
Write-Host "Buscando versão no GitHub..." -ForegroundColor Gray
$api = "https://api.github.com/repos/mstorsjo/llvm-mingw/releases/latest"
if ($v -ne "latest") { $api = "https://api.github.com/repos/mstorsjo/llvm-mingw/releases/tags/v$v" }

try {
    $rel = Invoke-RestMethod -Uri $api -UserAgent "b2p"
    $asset = $rel.assets | Where-Object { $_.name -like "*-$buildName-$architecture.zip" } | Select-Object -First 1

    if (-not $asset) { throw "Arquivo não encontrado." }

    # Correção para garantir propriedade Url
    if (-not $manifest.PSObject.Properties['Url']) {
        $manifest | Add-Member -NotePropertyName "Url" -NotePropertyValue $asset.browser_download_url -Force
    } else {
        $manifest.Url = $asset.browser_download_url
    }

    $versionStr = if ($v -eq "latest") { $rel.tag_name -replace 'v','' } else { $v }

    # 4. Instalar
    Install-B2PApp -Manifest $manifest -Version $versionStr -Silent:$s

} catch { Write-Host "Erro: $($_.Exception.Message)" -ForegroundColor Red }