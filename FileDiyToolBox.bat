@echo off
cd /d "%~dp0"
setlocal ENABLEDELAYEDEXPANSION
title �ĵ��ռ���ݹ����� 20160706 ^| F_Ms ^| f-ms.cn

REM �����������������
REM set debug=yes
set workDir=FileDiyToolBox
set mainListFile=%workDir%\mainList.ini

REM ���������Ŀ¼����
if not exist "%workDir%\" md "%workDir%\"
if not exist "%mainListFile%" call:createEmptyFile "%mainListFile%"

REM ��������
call:argsGet %*

REM ���б�
:mainList
cls
echo=#�ĵ��ռ���ݹ�����
echo=#���б�

REM ���б�Ϊ�յĻ���ʾ�û�����б�
for /f "usebackq eol= delims=" %%a in ("%mainListFile%") do goto mainList3
echo=#��ǰ���б�Ϊ��,���������һ���б�
call:addToolToMainList "%mainListFile%"
goto mainList
:mainList3

REM ����ָ�����б�ֱ�ӽ���
if defined fDTB_mainListArgs (
	set mainList_userInput=%fDTB_mainListArgs%
	set fDTB_mainListArgs=
	goto mainList4
)

echo=#����	����	��ע
REM ��ʾ�б�
call:Database_Print /ln /q /head " " "%mainListFile%" "	" "	" "0" "1,3"

REM ��ʾ�û�ѡ�����б�
set mainList_userInput=
set subListName=
set/p mainList_userInput=#��ѡ�����б�(?):
if not defined mainList_userInput goto mainList
:mainList4
if "%mainList_userInput:~0,1%"=="+" (
	call:addToolToMainList "%mainListFile%" "%mainList_userInput:~1%"
	goto mainList
)
REM �û�ɾ�����
set mainList_doFlag=
if "%mainList_userInput:~0,1%"=="-" (
	if "%mainList_userInput:~1%"=="" (
		set/p mainList_userInput=#�����뱻ɾ���б�����ƻ�����:
		if "!mainList_userInput!"=="" goto mainList
		set mainList_userInput=-!mainList_userInput!
	)
	set mainList_userInput=!mainList_userInput:~1!
	set mainList_doFlag=delete
)
REM ����
if "%mainList_userInput:~0,1%"=="?" (
	call:help 1
	goto mainList
)
if "%mainList_userInput:~0,1%"=="��" (
	call:help 1
	goto mainList
)
REM �޸�
if "%mainList_userInput:~0,1%"=="#" (
	if "%mainList_userInput:~1%"=="" (
		set/p mainList_userInput=#������Ҫ�޸��б�����ƻ�����:
		set mainList_userInput=#!mainList_userInput!
	)
	set mainList_userInput=!mainList_userInput:~1!
	set mainList_doFlag=change
)
call:DefinedNoNumberString "%mainList_userInput%"
if "%errorlevel%"=="1" goto mainList2

REM �û������б������
set mainList_findTemp=
call:Database_Find /q /i "%mainListFile%" "	" "%mainList_userInput%" "0" "1" "mainList_findTemp"
if defined mainList_findTemp (
	for /f "tokens=1" %%a in (%mainList_findTemp%) do set mainList_userInput=%%~a
) else goto mainList

REM �û�����������
:mainList2
REM �޸����
if /i "%mainList_doFlag%"=="change" (
	call:changeMainList "%mainList_userInput%" "%mainListFile%"
	goto mainList
)

REM �����û�ѡ���ȡ���б�
call:Database_Read /q "%mainListFile%" "	" "%mainList_userInput%" "1-2" "subListName subListFile"
set subListFile=%workDir%\%subListFile%

REM �û�ɾ���б����
if /i "%mainList_doFlag%"=="delete" (
	call:queRen #ȷ��ɾ��?||goto mainList
	call:Database_DeleteLine /q "%mainListFile%" "%mainList_userInput%" "1"
	if exist "%subListFile%" del /f /q "%subListFile%"
	goto mainList
)

if not defined subListName goto mainList

:subList
cls
echo=#�ĵ��ռ���ݹ�����
echo=#���б� : %subListName%
REM ���б��¹���Ϊ�յĻ���ʾ�û���ӹ���
for /f "usebackq eol= delims=" %%a in ("%subListFile%") do goto subList2
echo=#��ǰ�б���Ϊ��,���������һ���
call:addToolToSubList "%subListName%" "%subListFile%"
goto subList
:subList2

REM ����ָ�����б�ֱ�ӽ���
if defined fDTB_subListArgs (
	set subList_userInput=%fDTB_subListArgs%
	set fDTB_subListArgs=
	goto subList4
)

echo=#����	����	��ע
call:Database_Print /ln /q /head " " "%subListFile%" "	" "	" "0" "1,3"

REM ��ʾ�û�ѡ�񹤾�
set subList_userInput=
set/p subList_userInput=#��ѡ�񹤾�(?):
if not defined subList_userInput goto subList
:subList4
set subList_doFlag=
REM �򿪹���Ŀ¼
if "%subList_userInput:~-1%"==" " if not "%subList_userInput:~0,1%"==" " (
	set subList_userInput=%subList_userInput:~0,-1%
	set subList_doFlag=openDir
)
REM ���
if "%subList_userInput:~0,1%"=="+" (
	call:addToolToSubList "%subListName%" "%subListFile%" "%subList_userInput:~1%"
	goto subList
)
REM ɾ��
if "%subList_userInput:~0,1%"=="-" (
	if "%subList_userInput:~1%"=="" (
		set/p subList_userInput=#�����뱻ɾ�����ߵ����ƻ�����:
		if "!subList_userInput!"=="" goto subList
		set subList_userInput=-!subList_userInput!
	)
	set subList_userInput=!subList_userInput:~1!
	set subList_doFlag=delete
)
REM �޸�
if "%subList_userInput:~0,1%"=="#" (
	if "%subList_userInput:~1%"=="" (
		set/p subList_userInput=#������Ҫ�޸Ĺ��ߵ����ƻ�����:
		set subList_userInput=#!subList_userInput!
	)
	set subList_userInput=!subList_userInput:~1!
	set subList_doFlag=change
)
REM �������˵�
if "%subList_userInput:~0,1%"=="0" (
	goto mainList
)
REM ����
if "%subList_userInput:~0,1%"=="?" (
	call:help 2
	goto subList
)
if "%subList_userInput:~0,1%"=="��" (
	call:help 2
	goto subList
)

call:DefinedNoNumberString "%subList_userInput%"
if "%errorlevel%"=="1" goto subList3
REM �û����빤�������
set subList_findTemp=
call:Database_Find /q /i /first "%subListFile%" "	" "%subList_userInput%" "0" "1" "subList_findTemp"
if defined subList_findTemp (
	for /f "tokens=1" %%a in (%subList_findTemp%) do set subList_userInput=%%~a
) else goto subList

REM �û�����������
:subList3

REM ɾ�����
if /i "%subList_doFlag%"=="delete" (
	call:queRen #ȷ��ɾ��?||goto subList
	call:Database_DeleteLine /q "%subListFile%" "%subList_userInput%" "1"
	goto subList
)
REM �޸����
if /i "%subList_doFlag%"=="change" (
	call:changeSubList "%subList_userInput%" "%subListFile%"
	goto subList
)

REM �����û�ѡ���ȡ���߲���
for %%a in (subList_userInput_path, subList_userInput_args, subList_userInput_startPath) do set %%a=
call:Database_Read /q "%subListFile%" "	" "%subList_userInput%" "2,4,5" "subList_userInput_path subList_userInput_args subList_userInput_startPath"

if not defined subList_userInput_path goto subList
if not exist "%subList_userInput_path%" (
	echo=#����:ָ�������Ѳ�����,�����Ƿ��ѽ������ƶ���ɾ��
	echo=	��ʹ�� #�������� ��������޸�·��
	pause
	goto subList
)

REM ������ű��򿪷�������
set fDTB_Run_method=start /normal ""
for %%a in (".bat", ".cmd") do if /i "%subList_userInput_path:~-4%"=="%%~a" set fDTB_Run_method=

REM ��ʼĿ¼����
REM ��ʼĿ¼�������
if defined fDTB_Run_startPath set "subList_userInput_startPath=%fDTB_Run_startPath%" & goto subList4
if defined subList_userInput_startPath if not "%subList_userInput_startPath%"==" " if exist "%subList_userInput_startPath%" (
	goto subList4
) else call:queRen "#��⵽��ʼĿ¼�Ѳ�����,�Ƿ��Թ���Ŀ¼Ϊ��ʼĿ¼��?"||goto subList
REM ��ʼĿ¼���������
if exist "%subList_userInput_path%\" (
	set "subList_userInput_startPath=%subList_userInput_path%"
) else for %%a in ("%subList_userInput_path%") do set "subList_userInput_startPath=%%~dpa"

:subList4
pushd "%subList_userInput_startPath%"
if /i "%subList_doFlag%"=="openDir" (
	start /normal "" explorer.exe /select,"%subList_userInput_path%"
) else (
	REM ���ݲ����򿪹���
	%fDTB_Run_method% "%subList_userInput_path%" %subList_userInput_args% %fDTB_Run_Args%
)
popd
exit/b 0



goto end
:-----------------------------------------------------------�ӳ���ʼ�ָ���-----------------------------------------------------------:

REM �����б�����ӹ���
REM call:addToolToSubList "���б�����" "���б��ļ�·��"
:addToolToSubList
REM ���в������
if "%~2"=="" (
	if defined debug (
		echo=#addToolToSubList:���б��ļ�·��Ϊ��
		pause
	)
	exit/b 2
) else if not exist "%~2" (
	if defined debug (
		echo=#addToolToSubList:���б��ļ�·��������
		pause
	)
	exit/b 2
) else if "%~1"=="" (
	if defined debug (
		echo=#addToolToSubList:���б�����Ϊ��
		pause
	)
	exit/b 2
)

echo=#��ӹ��ߵ�: %~1
if not "%~3"=="" (
	set aTTSL_toolName=%~3
	shift/3
	goto addToolToSubList_name2
)

:addToolToSubList_name
set aTTSL_toolName=
set /p aTTSL_toolName=^|	��������:
:addToolToSubList_name2
if not defined aTTSL_toolName goto addToolToSubList_name
call:checkToolName "%aTTSL_toolName%" "%~2"
if not "%errorlevel%"=="0" (
	goto addToolToSubList_name
)
:addToolToSubList_path
set aTTSL_toolPath=
set /p aTTSL_toolPath=^|	����·��:
if not defined aTTSL_toolPath goto addToolToSubList_path
set aTTSL_toolPath=%aTTSL_toolPath:"=%
if not exist "%aTTSL_toolPath%" (
	call:pathFind /q "%aTTSL_toolPath%" aTTSL_toolPath||(
		echo=		�ļ�������,������
		goto addToolToSubList_Path
	)
)

:addToolToSubList_startPath
set aTTSL_toolStartPath=
set /p aTTSL_toolStartPath=^|	��ʼĿ¼(��ѡ):
REM ��ʼĿ¼Ĭ��Ϊ��������·��
if not defined aTTSL_toolStartPath (
	set aTTSL_toolStartPath= 
	goto addToolToSubList_args
)
REM �û��������Ϊ�ļ���
set aTTSL_toolStartPath=%aTTSL_toolStartPath:"=%
if not exist "%aTTSL_toolStartPath%" (
	echo=		Ŀ¼������,������
	goto addToolToSubList_startPath
)
if not exist "%aTTSL_toolStartPath%\" (
	echo=		�����Ŀ¼,������
	goto addToolToSubList_startPath
)

