# ===============================
# WINOPT REPAIR MODULE
# ===============================

function Repair-DISM {

    Write-Host ""
    Write-Host "Starting Windows Image Repair (DISM)..." -ForegroundColor Yellow
    Write-Host "This may take several minutes..." -ForegroundColor DarkGray
    Write-Host ""

    DISM /Online /Cleanup-Image /RestoreHealth

    Write-Host ""
    Write-Host "DISM repair completed." -ForegroundColor Green
}

# -------------------------------

function Repair-SFC {

    Write-Host ""
    Write-Host "Starting System File Checker (SFC)..." -ForegroundColor Yellow
    Write-Host "Scanning Windows system files..." -ForegroundColor DarkGray
    Write-Host ""

    sfc /scannow

    Write-Host ""
    Write-Host "SFC scan completed." -ForegroundColor Green
}

# -------------------------------

function Repair-Full {

    Write-Host ""
    Write-Host "Starting FULL Windows Repair..." -ForegroundColor Cyan
    Write-Host "Step 1: Repair Windows Image (DISM)"
    Write-Host ""

    DISM /Online /Cleanup-Image /RestoreHealth

    Write-Host ""
    Write-Host "Step 2: Repair System Files (SFC)"
    Write-Host ""

    sfc /scannow

    Write-Host ""
    Write-Host "Full repair completed." -ForegroundColor Green
}
