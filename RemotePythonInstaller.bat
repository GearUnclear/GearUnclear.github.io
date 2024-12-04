@echo off
setlocal

:: Set the directory where Python will be installed
set PYTHON_DIR=C:\pyap

:: Log file for Python installation
set PYTHON_LOG=%TEMP%\python_install.log

:: Check if Python is already installed in the specified directory
if exist "%PYTHON_DIR%\python.exe" (
    echo [INFO] Python is already installed at "%PYTHON_DIR%".
    goto :check_chrome
)

:: Clean up any existing installation
if exist "%PYTHON_DIR%" (
    echo [INFO] Cleaning up existing Python installation...
    rmdir /s /q "%PYTHON_DIR%"
)

:: Create the directory if it doesn't exist
if not exist "%PYTHON_DIR%" (
    echo [INFO] Creating Python installation directory at "%PYTHON_DIR%"...
    mkdir "%PYTHON_DIR%"
)

:: URL of the Python installer
set PYTHON_URL=https://www.python.org/ftp/python/3.11.0/python-3.11.0-amd64.exe

:: Path to save the downloaded Python installer
set PYTHON_INSTALLER_PATH=%PYTHON_DIR%\python-installer.exe

:: Download Python installer using PowerShell
echo [INFO] Downloading Python Installer from "%PYTHON_URL%"...
powershell -command "Invoke-WebRequest -Uri '%PYTHON_URL%' -OutFile '%PYTHON_INSTALLER_PATH%'" || (
    echo [ERROR] Failed to download Python Installer.
    echo Press any key to close this window.
    pause
    exit /b
)

:: Install Python silently with retries
echo [INFO] Installing Python...
set MAX_RETRIES=3
set RETRY_COUNT=0

:retry_install
set /a RETRY_COUNT+=1
start /wait "" "%PYTHON_INSTALLER_PATH%" /quiet InstallAllUsers=0 PrependPath=1 TargetDir="%PYTHON_DIR%" InstallLauncherAllUsers=0 /log "%PYTHON_LOG%"

:: Check if Python is installed in the specified directory
if exist "%PYTHON_DIR%\python.exe" (
    echo [INFO] Python is successfully installed at "%PYTHON_DIR%".
    goto :check_chrome
)
if %RETRY_COUNT% lss %MAX_RETRIES% (
    echo [WARN] Python installation failed. Retrying... (Attempt %RETRY_COUNT% of %MAX_RETRIES%)
    goto retry_install
) else (
    echo [ERROR] Failed to install Python after %MAX_RETRIES% attempts.
    echo Check the log at "%PYTHON_LOG%" for more information.
    echo Press any key to close this window.
    pause
    exit /b
)

:check_chrome
:: Check if Chrome is already installed in the specified directory
if exist "%PYTHON_DIR%\chrome-win64\chrome.exe" (
    echo [INFO] Chrome is already installed at "%PYTHON_DIR%\chrome-win64".
    goto :check_chromedriver
)

:: URL of the Chrome zip
set CHROME_ZIP_URL=https://storage.googleapis.com/chrome-for-testing-public/126.0.6478.126/win64/chrome-win64.zip
set CHROME_ZIP_PATH=%TEMP%\chrome-win64.zip

echo [INFO] Downloading Chrome zip from "%CHROME_ZIP_URL%"...
powershell -command "Invoke-WebRequest -Uri '%CHROME_ZIP_URL%' -OutFile '%CHROME_ZIP_PATH%'" || (
    echo [ERROR] Failed to download Chrome zip.
    echo Press any key to close this window.
    pause
    exit /b
)

echo [INFO] Unzipping Chrome zip to "%PYTHON_DIR%"...
powershell -command "Expand-Archive -Path '%CHROME_ZIP_PATH%' -DestinationPath '%PYTHON_DIR%'" || (
    echo [ERROR] Failed to unzip Chrome zip.
    echo Press any key to close this window.
    pause
    exit /b
)

:check_chromedriver
:: Check if Chromedriver is already installed in the specified directory
if exist "%PYTHON_DIR%\chromedriver-win64\chromedriver.exe" (
    echo [INFO] Chromedriver is already installed at "%PYTHON_DIR%\chromedriver-win64".
    goto :update_path
)

:: URL of the Chromedriver zip
set CHROMEDRIVER_ZIP_URL=https://storage.googleapis.com/chrome-for-testing-public/126.0.6478.126/win64/chromedriver-win64.zip
set CHROMEDRIVER_ZIP_PATH=%TEMP%\chromedriver-win64.zip

echo [INFO] Downloading Chromedriver zip from "%CHROMEDRIVER_ZIP_URL%"...
powershell -command "Invoke-WebRequest -Uri '%CHROMEDRIVER_ZIP_URL%' -OutFile '%CHROMEDRIVER_ZIP_PATH%'" || (
    echo [ERROR] Failed to download Chromedriver zip.
    echo Press any key to close this window.
    pause
    exit /b
)

