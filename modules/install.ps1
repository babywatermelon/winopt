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
    Write-Host "[OK] $text" -ForegroundColor Green
}

function Fail($text) {
    Write-Host "[FAIL] $text" -ForegroundColor Red
}

function Step($text) {
    Write-Host "-> $text" -ForegroundColor DarkCyan
}

# ===== CORE =====

function Install-App($name, $id) {
    Title "Installing $name"

    # Hỏi người dùng trước khi cài đặt
    $confirm = Read-Host "Bạn có muốn cài $name không? (Y/N)"
    if ($confirm -ne "Y") {
        Info "Đã hủy thao tác cài $name"
        return
    }

    Step "Starting installation..."
    Info "Please wait..."

    try {
        winget install --id $id --exact `
            --accept-package-agreements `
            --accept-source-agreements `
            --silent

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
        winget install --id Microsoft.Office `
            --exact `
            --accept-package-agreements `
            --accept-source-agreements

        if ($LASTEXITCODE -eq 0) {
            Done "Microsoft Office installed successfully"
        }
        else {
            throw "Exit code $LASTEXITCODE"
        }
    }
    catch {
        Fail "Office installation failed"
    }

    Write-Host ""
}

function Install-CPUZ {
    Install-App "CPU-Z" "CPUID.CPU-Z"
}

function Install-GPUZ {
    Install-App "GPU-Z" "TechPowerUp.GPU-Z"
}

function Install-HWMonitor {
    Install-App "HWMonitor" "CPUID.HWMonitor"
}

function Install-CrystalDiskInfo {
    Install-App "CrystalDiskInfo" "CrystalDewWorld.CrystalDiskInfo"
}
