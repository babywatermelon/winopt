function Network-Reset {

ipconfig /flushdns
netsh winsock reset

Write-Host "Network reset completed" -ForegroundColor Green

}

function Flush-DNS {

ipconfig /flushdns

Write-Host "DNS flushed" -ForegroundColor Green

}
