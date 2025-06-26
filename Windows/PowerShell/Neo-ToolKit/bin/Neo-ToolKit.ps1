# Make errors silent, if something doesnt work, assume it's the users fault.
$ErrorActionPreference = 'SilentlyContinue'

# Get and set the path of the PowerShell executable currently being used to a variable
$PowerShellExePath = (Get-Process -Pid $PID -FileVersionInfo).FileName

# A curated list of PowerShell scripts that I find useful in a hashtable format for easy additions/removals
$tools = [ordered]@{
    "Quit" = ""
    "Ultimate Windows Utility" = "iwr -useb 'https://christitus.com/win' | iex"
    "Repair System Files" = "iwr -useb 'https://raw.githubusercontent.com/NeoNyaa/Scripts/main/Windows/PowerShell/Repair-System-Files/bin/Repair-System-Files.ps1' | iex"
    "Microsoft Activation Scripts" = "irm 'https://get.activated.win' | iex"
    "Windows 11 Debloat" = "iwr -useb 'https://raw.githubusercontent.com/Raphire/Win11Debloat/master/Get.ps1' | iex"
    "Force Enable Optifine Mod Extraction" = "iwr -useb 'https://raw.githubusercontent.com/NeoNyaa/Scripts/main/Windows/PowerShell/Force-Enable-Optifine-Mod-Extraction/bin/Force-Enable-Optifine-Mod-Extraction.ps1' | iex"
}

# Create a menu which will only stop running once the user requests it to do so.
while ($true) {
    Clear-Host
    Write-Host
    $i = 0
    # Generate the list of tools
    ForEach ($tool in $tools.Keys) {
        Write-Host "$i) $tool"
        $i++
    }

    # Ask user what tool they want to run
    Write-Host
    [Int] $userSelection = Read-Host -Prompt "Select the tool you want to run"

    # Check if the user supplied a 0 and exit if so.
    if ($userSelection -eq 0) {
        exit 0
    } else {
        # PowerShell doesnt let you access a hashtable value with an offset like you can do with
        # an array whereas PWSH (PowerShell Core 7) does, this is to work around that issue :/
        # The below line is how simple this would be for PWSH instead of PowerShell.
        #
        # $tool = $tools.Values[$userSelection]
        #
        # I was incredibly tired when I wrote this and there is probably a simple solution
        # which is MUCH more clean but this works and I don't feel the need to change it.
        $i = 0
        ForEach ($tool in $tools.Values) {
            if ($userSelection -eq $i) {
                $toolToRun = $tool
            }
            $i++
        }
    }

    # Finally run the script the user chose as admin to ensure the script can run.
    if ($toolToRun -match 'NoExit') {
        Start-Process -FilePath $PowerShellExePath -Verb RunAs -ArgumentList "-NoExit -Command $toolToRun"
    } else {
        Start-Process -FilePath $PowerShellExePath -Verb RunAs -ArgumentList "-Command $toolToRun"
    }
}
