function Install-Chrome {

    Write-Host "Installing Chrome..." -ForegroundColor Yellow

    try {
        winget install -e --id Google.Chrome --silent --accept-package-agreements --accept-source-agreements
        Write-Host "Installed successfully!" -ForegroundColor Green
    }
    catch {
        Write-Host "Install failed!" -ForegroundColor Red
    }

}
