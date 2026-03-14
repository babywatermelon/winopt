function Repair-SFC {

sfc /scannow

}

function Repair-DISM {

DISM /Online /Cleanup-Image /RestoreHealth

}
