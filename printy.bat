@ECHO OFF
:: For Windows NT 4 or later only
IF NOT "%OS%"=="Windows_NT" GOTO Syntax

:: Localize variables
SETLOCAL
SET PrintCmd=
SET FileType=
SET Temp=%Temp:"=%

:: Command line parsing
IF NOT "%~2"=="" GOTO Syntax
IF     "%~1"=="" GOTO Syntax
IF    "%~n1"=="" GOTO Syntax
IF    "%~x1"=="" GOTO Syntax
ECHO."%~1" | FIND "/" >NUL && GOTO Syntax
ECHO."%~1" | FIND "?" >NUL && GOTO Syntax
ECHO."%~1" | FIND "*" >NUL && GOTO Syntax
IF NOT EXIST "%~1" GOTO Syntax

:: Get the file association from the registry
FOR /F "tokens=1* delims==" %%A IN ('ASSOC %~x1') DO (
	FOR /F "tokens=1 delims==" %%C IN ('FTYPE ^| FIND /I "%%~B"') DO (
		CALL :GetPrintCommand %%~C
	)
)

:: Check if a print command was found
IF NOT DEFINED PrintCmd GOTO NoAssoc

:: Print the file using the print command we just found
CALL START /MIN "PrintAny" %PrintCmd%

:: Done
GOTO End


:GetPrintCommand
:: Get the print command for this file type from the registry
FOR /F "tokens=3*" %%D IN ('REG.EXE Query HKCR\%1\shell\print\command /ve 2^>NUL') DO SET PrintCmd=%%E
IF NOT DEFINED PrintCmd GOTO:EOF
:: "Unescape" the command
SET PrintCmd=%PrintCmd:\"="%
SET PrintCmd=%PrintCmd:""="%
SET PrintCmd=%PrintCmd:\\=\%
:: Remove double double quotes in file name if applicable
ECHO.%PrintCmd% | FINDSTR.EXE /R /C:"\"%%1\"" >NUL && SET PrintCmd=%PrintCmd:"%1"="%%%~1"%
GOTO:EOF


:NoAssoc
CLS
ECHO.
ECHO Sorry, this batch file works only for known file types with associated
ECHO print commands defined in the registry hive HKEY_CLASSES_ROOT.
ECHO No print command seems to be assiociated with %~x1 files on this computer.
ECHO.


:Syntax
ECHO.
ECHO PrintAny.bat,  Version 2022 for Windows 7 and later
ECHO Prints any file type from the cmd
ECHO.
ECHO Usage:  PRINTANY  file_to_print
ECHO.
ECHO Where:  "file_to_print"  is the name of the file to be printed
ECHO                          (use double quotes for long file names)
ECHO.
ECHO.
ECHO Written by Rob van der Woude

:End
IF "%OS%"=="Windows_NT" ENDLOCAL