function Extension-Menu {

    while ($true) {

        Clear-Host
        Write-Host "==============================" -ForegroundColor Cyan
        Write-Host "      EXTENSION MANAGER       " -ForegroundColor Cyan
        Write-Host "==============================" -ForegroundColor Cyan

        Write-Host ""
        Write-Host "[1] Remove Chrome Extensions"
        Write-Host "[2] Remove Edge Extensions"
        Write-Host "[3] Remove Firefox Extensions"
        Write-Host "[4] Remove ALL Extensions"
        Write-Host "[5] Remove Edge Extension (By ID) 🔥"
        Write-Host "[0] Back"
        Write-Host ""

        $choice = Read-Host "Select option"

        switch ($choice) {
            "1" { Remove-ChromeExtensions }
            "2" { Remove-EdgeExtensions }
            "3" { Remove-FirefoxExtensions }
            "4" { Remove-AllExtensions }
            "5" { 
                $id = Read-Host "Enter Extension ID"
                Remove-EdgeExtensionByID $id
            }
            "0" { return }
            default { Write-Host "Invalid option!" -ForegroundColor Red }
        }

        Write-Host ""
        Read-Host "Press Enter to continue"
    }
}
function Stop-Browsers {
    taskkill /f /im chrome.exe 2>$null
    taskkill /f /im msedge.exe 2>$null
    taskkill /f /im firefox.exe 2>$null
}

# ===== REMOVE CHROME EXT =====
function Remove-ChromeExtensions {

    $basePath = "$env:LOCALAPPDATA\Google\Chrome\User Data"

    if (-not (Test-Path $basePath)) {
        Write-Host "Chrome not found!" -ForegroundColor Red
        return
    }

    Stop-Browsers

    Get-ChildItem $basePath -Directory | ForEach-Object {
        $extPath = Join-Path $_.FullName "Extensions"

        if (Test-Path $extPath) {
            Remove-Item "$extPath\*" -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "Chrome extensions removed: $($_.Name)" -ForegroundColor Green
        }
    }
}

# ===== REMOVE EDGE EXT =====
function Remove-EdgeExtensions {

    $basePath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data"

    if (-not (Test-Path $basePath)) {
        Write-Host "Edge not found!" -ForegroundColor Red
        return
    }

    Stop-Browsers

    Get-ChildItem $basePath -Directory | ForEach-Object {
        $extPath = Join-Path $_.FullName "Extensions"

        if (Test-Path $extPath) {
            Remove-Item "$extPath\*" -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "Edge extensions removed: $($_.Name)" -ForegroundColor Green
        }
    }
}

# ===== REMOVE FIREFOX EXT =====
function Remove-FirefoxExtensions {

    $profiles = "$env:APPDATA\Mozilla\Firefox\Profiles"

    if (-not (Test-Path $profiles)) {
        Write-Host "Firefox not found!" -ForegroundColor Red
        return
    }

    Stop-Browsers

    Get-ChildItem $profiles -Directory | ForEach-Object {
        $extPath = Join-Path $_.FullName "extensions"

        if (Test-Path $extPath) {
            Remove-Item "$extPath\*" -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "Firefox extensions removed: $($_.Name)" -ForegroundColor Green
        }
    }
}

# ===== REMOVE ALL EXTENSIONS =====
function Remove-AllExtensions {
    Remove-ChromeExtensions
    Remove-EdgeExtensions
    Remove-FirefoxExtensions
}

# ===== REMOVE EDGE EXTENSION BY ID (DEEP CLEAN) =====
function Remove-EdgeExtensionByID {

    param($extID)

    if (-not $extID) {
        Write-Host "Invalid Extension ID!" -ForegroundColor Red
        return
    }

    $basePath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data"

    if (-not (Test-Path $basePath)) {
        Write-Host "Edge not found!" -ForegroundColor Red
        return
    }

    Stop-Browsers

    Get-ChildItem $basePath -Directory | ForEach-Object {

        $profile = $_.FullName

        # 1. Extensions
        $extPath = Join-Path $profile "Extensions\$extID"
        if (Test-Path $extPath) {
            Remove-Item $extPath -Recurse -Force -ErrorAction SilentlyContinue
        }

        # 2. Local Extension Settings
        $localExt = Join-Path $profile "Local Extension Settings\$extID"
        if (Test-Path $localExt) {
            Remove-Item $localExt -Recurse -Force -ErrorAction SilentlyContinue
        }

        # 3. IndexedDB
        $indexed = Join-Path $profile "IndexedDB"
        if (Test-Path $indexed) {
            Get-ChildItem $indexed -Directory | Where-Object {
                $_.Name -like "*$extID*"
            } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        }

        # 4. Service Worker cache
        $sw = Join-Path $profile "Service Worker"
        if (Test-Path $sw) {
            Get-ChildItem $sw -Recurse -ErrorAction SilentlyContinue | Where-Object {
                $_.FullName -like "*$extID*"
            } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        }

        Write-Host "Removed Extension + Cache: $extID ($($_.Name))" -ForegroundColor Green
    }
}

# ===== EXTENSION MENU =====