:addToolToSubList_args
set aTTSL_toolArgs=
set /p aTTSL_toolArgs=^|	���в���(��ѡ):
if not defined aTTSL_toolArgs set aTTSL_toolArgs= 

:addToolToSubList_comment
set aTTSL_toolComment=
set /p aTTSL_toolComment=^|	��ע(��ѡ):
if not defined aTTSL_toolComment set aTTSL_toolComment=��
call:Database_Insert /q "%~2" "	" "%aTTSL_toolName%" "%aTTSL_toolPath%" "%aTTSL_toolComment%" "%aTTSL_toolArgs%" "%aTTSL_toolStartPath%"
exit/b 0

REM �޸����б�����
REM call:changeMainList "�޸������б�" "�����ļ�λ��"
:changeMainList
if "%~2"=="" (
	if defined debug (
		echo=#����:changeMainList:δָ�������ļ�λ��
		pause
	)
	exit/b 2
) else if not exist "%~2" (
	if defined debug (
		echo=#����:changeMainList:ָ�������ļ�������
		pause
	)
	exit/b 2
)
if "%~1"=="" (
	if defined debug (
		echo=#����:changeMainList:δָ���޸������б�
		pause
	)
	exit/b 2
) else (
	call:DefinedNoNumberString "%~1"&&(
		if defined debug (
			echo=#����:changeMainList:ָ���޸������б겻�Ϲ�
			pause
		)
		exit/b 2
	)
)
for %%a in (changeMainList_name changeMainList_comment) do set %%a=
call:Database_Read /q "%~2" "	" "%~1" "1,3" "changeMainList_name changeMainList_comment"
:changeMainList2
cls
echo=#�ĵ��ռ���ݹ�����
echo=#�б������޸�
echo= 1. ����: %changeMainList_name%
echo= 2. ��ע: %changeMainList_comment%

set changeMainList_userInput=
set/p changeMainList_userInput=#��ѡ������(?):
if not defined changeMainList_userInput goto changeMainList2
if "%changeMainList_userInput%"=="?" (
	call:help 3
)
if "%changeMainList_userInput%"=="��" (
	call:help 3
)
if not %changeMainlist_userInput% geq 0 goto changeMainList2
if not %changeMainlist_userInput% leq 2 goto changeMainList2
if "%changeMainlist_userInput%"=="0" exit/b 0

set changeMainList_newAttrib=
set/p changeMainList_newAttrib=#������������:
if not defined changeMainList_newAttrib goto changeMainList2

REM ȥ���������
set "changeMainList_newAttrib=%changeMainList_newAttrib:"=%"

REM �޸�����
if "%changeMainlist_userInput%"=="1" (
	call:checkToolName "%changeMainList_newAttrib%" "%~2"||(
		pause
		goto changeMainList2
	)
	call:Database_Update /q "%~2" "	" "%~1" "1" "%changeMainList_newAttrib%"
	set "changeMainList_name=%changeMainList_newAttrib%"
)
REM �޸ı�ע
if "%changeMainlist_userInput%"=="2" (
	call:Database_Update /q "%~2" "	" "%~1" "3" "%changeMainList_newAttrib%"
	set "changeMainList_comment=%changeMainList_newAttrib%"
)
goto changeMainList2
exit/b 0

REM �޸Ĺ�������
REM call:changeSubList "�޸������б�" "�����ļ�λ��"
:changeSubList
if "%~2"=="" (
	if defined debug (
		echo=#����:changeSubList:δָ�������ļ�λ��
		pause
	)
	exit/b 2
) else if not exist "%~2" (
	if defined debug (
		echo=#����:changeSubList:ָ�������ļ�������
		pause
	)
	exit/b 2
)
if "%~1"=="" (
	if defined debug (
		echo=#����:changeSubList:δָ���޸������б�
		pause
	)
	exit/b 2
) else (
	call:DefinedNoNumberString "%~1"&&(
		if defined debug (
			echo=#����:changeSubList:ָ���޸������б겻�Ϲ�
			pause
		)
		exit/b 2
	)
)
for %%a in (changeSubList_name changeSubList_path changeSubList_comment changeSubList_args changeSubList_startPath) do set %%a=
call:Database_Read /q "%~2" "	" "%~1" "1-5" "changeSubList_name changeSubList_path changeSubList_comment changeSubList_args changeSubList_startPath"
:changeSubList2
cls
echo=#�ĵ��ռ���ݹ�����
echo=#���������޸�
echo= 1. ����: %changeSubList_name%
echo= 2. ·��: %changeSubList_path%
echo= 3. ����: %changeSubList_args%
echo= 4. ��ʼĿ¼: %changeSubList_startPath%
echo= 5. ��ע: %changeSubList_comment%

set changeSubList_userInput=
set/p changeSubList_userInput=#��ѡ������(?):
if not defined changeSubList_userInput goto changeSubList2
if "%changeSubList_userInput%"=="?" (
	call:help 3
)
if "%changeSubList_userInput%"=="��" (
	call:help 3
)
if not %changeSublist_userInput% geq 0 goto changeSubList2
if not %changeSublist_userInput% leq 5 goto changeSubList2
if "%changeSublist_userInput%"=="0" exit/b 0

set changeSubList_newAttrib=
set/p changeSubList_newAttrib=#������������:
if not defined changeSubList_newAttrib goto changeSubList2

REM ȥ���������
set "changeSublist_newAttrib=%changeSublist_newAttrib:"=%"

REM �޸�����
if "%changeSublist_userInput%"=="1" (
	call:checkToolName "%changeSubList_newAttrib%" "%~2"||(
		pause
		goto changeSubList2
	)
	call:Database_Update /q "%~2" "	" "%~1" "1" "%changeSubList_newAttrib%"
	set "changeSubList_name=%changeSubList_newAttrib%"
)
REM �޸�·��
if "%changeSublist_userInput%"=="2" (
	if not exist "!changeSublist_newAttrib!" (
		call:pathFind /q "%changeSublist_newAttrib%" changeSublist_newAttrib||(
			echo=		�ļ�������,������
			pause
			goto changeSubList2
		)
	)
	call:Database_Update /q "%~2" "	" "%~1" "2" "!changeSubList_newAttrib!"
	set "changeSubList_path=!changeSubList_newAttrib!"
)
REM �޸Ĳ���
if "%changeSublist_userInput%"=="3" (
	call:Database_Update /q "%~2" "	" "%~1" "4" "%changeSubList_newAttrib%"
	set "changeSubList_args=%changeSubList_newAttrib%"
)
REM �޸���ʼĿ¼
if "%changeSublist_userInput%"=="4" (
	if not "!changeSubList_newAttrib!"==" " (
		if not exist "!changeSublist_newAttrib!" (
			echo=		·��������,������
			pause
			goto changeSubList2
		)
		if not exist "!changeSublist_newAttrib!\" (
			echo=		�����Ŀ¼,������
			pause
			goto changeSubList2
		)
	)
	call:Database_Update /q "%~2" "	" "%~1" "5" "!changeSubList_newAttrib!"
	set "changeSubList_startPath=!changeSubList_newAttrib!"
)
REM �޸ı�ע
if "%changeSublist_userInput%"=="5" (
	call:Database_Update /q "%~2" "	" "%~1" "3" "%changeSubList_newAttrib%"
	set "changeSubList_comment=%changeSubList_newAttrib%"
)
goto changeSubList2
exit/b 0



REM �����б���������б�
REM call:addToolToMainList "���б���ļ�·��"
:addToolToMainList
REM ���в������
if "%~1"=="" (
	if defined debug (
		echo=#addToolToMainList:���б���ļ�·��Ϊ��
		pause
	)
	exit/b 2
) else if not exist "%~1" (
	if defined debug (
		echo=#addToolToMainList:���б���ļ�·��������
		pause
	)
	exit/b 2
)

echo=#����б�
if not "%~2"=="" (
	set aTTML_toolName=%~2
	shift/2
	goto addToolToMainList_name2
)

:addToolToMainList_name
set aTTML_toolName=
set /p aTTML_toolName=^|	�б�����:
:addToolToMainList_name2
if not defined aTTML_toolName goto addToolToMainList_name
call:checkToolName "%aTTML_toolName%" "%~1"
if not "%errorlevel%"=="0" (
	goto addToolToMainList_name
)

:addToolToMainList_comment
set aTTML_toolComment=
set /p aTTML_toolComment=^|	��ע(��ѡ):
if not defined aTTML_toolComment set aTTML_toolComment=��
call:Database_Insert /q "%~1" "	" "%aTTML_toolName%" "%aTTML_toolName%.txtDB" "%aTTML_toolComment%"
call:createEmptyFile "%workDir%\%aTTML_toolName%.txtDB"
exit/b 0

REM �б�/�������ƺϹ��ж�
REM call:checkToolName "����" "���ظ�����ļ�"
:checkToolName
if "%~2"=="" (
	if defined debug (
		echo=#����:checkToolName:δָ�����ظ�����ļ�
		pause
	)
	exit/b 2
) else if not exist "%~2" (
	if defined debug (
		echo=#����:checkToolName:ָ�����ظ�����ļ�������
		pause
	)
)
if "%~1"=="" (
	if defined debug (
		echo=#����:checkToolName:δָ���������
		pause
	)
	exit/b 2
)
set checkToolName_toolName=
set checkToolName_toolName=%~1
if not defined checkToolName_toolName exit/b 1
if "%checkToolName_toolName:~0,1%"=="+" (
	echo=		���Ʋ����� + - # ?^(������^) ��ͷ���볢�Ը�������
	exit/b 1
)
if "%checkToolName_toolName:~0,1%"=="-" (
	echo=		���Ʋ����� + - # ?^(������^) ��ͷ���볢�Ը�������
	exit/b 1
)
if "%checkToolName_toolName:~-1%"==" " (
	echo=		���Ʋ����Կո��β���볢�Ը�������
	exit/b 1
)
if "%checkToolName_toolName:~0,1%"=="?" (
	echo=		���Ʋ����� + - # ?^(������^) ��ͷ���볢�Ը�������
	exit/b 1
)
if "%checkToolName_toolName:~0,1%"=="#" (
	echo=		���Ʋ����� + - # ?^(������^) ��ͷ���볢�Ը�������
	exit/b 1
)
if "%checkToolName_toolName:~0,1%"=="��" (
	echo=		���Ʋ����� + - # ?^(������^) ��ͷ���볢�Ը�������
	exit/b 1
)
if /i "%checkToolName_toolName%"=="/args" (
	echo=		���Ʋ���Ϊ /args /path ^(������^)���볢�Ը�������
	exit/b 1
)
if /i "%checkToolName_toolName%"=="/path" (
	echo=		���Ʋ���Ϊ /args /path ^(������^)���볢�Ը�������
	exit/b 1
)


