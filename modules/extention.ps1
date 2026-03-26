# ===== EXTENSION TOOL MODULE =====

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

# ===== REMOVE ALL =====
function Remove-AllExtensions {
    Remove-ChromeExtensions
    Remove-EdgeExtensions
    Remove-FirefoxExtensions
}

