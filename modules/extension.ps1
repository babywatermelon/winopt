# ==============================
# EXTENSION MANAGER (CLEAN)
# ==============================

function Extension-Menu {

    while ($true) {

        Clear-Host
        Write-Host "==============================" -ForegroundColor Cyan
        Write-Host "      EXTENSION MANAGER       " -ForegroundColor Cyan
        Write-Host "==============================" -ForegroundColor Cyan

        Write-Host ""
        Write-Host "[1] Remove Edge Extension (By ID)"
        Write-Host "[2] Remove ALL Edge Extensions"
        Write-Host "[0] Back"
        Write-Host ""

        $choice = Read-Host "Select option"

        switch ($choice) {
            "1" {
                $id = Read-Host "Enter Extension ID"
                Remove-EdgeExtensionByID $id
            }
            "2" {
                Remove-AllEdgeExtensions
            }
            "0" { return }
            default { Write-Host "Invalid option!" -ForegroundColor Red }
        }

        Read-Host "Press Enter to continue"
    }
}

# ===== STOP EDGE =====
function Stop-Edge {
    taskkill /f /im msedge.exe 2>$null
}

# ===== REMOVE ALL EXT =====
function Remove-AllEdgeExtensions {

    $basePath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data"

    if (!(Test-Path $basePath)) {
        Write-Host "Edge not found!" -ForegroundColor Red
        return
    }

    Stop-Edge

    Get-ChildItem $basePath -Directory | ForEach-Object {

        $extPath = Join-Path $_.FullName "Extensions"

        if (Test-Path $extPath) {
            Remove-Item "$extPath\*" -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "Removed ALL extensions: $($_.Name)" -ForegroundColor Green
        }
    }
}

# ===== REMOVE EXT BY ID (FULL CLEAN) =====
function Remove-EdgeExtensionByID {

    param($extID)

    if (-not $extID) {
        Write-Host "Invalid Extension ID!" -ForegroundColor Red
        return
    }

    $basePath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data"

    if (!(Test-Path $basePath)) {
        Write-Host "Edge not found!" -ForegroundColor Red
        return
    }

    Stop-Edge

    Get-ChildItem $basePath -Directory | ForEach-Object {

        $profile = $_.FullName

        # 1. Extensions
        Remove-Item "$profile\Extensions\$extID" -Recurse -Force -ErrorAction SilentlyContinue

        # 2. Local settings
        Remove-Item "$profile\Local Extension Settings\$extID" -Recurse -Force -ErrorAction SilentlyContinue

        # 3. IndexedDB
        Get-ChildItem "$profile\IndexedDB" -ErrorAction SilentlyContinue | Where-Object {
            $_.Name -like "*$extID*"
        } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

        # 4. Service Worker
        Get-ChildItem "$profile\Service Worker" -Recurse -ErrorAction SilentlyContinue | Where-Object {
            $_.FullName -like "*$extID*"
        } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

        # 5. Preferences (safe)
        $pref = "$profile\Preferences"
        if (Test-Path $pref) {
            try {
                $c = Get-Content $pref -Raw
                $c = $c -replace $extID, ""
                Set-Content $pref $c -Encoding UTF8
            } catch {}
        }

        # 6. Secure Preferences
        $spref = "$profile\Secure Preferences"
        if (Test-Path $spref) {
            try {
                $c = Get-Content $spref -Raw
                $c = $c -replace $extID, ""
                Set-Content $spref $c -Encoding UTF8
            } catch {}
        }

        Write-Host "Removed: $extID ($($_.Name))" -ForegroundColor Green
    }
}
