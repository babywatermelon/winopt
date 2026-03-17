function Install-CocCoc {

    Write-Host ""
    Write-Host "Downloading Coc Coc browser..." -ForegroundColor Yellow

    $url = "https://files.coccoc.com/browser/installers/coccoc_vi.exe"
    $output = "$env:TEMP\coccoc.exe"

    try {
        Invoke-WebRequest -Uri $url -OutFile $output -UseBasicParsing
        Write-Host "Download completed." -ForegroundColor Green
    }
    catch {
        Write-Host "Download failed!" -ForegroundColor Red
        return
    }

    Write-Host "Installing Coc Coc..." -ForegroundColor Yellow

    Start-Process $output -ArgumentList "/silent" -Wait

    Write-Host "Coc Coc installed successfully!" -ForegroundColor Green
}
