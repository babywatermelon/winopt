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
    Write-Host "`n--- Dang BAT LAI Windows Update (Reset toan bo) ---" -ForegroundColor Cyan

    # 1. Reset registry chặn Update
    $regPaths = @(
        "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU",
        "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
    )
    foreach ($path in $regPaths) {
        if (Test-Path $path) {
            Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    # Xóa Pause Updates
    $uxPath = "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings"
    if (Test-Path $uxPath) {
        Remove-ItemProperty -Path $uxPath -Name "PauseUpdatesExpiryTime" -ErrorAction SilentlyContinue
    }

    # 2. Khôi phục các service quan trọng về Automatic
    $services = @("wuauserv", "bits", "dosvc", "UsoSvc", "WaaSMedicSvc", "CryptSvc", "msiserver")
    foreach ($svc in $services) {
        try {
            Set-Service -Name $svc -StartupType Automatic -ErrorAction Stop
            Write-Host "Service $svc da set Automatic" -ForegroundColor Gray
        } catch {
            Write-Host "Khong the set $svc : $($_.Exception.Message)" -ForegroundColor Yellow
        }
    }

    # 3. Reset Windows Update Components (rất quan trọng)
    Write-Host "Dang reset Windows Update cache..." -ForegroundColor Yellow
    Stop-Service -Name wuauserv, bits, cryptSvc, msiserver -Force -ErrorAction SilentlyContinue

    $folders = @("$env:windir\SoftwareDistribution", "$env:windir\System32\catroot2")
    foreach ($folder in $folders) {
        if (Test-Path $folder) {
            Rename-Item $folder "$folder.old" -Force -ErrorAction SilentlyContinue
        }
    }

    # 4. Bật lại service
    Start-Service -Name bits, cryptSvc, msiserver -ErrorAction SilentlyContinue
    Start-Service -Name wuauserv -ErrorAction SilentlyContinue

    # 5. Bật lại Scheduled Tasks
    Get-ScheduledTask -TaskPath "\Microsoft\Windows\WindowsUpdate\" -ErrorAction SilentlyContinue | Enable-ScheduledTask -ErrorAction SilentlyContinue
    Get-ScheduledTask -TaskPath "\Microsoft\Windows\UpdateOrchestrator\" -ErrorAction SilentlyContinue | Enable-ScheduledTask -ErrorAction SilentlyContinue

    Write-Host "`nTHANH CONG: Da reset va bat lai Windows Update!" -ForegroundColor Green
    Write-Host "Vui long RESTART may ngay bay gio de ap dung." -ForegroundColor Magenta
    Write-Host "Sau khi restart, mo Settings > Windows Update > Check for updates de kich hoat." -ForegroundColor Cyan
}
