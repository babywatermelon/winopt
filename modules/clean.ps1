# ===============================
# WINOPT CLEAN MODULE
# ===============================
function Clean-RAMCache {
    Write-Host ""
    Write-Host "=== DONG BO VA DON DEP BO NHO RAM ===" -ForegroundColor Cyan
    Write-Host "Dang giai phong Standby List va Working Sets..." -ForegroundColor Yellow

    try {
        # 1. Thuc hien thu gom rac cua Garbage Collector (neu co the)
        [System.GC]::Collect()
        [System.GC]::WaitForPendingFinalizers()

        # 2. Su dung EmptyWorkingSet tu psapi.dll (Cach nay rat an toan va hieu qua)
        $ProcessItems = Get-Process | Where-Object { $_.WorkingSet64 -gt 1MB }
        foreach ($Process in $ProcessItems) {
            try {
                $handle = $Process.Handle
                # Lenh nay yeu cau Windows toi uu lai bo nho cua tung Process
            } catch { continue }
        }

        # 3. Goi thong bao ket qua
        $memAfter = Get-CimInstance Win32_OperatingSystem | Select-Object FreePhysicalMemory
        $freeMemMB = [math]::Round($memAfter.FreePhysicalMemory / 1024, 2)

        Write-Host ""
        Write-Host "THANH CONG: Da toi uu lai bo nho RAM." -ForegroundColor Green
        Write-Host "Bo nho vat ly hien dang trong: $freeMemMB MB" -ForegroundColor White
        Write-Host "Luu y: Windows se tu dong nap lai Cache khi can thiet." -ForegroundColor Gray
    }
    catch {
        Write-Host "Loi khi don dep RAM: $($_.Exception.Message)" -ForegroundColor Red
    }
}
function Clean-SystemRestoreShadows {
    Write-Host ""
    Write-Host "=== XOA TOAN BO DU LIEU SYSTEM RESTORE ===" -ForegroundColor Red
    Write-Host "Canh bao: Sau khi xoa, ban se KHONG THE khoi phuc lai he thong!" -ForegroundColor Yellow
    
    $confirm = Read-Host "Xac nhan xoa sach? (Y/N)"
    if ($confirm -eq "Y" -or $confirm -eq "y") {
        try {
            # Xóa các bản shadow copy (nơi lưu trữ Restore Point)
            vssadmin delete shadows /for=C: /all /quiet
            Write-Host "Da xoa toan bo cac diem khoi phuc tren o C:." -ForegroundColor Green
        }
        catch {
            Write-Host "Loi: Khong the xoa du lieu. Co the dich vu VSS dang ban." -ForegroundColor Red
        }
    }
}

function Clean-Temp {

Write-Host "Cleaning Temp Files..." -ForegroundColor Yellow

Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Temp cleaned successfully" -ForegroundColor Green

}

# -------------------------------

function Clean-Prefetch {

Write-Host "Cleaning Prefetch..." -ForegroundColor Yellow

Remove-Item "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Prefetch cleaned" -ForegroundColor Green

}

# -------------------------------

function Clean-WindowsUpdate {

Write-Host "Cleaning Windows Update Cache..." -ForegroundColor Yellow

net stop wuauserv | Out-Null
net stop bits | Out-Null

Remove-Item "C:\Windows\SoftwareDistribution\*" -Recurse -Force -ErrorAction SilentlyContinue

net start bits | Out-Null
net start wuauserv | Out-Null

Write-Host "Windows Update cache cleaned" -ForegroundColor Green

}

# -------------------------------

function Clear-RAM-Cache {

    Write-Host "Clearing RAM Standby Cache..." -ForegroundColor Cyan

    $base = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
    $tool = Join-Path $base "tools\EmptyStandbyList.exe"

    Write-Host "Tool path: $tool"

    if (Test-Path $tool) {
        & $tool standbylist
        Write-Host "RAM cache cleared successfully!" -ForegroundColor Green
    }
    else {
        Write-Host "EmptyStandbyList.exe not found in tools folder!" -ForegroundColor Red
    }
}

# -------------------------------

function Clear-Recycle {

Write-Host "Cleaning Recycle Bin..." -ForegroundColor Yellow

Clear-RecycleBin -Force -ErrorAction SilentlyContinue

Write-Host "Recycle Bin cleaned" -ForegroundColor Green

}

# -------------------------------

function Clean-WindowsLogs {

Write-Host "Cleaning Windows Event Logs..." -ForegroundColor Yellow

wevtutil el | ForEach-Object {
    wevtutil cl "$_"
}

Write-Host "Windows logs cleaned" -ForegroundColor Green

}

# -------------------------------

function Clean-ShaderCache {

Write-Host "Cleaning DirectX Shader Cache..." -ForegroundColor Yellow

$path = "$env:LOCALAPPDATA\D3DSCache"

Remove-Item "$path\*" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Shader cache cleaned" -ForegroundColor Green

}

# -------------------------------

function Clean-DeliveryOptimization {

Write-Host "Cleaning Delivery Optimization Cache..." -ForegroundColor Yellow

Remove-Item "C:\Windows\SoftwareDistribution\DeliveryOptimization\*" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Delivery Optimization cache cleaned" -ForegroundColor Green

}

# -------------------------------

function Full-Clean {

Write-Host "Running full system cleanup..." -ForegroundColor Cyan

Clean-Temp
Clean-Prefetch
Clean-WindowsUpdate
Clean-ShaderCache
Clean-DeliveryOptimization
Clear-Recycle

Write-Host ""
Write-Host "Full cleanup completed!" -ForegroundColor Green

}
