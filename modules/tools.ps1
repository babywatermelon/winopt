# ===============================
# WINOPT WINDOWS TOOLS MODULE
# ===============================

function Restart-Explorer {

    Write-Host ""
    Write-Host "Restarting Windows Explorer..." -ForegroundColor Yellow

    taskkill /f /im explorer.exe
    Start-Process explorer.exe

    Write-Host "Explorer restarted." -ForegroundColor Green
}

# -------------------------------

function Clear-Recycle {

    Write-Host ""
    Write-Host "Clearing Recycle Bin..." -ForegroundColor Yellow

    Clear-RecycleBin -Force -ErrorAction SilentlyContinue

    Write-Host "Recycle Bin cleared." -ForegroundColor Green
}

# -------------------------------

function Open-TaskManager {

    Write-Host "Opening Task Manager..." -ForegroundColor Yellow
    Start-Process taskmgr
}

# -------------------------------

function Open-ControlPanel {

    Write-Host "Opening Control Panel..." -ForegroundColor Yellow
    Start-Process control
}

# -------------------------------

function Open-DeviceManager {

    Write-Host "Opening Device Manager..." -ForegroundColor Yellow
    Start-Process devmgmt.msc
}

# -------------------------------

function Open-Services {

    Write-Host "Opening Services..." -ForegroundColor Yellow
    Start-Process services.msc
}

# -------------------------------

function Open-DiskManagement {

    Write-Host "Opening Disk Management..." -ForegroundColor Yellow
    Start-Process diskmgmt.msc
}

# -------------------------------

function Open-SystemProperties {

    Write-Host "Opening System Properties..." -ForegroundColor Yellow
    Start-Process sysdm.cpl
}

# -------------------------------

function Open-StartupApps {

    Write-Host "Opening Startup Apps..." -ForegroundColor Yellow
    Start-Process "ms-settings:startupapps"
}
