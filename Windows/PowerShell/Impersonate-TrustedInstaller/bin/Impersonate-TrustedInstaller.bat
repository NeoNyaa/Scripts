start "Impersonate TrustedInstaller" PowerShell -Command "Start-Process -FilePath PowerShell -Verb RunAs -ArgumentList '-NoExit -Command Invoke-Expression (Invoke-RestMethod -UseBasicParsing -URI ','https://raw.githubusercontent.com/NeoNyaa/Scripts/main/Windows/PowerShell/Impersonate-TrustedInstaller/bin/Impersonate-TrustedInstaller.ps1',')'"