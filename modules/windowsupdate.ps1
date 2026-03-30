# =============================================
# WinOpt - WINDOWS UPDATE CONTROL
# =============================================

function Get-WindowsUpdateStatus {
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

    # Kiểm tra Registry
    $key = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    $noAuto = (Get-ItemProperty -Path $key -Name "NoAutoUpdate" -ErrorAction SilentlyContinue).NoAutoUpdate
    if ($noAuto -eq 1) {
        Write-Host " Registry NoAutoUpdate : BỊ KHÓA (Windows Update đã tắt)" -ForegroundColor Red
    } else {
        Write-Host " Registry NoAutoUpdate : Đang hoạt động bình thường" -ForegroundColor Green
    }

    # Kiểm tra file bị rename
    $binaries = @('usoclient.exe', 'UsoClientUxBroker.exe', 'WaaSMedicAgent.exe')
    foreach ($bin in $binaries) {
        $disabled = "C:\Windows\System32\$bin.disabled"
        if (Test-Path $disabled) {
            Write-Host " Binary $bin : ĐÃ BỊ VÔ HIỆU HÓA" -ForegroundColor Red
        }
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

    # Dừng và tắt service
    $services = @('wuauserv', 'bits', 'WaaSMedicSvc', 'UsoSvc')
    foreach ($svc in $services) {
        if (Get-Service -Name $svc -ErrorAction SilentlyContinue) {
            Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
            Set-Service -Name $svc -StartupType Disabled
            Write-Host " ✓ $svc → Disabled" -ForegroundColor DarkRed
        }
    }

    # Đổi tên file hệ thống
    $binaries = @{
        "C:\Windows\System32\usoclient.exe" = "usoclient.exe.disabled"
        "C:\Windows\System32\UsoClientUxBroker.exe" = "UsoClientUxBroker.exe.disabled"
        "C:\Windows\System32\WaaSMedicAgent.exe" = "WaaSMedicAgent.exe.disabled"
    }
    foreach ($src in $binaries.Keys) {
        if (Test-Path $src) {
            Rename-Item -Path $src -NewName $binaries[$src] -Force -ErrorAction SilentlyContinue
            Write-Host " ✓ Đổi tên $(Split-Path $src -Leaf) → .disabled" -ForegroundColor DarkRed
        }
    }

    # Khóa Registry
    $regPaths = @(
        "HKLM:\SYSTEM\CurrentControlSet\Services\wuauserv",
        "HKLM:\SYSTEM\CurrentControlSet\Services\bits",
        "HKLM:\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc",
        "HKLM:\SYSTEM\CurrentControlSet\Services\UsoSvc"
    )
    foreach ($key in $regPaths) {
        if (Test-Path $key) {
            icacls $key /deny "SYSTEM:(W)" /T | Out-Null
        }
    }

    # Registry chính
    $AUPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    if (-not (Test-Path $AUPath)) { New-Item -Path $AUPath -Force | Out-Null }
    Set-ItemProperty -Path $AUPath -Name "NoAutoUpdate" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $AUPath -Name "AUOptions" -Value 1 -Type DWord -Force

    Write-Host "`n✅ WINDOWS UPDATE ĐÃ BỊ TẮT HOÀN TOÀN!" -ForegroundColor Green
    Write-Host "Khởi động lại máy để áp dụng hiệu quả nhất." -ForegroundColor Yellow
    Get-WindowsUpdateStatus
}

function Enable-WindowsUpdate {
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "❌ PHẢI CHẠY TOOL VỚI QUYỀN ADMINISTRATOR!" -ForegroundColor Red
        return
    }

    Write-Host "`n✅ ĐANG BẬT LẠI WINDOWS UPDATE..." -ForegroundColor Green
    Get-WindowsUpdateStatus

    # Khôi phục quyền Registry
    $regPaths = @(
        "HKLM:\SYSTEM\CurrentControlSet\Services\wuauserv",
        "HKLM:\SYSTEM\CurrentControlSet\Services\bits",
        "HKLM:\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc",
        "HKLM:\SYSTEM\CurrentControlSet\Services\UsoSvc"
    )
    foreach ($key in $regPaths) {
        if (Test-Path $key) {
            icacls $key /remove:d "SYSTEM" /T | Out-Null
        }
    }

    # Khôi phục file hệ thống
    $binaries = @{
        "C:\Windows\System32\usoclient.exe.disabled" = "usoclient.exe"
        "C:\Windows\System32\UsoClientUxBroker.exe.disabled" = "UsoClientUxBroker.exe"
        "C:\Windows\System32\WaaSMedicAgent.exe.disabled" = "WaaSMedicAgent.exe"
    }
    foreach ($disabled in $binaries.Keys) {
        $original = Join-Path (Split-Path $disabled) $binaries[$disabled]
        if (Test-Path $disabled) {
            Rename-Item -Path $disabled -NewName $binaries[$disabled] -Force -ErrorAction SilentlyContinue
            Write-Host " ✓ Khôi phục $(Split-Path $original -Leaf)" -ForegroundColor Green
        }
    }

    # Khởi động lại service
    $services = @('wuauserv', 'bits', 'WaaSMedicSvc', 'UsoSvc')
    foreach ($svc in $services) {
        if (Get-Service -Name $svc -ErrorAction SilentlyContinue) {
            Set-Service -Name $svc -StartupType Manual
            Start-Service -Name $svc -ErrorAction SilentlyContinue
        }
    }

    # Xóa Registry khóa
    $AUPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    if (Test-Path $AUPath) {
        Remove-ItemProperty -Path $AUPath -Name "NoAutoUpdate" -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $AUPath -Name "AUOptions" -ErrorAction SilentlyContinue
    }

    Write-Host "`n✅ WINDOWS UPDATE ĐÃ ĐƯỢC BẬT LẠI!" -ForegroundColor Green
    Get-WindowsUpdateStatus
}
