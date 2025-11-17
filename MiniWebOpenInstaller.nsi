!include "MUI2.nsh"
!include "LogicLib.nsh"

Name "MiniWebOpen"
OutFile "MiniWebOpen-Installer.exe"
InstallDir "$PROGRAMFILES\MiniWebOpen"
RequestExecutionLevel admin

; Add this single line for the welcome image
!define MUI_WELCOMEFINISHPAGE_BITMAP "welcome.bmp"

!define MUI_WELCOMEPAGE_TEXT "This installer will set up MiniWebOpen, which adds a context menu option to quickly start a web server in any folder.$\r$\n$\r$\nMiniWebOpen includes miniweb, a minimalistic web server developed by Avih and distributed under LGPLv2 license.$\r$\n$\r$\nWhen installed, you can right-click on any folder or within any folder's empty space and select 'Open as a webserver' to instantly start a web server serving files from that location.$\r$\n$\r$\nClick Next to continue."

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "lgpl-2.0.txt"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

!define MUI_FINISHPAGE_TEXT "MiniWebOpen has been successfully installed!$\r$\n$\r$\nYou can now right-click on any folder or within any folder's empty space and select 'Open as a webserver' to instantly start a web server on port 3333.$\r$\n$\r$\nThe web server will automatically open your browser to http://localhost:3333 after starting.$\r$\n$\r$\nThis software includes miniweb (https://github.com/avih/miniweb) which is licensed under LGPLv2."

!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"

Function .onInit
  ; Check if already installed and uninstall previous version
  ReadRegStr $0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MiniWebOpen" "UninstallString"
  ${If} $0 != ""
    MessageBox MB_YESNO "A previous version of MiniWebOpen is installed. Would you like to uninstall it first?" IDYES uninstall IDNO continue
    uninstall:
      ExecWait '$0 /S _?=$INSTDIR'
    continue:
  ${EndIf}
FunctionEnd

