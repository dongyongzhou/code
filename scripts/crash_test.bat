echo on
SET PCEXE_DIR=%CD%
SET CURRENT_DIR=%PCEXE_DIR%
echo CURRENT_DIR=%CURRENT_DIR%
cd %CURRENT_DIR%

set RESULT_FOLDER=%CURRENT_DIR%\TestResult
if not exist %RESULT_FOLDER% MD %RESULT_FOLDER%
set Test_RESULT=%RESULT_FOLDER%\test.log 

if exist %Test_RESULT% del %Test_RESULT% 
if exist log.txt del log.txt 
set File_path=%CURRENT_DIR%\logs
set Norm_File=%CURRENT_DIR%\norm.txt
set Crash_Path=H:\logs\crash\cramdump
set cramdump_path=H:\logs\crash
set count=0
echo %count% >> %Test_RESULT%

:Loop
	echo #********####Start Test*************************************#
	echo count=%count%
	echo %count% >> %Test_RESULT%
	if exist test1.txt del test1.txt 
	if exist test.txt del test.txt

	 
rem ####crash devices####
adb -s dy_test2 wait-for-devices
echo "crash devices"
adb -s dy_test2 shell "echo 'c' > /proc/sysrq-trigger"
echo "wait for devices"
adb -s dy_test2 wait-for-devices
sleep 10000
rem ###compara crash size by file and files###
adb -s dy_test2 wait-for-devices
	Sleep.exe 20000
	:PREPARE
	adb -s dy_test2 shell input keyevent 3
	Sleep.exe 5000
	adb -s dy_test2 shell am start -n com.android.systemui/.usb.UsbStorageActivity -f 0x10000000
	Sleep.exe 5000
	adb -s dy_test2 shell input keyevent 23
	Sleep.exe 100
	adb -s dy_test2 shell input keyevent 23
	Sleep.exe 100
	adb -s dy_test2 shell input keyevent 22
	Sleep.exe 100
	adb -s dy_test2 shell input keyevent 23	
	Sleep.exe 20000	
	
	dir %cramdump_path% /a
	if %errorlevel%==1 (	
		echo "Mount SD Fail">>  %Test_RESULT%
		goto PREPARE
	)else (
		echo "Mount SD pass">>  %Test_RESULT%
	)
	
	rem get carsh log file name
	echo %UMS%\%Crash_Path%
	for /f %%i in ( ' dir %Crash_Path% /B ' ) do set filename=%%i
	echo %filename%
	:COPY
	rem copy crash log to PC
	echo %Crash_Path%\%filename%
	echo %File_path%\
	MD %File_path%\%filename%
	xcopy %Crash_Path%\%filename% %File_path%\%filename%
	if %errorlevel%==0 (	
		ping -n 3 127.0.0.1>nul 
		echo " copy pass">>  %Test_RESULT%
		echo "copy pass"
		goto ChecKfile		
	)else (
	ping -n 4 127.0.1>nul 
	echo "copy Fail"
	echo "result=Fail" >>  %Test_RESULT%
	goto DEL
	)
	
	:ChecKfile	
	echo "----check copy file------"
	echo "#################%count%##########" >> log.txt
	echo "%filename%" >> log.txt
	dir  %CURRENT_DIR%\logs\%filename% /a:-d > test1.txt
	type test1.txt | find "1980" > test.txt
	fc /n test.txt %Norm_File% >> log.txt
	if %errorlevel%==0 (	
		ping -n 3 127.0.0.1>nul 
		echo " check pass">>  %Test_RESULT%
		goto DEL	
	)else (
	ping -n 4 127.0.1>nul 
	echo "check Fail">>  %Test_RESULT%
	goto DEL
	)
	
	:DEL
	rd /S /Q %Crash_Path% && Sleep.exe 2000
	dir %cramdump_path% /a | find "cramdump"
	if %errorlevel%==0 (	
		ping -n 4 127.0.1>nul 
		echo "DEL Fail">>  %Test_RESULT%
		Sleep.exe 5000
		goto DEL
	)else (
		ping -n 3 127.0.0.1>nul 
		echo " DEL pass">>  %Test_RESULT%
		 Sleep.exe 5000
		goto OK
	)
	
	
:OK
echo pass
echo RESULT=PASS >> %Test_RESULT%
set /a count+=1
if %count%==200000 (  
  goto END ) else ( 
  adb -s dy_test2 shell input keyevent 23	
  Sleep.exe 10000
  adb -s dy_test2 shell input keyevent 3
  Sleep.exe 5000
  goto Loop)  
          
rem	goto Loop



:ERROR
echo RESULT=FAIL >> %Test_RESULT%
set /a count+=1
if %count%==200000 (  
  goto END ) else ( 
  goto Loop)  
          

 
:END
pause