call:DefinedNoNumberString "%checkToolName_toolName:~0,1%"
if "%errorlevel%"=="1" (
	echo=		���Ʋ��������ֿ�ͷ,�볢�Ը�������
	exit/b 1
)
call:Database_Find /q /i /first "%~2" "	" "%checkToolName_toolName%" "0" "1" "checkToolName_find2temp"
if defined checkToolName_find2temp (
	echo=		����: %checkToolName_toolName% �Ѵ���, �볢�Ը�������
	exit/b 1
)
exit/b 0

REM ������ȡ
REM call:argsGet %*
:argsGet
for %%a in (fDTB_Run_Args, fDTB_mainListArgs, fDTB_subListArgs, fDTB_Run_startPath) do set %%a=

:argsGet1_2
set fDTB_Run_ArgsTemp=
set fDTB_Run_ArgsTemp=%1
if defined fDTB_Run_ArgsTemp if /i "/path"=="%~1" (
	if exist "%~2\" (
		set "fDTB_Run_startPath=%~2"
	)
	shift/1
	shift/1
	goto argsGet1_2
) else if /i "/args"=="%~1" (
	shift/1
	goto argsGet2
) else (
	if not defined fDTB_mainListArgs (
		set fDTB_mainListArgs=%~1
	) else if not defined fDTB_subListArgs (
		set fDTB_subListArgs=%~1
	)
	shift/1
	goto argsGet1_2
)
exit/b 0

:argsGet2
set fDTB_Run_ArgsTemp=
set fDTB_Run_ArgsTemp=%1
if not defined fDTB_Run_ArgsTemp goto argsGet3
set fDTB_Run_Args=%fDTB_Run_Args% %1
shift/1
goto argsGet2
:argsGet3
exit/b 0

REM ȷ�ϣ�
REM 20160502
REM call:queRen ["��ʾ����"] ["ȷ�ϰ���"] ["ȡ������"]
REM ����ֵ��0-�û�ȷ�ϣ�1-�û�ȡ��
:queRen
set queRen_tips=ȷ��?
set queRen_yes=Y
set queRen_no=

if not "%~1"=="" set queRen_tips=%~1
if not "%~2"=="" set queRen_yes=%~2
if not "%~3"=="" set queRen_no=%~3
set queRen_tips=%queRen_tips% [��:%queRen_yes%
if defined queRen_no (
	set queRen_tips=%queRen_tips%/��:%queRen_no%]
) else (
	set queRen_tips=%queRen_tips%]
)

:queRen2
set queRen_user=
set /p queRen_user=%queRen_tips%:
if defined queRen_user (
	
	if /i "%queRen_user%"=="%queRen_yes%" exit/b 0
	if defined queRen_no if /i not "%queRen_user%"=="%queRen_no%" goto queRen2
	
) else (
	if defined queRen_no goto queRen2
)
exit/b 1

REM �������ļ� 20160425
REM call:createEmptyFile "�ļ���"
REM ����ֵ��1 - �ļ�����ʧ�ܣ� 2 - ���ò������� 0 - �ɹ�
:createEmptyFile
REM �жϲ����Ƿ���ȷ
if "%~1"=="" (
	if defined debug (
		echo=#createEmptyFile:����Ϊ��
		pause
	)
	exit/b 2
)

REM ���ɿ��ļ�
(
	if a==b echo=�˴��������ɿ��ļ�
)>"%~1"

if exist "%~1" (
	exit/b 0
) else if defined debug (
	echo=#createEmptyFile:�ļ�����ʧ��
	pause
)
exit/b 1

REM ����
REM call:help [1/2/3]
REM  1 - ���б����
REM  2 - ���߰���
:help
if "%~1"=="" exit/b 1
if "%~1"=="1" (
	echo=#�б����
	echo=	�����б����кŻ����ƿ�ֱ�ӽ����б�
	echo=	+ ����б�,����+��ֱ�Ӹ�������б�����Ƽ���
	echo=	- ɾ���б�,����-��ֱ�Ӹ���ɾ���б����кŻ�����
	echo=	# �޸��б�,����#��ֱ�Ӹ����޸��б����кŻ�����
	echo=
	echo=	֧�ֲ�������: "%~nx0" [�б����л�����] [�������л�����] [/path ��ʼĿ¼] [/args [����1 ����2 ...]]
	echo=	  ����:
	echo=		��tool�б�: "%~nx0" tool
	echo=		��tool�б��µ�ec: "%~nx0" tool ec
	echo=		�򿪵�1���б�ĵ�2���: "%~nx0" 1 2
	echo=		�򿪵�1���б�ĵ�2���,��ʼĿ¼Ϊc:\windows: "%~nx0" 1 2 /path c:\windows
	echo=			�繤��������ʼĿ¼��ʧЧ����ʹ�ò���ָ������ʼĿ¼
	echo=		��tool�б��µ�ec��������/f /q���ݸ�ec: "%~nx0" tool ec /args /f /q
	echo=			����������в�����ָ����������ӵ����в�����
	echo=		��tool�б���ec��������,��ʼĿ¼Ϊc:\windows����/f /q��������
	echo=			"%~nx0" tool ec /path c:\windows /args /f /q
	echo=
	pause
)
if "%~1"=="2" (
	echo=#���߰���
	echo=	���빤�����кŻ����ƿ�ֱ�Ӵ򿪹���
	echo=	  �������кŻ����ƺ���ո�ɴ򿪹�������Ŀ¼
	echo=	+ ��ӹ���,����+��ֱ�Ӹ�����ӹ�������
	echo=	- ɾ������,����-��ֱ�Ӹ���ɾ���������кŻ�����
	echo=	# �޸Ĺ���,����#��ֱ�Ӹ����޸Ĺ������кŻ�����
	echo=	0 �������б�
	echo=
	pause
)
if "%~1"=="3" (
	echo=#�޸İ���
	echo=	����ָ���������кż����޸�ָ������
	echo=	0 �������б�
	echo=	��ʼĿ¼������Ϊ�ո��򹤾���������ʼĿ¼Ϊ��������Ŀ¼
	pause
)

exit/b 0


REM ��PathĿ¼�в����ҵ��ĵ�һ��ָ�������ִ�г���(pathext��չ��)��ȫ·��
REM call:pathFind [/Q(����ģʽ)] "���ҳ�����" "ȫ·��������ձ���"
REM errorlevel: 0 - �ҵ�, 1 - δ�ҵ�, 2 - ��������
REM 20160507
:pathFind
REM ʹ�ò����ж�
set pathFindQuit=
if /i "%~1"=="/q" (
	set pathFindQuit=yes
	shift/1
)
if "%~2"=="" (
	if not defined pathFindQuit (
		echo=	#����:pathFind:δָ��ȫ·��������ձ���
		pause
	)
	exit/b 2
)
if "%~1"=="" (
	if not defined pathFindQuit (
		echo=	#����:pathFind:δָ�����ҳ�����
		pause
	)
	exit/b 2
)
set pathFind_appName=%~1
for %%a in (/,\,:) do if not "%pathFind_appName%"=="!pathFind_appName:%%a=!" exit/b 1

REM ��ʼ������
set %~2=
if defined pathext (set pathFind_pathextTemp=%pathext%;.lnk) else set pathFind_pathextTemp=.EXE;.BAT;.CMD;.VBS;.lnk
if not defined path exit/b 1

REM ���ָ��������������չ�����ж�
if not "%~x1"=="" set "pathFind_pathextTemp=%~x1"

REM ����pathĿ¼
for /f "delims==" %%a in ('set pathFind_parsePath 2^>nul') do set %%a=
set pathFind_parsePath_count=0
set pathFind_pathTemp=
set pathFind_pathTemp=%path%

:pathFind_parsePath2
set /a pathFind_parsePath_count+=1
for /f "tokens=1,* delims=;" %%a in ("%pathFind_pathTemp%") do (
	set "pathFind_parsePath%pathFind_parsePath_count%=%%~a"
	if not "%%~b"=="" (
		set pathFind_pathTemp=
		set "pathFind_pathTemp=%%~b"
		goto pathFind_parsePath2
	)
)

REM ��ʼ����
for /l %%a in (1,1,%pathFind_parsePath_count%) do (
	for %%b in (%pathFind_pathextTemp%) do (
		if exist "!pathFind_parsePath%%a!\%~n1%%~b" (
			set "%~2=!pathFind_parsePath%%a!\%~n1%%~b"
			exit/b 0
		)
	)
)
exit/b 1


REM �жϱ������Ƿ��з������ַ� call:DefinedNoNumberString ���ж��ַ�
REM	����ֵ0�����з������ַ�������ֵ1�����޷������ַ�������ֵ2�������Ϊ��
REM �汾��20151231
:DefinedNoNumberString
REM �ж��ӳ�������������
if "%~1"=="" exit/b 2

REM ��ʼ���ӳ����������
for %%B in (DefinedNoNumberString) do set %%B=
set DefinedNoNumberString=%~1

