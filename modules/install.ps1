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

    Step "Starting installation..."
    Info "Please wait..."

    try {
        winget install --id $id --exact `
        --accept-package-agreements `
        --accept-source-agreements `
        --silent `
        -e

        if ($LASTEXITCODE -eq 0) {
            Done "$name installed successfully"
        }
        else {
            throw "Exit code $LASTEXITCODE"
        }
    }
    catch {
        Fail "$name installation failed"
    }

    Write-Host ""
}

# ===== APPS =====

## Browsers
function Install-Chrome {
    Install-App "Google Chrome" "Google.Chrome"
}

function Install-Edge {
    Install-App "Microsoft Edge" "Microsoft.Edge"
}

function Install-Firefox {
    Install-App "Mozilla Firefox" "Mozilla.Firefox"
}

## Office
function Install-Office {
    Install-App "Microsoft Office 365" "Microsoft.Office"
}

## Hardware Tools
function Install-CPUZ {
    Install-App "CPU-Z" "CPUID.CPU-Z"
}

function Install-GPUZ {
    Install-App "GPU-Z" "TechPowerUp.GPU-Z"
}

function Install-CrystalDiskInfo {
    Install-App "CrystalDiskInfo" "CrystalDewWorld.CrystalDiskInfo"
}

function Install-HWMonitor {
    Install-App "HWMonitor" "CPUID.HWMonitor"
}
# ===== BUNDLE =====

function Install-All {

    Title "Installing All Selected Apps"

    # Browsers
    Install-Chrome
    Install-Firefox
    Install-Edge

    # Office
    Install-Office

    # Hardware
    Install-CPUZ
    Install-GPUZ
    Install-CrystalDiskInfo
    Install-HWMonitor
}
