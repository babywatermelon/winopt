# ====================== GAMING TOOLS ======================

function Disable-GameBar {
    Write-Host "`n--- Disable Xbox Game Bar + Game DVR ---" -ForegroundColor Yellow
    
    Get-AppxPackage *XboxGamingOverlay* | Remove-AppxPackage -ErrorAction SilentlyContinue | Out-Null
    
    $path1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR"
    $path2 = "HKCU:\System\GameConfigStore"
    
    if (!(Test-Path $path1)) { New-Item -Path $path1 -Force | Out-Null }
    if (!(Test-Path $path2)) { New-Item -Path $path2 -Force | Out-Null }
    
    Set-ItemProperty -Path $path1 -Name "AppCaptureEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $path1 -Name "HistoricalCaptureEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $path2 -Name "GameDVR_Enabled" -Value 0 -Type DWord -Force
    
    Write-Host "Da tat Xbox Game Bar thanh cong!" -ForegroundColor Green
}

function Enable-GameBar {
    Write-Host "`n--- Enable Xbox Game Bar ---" -ForegroundColor Cyan
    
    $path1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR"
    $path2 = "HKCU:\System\GameConfigStore"
    
    if (!(Test-Path $path1)) { New-Item -Path $path1 -Force | Out-Null }
    if (!(Test-Path $path2)) { New-Item -Path $path2 -Force | Out-Null }
    
    Set-ItemProperty -Path $path1 -Name "AppCaptureEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $path2 -Name "GameDVR_Enabled" -Value 1 -Type DWord -Force
    
    Write-Host "Da bat lai Game Bar!" -ForegroundColor Green
}

function Disable-GameMode {
    Write-Host "`n--- Disable Game Mode ---" -ForegroundColor Yellow
    
    $path = "HKCU:\Software\Microsoft\GameBar"
    if (!(Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
    
    Set-ItemProperty -Path $path -Name "AllowAutoGameMode" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "AutoGameModeEnabled" -Value 0 -Type DWord -Force
    
    Write-Host "Game Mode da duoc tat!" -ForegroundColor Green
}

function Enable-GameMode {
    Write-Host "`n--- Enable Game Mode ---" -ForegroundColor Cyan
    
    $path = "HKCU:\Software\Microsoft\GameBar"
    if (!(Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
    
    Set-ItemProperty -Path $path -Name "AllowAutoGameMode" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "AutoGameModeEnabled" -Value 1 -Type DWord -Force
    
    Write-Host "Game Mode da duoc bat!" -ForegroundColor Green
}

function Set-HighPerformance {
    Write-Host "`n--- Set Power Plan: High Performance ---" -ForegroundColor Yellow
    powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    Write-Host "Da chuyen sang High Performance!" -ForegroundColor Green
}

function Set-Balanced {
    Write-Host "`n--- Set Power Plan: Balanced (Default) ---" -ForegroundColor Cyan
    powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e
    Write-Host "Da tro ve Balanced!" -ForegroundColor Green
}

# ====================== CORE ISOLATION (MEMORY INTEGRITY) ======================
function Disable-CoreIsolation {
    Write-Host "`n--- Disable Core Isolation (Memory Integrity) ---" -ForegroundColor Yellow
    
    $path = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity"
    
    if (!(Test-Path $path)) { 
        New-Item -Path $path -Force | Out-Null 
    }
    
    Set-ItemProperty -Path $path -Name "Enabled" -Value 0 -Type DWord -Force
    
    Write-Host "Core Isolation (Memory Integrity) da duoc TAT!" -ForegroundColor Green
    Write-Host "Luu y: Thay doi nay can RESTART MAY de ap dung." -ForegroundColor Magenta
    Write-Host "Hieu qua: Tang FPS, giam stutter cho mot so game." -ForegroundColor Cyan
}

function Enable-CoreIsolation {
    Write-Host "`n--- Enable Core Isolation (Memory Integrity) ---" -ForegroundColor Cyan
    
    $path = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity"
    
    if (!(Test-Path $path)) { 
        New-Item -Path $path -Force | Out-Null 
    }
    
    Set-ItemProperty -Path $path -Name "Enabled" -Value 1 -Type DWord -Force
    
    Write-Host "Core Isolation (Memory Integrity) da duoc BAT!" -ForegroundColor Green
    Write-Host "Luu y: Thay doi nay can RESTART MAY de ap dung." -ForegroundColor Magenta
}
