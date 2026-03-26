function Run-EdgeExtensionCleaner {

    Clear-Host
    Write-Host "==== EDGE EXTENSION CLEANER ====" -ForegroundColor Cyan

    taskkill /f /im msedge.exe 2>$null

    $path = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Extensions"

    if (!(Test-Path $path)) {
        Write-Host "No extensions found!" -ForegroundColor Red
        return
    }

    $list = Get-ChildItem $path -Directory

    if ($list.Count -eq 0) {
        Write-Host "No extensions installed!" -ForegroundColor Yellow
        return
    }

    $map = @{}
    $i = 1

    Write-Host ""
    foreach ($ext in $list) {
        Write-Host "[$i] $($ext.Name)"
        $map[$i] = $ext.Name
        $i++
    }

    Write-Host ""
    $choice = Read-Host "Select extension to remove"

    if (-not ($choice -as [int]) -or -not $map.ContainsKey([int]$choice)) {
        Write-Host "Invalid!" -ForegroundColor Red
        return
    }

    $extID = $map[[int]$choice]

    Write-Host "Removing $extID..." -ForegroundColor Yellow

    $basePath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data"

    Get-ChildItem $basePath -Directory | ForEach-Object {

        $profile = $_.FullName

        Remove-Item "$profile\Extensions\$extID" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "$profile\Local Extension Settings\$extID" -Recurse -Force -ErrorAction SilentlyContinue

        Get-ChildItem "$profile" -Recurse -ErrorAction SilentlyContinue | Where-Object {
            $_.FullName -like "*$extID*"
        } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    }

    Write-Host "DONE!" -ForegroundColor Green
    Start-Process msedge.exe
}
