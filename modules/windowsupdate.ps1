function Disable-WindowsUpdate {
    Write-Host "`n--- Dang tat Windows Update TRIET DE (phien ban nang cao) ---" -ForegroundColor Yellow
    
    # 1. Stop tất cả services liên quan
    $services = @("wuauserv", "bits", "dosvc", "UsoSvc", "WaaSMedicSvc", "WaaSMedicService")
    foreach ($service in $services) {
        Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
        Set-Service -Name $service -StartupType Disabled -ErrorAction SilentlyContinue
        Write-Host "Service $service da duoc tat va set Disabled" -ForegroundColor Gray
    }

    # 2. Registry chặn Auto Update
    $regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    if (!(Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    Set-ItemProperty -Path $regPath -Name "NoAutoUpdate" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "AUOptions" -Value 1 -Type DWord -Force   # 1 = Never check for updates

    # 3. Registry chặn Medic Service và Update Orchestrator
    $paths = @(
        "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate",
        "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings"
    )
    foreach ($p in $paths) {
        if (!(Test-Path $p)) { New-Item -Path $p -Force | Out-Null }
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "PauseUpdatesExpiryTime" -Value "2099-12-31T23:59:59Z" -Type String -Force

    # 4. Disable các Scheduled Tasks quan trọng
    Get-ScheduledTask -TaskPath "\Microsoft\Windows\WindowsUpdate\" -ErrorAction SilentlyContinue | Disable-ScheduledTask -ErrorAction SilentlyContinue
    Get-ScheduledTask -TaskPath "\Microsoft\Windows\UpdateOrchestrator\" -ErrorAction SilentlyContinue | Disable-ScheduledTask -ErrorAction SilentlyContinue

    # 5. Thêm quyền để ngăn Windows tự sửa (tùy chọn nhưng hiệu quả)
    try {
        takeown /F "$env:windir\System32\Tasks\Microsoft\Windows\UpdateOrchestrator" /A /R /D Y | Out-Null
        icacls "$env:windir\System32\Tasks\Microsoft\Windows\UpdateOrchestrator" /grant Administrators:F /T | Out-Null
    } catch {}

    Write-Host "`nTHANH CONG: Windows Update da bi vo hieu hoa TRIET DE!" -ForegroundColor Green
    Write-Host "Khuyen nghi: Restart may de ap dung day du." -ForegroundColor Cyan
}



function Enable-WindowsUpdate {
    Write-Host "`n--- BAT LAI Windows Update (Mimic Manual + Reset) ---" -ForegroundColor Cyan

    # 1. Reset policy
    Write-Host "Xoa policy chan Update..." -ForegroundColor Yellow
    Remove-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Recurse -Force -ErrorAction SilentlyContinue

    # 2. Set Startup Type bằng sc.exe (ổn định hơn Set-Service)
    Write-Host "Dat Startup Type = Automatic..." -ForegroundColor Yellow
    $services = @("wuauserv", "bits", "cryptSvc", "msiserver", "UsoSvc", "WaaSMedicSvc")
    foreach ($svc in $services) {
        sc.exe config $svc start= auto | Out-Null
        Write-Host "   $svc -> Automatic" -ForegroundColor Gray
    }

    # 3. Reset cache (rất quan trọng)
    Write-Host "Reset cache Windows Update..." -ForegroundColor Yellow
    Stop-Service wuauserv, bits, cryptSvc, msiserver -Force -ErrorAction SilentlyContinue

    Remove-Item "$env:windir\SoftwareDistribution\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:windir\System32\catroot2\*" -Recurse -Force -ErrorAction SilentlyContinue

    # 4. Start services (giống như bạn làm thủ công)
    Write-Host "Dang khoi dong services..." -ForegroundColor Yellow
    Start-Service bits, cryptSvc, msiserver -ErrorAction SilentlyContinue
    Start-Service wuauserv -ErrorAction SilentlyContinue

    # 5. Enable tasks
    Get-ScheduledTask -TaskPath "\Microsoft\Windows\WindowsUpdate\" -ErrorAction SilentlyContinue | Enable-ScheduledTask -ErrorAction SilentlyContinue

    Write-Host "`n=== HOAN TAT ===" -ForegroundColor Green
    Write-Host "Tool da thuc hien xong." -ForegroundColor Green
    Write-Host "Vui long RESTART MAY ngay bay gio." -ForegroundColor Magenta
    Write-Host "Sau restart, mo services.msc kiem tra Windows Update co o Automatic va Running khong." -ForegroundColor Cyan
}
