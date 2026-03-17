Write-Host "installer.ps1 LOADED" -ForegroundColor Green
function Install-Chrome {
    winget install Google.Chrome --accept-package-agreements --accept-source-agreements
}
