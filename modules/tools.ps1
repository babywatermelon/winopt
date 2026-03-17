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

# -------------------------------

function Show-SystemInfo {

    Clear-Host
    Write-Host "========== SYSTEM INFORMATION ==========" -ForegroundColor Cyan

    # OS Info
    $os = Get-CimInstance Win32_OperatingSystem
    Write-Host ""
    Write-Host "[OS]" -ForegroundColor Yellow
    Write-Host "Name: $($os.Caption)"
    Write-Host "Version: $($os.Version)"
    Write-Host "Architecture: $($os.OSArchitecture)"
    Write-Host "Last Boot: $($os.LastBootUpTime)"

    # CPU Info
    $cpu = Get-CimInstance Win32_Processor
    Write-Host ""
    Write-Host "[CPU]" -ForegroundColor Yellow
    Write-Host "Name: $($cpu.Name)"
    Write-Host "Cores: $($cpu.NumberOfCores)"
    Write-Host "Threads: $($cpu.NumberOfLogicalProcessors)"

    # RAM Info
    $ram = Get-CimInstance Win32_ComputerSystem
    $totalRAM = [math]::Round($ram.TotalPhysicalMemory / 1GB, 2)
    Write-Host ""
    Write-Host "[RAM]" -ForegroundColor Yellow
    Write-Host "Total RAM: $totalRAM GB"

    # Disk Info
    Write-Host ""
    Write-Host "[DISK]" -ForegroundColor Yellow
    Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
        $size = [math]::Round($_.Size / 1GB, 2)
        $free = [math]::Round($_.FreeSpace / 1GB, 2)
        Write-Host "$($_.DeviceID) - Total: $size GB | Free: $free GB"
    }

    # GPU Info
    $gpu = Get-CimInstance Win32_VideoController
    Write-Host ""
    Write-Host "[GPU]" -ForegroundColor Yellow
    foreach ($g in $gpu) {
        Write-Host "Name: $($g.Name)"
    }

    # Network Info
    Write-Host ""
    Write-Host "[NETWORK]" -ForegroundColor Yellow
    Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike "127.*"} | ForEach-Object {
        Write-Host "IP Address: $($_.IPAddress)"
    }

    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
}
