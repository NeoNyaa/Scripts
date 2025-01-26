# [pkill](https://cdn.githubraw.com/NeoNyaa/Scripts/main/Windows/Batch/pkill/bin/pkill.bat)
A very basic reimplementation of pkill for Windows

## Usage
`pkill <process name>`  
The process name is the filename of the running executable you want to kill excluding the .exe at the end. If you had an executable with the name of **program-8cef423.exe** running, you could use the command `pkill program-*` to forcibly kill **program-8cef423.exe** and all its child processes.

## Installation
Installation is as simple as putting the **pkill.bat** file in any folder which is specified in the path environment variable. You can list which folders are a part of the PATH environment variable by running `$env:PATH.Split(';')` in PowerShell

### Changelog
-   v1.0.0
    -   Initial Release