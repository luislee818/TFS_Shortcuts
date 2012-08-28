@echo off
setlocal
setlocal ENABLEEXTENSIONS

set localPath=C:\Workspace\Staples 2.5
set localPathRoot=C:
set localCheckoutPath=C:\Workspace\Staples 2.5\Main\Source\Navitor.StaplesPPE.Web.Public
set localCheckoutFiles=index.html scripts\main.js scripts\src scripts\tests
set serverDevBranchPath=$/Staples PPE/Main
set devBranch=Main
set intBranch=Integration
set intCheckinComment=Full merge from Dev to Integration
set histStopAfter=10

cd %localPath%
%localPathRoot%

if "%1"=="" goto ShowUsage
if /i "%1"=="var" goto ShowVar
if /i "%1"=="getD" goto GetDev
if /i "%1"=="getI" goto GetInt
if /i "%1"=="co" goto Checkout
if /i "%1"=="stat" goto Status
if /i "%1"=="checkind" goto CheckinDev
if /i "%1"=="checkini" goto CheckinInt
if /i "%1"=="checkinifff" goto CheckinIntForMergeNoprompt
if /i "%1"=="undo" goto Undo
if /i "%1"=="undod" goto UndoDev
if /i "%1"=="undoi" goto UndoInt
if /i "%1"=="diffdg" goto DiffDevGraphic
if /i "%1"=="diffdt" goto DiffDevText
if /i "%1"=="histdg" goto HistDevGraphic
if /i "%1"=="histdt" goto HistDevText
if /i "%1"=="mergedi" goto MergeDevtoInt
if /i "%1"=="diffmergedi" goto DiffMergeDevToInt
goto end

:ShowUsage
	echo usage: t ^<command^>
Rem new line
	echo. 
	echo command list (case insensitive):
	echo var         - Show local variables defined in script
	echo getD        - Get latest version of Dev branch
	echo getI        - Get latest version of Integration branch
	echo co [file]   - Checkout configured files (or passed in file) for edit
	echo stat        - View pending changes
	echo checkinD    - Checkin changes in Dev branch (GUI)
	echo checkinI    - Checkin changes in Integration branch (GUI)
	echo checkinIfff - (After merge) Checkin changes in Integration branch (no prompts)
	echo undo ^<file^> - Undo pending changes in specified file (full path)
	echo undoD       - Undo pending changes in local copy of Dev branch
	echo undoI       - Undo pending changes in local copy of Integration branch
	echo diffDG      - Show diff between working copy and Dev branch (GUI)
	echo diffDT      - Show diff between working copy and Dev branch (Text)
	echo histDG      - Show history of Dev branch (GUI)
	echo histDT      - Show history of Dev branch (Text)
	echo mergeDI     - Merge from Dev to Integration branch
	echo diffmergeDI - Show changesets not been merged from Dev to Integration branch
	goto end

:ShowVar
	echo The following variables are defined in the script
	echo localPath           = %localPath%
	echo localPathRoot       = %localPathRoot%
	echo localCheckoutPath   = %localCheckoutPath%
	echo localCheckoutFiles  = %localCheckoutFiles%
	echo serverDevBranchPath = %serverDevBranchPath%
	echo devBranch           = %devBranch%
	echo intBranch           = %intBranch%
	echo intCheckinComment   = %intCheckinComment%
	echo histStopAfter       = %histStopAfter%

	goto end
:GetDev
	echo Get latest version of %devBranch% to %localPath%
	tf get /recursive %devBranch%
	goto end
:GetInt
	echo Get latest version of %intBranch% to %localPath%
	tf get /recursive %intBranch%
	goto end
:Status
	echo View pending changes
	tf stat
	goto end
:Checkout
	cd %localCheckoutPath%
	%localPathRoot%
	REM "%~2" will remove quotes around %2, need 'setlocal ENABLEEXTENSIONS'
	if "%~2"=="" (
		echo Checkout JS files from %devBranch%
		tf checkout /recursive %localCheckoutFiles%
	) else (
		echo Checkout %2
		tf checkout %2
	)
	goto end
:CheckinDev
	echo Checkin files to %devBranch%
	tf checkin /recursive %devBranch%
	goto end
:CheckinInt
	echo Checkin files to %intBranch%
	tf checkin /comment:"%intCheckinComment%" /recursive %intBranch%
	goto end
:CheckinIntForMergeNoPrompt
	echo Checkin merging changes on %intBranch% without prompt
	tf checkin /comment:"%intCheckinComment%" /recursive %intBranch% /noprompt
	goto end
:Undo
	echo Undo local changes of %2
	tf undo %2 /noprompt
	goto end
:UndoDev
	echo Undo local changes on %devBranch%
	tf undo /recursive %devBranch% /noprompt
	goto end
:UndoInt
	echo Undo local changes on %intBranch%
	tf undo /recursive %intBranch% /noprompt
	goto end
:DiffDevGraphic
	echo Diff between %devBranch% and working copy (graphic)
	tf folderdiff "%serverDevBranchPath%" %devBranch% /recursive
	goto end
:DiffDevText
	echo Diff between %devBranch% and working copy (text)
	tf folderdiff "%serverDevBranchPath%" %devBranch% /recursive /noprompt
	goto end
:HistDevGraphic
	echo History of %devBranch% of last %histStopAfter% commits (graphic)
	tf history /recursive /stopafter:%histStopAfter% %devBranch%
	goto end
:HistDevText
	echo History of %devBranch% of last %histStopAfter% commits (text)
	tf history /recursive /stopafter:%histStopAfter% %devBranch% /noprompt
	goto end
:MergeDevToInt
	echo Merge from %devBranch% to %intBranch%
	tf merge %devBranch% %intBranch% /recursive
	goto end
:DiffMergeDevToInt
	echo (What if) Merge from %devBranch% to %intBranch%
	tf merge /candidate %devBranch% %intBranch% /recursive
	goto end

:end
