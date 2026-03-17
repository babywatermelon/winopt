$host.UI.RawUI.WindowTitle = "WinOpt - Windows Optimization Tool"

# ===== LOAD MODULES (FIX TEMP PATH) =====
$base = "$env:TEMP\winopt"
$modules = Get-ChildItem "$base\modules\*.ps1"

foreach ($module in $modules) {
    . $module.FullName
}

# ===== UI =====

function Pause {
    Write-Host ""
    Read-Host "Press Enter to continue"
}

function Header {
    Clear-Host
    Write-Host "=====================================" -ForegroundColor DarkGray
    Write-Host "              WINOPT TOOL            " -ForegroundColor Cyan
    Write-Host "=====================================" -ForegroundColor DarkGray
    Write-Host ""
}

function Show-Menu {

    Header

    Write-Host "System Cleanup" -ForegroundColor Yellow
    Write-Host "[1] Clean Temp"
    Write-Host "[2] Clear Prefetch"
    Write-Host "[3] Clean Windows Update Cache"
    Write-Host "[4] Clear Recycle Bin"
    Write-Host "[5] Clean Windows Logs"

    Write-Host ""
    Write-Host "Repair Tools" -ForegroundColor Yellow
    Write-Host "[7] Repair Windows (SFC)"
    Write-Host "[8] DISM Repair"
    Write-Host "[9] Full Windows Repair"

    Write-Host ""
    Write-Host "Network Tools" -ForegroundColor Yellow
    Write-Host "[10] Flush DNS"
    Write-Host "[11] Network Reset"
    Write-Host "[12] Renew IP"
    Write-Host "[13] Ping Test"

    Write-Host ""
    Write-Host "Windows Tools" -ForegroundColor Yellow
    Write-Host "[20] Open Task Manager"
    Write-Host "[21] Open Control Panel"
    Write-Host "[22] Open Device Manager"
    Write-Host "[23] Open Services"
    Write-Host "[24] Open Disk Management"
    Write-Host "[25] Open System Properties"
    Write-Host "[26] Open Startup Apps"
    Write-Host "[27] Open SystemInfo"
    Write-Host "[28] Show System Info GUI"

    Write-Host ""
    Write-Host "Install Tools" -ForegroundColor Yellow
    Write-Host "[40] Install Google Chrome"
    Write-Host "[41] Install Microsoft Edge"
    Write-Host "[42] Install Mozilla Firefox"
    Write-Host "[50] Install Office 365"

    Write-Host ""
    Write-Host "[0] Exit"
    Write-Host ""
}

# ===== MAIN LOOP =====

while ($true) {

    Show-Menu

    Write-Host "Select option: " -NoNewline -ForegroundColor Cyan
    $choice = Read-Host

    try {

        switch ($choice) {

            # Cleanup
            "1" { Clean-Temp }
            "2" { Clean-Prefetch }
            "3" { Clean-WindowsUpdate }
            "4" { Clear-Recycle }
            "5" { Clean-WindowsLogs }

            # Repair
            "7" { Repair-SFC }
            "8" { Repair-DISM }
            "9" { Repair-Full }

            # Network
            "10" { Flush-DNS }
            "11" { Network-Reset }
            "12" { Renew-IP }
            "13" { Ping-Test }

            # Windows Tools
            "20" { Open-TaskManager }
            "21" { Open-ControlPanel }
            "22" { Open-DeviceManager }
            "23" { Open-Services }
            "24" { Open-DiskManagement }
            "25" { Open-SystemProperties }
            "26" { Open-StartupApps }
            "27" { Open-SystemInfo }
            "28" { Show-SystemInfoGUI }

            # Install Tools
            "40" { Install-Chrome }
            "41" { Install-Edge }
            "42" { Install-Firefox }
            "50" { Install-Office }

            # Exit
            "0" {
                Write-Host "Exiting WinOpt..." -ForegroundColor Yellow
                Start-Sleep 1
                break
            }

            default {
                Write-Host "Invalid option!" -ForegroundColor Red
            }
        }

    }
    catch {
        Write-Host ""
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    }

    Pause
}
