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
    goto :python_installed
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

:python_installed
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

:: Install Python packages, preferring binary distributions to avoid build issues
:: Justification: Installing required packages (pandas, PyQt5) using pip
echo [INFO] Installing required Python packages (pandas, PyQt5)...
%PYTHON_DIR%\Scripts\pip.exe install pandas PyQt5 --only-binary :all: || (
    echo [ERROR] Failed to install required Python packages.
    echo Press any key to close this window.
    pause
    exit /b
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

:: Download the Python script using curl
echo [INFO] Downloading adpnote.py from housinghope.site to %DOWNLOAD_PATH%...
curl -L http://housinghopedata.site/adpnote.py -o %DOWNLOAD_PATH% || (
    echo [ERROR] Failed to download adpnote.py.
    echo Press any key to close this window.
    pause
    exit /b
)

echo [INFO] Installation and setup completed successfully.
echo Press any key to close this window.
pause
endlocal

