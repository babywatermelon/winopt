# 2. CHỨC NĂNG: WINDOWS DEFENDER & VIRUS PROTECTION
function Set-Defender {
    param($Status)
    Write-Host "`n--- $Status Windows Defender ---" -ForegroundColor Yellow
    $regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender"
    if ($Status -eq "Disable") {
        Set-ItemProperty -Path $regPath -Name "DisableAntiSpyware" -Value 1 -ErrorAction SilentlyContinue
        Write-Host "DA GUI LENH TAT: Hay khoi dong lai may de ap dung." -ForegroundColor Red
    } else {
        Set-ItemProperty -Path $regPath -Name "DisableAntiSpyware" -Value 0 -ErrorAction SilentlyContinue
        Write-Host "THANH CONG: Defender da duoc kich hoat lai." -ForegroundColor Green
    }
}

function Set-RealTimeProtection {
    param($Status)
    Write-Host "`n--- $Status Real-time Protection ---" -ForegroundColor Yellow
    try {
        if ($Status -eq "Disable") {
            Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction Stop
            Write-Host "THANH CONG: Da tat quet virus thoi gian thuc." -ForegroundColor Red
        } else {
            Set-MpPreference -DisableRealtimeMonitoring $false -ErrorAction Stop
            Write-Host "THANH CONG: Da bat quet virus thoi gian thuc." -ForegroundColor Green
        }
    } catch {
        Write-Host "LOI: Khong the thuc hien. Co the do 'Tamper Protection' dang bat trong Windows Security." -ForegroundColor Red
    }
}

# 3. CHỨC NĂNG: WINDOWS FIREWALL
function Set-Firewall {
    param($Status)
    Write-Host "`n--- $Status Windows Firewall ---" -ForegroundColor Yellow
    if ($Status -eq "Disable") {
        Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
        Write-Host "THANH CONG: Tuong lua da bi tat." -ForegroundColor Red
    } else {
        Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
        Write-Host "THANH CONG: Tuong lua da duoc bat." -ForegroundColor Green
    }
}
