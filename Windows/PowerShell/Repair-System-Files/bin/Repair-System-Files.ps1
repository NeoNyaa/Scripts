SFC.exe /ScanNow
DISM.exe /Cleanup-Wim
DISM.exe /Cleanup-MountPoints
DISM.exe /Online /Cleanup-Image /RestoreHealth
