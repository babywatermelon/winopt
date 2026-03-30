Clear-Host
Write-Host "Loading WinOpt Tool..." -ForegroundColor Cyan

$base = "$env:TEMP\winopt"
$modules = "$base\modules"

# Xóa thư mục cũ
if (Test-Path $base) {
    Remove-Item -Path $base -Recurse -Force -ErrorAction SilentlyContinue
}

New-Item -ItemType Directory -Path $modules -Force | Out-Null

Write-Host "Downloading modules from GitHub..." -ForegroundColor DarkGray

$moduleList = @("clean", "network", "repair", "tools", "install", "uninstall", "windowsupdate", "security", "gaming")

foreach ($m in $moduleList) {
    $url = "https://raw.githubusercontent.com/babywatermelon/winopt/main/modules/$m.ps1"
    $out = "$modules\$m.ps1"
    
    try {
        Invoke-WebRequest $url -OutFile $out -UseBasicParsing -TimeoutSec 20
        Write-Host "✅ Downloaded: $m.ps1" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Error downloading $m.ps1" -ForegroundColor Red
    }
}

# === FIX EXECUTION POLICY & LOAD MODULES ===
Write-Host "`nSetting Execution Policy for this session..." -ForegroundColor Yellow
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

Write-Host "`n=== KIỂM TRA WINDOWS UPDATE MODULE ===" -ForegroundColor Cyan

$updateFile = "$modules\windowsupdate.ps1"

if (Test-Path $updateFile) {
    try {
        . $updateFile
        Write-Host "✅ windowsupdate.ps1 loaded successfully" -ForegroundColor Magenta

        if (Get-Command Enable-WindowsUpdate -ErrorAction SilentlyContinue) {
            Write-Host "   ✓ Enable-WindowsUpdate sẵn sàng" -ForegroundColor Green
        } else {
            Write-Host "   ✘ Enable-WindowsUpdate KHÔNG tồn tại (file bị cắt)" -ForegroundColor Red
        }
    }
    catch {
        Write-Host "❌ Lỗi load windowsupdate.ps1" -ForegroundColor Red
        Write-Host "   $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "❌ Không tìm thấy windowsupdate.ps1" -ForegroundColor Red
}

Write-Host "=== DEBUG HOÀN TẤT ===`n" -ForegroundColor Cyan

# Tạo file menu.ps1 thủ công (vì file trên GitHub có vấn đề)
Write-Host "Creating menu.ps1 ..." -ForegroundColor DarkGray

$menuContent = @'
# (Dán toàn bộ nội dung menu.ps1 đã sửa của anh vào đây - phần từ $host.UI.RawUI.WindowTitle đến hết vòng while)
'@

$menuContent | Out-File -FilePath "$base\menu.ps1" -Encoding UTF8

Write-Host "Starting WinOpt..." -ForegroundColor Green

# Chạy menu
powershell -ExecutionPolicy Bypass -File "$base\menu.ps1"
