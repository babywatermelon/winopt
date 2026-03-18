$host.UI.RawUI.WindowTitle = "WinOpt - Windows Optimization Tool"

# ===== LOAD MODULES =====
$base = "$env:TEMP\winopt"
$modules = Get-ChildItem "$base\modules\*.ps1" -ErrorAction SilentlyContinue

foreach ($module in $modules) {
    . $module.FullName
}

# ===== UI CORE =====

function Pause {
    Write-Host ""
    Read-Host "Press Enter to continue"
}

function Header {
    Clear-Host

    $width = $Host.UI.RawUI.WindowSize.Width
    $title = " WINOPT TOOL "

    $padding = [math]::Floor(($width - $title.Length) / 2)
    $line = "=" * $width

    Write-Host $line -ForegroundColor DarkGray
    Write-Host (" " * $padding + $title) -ForegroundColor Cyan
    Write-Host $line -ForegroundColor DarkGray
    Write-Host ""
}

# ===== DRAW LINE =====
function Draw-Line {
    param(
        $left,
        $right,
        $menuWidth,
        $leftPadding
    )

    $innerWidth = $menuWidth - 4
    $half = [math]::Floor($innerWidth / 2)

    $leftText  = ($left  | Out-String).Trim().PadRight($half)
    $rightText = ($right | Out-String).Trim().PadRight($half)

    Write-Host (" " * $leftPadding + "| ") -NoNewline -ForegroundColor DarkGray
    Write-Host $leftText -NoNewline -ForegroundColor Green
    Write-Host $rightText -NoNewline -ForegroundColor Yellow
    Write-Host " |" -ForegroundColor DarkGray
}

# ===== DRAW SECTION =====
function Draw-Section {
    param(
        $left,
        $right,
        $menuWidth,
        $leftPadding
    )

    $innerWidth = $menuWidth - 4
    $half = [math]::Floor($innerWidth / 2)

    $leftText  = ($left  | Out-String).Trim().PadRight($half)
    $rightText = ($right | Out-String).Trim().PadRight($half)

    Write-Host (" " * $leftPadding + "| ") -NoNewline -ForegroundColor DarkGray
    Write-Host $leftText -NoNewline -ForegroundColor Cyan
    Write-Host $rightText -NoNewline -ForegroundColor Cyan
    Write-Host " |" -ForegroundColor DarkGray
}

# ===== MENU =====
function Show-Menu {

    Header

    $width = $Host.UI.RawUI.WindowSize.Width
    $menuWidth = 80
    $leftPadding = [math]::Floor(($width - $menuWidth) / 2)

    # Top border
    Write-Host (" " * $leftPadding + "+" + ("-" * ($menuWidth - 2)) + "+") -ForegroundColor DarkGray

    # CONTENT
    Draw-Section "System Cleanup" "Repair Tools" $menuWidth $leftPadding
    Draw-Line "[1] Clean Temp" "[7] Repair Windows (SFC)" $menuWidth $leftPadding
    Draw-Line "[2] Clear Prefetch" "[8] DISM Repair" $menuWidth $leftPadding
    Draw-Line "[3] Clean Update Cache" "[9] Full Windows Repair" $menuWidth $leftPadding
    Draw-Line "[4] Clear Recycle Bin" "" $menuWidth $leftPadding
    Draw-Line "[5] Clean Logs" "" $menuWidth $leftPadding
    Draw-Line "" "" $menuWidth $leftPadding

    Draw-Section "Network Tools" "Windows Tools" $menuWidth $leftPadding
    Draw-Line "[10] Flush DNS" "[20] Task Manager" $menuWidth $leftPadding
    Draw-Line "[11] Network Reset" "[21] Control Panel" $menuWidth $leftPadding
    Draw-Line "[12] Renew IP" "[22] Device Manager" $menuWidth $leftPadding
    Draw-Line "[13] Ping Test" "[23] Services" $menuWidth $leftPadding
    Draw-Line "" "[24] Disk Management" $menuWidth $leftPadding
    Draw-Line "" "[25] System Properties" $menuWidth $leftPadding
    Draw-Line "" "[26] Startup Apps" $menuWidth $leftPadding
    Draw-Line "" "[27] SystemInfo" $menuWidth $leftPadding
    Draw-Line "" "[28] System Info GUI" $menuWidth $leftPadding
    Draw-Line "" "" $menuWidth $leftPadding

    Draw-Section "Install Tools" "" $menuWidth $leftPadding
    Draw-Line "[40] Chrome" "" $menuWidth $leftPadding
    Draw-Line "[41] Edge" "" $menuWidth $leftPadding
    Draw-Line "[42] Firefox" "" $menuWidth $leftPadding
    Draw-Line "[50] Office 365" "" $menuWidth $leftPadding
    Draw-Line "" "" $menuWidth $leftPadding

    Draw-Line "[0] Exit" "" $menuWidth $leftPadding

    # Bottom border
    Write-Host (" " * $leftPadding + "+" + ("-" * ($menuWidth - 2)) + "+") -ForegroundColor DarkGray

    Write-Host ""
}

# ===== MAIN LOOP =====
while ($true) {

    Show-Menu

    Write-Host "Select option: " -NoNewline -ForegroundColor Cyan
    $choice = Read-Host

    try {
        switch ($choice) {

            "1" { Clean-Temp }
            "2" { Clean-Prefetch }
            "3" { Clean-WindowsUpdate }
            "4" { Clear-Recycle }
            "5" { Clean-WindowsLogs }

            "7" { Repair-SFC }
            "8" { Repair-DISM }
            "9" { Repair-Full }

            "10" { Flush-DNS }
            "11" { Network-Reset }
            "12" { Renew-IP }
            "13" { Ping-Test }

            "20" { Open-TaskManager }
            "21" { Open-ControlPanel }
            "22" { Open-DeviceManager }
            "23" { Open-Services }
            "24" { Open-DiskManagement }
            "25" { Open-SystemProperties }
            "26" { Open-StartupApps }
            "27" { Open-SystemInfo }
            "28" { Show-SystemInfoGUI }

            "40" { Install-Chrome }
            "41" { Install-Edge }
            "42" { Install-Firefox }
            "50" { Install-Office }

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
