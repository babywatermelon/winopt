while($true){

Clear-Host

Write-Host "=================================" -ForegroundColor DarkGray
Write-Host "           WINOPT TOOL           " -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor DarkGray
Write-Host ""

Write-Host "[1] Clean Temp"
Write-Host "[2] Clear Prefetch"
Write-Host "[3] Clean Windows Update Cache"
Write-Host "[4] Network Reset"
Write-Host "[5] Repair Windows"
Write-Host "[6] Disk Cleanup"
Write-Host "[7] Flush DNS"
Write-Host ""
Write-Host "[0] Exit"

$choice = Read-Host "Select"

switch($choice){

1{
Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Temp cleaned" -ForegroundColor Green
pause
}

2{
Remove-Item "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Prefetch cleaned" -ForegroundColor Green
pause
}

3{
Write-Host "Cleaning Windows Update Cache..." -ForegroundColor Yellow
net stop wuauserv
Remove-Item "C:\Windows\SoftwareDistribution\*" -Recurse -Force -ErrorAction SilentlyContinue
net start wuauserv
Write-Host "Windows Update Cache cleaned" -ForegroundColor Green
pause
}

4{
ipconfig /flushdns
netsh winsock reset
Write-Host "Network reset completed" -ForegroundColor Green
pause
}

5{
sfc /scannow
pause
}

6{
cleanmgr
pause
}

7{
ipconfig /flushdns
Write-Host "DNS flushed" -ForegroundColor Green
pause
}

0{
Write-Host "Exiting WinOpt..." -ForegroundColor Yellow
Start-Sleep 1
exit
}

default{
Write-Host "Invalid option" -ForegroundColor Red
pause
}

}

}