REM �ӳ���ʼ����
for /l %%B in (0,1,9) do (
	set DefinedNoNumberString=!DefinedNoNumberString:%%B=!
	if not defined DefinedNoNumberString exit/b 1
)
exit/b 0
REM __________________________________________________________________�������ı����ݿ⹤����____________________________________________________________________________
REM 
REM                                                          ���������������ı����ݿ�Ĳ���Ч�ʼ��׻�
REM                                                                        -20160625-
REM                                                     ���ߣ�F_Ms | ���䣺imf_ms@yeah.net | ���ͣ�f-ms.cn
REM ____________________________________________________________________________________________________________________________________________________________________
REM 
REM ʹ�÷�����
REM 	���ӳ���ģ��ֱ�Ӹ��Ƶ��Լ������к�ֱ�Ӹ���ʹ�÷������ü���(���ᱻ�������е���λ��)��ÿ���ӳ��򶼿��Զ������У�����Ҫ��ģ��ֱ�����ͺ���
REM 	�����ӳ���û��ʹ�õ��������ߣ�Ҳû��ʹ�ò��ȶ��Ľ����ȡ����������жϣ������������⣬WinXP/Win7/Win10���Ծ�δ������
REM 
REM ע�����
REM 	�ӳ���������Ҫ�����ӳ٣�setlocal ENABLEDELAYEDEXPANSION��ע�⿪��
REM 	�ӳ���ʹ��������for %���� (��ʮ����ASCII�����ַ�������),���ڱ�д����ʱforǶ���е���������ʱ�ܿ���Щ������
REM 		%%; %%: %%^> %%? %%@ %%A %%B %%C %%D %%E %%F %%G %%H %%I %%J %%K %%L %%M %%N %%O %%P %%Q %%R %%S %%T %%U %%V %%W %%X %%Y %%Z %%[ %%\ %%] %%_
REM 	�����ӳ���δ�����������ַ��Ĵ������ԣ�����"< > ( ) | &"����Щ�ַ��ļ����Ծͺ��ѱ�֤��
REM ____________________________________________________________________________________________________________________________________________________________________
REM 
REM #	Database_Read	��ָ���ļ���ָ���С�ָ���ָ�����ָ���л�ȡ���ݸ�ֵ��ָ������
REM 		call:Database_Read [/Q(����ģʽ������ʾ����)] "����Դ�ļ�" "�����зָ���" "����������" "�Էָ���Ϊ�ָ��N������(��Ŀ������Ŀ��֮��ʹ��,�ָ�ҿ�������ָ��-)" "������������(�������֮��ʹ�ÿո��,���зָ�)"
REM 			���ӣ����ļ� "c:\users\a\Database.ini" �н��� "	" Ϊ�ָ����ĵ�4�����ݵĵ�1,2,3,6�����ݷֱ�ֵ��var1,var2,var3,var4
REM					call:Database_Read "c:\users\a\Database.ini" "	" "4" "1-3,6" "var1 var2 var3 var4"
REM ____________________________________________________________________________________________________________________________________________________________________
REM 
REM #	Database_Update	�޸�ָ���ļ���ָ������ָ���ָ����ָ��ָ���е�����
REM 		call:Database_Update [/Q(����ģʽ������ʾ����)] "����Դ" "�����зָ���" "���޸��������ڿ�ʼ�к�" "�Էָ���Ϊ�ָ��N������(�к����к�֮��ʹ��,�ָ�ҿ�������ָ��-)" "���е�һ���޸ĺ�����" "���еڶ����޸ĺ�����" ...
REM 			���ӣ����ļ� "c:\users\a\Database.ini" �е�4���� "	" Ϊ�ָ�1,2,3,6�������޸�Ϊ�ֱ��޸�Ϊ string1 string2 string3 string4
REM					call:Database_Update "c:\users\a\Database.ini" "	" "4" "1-3,6" "string1" "string2" "string3" "string4"
REM ____________________________________________________________________________________________________________________________________________________________________
REM 
REM #	Database_Print	��ָ���ļ���ָ���С�ָ���ָ�����ָ���л�ȡ���ݲ���ӡ����Ļ���ļ�
REM call:Database_Print [/Q(����ģʽ������ʾ����)] [/LN(��ʾ�����������ӡ�����е����,������������Դ�ļ��е��к�)] [/HEAD ��ӡ��ͷ�������] [/FOOT ��ӡ��β׷������] "����Դ" "������ȡ�ָ���" "���ݴ�ӡ�ָ���" "��ӡ������(֧�ֵ����ָ���,�����������ָ���-,0Ϊָ��ȫ����)" "�Էָ���Ϊ�ָ��N������(�к����к�֮��ʹ��,�ָ�ҿ�������ָ��-)" [/F �ļ�(������������ļ�)] 
REM 			���ӣ����ļ� "c:\users\a\Database.ini" �еĵ�4-5���� "	" Ϊ�ָ����ĵ�1,2,3,6��������"*"Ϊ�ָ�����ӡ����
REM 				call:Database_Print "c:\users\a\Database.ini" "	" "*" "4-5" 1-3,6"
REM ____________________________________________________________________________________________________________________________________________________________________
REM 
REM #	Database_Find	��ָ���ļ���ָ���С�ָ���ָ�����ָ���С�ָ���ַ�����������������������к�д�뵽ָ��������
REM 		call:Database_Find [/Q(����ģʽ������ʾ����)] [/i(�����ִ�Сд)] [/first(���ز��ҵ��ĵ�һ�����)] "����Դ" "�����зָ���"  "�����ַ���" "����������(֧�ֵ����ָ���,�����������ָ���-,0Ϊָ��ȫ����)" "����������(֧�ֵ����ָ���,�����������ָ���-)" "���ҽ���к��кŽ�����ܸ�ֵ������"
REM 			ע��---------------------------------------------------------------------------------------------------------------------------------
REM 				��������������ʽΪ��"�� ��","�� ��","..."���εݼӣ�����ڶ��е����к͵����е����еĸ�ֵ���ݾ�Ϊ��"2 3","5 6"
REM 				����ʹ�� 'for %%a in (%�������%) do for /f "tokens=1,2" %%b in ("%%~a") do echo=��%%b�У���%%c��' �ķ������н��ʹ��
REM 				---------------------------------------------------------------------------------------------------------------------------------
REM 			���ӣ����ļ� "c:\users\a\Database.ini"�е�����������"	"Ϊ�ָ����ĵ�һ���в����ִ�Сд�Ĳ����ַ���data(��ȫƥ��)����������������кŸ�ֵ������result
REM 				call:Database_Find /i "c:\users\a\Database.ini" "	" "data" "3-5" "1" "result"
REM ____________________________________________________________________________________________________________________________________________________________________
REM 
REM #	Database_Insert	�������ݵ�ָ���ı����ݿ��ļ���
REM 		call:Database_Insert [/Q(����ģʽ������ʾ����)] "����Դ" [/LN [���뵽��λ��(Ĭ�ϵײ�׷��)]] "�����зָ���" "����1" "����2" "����3" "..."
REM 			���ӣ�������"data1" "data2" "data3" �� "	"Ϊ�ָ������뵽�ı����ݿ��ļ�" "c:\users\a\Database.ini"
REM 				call:Database_Insert "c:\users\a\Database.ini" "	" "data1" "data2" "data3"
REM ____________________________________________________________________________________________________________________________________________________________________
REM 
REM #	Database_Sort	����������ʹ��ת�Ƶ�ָ����
REM 		call:Database_Sort [/Q(����ģʽ������ʾ����)] "����Դ" "�������к�" "������к�"
REM 			���ӣ����ļ� "c:\users\a\Database.ini" �е���������ԭ�ڶ��е�λ��
REM 				call:Database_Sort "c:\users\a\Database.ini" "4" "2"
REM ____________________________________________________________________________________________________________________________________________________________________
REM 
REM #	Database_DeleteLine	ɾ��ָ���ļ�ָ����
REM 		call:Database_DeleteLine [/Q(����ģʽ������ʾ����)] "����Դ" "��ɾ��������ʼ��" "����ʼ�п�ʼ��������ɾ��������(�������У����µ���β������0)"
REM 			���ӣ����ļ� "c:\users\a\Database.ini" �еڶ�������ɾ��
REM 				call:Database_DeleteLine "c:\users\a\Database.ini" "2" "2"
REM ____________________________________________________________________________________________________________________________________________________________________

:---------------------Database_Print---------------------:

REM ��ָ���ļ���ָ���С�ָ���ָ�����ָ���л�ȡ���ݲ���ӡ����Ļ���ļ�
REM call:Database_Print [/Q(����ģʽ������ʾ����)] [/LN(��ʾ�����������ӡ�����е����,������������Դ�ļ��е��к�)] [/HEAD ��ӡ��ͷ�������] [/FOOT ��ӡ��β׷������] "����Դ" "������ȡ�ָ���" "���ݴ�ӡ�ָ���" "��ӡ������(֧�ֵ����ָ���,�����������ָ���-,0Ϊָ��ȫ����)" "�Էָ���Ϊ�ָ��N������(�к����к�֮��ʹ��,�ָ�ҿ�������ָ��-)" [/F �ļ�(������������ļ�)] 
REM ���ӣ����ļ� "c:\users\a\Database.ini" �еĵ�4-5���� "	" Ϊ�ָ����ĵ�1,2,3,6��������"*"Ϊ�ָ�����ӡ����
REM					call:Database_Print "c:\users\a\Database.ini" "	" "*" "4-5" 1-3,6"
REM ����ֵ���飺0-����������1-���޴��У�2-�����������ӳ���
REM ע�⣺����ֵ���ֻ֧�ֵ�31�У��Ƽ��ڴ������ݵ�ʱ��ʹ���Ʊ��"	"Ϊ�ָ������Է��������ݺͷָ�������,�ı����ݿ��в�Ҫ���п��кͿ�ֵ����ֹ�������ݴ���
REM �汾:20160625
:Database_Print
REM ����ӳ������л����������
for %%A in (d_P_ErrorPrint d_P_LineNumber d_P_PrintHead d_P_PrintFoot) do set "%%A="
if /i "%~1"=="/ln" (
	set "d_P_LineNumber=Yes"
	shift/1
) else if /i "%~1"=="/q" (shift/1) else set "d_P_ErrorPrint=Yes"
if /i "%~1"=="/ln" (
	set "d_P_LineNumber=Yes"
	shift/1
) else if /i "%~1"=="/q" (shift/1) else set "d_P_ErrorPrint=Yes"

if /i "%~1"=="/head" (
	set "d_P_PrintHead=%~2"
	shift/1
	shift/1
) else if /i "%~1"=="/foot" (
	set "d_P_PrintFoot=%~2"
	shift/1
	shift/1
)
if /i "%~1"=="/head" (
	set "d_P_PrintHead=%~2"
	shift/1
	shift/1
) else if /i "%~1"=="/foot" (
	set "d_P_PrintFoot=%~2"
	shift/1
	shift/1
)

if /i "%~6"=="/f" if "%~7"=="" (
	if defined d_P_ErrorPrint echo=	[����%0:����7-ָ������ļ�Ϊ��]
)
if "%~5"=="" (
	if defined d_P_ErrorPrint echo=	[����%0:����6-ָ����Ŀ��Ϊ��]
	exit/b 2
)
if "%~4"=="" (
	if defined d_P_ErrorPrint echo=	[����%0:����4-ָ���к�Ϊ��]
	exit/b 2
)
if "%~3"=="" (
	if defined d_P_ErrorPrint echo=	[����%0:����3-ָ�����ݴ�ӡ�ָ���Ϊ��]
	exit/b 2
)
if "%~2"=="" (
	if defined d_P_ErrorPrint echo=	[����%0:����2-ָ��������ȡ�ָ���Ϊ��]
	exit/b 2
)
if "%~1"=="" (
	if defined d_P_ErrorPrint echo=	[����%0:����1-ָ������Դ�ļ�Ϊ��]
	exit/b 2
) else if not exist "%~1" (
	if defined d_P_ErrorPrint echo=	[����%0:����1-ָ������Դ�ļ�������:%~1]
	exit/b 2
)
REM ��ʼ������
for %%_ in (d_P_Count d_P_Count2 d_P_Count3 d_P_ValueTemp d_P_StringTest d_P_Count4 d_P_Pass) do set "%%_="
for /f "delims==" %%_ in ('set d_P_AlreadyLineNumber 2^>nul') do set "%%_="
if /i "%~6"=="/f" (
	set d_P_File=">>"%~7""
	if exist "%~7" del /f /q "%~7"
) else set "d_P_File= "

REM �ӳ���ʼ����

REM �ж��û������к��Ƿ���Ϲ���
set "d_P_StringTest=%~4"
for %%_ in (1,2,3,4,5,6,7,8,9,0,",",-) do if defined d_P_StringTest set "d_P_StringTest=!d_P_StringTest:%%~_=!"
if defined d_P_StringTest (
	if defined d_P_ErrorPrint echo=	[����%0:����4:ָ�������в����Ϲ���:%~4]
	exit/b 2
)
for %%_ in (%~4) do (
	set "d_P_Pass="
	set "d_P_Pass=%%~_"
	if "!d_P_Pass!"=="!d_P_Pass:-=!" (
		if "%%~_"=="0" (
			set "d_P_Count2=0"
			set "d_P_Count=No"
			set "d_P_Pass="
			) else (
			set /a "d_P_Count2=%%~_-1"
			set /a "d_P_Pass=%%~_-1"
			set "d_P_Count=0"
			if "!d_P_Pass!"=="0" (set "d_P_Pass=") else set "d_P_Pass=skip=!d_P_Pass!"
			)
		call:Database_Print_Run "%~1" "%~2" "%~3" "%~5"
	) else (
		for /f "tokens=1,2 delims=-" %%: in ("%%~_") do (
			if "%%~:"=="%%~;" (
				set "d_P_Count2=%%~:-1"
				set /a "d_P_Pass=%%~:-1"
				set "d_P_Count=0"
				) else call:Database_Print2 "%%~:" "%%~;"
			if "!d_P_Pass!"=="0" (set "d_P_Pass=") else set "d_P_Pass=skip=!d_P_Pass!"
			call:Database_Print_Run "%~1" "%~2" "%~3" "%~5"
		)
	)
)
exit/b 0


