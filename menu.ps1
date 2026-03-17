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
