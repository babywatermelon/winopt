$host.UI.RawUI.WindowTitle = "WinOpt - Windows Optimization Tool"

# Load modules
$modules = Get-ChildItem "$PSScriptRoot\modules\*.ps1"

foreach ($module in $modules) {
    . $module.FullName
}

function Pause {
    Write-Host ""
    Read-Host "Press Enter to continue"
}

function Show-Menu {

Clear-Host

Write-Host "=====================================" -ForegroundColor DarkGray
Write-Host "              WINOPT TOOL            " -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor DarkGray
Write-Host ""

Write-Host "System Cleanup"
Write-Host "[1] Clean Temp"
Write-Host "[2] Clear Prefetch"
Write-Host "[3] Clean Windows Update Cache"
Write-Host "[4] Clear Recycle Bin"
Write-Host "[5] Clean Windows Logs"

Write-Host ""
Write-Host "Repair Tools"
Write-Host "[7] Repair Windows (SFC)"
Write-Host "[8] DISM Repair"
Write-Host "[9] Full Windows Repair"

Write-Host ""
Write-Host "Network Tools"
Write-Host "[10] Flush DNS"
Write-Host "[11] Network Reset"
Write-Host "[12] Renew IP"
Write-Host "[13] Ping Test"

Write-Host ""
Write-Host "Windows Tools"
Write-Host "[20] Open Task Manager"
Write-Host "[21] Open Control Panel"
Write-Host "[22] Open Device Manager"
Write-Host "[23] Open Services"
Write-Host "[24] Open Disk Management"
Write-Host "[25] Open System Properties"
Write-Host "[26] Open Startup Apps"
Write-Host "[27] Open SystemInfo"
Write-Host "[28] Show System Info GUI"

Write-Host ""
Write-Host "[0] Exit"
Write-Host ""

}

while ($true) {

Show-Menu

$choice = Read-Host "Select option"

switch ($choice) {

"1" { Clean-Temp; Pause }
"2" { Clean-Prefetch; Pause }
"3" { Clean-WindowsUpdate; Pause }
"4" { Clear-Recycle; Pause }
"5" { Clean-WindowsLogs; Pause }

"7" { Repair-SFC; Pause }
"8" { Repair-DISM; Pause }
"9" { Repair-Full; Pause }

"10" { Flush-DNS; Pause }
"11" { Network-Reset; Pause }
"12" { Renew-IP; Pause }
"13" { Ping-Test; Pause }

"20" { Open-TaskManager; Pause }
"21" { Open-ControlPanel; Pause }
"22" { Open-DeviceManager; Pause }
"23" { Open-Services; Pause }
"24" { Open-DiskManagement; Pause }
"25" { Open-SystemProperties; Pause }
"26" { Open-StartupApps; Pause }
"27" { Open-SystemInfo; Pause }
"28" { Show-SystemInfoGUI; Pause }

"0" {
Write-Host "Exiting WinOpt..." -ForegroundColor Yellow
Start-Sleep 1
break
}

default {
Write-Host "Invalid option" -ForegroundColor Red
Pause
}

}

}
