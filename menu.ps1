$host.UI.RawUI.WindowTitle = "WinOpt - Windows Optimization Tool"

# ===== LOAD MODULES =====
$base = "$env:TEMP\winopt"
$modules = Get-ChildItem "$base\modules\*.ps1"
foreach ($module in $modules) {
    . $module.FullName
}

# ===== COLOR FUNCTION =====
function Write-Color($text, $colorCode) {
    Write-Host ("`e[" + $colorCode + "m" + $text + "`e[0m")
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
    $padding = [math]::Floor(($width - $title.Length) / 2)
    $line = "=" * $width

    Write-Color $line 90   # xám nhạt
    Write-Color (" " * $padding + $title) 36   # cyan
    Write-Color $line 90
    Write-Host ""
}

function Show-Menu {
    Header
    $width = $Host.UI.RawUI.WindowSize.Width
    $menuWidth = 80
    $leftPadding = [math]::Floor(($width - $menuWidth) / 2)

    function Draw-Line($left = "", $right = "", $leftColor = 37, $rightColor = 37) {
        $innerWidth = $menuWidth - 4
        $half = [math]::Floor($innerWidth / 2)
        $leftText  = $left.PadRight($half)
        $rightText = $right.PadRight($half)

        $line = (" " * $leftPadding + "| " + $leftText + $rightText + " |")
        # tô màu riêng cho cột trái/phải
        $colored = ("`e[" + $leftColor + "m" + $leftText + "`e[0m" +
                    "`e[" + $rightColor + "m" + $rightText + "`e[0m")
        Write-Host (" " * $leftPadding + "| " + $colored + " |")
    }

    # Top border
    Write-Host (" " * $leftPadding + "+" + ("-" * ($menuWidth - 2)) + "+")

    # ===== CONTENT =====
    Draw-Line "System Cleanup" "Repair Tools" 36 35
    Draw-Line "[1] Clean Temp" "[7] Repair Windows (SFC)" 32 33
    Draw-Line "[2] Clear Prefetch" "[8] DISM Repair" 32 33
    Draw-Line "[3] Clean Update Cache" "[9] Full Windows Repair" 32 33
    Draw-Line "[4] Clear Recycle Bin" "" 32 37
    Draw-Line "[5] Clean Logs" "" 32 37
    Draw-Line "" "" 37 37

    Draw-Line "Network Tools" "Windows Tools" 36 35
    Draw-Line "[10] Flush DNS" "[20] Task Manager" 34 33
    Draw-Line "[11] Network Reset" "[21] Control Panel" 34 33
    Draw-Line "[12] Renew IP" "[22] Device Manager" 34 33
    Draw-Line "[13] Ping Test" "[23] Services" 34 33
    Draw-Line "" "[24] Disk Management" 37 33
    Draw-Line "" "[25] System Properties" 37 33
    Draw-Line "" "[26] Startup Apps" 37 33
    Draw-Line "" "[27] SystemInfo" 37 33
    Draw-Line "" "[28] System Info GUI" 37 33
    Draw-Line "" "" 37 37

    Draw-Line "Install Tools" "" 36 37
    Draw-Line "[40] Chrome" "" 32 37
    Draw-Line "[41] Edge" "" 32 37
    Draw-Line "[42] Firefox" "" 32 37
    Draw-Line "[50] Office 365" "" 32 37
    Draw-Line "" "" 37 37

    Draw-Line "[0] Exit" "" 31 37

    # Bottom border
    Write-Host (" " * $leftPadding + "+" + ("-" * ($menuWidth - 2)) + "+")
    Write-Host ""
}

# ===== MAIN LOOP =====
while ($true) {
    Show-Menu
    Write-Color "Select option: " 36
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
                Write-Color "Exiting WinOpt..." 33
                Start-Sleep 1
                break
            }
            default {
                Write-Color "Invalid option!" 31
            }
        }
    }
    catch {
        Write-Color ("Error: $($_.Exception.Message)") 31
    }
    Pause
}
