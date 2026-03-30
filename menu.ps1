$host.UI.RawUI.WindowTitle = "WinOpt - Windows Optimization Tool"

# ===== TỰ ĐỘNG CĂN CHỈNH KÍCH THƯỚC CỬA SỔ =====
try {
    $rawUI = $Host.UI.RawUI
    $buffer = $rawUI.BufferSize
    $buffer.Width = 200
    $buffer.Height = 5000
    $rawUI.BufferSize = $buffer

    $desiredWidth = 120
    $desiredHeight = 52
    $maxSize = $rawUI.MaxPhysicalWindowSize
    if ($desiredWidth -gt $maxSize.Width) { $desiredWidth = $maxSize.Width }
    if ($desiredHeight -gt $maxSize.Height) { $desiredHeight = $maxSize.Height - 3 }

    $windowSize = New-Object System.Management.Automation.Host.Size($desiredWidth, $desiredHeight)
    $rawUI.WindowSize = $windowSize
}
catch { }

# ===== LOAD MODULES =====
$base = "$env:TEMP\winopt"
$modulePath = Join-Path $base "modules"

Write-Host "`n=== ĐANG LOAD MODULES ===" -ForegroundColor Cyan

if (Test-Path $modulePath) {
    $modules = Get-ChildItem "$modulePath\*.ps1" -ErrorAction SilentlyContinue
    
    if ($modules.Count -eq 0) {
        Write-Host "❌ Không có file .ps1 nào trong thư mục modules!" -ForegroundColor Red
    }
    else {
        foreach ($module in $modules) {
            try {
                . $module.FullName
                $color = if ($module.Name -like "*update*") { "Magenta" } else { "Green" }
                Write-Host "✅ Loaded module: $($module.Name)" -ForegroundColor $color
            }
            catch {
                Write-Host "❌ LỖI load $($module.Name): $($_.Exception.Message)" -ForegroundColor Red
            }
        }
    }
}
else {
    Write-Host "❌ Không tìm thấy thư mục: $modulePath" -ForegroundColor Red
}

Write-Host "=== HOÀN TẤT LOAD MODULES ===`n" -ForegroundColor Cyan

# ===== UI CORE =====
function Pause {
    Write-Host ""
    Read-Host "Press Enter to continue"
}

function Header {
    Clear-Host
    $width = $Host.UI.RawUI.WindowSize.Width
    $title = " WINOPT TOOL "
    $padding = [math]::Max(0, [math]::Floor(($width - $title.Length) / 2))
    $line = "=" * $width
    Write-Host $line -ForegroundColor DarkGray
    Write-Host (" " * $padding + $title) -ForegroundColor Cyan
    Write-Host $line -ForegroundColor DarkGray
    Write-Host ""
}

function Draw-Line {
    param($left, $right, $menuWidth, $leftPadding)
    $innerWidth = $menuWidth - 4
    $half = [math]::Max(1, [math]::Floor($innerWidth / 2))
 
    $leftText = ($left | Out-String).Trim()
    $rightText = ($right | Out-String).Trim()
 
    $leftPadded = $leftText.PadRight($half)
    if ($leftPadded.Length -gt $half) { $leftPadded = $leftPadded.Substring(0, $half) }
 
    $rightPadded = $rightText.PadRight($half)
    if ($rightPadded.Length -gt $half) { $rightPadded = $rightPadded.Substring(0, $half) }
  
    Write-Host (" " * [math]::Max(0, $leftPadding) + "| ") -NoNewline -ForegroundColor DarkGray
    Write-Host $leftPadded -NoNewline -ForegroundColor White
    Write-Host $rightPadded -NoNewline -ForegroundColor White
    Write-Host " |" -ForegroundColor DarkGray
}

