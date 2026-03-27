# ===============================
# WINOPT CLEAN MODULE
# ===============================
function Clean-RAMCache {
    Write-Host ""
    Write-Host "=== DON DEP RAM CACHE (STANDBY LIST) ===" -ForegroundColor Cyan
    Write-Host "Dang giai phong bo nho dem he thong..." -ForegroundColor Yellow

    # Dinh nghia API de can thiep vao he thong
    $Code = @"
    using System;
    using System.Runtime.InteropServices;

    public class RAMCleaner {
        [DllImport("advapi32.dll", SetLastError = true)]
        public static extern bool PrivilegeCheck(IntPtr TokenHandle, ref PRIVILEGE_SET RequiredPrivileges, out bool pfResult);

        [DllImport("ntdll.dll")]
        public static extern UInt32 NtSetSystemInformation(int InfoClass, IntPtr Info, int Length);

        public static void EmptyCache() {
            // 4 la ma lenh de don sach SystemMemoryList (Standby List)
            int SystemMemoryListPurge = 4;
            int size = Marshal.SizeOf(SystemMemoryListPurge);
            IntPtr pSize = Marshal.AllocHGlobal(size);
            Marshal.StructureToPtr(SystemMemoryListPurge, pSize, false);
            
            NtSetSystemInformation(80, pSize, size);
            Marshal.FreeHGlobal(pSize);
        }
    }
"@

    try {
        # Load code C# vao PowerShell
        Add-Type -TypeDefinition $Code -ErrorAction SilentlyContinue
        
        # Thuc thi don dep
        [RAMCleaner]::EmptyCache()

        Write-Host "THANH CONG: Da xoa sach Standby List." -ForegroundColor Green
        Write-Host "Hay kiem tra lai muc 'Cached' trong Task Manager." -ForegroundColor White
    }
    catch {
        Write-Host "Loi: Khong the don dep Cache. Hay dam bao ban chay quyen Admin." -ForegroundColor Red
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
