# ============================================================
# MODULE: SECURITY CONTROL (Defender + Firewall)
# ============================================================

function Set-Defender {
    param([string]$Status)  # "Enable" or "Disable"

    if ($Status -eq "Disable") {
        Write-Host "`n--- TAT Windows Defender (Tam thoi) ---" -ForegroundColor Yellow
        
        # Tat Real-time Protection qua Registry (hieu qua hon)
        $regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender"
        if (!(Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
        Set-ItemProperty -Path $regPath -Name "DisableAntiSpyware" -Value 1 -Type DWord -Force
        
        # Tat qua cmdlet (Windows 11)
        Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue
        
        Write-Host "Windows Defender da bi TAT." -ForegroundColor Green
        Write-Host "Luu y: Defender co the tu bat lai sau reboot hoac update." -ForegroundColor Cyan
    }
    else {
        Write-Host "`n--- BAT Windows Defender ---" -ForegroundColor Cyan
        
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -ErrorAction SilentlyContinue
        Set-MpPreference -DisableRealtimeMonitoring $false -ErrorAction SilentlyContinue
        
        Write-Host "Windows Defender da duoc BAT." -ForegroundColor Green
    }
}

function Set-RealTimeProtection {
    param([string]$Status)

    if ($Status -eq "Disable") {
        Write-Host "`n--- TAT Real-time Protection ---" -ForegroundColor Yellow
        Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue
        Write-Host "Real-time Protection da bi TAT." -ForegroundColor Green
    }
    else {
        Write-Host "`n--- BAT Real-time Protection ---" -ForegroundColor Cyan
        Set-MpPreference -DisableRealtimeMonitoring $false -ErrorAction SilentlyContinue
        Write-Host "Real-time Protection da duoc BAT." -ForegroundColor Green
    }
}

function Set-Firewall {
    param([string]$Status)

    if ($Status -eq "Disable") {
        Write-Host "`n--- TAT Windows Firewall ---" -ForegroundColor Yellow
        Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False -ErrorAction SilentlyContinue
        Write-Host "Windows Firewall da bi TAT (tat ca cac profile)." -ForegroundColor Green
    }
    else {
        Write-Host "`n--- BAT Windows Firewall ---" -ForegroundColor Cyan
        Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True -ErrorAction SilentlyContinue
        Write-Host "Windows Firewall da duoc BAT." -ForegroundColor Green
    }
}

# Hàm bổ sung tiện ích
function Show-DefenderStatus {
    $status = Get-MpPreference | Select-Object DisableRealtimeMonitoring, RealTimeScanDirection
    Write-Host "`nTrang thai Defender hien tai:" -ForegroundColor Cyan
    $status | Format-List
}
