Clear-Host
Write-Host "Loading WinOpt Tool..." -ForegroundColor Cyan

$base = "$env:TEMP\winopt"
$modules = "$base\modules"

# Xóa thư mục cũ
if (Test-Path $base) {
    Remove-Item -Path $base -Recurse -Force -ErrorAction SilentlyContinue
}

# Tạo thư mục
New-Item -ItemType Directory -Path $modules -Force | Out-Null
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

Write-Host "Downloading modules from GitHub..." -ForegroundColor DarkGray

$moduleList = @("clean", "network", "repair", "tools", "install", "uninstall", "security", "gaming", "extension")

foreach ($m in $moduleList) {
    $url = "https://raw.githubusercontent.com/babywatermelon/winopt/main/modules/$m.ps1"
    $out = "$modules\$m.ps1"
    try {
        Invoke-WebRequest $url -OutFile $out -UseBasicParsing
        Write-Host "✅ Downloaded: $m.ps1" -ForegroundColor Green
    } catch {
        Write-Host "❌ Error downloading $m.ps1" -ForegroundColor Red
    }
}

Write-Host "✅ All modules downloaded successfully" -ForegroundColor Green

# Tải menu.ps1 từ GitHub (không tạo thủ công nữa)
Write-Host "Downloading menu.ps1 from GitHub..." -ForegroundColor Cyan

$menuUrl = "https://raw.githubusercontent.com/babywatermelon/winopt/main/menu.ps1"
$menuPath = "$base\menu.ps1"

try {
    Invoke-WebRequest $menuUrl -OutFile $menuPath -UseBasicParsing
    Write-Host "✅ Menu.ps1 downloaded successfully" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to download menu.ps1" -ForegroundColor Red
    Write-Host "Please make sure menu.ps1 exists on your GitHub repository." -ForegroundColor Yellow
    Pause
    exit
}

Write-Host "Starting WinOpt Tool..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor DarkGray

# Chạy menu
powershell -ExecutionPolicy Bypass -File $menuPath
