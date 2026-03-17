function Install-Chrome {

    Write-Host "Checking Chrome..." -ForegroundColor Cyan

    $app = winget list --id Google.Chrome

    if ($app -match "Google Chrome") {
        Write-Host "Chrome already installed!" -ForegroundColor Yellow
        return
    }

    Write-Host "Installing Chrome..." -ForegroundColor Cyan

    winget install --id Google.Chrome --exact --accept-package-agreements --accept-source-agreements

    Write-Host "Done!" -ForegroundColor Green
}
