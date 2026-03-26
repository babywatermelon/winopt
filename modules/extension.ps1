# ==========================================
# EDGE EXTENSION CLEANER (FULL CLEAN)
# ==========================================

function Remove-EdgeExtension {

    Clear-Host
    Write-Host "===== EDGE EXTENSION CLEANER =====" -ForegroundColor Cyan

    # Stop Edge
    taskkill /f /im msedge.exe 2>$null

    $extPath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Extensions"

    if (!(Test-Path $extPath)) {
        Write-Host "Extensions folder not found!" -ForegroundColor Red
        return
    }

    $extensions = Get-ChildItem $extPath -Directory

    if ($extensions.Count -eq 0) {
        Write-Host "No extensions installed!" -ForegroundColor Yellow
        return
    }

    # ===== LIST EXTENSIONS =====
    $map = @{}
    $i = 1

    Write-Host ""
    Write-Host "Installed Extensions:" -ForegroundColor Green
    Write-Host "----------------------"

    foreach ($ext in $extensions) {
        Write-Host "[$i] $($ext.Name)"
        $map[$i] = $ext.Name
        $i++
    }

    # ===== SELECT =====
    Write-Host ""
    $choice = Read-Host "Select extension number to REMOVE"

    if (-not ($choice -as [int]) -or -not $map.ContainsKey([int]$choice)) {
        Write-Host "Invalid selection!" -ForegroundColor Red
        return
    }

    $extID = $map[[int]$choice]

    Write-Host ""
    Write-Host "Removing extension: $extID ..." -ForegroundColor Yellow

    $basePath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data"

    # ===== CLEAN ALL PROFILES =====
    Get-ChildItem $basePath -Directory | ForEach-Object {

        $profile = $_.FullName

        # 1. Extension files
        Remove-Item "$profile\Extensions\$extID" -Recurse -Force -ErrorAction SilentlyContinue

        # 2. Local settings
        Remove-Item "$profile\Local Extension Settings\$extID" -Recurse -Force -ErrorAction SilentlyContinue

        # 3. IndexedDB
        if (Test-Path "$profile\IndexedDB") {
            Get-ChildItem "$profile\IndexedDB" -ErrorAction SilentlyContinue | Where-Object {
                $_.Name -like "*$extID*"
            } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        }

        # 4. Service Worker
        if (Test-Path "$profile\Service Worker") {
            Get-ChildItem "$profile\Service Worker" -Recurse -ErrorAction SilentlyContinue | Where-Object {
                $_.FullName -like "*$extID*"
            } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        }

        # 5. Preferences
        $pref = "$profile\Preferences"
        if (Test-Path $pref) {
            try {
                (Get-Content $pref -Raw) -replace $extID, "" | Set-Content $pref -Encoding UTF8
            } catch {}
        }

        # 6. Secure Preferences
        $spref = "$profile\Secure Preferences"
        if (Test-Path $spref) {
            try {
                (Get-Content $spref -Raw) -replace $extID, "" | Set-Content $spref -Encoding UTF8
            } catch {}
        }

        Write-Host "Cleaned profile: $($_.Name)" -ForegroundColor Green
    }

    Write-Host ""
    Write-Host "DONE - Extension removed completely!" -ForegroundColor Cyan

    # Restart Edge
    Start-Sleep 1
    Start-Process msedge.exe
}

# ===== RUN =====
Remove-EdgeExtension
