# ===============================
# WINOPT NETWORK MODULE
# ===============================

function Flush-DNS {

    Write-Host ""
    Write-Host "Flushing DNS cache..." -ForegroundColor Yellow
    Write-Host ""

    ipconfig /flushdns

    Write-Host ""
    Write-Host "DNS cache cleared." -ForegroundColor Green
}

# -------------------------------

function Renew-IP {

    Write-Host ""
    Write-Host "Renewing IP address..." -ForegroundColor Yellow
    Write-Host ""

    ipconfig /release
    ipconfig /renew

    Write-Host ""
    Write-Host "IP renewed successfully." -ForegroundColor Green
}

# -------------------------------

function Ping-Test {

    Write-Host ""
    Write-Host "Testing network connection..." -ForegroundColor Yellow
    Write-Host ""

    ping 8.8.8.8 -n 4

    Write-Host ""
    Write-Host "Ping test completed." -ForegroundColor Green
}

# -------------------------------

function Network-Reset {

    Write-Host ""
    Write-Host "Resetting network configuration..." -ForegroundColor Yellow
    Write-Host ""

    ipconfig /flushdns
    netsh winsock reset
    netsh int ip reset

    Write-Host ""
    Write-Host "Network reset completed." -ForegroundColor Green
    Write-Host "Restart your computer to apply changes." -ForegroundColor DarkGray
}
