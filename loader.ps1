Clear-Host
Write-Host "Loading WinOpt Tool..."

$temp="$env:TEMP\winopt"

if(!(Test-Path $temp)){
New-Item -ItemType Directory -Path $temp | Out-Null
}

Invoke-WebRequest https://raw.githubusercontent.com/USERNAME/winopt/main/menu.ps1 -OutFile "$temp\menu.ps1"

powershell "$temp\menu.ps1"
