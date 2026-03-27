# ===============================
# WINOPT REPAIR MODULE
# ===============================

# -------------------------------
# -------------------------------
function Create-RestorePoint {
    Write-Host ""
    Write-Host "=== TAO SYSTEM RESTORE POINT ===" -ForegroundColor Cyan
    Write-Host ""

    # Kiểm tra quyền Admin
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "Loi: Vui long chay WinOpt voi quyen Administrator!" -ForegroundColor Red
        return
    }

    # Xac nhan tu nguoi dung
    $confirm = Read-Host "Ban co chac chan muon tao System Restore Point khong? (Y/N)"
    if ($confirm -ne "Y" -and $confirm -ne "y") {
        Write-Host "Da huy tao Restore Point." -ForegroundColor Yellow
        return
    }

    Write-Host "Dang kiem tra dich vu System Restore..." -ForegroundColor Yellow

    try {
        # Kiem tra va bat dich vu System Restore neu can
        $service = Get-Service -Name "srpv" -ErrorAction SilentlyContinue
        
        if ($service -and $service.Status -ne "Running") {
            Write-Host "Dich vu System Restore dang bi tat. Dang bat..." -ForegroundColor Yellow
            Set-Service -Name "srpv" -StartupType Automatic -ErrorAction Stop
            Start-Service -Name "srpv" -ErrorAction Stop
            Write-Host "Da bat dich vu System Restore thanh cong." -ForegroundColor Green
        }

        # Kiem tra va bat System Protection tren o C:
        $protection = Get-ComputerRestorePoint -ErrorAction SilentlyContinue
        if (-not $protection) {
            Write-Host "Dang bat System Protection tren o dia C: ..." -ForegroundColor Yellow
            Enable-ComputerRestore -Drive "C:\" -ErrorAction Stop
            Write-Host "Da bat System Protection tren C: thanh cong." -ForegroundColor Green
        }

        # Tao Restore Point
        Write-Host ""
        Write-Host "Dang tao System Restore Point..." -ForegroundColor Yellow
        $description = "WinOpt Restore Point - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"

        Checkpoint-Computer -Description $description -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop

        Write-Host ""
        Write-Host "TAO RESTORE POINT THANH CONG!" -ForegroundColor Green
        Write-Host "Mo ta: $description" -ForegroundColor White
        Write-Host "Ban co the dung no de khoi phuc he thong neu can thiet." -ForegroundColor Gray
    }
    catch {
        Write-Host ""
        Write-Host "Loi khi tao Restore Point:" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        Write-Host ""
        Write-Host "Goi y khac phuc:" -ForegroundColor Yellow
        Write-Host "- Chay tool voi quyen Administrator" -ForegroundColor Gray
        Write-Host "- Mo System Protection thu cong: Tim 'Create a restore point' trong Search" -ForegroundColor Gray
        Write-Host "- Dam bao o C: co duong luong trong (it nhat 5-10GB)" -ForegroundColor Gray
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
