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
    Write-Host "`n--- BAT LAI Windows Update (WUB Style - Reset toan bo + Fix Permission) ---" -ForegroundColor Cyan

    # 1. Reset Registry Policy chan Update
    Write-Host "Dang xoa policy chan Windows Update..." -ForegroundColor Yellow
    $regPaths = @(
        "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU",
        "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
    )
    foreach ($path in $regPaths) {
        if (Test-Path $path) { Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue }
    }

    # Xóa Pause Updates đến 2099
    $uxPath = "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings"
    if (Test-Path $uxPath) {
        Remove-ItemProperty -Path $uxPath -Name "PauseUpdatesExpiryTime" -ErrorAction SilentlyContinue
    }

    # 2. Reset Security Descriptor (Permission) cho service - Cách mạnh nhất fix "Access is denied"
    Write-Host "Dang reset quyen (Security Descriptor) cho cac service..." -ForegroundColor Yellow
    try {
        sc.exe sdset wuauserv "D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)" | Out-Null
        sc.exe sdset bits "D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)" | Out-Null
        Write-Host "Da reset permission cho wuauserv va bits" -ForegroundColor Gray
    } catch {
        Write-Host "Khong the reset permission: $($_.Exception.Message)" -ForegroundColor Yellow
    }

    # 3. Set Startup Type = Automatic
    Write-Host "Dang dat Startup Type = Automatic..." -ForegroundColor Yellow
    $services = @("wuauserv", "bits", "cryptSvc", "msiserver", "UsoSvc", "WaaSMedicSvc")
    foreach ($svc in $services) {
        sc.exe config $svc start= auto | Out-Null
        Write-Host "   $svc -> Automatic" -ForegroundColor Gray
    }

    # 4. Reset Windows Update Cache
    Write-Host "Dang reset cache Windows Update..." -ForegroundColor Yellow
    Stop-Service wuauserv, bits, cryptSvc, msiserver -Force -ErrorAction SilentlyContinue

    Remove-Item "$env:windir\SoftwareDistribution\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:windir\System32\catroot2\*" -Recurse -Force -ErrorAction SilentlyContinue

    # 5. Start services
    Start-Service bits, cryptSvc, msiserver -ErrorAction SilentlyContinue
    Start-Service wuauserv -ErrorAction SilentlyContinue

    # 6. Enable Scheduled Tasks
    Get-ScheduledTask -TaskPath "\Microsoft\Windows\WindowsUpdate\" -ErrorAction SilentlyContinue | Enable-ScheduledTask -ErrorAction SilentlyContinue
    Get-ScheduledTask -TaskPath "\Microsoft\Windows\UpdateOrchestrator\" -ErrorAction SilentlyContinue | Enable-ScheduledTask -ErrorAction SilentlyContinue

    Write-Host "`n=== HOAN TAT ===" -ForegroundColor Green
    Write-Host "Da reset va bat lai Windows Update." -ForegroundColor Green
    Write-Host "Vui long RESTART MAY ngay bay gio de ap dung." -ForegroundColor Magenta
    Write-Host "Sau restart, mo Settings > Windows Update > nhan 'Check for updates'." -ForegroundColor Cyan
}
