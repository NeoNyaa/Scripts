# Set up directories needed for Optifine
Clear-Host
Write-Host "Preparing directories" -NoNewLine
Set-Location $env:APPDATA
Write-Host "." -NoNewline -ForegroundColor DarkGray
$null = New-Item -Type Directory -Path '.minecraft', '.minecraft\versions' -ErrorAction 'SilentlyContinue'
Write-Host "." -NoNewline -ForegroundColor DarkGray
Set-Location '.minecraft\versions'
Write-Host ". (Done)" -ForegroundColor DarkGray

# Fetch the version index
Write-Host "Fetching version index " -NoNewline
$versionIndex = Invoke-WebRequest -UseBasicParsing -URI 'https://piston-meta.mojang.com/mc/game/version_manifest_v2.json' -ProgressAction SilentlyContinue | ConvertFrom-Json
Write-Host "(Done)" -ForegroundColor DarkGray

# Iterate over each version from the above index and if it's a release, download the client file to the respective folder
foreach ($version in $VersionIndex.versions) {
    if ($version.type -eq "release") {
        $versionMeta = Invoke-WebRequest -UseBasicParsing -URI $version.url -ProgressAction SilentlyContinue | ConvertFrom-Json
        $versionID = $versionMeta.id

        if ($versionID -eq "1.7.1") {
            break
        }

        $null = New-Item -Type Directory -Path $versionID -ErrorAction SilentlyContinue
        Write-Host "Downloading: " -NoNewline
        Write-Host "$versionID.jar " -NoNewline -ForegroundColor Cyan

        if (!(Test-Path -Path $versionID/$versionID.jar)) {
            Invoke-WebRequest -URI $versionMeta.downloads.client.url -OutFile $versionID/$versionID.jar
            Write-Host "(Done)" -ForegroundColor DarkGray
        } else {
            Write-Host "(Skipping)" -ForegroundColor Yellow
        }
    }
}

# Let the user know the process is complete and then await an enter keypress
Write-Host "`nYou should be able to extract the Optifine mod file now"
Read-Host -Prompt "`nPress [Enter] to exit"