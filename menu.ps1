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

function Center-Text($text) {
    $width = $Host.UI.RawUI.WindowSize.Width
    $pad = [math]::Floor(($width - $text.Length) / 2)
    if ($pad -lt 0) { $pad = 0 }
    return (" " * $pad) + $text
}

function Header {
    Clear-Host

    Write-Host (Center-Text "============================================") -ForegroundColor DarkGray
    Write-Host (Center-Text "WINOPT TOOL") -ForegroundColor Cyan
    Write-Host (Center-Text "Windows Optimization Utility") -ForegroundColor DarkGray
    Write-Host (Center-Text "============================================") -ForegroundColor DarkGray
    Write-Host ""
}

function Show-Menu {

    Header

    Write-Host (Center-Text "[ SYSTEM CLEANUP ]") -ForegroundColor Yellow
    Write-Host (Center-Text "1. Clean Temp             2. Clear Prefetch")
    Write-Host (Center-Text "3. Windows Update Cache   4. Recycle Bin")
    Write-Host (Center-Text "5. Windows Logs")
    Write-Host ""

    Write-Host (Center-Text "[ REPAIR TOOLS ]") -ForegroundColor Yellow
    Write-Host (Center-Text "7. SFC Scan               8. DISM Repair")
    Write-Host (Center-Text "9. Full Windows Repair")
    Write-Host ""

    Write-Host (Center-Text "[ NETWORK TOOLS ]") -ForegroundColor Yellow
    Write-Host (Center-Text "10. Flush DNS             11. Network Reset")
    Write-Host (Center-Text "12. Renew IP              13. Ping Test")
    Write-Host ""

    Write-Host (Center-Text "[ WINDOWS TOOLS ]") -ForegroundColor Yellow
    Write-Host (Center-Text "20. Task Manager          21. Control Panel")
    Write-Host (Center-Text "22. Device Manager        23. Services")
    Write-Host (Center-Text "24. Disk Management       25. System Properties")
    Write-Host (Center-Text "26. Startup Apps          27. System Info")
    Write-Host (Center-Text "28. System Info GUI")
    Write-Host ""

    Write-Host (Center-Text "[ INSTALL TOOLS ]") -ForegroundColor Yellow
    Write-Host (Center-Text "40. Google Chrome         41. Microsoft Edge")
    Write-Host (Center-Text "42. Mozilla Firefox       50. Office 365")
    Write-Host ""

    Write-Host (Center-Text "0. Exit") -ForegroundColor Red
    Write-Host ""

    Write-Host (Center-Text "Select option: ") -NoNewline -ForegroundColor Cyan
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
