function Restart-Explorer {

taskkill /f /im explorer.exe
Start-Process explorer.exe

Write-Host "Explorer restarted" -ForegroundColor Green

}

function Clear-Recycle {

Clear-RecycleBin -Force -ErrorAction SilentlyContinue

Write-Host "Recycle bin cleared" -ForegroundColor Green

}

function Open-TaskManager {

Start-Process taskmgr

}

function Open-ControlPanel {

Start-Process control

}

function Open-DeviceManager {

Start-Process devmgmt.msc

}
