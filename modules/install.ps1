# ===== UI =====

function Line {
    Write-Host "----------------------------------------" -ForegroundColor DarkGray
}

function Title($text) {
    Line
    Write-Host " $text" -ForegroundColor Cyan
    Line
}

function Status($text) {
    Write-Host "[*] $text" -ForegroundColor Yellow
}

function Done($text) {
    Write-Host "[✓] $text" -ForegroundColor Green
}

function Fail($text) {
    Write-Host "[✗] $text" -ForegroundColor Red
}

function Wait-Animation {
    $chars = "|/-\"
    for ($i = 0; $i -lt 15; $i++) {
        foreach ($c in $chars.ToCharArray()) {
            Write-Host -NoNewline "`rProcessing... $c"
            Start-Sleep -Milliseconds 120
        }
    }
    Write-Host ""
}

# ===== CORE =====

function Install-App($name, $id) {

    Title "INSTALL $name"

    Status "Checking package..."
    Start-Sleep 1

    Status "Starting installation..."
    Wait-Animation

    try {
        Start-Process "winget" `
            -ArgumentList "install --id $id --exact --accept-package-agreements --accept-source-agreements" `
            -Wait

        Done "$name installed successfully"
    }
    catch {
        Fail "$name installation failed"
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

    Title "INSTALL MICROSOFT OFFICE 365"

    Status "This may take several minutes..."
    Status "Running in background..."

    # Loading chạy song song
    $job = Start-Job {
        $chars = "|/-\"
        while ($true) {
            foreach ($c in $chars.ToCharArray()) {
                Write-Host -NoNewline "`rInstalling Office... $c"
                Start-Sleep -Milliseconds 200
            }
        }
    }

    try {
        Start-Process "winget" `
            -ArgumentList "install --id Microsoft.Office --exact --accept-package-agreements --accept-source-agreements" `
            -Wait

        Stop-Job $job | Out-Null
        Remove-Job $job

        Write-Host "`r" -NoNewline
        Done "Microsoft Office installed successfully"
    }
    catch {
        Stop-Job $job | Out-Null
        Remove-Job $job

        Write-Host "`r" -NoNewline
        Fail "Office installation failed"
    }

    Write-Host ""
}