REM call:Database_Print_Run "�ļ�" "������ȡ�ָ���" "���ݴ�ӡ�ָ���" "�к�"
:Database_Print_Run
set "d_P_Count3="
(
	for /f "usebackq %d_P_Pass% eol=^ tokens=%~4 delims=%~2" %%? in ("%~1") do (
		set /a "d_P_Count3+=1"
		set /a "d_P_Count2+=1"
		
		if not defined d_P_AlreadyLineNumber!d_P_Count2! (
			set "d_P_AlreadyLineNumber!d_P_Count2!=Yes"
			set /a "d_P_Count4+=1"
			
			if defined d_P_LineNumber set "d_P_LineNumber=!d_P_Count4!.%~3"
			for /f "eol=^ delims=%%" %%^> in ("!d_P_LineNumber!%%?%~3%%@%~3%%A%~3%%B%~3%%C%~3%%D%~3%%E%~3%%F%~3%%G%~3%%H%~3%%I%~3%%J%~3%%K%~3%%L%~3%%M%~3%%N%~3%%O%~3%%P%~3%%Q%~3%%R%~3%%S%~3%%T%~3%%U%~3%%V%~3%%W%~3%%X%~3%%Y%~3%%Z%~3%%[%~3%%\%~3%%]") do set d_P_ValueTemp=%%^>
			if "!d_P_ValueTemp:~-1!"=="%~3" (echo=%d_P_PrintHead%!d_P_ValueTemp:~0,-1!%d_P_PrintFoot%) else echo=%d_P_PrintHead%!d_P_ValueTemp!%d_P_PrintFoot%
		)
		if /i not "%d_P_Count%"=="No" (
			if "%d_P_Count%"=="0" exit/b 0
			if "!d_P_Count3!"=="%d_P_Count%" exit/b 0
		)
	)
)%d_P_File:~1,1%%d_P_File:~2,-1%

exit/b 0

REM ��������Ƕ�����ԭ���µ����ⲻ�ò�д��һ���ӳ�������ж�
REM call:Database_Print2 ��һ��ֵ �ڶ���ֵ
:Database_Print2
if %~10 gtr %~20 (
	set /a "d_P_Count2=%~2-1"
	set /a "d_P_Pass=%~2-1"
	set /a "d_P_Count=%~1-%~2+1"
) else (
	set /a "d_P_Count2=%~1-1"
	set /a "d_P_Pass=%~1-1"
	set /a "d_P_Count=%~2-%~1+1"
)
exit/b


:---------------------Database_Insert---------------------:


REM �������ݵ�ָ���ı����ݿ��ļ���
REM call:Database_Insert [/Q(����ģʽ������ʾ����)] "����Դ" [/LN [���뵽��λ��(Ĭ�ϵײ�׷��)]] "�����зָ���" "����1" "����2" "����3" "..."
REM ���ӣ�������"data1" "data2" "data3" �� "	"Ϊ�ָ������뵽�ı����ݿ��ļ�" "c:\users\a\Database.ini"
REM					call:Database_Insert "c:\users\a\Database.ini" "	" "data1" "data2" "data3"
REM ����ֵ���飺0-����������1-���޴��У�2-�����������ӳ���
REM ע�⣺����ֵ���ֻ֧�ֵ�31�У��Ƽ��ڴ������ݵ�ʱ��ʹ���Ʊ��"	"Ϊ�ָ������Է��������ݺͷָ�������,�ı����ݿ��в�Ҫ���п��кͿ�ֵ����ֹ�������ݴ���
REM �汾:20160507
:Database_Insert
REM ����ӳ������л����������
for %%A in (d_I_ErrorPrint d_I_LineNumber d_I_Value) do set "%%A="
if /i "%~1"=="/q" (
	shift/1
) else set "d_I_ErrorPrint=Yes"

if "%~2"=="" (
	if defined d_I_ErrorPrint echo=	[����%0:����3-ָ���ָ���Ϊ��]
	exit/b 2
)
if /i "%~2"=="/LN" if "%~3"=="" (
	if defined d_I_ErrorPrint echo=	[����%0:����3-ָ�������к�Ϊ��]
	exit/b 2
) else (
	set "d_I_LineNumber=%~3"
	shift/2
	shift/2
)
if defined d_I_LineNumber if %d_I_LineNumber%0 lss 10 (
	if defined d_I_ErrorPrint echo=	[����%0:����3-ָ�������к�С��1]
	exit/b 2
)
if "%~3"=="" (
	if defined d_I_ErrorPrint echo=	[����%0:����3-ָ��д������Ϊ��]
	exit/b 2
)
if "%~2"=="" (
	if defined d_I_ErrorPrint echo=	[����%0:����2-ָ���ָ���Ϊ��]
	exit/b 2
)
if "%~1"=="" (
	if defined d_I_ErrorPrint echo=	[����%0:����1-ָ������Դ�ļ�Ϊ��]
	exit/b 2
) else if not exist "%~1" (
	if defined d_I_ErrorPrint echo=	[����%0:����1-ָ������Դ�ļ�������:%~1]
	exit/b 2
)

REM ��ʼ������
for %%_ in (d_I_Count d_I_Pass1 d_I_Temp_File) do set "%%_="
for /l %%_ in (1,1,31) do set "d_I_Value%%_="
if defined d_I_LineNumber (
	set "d_I_Temp_File=%~1_Temp"
	if exist "%d_I_Temp_File%" del /f /q "%d_I_Temp_File%"
)

REM �ӳ���ʼ����
REM ��ȡ�û�ָ��ֵ
:Database_Insert1
set /a "d_I_Count+=1"
set "d_I_Value%d_I_Count%=%~3"
if not "%~4"=="" (
	shift/3
	goto Database_Insert1
)
for /l %%_ in (1,1,%d_I_Count%) do (
	set "d_I_Value=!d_I_Value!%~2!d_I_Value%%_!"
)
set "d_I_Value=%d_I_Value:~1%"
REM δָ�������к����
if not defined d_I_LineNumber call:Database_Insert_Echo d_I_Value>>"%~1"&exit/b 0
REM ָ�������к����
REM ���������Ƿ����
set /a "d_I_Pass1=%d_I_LineNumber%-1"
if "%d_I_Pass1%"=="0" (set "d_I_Pass1=") else set "d_I_Pass1=skip=%d_I_Pass1%"
for /f "usebackq %d_I_Pass1% eol=^ delims=" %%? in ("%~1") do goto Database_Insert2
if defined d_I_ErrorPrint echo=	[����%0:���:���޴���:%d_I_LineNumber%]
exit/b 1
:Database_Insert2
set "d_I_Count="
REM ָ����ǰ������д����ʱ�ļ�
set /a "d_I_Count2=%d_I_LineNumber%-1"
if "%d_I_Count2%"=="0" goto Database_Insert3
for /f "usebackq eol=^ delims=" %%? in ("%~1") do (
	set /a "d_I_Count+=1"
	echo=%%?
	if "!d_I_Count!"=="%d_I_Count2%" goto Database_Insert3
)>>"%d_I_Temp_File%"
:Database_Insert3
REM д��������ݵ���ʱ�ļ�
call:Database_Insert_Echo d_I_Value>>"%d_I_Temp_File%"
REM д������к����ݵ���ʱ�ļ�
(
	for /f "usebackq %d_I_Pass1% eol=^ delims=" %%? in ("%~1") do echo=%%?
)>>"%d_I_Temp_File%"
REM ����ʱ�ı����ݿ��ļ�����Դ�ı����ݿ��ļ�
copy "%d_I_Temp_File%" "%~1">nul 2>nul
if not "%errorlevel%"=="0" (
	if defined d_I_ErrorPrint echo=	[����%0:���:���ݸ���ʧ�ܣ�����Ȩ�޲�����ļ�������]
	exit/b 1
)
if exist "%d_I_Temp_File%" del /f /q "%d_I_Temp_File%"
exit/b 0

REM ���ڽ����������ݲ��ܽ�βΪ�ո�+0/1/2/3�Ͳ��ܺ���()����
REM call:Database_Insert_Echo ������
:Database_Insert_Echo
echo=!%~1!
exit/b 0


:---------------------Database_Read---------------------:

REM ��ָ���ļ���ָ���С�ָ���ָ�����ָ���л�ȡ���ݸ�ֵ��ָ������
REM call:Database_Read [/Q(����ģʽ������ʾ����)] "����Դ�ļ�" "�����зָ���" "����������" "�Էָ���Ϊ�ָ��N������(��Ŀ������Ŀ��֮��ʹ��,�ָ�ҿ�������ָ��-)" "������������(�������֮��ʹ�ÿո��,���зָ�)"
REM ���ӣ����ļ� "c:\users\a\Database.ini" �н��� "	" Ϊ�ָ����ĵ�4�����ݵĵ�1,2,3,6�����ݷֱ�ֵ��var1,var2,var3,var4
REM					call:Database_Read "c:\users\a\Database.ini" "	" "4" "1-3,6" "var1 var2 var3 var4"
REM ����ֵ���飺0-����������1-���޴��У�2-�����������ӳ���
REM ע�⣺����ֵ���ֻ֧�ֵ�31�У��Ƽ��ڴ������ݵ�ʱ��ʹ���Ʊ��"	"Ϊ�ָ������Է��������ݺͷָ�������,�ı����ݿ��в�Ҫ���п��кͿ�ֵ����ֹ�������ݴ���
REM �汾:20151127
:Database_Read
REM ����ӳ������л����������
set "d_R_ErrorPrint="
if /i "%~1"=="/q" (shift/1) else set "d_R_ErrorPrint=Yes"
if "%~5"=="" (
	if defined d_R_ErrorPrint echo=	[����%0:����5-ָ������ֵ������Ϊ��]
	exit/b 2
)
if "%~4"=="" (
	if defined d_R_ErrorPrint echo=	[����%0:����4-ָ����Ŀ��Ϊ��]
	exit/b 2
)
if "%~3"=="" (
	if defined d_R_ErrorPrint echo=	[����%0:����3-ָ���к�Ϊ��]
	exit/b 2
)
if %~3 lss 1 (
	if defined d_R_ErrorPrint echo=	[����%0:����3-ָ���к�С��1:%~3]
	exit/b 2
)
if "%~2"=="" (
	if defined d_R_ErrorPrint echo=	[����%0:����2-ָ���ָ���Ϊ��]
	exit/b 2
)
if "%~1"=="" (
	if defined d_R_ErrorPrint echo=	[����%0:����1-ָ������Դ�ļ�Ϊ��]
	exit/b 2
) else if not exist "%~1" (
	if defined d_R_ErrorPrint echo=	[����%0:����1-ָ������Դ�ļ�������:%~1]
	exit/b 2
)

REM ��ʼ������
for %%_ in (d_R_Count d_R_Pass) do set "%%_="
for /l %%_ in (1,1,31) do if defined d_R_Count%%_ set "d_R_Count%%_="
set /a "d_R_Pass=%~3-1"
if "%d_R_Pass%"=="0" (set "d_R_Pass=") else set "d_R_Pass=skip=%d_R_Pass%"

