Clear-Host
Write-Host "Loading WinOpt Tool..." -ForegroundColor Cyan

$base = "$env:TEMP\winopt"
$modules = "$base\modules"

# Xóa thư mục cũ để tránh lỗi cũ
if (Test-Path $base) {
    Remove-Item -Path $base -Recurse -Force -ErrorAction SilentlyContinue
}

New-Item -ItemType Directory -Path $modules -Force | Out-Null
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

Write-Host "Downloading modules from GitHub..." -ForegroundColor DarkGray

$moduleList = @("clean", "network", "repair", "tools", "install", "uninstall", "security", "gaming")

foreach ($m in $moduleList) {
    $url = "https://raw.githubusercontent.com/babywatermelon/winopt/main/modules/$m.ps1"
    $out = "$modules\$m.ps1"
    try {
        Invoke-WebRequest $url -OutFile $out -UseBasicParsing
        Write-Host "✅ Downloaded: $m.ps1" -ForegroundColor Green
    } catch {
        Write-Host "❌ Error downloading $m.ps1" -ForegroundColor Red
    }
}

# Tạo windowsupdate.ps1 (đầy đủ)
Write-Host "Creating windowsupdate.ps1 (Full & Fixed)..." -ForegroundColor Magenta
$wuContent = @'
# Windows Update Control functions (Get-WindowsUpdateStatus, Disable-WindowsUpdate, Enable-WindowsUpdate)
# (Dán nguyên code function Get-WindowsUpdateStatus, Disable-WindowsUpdate, Enable-WindowsUpdate của bạn vào đây)
'@  # ← Thay bằng code đầy đủ của 3 function này

$wuContent | Out-File -FilePath "$modules\windowsupdate.ps1" -Encoding UTF8

# ================== TẠO MENU.PS1 ĐẦY ĐỦ ==================
Write-Host "Creating menu.ps1 ..." -ForegroundColor Magenta

$menuContent = @'
$host.UI.RawUI.WindowTitle = "WinOpt - Windows Optimization Tool"

# ===== TỰ ĐỘNG CĂN CHỈNH KÍCH THƯỚC CỬA SỔ =====
try {
    $rawUI = $Host.UI.RawUI
    $buffer = $rawUI.BufferSize
    $buffer.Width = 200
    $buffer.Height = 5000
    $rawUI.BufferSize = $buffer
    $desiredWidth = 120
    $desiredHeight = 52
    $maxSize = $rawUI.MaxPhysicalWindowSize
    if ($desiredWidth -gt $maxSize.Width) { $desiredWidth = $maxSize.Width }
    if ($desiredHeight -gt $maxSize.Height) { $desiredHeight = $maxSize.Height - 3 }
    $windowSize = New-Object System.Management.Automation.Host.Size($desiredWidth, $desiredHeight)
    $rawUI.WindowSize = $windowSize
}
catch { }

# ===== LOAD ALL MODULES =====
$modulePath = "$env:TEMP\winopt\modules"
Write-Host "`n=== ĐANG LOAD MODULES ===" -ForegroundColor Cyan

Get-ChildItem "$modulePath\*.ps1" -ErrorAction SilentlyContinue | ForEach-Object {
    try {
        . $_.FullName
        $color = if ($_.Name -like "*update*") { "Magenta" } else { "Green" }
        Write-Host "✅ Loaded: $($_.Name)" -ForegroundColor $color
    }
    catch {
        Write-Host "❌ Lỗi load $($_.Name): $($_.Exception.Message)" -ForegroundColor Red
    }
}
Write-Host "=== HOÀN TẤT LOAD MODULES ===`n" -ForegroundColor Cyan

# ===== UI FUNCTIONS (Header, Draw-Line, Draw-Section, Pause) =====
function Pause {
    Write-Host ""
    Read-Host "Press Enter to continue"
}

function Header {
    Clear-Host
    $width = $Host.UI.RawUI.WindowSize.Width
    $title = " WINOPT TOOL "
    $padding = [math]::Max(0, [math]::Floor(($width - $title.Length) / 2))
    $line = "=" * $width
    Write-Host $line -ForegroundColor DarkGray
    Write-Host (" " * $padding + $title) -ForegroundColor Cyan
    Write-Host $line -ForegroundColor DarkGray
    Write-Host ""
}

