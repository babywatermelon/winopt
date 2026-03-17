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
        "============================================",
        "                WINOPT TOOL                 ",
        "        Windows Optimization Utility        ",
        "============================================",
        ""
    )

    Show-CenteredBlock $header
}

function Show-Menu {

    Header

    $menu = @(
        "[ SYSTEM CLEANUP ]",
        " 1. Clean Temp             2. Clear Prefetch",
        " 3. Windows Update Cache   4. Recycle Bin",
        " 5. Windows Logs",
        "",
        "[ REPAIR TOOLS ]",
        " 7. SFC Scan               8. DISM Repair",
        " 9. Full Windows Repair",
        "",
        "[ NETWORK TOOLS ]",
        "10. Flush DNS             11. Network Reset",
        "12. Renew IP              13. Ping Test",
        "",
        "[ WINDOWS TOOLS ]",
        "20. Task Manager          21. Control Panel",
        "22. Device Manager        23. Services",
        "24. Disk Management       25. System Properties",
        "26. Startup Apps          27. System Info",
        "28. System Info GUI",
        "",
        "[ INSTALL TOOLS ]",
        "40. Google Chrome         41. Microsoft Edge",
        "42. Mozilla Firefox       50. Office 365",
        "",
        "0. Exit"
    )

    Show-CenteredBlock $menu

    Write-Host ""
    Write-Host "Select option: " -NoNewline -ForegroundColor Cyan
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