echo [INFO] Unzipping Chromedriver zip to "%PYTHON_DIR%"...
powershell -command "Expand-Archive -Path '%CHROMEDRIVER_ZIP_PATH%' -DestinationPath '%PYTHON_DIR%'" || (
    echo [ERROR] Failed to unzip Chromedriver zip.
    echo Press any key to close this window.
    pause
    exit /b
)

:update_path
:: Update PATH for this session only
set PATH=%PYTHON_DIR%;%PYTHON_DIR%\Scripts;%PATH%

:: Update pip to the latest version
echo [INFO] Updating pip...
"%PYTHON_DIR%\python.exe" -m pip install --upgrade pip > "%PYTHON_LOG%" 2>&1
if errorlevel 1 (
    echo [ERROR] Failed to update pip. Check the log at "%PYTHON_LOG%" for more information.
    echo [INFO] Continuing despite the error...
) else (
    echo [INFO] pip updated successfully.
)

:: Check and install pandas
echo [INFO] Checking pandas installation...
"%PYTHON_DIR%\Scripts\pip.exe" show pandas >nul 2>&1
if errorlevel 1 (
    echo [INFO] pandas is not installed. Installing now...
    "%PYTHON_DIR%\Scripts\pip.exe" install pandas --only-binary :all: || (
        echo [ERROR] Failed to install pandas.
        echo [INFO] Continuing despite the error...
    )
) else (
    echo [INFO] pandas is already installed.
)

:: Check and install PyQt5
echo [INFO] Checking PyQt5 installation...
"%PYTHON_DIR%\Scripts\pip.exe" show PyQt5 >nul 2>&1
if errorlevel 1 (
    echo [INFO] PyQt5 is not installed. Installing now...
    "%PYTHON_DIR%\Scripts\pip.exe" install PyQt5 --only-binary :all: || (
        echo [ERROR] Failed to install PyQt5.
        echo [INFO] Continuing despite the error...
    )
) else (
    echo [INFO] PyQt5 is already installed.
)

:: Check and install tkinterdnd2
echo [INFO] Checking tkinterdnd2 installation...
"%PYTHON_DIR%\Scripts\pip.exe" show tkinterdnd2 >nul 2>&1
if errorlevel 1 (
    echo [INFO] tkinterdnd2 is not installed. Installing now...
    "%PYTHON_DIR%\Scripts\pip.exe" install tkinterdnd2 --only-binary :all: || (
        echo [ERROR] Failed to install tkinterdnd2.
        echo [INFO] Continuing despite the error...
    )
) else (
    echo [INFO] tkinterdnd2 is already installed.
)

:: Install numpy with a specific version
echo [INFO] Installing numpy==1.26.4...
"%PYTHON_DIR%\Scripts\pip.exe" install numpy==1.26.4 || (
    echo [ERROR] Failed to install numpy==1.26.4.
    echo [INFO] Continuing despite the error...
)

:: Check and install requests
echo [INFO] Checking requests installation...
"%PYTHON_DIR%\Scripts\pip.exe" show requests >nul 2>&1
if errorlevel 1 (
    echo [INFO] requests is not installed. Installing now...
    "%PYTHON_DIR%\Scripts\pip.exe" install requests --only-binary :all: || (
        echo [ERROR] Failed to install requests.
        echo [INFO] Continuing despite the error...
    )
) else (
    echo [INFO] requests is already installed.
)

:: Check and install fuzzywuzzy
echo [INFO] Checking fuzzywuzzy installation...
"%PYTHON_DIR%\Scripts\pip.exe" show fuzzywuzzy >nul 2>&1
if errorlevel 1 (
    echo [INFO] fuzzywuzzy is not installed. Installing now...
    "%PYTHON_DIR%\Scripts\pip.exe" install fuzzywuzzy --only-binary :all: || (
        echo [ERROR] Failed to install fuzzywuzzy.
        echo [INFO] Continuing despite the error...
    )
) else (
    echo [INFO] fuzzywuzzy is already installed.
)

:: Check and install Pillow
echo [INFO] Checking Pillow installation...
"%PYTHON_DIR%\Scripts\pip.exe" show Pillow >nul 2>&1
if errorlevel 1 (
    echo [INFO] Pillow is not installed. Installing now...
    "%PYTHON_DIR%\Scripts\pip.exe" install Pillow --only-binary :all: || (
        echo [ERROR] Failed to install Pillow.
        echo [INFO] Continuing despite the error...
    )
) else (
    echo [INFO] Pillow is already installed.
)

:: Check and install openpyxl
echo [INFO] Checking openpyxl installation...
"%PYTHON_DIR%\Scripts\pip.exe" show openpyxl >nul 2>&1
if errorlevel 1 (
    echo [INFO] openpyxl is not installed. Installing now...
    "%PYTHON_DIR%\Scripts\pip.exe" install openpyxl --only-binary :all: || (
        echo [ERROR] Failed to install openpyxl.
        echo [INFO] Continuing despite the error...
    )
) else (
    echo [INFO] Openpyxl is already installed.
)

