Clear-Host

Write-Host "====================="
Write-Host "   WINOPT TOOL"
Write-Host "====================="

Write-Host "1. Clean Temp"
Write-Host "2. Network Reset"
Write-Host "3. Repair Windows"
Write-Host "0. Exit"

$choice=Read-Host "Select"

switch($choice){

1 {
Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Temp cleaned"
pause
}

2 {
ipconfig /flushdns
netsh winsock reset
pause
}

3 {
sfc /scannow
pause
}

}
