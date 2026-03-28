# ====================== DISABLE WINDOWS UPDATE (RẤT MẠNH - Giống WUB) ======================
function Disable-WindowsUpdate {
    Write-Host "`n--- DANG TAT WINDOWS UPDATE TRIET DE (Protect cao cap) ---" -ForegroundColor Yellow

    $services = @("wuauserv", "bits", "dosvc", "UsoSvc", "WaaSMedicSvc")

    foreach ($service in $services) {
        Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
        Set-Service -Name $service -StartupType Disabled -ErrorAction SilentlyContinue
        Write-Host " [✓] Disabled: $service" -ForegroundColor Gray
    }

    # Registry Policy
    $AUPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    if (!(Test-Path $AUPath)) { New-Item -Path $AUPath -Force | Out-Null }
    Set-ItemProperty -Path $AUPath -Name "NoAutoUpdate" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $AUPath -Name "AUOptions" -Value 1 -Type DWord -Force

    $UXPath = "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings"
    if (!(Test-Path $UXPath)) { New-Item -Path $UXPath -Force | Out-Null }
    Set-ItemProperty -Path $UXPath -Name "PauseUpdatesExpiryTime" -Value "2099-12-31T23:59:59Z" -Type String -Force

    # Disable tasks
    Get-ScheduledTask -TaskPath "\Microsoft\Windows\WindowsUpdate\" -ErrorAction SilentlyContinue | Disable-ScheduledTask
    Get-ScheduledTask -TaskPath "\Microsoft\Windows\UpdateOrchestrator\" -ErrorAction SilentlyContinue | Disable-ScheduledTask

    # Protect services (Security Descriptor + Registry)
    Write-Host "`nDang protect services..." -ForegroundColor Cyan
    $critical = @("wuauserv", "WaaSMedicSvc", "UsoSvc")

    foreach ($svc in $critical) {
        $key = "HKLM:\SYSTEM\CurrentControlSet\Services\$svc"
        if (Test-Path $key) {
            # Security Descriptor mạnh (giống WUB Protect)
            sc.exe sdset $svc "D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWLOCRRC;;;PU)" | Out-Null
        }
    }

    Write-Host "`nTHANH CONG: Windows Update da bi tat TRIET DE!" -ForegroundColor Green
    Write-Host "Khuyen nghi: Restart may." -ForegroundColor Cyan
}

# ====================== ENABLE WINDOWS UPDATE (FULL RESET - MẠNH NHẤT) ======================
function Enable-WindowsUpdate {
    Write-Host "`n--- BAT LAI WINDOWS UPDATE (Full Reset + Fix Permissions) ---" -ForegroundColor Cyan

    # 1. Xóa Policy
    Remove-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Recurse -Force -ErrorAction SilentlyContinue

    # 2. Reset Startup Type bằng sc.exe (ổn định nhất)
    Write-Host "Reset Startup Type..." -ForegroundColor Yellow
    $svcs = @("wuauserv", "bits", "cryptSvc", "msiserver", "UsoSvc", "WaaSMedicSvc")
    foreach ($s in $svcs) {
        sc.exe config $s start= demand | Out-Null
    }

    # 3. Fix Permissions Registry (quan trọng nhất)
    Write-Host "Fixing Registry Permissions..." -ForegroundColor Yellow
    $critical = @("wuauserv", "WaaSMedicSvc", "UsoSvc")

    foreach ($svc in $critical) {
        $keyPath = "HKLM:\SYSTEM\CurrentControlSet\Services\$svc"
        if (Test-Path $keyPath) {
            try {
                # Lấy ownership bằng .NET (ổn định hơn)
                $reg = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey("SYSTEM\CurrentControlSet\Services\$svc", [Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree, [System.Security.AccessControl.RegistryRights]::TakeOwnership)
                $acl = $reg.GetAccessControl()
                $acl.SetOwner([System.Security.Principal.NTAccount]"Administrators")
                $reg.SetAccessControl($acl)
                $reg.Close()

                # Grant Full Control
                $reg = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey("SYSTEM\CurrentControlSet\Services\$svc", [Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree, [System.Security.AccessControl.RegistryRights]::ChangePermissions)
                $acl = $reg.GetAccessControl()
                $rule = New-Object System.Security.AccessControl.RegistryAccessRule("Administrators", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
                $acl.SetAccessRule($rule)
                $reg.SetAccessControl($acl)
                $reg.Close()

                # Xóa Deny rules nếu có
                $acl = Get-Acl $keyPath
                $denyRules = $acl.Access | Where-Object { $_.AccessControlType -eq "Deny" }
                foreach ($rule in $denyRules) {
                    $acl.RemoveAccessRule($rule) | Out-Null
                }
                Set-Acl -Path $keyPath -AclObject $acl

                Write-Host " [✓] Fixed permissions: $svc" -ForegroundColor Gray
            }
            catch {
                Write-Host " [!] Cannot fix $svc fully: $($_.Exception.Message)" -ForegroundColor Yellow
            }
        }
    }

    # 4. Reset cache
    Write-Host "Resetting Update Cache..." -ForegroundColor Yellow
    Stop-Service wuauserv, bits, cryptSvc, msiserver, WaaSMedicSvc -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:windir\SoftwareDistribution\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:windir\System32\catroot2\*" -Recurse -Force -ErrorAction SilentlyContinue

    # 5. Start services
    Start-Service bits, cryptSvc, msiserver -ErrorAction SilentlyContinue
    Start-Service wuauserv -ErrorAction SilentlyContinue

    # 6. Enable tasks
    Get-ScheduledTask -TaskPath "\Microsoft\Windows\WindowsUpdate\" -ErrorAction SilentlyContinue | Enable-ScheduledTask
    Get-ScheduledTask -TaskPath "\Microsoft\Windows\UpdateOrchestrator\" -ErrorAction SilentlyContinue | Enable-ScheduledTask

    Write-Host "`n=== HOAN TAT FULL RESET ===" -ForegroundColor Green
    Write-Host "Vui long RESTART MAY NGAY BAY GIO!" -ForegroundColor Magenta
    Write-Host "Sau restart, mo services.msc (Run as Administrator) → Windows Update → Startup type = Manual hoặc Automatic → Start" -ForegroundColor Cyan
}
