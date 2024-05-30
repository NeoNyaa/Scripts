$ProgressPreference = 'SilentlyContinue'
$Host.UI.RawUI.WindowTitle = 'Spicetify Installer - V1.0.3'
Clear-Host
Write-Host

Write-Host "Killing Spotify`n"
TASKKILL /f /t /im Spotify.exe *> $null

Write-Host "Checking for and uninstalling the Microsoft Store variant of Spotify`n"
ForEach ($Package in Get-AppxPackage *spotify*) {
    Remove-AppxPackage $Package
}

Write-Host "Downloading the Spotify installer`n"
Invoke-WebRequest -URI "https://download.scdn.co/SpotifySetup.exe" -OutFile "$env:TEMP/SpotifySetup.exe"

Write-Host "Installing Spotify`n"
$spotifySetup = Start-Process -FilePath "$env:TEMP/SpotifySetup.exe" -PassThru -NoNewWindow
$spotifySetup.WaitForExit()

Write-Host "Deleting the Spotify installer`n"
Remove-Item -Path "$env:TEMP/SpotifySetup.exe" -Force

Write-Host "Killing Spotify in 5 seconds`n"
Start-Sleep -Seconds 5
TASKKILL /f /t /im Spotify.exe *> $null

if (!(Get-Command spicetify -ErrorAction SilentlyContinue)) {
    Write-Host "Downloading spicetify`b"
    (Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/spicetify/cli/main/install.ps1").Content.Replace('$choice = $Host.UI.PromptForChoice', '$choice = 1 # ') | Invoke-Expression *> $null
} else {
    Write-Host "Updating Spicetify`n"
    Start-Process -FilePath spicetify -ArgumentList "upgrade", "-n" -WindowStyle Hidden -Wait
}

Write-Host "Updating the Spicetify Marketplace`n"
Invoke-WebRequest -UseBasicParsing -URI "https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.ps1" | Invoke-Expression *> $null

Write-Host "Starting Spotify`n"
Start-Process -FilePath "$env:APPDATA/Spotify/Spotify.exe" -ArgumentList "--minimized"
