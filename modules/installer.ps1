function Install-CocCoc {

    Write-Host ""
    Write-Host "Downloading Coc Coc..." -ForegroundColor Yellow

    $url = "https://files.coccoc.com/browser/installers/coccoc_vi.exe"
    $output = "$env:TEMP\coccoc.exe"

    try {
        Invoke-WebRequest -Uri $url -OutFile $output -ErrorAction Stop
        Write-Host "Download completed!" -ForegroundColor Green
    }
    catch {
        Write-Host "Download failed!" -ForegroundColor Red
        return
    }

    Write-Host "Installing Coc Coc..." -ForegroundColor Yellow

    try {
        Start-Process $output -ArgumentList "/S" -Wait -ErrorAction Stop
        Write-Host "Installed successfully!" -ForegroundColor Green
    }
    catch {
        Write-Host "Install failed!" -ForegroundColor Red
    }

}
