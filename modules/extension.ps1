# ==========================================
# WINOPT - EXTENSION MANAGER (STABLE)
# ==========================================

# ===== MENU =====
function Extension-Menu {

    while ($true) {

        Clear-Host
        Write-Host "==============================" -ForegroundColor Cyan
        Write-Host "      EXTENSION MANAGER       " -ForegroundColor Cyan
        Write-Host "==============================" -ForegroundColor Cyan

        Write-Host ""
        Write-Host "[1] Remove Edge Extension (FULL CLEAN)"
        Write-Host "[0] Back"
        Write-Host ""

        $choice = Read-Host "Select option"

        switch ($choice) {
            "1" {
                $id = Read-Host "Enter Extension ID"
                Remove-EdgeExtensionFull $id
            }
            "0" { return }
            default { Write-Host "Invalid option!" -ForegroundColor Red }
        }

        Write-Host ""
        Read-Host "Press Enter to continue"
    }
}

# ===== STOP EDGE =====
function Stop-Edge {
    taskkill /f /im msedge.exe 2>$null
}

# ===== FULL CLEAN FUNCTION =====
function Remove-EdgeExtensionFull {

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

        # ===== 1. Extension files =====
        Remove-Item "$profile\Extensions\$extID" -Recurse -Force -ErrorAction SilentlyContinue

        # ===== 2. Local Extension Settings =====
        Remove-Item "$profile\Local Extension Settings\$extID" -Recurse -Force -ErrorAction SilentlyContinue

        # ===== 3. IndexedDB =====
        if (Test-Path "$profile\IndexedDB") {
            Get-ChildItem "$profile\IndexedDB" -ErrorAction SilentlyContinue | Where-Object {
                $_.Name -like "*$extID*"
            } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        }

        # ===== 4. Service Worker =====
        if (Test-Path "$profile\Service Worker") {
            Get-ChildItem "$profile\Service Worker" -Recurse -ErrorAction SilentlyContinue | Where-Object {
                $_.FullName -like "*$extID*"
            } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        }

        # ===== 5. Preferences =====
        $pref = "$profile\Preferences"
        if (Test-Path $pref) {
            try {
                $content = Get-Content $pref -Raw
                $content = $content -replace $extID, ""
                Set-Content $pref -Value $content -Encoding UTF8
            } catch {}
        }

        # ===== 6. Secure Preferences =====
        $spref = "$profile\Secure Preferences"
        if (Test-Path $spref) {
            try {
                $content = Get-Content $spref -Raw
                $content = $content -replace $extID, ""
                Set-Content $spref -Value $content -Encoding UTF8
            } catch {}
        }

        Write-Host "Removed FULL: $extID ($($_.Name))" -ForegroundColor Green
    }

    Write-Host ""
    Write-Host "Done. Restarting Edge..." -ForegroundColor Cyan

    Start-Sleep 1
    Start-Process "msedge.exe"
}
