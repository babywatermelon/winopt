Clear-Host
Write-Host "Loading WinOpt Tool..." -ForegroundColor Cyan

$base = "$env:TEMP\winopt"
$modules = "$base\modules"

# Xóa thư mục cũ để tải phiên bản mới nhất
if (Test-Path $base) {
    Remove-Item -Path $base -Recurse -Force -ErrorAction SilentlyContinue
}

New-Item -ItemType Directory -Path $modules -Force | Out-Null

Write-Host "Downloading modules from GitHub..." -ForegroundColor DarkGray

# Danh sách module
$moduleList = @("clean", "network", "repair", "tools", "install", "uninstall", "windowsupdate", "security", "gaming")

foreach ($m in $moduleList) {
    $url = "https://raw.githubusercontent.com/babywatermelon/winopt/main/modules/$m.ps1"
    $out = "$modules\$m.ps1"
    
    try {
        Invoke-WebRequest $url -OutFile $out -UseBasicParsing -TimeoutSec 15
        Write-Host "✅ Downloaded: $m.ps1" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Error downloading $m.ps1" -ForegroundColor Red
        Write-Host "   $($_.Exception.Message)" -ForegroundColor Red
    }
}

# === DEBUG WINDOWS UPDATE MODULE ===
Write-Host "`n=== KIỂM TRA WINDOWS UPDATE MODULE ===" -ForegroundColor Yellow

$updateFile = "$modules\windowsupdate.ps1"

if (Test-Path $updateFile) {
    try {
        . $updateFile
        Write-Host "✅ windowsupdate.ps1 loaded successfully" -ForegroundColor Magenta
        
        # Kiểm tra các hàm có tồn tại không
        if (Get-Command Disable-WindowsUpdate -ErrorAction SilentlyContinue) {
            Write-Host "   ✓ Disable-WindowsUpdate tồn tại" -ForegroundColor Green
        } else {
            Write-Host "   ✘ Disable-WindowsUpdate KHÔNG tồn tại" -ForegroundColor Red
        }
        
        if (Get-Command Enable-WindowsUpdate -ErrorAction SilentlyContinue) {
            Write-Host "   ✓ Enable-WindowsUpdate tồn tại" -ForegroundColor Green
        } else {
            Write-Host "   ✘ Enable-WindowsUpdate KHÔNG tồn tại (đây là nguyên nhân lỗi!)" -ForegroundColor Red
        }
        
        if (Get-Command Get-WindowsUpdateStatus -ErrorAction SilentlyContinue) {
            Write-Host "   ✓ Get-WindowsUpdateStatus tồn tại" -ForegroundColor Green
        }
    }
    catch {
        Write-Host "❌ Lỗi khi load windowsupdate.ps1" -ForegroundColor Red
        Write-Host "   $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "❌ Không tìm thấy windowsupdate.ps1 sau khi download" -ForegroundColor Red
}

Write-Host "=== DEBUG HOÀN TẤT ===`n" -ForegroundColor Yellow

Write-Host "Starting WinOpt..." -ForegroundColor Cyan

# Chạy menu
powershell -ExecutionPolicy Bypass -File "$base\menu.ps1"
