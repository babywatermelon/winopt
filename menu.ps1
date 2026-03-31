$host.UI.RawUI.WindowTitle = "WinOpt - Windows Optimization Tool"

# ===== AUTO WINDOW SIZE =====
try {
    $rawUI = $Host.UI.RawUI

    $buffer = $rawUI.BufferSize
    $buffer.Width = 160
    $buffer.Height = 1000
    $rawUI.BufferSize = $buffer

    $desiredWidth = 120
    $desiredHeight = 50
    $maxSize = $rawUI.MaxPhysicalWindowSize

    if ($desiredWidth -gt $maxSize.Width) { $desiredWidth = $maxSize.Width }
    if ($desiredHeight -gt $maxSize.Height) { $desiredHeight = $maxSize.Height - 2 }

    $rawUI.WindowSize = New-Object System.Management.Automation.Host.Size($desiredWidth, $desiredHeight)
}
catch {}

# ===== LOAD MODULES =====
$base = "$env:TEMP\winopt"
$modulePath = Join-Path $base "modules"

Write-Host "`n=== LOADING MODULES ===" -ForegroundColor Cyan

if (Test-Path $modulePath) {
    $modules = Get-ChildItem "$modulePath\*.ps1" -ErrorAction SilentlyContinue

    if (-not $modules -or $modules.Count -eq 0) {
        Write-Host "❌ No module files found!" -ForegroundColor Red
    }
    else {
        foreach ($module in $modules) {
            try {
                . $module.FullName
                Write-Host "✅ $($module.Name)" -ForegroundColor Green
            }
            catch {
                Write-Host "❌ $($module.Name): $($_.Exception.Message)" -ForegroundColor Red
            }
        }
    }
}
else {
    Write-Host "❌ Module folder not found!" -ForegroundColor Red
}

Write-Host "=== DONE ===`n" -ForegroundColor Cyan

# ===== CORE UI =====
function Pause {
    Write-Host ""
    Read-Host "Press Enter to continue"
}

function Header {
    Clear-Host
    $width = $Host.UI.RawUI.WindowSize.Width
    $title = " WINOPT TOOL "
    $pad = [math]::Floor(($width - $title.Length) / 2)

    Write-Host ("=" * $width) -ForegroundColor DarkGray
    Write-Host (" " * $pad + $title) -ForegroundColor Cyan
    Write-Host ("=" * $width) -ForegroundColor DarkGray
    Write-Host ""
}

function Draw-Line {
    param($left, $right, $menuWidth, $leftPadding)

    $inner = $menuWidth - 4
    $halfLeft = [math]::Floor($inner / 2)
    $halfRight = $inner - $halfLeft

    $l = ($left | Out-String).Trim().PadRight($halfLeft).Substring(0, $halfLeft)
    $r = ($right | Out-String).Trim().PadRight($halfRight).Substring(0, $halfRight)

    Write-Host (" " * $leftPadding + "| ") -NoNewline -ForegroundColor DarkGray
    Write-Host $l -NoNewline
    Write-Host $r -NoNewline
    Write-Host " |" -ForegroundColor DarkGray
}

function Draw-Section {
    param($left, $right, $menuWidth, $leftPadding)

    $inner = $menuWidth - 4
    $halfLeft = [math]::Floor($inner / 2)
    $halfRight = $inner - $halfLeft

    $l = ($left | Out-String).Trim().PadRight($halfLeft).Substring(0, $halfLeft)
    $r = ($right | Out-String).Trim().PadRight($halfRight).Substring(0, $halfRight)

    Write-Host (" " * $leftPadding + "| ") -NoNewline -ForegroundColor DarkGray
    Write-Host $l -NoNewline -ForegroundColor Yellow
    Write-Host $r -NoNewline -ForegroundColor Yellow
    Write-Host " |" -ForegroundColor DarkGray
}

