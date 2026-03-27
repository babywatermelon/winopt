# ===============================
# WINOPT REPAIR MODULE
# ===============================

# -------------------------------
function Create-RestorePoint {
    Write-Host ""
    Write-Host "=== CREATE SYSTEM RESTORE POINT ===" -ForegroundColor Cyan
    Write-Host ""

    # Xác nhận mạnh từ người dùng
    $confirm = Read-Host "Ban co chac chan muon tao System Restore Point khong? (Y/N)"
    if ($confirm -ne "Y" -and $confirm -ne "y") {
        Write-Host "Da huy tao Restore Point." -ForegroundColor Yellow
        return
    }

    Write-Host "Dang tao System Restore Point..." -ForegroundColor Yellow
    Write-Host "Vui long doi trong vai giay..." -ForegroundColor DarkGray

    try {
        # Tạo restore point với mô tả rõ ràng
        $description = "WinOpt Restore Point - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
        
        Checkpoint-Computer -Description $description -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop

        Write-Host ""
        Write-Host "TAO RESTORE POINT THANH CONG!" -ForegroundColor Green
        Write-Host "Mo ta: $description" -ForegroundColor White
        Write-Host "Ban co the su dung no de khoi phuc he thong neu can." -ForegroundColor Gray
    }
    catch {
        Write-Host ""
        Write-Host "Loi khi tao Restore Point:" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        Write-Host "Luu y: System Restore phai duoc bat tren o dia he thong (thuong la C:)." -ForegroundColor Yellow
    }
}

# -------------------------------
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
    
    # Gợi ý tạo Restore Point trước khi Full Repair
    $createRP = Read-Host "Ban co muon tao System Restore Point truoc khi chay Full Repair khong? (Y/N - mac dinh Y)"
    if ($createRP -eq "Y" -or $createRP -eq "y" -or $createRP -eq "") {
        Create-RestorePoint
    }

    Write-Host ""
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
