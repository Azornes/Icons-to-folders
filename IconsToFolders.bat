@echo off & Setlocal EnableDelayedExpansion & chcp 65001
Color 0A & Mode 78,65
set "ScriptName=%~nx0"
set /a "count=0"
set /a "imagecount=0"
Title Drag and Drop a folder or multi folders over "%ScriptName%"
if "%~1"=="" goto error
for %%a in (%*) do ( 
    if "%%~xa"==".ico" (
        set /a "imagecount+=1"
        set "$images[!imagecount!]=%%~a"
    ) else (
        set /a "count+=1"
        pushd "%%~a" 2>nul && ( popd  & set "$Folder[!count!]=%%~a" )
    )
)

Timeout /T 1 /nobreak>nul

echo(
echo Please drag and drop folder with your custom icons to be set to your selected folders over here
echo and press enter...
echo(
echo Or just write the whole path and press enter ...
Set /p "iconFolder="

for /f "tokens=*" %%f in ('dir /b /s /a-d !iconFolder!\*.ico') do (
	set /a "imagecount+=1"
	set "$images[!imagecount!]=%%~f"
	echo %%f
)

Timeout /T 1 /nobreak>nul

rem Display the contents of the array $Folder
for /L %%i in (1,1,%count%) do (
    If [%count%] EQU [1] (
        echo You have chosen this folder : 
        echo [%%i] - "!$Folder[%%i]!"
    ) else (
        echo [%%i] - "!$Folder[%%i]!"
    )
)

rem Display the contents of the array $images
echo(
echo images : "!$images!"
echo Images:
for /L %%i in (1,1,!imagecount!) do (	
	set "image=!$images[%%i]!"
	echo !image!
	For %%A in ("!image!") do (
		echo full path: %%~fA
		echo directory: %%~dA
		echo path: %%~pA
		echo file name only: %%~nA
		echo extension only: %%~xA
		echo expanded path with short names: %%~sA
		echo attributes: %%~aA
		echo date and time: %%~tA
		echo size: %%~zA
		echo drive + path: %%~dpA
		echo name.ext: %%~nxA
		echo full path + short name: %%~fsA
		echo [35m___________________________________________________[0m
	)	
	echo The selected images is : "!Icon_Name!"
)

Timeout /T 1 /nobreak>nul

If [!imagecount!] == 0 (
    cls & echo(
    echo  The selected images is : "%systemroot%\system32\shell32.dll,47"
	for /L %%i in (1,1,%count%) do (
		echo !$Folder[%%i]!
		Call :WriteDesktopIni "!$Folder[%%i]!" "%systemroot%\system32\shell32.dll,47"
	)
) Else (
	cls & echo(
	for /L %%c in (1,1,!imagecount!) do (
		set "image=!$images[%%c]!"
		For %%a in ("!image!") do (
			set "Icon_Name_ext=%%~nxa"
			set "Icon_Name=%%~na" 
			set "Icon_Ext=%%~xa"
			set "Icon_Path=%%~fa"
		)
		If /I [!Icon_Ext!] EQU [.ICO] (
			echo [31m█▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█[0m
			echo The selected images is : "!Icon_Name!"
			echo From this path : "!Icon_Path!"
			echo [35m┌────────────────────────────────────────────────┐[0m
						
			for /L %%i in (1,1,%count%) do (	
				echo [35m┌────────────────────────────────────────────────┐[0m
				set "folder=!$Folder[%%i]!"
				For %%a in ("!folder!") do (
					set "folder_Name=%%~na" 
					set "folder_Ext=%%~xa"
					set "folder_Path=%%~fa"
				)
				
				echo nazwa folderu "!folder_Name!"
				echo nazwa pliku   "!Icon_Name!"
				
				If "!folder_Name!" == "!Icon_Name!" (
					echo The name of the folder is correct I'm starting to make an icon.
					echo to folder: "!folder_Path!"					
					Copy /y "!Icon_Path!" "!folder_Path!\!Icon_Name_ext!">nul 2>&1					
					Attrib +H "!folder_Path!\!Icon_Name_ext!">nul 2>&1
					Call :WriteDesktopIni "!folder_Path!" "!Icon_Path!"
					echo [35m└────────────────────────────────────────────────┘[0m
				) else (
					echo folder nie pasuje
					echo [35m└────────────────────────────────────────────────┘[0m
				)				
			)
			echo [31m█▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█[0m
		) else (
			Cls & Color 0C & echo( 
			echo The extension : [*!Icon_Ext!] is not allowed
		)		
	)
)



echo  [32mEnd of the script 1"%ScriptName%"[0m
echo  [35mYou must wait a minute for refresh icon in explorer to show up[0m
echo  [35mWait 50s or ctrl-c or close window to exit[0m
Timeout /T 50 /nobreak>nul

cls
echo(
echo  [32mEnd of the script "%ScriptName%"[0m
Timeout /T 2 /nobreak>nul & Exit
::***************************************************************************
:WriteDesktopIni [Folder] [Icon]
if exist "%~1\desktop.ini" ( attrib -h -s -a "%~1\desktop.ini" >nul 2>&1 )
(
    ECHO [.ShellClassInfo] 
    ECHO IconResource=%~2
)>"%~1\desktop.ini"
attrib +S +H +A "%~1\desktop.ini" >nul 2>&1
attrib +R "%~1" >nul 2>&1
goto :eof
::***************************************************************************
:Error
Mode 86,10 & color 0B
echo( & echo(
echo   You should drag and drop a folder or multi folders over "%ScriptName%"
echo(
echo   Or Usage in command line like this syntax : 
echo(
echo   %~nx0 "FolderPath1" "FolderPath2" "FolderPath3" "FolderPath4"
Timeout /T 10 /nobreak>nul & exit
::***************************************************************************