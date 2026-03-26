# ==========================================
# EDGE EXTENSION CLEANER (FIXED REAL CLEAN)
# ==========================================

function Remove-EdgeExtension {

    Clear-Host
    Write-Host "===== EDGE EXTENSION CLEANER =====" -ForegroundColor Cyan

    # Kill Edge mạnh hơn
    Get-Process msedge -ErrorAction SilentlyContinue | Stop-Process -Force

    Start-Sleep 1

    $basePath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data"
    $extPath = "$basePath\Default\Extensions"

    if (!(Test-Path $extPath)) {
        Write-Host "Extensions folder not found!" -ForegroundColor Red
        return
    }

    $extensions = Get-ChildItem $extPath -Directory

    if ($extensions.Count -eq 0) {
        Write-Host "No extensions installed!" -ForegroundColor Yellow
        return
    }

    # ===== LIST =====
    $map = @{}
    $i = 1

    Write-Host ""
    foreach ($ext in $extensions) {
        Write-Host "[$i] $($ext.Name)"
        $map[$i] = $ext.Name
        $i++
    }

    # ===== SELECT =====
    Write-Host ""
    $choice = Read-Host "Select extension number"

    if (-not ($choice -as [int]) -or -not $map.ContainsKey([int]$choice)) {
        Write-Host "Invalid!" -ForegroundColor Red
        return
    }

    $extID = $map[[int]$choice]

    Write-Host "Removing $extID ..." -ForegroundColor Yellow

    # ===== CLEAN ALL PROFILE =====
    Get-ChildItem $basePath -Directory | ForEach-Object {

        $profile = $_.FullName

        # 1. Remove extension folder
        Remove-Item "$profile\Extensions\$extID" -Recurse -Force -ErrorAction SilentlyContinue

        # 2. Remove local settings
        Remove-Item "$profile\Local Extension Settings\$extID" -Recurse -Force -ErrorAction SilentlyContinue

        # 3. Remove IndexedDB
        Remove-Item "$profile\IndexedDB\*$extID*" -Recurse -Force -ErrorAction SilentlyContinue

        # 4. Remove Service Worker
        Remove-Item "$profile\Service Worker\*\*$extID*" -Recurse -Force -ErrorAction SilentlyContinue

        # ===== FIX QUAN TRỌNG: JSON CLEAN =====

        $prefFile = "$profile\Preferences"

        if (Test-Path $prefFile) {
            try {
                $json = Get-Content $prefFile -Raw | ConvertFrom-Json

                if ($json.extensions.settings.$extID) {
                    $json.extensions.settings.PSObject.Properties.Remove($extID)
                }

                $json | ConvertTo-Json -Depth 100 | Set-Content $prefFile -Encoding UTF8

                Write-Host "Fixed Preferences: $($_.Name)" -ForegroundColor Green
            }
            catch {
                Write-Host "Failed JSON fix: $($_.Name)" -ForegroundColor Yellow
            }
        }

        # Secure Preferences (optional)
        $spref = "$profile\Secure Preferences"
        if (Test-Path $spref) {
            try {
                $json = Get-Content $spref -Raw | ConvertFrom-Json

                if ($json.extensions.settings.$extID) {
                    $json.extensions.settings.PSObject.Properties.Remove($extID)
                }

                $json | ConvertTo-Json -Depth 100 | Set-Content $spref -Encoding UTF8
            }
            catch {}
        }

    }

    Write-Host ""
    Write-Host "DONE! Extension removed fully." -ForegroundColor Cyan

    Start-Sleep 1
    Start-Process msedge.exe
}

Remove-EdgeExtension
