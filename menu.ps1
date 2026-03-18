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

    $width = $Host.UI.RawUI.WindowSize.Width
    $title = "WINOPT TOOL"

    # Tính padding để căn giữa
    $padding = [math]::Floor(($width - $title.Length) / 2)

    # Tạo dòng viền full width
    $line = "=" * $width

    Write-Host $line -ForegroundColor DarkGray
    Write-Host (" " * $padding + $title) -ForegroundColor Cyan
    Write-Host $line -ForegroundColor DarkGray
    Write-Host ""
}

function Show-Menu {

    Header

    $width = $Host.UI.RawUI.WindowSize.Width
    $menuWidth = 80   # chỉnh độ rộng khung
    $leftPadding = [math]::Floor(($width - $menuWidth) / 2)

    function Draw-Line($left = "", $right = "") {
        $innerWidth = $menuWidth - 4
        $half = [math]::Floor($innerWidth / 2)

        $leftText  = $left.PadRight($half)
        $rightText = $right.PadRight($half)

        Write-Host (" " * $leftPadding + "| " + $leftText + $rightText + " |")
    }

    # Top border
    Write-Host (" " * $leftPadding + "+" + ("-" * ($menuWidth - 2)) + "+")

    # ===== CONTENT =====
    Draw-Line "System Cleanup"         "Repair Tools"
    Draw-Line "[1] Clean Temp"         "[7] Repair Windows (SFC)"
    Draw-Line "[2] Clear Prefetch"     "[8] DISM Repair"
    Draw-Line "[3] Clean Update Cache" "[9] Full Windows Repair"
    Draw-Line "[4] Clear Recycle Bin"  ""
    Draw-Line "[5] Clean Logs"         ""
    Draw-Line "" ""

    Draw-Line "Network Tools"          "Windows Tools"
    Draw-Line "[10] Flush DNS"         "[20] Task Manager"
    Draw-Line "[11] Network Reset"     "[21] Control Panel"
    Draw-Line "[12] Renew IP"          "[22] Device Manager"
    Draw-Line "[13] Ping Test"         "[23] Services"
    Draw-Line ""                       "[24] Disk Management"
    Draw-Line ""                       "[25] System Properties"
    Draw-Line ""                       "[26] Startup Apps"
    Draw-Line ""                       "[27] SystemInfo"
    Draw-Line ""                       "[28] System Info GUI"
    Draw-Line "" ""

    Draw-Line "Install Tools"          ""
    Draw-Line "[40] Chrome"            ""
    Draw-Line "[41] Edge"              ""
    Draw-Line "[42] Firefox"           ""
    Draw-Line "[50] Office 365"        ""
    Draw-Line "" ""

    Draw-Line "[0] Exit"               ""

    # Bottom border
    Write-Host (" " * $leftPadding + "+" + ("-" * ($menuWidth - 2)) + "+")

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