function Draw-Line {
    param($left, $right, $menuWidth, $leftPadding)
    $innerWidth = $menuWidth - 4
    $half = [math]::Max(1, [math]::Floor($innerWidth / 2))
    $leftText = ($left | Out-String).Trim()
    $rightText = ($right | Out-String).Trim()
    $leftPadded = $leftText.PadRight($half)
    if ($leftPadded.Length -gt $half) { $leftPadded = $leftPadded.Substring(0, $half) }
    $rightPadded = $rightText.PadRight($half)
    if ($rightPadded.Length -gt $half) { $rightPadded = $rightPadded.Substring(0, $half) }

    Write-Host (" " * [math]::Max(0, $leftPadding) + "| ") -NoNewline -ForegroundColor DarkGray
    Write-Host $leftPadded -NoNewline -ForegroundColor White
    Write-Host $rightPadded -NoNewline -ForegroundColor White
    Write-Host " |" -ForegroundColor DarkGray
}

function Draw-Section {
    param($left, $right, $menuWidth, $leftPadding)
    $innerWidth = $menuWidth - 4
    $half = [math]::Max(1, [math]::Floor($innerWidth / 2))
    $leftText = ($left | Out-String).Trim()
    $rightText = ($right | Out-String).Trim()
    $leftPadded = $leftText.PadRight($half)
    if ($leftPadded.Length -gt $half) { $leftPadded = $leftPadded.Substring(0, $half) }
    $rightPadded = $rightText.PadRight($half)
    if ($rightPadded.Length -gt $half) { $rightPadded = $rightPadded.Substring(0, $half) }

    Write-Host (" " * [math]::Max(0, $leftPadding) + "| ") -NoNewline -ForegroundColor DarkGray
    Write-Host $leftPadded -NoNewline -ForegroundColor Yellow
    Write-Host $rightPadded -NoNewline -ForegroundColor Yellow
    Write-Host " |" -ForegroundColor DarkGray
}

# ===== SHOW-MENU FUNCTION (quan trọng nhất) =====
function Show-Menu {
    Header
    $width = $Host.UI.RawUI.WindowSize.Width
    $menuWidth = 120
    $leftPadding = [math]::Max(0, [math]::Floor(($width - $menuWidth) / 2))
  
    Write-Host (" " * $leftPadding + "+" + ("-" * ($menuWidth - 2)) + "+") -ForegroundColor DarkGray
  
    Draw-Section "System Cleanup" "Repair Tools" $menuWidth $leftPadding
    Draw-Line "[1] Clean Temp" "[11] Repair Windows (SFC)" $menuWidth $leftPadding
    # ... (dán tiếp toàn bộ các Draw-Line còn lại của bạn vào đây)

    Draw-Line "[99] README / Help" "" $menuWidth $leftPadding
    Draw-Line "[0] Exit" "" $menuWidth $leftPadding
    Write-Host (" " * $leftPadding + "+" + ("-" * ($menuWidth - 2)) + "+") -ForegroundColor DarkGray
    Write-Host ""
}

# ===== MAIN LOOP =====
while ($true) {
    Show-Menu
    Write-Host "Select option: " -NoNewline -ForegroundColor Cyan
    $choice = Read-Host

    try {
        switch ($choice) {
            "1" { Clean-Temp }
            # ... dán tất cả các case khác của bạn vào đây (từ code đầu tiên)

            "41" { Disable-WindowsUpdate }
            "42" { Enable-WindowsUpdate }
            "43" { Clear-Host; Get-WindowsUpdateStatus; Pause }
            "99" { Show-Readme }
            "0" {
                $confirm = Read-Host "Are you sure you want to exit? (Y/N)"
                if ($confirm -match "^y") { exit }
            }
            default { Write-Host "Invalid option!" -ForegroundColor Red }
        }
    }
    catch {
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    }
    Pause
}
'@

$menuContent | Out-File -FilePath "$base\menu.ps1" -Encoding UTF8 -Force

Write-Host "✅ menu.ps1 đã được tạo đầy đủ" -ForegroundColor Green
Write-Host "Starting WinOpt Tool..." -ForegroundColor Cyan

# Chạy menu
powershell -ExecutionPolicy Bypass -File "$base\menu.ps1"
