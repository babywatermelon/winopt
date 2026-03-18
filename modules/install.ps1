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

# ===== CHECK =====

function Check-Winget {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Fail "Winget not found!"
        return $false
    }
    return $true
}

# ===== CORE =====

function Install-App($name, $id) {

    if (-not (Check-Winget)) { return }

    Title "Installing $name"

    Step "Starting installation..."
    Info "Please wait..."

    $args = @(
        "install",
        "--id", $id,
        "--exact",
        "--accept-package-agreements",
        "--accept-source-agreements",
        "-e"
    )

    $process = Start-Process -FilePath "winget" `
        -ArgumentList $args `
        -Wait `
        -PassThru `
        -NoNewWindow

    if ($process.ExitCode -eq 0) {
        Done "$name installed successfully"
    }
    else {
        Fail "$name installation failed (Code: $($process.ExitCode))"
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

## Office (GIỮ WINGET)
function Install-Office {
    Install-App "Microsoft Office" "Microsoft.Office"
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

    Install-Chrome
    Install-Firefox
    Install-Edge

    Install-Office

    Install-CPUZ
    Install-GPUZ
    Install-CrystalDiskInfo
    Install-HWMonitor
}