:: Check and install Selenium
echo [INFO] Checking Selenium installation...
"%PYTHON_DIR%\Scripts\pip.exe" show selenium >nul 2>&1
if errorlevel 1 (
    echo [INFO] Selenium is not installed. Installing now...
    "%PYTHON_DIR%\Scripts\pip.exe" install selenium --only-binary :all: || (
        echo [ERROR] Failed to install Selenium.
        echo [INFO] Continuing despite the error...
    )
) else (
    echo [INFO] Selenium is already installed.
)

:: Check and install tkinterdnd2 (New Section)
:: Note: This section has already been added above for tkinterdnd2 installation.

:: Initialize paths for downloading fscpanel.py
echo [INFO] Initializing download paths for fscpanel.py...
set PRIMARY_DOWNLOAD_PATH=%USERPROFILE%\OneDrive - Housing Hope\Desktop\fscpanel.py
set SECONDARY_DOWNLOAD_PATH=%USERPROFILE%\OneDrive\Desktop\fscpanel.py
set FALLBACK_DOWNLOAD_PATH=%USERPROFILE%\Downloads\fscpanel.py

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

:: Always download the latest version of fscpanel.py
echo [INFO] Downloading fscpanel.py from housinghope.site to %DOWNLOAD_PATH%...
curl -L http://housinghopedata.site/fscpanel.py -o "%DOWNLOAD_PATH%" || (
    echo [ERROR] Failed to download fscpanel.py.
    echo Press any key to close this window.
    pause
    exit /b
)

:: Copy fscpanel.py to the primary OneDrive desktop
if exist "%PRIMARY_DOWNLOAD_PATH%" (
    del "%PRIMARY_DOWNLOAD_PATH%"
)
copy "%DOWNLOAD_PATH%" "%PRIMARY_DOWNLOAD_PATH%" || (
    :: If the file copy fails, rename the newly downloaded file
    set TIMESTAMP=%DATE:~-4,4%%DATE:~-10,2%%DATE:~-7,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%
    set TIMESTAMP=%TIMESTAMP: =0%
    set RENAMED_PATH="%USERPROFILE%\OneDrive - Housing Hope\Desktop\fscpanel_%TIMESTAMP%.py"
    rename "%DOWNLOAD_PATH%" "%RENAMED_PATH%" || (
        echo [ERROR] Failed to rename fscpanel.py due to unexpected error.
    )
    echo [INFO] Renamed downloaded fscpanel.py to %RENAMED_PATH% due to an access issue.
) else (
    echo [INFO] Copied fscpanel.py to the primary OneDrive desktop.
)

:: Copy fscpanel.py to the secondary OneDrive desktop
if exist "%SECONDARY_DOWNLOAD_PATH%" (
    del "%SECONDARY_DOWNLOAD_PATH%"
)
copy "%DOWNLOAD_PATH%" "%SECONDARY_DOWNLOAD_PATH%" || (
    :: If the file copy fails, rename the newly downloaded file
    set TIMESTAMP=%DATE:~-4,4%%DATE:~-10,2%%DATE:~-7,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%
    set TIMESTAMP=%TIMESTAMP: =0%
    set RENAMED_PATH="%USERPROFILE%\OneDrive\Desktop\fscpanel_%TIMESTAMP%.py"
    rename "%DOWNLOAD_PATH%" "%RENAMED_PATH%" || (
        echo [ERROR] Failed to rename fscpanel.py due to unexpected error.
    )
    echo [INFO] Renamed downloaded fscpanel.py to %RENAMED_PATH% due to an access issue.
) else (
    echo [INFO] Copied fscpanel.py to the secondary OneDrive desktop.
)

:: Copy fscpanel.py to the physical desktop
set PHYSICAL_DESKTOP_PATH=C:\Users\%USERNAME%\Desktop\fscpanel.py
if exist "%PHYSICAL_DESKTOP_PATH%" (
    del "%PHYSICAL_DESKTOP_PATH%"
)
copy "%DOWNLOAD_PATH%" "%PHYSICAL_DESKTOP_PATH%" || (
    :: If the file copy fails, rename the newly downloaded file
    set TIMESTAMP=%DATE:~-4,4%%DATE:~-10,2%%DATE:~-7,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%
    set TIMESTAMP=%TIMESTAMP: =0%
    set RENAMED_PATH=C:\Users\%USERNAME%\Desktop\fscpanel_%TIMESTAMP%.py
    rename "%DOWNLOAD_PATH%" "%RENAMED_PATH%" || (
        echo [ERROR] Failed to rename fscpanel.py due to unexpected error.
    )
    echo [INFO] Renamed downloaded fscpanel.py to %RENAMED_PATH% due to an access issue.
) else (
    echo [INFO] Copied fscpanel.py to the physical desktop.
)

echo [INFO] Installation and setup completed successfully.
echo Press any key to close this window.
pause
endlocal
