$host.UI.RawUI.WindowTitle = "WinOpt - Windows Optimization Tool"

# ===== LOAD MODULES =====
$base = "$env:TEMP\winopt"
$modulePath = Join-Path $base "modules"

if (Test-Path $modulePath) {
    $modules = Get-ChildItem "$modulePath\*.ps1" -ErrorAction SilentlyContinue
    foreach ($module in $modules) {
        try {
            . $module.FullName
        }
        catch {
            Write-Host "Error loading module: $($module.Name)" -ForegroundColor Red
        }
    }
}
else {
    Write-Host "Modules folder not found: $modulePath" -ForegroundColor Yellow
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

function Draw-Line {
    param($left, $right, $menuWidth, $leftPadding)
    $innerWidth = $menuWidth - 4
    $half = [math]::Floor($innerWidth / 2)
    $leftText = ($left | Out-String).Trim().PadRight($half)
    $rightText = ($right | Out-String).Trim().PadRight($half)
    Write-Host (" " * $leftPadding + "| ") -NoNewline -ForegroundColor DarkGray
    Write-Host $leftText -NoNewline -ForegroundColor White
    Write-Host $rightText -NoNewline -ForegroundColor White
    Write-Host " |" -ForegroundColor DarkGray
}

function Draw-Section {
    param($left, $right, $menuWidth, $leftPadding)
    $innerWidth = $menuWidth - 4
    $half = [math]::Floor($innerWidth / 2)
    $leftText = ($left | Out-String).Trim().PadRight($half)
    $rightText = ($right | Out-String).Trim().PadRight($half)
    Write-Host (" " * $leftPadding + "| ") -NoNewline -ForegroundColor DarkGray
    Write-Host $leftText -NoNewline -ForegroundColor Yellow
    Write-Host $rightText -NoNewline -ForegroundColor Yellow
    Write-Host " |" -ForegroundColor DarkGray
}

# ===== MENU =====
function Show-Menu {
    Header
    $width = $Host.UI.RawUI.WindowSize.Width
    $menuWidth = 82
    $leftPadding = [math]::Floor(($width - $menuWidth) / 2)

    Write-Host (" " * $leftPadding + "+" + ("-" * ($menuWidth - 2)) + "+") -ForegroundColor DarkGray

    # ================== SYSTEM CLEANUP & REPAIR TOOLS ==================
    Draw-Section "System Cleanup" "Repair Tools" $menuWidth $leftPadding
    Draw-Line "[1] Clean Temp"           "[11] Repair Windows (SFC)"      $menuWidth $leftPadding
    Draw-Line "[2] Clear Prefetch"       "[12] DISM Repair"               $menuWidth $leftPadding
    Draw-Line "[3] Clean Update Cache"   "[13] Full Windows Repair"       $menuWidth $leftPadding
    Draw-Line "[4] Clear Recycle Bin"    ""                               $menuWidth $leftPadding
    Draw-Line "[5] Clean Logs"           ""                               $menuWidth $leftPadding
    Draw-Line "" "" $menuWidth $leftPadding

    # ================== NETWORK TOOLS & WINDOWS QUICK TOOLS ==================
    Draw-Section "Network Tools" "Windows Quick Tools" $menuWidth $leftPadding
    Draw-Line "[21] Flush DNS"            "[31] Task Manager"              $menuWidth $leftPadding
    Draw-Line "[22] Network Reset"        "[32] Control Panel"             $menuWidth $leftPadding
    Draw-Line "[23] Renew IP"             "[33] Device Manager"            $menuWidth $leftPadding
    Draw-Line "[24] Ping Test"            "[34] Services"                  $menuWidth $leftPadding
    Draw-Line ""                          "[35] Disk Management"           $menuWidth $leftPadding
    Draw-Line ""                          "[36] System Properties"         $menuWidth $leftPadding
    Draw-Line ""                          "[37] Startup Apps"              $menuWidth $leftPadding
    Draw-Line ""                          "[38] SystemInfo (CMD)"          $menuWidth $leftPadding
    Draw-Line ""                          "[39] System Info GUI"           $menuWidth $leftPadding
    Draw-Line "" "" $menuWidth $leftPadding

    # ================== INSTALL & UNINSTALL TOOLS ==================
    Draw-Section "Install Tools" "Uninstall Tools" $menuWidth $leftPadding
    Draw-Line "[41] Chrome"               "[61] Remove Chrome"             $menuWidth $leftPadding
    Draw-Line "[42] Edge"                 "[62] Remove Edge"               $menuWidth $leftPadding
    Draw-Line "[43] Firefox"              "[63] Remove Firefox"            $menuWidth $leftPadding
    Draw-Line "[44] CPU-Z"                "[64] Remove CPU-Z"              $menuWidth $leftPadding
    Draw-Line "[45] GPU-Z"                "[65] Remove GPU-Z"              $menuWidth $leftPadding
    Draw-Line "[46] CrystalDiskInfo"      "[66] Remove CrystalDiskInfo"    $menuWidth $leftPadding
    Draw-Line "[47] HWMonitor"            "[67] Remove HWMonitor"          $menuWidth $leftPadding
    Draw-Line "[48] Office 365"           "[68] Remove Office"             $menuWidth $leftPadding
    Draw-Line "" "" $menuWidth $leftPadding


    # Help & Exit
    Draw-Line "[99] README / Help"        ""                               $menuWidth $leftPadding
    Draw-Line "[0]  Exit"                 ""                               $menuWidth $leftPadding

    Write-Host (" " * $leftPadding + "+" + ("-" * ($menuWidth - 2)) + "+") -ForegroundColor DarkGray
    Write-Host ""
}

# ===== README (TIENG VIET KHONG DAU) =====
function Show-Readme {
    $readme = @"
===========================================================
                    WINOPT TOOL
        Windows Optimization & Repair Toolkit
===========================================================

WinOpt la cong cu toi uu va sua loi Windows duoc xay dung bang PowerShell.

Muc tieu:
- Don dep he thong
- Sua loi Windows
- Toi uu hieu nang
- Cai dat phan mem nhanh
- Cung cap cong cu nhanh cho IT Support

Phu hop cho:
- Nguoi dung pho thong
- Ky thuat vien IT

===========================================================
CAC CHUC NANG CHINH
===========================================================
[ SYSTEM CLEANUP ]
1.  Clean Temp
2.  Clear Prefetch
3.  Clean Update Cache
4.  Clear Recycle Bin
5.  Clean Logs

[ REPAIR TOOLS ]
11. Repair Windows (SFC)
12. DISM Repair
13. Full Windows Repair

[ NETWORK TOOLS ]
21. Flush DNS
22. Network Reset
23. Renew IP
24. Ping Test

[ WINDOWS QUICK TOOLS ]
31. Task Manager
32. Control Panel
33. Device Manager
34. Services
35. Disk Management
36. System Properties
37. Startup Apps
38. SystemInfo (CMD)
39. System Info GUI

[ INSTALL TOOLS ]
41. Chrome          61. Remove Chrome
42. Edge            62. Remove Edge
43. Firefox         63. Remove Firefox
44. CPU-Z           64. Remove CPU-Z
45. GPU-Z           65. Remove GPU-Z
46. CrystalDiskInfo 66. Remove CrystalDiskInfo
47. HWMonitor       67. Remove HWMonitor
48. Office 365      68. Remove Office


===========================================================
LUU Y
===========================================================
- Nen chay bang quyen Administrator
- Mot so chuc nang can ket noi internet
- Khong tat tool khi dang chay Repair
- Mot so chuc nang quan trong se co xac nhan truoc khi thuc hien

DEVELOPED BY
Nguyen Minh Tri | 0789649285 | triclgtyahoo@gmail.com
===========================================================
"@
    $path = "$env:TEMP\WinOpt_README.txt"
    $readme | Out-File -Encoding ASCII $path
    Start-Process notepad $path
}

# ===== MAIN LOOP =====
while ($true) {
    Show-Menu
    Write-Host "Select option: " -NoNewline -ForegroundColor Cyan
    $choice = Read-Host

    try {
        switch ($choice) {
            # System Cleanup
            "1"  { Clean-Temp }
            "2"  { Clean-Prefetch }
            "3"  { Clean-WindowsUpdate }
            "4"  { Clear-Recycle }
            "5"  { Clean-WindowsLogs }

            # Repair Tools
            "11" { Repair-SFC }
            "12" { Repair-DISM }
            "13" { Repair-Full }

            # Network Tools
            "21" { Flush-DNS }
            "22" { Network-Reset }
            "23" { Renew-IP }
            "24" { Ping-Test }

            # Windows Quick Tools
            "31" { Open-TaskManager }
            "32" { Open-ControlPanel }
            "33" { Open-DeviceManager }
            "34" { Open-Services }
            "35" { Open-DiskManagement }
            "36" { Open-SystemProperties }
            "37" { Open-StartupApps }
            "38" { Open-SystemInfo }
            "39" { Show-SystemInfoGUI }

            # Install Tools
            "41" { Install-Chrome }
            "42" { Install-Edge }
            "43" { Install-Firefox }
            "44" { Install-CPUZ }
            "45" { Install-GPUZ }
            "46" { Install-CrystalDiskInfo }
            "47" { Install-HWMonitor }
            "48" { Install-Office }

            # Uninstall Tools
            "61" { Uninstall-Chrome }
            "62" { Uninstall-Edge }
            "63" { Uninstall-Firefox }
            "64" { Uninstall-CPUZ }
            "65" { Uninstall-GPUZ }
            "66" { Uninstall-CrystalDiskInfo }
            "67" { Uninstall-HWMonitor }
            "68" { Uninstall-Office }


            # Help & Exit
            "99" { Show-Readme }
            "0"  {
                $confirm = Read-Host "Are you sure you want to exit? (Y/N)"
                if ($confirm -eq "Y" -or $confirm -eq "y") {
                    Write-Host "Exiting WinOpt..." -ForegroundColor Yellow
                    Start-Sleep 1
                    return
                }
            }
            default {
                Write-Host "Invalid option! Please try again." -ForegroundColor Red
            }
        }
    }
    catch {
        Write-Host ""
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    }

    Pause
}
