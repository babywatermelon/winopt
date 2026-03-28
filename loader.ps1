Clear-Host
Write-Host "Loading WinOpt Tool..." -ForegroundColor Cyan

$base = "$env:TEMP\winopt"
$modules = "$base\modules"

# Xóa toàn bộ thư mục cũ để tải mới nhất
if (Test-Path $base) {
    Remove-Item -Path $base -Recurse -Force
}

New-Item -ItemType Directory -Path $modules -Force | Out-Null

# Download menu
Write-Host "Downloading menu..." -ForegroundColor DarkGray
Invoke-WebRequest "https://raw.githubusercontent.com/babywatermelon/winopt/main/menu.ps1" -OutFile "$base\menu.ps1"

# Download modules
$moduleList = @("clean", "network", "repair", "tools", "install", "uninstall", "windowsupdate", "security", "gaming")

foreach ($m in $moduleList) {
    $url = "https://raw.githubusercontent.com/babywatermelon/winopt/main/modules/$m.ps1"
    $out = "$modules\$m.ps1"
    Write-Host "Downloading $m.ps1 ..." -ForegroundColor DarkGray
    try {
        Invoke-WebRequest $url -OutFile $out
        Write-Host "Downloaded: $m.ps1" -ForegroundColor Green
    }
    catch {
        Write-Host "Error downloading $m.ps1" -ForegroundColor Red
    }
}

Write-Host "All modules downloaded successfully!" -ForegroundColor Cyan
Write-Host "Starting WinOpt..." -ForegroundColor Cyan

# Run menu
powershell -ExecutionPolicy Bypass -File "$base\menu.ps1"
