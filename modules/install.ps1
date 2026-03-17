# ===== UI HELPERS =====

function Show-Title($msg) {
    Write-Host "`n==== $msg ====" -ForegroundColor Cyan
}

function Show-Status($msg) {
    Write-Host "[*] $msg" -ForegroundColor Yellow
}

function Show-Success($msg) {
    Write-Host "[✓] $msg" -ForegroundColor Green
}

function Show-Error($msg) {
    Write-Host "[✗] $msg" -ForegroundColor Red
}

function Show-Loading($seconds) {
    $chars = "|/-\"
    $end = (Get-Date).AddSeconds($seconds)

    while ((Get-Date) -lt $end) {
        foreach ($c in $chars.ToCharArray()) {
            Write-Host -NoNewline "`rProcessing... $c"
            Start-Sleep -Milliseconds 150
        }
    }
    Write-Host ""
}

# ===== CORE INSTALL FUNCTION =====

function Install-App($name, $id) {

    Show-Title "INSTALL $name"

    Show-Status "Preparing installation..."
    Start-Sleep 1

    Show-Status "Running winget..."
    
    try {
        Start-Process "winget" `
            -ArgumentList "install --id $id --exact --accept-package-agreements --accept-source-agreements" `
            -Wait -NoNewWindow

        Show-Success "$name installed successfully!"
    }
    catch {
        Show-Error "$name installation failed!"
    }

    Write-Host ""
}

# ===== APPS =====

function Install-Chrome {
    Install-App "Google Chrome" "Google.Chrome"
}

function Install-Edge {
    Install-App "Microsoft Edge" "Microsoft.Edge"
}

function Install-Firefox {
    Install-App "Mozilla Firefox" "Mozilla.Firefox"
}

function Install-Office {

    Show-Title "INSTALL MICROSOFT OFFICE 365"

    Show-Status "This may take 5-15 minutes..."
    Show-Status "Downloading & installing in background..."

    # Fake loading để user không nghĩ bị treo
    Start-Job {
        $chars = "|/-\"
        while ($true) {
            foreach ($c in $chars.ToCharArray()) {
                Write-Host -NoNewline "`rInstalling Office... $c"
                Start-Sleep -Milliseconds 200
            }
        }
    } | Out-Null

    try {
        Start-Process "winget" `
            -ArgumentList "install --id Microsoft.Office --exact --accept-package-agreements --accept-source-agreements" `
            -Wait -NoNewWindow

        Get-Job | Stop-Job | Remove-Job

        Write-Host "`r" -NoNewline
        Show-Success "Office installed successfully!"
    }
    catch {
        Get-Job | Stop-Job | Remove-Job

        Write-Host "`r" -NoNewline
        Show-Error "Office installation failed!"
    }

    Write-Host ""
}
