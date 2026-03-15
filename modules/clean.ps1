function Clean-Temp {

Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Temp cleaned" -ForegroundColor Green

}

function Clean-Prefetch {

Remove-Item "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Prefetch cleaned" -ForegroundColor Green

}

function Clean-WindowsUpdate {

Write-Host "Cleaning Windows Update Cache..." -ForegroundColor Yellow

net stop wuauserv
Remove-Item "C:\Windows\SoftwareDistribution\*" -Recurse -Force -ErrorAction SilentlyContinue
net start wuauserv

Write-Host "Completed" -ForegroundColor Green

}

function Clear-RAM {

    Write-Host "Clearing RAM Standby Cache..." -ForegroundColor Cyan

    $tool = "$PSScriptRoot\tools\EmptyStandbyList.exe"

    if (Test-Path $tool) {
        & $tool standbylist
        Write-Host "RAM cache cleared!" -ForegroundColor Green
    }
    else {
        Write-Host "EmptyStandbyList not found!" -ForegroundColor Red
    }
}
