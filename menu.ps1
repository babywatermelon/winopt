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
            Write-Host "Error loading module: $($module.Name)"
        }
    }
}
else {
    Write-Host "Modules folder not found: $modulePath"
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
    param($left, $right, $menuWidth, $leftPadding)

    $innerWidth = $menuWidth - 4
    $half = [math]::Floor($innerWidth / 2)

    $leftText  = ($left  | Out-String).Trim().PadRight($half)
    $rightText = ($right | Out-String).Trim().PadRight($half)

    Write-Host (" " * $leftPadding + "| ") -NoNewline -ForegroundColor DarkGray
    Write-Host $leftText -NoNewline -ForegroundColor White
    Write-Host $rightText -NoNewline -ForegroundColor White
    Write-Host " |" -ForegroundColor DarkGray
}

# ===== DRAW SECTION =====
function Draw-Section {
    param($left, $right, $menuWidth, $leftPadding)

    $innerWidth = $menuWidth - 4
    $half = [math]::Floor($innerWidth / 2)

    $leftText  = ($left  | Out-String).Trim().PadRight($half)
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
    $menuWidth = 80
    $leftPadding = [math]::Floor(($width - $menuWidth) / 2)

    Write-Host (" " * $leftPadding + "+" + ("-" * ($menuWidth - 2)) + "+") -ForegroundColor DarkGray

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

    Draw-Section "Install Tools" "Uninstall Tools" $menuWidth $leftPadding
    Draw-Line "[40] Chrome" "[60] Remove Chrome" $menuWidth $leftPadding
    Draw-Line "[41] Edge" "[61] Remove Edge" $menuWidth $leftPadding
    Draw-Line "[42] Firefox" "[62] Remove Firefox" $menuWidth $leftPadding
    Draw-Line "[43] Cpuz" "[63] Remove CPUZ" $menuWidth $leftPadding
    Draw-Line "[44] Gpuz" "[64] Remove GPUZ" $menuWidth $leftPadding
    Draw-Line "[45] CrystalDiskInfo" "[65] Remove CrystalDiskInfo" $menuWidth $leftPadding
    Draw-Line "[46] HWMonitor" "[66] Remove HWMonitor" $menuWidth $leftPadding
    Draw-Line "[50] Office 365" "[67] Remove Office" $menuWidth $leftPadding
    Draw-Line "" "" $menuWidth $leftPadding
    
    Draw-Line "[99] README / Help" "" $menuWidth $leftPadding
    Draw-Line "[0] Exit" "" $menuWidth $leftPadding

    Write-Host (" " * $leftPadding + "+" + ("-" * ($menuWidth - 2)) + "+") -ForegroundColor DarkGray
    Write-Host ""
}

# ===== README =====
function Show-Readme {

$readme = @"
===========================================================
                    WINOPT TOOL
        Windows Optimization & Repair Toolkit
===========================================================
-----------------------------------------------------------
WinOpt la cong cu toi uu va sua loi Windows duoc xay dung
bang PowerShell.

Muc tieu:
- Don dep he thong
- Sua loi Windows
- Toi uu hieu nang
- Cai dat phan mem
- Cung cap cong cu nhanh cho nguoi dung

Tool phu hop cho:
- Nguoi dung pho thong
- Ky thuat vien IT
- Nguoi muon toi uu may nhanh gon

===========================================================
CAC CHUC NANG CHINH
===========================================================

[ SYSTEM CLEANUP ]
-----------------------------------------------------------
1. Clean Temp
   -> Xoa file tam trong he thong

2. Clear Prefetch
   -> Xoa cache Prefetch (tang toc load app)

3. Clean Update Cache
   -> Xoa cache Windows Update

4. Clear Recycle Bin
   -> Don thung rac

5. Clean Logs
   -> Xoa log he thong khong can thiet


[ REPAIR TOOLS ]
-----------------------------------------------------------
7. Repair Windows (SFC)
   -> Quet va sua file he thong

8. DISM Repair
   -> Khoi phuc image Windows

9. Full Windows Repair
   -> Ket hop SFC + DISM


[ NETWORK TOOLS ]
-----------------------------------------------------------
10. Flush DNS
    -> Xoa cache DNS

11. Network Reset
    -> Reset toan bo cau hinh mang

12. Renew IP
    -> Cap lai IP

13. Ping Test
    -> Kiem tra ket noi mang


[ WINDOWS TOOLS ]
-----------------------------------------------------------
20. Task Manager
21. Control Panel
22. Device Manager
23. Services
24. Disk Management
25. System Properties
26. Startup Apps
27. SystemInfo (CMD)
28. System Info GUI

-> Truy cap nhanh cac cong cu he thong


[ INSTALL TOOLS ]
-----------------------------------------------------------
40. Google Chrome
41. Microsoft Edge
42. Mozilla Firefox
50. Microsoft Office 365

-> Cai dat phan mem nhanh


===========================================================
TAC DUNG CUA WINOPT
===========================================================
- Tang toc he thong
- Giam loi Windows
- Don dep rac hieu qua
- Tiet kiem thoi gian thao tac
- Tich hop nhieu cong cu trong 1 menu

===========================================================
LUU Y
===========================================================
- Nen chay bang quyen Administrator
- Mot so chuc nang can internet
- Khong tat tool khi dang repair

===========================================================
DEVELOPED BY
Nguyen Minh Tri | 0789649285 | triclgtyahoo@gmail.com
===========================================================

"@

    $path = "$env:TEMP\WinOpt_README.txt"

    # Ghi file (luc nay khong can lo encoding nua)
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
            "43" { Install-CPUZ }
            "44" { Install-GPUZ }
            "45" { Install-CrystalDiskInfo }
            "46" { Install-HWMonitor }
            "50" { Install-Office }

            "60" { Uninstall-Chrome }
            "61" { Uninstall-Edge }
            "62" { Uninstall-Firefox }
            "63" { Uninstall-CPUZ }
            "64" { Uninstall-GPUZ }
            "65" { Uninstall-CrystalDiskInfo }
            "66" { Uninstall-HWMonitor }
            "67" { Uninstall-Office }

            "99" { Show-Readme }

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
