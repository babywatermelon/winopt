# ====================== DISABLE WINDOWS UPDATE (MẠNH - Giống WUB) ======================
function Disable-WindowsUpdate {
    Write-Host "`n--- DANG TAT WINDOWS UPDATE TRIET DE (Kieu WUB - Co Protect) ---" -ForegroundColor Yellow

    $services = @("wuauserv", "bits", "dosvc", "UsoSvc", "WaaSMedicSvc", "WaaSMedicService")

    # 1. Stop tất cả services
    foreach ($service in $services) {
        Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
        Set-Service -Name $service -StartupType Disabled -ErrorAction SilentlyContinue
        Write-Host "Stopped & Disabled: $service" -ForegroundColor Gray
    }

    # 2. Registry Policy chặn Update
    $regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    if (!(Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    Set-ItemProperty -Path $regPath -Name "NoAutoUpdate" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "AUOptions" -Value 1 -Type DWord -Force

    # Pause Updates vĩnh viễn
    $uxPath = "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings"
    if (!(Test-Path $uxPath)) { New-Item -Path $uxPath -Force | Out-Null }
    Set-ItemProperty -Path $uxPath -Name "PauseUpdatesExpiryTime" -Value "2099-12-31T23:59:59Z" -Type String -Force

    # 3. Disable Scheduled Tasks
    Get-ScheduledTask -TaskPath "\Microsoft\Windows\WindowsUpdate\" -ErrorAction SilentlyContinue | Disable-ScheduledTask -ErrorAction SilentlyContinue
    Get-ScheduledTask -TaskPath "\Microsoft\Windows\UpdateOrchestrator\" -ErrorAction SilentlyContinue | Disable-ScheduledTask -ErrorAction SilentlyContinue

    # 4. === PHẦN MẠNH NHẤT: Protect Service Settings (giống WUB) ===
    Write-Host "`nAp dung Protect Service Settings..." -ForegroundColor Cyan

    $criticalServices = @("wuauserv", "WaaSMedicSvc", "UsoSvc")
    foreach ($svc in $criticalServices) {
        $regKey = "HKLM:\SYSTEM\CurrentControlSet\Services\$svc"
        if (Test-Path $regKey) {
            # Lấy Ownership cho Administrators
            $acl = Get-Acl $regKey
            $admins = New-Object System.Security.Principal.NTAccount("Administrators")
            $acl.SetOwner($admins)
            Set-Acl -Path $regKey -AclObject $acl

            # Grant Full Control cho Administrators
            $rule = New-Object System.Security.AccessControl.RegistryAccessRule("Administrators","FullControl","ContainerInherit,ObjectInherit","None","Allow")
            $acl.SetAccessRule($rule)
            Set-Acl -Path $regKey -AclObject $acl

            # Deny Write cho SYSTEM (ngăn Medic Service tự sửa)
            try {
                $denyRule = New-Object System.Security.AccessControl.RegistryAccessRule("SYSTEM","WriteKey","ContainerInherit,ObjectInherit","None","Deny")
                $acl.AddAccessRule($denyRule)
                Set-Acl -Path $regKey -AclObject $acl
                Write-Host "Protected $svc (Deny SYSTEM Write)" -ForegroundColor Gray
            } catch {}
        }

        # Security Descriptor mạnh (Protect)
        sc.exe sdset $svc "D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWLOCRRC;;;PU)" | Out-Null
    }

    Write-Host "`nTHANH CONG: Windows Update da bi vo hieu hoa TRIET DE voi Protect!" -ForegroundColor Green
    Write-Host "Khuyen nghi: Restart may de ap dung." -ForegroundColor Cyan
}

# ====================== ENABLE WINDOWS UPDATE (Khôi phục) ======================
function Enable-WindowsUpdate {
    Write-Host "`n--- BAT LAI WINDOWS UPDATE (Full Reset + Restore Permissions) ---" -ForegroundColor Cyan

    # 1. Xóa Policy
    Remove-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Recurse -Force -ErrorAction SilentlyContinue

    # 2. Reset Startup Type
    $services = @("wuauserv", "bits", "cryptSvc", "msiserver", "UsoSvc", "WaaSMedicSvc")
    foreach ($svc in $services) {
        sc.exe config $svc start= demand | Out-Null   # demand = Manual (Trigger Start)
        Write-Host " $svc -> Manual/Demand" -ForegroundColor Gray
    }

    # 3. Restore Permissions (xóa Deny)
    $criticalServices = @("wuauserv", "WaaSMedicSvc", "UsoSvc")
    foreach ($svc in $criticalServices) {
        $regKey = "HKLM:\SYSTEM\CurrentControlSet\Services\$svc"
        if (Test-Path $regKey) {
            $acl = Get-Acl $regKey
            # Xóa rule Deny của SYSTEM
            $acl.Access | Where-Object { $_.AccessControlType -eq "Deny" } | ForEach-Object {
                $acl.RemoveAccessRule($_)
            }
            Set-Acl -Path $regKey -AclObject $acl
            Write-Host "Restored permissions for $svc" -ForegroundColor Gray
        }
    }

    # 4. Reset cache
    Stop-Service wuauserv, bits, cryptSvc, msiserver, WaaSMedicSvc -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:windir\SoftwareDistribution\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:windir\System32\catroot2\*" -Recurse -Force -ErrorAction SilentlyContinue

    # 5. Start services
    Start-Service bits, cryptSvc, msiserver -ErrorAction SilentlyContinue
    Start-Service wuauserv -ErrorAction SilentlyContinue

    # 6. Enable tasks
    Get-ScheduledTask -TaskPath "\Microsoft\Windows\WindowsUpdate\" -ErrorAction SilentlyContinue | Enable-ScheduledTask -ErrorAction SilentlyContinue
    Get-ScheduledTask -TaskPath "\Microsoft\Windows\UpdateOrchestrator\" -ErrorAction SilentlyContinue | Enable-ScheduledTask -ErrorAction SilentlyContinue

    Write-Host "`n=== HOAN TAT KHÔI PHỤC ===" -ForegroundColor Green
    Write-Host "Vui long RESTART MAY ngay bay gio!" -ForegroundColor Magenta
    Write-Host "Sau restart, mo services.msc (Run as Admin) de kiem tra va Start Windows Update." -ForegroundColor Cyan
}
