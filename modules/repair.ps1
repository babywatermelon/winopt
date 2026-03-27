# ===============================
# WINOPT REPAIR MODULE
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

# ===============================
# CHUC NANG KHOI PHUC HE THONG
function Restore-ComputerPoint {
    Write-Host ""
    Write-Host "=== KHOI PHUC HE THONG (SYSTEM RESTORE) ===" -ForegroundColor Cyan
    Write-Host ""

    # 1. Kiem tra quyen Admin
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "Loi: Vui long chay WinOpt voi quyen Administrator!" -ForegroundColor Red
        return
    }

    # 2. Lay danh sach cac diem Restore hien co
    Write-Host "Dang tai danh sach cac diem khoi phuc..." -ForegroundColor Yellow
    $restorePoints = Get-ComputerRestorePoint -ErrorAction SilentlyContinue

    if (-not $restorePoints) {
        Write-Host "Khong tim thay diem khoi phuc (Restore Point) nao trong he thong!" -ForegroundColor Red
        Write-Host "Goi y: Ban hay dung chuc nang [14] de tao mot diem truoc." -ForegroundColor Gray
        return
    }

    # Hiển thị điểm mới nhất cho người dùng xem
    $latest = $restorePoints | Sort-Object CreationTime -Descending | Select-Object -First 1
    Write-Host "Diem khoi phuc gan nhat duoc tim thay:" -ForegroundColor White
    Write-Host " - Ten: $($latest.Description)" -ForegroundColor Green
    Write-Host " - Ngay tao: $($latest.CreationTime)" -ForegroundColor Green
    Write-Host " - ID: $($latest.SequenceNumber)" -ForegroundColor Green
    Write-Host ""

    # 3. Xac nhan khoi phuc
    Write-Host "Luu y: Khi bat dau, Windows se mo trinh khoi phuc." -ForegroundColor Yellow
    $confirm = Read-Host "Ban co muon tien hanh khoi phuc khong? (Y/N)"
    
    if ($confirm -eq "Y" -or $confirm -eq "y") {
        Write-Host "Dang khoi chay System Restore Wizard..." -ForegroundColor Cyan
        
        # Goi trinh Restore cua Windows (rstrui.exe)
        # Lenh nay se mo cua so Restore va tu chon diem gan nhat neu co the
        Start-Process "rstrui.exe" -ArgumentList "/latest" -Wait
        
        Write-Host ""
        Write-Host "Da gui yeu cau khoi phuc. Vui long lam theo huong dan tren man hinh Windows." -ForegroundColor White
    } else {
        Write-Host "Da huy thao tac khoi phuc." -ForegroundColor Yellow
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
