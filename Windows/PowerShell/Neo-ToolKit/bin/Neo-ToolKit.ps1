$tools = [ordered]@{
    "Quit" = "exit 0"
    "Ultimate Windows Utility" = "iwr -useb 'https://christitus.com/win' | iex"
    "Windows 11 Debloat" = "iwr -useb 'https://raw.githubusercontent.com/Raphire/Win11Debloat/master/Get.ps1' | iex"
    "Microsoft Activation Scripts" = "irm 'https://get.activated.win' | iex"
}

while ($true) {
    Clear-Host
    Write-Host
    $i = 0
    ForEach ($tool in $tools.Keys) {
        Write-Host "$i) $tool"
        $i++
    }

    Write-Host
    [Int] $userSelection = Read-Host -Prompt "Select the tool you want to run"

    if ($userSelection -eq 0) {
        Invoke-Expression -Command $tools.values[$userSelection]
    } else {
        $toolToRun = $tools.values[$userSelection]
    }
    
    Start-Process -FilePath (Get-Process -Pid $PID -FileVersionInfo).FileName -Verb RunAs -ArgumentList "-Command $toolToRun"
}