REM �ӳ���ʼ����
for %%_ in (%~5) do (
	set /a "d_R_Count+=1"
	set "d_R_Count!d_R_Count!=%%_"
)
set "d_R_Count="
for /f "usebackq eol=^ %d_R_Pass% tokens=%~4 delims=%~2" %%? in ("%~1") do (
	for %%_ in ("!d_R_Count1!=%%~?","!d_R_Count2!=%%~@","!d_R_Count3!=%%~A","!d_R_Count4!=%%~B","!d_R_Count5!=%%~C","!d_R_Count6!=%%~D","!d_R_Count7!=%%~E","!d_R_Count8!=%%~F","!d_R_Count9!=%%~G","!d_R_Count10!=%%~H","!d_R_Count11!=%%~I","!d_R_Count12!=%%~J","!d_R_Count13!=%%~K","!d_R_Count14!=%%~L","!d_R_Count15!=%%~M","!d_R_Count16!=%%~N","!d_R_Count17!=%%~O","!d_R_Count18!=%%~P","!d_R_Count19!=%%~Q","!d_R_Count20!=%%~R","!d_R_Count21!=%%~S","!d_R_Count22!=%%~T","!d_R_Count23!=%%~U","!d_R_Count24!=%%~V","!d_R_Count25!=%%~W","!d_R_Count26!=%%~X","!d_R_Count27!=%%~Y","!d_R_Count28!=%%~Z","!d_R_Count29!=%%~[","!d_R_Count30!=%%~\","!d_R_Count31!=%%~]") do (
		set /a "d_R_Count+=1"
		if defined d_R_Count!d_R_Count! set %%_
	)
	exit/b 0
)
if not defined d_R_Count if defined d_R_ErrorPrint echo=	[����%0:���-���޴���:%~3]
exit/b 1


:---------------------Database_Sort---------------------:

REM ����������ʹ��ת�Ƶ�ָ����
REM call:Database_Sort [/Q(����ģʽ������ʾ����)] "����Դ" "�������к�" "������к�"
REM ���ӣ����ļ� "c:\users\a\Database.ini" �е���������ԭ�ڶ��е�λ��
REM					call:Database_Sort "c:\users\a\Database.ini" "4" "2"
REM ����ֵ���飺0-����������1-���޴��У�2-�����������ӳ���3-��������ֵ��ͬ
REM �汾:20151204
:Database_Sort
REM ����ӳ������л����������
for %%A in (d_S_ErrorPrint) do set "%%A="
if /i "%~1"=="/q" (
	shift/1
) else set "d_S_ErrorPrint=Yes"
if "%~3"=="" (
	if defined d_S_ErrorPrint echo=	[����%0:����3-ָ�������������Ϊ��]
	exit/b 2
)
if %~3 lss 0 (
	if defined d_S_ErrorPrint echo=	[����%0:����3-ָ�������������С��0:%~2]
)
if "%~2"=="" (
	if defined d_S_ErrorPrint echo=	[����%0:����2-ָ����������Ϊ��]
	exit/b 3
)
if %~2 lss 0 (
	if defined d_S_ErrorPrint echo=	[����%0:����2-ָ����������С��0:%~2]
)
if "%~2"=="%~3" (
	if defined d_S_ErrorPrint echo=	[����%0:����2;����1:�����������������������ͬ����ʵ�����壬���������:%~2:%~3]
	exit/b 1
)
if "%~1"=="" (
	if defined d_S_ErrorPrint echo=	[����%0:����1-ָ������Դ�ļ�Ϊ��]
	exit/b 2
) else if not exist "%~1" (
	if defined d_S_ErrorPrint echo=	[����%0:����1-ָ������Դ�ļ�������:%~1]
	exit/b 2
)

REM ��ʼ������
for %%_ in (d_S_Count d_S_Count2 d_S_Pass1 d_S_Pass2 d_S_Pass3 d_S_Temp_File) do set "%%_="
set "d_S_Temp_File=%~1_Temp"
if exist "%d_S_Temp_File%" del /f /q "%d_S_Temp_File%"


if %~2 lss %~3 (
	REM ǰ������
	set /a "d_S_Count1=%~2-1"
	REM ��ʼ�к󣬽�����ǰ
	set /a "d_S_Pass1=%~2
	set /a "d_S_Count2=%~3-%~2"
	REM ��ʼ������
	set /a "d_S_Pass2=%~2-1"
	set /a "d_S_LineDefinedCheck1=%~2-1"
	REM �����к�(����������)
	set /a "d_S_Pass3=%~3"
	set /a "d_S_LineDefinedCheck2=%~3-1"
) else (
	REM ǰ������
	set /a "d_S_Count1=%~3-1"
	REM ��ʼ������
	set /a "d_S_Pass1=%~2-1"
	set /a "d_S_LineDefinedCheck1=%~2-1"
	REM ������(����������)����ʼ��֮������
	set /a "d_S_Pass2=%~3-1"
	set /a "d_S_Count2=%~2-%~3"
	set /a "d_S_LineDefinedCheck2=%~3-1"
	REM ��ʼ�к�����
	set /a "d_S_Pass3=%~2"
)

for %%_ in (d_S_LineDefinedCheck1 d_S_LineDefinedCheck2 d_S_Pass1 d_S_Pass2 d_S_Pass3) do if "!%%_!"=="0" (set "%%_=") else set "%%_=skip=!%%_!"

REM �ж��Ƿ���ָ��ɾ����
for /f "usebackq eol=^ %d_S_LineDefinedCheck1% delims=" %%? in ("%~1") do goto Database_Sort_2
if defined d_S_ErrorPrint (
	echo=	[����:%0:���:���޴���:%~2]
)
exit/b 1
:Database_Sort_2
for /f "usebackq eol=^ %d_S_LineDefinedCheck2% delims=" %%? in ("%~1") do goto Database_Sort_3
if defined d_S_ErrorPrint (
	echo=	[����:%0:���:���޴���:%~3]
)
:Database_Sort_3

REM �ӳ���ʼ����
REM �ı����ݿ�ǰ������д��
if not "%d_S_Count1%"=="0" for /f "usebackq eol=^ delims=" %%_ in ("%~1") do (
	set /a "d_S_Count+=1"
	echo=%%_
	if "!d_S_Count!"=="!d_S_Count1!" goto Database_Sort1
)>>"%d_S_Temp_File%"

:Database_Sort1
set "d_S_Count="
(
	if %~2 lss %~3 (
		for /f "usebackq %d_S_Pass1% eol=^ delims=" %%_ in ("%~1") do (
			set /a "d_S_Count+=1"
			echo=%%_
			if "!d_S_Count!"=="%d_S_Count2%" goto Database_Sort2
		)
	) else (
		for /f "usebackq %d_S_Pass1% eol=^ delims=" %%_ in ("%~1") do (
			echo=%%_
			goto Database_Sort2
		)
	)
)>>"%d_S_Temp_File%"

:Database_Sort2
set "d_S_Count="
(
	if %~2 lss %~3 (
		for /f "usebackq %d_S_Pass2% eol=^ delims=" %%_ in ("%~1") do (
			echo=%%_
			goto Database_Sort3
		)
	) else (
		for /f "usebackq %d_S_Pass2% eol=^ delims=" %%_ in ("%~1") do (
			set /a "d_S_Count+=1"
			echo=%%_
			if "!d_S_Count!"=="%d_S_Count2%" goto Database_Sort3
		)
	)
)>>"%d_S_Temp_File%"
:Database_Sort3
for /f "usebackq %d_S_Pass3% eol=^ delims=" %%_ in ("%~1") do (
	echo=%%_
)>>"%d_S_Temp_File%"

REM ����ʱ�ı����ݿ��ļ�����Դ�ı����ݿ��ļ�
copy "%d_S_Temp_File%" "%~1">nul 2>nul
if not "%errorlevel%"=="0" (
	if defined d_S_ErrorPrint echo=	[����%0:���:���ݸ���ʧ�ܣ�����Ȩ�޲�����ļ�������]
	exit/b 1
)
if exist "%d_S_Temp_File%" del /f /q "%d_S_Temp_File%"
exit/b 0

:---------------------Database_Update---------------------:


REM �޸�ָ���ļ���ָ������ָ���ָ����ָ��ָ���е�����
REM call:Database_Update [/Q(����ģʽ������ʾ����)] "����Դ" "�����зָ���" "���޸��������ڿ�ʼ�к�" "�Էָ���Ϊ�ָ��N������(�к����к�֮��ʹ��,�ָ�ҿ�������ָ��-)" "���е�һ���޸ĺ�����" "���еڶ����޸ĺ�����" ...
REM ���ӣ����ļ� "c:\users\a\Database.ini" �е�4���� "	" Ϊ�ָ�1,2,3,6�������޸�Ϊ�ֱ��޸�Ϊ string1 string2 string3 string4
REM					call:Database_Update "c:\users\a\Database.ini" "	" "4" "1-3,6" "string1" "string2" "string3" "string4"
REM ����ֵ���飺0-����������1-���޴��У�2-�����������ӳ���
REM ע�⣺����ֵ���ֻ֧�ֵ�31�У��Ƽ��ڴ������ݵ�ʱ��ʹ���Ʊ��"	"Ϊ�ָ������Է��������ݺͷָ�������,�ı����ݿ��в�Ҫ���п��кͿ�ֵ����ֹ�������ݴ���
REM �汾:20151130
:Database_Update
REM ����ӳ������л����������
for %%A in (d_U_ErrorPrint) do set "%%A="
if /i "%~1"=="/q" (
	shift/1
) else set "d_U_ErrorPrint=Yes"
if "%~5"=="" (
	if defined d_U_ErrorPrint echo=	[����%0:����5-ָ���޸ĺ�����Ϊ��]
	exit/b 2
)
if "%~4"=="" (
	if defined d_U_ErrorPrint echo=	[����%0:����4-ָ���к�Ϊ��]
	exit/b 2
)
if "%~3"=="" (
	if defined d_U_ErrorPrint echo=	[����%0:����3-ָ���к�Ϊ��]
	exit/b 2
)
if %~3 lss 1 (
	if defined d_U_ErrorPrint echo=	[����%0:����3-ָ���к�С��1:%~3]
	exit/b 2
)
if "%~2"=="" (
	if defined d_U_ErrorPrint echo=	[����%0:����2-�����зָ���Ϊ��]
	exit/b 2
)
if "%~1"=="" (
	if defined d_U_ErrorPrint echo=	[����%0:����1-ָ������Դ�ļ�Ϊ��]
	exit/b 2
) else if not exist "%~1" (
	if defined d_U_ErrorPrint echo=	[����%0:����1-ָ������Դ�ļ�������:%~1]
	exit/b 2
)
REM ��ʼ������
for %%_ in (d_U_Count d_U_Pass1 d_U_Pass2 d_U_Pass3 d_U_Temp_File d_U_FinalValue d_U_Value) do set "%%_="
for /l %%_ in (1,1,31) do (
	set "d_U_Value%%_="
	set "d_U_FinalValue%%_="
)
set "d_U_Temp_File=%~1_Temp"
if exist "%d_U_Temp_File%" del /f /q "%d_U_Temp_File%"
set /a "d_U_Pass3=%~3"
set /a "d_U_Pass2=%~3-1"
set /a "d_U_Pass1=%~3-1"

