# Clean up the terminal and check if PowerShell was ran with administrator permissions.
Clear-Host

if ([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544") -eq $False) {
    Read-Host -Prompt "`nERROR! PowerShell was not ran with administrator Permissions"
    exit 1
}

# Install and Import a PowerShell module which makes this possible.
Write-Host "`nInstalling the NtObjectManager PowerShell module."
Install-Module -Name NtObjectManager -Force -Scope CurrentUser -WarningAction 'SilentlyContinue'
Import-Module NtObjectManager

# Impersonate TrustedInstaller
Write-Host "Attempting to impersonate TrustedInstaller"
Start-Service TrustedInstaller
try {
    $null = (Get-NtThread -Current -PseudoHandle).ImpersonateThread((Get-NtProcess -Name TrustedInstaller.exe).GetFirstThread())
    Write-Host "Success!`n"
}
catch {
    Read-Host -Prompt "Failed! Make sure that only one instance of an impersonated terminal session is active at any one time."
}
