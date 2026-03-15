# ===============================
# WINOPT CLEAN MODULE
# ===============================

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

    $base = Split-Path $PSScriptRoot -Parent
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
