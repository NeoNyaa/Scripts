# [Download Force Enable Optifine Mod Extraction](https://cdn.githubraw.com/NeoNyaa/Scripts/main/Windows/PowerShell/Force-Enable-Optifine-Mod-Extraction/bin/Force-Enable-Optifine-Mod-Extraction.bat)

### Changelog

-   v1.0.0
    -   Initial Release
-   v1.0.1
    -   Disabled showing some progress bars for cleaner terminal output
        -   The progress bars disabled were those for the version index and version manifest as they are incredibly small files relitively speaking. The only progress bars that show now SHOULD be the jar file downloads bars.
-   v1.0.2
    -   Rolled back above changes because PowerShell v1 sucks
-   v1.0.3
    -   Fixed an if statement not doing what it should be doing
-   v1.0.4
    -   Fixed MC v1.7.1 getting skipped due to it being marked as a snapshot and not as a release
        -   This causes a later check to fail completely
-   v1.0.5
    -   Disabled progress bars one again to improve download speeds
