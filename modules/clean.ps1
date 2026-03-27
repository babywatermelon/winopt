# ===============================
# WINOPT CLEAN MODULE
# ===============================
function Clean-RAMCache {
    Write-Host ""
    Write-Host "=== DON DEP RAM CACHE (STANDBY LIST) ===" -ForegroundColor Cyan
    Write-Host "Dang kich hoat dac quyen he thong..." -ForegroundColor Yellow

    $Code = @"
    using System;
    using System.Runtime.InteropServices;
    using System.Security.Principal;

    public class RAMCleaner {
        [DllImport("ntdll.dll")]
        public static extern UInt32 NtSetSystemInformation(int InfoClass, IntPtr Info, int Length);

        [StructLayout(LayoutKind.Sequential, Pack = 1)]
        public struct TOKEN_PRIVILEGES {
            public int PrivilegeCount;
            public long Luid;
            public int Attributes;
        }

        [DllImport("advapi32.dll", SetLastError = true)]
        public static extern bool OpenProcessToken(IntPtr ProcessHandle, uint DesiredAccess, out IntPtr TokenHandle);

        [DllImport("advapi32.dll", SetLastError = true, CharSet = CharSet.Auto)]
        public static extern bool LookupPrivilegeValue(string lpSystemName, string lpName, out long lpLuid);

        [DllImport("advapi32.dll", SetLastError = true)]
        public static extern bool AdjustTokenPrivileges(IntPtr TokenHandle, bool DisableAllPrivileges, ref TOKEN_PRIVILEGES NewState, int BufferLength, IntPtr PreviousState, IntPtr ReturnLength);

        public static void EmptyCache() {
            // Cap quyen SE_PROFILE_SINGLE_PROCESS_NAME hoac SE_INCREASE_QUOTA_NAME
            IntPtr hToken;
            TOKEN_PRIVILEGES tkp = new TOKEN_PRIVILEGES();
            OpenProcessToken(System.Diagnostics.Process.GetCurrentProcess().Handle, 0x0020 | 0x0008, out hToken);
            tkp.PrivilegeCount = 1;
            LookupPrivilegeValue(null, "SeProfileSingleProcessPrivilege", out tkp.Luid);
            tkp.Attributes = 0x00000002;
            AdjustTokenPrivileges(hToken, false, ref tkp, 0, IntPtr.Zero, IntPtr.Zero);

            // Lenh giai phong Standby List
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
        # Neu class da ton tai thi khong can Add-Type lai de tranh loi
        if (-not ([System.Management.Automation.PSTypeName]"RAMCleaner").Type) {
            Add-Type -TypeDefinition $Code -ErrorAction SilentlyContinue
        }
        
        [RAMCleaner]::EmptyCache()
        Write-Host "THANH CONG: Da giai phong Standby List." -ForegroundColor Green
    }
    catch {
        Write-Host "Loi: Khong the can thiep vao Kernel." -ForegroundColor Red
        Write-Host "Goi y: Hay kiem tra xem Antivirus co dang chan script khong." -ForegroundColor Gray
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
