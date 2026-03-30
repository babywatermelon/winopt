Clear-Host
Write-Host "Loading WinOpt Tool..." -ForegroundColor Cyan

$base = "$env:TEMP\winopt"
$modules = "$base\modules"

if (Test-Path $base) { Remove-Item -Path $base -Recurse -Force -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Path $modules -Force | Out-Null

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# Download các module khác (trừ windowsupdate)
$moduleList = @("clean", "network", "repair", "tools", "install", "uninstall", "security", "gaming")

foreach ($m in $moduleList) {
    $url = "https://raw.githubusercontent.com/babywatermelon/winopt/main/modules/$m.ps1"
    $out = "$modules\$m.ps1"
    try {
        Invoke-WebRequest $url -OutFile $out -UseBasicParsing
        Write-Host "✅ Downloaded: $m.ps1" -ForegroundColor Green
    } catch {
        Write-Host "❌ Error: $m.ps1" -ForegroundColor Red
    }
}

Write-Host "Creating windowsupdate.ps1 (Full & Fixed)..." -ForegroundColor Magenta

# ================== WINDOWS UPDATE MODULE HOÀN CHỈNH ==================
$wuContent = @'
# =============================================
# WinOpt - WINDOWS UPDATE CONTROL (CỰC MẠNH)
# =============================================

function Get-WindowsUpdateStatus {
    Write-Host "`n" -NoNewline
    Write-Host "═" * 80 -ForegroundColor DarkGray
    Write-Host "               TRẠNG THÁI WINDOWS UPDATE HIỆN TẠI" -ForegroundColor Cyan
    Write-Host "═" * 80 -ForegroundColor DarkGray

    $services = @('wuauserv', 'bits', 'WaaSMedicSvc', 'UsoSvc')
    foreach ($svc in $services) {
        $s = Get-Service -Name $svc -ErrorAction SilentlyContinue
        if ($s) {
            $color = if ($s.Status -eq 'Running') { 'Green' } else { 'Red' }
            Write-Host "   Service $svc`t: $($s.Status) (Startup: $($s.StartType))" -ForegroundColor $color
        }
    }

    $key = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    $noAuto = (Get-ItemProperty -Path $key -Name "NoAutoUpdate" -ErrorAction SilentlyContinue).NoAutoUpdate
    if ($noAuto -eq 1) {
        Write-Host "   Registry NoAutoUpdate   : BỊ KHÓA" -ForegroundColor Red
    } else {
        Write-Host "   Registry NoAutoUpdate   : Hoạt động bình thường" -ForegroundColor Green
    }
    Write-Host "═" * 80 -ForegroundColor DarkGray
}

function Disable-WindowsUpdate {
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "❌ PHẢI CHẠY TOOL VỚI QUYỀN ADMINISTRATOR!" -ForegroundColor Red
        return
    }

    Write-Host "`n🚫 ĐANG TẮT WINDOWS UPDATE CỰC MẠNH..." -ForegroundColor Red
    Get-WindowsUpdateStatus

    $services = @('wuauserv', 'bits', 'WaaSMedicSvc', 'UsoSvc')
    foreach ($svc in $services) {
        if (Get-Service -Name $svc -ErrorAction SilentlyContinue) {
            Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
            Set-Service -Name $svc -StartupType Disabled
            Write-Host "   ✓ $svc → Disabled" -ForegroundColor DarkRed
        }
    }

    $binaries = @{
        "C:\Windows\System32\usoclient.exe"          = "usoclient.exe.disabled"
        "C:\Windows\System32\UsoClientUxBroker.exe" = "UsoClientUxBroker.exe.disabled"
        "C:\Windows\System32\WaaSMedicAgent.exe"    = "WaaSMedicAgent.exe.disabled"
    }
    foreach ($src in $binaries.Keys) {
        $dst = Join-Path (Split-Path $src) $binaries[$src]
        if (Test-Path $src) {
            Rename-Item -Path $src -NewName $binaries[$src] -Force -ErrorAction SilentlyContinue
            Write-Host "   ✓ Đổi tên $(Split-Path $src -Leaf) → .disabled" -ForegroundColor DarkRed
        }
    }

    $regPaths = @("HKLM:\SYSTEM\CurrentControlSet\Services\wuauserv","HKLM:\SYSTEM\CurrentControlSet\Services\bits","HKLM:\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc","HKLM:\SYSTEM\CurrentControlSet\Services\UsoSvc")
    foreach ($key in $regPaths) {
        if (Test-Path $key) { icacls $key /deny "SYSTEM:(W)" /T | Out-Null }
    }

    $AUPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    if (-not (Test-Path $AUPath)) { New-Item -Path $AUPath -Force | Out-Null }
    Set-ItemProperty -Path $AUPath -Name "NoAutoUpdate" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $AUPath -Name "AUOptions" -Value 1 -Type DWord -Force

    Write-Host "`n✅ WINDOWS UPDATE ĐÃ TẮT HOÀN TOÀN!" -ForegroundColor Green
    Get-WindowsUpdateStatus
}