# ===== SAFE EXEC =====
function Run-Safe($cmd) {
    if (Get-Command $cmd -ErrorAction SilentlyContinue) {
        & $cmd
    } else {
        Write-Host "❌ Missing function: $cmd" -ForegroundColor Red
    }
}

# ===== MENU =====
function Show-Menu {
    Header

    $width = $Host.UI.RawUI.WindowSize.Width
    $menuWidth = 110
    $pad = [math]::Floor(($width - $menuWidth) / 2)

    Write-Host (" " * $pad + "+" + ("-" * ($menuWidth - 2)) + "+") -ForegroundColor DarkGray

    Draw-Section "System Cleanup" "Repair Tools" $menuWidth $pad
    Draw-Line "[1] Temp" "[11] SFC" $menuWidth $pad
    Draw-Line "[2] Prefetch" "[12] DISM" $menuWidth $pad
    Draw-Line "[3] Update Cache" "[13] Full Repair" $menuWidth $pad
    Draw-Line "[4] Recycle Bin" "[14] Restore Point" $menuWidth $pad
    Draw-Line "[5] Logs" "[15] System Restore" $menuWidth $pad
    Draw-Line "[6] RAM Cache" "" $menuWidth $pad
    Draw-Line "[7] Restore Shadows" "" $menuWidth $pad
    Draw-Line "" "" $menuWidth $pad

    Draw-Section "Network Tools" "Windows Tools" $menuWidth $pad
    Draw-Line "[21] Flush DNS" "[31] Task Manager" $menuWidth $pad
    Draw-Line "[22] Reset Net" "[32] Control Panel" $menuWidth $pad
    Draw-Line "[23] Renew IP" "[33] Device Manager" $menuWidth $pad
    Draw-Line "[24] Ping" "[34] Services" $menuWidth $pad
    Draw-Line "" "[35] Disk Manager" $menuWidth $pad
    Draw-Line "" "[36] System Props" $menuWidth $pad
    Draw-Line "" "[37] Startup Apps" $menuWidth $pad
    Draw-Line "" "[38] SystemInfo CMD" $menuWidth $pad
    Draw-Line "" "[39] SystemInfo GUI" $menuWidth $pad
    Draw-Line "" "" $menuWidth $pad

    # ===== TÁCH RIÊNG =====
    Draw-Section "Security Tools" "Gaming Tools" $menuWidth $pad
    Draw-Line "[51] Disable Defender" "[61] Disable GameBar" $menuWidth $pad
    Draw-Line "[52] Enable Defender" "[62] Enable GameBar" $menuWidth $pad
    Draw-Line "[53] Disable RTP" "[63] Disable GameMode" $menuWidth $pad
    Draw-Line "[54] Enable RTP" "[64] Enable GameMode" $menuWidth $pad
    Draw-Line "[55] Enable Firewall" "[65] High Performance" $menuWidth $pad
    Draw-Line "[56] Disable Firewall" "[66] Balanced" $menuWidth $pad
    Draw-Line "" "[67] Disable Core Isolation" $menuWidth $pad
    Draw-Line "" "[68] Enable Core Isolation" $menuWidth $pad
    Draw-Line "" "" $menuWidth $pad

    Draw-Section "Install Tools" "Uninstall Tools" $menuWidth $pad
    Draw-Line "[71] Chrome" "[81] Remove Chrome" $menuWidth $pad
    Draw-Line "[72] Edge" "[82] Remove Edge" $menuWidth $pad
    Draw-Line "[73] Firefox" "[83] Remove Firefox" $menuWidth $pad
    Draw-Line "[74] CPU-Z" "[84] Remove CPU-Z" $menuWidth $pad
    Draw-Line "[75] GPU-Z" "[85] Remove GPU-Z" $menuWidth $pad
    Draw-Line "[76] CrystalDiskInfo" "[86] Remove CDI" $menuWidth $pad
    Draw-Line "[77] HWMonitor" "[87] Remove HWMonitor" $menuWidth $pad
    Draw-Line "[78] Office" "[88] Remove Office" $menuWidth $pad
    Draw-Line "" "" $menuWidth $pad

    Draw-Line "[99] Help" "" $menuWidth $pad
    Draw-Line "[0] Exit" "" $menuWidth $pad

    Write-Host (" " * $pad + "+" + ("-" * ($menuWidth - 2)) + "+") -ForegroundColor DarkGray
    Write-Host ""
}

