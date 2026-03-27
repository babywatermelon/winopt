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
    Write-Host "`n--- Dang BAT LAI Windows Update (phien ban day du) ---" -ForegroundColor Cyan

    # 1. Khôi phục các services về trạng thái mặc định
    $services = @("wuauserv", "bits", "dosvc", "UsoSvc", "WaaSMedicSvc")
    foreach ($service in $services) {
        Set-Service -Name $service -StartupType Automatic -ErrorAction SilentlyContinue
        Start-Service -Name $service -ErrorAction SilentlyContinue
        Write-Host "Service $service da duoc bat lai (Automatic)" -ForegroundColor Gray
    }

    # 2. Xóa registry chặn Auto Update
    $regPathAU = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    if (Test-Path $regPathAU) {
        Remove-Item -Path $regPathAU -Recurse -Force -ErrorAction SilentlyContinue
    }

    $regPathWU = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
    if (Test-Path $regPathWU) {
        Remove-ItemProperty -Path $regPathWU -Name "NoAutoUpdate" -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $regPathWU -Name "AUOptions" -ErrorAction SilentlyContinue
    }

    # Xóa Pause Updates đến năm 2099
    $uxPath = "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings"
    if (Test-Path $uxPath) {
        Remove-ItemProperty -Path $uxPath -Name "PauseUpdatesExpiryTime" -ErrorAction SilentlyContinue
    }

    # 3. Bật lại các Scheduled Tasks quan trọng
    Get-ScheduledTask -TaskPath "\Microsoft\Windows\WindowsUpdate\" -ErrorAction SilentlyContinue | Enable-ScheduledTask -ErrorAction SilentlyContinue
    Get-ScheduledTask -TaskPath "\Microsoft\Windows\UpdateOrchestrator\" -ErrorAction SilentlyContinue | Enable-ScheduledTask -ErrorAction SilentlyContinue

    Write-Host "`nTHANH CONG: Windows Update da duoc bat lai!" -ForegroundColor Green
    Write-Host "Khuyen nghi: Restart may de ap dung hoan chinh." -ForegroundColor Cyan
}
