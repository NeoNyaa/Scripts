:: Check if the user specified an argument and quit if not
@IF [%1]==[] echo ERROR: No process name specified. && exit 1 /B

:: Kill the process the user specified, filter is here to allow for using a wildcard
@TASKKILL /F /T /FI "PID ge 0" /IM %1.exe