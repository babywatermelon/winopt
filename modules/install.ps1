function Install-Chrome {

    Write-Host "Installing Google Chrome..." -ForegroundColor Cyan

    try {
        Start-Process "winget" -ArgumentList "install --id Google.Chrome --exact --accept-package-agreements --accept-source-agreements" -Wait -NoNewWindow

        Write-Host "Done!" -ForegroundColor Green
    }
    catch {
        Write-Host "Install failed!" -ForegroundColor Red
    }
}