Section "Install"

  SetOutPath "$INSTDIR"
  File "miniweb.exe"
  WriteUninstaller "$INSTDIR\Uninstall.exe"

  ; Include LGPLv2 license file
  File "lgpl-2.0.txt"

  ; Create batch file FIRST, before registry entries
  FileOpen $0 "$INSTDIR\StartMiniWeb.bat" w
  FileWrite $0 '@echo off$\r$\n'
  FileWrite $0 'echo Starting MiniWeb server in: %1$\r$\n'
  FileWrite $0 'echo Miniweb is licensed under LGPLv2 - https://github.com/avih/miniweb$\r$\n'
  FileWrite $0 'start "MiniWeb" "$INSTDIR\miniweb.exe" -r "%~1" -p 3333$\r$\n'
  FileWrite $0 'timeout /t 1 /nobreak > nul$\r$\n'
  FileWrite $0 'start http://localhost:3333$\r$\n'
  FileClose $0

  ; Create a readme file with description and attribution
  FileOpen $0 "$INSTDIR\README.txt" w
  FileWrite $0 "MiniWebOpen - Quick Folder Web Server$\r$\n"
  FileWrite $0 "=====================================$\r$\n$\r$\n"
  FileWrite $0 "This software adds a context menu option to Windows Explorer that allows you to instantly start a web server in any folder.$\r$\n$\r$\n"
  FileWrite $0 "THIRD-PARTY COMPONENTS:$\r$\n"
  FileWrite $0 "This software includes miniweb, a minimalistic web server developed by Avih.$\r$\n"
  FileWrite $0 "miniweb is licensed under the GNU Lesser General Public License v2.0 (LGPLv2).$\r$\n"
  FileWrite $0 "Source code and license details: https://github.com/avih/miniweb$\r$\n$\r$\n"
  FileWrite $0 "FEATURES:$\r$\n"
  FileWrite $0 "- Right-click on any folder and select 'Open as a webserver'$\r$\n"
  FileWrite $0 "- Right-click on empty space within any folder and select 'Open as a webserver'$\r$\n"
  FileWrite $0 "- Automatically starts miniweb.exe serving files from the selected folder$\r$\n"
  FileWrite $0 "- Opens your browser to http://localhost:3333 automatically$\r$\n"
  FileWrite $0 "- Works with both regular folders and virtual folders$\r$\n$\r$\n"
  FileWrite $0 "USAGE:$\r$\n"
  FileWrite $0 "1. Navigate to any folder in Windows Explorer$\r$\n"
  FileWrite $0 "2. Right-click on the folder icon or empty space within the folder$\r$\n"
  FileWrite $0 "3. Select 'Open as a webserver' from the context menu$\r$\n"
  FileWrite $0 "4. A web server will start on port 3333 and your browser will open$\r$\n$\r$\n"
  FileWrite $0 "LICENSE:$\r$\n"
  FileWrite $0 "MiniWebOpen installer and context menu integration is developed by Nirklars.$\r$\n"
  FileWrite $0 "The included miniweb executable is licensed under LGPLv2 by Avih.$\r$\n"
  FileWrite $0 "See lgpl-2.0.txt for the full license terms.$\r$\n$\r$\n"
  FileWrite $0 "UNINSTALL:$\r$\n"
  FileWrite $0 "Use 'Add or Remove Programs' in Windows Settings to uninstall.$\r$\n$\r$\n"
  FileWrite $0 "miniweb repository: https://github.com/avih/miniweb$\r$\n"
  FileClose $0

  ; Create a separate attribution file
  FileOpen $0 "$INSTDIR\ATTRIBUTION.txt" w
  FileWrite $0 "Third-Party Software Attribution$\r$\n"
  FileWrite $0 "===============================$\r$\n$\r$\n"
  FileWrite $0 "MiniWebOpen includes the following third-party software:$\r$\n$\r$\n"
  FileWrite $0 "miniweb - Minimalistic web server$\r$\n"
  FileWrite $0 "---------------------------------$\r$\n"
  FileWrite $0 "Author: Avih$\r$\n"
  FileWrite $0 "Repository: https://github.com/avih/miniweb$\r$\n"
  FileWrite $0 "License: GNU Lesser General Public License v2.0 (LGPLv2)$\r$\n"
  FileWrite $0 "$\r$\n"
  FileWrite $0 "The LGPLv2 license grants you the freedom to:$\r$\n"
  FileWrite $0 "- Use the software for any purpose$\r$\n"
  FileWrite $0 "- Study how the software works and modify it$\r$\n"
  FileWrite $0 "- Distribute original or modified versions$\r$\n"
  FileWrite $0 "$\r$\n"
  FileWrite $0 "Full license text is available in lgpl-2.0.txt$\r$\n"
  FileWrite $0 "$\r$\n"
  FileWrite $0 "Nullsoft Install System$\r$\n"
  FileWrite $0 "---------------------------------$\r$\n"
  FileWrite $0 "This software is built using NSIS Nullsoft Installer System: https://nsis.sourceforge.io/Main_Page$\r$\n"
  FileWrite $0 "It is licensed under several open source licenses: https://nsis.sourceforge.io/License$\r$\n"
  FileClose $0

  ; Uninstall entry with company name and description
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MiniWebOpen" "DisplayName" "MiniWebOpen - Quick Folder Web Server"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MiniWebOpen" "UninstallString" '"$INSTDIR\Uninstall.exe"'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MiniWebOpen" "InstallLocation" "$INSTDIR"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MiniWebOpen" "DisplayIcon" "$INSTDIR\miniweb.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MiniWebOpen" "Publisher" "Nirklars"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MiniWebOpen" "DisplayVersion" "1.0.0"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MiniWebOpen" "HelpLink" "https://github.com/Nirklars/MiniwebOpen"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MiniWebOpen" "URLInfoAbout" "https://github.com/Nirklars/MiniwebOpen"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MiniWebOpen" "Comments" "Adds context menu option to start web server in any folder. Includes miniweb (LGPLv2)."
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MiniWebOpen" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MiniWebOpen" "NoRepair" 1

  ; Context menu for directories (file system folders)
  WriteRegStr HKCR "Directory\shell\OpenAsWebServer" "" "Open as a webserver"
  WriteRegStr HKCR "Directory\shell\OpenAsWebServer" "Icon" "shell32.dll,14"
  WriteRegStr HKCR "Directory\shell\OpenAsWebServer\command" "" '"$INSTDIR\StartMiniWeb.bat" "%1"'

  ; Context menu for Folder class (includes virtual folders)
  WriteRegStr HKCR "Folder\shell\OpenAsWebServer" "" "Open as a webserver"
  WriteRegStr HKCR "Folder\shell\OpenAsWebServer" "Icon" "shell32.dll,14"
  WriteRegStr HKCR "Folder\shell\OpenAsWebServer\command" "" '"$INSTDIR\StartMiniWeb.bat" "%1"'

  ; Context menu for folder background (empty space)
  WriteRegStr HKCR "Directory\Background\shell\OpenAsWebServer" "" "Open as a webserver"
  WriteRegStr HKCR "Directory\Background\shell\OpenAsWebServer" "Icon" "shell32.dll,14"
  WriteRegStr HKCR "Directory\Background\shell\OpenAsWebServer\command" "" '"$INSTDIR\StartMiniWeb.bat" "%V"'

  ; Refresh shell to make the context menu appear immediately
  System::Call 'Shell32::SHChangeNotify(i 0x8000000, i 0, i 0, i 0)'

SectionEnd

Section "Uninstall"

  ; Stop any running instances of miniweb
  ExecWait 'taskkill /f /im miniweb.exe' $0
  ExecWait 'taskkill /f /im StartMiniWeb.bat' $0

  Delete "$INSTDIR\miniweb.exe"
  Delete "$INSTDIR\Uninstall.exe"
  Delete "$INSTDIR\StartMiniWeb.bat"
  Delete "$INSTDIR\README.txt"
  Delete "$INSTDIR\ATTRIBUTION.txt"
  Delete "$INSTDIR\lgpl-2.0.txt"
  RMDir "$INSTDIR"

  ; Remove uninstall registry entry
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MiniWebOpen"

  ; Remove context menu entries
  DeleteRegKey HKCR "Directory\shell\OpenAsWebServer"
  DeleteRegKey HKCR "Folder\shell\OpenAsWebServer"
  DeleteRegKey HKCR "Directory\Background\shell\OpenAsWebServer"

  ; Refresh shell to remove the context menu immediately
  System::Call 'Shell32::SHChangeNotify(i 0x8000000, i 0, i 0, i 0)'

SectionEnd