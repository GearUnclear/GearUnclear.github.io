@echo off
setlocal

:: Set the directory where Python will be installed
:: Justification: Specifying a custom installation directory for Python
set PYTHON_DIR=C:\pyap

:: Log file for Python installation
:: Justification: Defining a log file path to capture the installation output for troubleshooting
set PYTHON_LOG=%TEMP%\python_install.log

:: Create the directory if it doesn't exist
:: Justification: Ensuring the custom installation directory exists before proceeding
if not exist "%PYTHON_DIR%" (
    echo [INFO] Creating Python installation directory at "%PYTHON_DIR%"...
    mkdir "%PYTHON_DIR%"
)

:: Check if Python is already installed in the specified directory
:: Justification: Avoiding redundant installations if Python is already installed
if exist "%PYTHON_DIR%\python.exe" (
    echo [INFO] Python is already installed at "%PYTHON_DIR%".
    goto :check_adpnote
)

:: URL of the Python installer
:: Justification: Specifying the download URL for the desired Python version
set PYTHON_URL=https://www.python.org/ftp/python/3.11.0/python-3.11.0.exe

:: Path to save the downloaded Python installer
:: Justification: Defining a temporary path to store the downloaded installer
set PYTHON_INSTALLER_PATH=%TEMP%\python-installer.exe

:: Download Python installer using PowerShell
:: Justification: Using PowerShell's Invoke-WebRequest to download the installer
echo [INFO] Downloading Python Installer from "%PYTHON_URL%"...
powershell -command "Invoke-WebRequest -Uri '%PYTHON_URL%' -OutFile '%PYTHON_INSTALLER_PATH%'" || (
    echo [ERROR] Failed to download Python Installer.
    echo Press any key to close this window.
    pause
    exit /b
)

:: Install Python silently
:: Justification: Running the Python installer silently with specific options
::   - InstallAllUsers=1: Install for all users
::   - PrependPath=1: Add Python to PATH
::   - TargetDir: Custom installation directory
::   - InstallLauncherAllUsers=1: Make Python available to all users
echo [INFO] Installing Python...
start /wait "" "%PYTHON_INSTALLER_PATH%" /quiet InstallAllUsers=0 PrependPath=1 TargetDir="%PYTHON_DIR%" InstallLauncherAllUsers=0 > "%PYTHON_LOG%" 2>&1 || (
    echo [ERROR] Failed to install Python.
    echo Press any key to close this window.
    pause
    exit /b
)

:: Check if Python was installed successfully
:: Justification: Verifying the presence of python.exe in the installation directory
if not exist "%PYTHON_DIR%\python.exe" (
    echo [ERROR] Failed to install Python. Check the log at "%PYTHON_LOG%" for more information.
    echo Press any key to close this window.
    pause
    exit /b
)

:: Python installed successfully
echo [INFO] Python installed successfully at "%PYTHON_DIR%".

:check_adpnote
:: Update PATH for this session only
:: Justification: Ensuring the current session has access to the installed Python
set PATH=%PYTHON_DIR%;%PYTHON_DIR%\Scripts;%PATH%

:: Update pip to the latest version
:: Justification: Upgrading pip to the latest version for better package management
echo [INFO] Updating pip...
"%PYTHON_DIR%\python.exe" -m pip install --upgrade pip > "%PYTHON_LOG%" 2>&1
if errorlevel 1 (
    echo [ERROR] Failed to update pip. Check the log at "%PYTHON_LOG%" for more information.
    echo Press any key to close this window.
    pause
    exit /b
) else (
    echo [INFO] pip updated successfully.
)

:: Check if required packages are installed
:: Justification: Avoiding redundant installations of packages
"%PYTHON_DIR%\Scripts\pip.exe" show pandas >nul 2>&1
if errorlevel 0 (
    echo [INFO] pandas is already installed.
) else (
    echo [INFO] Installing pandas...
    %PYTHON_DIR%\Scripts\pip.exe install pandas --only-binary :all: || (
        echo [ERROR] Failed to install pandas.
        echo Press any key to close this window.
        pause
        exit /b
    )
)

"%PYTHON_DIR%\Scripts\pip.exe" show PyQt5 >nul 2>&1
if errorlevel 0 (
    echo [INFO] PyQt5 is already installed.
) else (
    echo [INFO] Installing PyQt5...
    %PYTHON_DIR%\Scripts\pip.exe install PyQt5 --only-binary :all: || (
        echo [ERROR] Failed to install PyQt5.
        echo Press any key to close this window.
        pause
        exit /b
    )
)

