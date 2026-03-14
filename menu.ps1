$host.UI.RawUI.WindowTitle = "WinOpt - Windows Optimization Tool"

# Load modules
. "$PSScriptRoot\modules\clean.ps1"
. "$PSScriptRoot\modules\repair.ps1"
. "$PSScriptRoot\modules\network.ps1"
. "$PSScriptRoot\modules\tools.ps1"

function Show-Menu {

Clear-Host

Write-Host "=====================================" -ForegroundColor DarkGray
Write-Host "              WINOPT TOOL            " -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor DarkGray
Write-Host ""

Write-Host "[1] Clean Temp"
Write-Host "[2] Clear Prefetch"
Write-Host "[3] Clean Windows Update Cache"
Write-Host "[4] Network Reset"
Write-Host "[5] Repair Windows (SFC)"
Write-Host "[6] DISM Repair"
Write-Host "[7] Restart Explorer"
Write-Host "[8] Clear Recycle Bin"
Write-Host "[9] Flush DNS"

Write-Host ""
Write-Host "[11] Open Task Manager"
Write-Host "[12] Open Control Panel"
Write-Host "[13] Open Device Manager"

Write-Host ""
Write-Host "[0] Exit"
Write-Host ""

}

while ($true) {

Show-Menu

$choice = Read-Host "Select option"

switch ($choice) {

"1" { Clean-Temp; pause }
"2" { Clean-Prefetch; pause }
"3" { Clean-WindowsUpdate; pause }

"4" { Network-Reset; pause }

"5" { Repair-SFC; pause }
"6" { Repair-DISM; pause }

"7" { Restart-Explorer; pause }
"8" { Clear-Recycle; pause }

"9" { Flush-DNS; pause }

"11" { Open-TaskManager }
"12" { Open-ControlPanel }
"13" { Open-DeviceManager }

"0" {
Write-Host "Exiting WinOpt..." -ForegroundColor Yellow
Start-Sleep 1
exit
}

default {
Write-Host "Invalid option" -ForegroundColor Red
pause
}

}

}
