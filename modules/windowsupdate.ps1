# ============================================================
# MODULE: WINDOWS CONTROL (UPDATE, DEFENDER, FIREWALL)
# ============================================================

# 1. CHỨC NĂNG: WINDOWS UPDATE
function Disable-WindowsUpdate {
    Write-Host "`n--- Dang tat Windows Update triet de ---" -ForegroundColor Yellow
    $services = @("wuauserv", "bits", "dosvc", "UsoSvc")
    foreach ($service in $services) {
        Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
        Set-Service -Name $service -StartupType Disabled -ErrorAction SilentlyContinue
    }
    # Registry de chan tu dong Update
    $regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    if (!(Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    Set-ItemProperty -Path $regPath -Name "NoAutoUpdate" -Value 1 -ErrorAction SilentlyContinue
    Write-Host "THANH CONG: Windows Update da bi vo hieu hoa." -ForegroundColor Green
}

function Enable-WindowsUpdate {
    Write-Host "`n--- Dang bat lai Windows Update ---" -ForegroundColor Cyan
    $services = @("wuauserv", "bits", "dosvc", "UsoSvc")
    foreach ($service in $services) {
        Set-Service -Name $service -StartupType Automatic -ErrorAction SilentlyContinue
        Start-Service -Name $service -ErrorAction SilentlyContinue
    }
    $regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    Remove-ItemProperty -Path $regPath -Name "NoAutoUpdate" -ErrorAction SilentlyContinue
    Write-Host "THANH CONG: Windows Update da duoc bat." -ForegroundColor Green
}


