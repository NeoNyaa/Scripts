$ProgressPreference = 'SilentlyContinue'
Clear-Host
Write-Host

Write-Host "Killing Spotify"
TASKKILL /f /t /im Spotify.exe *> $null

Write-Host "Downloading Spotify installer"
Invoke-WebRequest -URI "https://download.scdn.co/SpotifySetup.exe" -OutFile "$env:TEMP/SpotifySetup.exe"

Write-Host "Installing Spotify"
$spotifySetup = Start-Process -FilePath "$env:TEMP/SpotifySetup.exe" -PassThru -NoNewWindow
$spotifySetup.WaitForExit()

Write-Host "Deleting Spotify installer"
Remove-Item -Path "$env:TEMP/SpotifySetup.exe" -Force
TASKKILL /f /t /im Spotify.exe *> $null

Write-Host "Killing Spotify"

if (!(Get-Command spicetify -ErrorAction SilentlyContinue)) {
    Write-Host "Downloading spicetify"
    (Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/spicetify/cli/main/install.ps1").Content.Replace('$choice = $Host.UI.PromptForChoice', '$choice = 1 # ') | Invoke-Expression *> $null
} else {
    Write-Host "Updating Spicetify"
    Start-Process -FilePath spicetify -ArgumentList "upgrade", "-n" -WindowStyle Hidden -Wait
}

Write-Host "Updating the Spicetify Marketplace"
Invoke-WebRequest -UseBasicParsing -URI "https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.ps1" | Invoke-Expression *> $null

Write-Host "Starting Spotify"
Start-Process -FilePath "$env:APPDATA/Spotify/Spotify.exe" -ArgumentList "--minimized"