function Draw-Section {
    param($left, $right, $menuWidth, $leftPadding)
    $innerWidth = $menuWidth - 4
    $half = [math]::Max(1, [math]::Floor($innerWidth / 2))
 
    $leftText = ($left | Out-String).Trim()
    $rightText = ($right | Out-String).Trim()
    $leftPadded = $leftText.PadRight($half)
    if ($leftPadded.Length -gt $half) { $leftPadded = $leftPadded.Substring(0, $half) }
 
    $rightPadded = $rightText.PadRight($half)
    if ($rightPadded.Length -gt $half) { $rightPadded = $rightPadded.Substring(0, $half) }
  
    Write-Host (" " * [math]::Max(0, $leftPadding) + "| ") -NoNewline -ForegroundColor DarkGray
    Write-Host $leftPadded -NoNewline -ForegroundColor Yellow
    Write-Host $rightPadded -NoNewline -ForegroundColor Yellow
    Write-Host " |" -ForegroundColor DarkGray
}

# ===== SHOW-MENU =====
# ===== SHOW-MENU =====
function Show-Menu {
    Header
    $width = $Host.UI.RawUI.WindowSize.Width
    $menuWidth = 92                    # Giảm xuống một chút để cân đối hơn
    $leftPadding = [math]::Max(0, [math]::Floor(($width - $menuWidth) / 2))
  
    Write-Host (" " * $leftPadding + "+" + ("-" * ($menuWidth - 2)) + "+") -ForegroundColor DarkGray
  
    # System Cleanup & Repair Tools
    Draw-Section "System Cleanup" "Repair Tools" $menuWidth $leftPadding
    Draw-Line "[1] Clean Temp" "[11] Repair Windows (SFC)" $menuWidth $leftPadding
    Draw-Line "[2] Clear Prefetch" "[12] DISM Repair" $menuWidth $leftPadding
    Draw-Line "[3] Clean Update Cache" "[13] Full Windows Repair" $menuWidth $leftPadding
    Draw-Line "[4] Clear Recycle Bin" "[14] Create Restore Point" $menuWidth $leftPadding
    Draw-Line "[5] Clean Logs" "[15] System Restore" $menuWidth $leftPadding
    Draw-Line "[6] Clean RAM cache" "" $menuWidth $leftPadding
    Draw-Line "[7] Clear Restore Points" "" $menuWidth $leftPadding
    Draw-Line "" "" $menuWidth $leftPadding

    # Network Tools & Windows Quick Tools
    Draw-Section "Network Tools" "Windows Quick Tools" $menuWidth $leftPadding
    Draw-Line "[21] Flush DNS" "[31] Task Manager" $menuWidth $leftPadding
    Draw-Line "[22] Network Reset" "[32] Control Panel" $menuWidth $leftPadding
    Draw-Line "[23] Renew IP" "[33] Device Manager" $menuWidth $leftPadding
    Draw-Line "[24] Ping Test" "[34] Services" $menuWidth $leftPadding
    Draw-Line "" "[35] Disk Management" $menuWidth $leftPadding
    Draw-Line "" "[36] System Properties" $menuWidth $leftPadding
    Draw-Line "" "[37] Startup Apps" $menuWidth $leftPadding
    Draw-Line "" "[38] SystemInfo (CMD)" $menuWidth $leftPadding
    Draw-Line "" "[39] System Info GUI" $menuWidth $leftPadding
    Draw-Line "" "" $menuWidth $leftPadding

    # Security & Gaming Tools (đã gộp)
    Draw-Section "Security & Gaming Tools" "" $menuWidth $leftPadding
    Draw-Line "[51] Disable Defender" "[61] Disable Game Bar" $menuWidth $leftPadding
    Draw-Line "[52] Enable Defender" "[62] Enable Game Bar" $menuWidth $leftPadding
    Draw-Line "[53] Disable Virus Prot." "[63] Disable Game Mode" $menuWidth $leftPadding
    Draw-Line "[54] Enable Virus Prot." "[64] Enable Game Mode" $menuWidth $leftPadding
    Draw-Line "[55] Enable Firewall" "[65] High Performance" $menuWidth $leftPadding
    Draw-Line "[56] Disable Firewall" "[66] Balanced (Default)" $menuWidth $leftPadding
    Draw-Line "" "[67] Disable Core Isolation" $menuWidth $leftPadding
    Draw-Line "" "[68] Enable Core Isolation" $menuWidth $leftPadding
    Draw-Line "" "" $menuWidth $leftPadding

    # Install & Uninstall Tools
    Draw-Section "Install Tools" "Uninstall Tools" $menuWidth $leftPadding
    Draw-Line "[71] Chrome" "[81] Remove Chrome" $menuWidth $leftPadding
    Draw-Line "[72] Edge" "[82] Remove Edge" $menuWidth $leftPadding
    Draw-Line "[73] Firefox" "[83] Remove Firefox" $menuWidth $leftPadding
    Draw-Line "[74] CPU-Z" "[84] Remove CPU-Z" $menuWidth $leftPadding
    Draw-Line "[75] GPU-Z" "[85] Remove GPU-Z" $menuWidth $leftPadding
    Draw-Line "[76] CrystalDiskInfo" "[86] Remove CrystalDiskInfo" $menuWidth $leftPadding
    Draw-Line "[77] HWMonitor" "[87] Remove HWMonitor" $menuWidth $leftPadding
    Draw-Line "[78] Office 365" "[88] Remove Office" $menuWidth $leftPadding
    Draw-Line "" "" $menuWidth $leftPadding

    # Help & Exit
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
WinOpt là công cụ tối ưu và sửa lỗi Windows.
Nên chạy bằng quyền Administrator.
DEVELOPED BY: Nguyen Minh Tri
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
            "1" { Clean-Temp }
            "2" { Clean-Prefetch }
            "3" { Clean-WindowsUpdate }
            "4" { Clear-Recycle }
            "5" { Clean-WindowsLogs }
            "6" { Clean-RAMCache }
            "7" { Clean-SystemRestoreShadows }

            "11" { Repair-SFC }
            "12" { Repair-DISM }
            "13" { Repair-Full }
            "14" { Create-RestorePoint }
            "15" { Restore-ComputerPoint }

            "21" { Flush-DNS }
            "22" { Network-Reset }
            "23" { Renew-IP }
            "24" { Ping-Test }

            "31" { Open-TaskManager }
            "32" { Open-ControlPanel }
            "33" { Open-DeviceManager }
            "34" { Open-Services }
            "35" { Open-DiskManagement }
            "36" { Open-SystemProperties }
            "37" { Open-StartupApps }
            "38" { Open-SystemInfo }
            "39" { Show-SystemInfoGUI }

            "51" { Set-Defender -Status "Disable" }
            "52" { Set-Defender -Status "Enable" }
            "53" { Set-RealTimeProtection -Status "Disable" }
            "54" { Set-RealTimeProtection -Status "Enable" }
            "55" { Set-Firewall -Status "Enable" }
            "56" { Set-Firewall -Status "Disable" }

            "61" { Disable-GameBar }
            "62" { Enable-GameBar }
            "63" { Disable-GameMode }
            "64" { Enable-GameMode }
            "65" { Set-HighPerformance }
            "66" { Set-Balanced }
            "67" { Disable-CoreIsolation }
            "68" { Enable-CoreIsolation }

            "71" { Install-Chrome }
            "72" { Install-Edge }
            "73" { Install-Firefox }
            "74" { Install-CPUZ }
            "75" { Install-GPUZ }
            "76" { Install-CrystalDiskInfo }
            "77" { Install-HWMonitor }
            "78" { Install-Office }

            "81" { Uninstall-Chrome }
            "82" { Uninstall-Edge }
            "83" { Uninstall-Firefox }
            "84" { Uninstall-CPUZ }
            "85" { Uninstall-GPUZ }
            "86" { Uninstall-CrystalDiskInfo }
            "87" { Uninstall-HWMonitor }
            "88" { Uninstall-Office }

            "99" { Show-Readme }
            "0" {
                $confirm = Read-Host "Are you sure you want to exit? (Y/N)"
                if ($confirm -match "^y") { exit }
            }
            default { Write-Host "Invalid option!" -ForegroundColor Red }
        }
    }
    catch {
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    }
    Pause
}
