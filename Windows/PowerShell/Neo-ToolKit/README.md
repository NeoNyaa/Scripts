# [Download Neo-ToolKit](https://cdn.githubraw.com/NeoNyaa/Scripts/main/Windows/PowerShell/Neo-ToolKit/bin/Neo-ToolKit.bat)

### Changelog

-   v1.0.0
    -   Initial Release
-   v1.0.1
    -   Fixed the script not working on PowerShell due to a simple QoL feature present in PWSH not being present in PowerShell.
        -   PowerShell and PWSH both support hashtables but what PWSH has over PowerShell is being able to fetch a key/value from a hashtable using an offset like you would with an array. PowerShell does NOT have this feature which results in a very hacky/messy work around instead of something as simple as `$hashtable.values[$i]`
-   v1.0.2
    -   Updated the link for the batch script
-   v.1.1.0
    -   Added Impersonate TrustedInstaler
-   v1.1.1
    -   Added support for keeping terminal windows open should the script actually require it
-   v1.1.2
    -   Fixed Impersonate TrustedInstaller not loading due to a mispositioned -NoExit argument