set "d_U_Pass3=skip=%d_U_Pass3%"
if "%d_U_Pass2%"=="0" (set "d_U_Pass2=") else set "d_U_Pass2=skip=%d_U_Pass2%"

REM �ж��Ƿ���ָ���޸���
for /f "usebackq eol=^ %d_U_Pass2% delims=" %%? in ("%~1") do goto Database_Updata_2
if defined d_U_ErrorPrint (
	echo=	[����:%0:���:���޴���:%~3]
)
exit/b 1
:Database_Updata_2
if %d_U_Pass1% leq 0 goto Database_Updata2

REM �ӳ���ʼ����
REM �������׶ν����޸ģ����ı����ݿ�Դ�ļ���Ϊ���׶Σ��޸���ǰ������ȡд�룬�޸�����ȡ�޸Ĳ�д�룬�޸��к�������ȡ��д�� �����޸��ı����ݿ�

REM �޸���ǰ������ȡд��׶�
:Database_Updata1

(
	for /f "usebackq eol=^ delims=" %%? in ("%~1") do (
		set /a "d_U_Count+=1"
		echo=%%?
		if "!d_U_Count!"=="%d_U_Pass1%" goto Database_Updata2
	)
)>>"%d_U_Temp_File%"

REM �޸�����ȡ�޸Ĳ�д��׶�
:Database_Updata2
set "d_U_Count="

:Database_Updata2_2
REM ���û�ָ���޸����ݸ�ֵ�����б���
set /a "d_U_Count+=1"
set "d_U_Value%d_U_Count%=%~5"
if not "%~6"=="" (
	shift/5
	goto Database_Updata2_2
)

set "d_U_Count="

REM ���û�ָ���޸����ݸ�ֵ������������λ�����б���
for /f "tokens=%~4 delims=," %%? in ("1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31") do set "d_U_Column=%%? %%@ %%A %%B %%C %%D %%E %%F %%G %%H %%I %%J %%K %%L %%M %%N %%O %%P %%Q %%R %%S %%T %%U %%V %%W %%X %%Y %%Z %%[ %%\ %%]"
for /f "delims=%%" %%a in ("%d_U_Column%") do set "d_U_Column=%%a"
for %%a in (%d_U_Column%) do (
	set /a "d_U_Count+=1"
	call:Database_Updata_Var d_U_FinalValue%%a d_U_Value!d_U_Count!
)

set "d_U_Count="

REM ���ı����ݿ��޸��в����޸ĵ����ݸ�ֵ������������λ�����б���(�Ѿ�����ֵ�����б���������)
for /f "usebackq eol=^ tokens=1-31 %d_U_Pass2% delims=%~2" %%? in ("%~1") do (
	for %%_ in ("%%?" "%%@" "%%A" "%%B" "%%C" "%%D" "%%E" "%%F" "%%G" "%%H" "%%I" "%%J" "%%K" "%%L" "%%M" "%%N" "%%O" "%%P" "%%Q" "%%R" "%%S" "%%T" "%%U" "%%V" "%%W" "%%X" "%%Y" "%%Z" "%%[" "%%\" "%%]") do (
		if "%%~_"=="" goto Database_Updata2_3
		set /a "d_U_Count+=1"
		if not defined d_U_FinalValue!d_U_Count! set "d_U_FinalValue!d_U_Count!=%%~_"
	)
	goto Database_Updata2_3
)
:Database_Updata2_3
if "%d_U_FinalValue1%"=="" (
	if not defined d_U_ErrorPrint echo=	[����%0:���:���޴���]
	exit/b 1
)
REM ���޸ĺ��޸�����ʽд����ʱ�ı����ݿ��ļ�
for /l %%_ in (1,1,%d_U_Count%) do (
	set "d_U_FinalValue=!d_U_FinalValue!%~2!d_U_FinalValue%%_!"
)
set "d_U_FinalValue=%d_U_FinalValue:~1%"
call:Database_Update_Echo d_U_FinalValue>>"%d_U_Temp_File%"

REM �޸��к�������ȡ��д��׶�
:Database_Updata3
(
	for /f "usebackq %d_U_Pass3% eol=^ delims=" %%? in ("%~1") do echo=%%?
)>>"%d_U_Temp_File%"

REM ����ʱ�ı����ݿ��ļ�����Դ�ı����ݿ��ļ����޸����
copy "%d_U_Temp_File%" "%~1">nul 2>nul
if not "%errorlevel%"=="0" (
	if defined d_U_ErrorPrint echo=	[����%0:���:�޸ĺ����ݸ���ʧ�ܣ�����Ȩ�޲�����ļ�������]
	exit/b 1
)
if exist "%d_U_Temp_File%" del /f /q "%d_U_Temp_File%"
exit/b 0

REM ���ڱ������������������ӳ���
:Database_Updata_Var
set "%~1=!%~2!"
exit/b 0
REM ���ڽ����������ݲ��ܽ�βΪ�ո�+0/1/2/3�Ͳ��ܺ���()����
REM call:Database_Update_Echo ������
:Database_Update_Echo
echo=!%~1!
exit/b 0

:---------------------Database_Find---------------------:

REM ��ָ���ļ���ָ���С�ָ���ָ�����ָ���С�ָ���ַ�����������������������к�д�뵽ָ��������
REM call:Database_Find [/Q(����ģʽ������ʾ����)] [/i(�����ִ�Сд)] [/first(���ز��ҵ��ĵ�һ�����)] "����Դ" "�����зָ���"  "�����ַ���" "����������(֧�ֵ����ָ���,�����������ָ���-,0Ϊָ��ȫ����)" "����������(֧�ֵ����ָ���,�����������ָ���-)" "���ҽ���к��кŽ�����ܸ�ֵ������"
	REM ע�⣺-------------------------------------------------------------------------------------------------------------------------------
	REM 	��������������ʽΪ��"�� ��","�� ��","..."���εݼӣ�����ڶ��е����к͵����е����еĸ�ֵ���ݾ�Ϊ��"2 3","5 6"
	REM 	����ʹ�� 'for %%a in (%�������%) do for /f "tokens=1,2" %%b in ("%%~a") do echo=��%%b�У���%%c��' �ķ������н��ʹ��
	REM -------------------------------------------------------------------------------------------------------------------------------------
REM ���ӣ����ļ� "c:\users\a\Database.ini"�е�����������"	"Ϊ�ָ����ĵ�һ���в����ִ�Сд�Ĳ����ַ���data(��ȫƥ��)����������������кŸ�ֵ������result
REM					call:Database_Find /i "c:\users\a\Database.ini" "	" "data" "3-5" "1" "result"
REM ����ֵ���飺0-����ָ���ַ����ҵ�������Ѹ�ֵ������1-δ���ҵ������2-�����������ӳ���
REM ע�⣺����ֵ���ֻ֧�ֵ�31�У��Ƽ��ڴ������ݵ�ʱ��ʹ���Ʊ��"	"Ϊ�ָ������Է��������ݺͷָ�������,�ı����ݿ��в�Ҫ���п��кͿ�ֵ����ֹ�������ݴ���
REM �汾:20160625
:Database_Find
REM ����ӳ������л����������
for %%A in (d_F_ErrorPrint d_F_Insensitive d_F_FindFirst) do set "%%A="
if /i "%~1"=="/i" (
	set "d_F_Insensitive=/i"
	shift/1
) else if /i "%~1"=="/q" (shift/1) else set "d_F_ErrorPrint=Yes"
if /i "%~1"=="/i" (
	set "d_F_Insensitive=/i"
	shift/1
) else if /i "%~1"=="/q" (shift/1) else set "d_F_ErrorPrint=Yes"

if /i "%~1"=="/first" (
	set d_F_FindFirst=Yes
	shift/1
)

if "%~6"=="" (
	if defined d_F_ErrorPrint echo=	[����%0:����6-ָ�����ܽ��������Ϊ��]
	exit/b 2
)
if "%~5"=="" (
	if defined d_F_ErrorPrint echo=	[����%0:����5-ָ�������к�Ϊ��]
	exit/b 2
)
if "%~4"=="" (
	if defined d_F_ErrorPrint echo=	[����%0:����4-ָ�������к�Ϊ��]
	exit/b 2
)
if "%~3"=="" (
	if defined d_F_ErrorPrint echo=	[����%0:����3-ָ�������ַ���Ϊ��]
	exit/b 2
)
if "%~2"=="" (
	if defined d_F_ErrorPrint echo=	[����%0:����2-ָ�������зָ���Ϊ��]
	exit/b 2
)
if "%~1"=="" (
	if defined d_F_ErrorPrint echo=	[����%0:����1-ָ������Դ�ļ�Ϊ��]
	exit/b 2
) else if not exist "%~1" (
	if defined d_F_ErrorPrint echo=	[����%0:����1-ָ������Դ�ļ�������:%~1]
	exit/b 2
)

REM ��ʼ������
for %%_ in (d_F_Count d_F_StringTest d_F_Count2 d_F_Pass %~6) do set "%%_="
for /f "delims==" %%_ in ('set d_F_AlreadyLineNumber 2^>nul') do set "%%_="
for /f "delims==" %%_ in ('set d_F_Column 2^>nul') do set "%%_="

REM �ӳ���ʼ����
REM �ж��û������к��Ƿ���Ϲ���
set "d_F_StringTest=%~4"
for %%_ in (1,2,3,4,5,6,7,8,9,0,",",-) do if defined d_F_StringTest set "d_F_StringTest=!d_F_StringTest:%%~_=!"
if defined d_F_StringTest (
	if defined d_F_ErrorPrint echo=	[����%0:����4:ָ�������кŲ����Ϲ���:%~4]
	exit/b 2
)

REM ���кŸ�ֵ���б���
for /f "tokens=%~5" %%? in ("1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31") do for /f "delims=%%" %%_ in ("%%? %%@ %%A %%B %%C %%D %%E %%F %%G %%H %%I %%J %%K %%L %%M %%N %%O %%P %%Q %%R %%S %%T %%U %%V %%W %%X %%Y %%Z %%[ %%\ %%]") do for %%: in (%%_) do (
	set /a "d_F_Count+=1"
	set "d_F_Column!d_F_Count!=%%:"
)
set "d_F_Count="
REM �����кŽ��в��ִ������
for %%_ in (%~4) do (
	set "d_F_Pass="
	set "d_F_Pass=%%~_"
	if "!d_F_Pass!"=="!d_F_Pass:-=!" (
		if "%%~_"=="0" (
			set "d_F_Count2=0"
			set "d_F_Count=No"
			set "d_F_Pass="
		) else (
			set /a "d_F_Count2=%%~_-1"
			set /a "d_F_Pass=%%~_-1"
			set "d_F_Count=0"
			if "!d_F_Pass!"=="0" (set "d_F_Pass=") else set "d_F_Pass=skip=!d_F_Pass!"
		)
		call:Database_Find_Run "%~1" "%~2" "%~5" "%~3" "%~6"
		if defined d_F_FindFirst if defined %~6 (
			set "%~6=!%~6:~1!"
			exit/b 0
		)
	) else (
		for /f "tokens=1,2 delims=-" %%: in ("%%~_") do (
			if "%%~:"=="%%~;" (
				set /a "d_F_Count2=%%~:-1"
				set /a "d_F_Pass=%%~:-1"
				set "d_F_Count=0"
			) else call:Database_Find2 "%%~:" "%%~;"
			if "!d_F_Pass!"=="0" (set "d_F_Pass=") else set "d_F_Pass=skip=!d_F_Pass!"
			call:Database_Find_Run "%~1" "%~2" "%~5" "%~3" "%~6"
			if defined d_F_FindFirst if defined %~6 (
				set "%~6=!%~6:~1!"
				exit/b 0
			)
		)
	)
)