# ===== MAIN LOOP =====
while ($true) {
    Show-Menu
    Write-Host "Select option: " -NoNewline -ForegroundColor Cyan
    $c = Read-Host

    try {
        switch ($c) {
            "1" { Run-Safe Clean-Temp }
            "2" { Run-Safe Clean-Prefetch }
            "3" { Run-Safe Clean-WindowsUpdate }
            "4" { Run-Safe Clear-Recycle }
            "5" { Run-Safe Clean-WindowsLogs }
            "6" { Run-Safe Clean-RAMCache }
            "7" { Run-Safe Clean-SystemRestoreShadows }

            "11" { Run-Safe Repair-SFC }
            "12" { Run-Safe Repair-DISM }
            "13" { Run-Safe Repair-Full }
            "14" { Run-Safe Create-RestorePoint }
            "15" { Run-Safe Restore-ComputerPoint }

            "21" { Run-Safe Flush-DNS }
            "22" { Run-Safe Network-Reset }
            "23" { Run-Safe Renew-IP }
            "24" { Run-Safe Ping-Test }

            "31" { Run-Safe Open-TaskManager }
            "32" { Run-Safe Open-ControlPanel }
            "33" { Run-Safe Open-DeviceManager }
            "34" { Run-Safe Open-Services }
            "35" { Run-Safe Open-DiskManagement }
            "36" { Run-Safe Open-SystemProperties }
            "37" { Run-Safe Open-StartupApps }
            "38" { Run-Safe Open-SystemInfo }
            "39" { Run-Safe Show-SystemInfoGUI }

            "51" { Run-Safe Set-Defender }
            "52" { Run-Safe Set-Defender }
            "53" { Run-Safe Set-RealTimeProtection }
            "54" { Run-Safe Set-RealTimeProtection }
            "55" { Run-Safe Set-Firewall }
            "56" { Run-Safe Set-Firewall }

            "61" { Run-Safe Disable-GameBar }
            "62" { Run-Safe Enable-GameBar }
            "63" { Run-Safe Disable-GameMode }
            "64" { Run-Safe Enable-GameMode }
            "65" { Run-Safe Set-HighPerformance }
            "66" { Run-Safe Set-Balanced }
            "67" { Run-Safe Disable-CoreIsolation }
            "68" { Run-Safe Enable-CoreIsolation }

            "71" { Run-Safe Install-Chrome }
            "72" { Run-Safe Install-Edge }
            "73" { Run-Safe Install-Firefox }
            "74" { Run-Safe Install-CPUZ }
            "75" { Run-Safe Install-GPUZ }
            "76" { Run-Safe Install-CrystalDiskInfo }
            "77" { Run-Safe Install-HWMonitor }
            "78" { Run-Safe Install-Office }

            "81" { Run-Safe Uninstall-Chrome }
            "82" { Run-Safe Uninstall-Edge }
            "83" { Run-Safe Uninstall-Firefox }
            "84" { Run-Safe Uninstall-CPUZ }
            "85" { Run-Safe Uninstall-GPUZ }
            "86" { Run-Safe Uninstall-CrystalDiskInfo }
            "87" { Run-Safe Uninstall-HWMonitor }
            "88" { Run-Safe Uninstall-Office }

            "99" { Write-Host "WinOpt Tool - Help" -ForegroundColor Yellow }

            "0" {
                $confirm = Read-Host "Exit? (Y/N)"
                if ($confirm -match "^y") { break }
            }

            default {
                Write-Host "Invalid option!" -ForegroundColor Red
            }
        }
    }
    catch {
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    }

    Pause
}