function Enable-WindowsUpdate {
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "❌ PHẢI CHẠY TOOL VỚI QUYỀN ADMINISTRATOR!" -ForegroundColor Red
        return
    }

    Write-Host "`n✅ ĐANG BẬT LẠI WINDOWS UPDATE..." -ForegroundColor Green
    Get-WindowsUpdateStatus

    $regPaths = @("HKLM:\SYSTEM\CurrentControlSet\Services\wuauserv","HKLM:\SYSTEM\CurrentControlSet\Services\bits","HKLM:\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc","HKLM:\SYSTEM\CurrentControlSet\Services\UsoSvc")
    foreach ($key in $regPaths) {
        if (Test-Path $key) { icacls $key /remove:d "SYSTEM" /T | Out-Null }
    }

    $binaries = @{
        "C:\Windows\System32\usoclient.exe.disabled"          = "usoclient.exe"
        "C:\Windows\System32\UsoClientUxBroker.exe.disabled" = "UsoClientUxBroker.exe"
        "C:\Windows\System32\WaaSMedicAgent.exe.disabled"    = "WaaSMedicAgent.exe"
    }
    foreach ($disabled in $binaries.Keys) {
        $original = Join-Path (Split-Path $disabled) $binaries[$disabled]
        if (Test-Path $disabled) {
            Rename-Item -Path $disabled -NewName $binaries[$disabled] -Force -ErrorAction SilentlyContinue
            Write-Host "   ✓ Khôi phục $(Split-Path $original -Leaf)" -ForegroundColor Green
        }
    }

    $services = @('wuauserv', 'bits', 'WaaSMedicSvc', 'UsoSvc')
    foreach ($svc in $services) {
        if (Get-Service -Name $svc -ErrorAction SilentlyContinue) {
            Set-Service -Name $svc -StartupType Manual
            Start-Service -Name $svc -ErrorAction SilentlyContinue
        }
    }

    $AUPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    if (Test-Path $AUPath) {
        Remove-ItemProperty -Path $AUPath -Name "NoAutoUpdate" -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $AUPath -Name "AUOptions" -ErrorAction SilentlyContinue
    }

    Write-Host "`n✅ WINDOWS UPDATE ĐÃ BẬT LẠI HOÀN TOÀN!" -ForegroundColor Green
    Get-WindowsUpdateStatus
}
'@

$wuContent | Out-File -FilePath "$modules\windowsupdate.ps1" -Encoding UTF8

Write-Host "✅ windowsupdate.ps1 đã được tạo đầy đủ" -ForegroundColor Green
Write-Host "Starting WinOpt..." -ForegroundColor Cyan

powershell -ExecutionPolicy Bypass -File "$base\menu.ps1"
