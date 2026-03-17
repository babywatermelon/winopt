# ===== UI NHẸ =====

function Title($text) {
    Write-Host ""
    Write-Host "========== $text ==========" -ForegroundColor Cyan
}

function Done($text) {
    Write-Host "[OK] $text" -ForegroundColor Green
}

function Fail($text) {
    Write-Host "[ERROR] $text" -ForegroundColor Red
}

# ===== CORE (CHẠY TRỰC TIẾP WINGET) =====

function Install-App($name, $id) {

    Title "Installing $name"

    try {
        winget install --id $id --exact --accept-package-agreements --accept-source-agreements

        Done "$name installed"
    }
    catch {
        Fail "$name install failed"
    }
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
    Write-Host "Please wait... this may take several minutes" -ForegroundColor Yellow

    try {
        winget install --id Microsoft.Office --exact --accept-package-agreements --accept-source-agreements

        Done "Office installed"
    }
    catch {
        Fail "Office install failed"
    }
}
