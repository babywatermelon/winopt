function Install-Chrome {

    Write-Host ""
    Write-Host "Installing Google Chrome..." -ForegroundColor Yellow

    try {
        winget install -e --id Google.Chrome `
        --silent `
        --accept-package-agreements `
        --accept-source-agreements

        Write-Host "Chrome installed successfully!" -ForegroundColor Green
    }
    catch {
        Write-Host "Install failed!" -ForegroundColor Red
    }

}
