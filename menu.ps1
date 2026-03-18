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

    Draw-Section "Install Tools" "" $menuWidth $leftPadding
    Draw-Line "[40] Chrome" "" $menuWidth $leftPadding
    Draw-Line "[41] Edge" "" $menuWidth $leftPadding
    Draw-Line "[42] Firefox" "" $menuWidth $leftPadding
    Draw-Line "[50] Office 365" "" $menuWidth $leftPadding
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

GIỚI THIỆU
-----------------------------------------------------------
WinOpt là công cụ tối ưu và sửa lỗi Windows được xây dựng 
bằng PowerShell.

Mục tiêu:
- Dọn dẹp hệ thống
- Sửa lỗi Windows
- Tối ưu hiệu năng
- Cung cấp công cụ nhanh cho người dùng

Tool phù hợp cho:
- Người dùng phổ thông
- Kỹ thuật viên IT
- Người muốn tối ưu máy nhanh gọn

===========================================================
CÁC CHỨC NĂNG CHÍNH
===========================================================

[ SYSTEM CLEANUP ]
-----------------------------------------------------------
1. Clean Temp
   -> Xóa file tạm trong hệ thống

2. Clear Prefetch
   -> Xóa cache Prefetch (tăng tốc load app)

3. Clean Update Cache
   -> Xóa cache Windows Update

4. Clear Recycle Bin
   -> Dọn thùng rác

5. Clean Logs
   -> Xóa log hệ thống không cần thiết


[ REPAIR TOOLS ]
-----------------------------------------------------------
7. Repair Windows (SFC)
   -> Quét và sửa file hệ thống

8. DISM Repair
   -> Khôi phục image Windows

9. Full Windows Repair
   -> Kết hợp SFC + DISM


[ NETWORK TOOLS ]
-----------------------------------------------------------
10. Flush DNS
    -> Xóa cache DNS

11. Network Reset
    -> Reset toàn bộ cấu hình mạng

12. Renew IP
    -> Cấp lại IP

13. Ping Test
    -> Kiểm tra kết nối mạng


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

-> Truy cập nhanh các công cụ hệ thống


[ INSTALL TOOLS ]
-----------------------------------------------------------
40. Google Chrome
41. Microsoft Edge
42. Mozilla Firefox
50. Microsoft Office 365

-> Cài đặt phần mềm nhanh


===========================================================
TÁC DỤNG CỦA WINOPT
===========================================================
- Tăng tốc hệ thống
- Giảm lỗi Windows
- Dọn dẹp rác hiệu quả
- Tiết kiệm thời gian thao tác
- Tích hợp nhiều công cụ trong 1 menu

===========================================================
LƯU Ý
===========================================================
- Nên chạy bằng quyền Administrator
- Một số chức năng cần internet
- Không tắt tool khi đang repair

===========================================================
DEVELOPED BY
WinOpt Project
===========================================================

"@

    # Tạo file trong TEMP
    $path = "$env:TEMP\WinOpt_README.txt"

    # Ghi UTF8 để không lỗi tiếng Việt
    $Utf8NoBom = New-Object System.Text.UTF8Encoding $true
    [System.IO.File]::WriteAllText($path, $readme, $Utf8NoBom)

    # Mở bằng Notepad
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
            "50" { Install-Office }

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
