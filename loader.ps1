Clear-Host
Write-Host "Loading WinOpt Tool..." -ForegroundColor Cyan

$base = "$env:TEMP\winopt"
$modules = "$base\modules"

# Xóa thư mục cũ
if (Test-Path $base) {
    Remove-Item -Path $base -Recurse -Force -ErrorAction SilentlyContinue
}

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

# Tạo windowsupdate.ps1 (Full)
Write-Host "Creating windowsupdate.ps1 (Full & Fixed)..." -ForegroundColor Magenta

$wuContent = @'
function Get-WindowsUpdateStatus {
    # Dán đầy đủ code Get-WindowsUpdateStatus của bạn vào đây
    Write-Host "`n" -NoNewline
    Write-Host "═" * 80 -ForegroundColor DarkGray
    Write-Host " TRẠNG THÁI WINDOWS UPDATE HIỆN TẠI" -ForegroundColor Cyan
    Write-Host "═" * 80 -ForegroundColor DarkGray
    $services = @('wuauserv', 'bits', 'WaaSMedicSvc', 'UsoSvc')
    foreach ($svc in $services) {
        $s = Get-Service -Name $svc -ErrorAction SilentlyContinue
        if ($s) {
            $color = if ($s.Status -eq 'Running') { 'Green' } else { 'Red' }
            Write-Host " Service $svc`t: $($s.Status) (Startup: $($s.StartType))" -ForegroundColor $color
        }
    }
    $key = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    $noAuto = (Get-ItemProperty -Path $key -Name "NoAutoUpdate" -ErrorAction SilentlyContinue).NoAutoUpdate
    if ($noAuto -eq 1) {
        Write-Host " Registry NoAutoUpdate : BỊ KHÓA" -ForegroundColor Red
    } else {
        Write-Host " Registry NoAutoUpdate : Hoạt động bình thường" -ForegroundColor Green
    }
    Write-Host "═" * 80 -ForegroundColor DarkGray
}

function Disable-WindowsUpdate { ... }   # Dán đầy đủ function Disable
function Enable-WindowsUpdate { ... }    # Dán đầy đủ function Enable
'@   # ← Bạn thay phần ... bằng code thực của 3 function

$wuContent | Out-File -FilePath "$modules\windowsupdate.ps1" -Encoding UTF8

Write-Host "✅ windowsupdate.ps1 đã tạo" -ForegroundColor Green
Write-Host "Starting WinOpt Tool..." -ForegroundColor Cyan

# Chạy trực tiếp menu.ps1 (không ghi đè nữa)
powershell -ExecutionPolicy Bypass -File "$base\menu.ps1"
