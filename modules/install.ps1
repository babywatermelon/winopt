function Install-Chrome {

    Write-Host "Installing Google Chrome..." -ForegroundColor Cyan

    try {
        Start-Process "winget" -ArgumentList "install --id Google.Chrome --exact --accept-package-agreements --accept-source-agreements" -Wait

        Write-Host "Done!" -ForegroundColor Green
    }
    catch {
        Write-Host "Install failed!" -ForegroundColor Red
    }
}

function Install-Edge {

    Write-Host "Installing Microsoft Edge..." -ForegroundColor Cyan

    try {
        Start-Process "winget" -ArgumentList "install --id Microsoft.Edge --exact --accept-package-agreements --accept-source-agreements" -Wait

        Write-Host "Edge installed!" -ForegroundColor Green
    }
    catch {
        Write-Host "Install failed!" -ForegroundColor Red
    }
}

function Install-Firefox {

    Write-Host "Installing Mozilla Firefox..." -ForegroundColor Cyan

    try {
        Start-Process "winget" -ArgumentList "install --id Mozilla.Firefox --exact --accept-package-agreements --accept-source-agreements" -Wait

        Write-Host "Firefox installed!" -ForegroundColor Green
    }
    catch {
        Write-Host "Install failed!" -ForegroundColor Red
    }
}

function Install-Office {

    Write-Host "Installing Microsoft Office 365..." -ForegroundColor Cyan

    try {
        Start-Process "winget" -ArgumentList "install --id Microsoft.Office --exact --accept-package-agreements --accept-source-agreements" -Wait

        Write-Host "Office installed!" -ForegroundColor Green
    }
    catch {
        Write-Host "Install failed!" -ForegroundColor Red
    }
}
