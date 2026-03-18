# ===== UI =====

function Line {
    Write-Host "============================================" -ForegroundColor DarkGray
}

function Title($text) {
    Write-Host ""
    Line
    Write-Host (" {0}" -f $text.ToUpper()) -ForegroundColor Cyan
    Line
}

function Info($text) {
    Write-Host "[*] $text" -ForegroundColor Yellow
}

function Done($text) {
    Write-Host "[✓] $text" -ForegroundColor Green
}

function Fail($text) {
    Write-Host "[✗] $text" -ForegroundColor Red
}

function Step($text) {
    Write-Host "→ $text" -ForegroundColor DarkCyan
}

# ===== CORE =====

function Install-App($name, $id) {

    Title "Installing $name"

    Step "Checking package..."
    Start-Sleep -Milliseconds 500

    Step "Starting installation..."
    Info "Please wait..."

    try {
        winget install --id $id --exact --accept-package-agreements --accept-source-agreements

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

    Title "Installing Microsoft Office 365"

    Info "This may take several minutes..."
    Info "Do not close the window"

    try {
        winget install --id Microsoft.Office --exact --accept-package-agreements --accept-source-agreements

        Done "Microsoft Office installed successfully"
    }
    catch {
        Fail "Office installation failed"
    }

    Write-Host ""
}

function Install-Zalo {

    Title "Installing Zalo"

    $url = "https://zalo.me/download/zalo-pc"
    $output = "$env:TEMP\zalo_setup.exe"

    Step "Downloading installer..."
    try {
        Invoke-WebRequest -Uri $url -OutFile $output -UseBasicParsing
        Done "Download completed"
    }
    catch {
        Fail "Download failed"
        return
    }

    Step "Starting installation..."
    try {
        Start-Process $output -Wait
        Done "Zalo installed successfully"
    }
    catch {
        Fail "Installation failed"
    }

    # Cleanup
    Remove-Item $output -ErrorAction SilentlyContinue

    Write-Host ""
}
