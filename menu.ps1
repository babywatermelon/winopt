$host.UI.RawUI.WindowTitle = "WinOpt - Windows Optimization Tool"

# ===== LOAD MODULES =====
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

function Show-CenteredBlock($lines) {
    $width = $Host.UI.RawUI.WindowSize.Width

    foreach ($line in $lines) {
        $pad = [math]::Floor(($width - $line.Length) / 2)
        if ($pad -lt 0) { $pad = 0 }
        Write-Host (" " * $pad + $line)
    }
}

function Header {
    Clear-Host

    $header = @(
        "████████████████████████████████████████████",
        "          WINOPT - OPTIMIZATION TOOL         ",
        "        Windows Optimization Utility         ",
        "████████████████████████████████████████████",
        ""
    )

    foreach ($line in $header) {
        Write-Host $line -ForegroundColor Green
    }
}

function Show-Menu {
    Header

    Write-Host "[ SYSTEM CLEANUP ]" -ForegroundColor Cyan
    Write-Host " 1. Clean Temp             2. Clear Prefetch" -ForegroundColor Yellow
    Write-Host " 3. Windows Update Cache   4. Recycle Bin" -ForegroundColor Yellow
    Write-Host " 5. Windows Logs" -ForegroundColor Yellow
    Write-Host ""

    Write-Host "[ REPAIR TOOLS ]" -ForegroundColor Cyan
    Write-Host " 7. SFC Scan               8. DISM Repair" -ForegroundColor Yellow
    Write-Host " 9. Full Windows Repair" -ForegroundColor Yellow
    Write-Host ""

    Write-Host "[ NETWORK TOOLS ]" -ForegroundColor Cyan
    Write-Host "10. Flush DNS             11. Network Reset" -ForegroundColor Yellow
    Write-Host "12. Renew IP              13. Ping Test" -ForegroundColor Yellow
    Write-Host ""

    Write-Host "[ WINDOWS TOOLS ]" -ForegroundColor Cyan
    Write-Host "20. Task Manager          21. Control Panel" -ForegroundColor Yellow
    Write-Host "22. Device Manager        23. Services" -ForegroundColor Yellow
    Write-Host "24. Disk Management       25. System Properties" -ForegroundColor Yellow
    Write-Host "26. Startup Apps          27. System Info" -ForegroundColor Yellow
    Write-Host "28. System Info GUI" -ForegroundColor Yellow
    Write-Host ""

    Write-Host "[ INSTALL TOOLS ]" -ForegroundColor Cyan
    Write-Host "40. Google Chrome         41. Microsoft Edge" -ForegroundColor Yellow
    Write-Host "42. Mozilla Firefox       50. Office 365" -ForegroundColor Yellow
    Write-Host ""

    Write-Host "0. Exit" -ForegroundColor Red
    Write-Host ""
    Write-Host "Select option: " -NoNewline -ForegroundColor Magenta
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
                return
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

    if ($choice -ne "0") {
        Pause
    }
}