"%PYTHON_DIR%\Scripts\pip.exe" show requests >nul 2>&1
if errorlevel 0 (
    echo [INFO] requests is already installed.
) else (
    echo [INFO] Installing requests...
    %PYTHON_DIR%\Scripts\pip.exe install requests --only-binary :all: || (
        echo [ERROR] Failed to install requests.
        echo Press any key to close this window.
        pause
        exit /b
    )
)

:: Initialize paths
set PRIMARY_DOWNLOAD_PATH="%USERPROFILE%\OneDrive - Housing Hope\Desktop\adpnote.py"
set SECONDARY_DOWNLOAD_PATH="%USERPROFILE%\OneDrive\Desktop\adpnote.py"
set FALLBACK_DOWNLOAD_PATH="%USERPROFILE%\Downloads\adpnote.py"

:: Try the primary OneDrive path
if exist "%USERPROFILE%\OneDrive - Housing Hope\Desktop" (
    set DOWNLOAD_PATH=%PRIMARY_DOWNLOAD_PATH%
) else (
    :: Try the secondary OneDrive path
    if exist "%USERPROFILE%\OneDrive\Desktop" (
        set DOWNLOAD_PATH=%SECONDARY_DOWNLOAD_PATH%
    ) else (
        :: Fallback to Downloads folder
        set DOWNLOAD_PATH=%FALLBACK_DOWNLOAD_PATH%
    )
)

:: Always download the latest version of adpnote.py
echo [INFO] Downloading adpnote.py from housinghope.site to %DOWNLOAD_PATH%...
curl -L http://housinghopedata.site/adpnote.py -o %DOWNLOAD_PATH% || (
    echo [ERROR] Failed to download adpnote.py.
    echo Press any key to close this window.
    pause
    exit /b
)

:: Copy adpnote.py to the primary OneDrive desktop
if exist "%PRIMARY_DOWNLOAD_PATH%" (
    del "%PRIMARY_DOWNLOAD_PATH%"
)
copy %DOWNLOAD_PATH% "%PRIMARY_DOWNLOAD_PATH%"
if errorlevel 1 (
    :: If the file copy fails, rename the newly downloaded file
    set TIMESTAMP=%DATE:~-4,4%%DATE:~-10,2%%DATE:~-7,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%
    set TIMESTAMP=%TIMESTAMP: =0%
    set RENAMED_PATH="%USERPROFILE%\OneDrive - Housing Hope\Desktop\adpnote_%TIMESTAMP%.py"
    rename %DOWNLOAD_PATH% %RENAMED_PATH%
    echo [INFO] Renamed downloaded adpnote.py to %RENAMED_PATH% due to an access issue.
) else (
    echo [INFO] Copied adpnote.py to the primary OneDrive desktop.
)

:: Copy adpnote.py to the secondary OneDrive desktop
if exist "%SECONDARY_DOWNLOAD_PATH%" (
    del "%SECONDARY_DOWNLOAD_PATH%"
)
copy %DOWNLOAD_PATH% "%SECONDARY_DOWNLOAD_PATH%"
if errorlevel 1 (
    :: If the file copy fails, rename the newly downloaded file
    set TIMESTAMP=%DATE:~-4,4%%DATE:~-10,2%%DATE:~-7,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%
    set TIMESTAMP=%TIMESTAMP: =0%
    set RENAMED_PATH="%USERPROFILE%\OneDrive\Desktop\adpnote_%TIMESTAMP%.py"
    rename %DOWNLOAD_PATH% %RENAMED_PATH%
    echo [INFO] Renamed downloaded adpnote.py to %RENAMED_PATH% due to an access issue.
) else (
    echo [INFO] Copied adpnote.py to the secondary OneDrive desktop.
)

:: Copy adpnote.py to the physical desktop, ensuring it is replaced
set PHYSICAL_DESKTOP_PATH=C:\Users\%USERNAME%\Desktop\adpnote.py
if exist %PHYSICAL_DESKTOP_PATH% (
    del %PHYSICAL_DESKTOP_PATH%
)
copy %DOWNLOAD_PATH% %PHYSICAL_DESKTOP_PATH%
if errorlevel 1 (
    :: If the file copy fails, rename the newly downloaded file
    set TIMESTAMP=%DATE:~-4,4%%DATE:~-10,2%%DATE:~-7,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%
    set TIMESTAMP=%TIMESTAMP: =0%
    set RENAMED_PATH=C:\Users\%USERNAME%\Desktop\adpnote_%TIMESTAMP%.py
    rename %DOWNLOAD_PATH% %RENAMED_PATH%
    echo [INFO] Renamed downloaded adpnote.py to %RENAMED_PATH% due to an access issue.
) else (
    echo [INFO] Copied adpnote.py to the physical desktop.
)

echo [INFO] Installation and setup completed successfully.
echo Press any key to close this window.
pause
endlocal
