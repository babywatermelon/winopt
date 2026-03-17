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


function Open-SystemInfo {
    Write-Host "Opening System Information..." -ForegroundColor Yellow
    Start-Process msinfo32
}

function Show-SystemInfoGUI{

    Clear-Host
    Write-Host "========== SYSTEM INFORMATION ==========" -ForegroundColor Cyan

    # ===== OS =====
    $os = Get-CimInstance Win32_OperatingSystem
    Write-Host "`n[OS]" -ForegroundColor Yellow
    Write-Host "Name: $($os.Caption)"
    Write-Host "Version: $($os.Version)"
    Write-Host "Build: $($os.BuildNumber)"
    Write-Host "Architecture: $($os.OSArchitecture)"
    Write-Host "Install Date: $($os.InstallDate)"
    Write-Host "Last Boot: $($os.LastBootUpTime)"

    # ===== SYSTEM =====
    $sys = Get-CimInstance Win32_ComputerSystem
    Write-Host "`n[SYSTEM]" -ForegroundColor Yellow
    Write-Host "Manufacturer: $($sys.Manufacturer)"
    Write-Host "Model: $($sys.Model)"
    Write-Host "System Type: $($sys.SystemType)"
    Write-Host "User: $($sys.UserName)"

    # ===== CPU =====
    $cpu = Get-CimInstance Win32_Processor
    Write-Host "`n[CPU]" -ForegroundColor Yellow
    Write-Host "Name: $($cpu.Name)"
    Write-Host "Cores: $($cpu.NumberOfCores)"
    Write-Host "Threads: $($cpu.NumberOfLogicalProcessors)"

    # ===== RAM =====
    $ram = [math]::Round($sys.TotalPhysicalMemory / 1GB, 2)
    Write-Host "`n[RAM]" -ForegroundColor Yellow
    Write-Host "Total RAM: $ram GB"

    # ===== BIOS =====
    $bios = Get-CimInstance Win32_BIOS
    Write-Host "`n[BIOS]" -ForegroundColor Yellow
    Write-Host "Vendor: $($bios.Manufacturer)"
    Write-Host "Version: $($bios.SMBIOSBIOSVersion)"
    Write-Host "Release Date: $($bios.ReleaseDate)"

    # ===== MAINBOARD =====
    $board = Get-CimInstance Win32_BaseBoard
    Write-Host "`n[MAINBOARD]" -ForegroundColor Yellow
    Write-Host "Manufacturer: $($board.Manufacturer)"
    Write-Host "Product: $($board.Product)"

    # ===== GPU =====
    $gpu = Get-CimInstance Win32_VideoController
    Write-Host "`n[GPU]" -ForegroundColor Yellow
    foreach ($g in $gpu) {
        Write-Host "Name: $($g.Name)"
    }

    # ===== DISK =====
    Write-Host "`n[DISK]" -ForegroundColor Yellow
    Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
        $size = [math]::Round($_.Size / 1GB, 2)
        $free = [math]::Round($_.FreeSpace / 1GB, 2)
        Write-Host "$($_.DeviceID) - Total: $size GB | Free: $free GB"
    }

    # ===== NETWORK =====
    Write-Host "`n[NETWORK]" -ForegroundColor Yellow
    Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike "127.*"} | ForEach-Object {
        Write-Host "IP: $($_.IPAddress)"
    }

    Write-Host "`n========================================" -ForegroundColor Cyan
}