if defined %~6 (set "%~6=!%~6:~1!") else (
	if defined d_F_ErrorPrint echo=	[���%0:���ݹؼ���"%~3"δ�ܴ�ָ���ļ��������ҵ����]
	exit/b 1
)
exit/b 0

REM call:Database_Find_Run "�ļ�" "�ָ���" "��" "�����ַ���" "������"
:Database_Find_Run
set "d_F_Count3="
for /f "usebackq %d_F_Pass% eol=^ tokens=%~3 delims=%~2" %%? in ("%~1") do (
	set /a "d_F_Count3+=1"
	set /a "d_F_Count2+=1"
	
	if not defined d_F_AlreadyLineNumber!d_F_Count2! (
		set "d_F_AlreadyLineNumber!d_F_Count2!=Yes"
		
		if "%%?"=="%%~?" (
			if %d_F_Insensitive% "%%?"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column1!"&if defined d_F_FindFirst exit/b
		)
		if "%%@"=="%%~@" (
			if %d_F_Insensitive% "%%@"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column2!"&if defined d_F_FindFirst exit/b
		)
		if "%%A"=="%%~A" (
			if %d_F_Insensitive% "%%A"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column3!"&if defined d_F_FindFirst exit/b
		)
		if "%%B"=="%%~B" (
			if %d_F_Insensitive% "%%B"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column4!"&if defined d_F_FindFirst exit/b
		)
		if "%%C"=="%%~C" (
			if %d_F_Insensitive% "%%C"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column5!"&if defined d_F_FindFirst exit/b
		)
		if "%%D"=="%%~D" (
			if %d_F_Insensitive% "%%D"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column6!"&if defined d_F_FindFirst exit/b
		)
		if "%%E"=="%%~E" (
			if %d_F_Insensitive% "%%E"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column7!"&if defined d_F_FindFirst exit/b
		)
		if "%%F"=="%%~F" (
			if %d_F_Insensitive% "%%F"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column8!"&if defined d_F_FindFirst exit/b
		)
		if "%%G"=="%%~G" (
			if %d_F_Insensitive% "%%G"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column9!"&if defined d_F_FindFirst exit/b
		)
		if "%%H"=="%%~H" (
			if %d_F_Insensitive% "%%H"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column10!"&if defined d_F_FindFirst exit/b
		)
		if "%%I"=="%%~I" (
			if %d_F_Insensitive% "%%I"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column11!"&if defined d_F_FindFirst exit/b
		)
		if "%%J"=="%%~J" (
			if %d_F_Insensitive% "%%J"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column12!"&if defined d_F_FindFirst exit/b
		)
		if "%%K"=="%%~K" (
			if %d_F_Insensitive% "%%K"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column13!"&if defined d_F_FindFirst exit/b
		)
		if "%%L"=="%%~L" (
			if %d_F_Insensitive% "%%L"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column14!"&if defined d_F_FindFirst exit/b
		)
		if "%%M"=="%%~M" (
			if %d_F_Insensitive% "%%M"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column15!"&if defined d_F_FindFirst exit/b
		)
		if "%%N"=="%%~N" (
			if %d_F_Insensitive% "%%N"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column16!"&if defined d_F_FindFirst exit/b
		)
		if "%%O"=="%%~O" (
			if %d_F_Insensitive% "%%O"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column17!"&if defined d_F_FindFirst exit/b
		)
		if "%%P"=="%%~P" (
			if %d_F_Insensitive% "%%P"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column18!"&if defined d_F_FindFirst exit/b
		)
		if "%%Q"=="%%~Q" (
			if %d_F_Insensitive% "%%Q"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column19!"&if defined d_F_FindFirst exit/b
		)
		if "%%R"=="%%~R" (
			if %d_F_Insensitive% "%%R"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column20!"&if defined d_F_FindFirst exit/b
		)
		if "%%S"=="%%~S" (
			if %d_F_Insensitive% "%%S"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column21!"&if defined d_F_FindFirst exit/b
		)
		if "%%T"=="%%~T" (
			if %d_F_Insensitive% "%%T"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column22!"&if defined d_F_FindFirst exit/b
		)
		if "%%U"=="%%~U" (
			if %d_F_Insensitive% "%%U"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column23!"&if defined d_F_FindFirst exit/b
		)
		if "%%V"=="%%~V" (
			if %d_F_Insensitive% "%%V"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column24!"&if defined d_F_FindFirst exit/b
		)
		if "%%W"=="%%~W" (
			if %d_F_Insensitive% "%%W"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column25!"&if defined d_F_FindFirst exit/b
		)
		if "%%X"=="%%~X" (
			if %d_F_Insensitive% "%%X"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column26!"&if defined d_F_FindFirst exit/b
		)
		if "%%Y"=="%%~Y" (
			if %d_F_Insensitive% "%%Y"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column27!"&if defined d_F_FindFirst exit/b
		)
		if "%%Z"=="%%~Z" (
			if %d_F_Insensitive% "%%Z"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column28!"&if defined d_F_FindFirst exit/b
		)
		if "%%["=="%%~[" (
			if %d_F_Insensitive% "%%["=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column29!"&if defined d_F_FindFirst exit/b
		)
		if "%%\"=="%%~\" (
			if %d_F_Insensitive% "%%\"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column30!"&if defined d_F_FindFirst exit/b
		)
		if "%%]"=="%%~]" (
			if %d_F_Insensitive% "%%]"=="%~4" set %~5=!%~5!,"!d_F_Count2! !d_F_Column31!"&if defined d_F_FindFirst exit/b
		)
	)
	if /i not "%d_F_Count%"=="No" (
		if "%d_F_Count%"=="0" exit/b
		if "!d_F_Count3!"=="%d_F_Count%" exit/b
	)
)
exit/b

REM ��������Ƕ�����ԭ���µ����ⲻ�ò�д��һ���ӳ�������ж�
REM call:Database_Find2 ��һ��ֵ �ڶ���ֵ
:Database_Find2
if %~10 gtr %~20 (
	set /a "d_F_Count2=%~2-1"
	set /a "d_F_Pass=%~2-1"
	set /a "d_F_Count=%~1-%~2+1"
) else (
	set /a "d_F_Count2=%~1-1"
	set /a "d_F_Pass=%~1-1"
	set /a "d_F_Count=%~2-%~1+1"
)
exit/b

:---------------------Database_DeleteLine---------------------:

REM ɾ��ָ���ļ�ָ����
REM call:Database_DeleteLine [/Q(����ģʽ������ʾ����)] "����Դ" "��ɾ��������ʼ��" "����ʼ�п�ʼ��������ɾ��������(�������У����µ���β������0)"
REM ���ӣ����ļ� "c:\users\a\Database.ini" �еڶ�������ɾ��
REM					call:Database_DeleteLine "c:\users\a\Database.ini" "2" "2"
REM ����ֵ���飺0-����������1-���޴��У�2-�����������ӳ���
REM �汾:20151130
:Database_DeleteLine
REM ����ӳ������л����������
for %%A in (d_DL_ErrorPrint) do set "%%A="
if /i "%~1"=="/q" (
	shift/1
) else set "d_DL_ErrorPrint=Yes"
if "%~3"=="" (
	if defined d_DL_ErrorPrint echo=	[����%0:����3-ָ��ƫ����Ϊ��]
	exit/b 2
)
if %~3 lss 0 (
	if defined d_DL_ErrorPrint echo=	[����%0:����3-ָ��ƫ����С��0:%~4]
)
if "%~2"=="" (
	if defined d_DL_ErrorPrint echo=	[����%0:����2-ָ����ʼ�к�Ϊ��]
	exit/b 2
)
if %~2 lss 1 (
	if defined d_DL_ErrorPrint echo=	[����%0:����2-ָ����ʼ�к�С��1:%~3]
	exit/b 2
)
if "%~1"=="" (
	if defined d_DL_ErrorPrint echo=	[����%0:����1-ָ������Դ�ļ�Ϊ��]
	exit/b 2
) else if not exist "%~1" (
	if defined d_DL_ErrorPrint echo=	[����%0:����1-ָ������Դ�ļ�������:%~1]
	exit/b 2
)

REM ��ʼ������
for %%_ in (d_DL_Count d_DL_Pass1 d_DL_Pass2 d_DL_Pass3 d_DL_Temp_File) do set "%%_="
set "d_DL_Temp_File=%~1_Temp"
if exist "%d_DL_Temp_File%" del /f /q "%d_DL_Temp_File%"
set /a "d_DL_Pass3=%~2-1"
set /a "d_DL_Pass2=%~2+%~3-1"
set /a "d_DL_Pass1=%~2-1"

if "%d_DL_Pass3%"=="0" (set "d_DL_Pass3=") else set "d_DL_Pass3=skip=%d_DL_Pass3%"
if "%d_DL_Pass2%"=="0" (set "d_DL_Pass2=") else set "d_DL_Pass2=skip=%d_DL_Pass2%"

REM �ж��Ƿ���ָ��ɾ����
for /f "usebackq eol=^ %d_DL_Pass3% delims=" %%? in ("%~1") do goto Database_Updata_2
if defined d_DL_ErrorPrint (
	echo=	[����:%0:���:���޴���:%~3]
)
exit/b 1
:Database_Updata_2
if %d_DL_Pass1% leq 0 goto Database_Updata2
REM �ӳ���ʼ����
REM ��ɾ����ǰ����д�뵽��ʱ�ı����ݿ��ļ�
:Database_Updata1
(
	for /f "usebackq eol=^ delims=" %%? in ("%~1") do (
		set /a "d_DL_Count+=1"
		echo=%%?
		if "!d_DL_Count!"=="%d_DL_Pass1%" goto Database_Updata2
	)
)>>"%d_DL_Temp_File%"

REM ��ɾ���к�����д�뵽��ʱ�ı����ݿ��ļ�
:Database_Updata2
if "%~3"=="0" (
	if "%~2"=="1" (if "a"=="b" echo=�˴����ɿ��ļ�)>>"%d_DL_Temp_File%"
) else (
	for /f "usebackq %d_DL_Pass2% eol=^ delims=" %%? in ("%~1") do echo=%%?
)>>"%d_DL_Temp_File%"

REM ����ʱ�ı����ݿ��ļ�����Դ�ı����ݿ��ļ�
copy "%d_DL_Temp_File%" "%~1">nul 2>nul
if not "%errorlevel%"=="0" (
	if defined d_DL_ErrorPrint echo=	[����%0:���:ɾ�������ݸ���ʧ�ܣ�����Ȩ�޲�����ļ�������]
	exit/b 1
)
if exist "%d_DL_Temp_File%" del /f /q "%d_DL_Temp_File%"
exit/b 0

:-----------------------------------------------------------�ӳ�������ָ���-----------------------------------------------------------:
:end