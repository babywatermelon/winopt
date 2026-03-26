Clear-Host
Write-Host "Loading WinOpt Tool..." -ForegroundColor Cyan

$base = "$env:TEMP\winopt"

if (!(Test-Path $base)) {
    New-Item -ItemType Directory -Path $base | Out-Null
}

$modules = "$base\modules"

if (!(Test-Path $modules)) {
    New-Item -ItemType Directory -Path $modules | Out-Null
}

# Download menu
Invoke-WebRequest "https://raw.githubusercontent.com/babywatermelon/winopt/main/menu.ps1" -OutFile "$base\menu.ps1"

# ===== Download modules (FULL) =====
$moduleList = @(
    "clean",
    "network",
    "repair",
    "tools",
    "install"    
    "uninstall"
    "extention"
)

foreach ($m in $moduleList) {
    $url = "https://raw.githubusercontent.com/babywatermelon/winopt/main/modules/$m.ps1"
    $out = "$modules\$m.ps1"

    Write-Host "Downloading $m..." -ForegroundColor DarkGray
    Invoke-WebRequest $url -OutFile $out
}

# Run menu
powershell -ExecutionPolicy Bypass -File "$base\menu.ps1"
