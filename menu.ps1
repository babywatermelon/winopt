$host.UI.RawUI.WindowTitle = "WinOpt - Windows Optimization Tool"

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
Write-Host "[7] Disk Cleanup"
Write-Host "[8] Flush DNS"
Write-Host "[9] Restart Explorer"
Write-Host "[10] Clear Recycle Bin"
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

"1" {
Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Temp cleaned" -ForegroundColor Green
pause
}

"2" {
Remove-Item "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Prefetch cleaned" -ForegroundColor Green
pause
}

"3" {
Write-Host "Cleaning Windows Update Cache..." -ForegroundColor Yellow
net stop wuauserv
Remove-Item "C:\Windows\SoftwareDistribution\*" -Recurse -Force -ErrorAction SilentlyContinue
net start wuauserv
Write-Host "Completed" -ForegroundColor Green
pause
}

"4" {
ipconfig /flushdns
netsh winsock reset
Write-Host "Network reset done" -ForegroundColor Green
pause
}

"5" {
sfc /scannow
pause
}

"6" {
DISM /Online /Cleanup-Image /RestoreHealth
pause
}

"7" {
cleanmgr
pause
}

"8" {
ipconfig /flushdns
Write-Host "DNS flushed" -ForegroundColor Green
pause
}

"9" {
taskkill /f /im explorer.exe
Start-Process explorer.exe
Write-Host "Explorer restarted" -ForegroundColor Green
pause
}

"10" {
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Write-Host "Recycle bin cleared" -ForegroundColor Green
pause
}

"11" {
Start-Process taskmgr
}

"12" {
Start-Process control
}

"13" {
Start-Process devmgmt.msc
}

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
