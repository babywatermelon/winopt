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

# Download modules
Invoke-WebRequest "https://raw.githubusercontent.com/babywatermelon/winopt/main/modules/clean.ps1" -OutFile "$modules\clean.ps1"
Invoke-WebRequest "https://raw.githubusercontent.com/babywatermelon/winopt/main/modules/network.ps1" -OutFile "$modules\network.ps1"
Invoke-WebRequest "https://raw.githubusercontent.com/babywatermelon/winopt/main/modules/repair.ps1" -OutFile "$modules\repair.ps1"
Invoke-WebRequest "https://raw.githubusercontent.com/babywatermelon/winopt/main/modules/tools.ps1" -OutFile "$modules\tools.ps1"

# Run menu
powershell -ExecutionPolicy Bypass -File "$base\menu.ps1"
