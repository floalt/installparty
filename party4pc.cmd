:: Start-Script für configure-pc.ps1
:: ver 0.6

@echo off

SET scriptpath=%~dp0

:: ExecutionPolicy Check

powershell "Get-ExecutionPolicy" > %scriptpath%policy.tmp
set /p policy=<%scriptpath%policy.tmp
del %scriptpath%policy.tmp

IF "%policy%" EQU "Unrestricted" (
	echo "OK: ExecutionPolicy ist bereits %policy%"

) ELSE (
	echo "INFO: ExecutionPolicy muss auf Unrestricted geaendert werden..."
	powershell "Set-ExecutionPolicy Unrestricted -Force"
)


:: ExecutionPolicy Check 2

timeout 2 > nul
powershell "Get-ExecutionPolicy" > %scriptpath%policy2.tmp
	set /p policy2=<%scriptpath%policy2.tmp
	del %scriptpath%policy2.tmp

IF "%policy2%" EQU "Unrestricted" (
	echo "OK: ExecutionPolicy ist jetzt Unrestricted"
	) ELSE (
	echo.
	echo "FEHLER: ExecutionPolicy konnte nicht geaendert werden"
	echo.
	pause
	exit
)

:: Start Script

powershell "%scriptpath%configure-pc.ps1"

pause