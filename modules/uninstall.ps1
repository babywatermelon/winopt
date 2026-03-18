function Uninstall-App($name, $id) {
    Title "Uninstalling $name"

    # Ask user before uninstall
    $confirm = Read-Host "Do you want to uninstall $name? (Y/N)"
    if ($confirm -ne "Y") {
        Info "Uninstallation of $name was cancelled"
        return
    }

    Step "Starting uninstall..."
    Info "Please wait..."

    try {
        winget uninstall --id $id --exact `
            --accept-source-agreements `
            --silent

        if ($LASTEXITCODE -eq 0) {
            Done "$name removed successfully"
        }
        else {
            throw "Exit code $LASTEXITCODE"
        }
    }
    catch {
        Fail "$name uninstall failed"
    }

    Write-Host ""
}

function Uninstall-Chrome {
    Uninstall-App "Google Chrome" "Google.Chrome"
}

function Uninstall-Edge {
    Uninstall-App "Microsoft Edge" "Microsoft.Edge"
}

function Uninstall-Firefox {
    Uninstall-App "Mozilla Firefox" "Mozilla.Firefox"
}

function Uninstall-CPUZ {
    Uninstall-App "CPU-Z" "CPUID.CPU-Z"
}

function Uninstall-GPUZ {
    Uninstall-App "GPU-Z" "TechPowerUp.GPU-Z"
}

function Uninstall-CrystalDiskInfo {
    Uninstall-App "CrystalDiskInfo" "CrystalDewWorld.CrystalDiskInfo"
}

function Uninstall-HWMonitor {
    Uninstall-App "HWMonitor" "CPUID.HWMonitor"
}

function Uninstall-Office {
    Uninstall-App "Microsoft Office" "Microsoft.Office"
}
