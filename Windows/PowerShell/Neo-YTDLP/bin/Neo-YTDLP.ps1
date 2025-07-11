# UX tweaks
$global:ProgressPreference = 'SilentlyContinue'

$scriptVersion = "v1.0.5"
$binaryPath = "$env:LOCALAPPDATA\Programs\Neo-YTDLP"
$initialDirectory = Get-Location
$defaultArguments = "--embed-chapters --windows-filenames -w --quiet --progress -o `"%(title)s.%(ext)s`" -P `"$env:userprofile\Downloads\Neo-YTDLP`" -a `"$binaryPath\Links.txt`" --ffmpeg-location `"$binaryPath`""

function Write-FancyInfo($msg) {
  Write-Host -ForegroundColor Blue -NoNewline "[Info] "; Write-Host "$msg"
}

function Install-YTDLP {
  Clear-Host
  $Host.UI.RawUI.WindowTitle = "Neo-YTDLP Installer - $scriptVersion"

  # Give user warning and alow them to exit
  Write-Host "`nIn order for this script to function some files need to be downloaded.`nNothing has been downloaded yet and you can safely exit this script if you dont wish to continue."
  Read-Host -Prompt "Otherwise, press [ENTER] to continue"
  Clear-Host

  # Make the files and folders needed
  $null = New-Item -Path $binaryPath -ItemType 'Directory' -ErrorAction 'SilentlyContinue'
  Set-Location $binaryPath
  $null = New-Item -Path Links.txt -ItemType File -ErrorAction 'SilentlyContinue'
  Set-Content -Path Links.txt -Value "# Replace the contents of this file with the urls of the videos`n# you want to download; each of which being on a seperate line."

  # Download yt-dlp.exe
  Write-FancyInfo "Downloading yt-dlp.exe"
  Invoke-RestMethod -UseBasicParsing -URI "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe" -OutFile "yt-dlp.exe"

  # Download and extract FFmpeg
  Write-FancyInfo "Downloading FFmpeg"
  Invoke-RestMethod -UseBasicParsing -URI "https://github.com/yt-dlp/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip" -OutFile "ffmpeg-master-latest-win64-gpl.zip"
  Write-Host " - Extracting FFmpeg"
  Expand-Archive -Path "ffmpeg-master-latest-win64-gpl.zip" -DestinationPath .
  Write-Host " - Moving and cleaning up residual files"
  Get-ChildItem -Path "ffmpeg-master-latest-win64-gpl\bin\*.exe" -Exclude ffplay.exe | Move-Item -Destination .
  Remove-Item -Path "ffmpeg-master-latest-win64-gpl*" -Force -Recurse

  # Download and extract AtomicParsley
  Write-FancyInfo "Downloading AtomicParsely"
  Invoke-RestMethod -UseBasicParsing -URI "https://github.com/wez/atomicparsley/releases/latest/download/AtomicParsleyWindows.zip" -OutFile "AtomicParsleyWindows.zip"
  Write-Host " - Extracting AtomicParsley"
  Expand-Archive -Path "AtomicParsleyWindows.zip" -DestinationPath .
  Write-Host " - Cleaning up residual files"
  Remove-Item -Path "AtomicParsleyWindows*" -Force -Recurse

  # Download and extract PhantomJS
  Write-FancyInfo "Downloading PhantomJS"
  Invoke-RestMethod -UseBasicParsing -URI "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-windows.zip" -OutFile "phantomjs-2.1.1-windows.zip"
  Write-Host " - Extracting PhantomJS"
  Expand-Archive -Path "phantomjs-2.1.1-windows.zip" -DestinationPath .
  Write-Host " - Moving and cleaning up residual files"
  Move-Item -Path "phantomjs-2.1.1-windows\bin\phantomjs.exe" -Destination .
  Remove-Item -Path "phantomjs-2.1.1-windows*" -Force -Recurse
}

function Uninstall-YTDLP {
  Set-Location ..
  Remove-Item -Path $binaryPath -Force -Recurse -ErrorAction 'SilentlyContinue'
}

function download($type) {
  switch ($type) {
    1 {$completeArgs = $defaultArguments + " -f bestaudio --audio-format mp3 -x"}
    2 {$completeArgs = $defaultArguments + " -f bestvideo"}
    3 {$completeArgs = $defaultArguments + " -f `"bv+ba/b`""}
  }
  Start-Process -FilePath notepad.exe -ArgumentList Links.txt -Wait
  Clear-Host
  Write-FancyInfo "Fetching information and downloading content"
  Invoke-Expression ".\yt-dlp.exe $completeArgs"
  Start-Process -FilePath explorer.exe -ArgumentList "$env:userprofile\Downloads\Neo-YTDLP"
}

if (!(Test-Path -Path $binaryPath -ErrorAction 'SilentlyContinue')) {
  Install-YTDLP
}

$Host.UI.RawUI.WindowTitle = "Neo-YTDLP - $scriptVersion"
Set-Location $binaryPath
Invoke-Expression ".\yt-dlp.exe -U -q"
Clear-Host
Write-Host "`nPress 1 then [ENTER] for audio only downloads"
Write-Host "Press 2 then [ENTER] for video only downloads"
Write-Host "Press 3 then [ENTER] for audio and video downloads`n"
Write-Host "Press R then [ENTER] to completely reinstall yt-dlp" -ForegroundColor "DarkGray"
Write-Host "Press U then [ENTER] to completely uninstall yt-dlp`n" -ForegroundColor "DarkGray"
$optionPrompt = Read-Host -Prompt "Make a selection"

switch ($optionPrompt) {
  1 {download(1)}
  2 {download(2)}
  3 {download(3)}
  R {Uninstall-YTDLP; Install-YTDLP; Exit}
  U {Uninstall-YTDLP; Exit}
  default {Throw "Invalid option was provided"}
}

# Restore initial directory for testing purposes
Set-Location $initialDirectory
