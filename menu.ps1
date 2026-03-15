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

Write-Host "[1] Clean Temp"
Write-Host "[2] Clear Prefetch"
Write-Host "[3] Clean Windows Update Cache"
Write-Host "[4] Network Reset"
Write-Host "[5] Repair Windows (SFC)"
Write-Host "[6] DISM Repair"
Write-Host "[7] Restart Explorer"
Write-Host "[8] Clear Recycle Bin"
Write-Host "[9] Flush DNS"
Write-Host "[10] Clear RAM Cache"

Write-Host ""
Write-Host "[20] Open Task Manager"
Write-Host "[21] Open Control Panel"
Write-Host "[22] Open Device Manager"

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

"4" { Network-Reset; Pause }

"5" { Repair-SFC; Pause }
"6" { Repair-DISM; Pause }

"7" { Restart-Explorer; Pause }
"8" { Clear-Recycle; Pause }

"9" { Flush-DNS; Pause }
"10" { Clear RAM Cache; Pause }

"11" { Open-TaskManager; Pause }
"12" { Open-ControlPanel; Pause }
"13" { Open-DeviceManager; Pause }

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
