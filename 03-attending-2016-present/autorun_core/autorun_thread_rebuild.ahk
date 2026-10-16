﻿﻿﻿#NoEnv



#SingleInstance,force



SetBatchLines,-1



DetectHiddenWindows, On



SetTitleMatchMode,2



coordmode,mouse,screen



#NoTrayIcon



#include <acc>



#include <.netgetcontrol>



#include <risimpax>



#include <portallib>



#include <hotstring>



#include <SystemCursor>



#include <hash>



#include <WinVisible>



;~ #include <ahkmini>



;~ #include <ahkthread>



;~ #include <createscript>



#include <getDllPath>



#include <JoinScript>



#include <RegJump>



#include <UIAutomationServer>



#Include <ComDispatch>



#Include <ComDispTable>



#Include <ComVar>



#Include <SetTimerFn>



#Include <dcm4che>



;~ #include <JSON>



ComObjError(false)



onexit,onexit



if regexmatch(a_scriptdir,"is)(.+?)\\scripts\\Autorun$",match)



	root:=match1, partialMode:=false



else{



	root:=a_scriptdir, partialMode:=true



	gosub copyMainExe



}



;~ #WarnContinuableException,off



sendmode,input



;~ threadIds:=CriticalObject()



;~ updateLibPath()







dllPath:=getDllPath()



,IMPAX_id:=loginId



,IMPAX_pw:=loginPw



,RIS_id:=loginId



,RIS_pw:=loginPw



,IMPAX_title:="IMPAX 6.5.2.114 Radiologist with QC"



,RisName:="陳醫師"



,imageWinToggle:=1



,scrollImageConst:=0



,scrolling:=0,scrollingFreq:=100



;~ ,mouseHooks:=[]



,thisHwnd:=WinExist("Ahk_PID " thisPid:=DllCall("GetCurrentProcessId"))



,mouseDragUtil:=1



,onmessage(0______,"mouseDragUtilInact")



,onmessage(0x1122,"accNoChanged")



,openedWindows:=[]



,hiddenWindows:=[]



,autofocus=1



,breakLineControls:=["txtALL","INDICATION","ALLERGY","HEALTHY_VOLUNTEER","DIAGNOSTIC","SPECIAL_MEDICAL","SYMPTOM"]



;~ ,mouseHook:=SetWindowsHookEx(WH_MOUSE_LL   := 14, RegisterCallback("MouseHook", "Fast"))



,ahkMain:= root "\scripts\Autohotkey\AutoHotkey.exe"







SetTimer,commandArr,-1



gui,+lastfound +toolwindow



winget,guiHWND,id



;~ wingettitle,a,ahk_id %thisHwnd%



;~ wingettitle,b,ahk_id %guiHwnd%



;~ msgbox % a "," b



gui,add,edit,vcommands,



gui,add,button,gterminateUSBprocess,Unmount USB



gui,add,button,gexe yp x+5,Execute



gui,show,autosize,Enter command ...











gosub RisGroup



gosub PacsGroup



gosub RisImpaxRoutine



;~ settimer,impaxContextServer,-1



;~ settimer,UIAutomationServer,-1 



settimer,openAnotherRis,-60000



;~ settimer,openAnotherRisRoutine,-1



SetTimer,impaxError,-1000















gosub closeOtherAHK



gosub createNotifyGui























gosub closeImpaxBridge











;~ setTimer,killUpdate,500



SetTimer,killUpdateThread,-1000



setTimer,noIdle,540000



;~ settimer,autofocus,200



;~ settimer,checkExam,-1







;~ settimer,keepLbuttonDown,1000











;~ settimer,RisHistoryBreakline,-500







sysget,monitorCount,monitorcount



;~ if (monitorcount>1){



	sysget,firstMonitor,monitor,1



	sysget,lastMonitor,monitor,% monitorCount



	;~ settimer,cyclicMonitor,-1



;~ }



monitors:=monitorInfo()







;~ hotstring("(p)(\d{2})(w)","pw",3)



if(!partialMode){



;~ try {



run % ahkMain " " root "\scripts\Radiology\TextHotkey\TextHotkey.ahk"



run % ahkMain " " root "\scripts\Radiology\MouseKeyRemap\capslock_remap_alt.ahk"



run % ahkMain " " root "\scripts\Radiology\RisHelper\AutoNum.ahk"



run % ahkMain " " root "\scripts\Autorun\RazerNaga.ahk"



;~ run % root "\scripts\Radiology\TextHotkey\TextHotkey.exe"



;~ run % root "\scripts\Radiology\MouseKeyRemap\capslock_remap_alt.exe"



;~ run % root "\scripts\Radiology\RisHelper\AutoNum.exe"



;~ run % root "\scripts\Autorun\RazerNaga.exe"



;~ }



}else{



	;~ try{



	for k,v in ["textHotkey.exe", "capslock_remap_alt.exe", "AutoNum.exe", "RazerNaga.exe"]



		run % v



	;~ }



}











;~ winactivate,% "ahk_id " guiHwnd



SetTimer,sciteSession,-1



;~ gui,show,autosize,Enter command ...



;~ Hotstring("i)(\d\d)([a-z][a-z])", "xetf", 3)



gosub impaxContextServer



gosub UIAutomationServer



gosub openAnotherRisRoutine



settimer,cyclicMonitor,500,-1



return







;~ !p:



;~ aaa:=aaa?1:aaa+1



;~ bbb:=[ahkMain " " root "\scripts\Radiology\TextHotkey\TextHotkey.ahk", ahkMain " " root "\scripts\Radiology\MouseKeyRemap\capslock_remap_alt.ahk",  ahkMain " " root "\scripts\Radiology\RisHelper\AutoNum.ahk", ahkMain " " root "\scripts\Autorun\RazerNaga.ahk"]



;~ run % bbb[aaa]



;~ return







copyMainExe:



path:=""



if FileExist(path:=A_ScriptDir "\AutoHotkey.exe"){



}else if FileExist(path:=A_ScriptDir "\" RegExReplace(A_ScriptName, ".ahk", ".exe")){



}



if(path="")



	return



Loop,*,1,1



{



	SplitPath,A_LoopFileLongPath,,fileDir,ext,filenameNoExt



	if InStr(FileExist(A_LoopFileLongPath), "D") && (A_LoopFileLongPath!=A_ScriptDir "\Lib"){



		;~ MsgBox % A_LoopFileLongPath



		FileCreateShortcut,% A_ScriptDir "\Lib",% A_LoopFileLongPath "\Lib.lnk"



	}else if (ext="ahk"){



		



		if RegExMatch(fileDir, "i)lib\\?$") || (A_LoopFileName="autorun.ahk")



			continue



		



		;~ MsgBox % filenameNoExt



		if !FileExist(target:=fileDir "\" filenameNoExt ".exe")



			FileCopy,% path,% target,1



		;~ MsgBox % fileDir "\" filenameNoExt ".exe"



	}



}



return







t::



ahkmini("msgbox")



return







closeImpaxBridge:



process,close,AgfaDTIWatchDog.exe



process,close,AgfaDTIBridge.exe



return







impaxError:



IfWinExist,發生錯誤 ahk_exe impax-client-main.exe



{



	WinClose



	Loop {



		Sleep 400



		process,close,impax-client-main.exe



	}until (!ErrorLevel) || (A_Index>10)



	SetTimer,login_impax,-1



}



SetTimer,impaxError,-1000



return







sciteSession:



fileread,sciteSession,% root "\scripts\Autohotkey\SciTE\user\SciTE.session"



newSciteSession:=RegExReplace(sciteSession, "i)path=\w+:", "path=" root)



if(sciteSession!=newSciteSession){



	FileDelete,% root "\scripts\Autohotkey\SciTE\user\SciTE.session"



	FileAppend,% newSciteSession,% root "\scripts\Autohotkey\SciTE\user\SciTE.session",utf-8



}



return







createNotifyGUI:



;~ return ;pauseThread



Loop, 4



{



	Gui, notify%A_Index%: -Caption +ToolWindow +AlwaysOnTOp



	Gui, notify%A_Index%: Color, white



}



return



show:



Critical



if (frame<20){



	settimer,show,off



	settimer,hide,-1



	return



}



cornerX1:=floor(newX-frame/2),cornerY1:=floor(newY-frame/2)



,cornerX2:=floor(newX+frame/2),cornerY2:=floor(newY+frame/2)



Gui, notify1: Show, % "x" cornerX1 " y" cornerY1 " w" frame " h2 NoActivate"



Gui, notify4: Show, % "x" cornerX1 " y" cornerY2 " w" frame " h2 NoActivate"



Gui, notify2: Show, % "x" cornerX1 " y" cornerY1 " w2 h" frame " NoActivate"



Gui, notify3: Show, % "x" cornerX2 " y" cornerY1 " w2 h" frame " NoActivate"



frame:=floor(frame/2)



settimer,show,-50



return



hide:



Critical



loop 4



	gui, notify%a_index%:hide



return



















mouseDragUtilInact(wParam, lParam, msg, hwnd){



	global 



	mouseDragUtil:=0



	mammoAhkHwnd:=hwnd



	settimer,mouseDragUtilAct,5000



	return



}



mouseDragUtilAct:



;~ tooltip % winexist("ahk_id " mammoAhkHwnd)



if winexist("ahk_id " mammoAhkHwnd)



	return



settimer,mouseDragUtilAct,off



mouseDragUtil:=1



mammoAhkHwnd:=0



return



RisGroup:



groupadd,RisGroup,放射線資訊管理系統(Radiology Information System)



groupadd,RisGroup,ahk_exe simpleRIS.exe



return



PacsGroup:



GroupAdd,pacs,ahk_exe impax-client-main.exe



GroupAdd,pacs,ahk_exe WEBVIE~1.exe



return







closeOtherAHK:



;~ return ;pauseThread



for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process where name = 'AutoHotkey.exe' and processID  <> " thisPid )



   winclose,% "ahk_pid " process.ProcessId



winclose,ahk_exe capslock_remap_alt.exe



winclose,ahk_exe textHotkey.exe



winclose,ahk_exe AutoNum.exe



winclose,ahk_exe RazerNaga.exe



return



:?*b0:(::



keywait,9,T1



send ){left}



return



~^9::



keywait,9,T1



send (



return



+bs::



send ^+{right}{bs}



return











*`::



if getkeystate("shift") {



	send ~



	return



}



if getkeystate("ctrl"){



	send ``



	return



}



ifwinactive,ahk_class SciTEWindow



{



	send ``



	return



}



send ^+{left}{bs}



return











cyclicMonitor:



if getkeystate("lbutton") || getkeystate("rbutton") || getkeystate("mbutton")



	return



mousegetpos,x,y



if (x=lastMonitorRight-1){



	mousemove,1,% Floor(y*firstMonitorBottom/lastMonitorBottom),0



	settimer,show,-1



}else if(x=0){



	mousemove,% lastMonitorRight,% Floor(y*lastMonitorBottom/firstMonitorBottom),0



	settimer,show,-1



}



return



~^!z::



if !(a_priorhotkey=a_thishotkey && A_TimeSincePriorHotkey<300)



	return



tooltip,% "Autofocus " ((autofocus:=!autofocus)?"":"de") "activated!"



sleep 1000



tooltip



return



RisImpaxRoutine:



;~ risOld:=impaxOld:=0



;~ risState:=CriticalObject(), ImpaxState:=CriticalObject(), RisChanged:=false



;~ return ;pauseThread







risOld:=risState[2],impaxOld:=impaxState[2,1]



,RisState:=RisOpened(),ImpaxState:=ImpaxOpened()



	



if (!risOld || risOld!=risState[2])



	SetTimer,RisChanged,-1



risOld:=risState[2]







SetTimer,RisImpaxRoutine,-500



;~ SetTimer,RisChanged,500



return







RisChanged:



;~ if(RisChanged){



	;~ ToolTip % RisChanged



	SetTimer,accNoRoutine,-1000



	;~ RisChanged:=false



;~ }



;~ HIMC:=DllCall("Imm32.dll\ImmAssociateContext","UInt", risState[2], "UInt", 0)



return







accNoRoutine:



;~ if !WinExist("ahk_id " risAccHwnd) && !(risAccHwnd:=getRisAccNoHwnd(risState[2]))



	;~ SetTimer,accNoRoutine,-1000



;~ else if (!(pRisAcc)) || (pRisAcc!=(risAcc:=ControlGetText(risAccHwnd))){



	;~ SetTimer,risAccChanged,-1



	;~ pRisAccHwnd:=risAccHwnd



	;~ SetTimer,accNoRoutine,-1000



;~ }



if WinExist("ahk_id " risAccHwnd) || (risAccHwnd:=getRisAccNoHwnd(risState[2])) {



	if (!pRisAccHwnd){



		SetTimer,risAccChanged,-500



		cmdUIAutomationServer(risAccHwnd,1,0x1122,0,thisHwnd)



	}else if (pRisAccHwnd!=risAccHwnd){



		cmdUIAutomationServer(risAccHwnd,1,0x1122,0,thisHwnd)



	}



	pRisAccHwnd:=risAccHwnd



}



SetTimer,accNoRoutine,-1000



return







accNoChanged(){



	SetTimer,risAccChanged,-500



}



risAccChanged:



settimer,RisHistoryBreakline,-1



return







;~ e::



;~ ListLines



;~ return







autofocus:



if !autofocus



	return



mousegetpos,x,y,mouseWin



if(priorX<a_screenwidth&&x>a_screenwidth) && !winexist("匯出影像 ahk_class WindowsForms10.Window.8.app.0.2bf8098"){



	winactivate,% "ahk_id " mouseWin



}else if (priorX>a_screenwidth&&x<a_screenwidth) {



	wingetclass,mouseWinClass,ahk_id %mouseWin%



	if instr(mouseWinClass,"WindowsForms10.Window.8.app") && risState[2]!=mouseWin



		return



	if mouseWinClass not in Chrome_WidgetWin_1,AutoHotkeyGUI,#32770,IEFrame,SciTEWindow,MozillaWindowClass,SleipnirMainWindow



	{



		winactivate,% "ahk_id " risState[2]



	}



}



priorX:=x



return



checkActivateImpax:



loop 15 {



	if !winactive("ahk_class WindowsForms10.Window.8.app.0.2bf8098"){



		winactivate,% "ahk_id " reActivate



		break



	}



	sleep 200



}



return



AppsKey:



if ImpaxState[1]!=2



	return



winget,list,list,ahk_class WindowsForms10.Window.8.app.0.2bf8098



loop % list {



	for k,v in getControls(list%a_index%)



	if (instr(v.text,"BMP_SERIES_MODE") && instr(v.classNN,"WindowsForms10.BUTTON.app")) {



		loc:=Acc_Location(acc_objectfromwindow(v.hwnd))



		winget,id,id,A



		mousegetpos,x,y



		mouseclick,l,% loc.x+1,% loc.y+1,1,0



		winactivate,% id



		mousemove,% x,% y,0



		break



	}



}



return



noIdle:



if  RisState[1]!=2



	return



mousegetpos,,,win



if (win=RisState[2])



{



	mousemove,1,0,0,R



	mousemove,-1,0,0,R



}else {



	for k,v in risControls:=GetControls(RisState[2])



	if instr(v.ClassNN,"WindowsForms10.SysTreeView32") {



		controlsend,,{space},% "ahk_id " v.Hwnd



		break



	}



}



return



KillUpdateThread:



thread,Priority,-1



ifwinexist,Sleipnir ahk_class #32770,Latest version of Sleipnir



	controlclick,Button2,Sleipnir ahk_class #32770,Latest version of Sleipnir



ifwinexist,SciTE4AutoHotkey Updater ahk_class #32770



	controlclick,Button2,SciTE4AutoHotkey Updater ahk_class #32770



ifwinexist,Microsoft Office Activation Wizard ahk_class NUIDialog



	controlsend,NetUIHWND1,{esc},Microsoft Office Activation Wizard ahk_class NUIDialog



ifwinexist,ahk_class #32770,The type initializer for 'HL7.HL7Port' threw an exception.



{



	controlclick,Button1,ahk_class #32770,The type initializer for 'HL7.HL7Port' threw an exception.



	winshow,Sleipnir ahk_class SleipnirMainWindow



}



if winHwnd:=winexist("放射線資訊管理系統(Radiology Information System)","Unhandled exception")



	for k,v in getControls(winHwnd)



		if instr(v.text,"Continue")



			controlclick,,% "ahk_id " v.hwnd



if winHwnd:=winexist("放射線資訊管理系統(Radiology Information System)","未處理的例外狀況")



	for k,v in getControls(winHwnd)



		if instr(v.text,"繼續")



			controlclick,,% "ahk_id " v.hwnd



ifwinexist,Error ahk_class #32770,A problem occurred and the application



	controlclick,Button1,Error ahk_class #32770,A problem occurred and the application



ifwinexist,% "錯誤 ahk_class #32770",% "發生問題，應用程式無法繼續執行"



	controlclick,Button1,錯誤 ahk_class #32770,% "發生問題，應用程式無法繼續執行"



ifwinexist,% "Windows - 沒有磁片"



	controlclick,Button1,% "Windows - 沒有磁片"



ifwinexist,ahk_class #32770,Specifically: vinfoGuiText



	controlclick,Button1



if impaxExport:=winexist("匯出影像 ahk_class WindowsForms10.Window.8.app.0.2bf8098")



	if impaxExportQuality:=getNetControl2(impaxExport,"(1-100)","","","","","","",6)[1]



		if (controlgettext(impaxExportQuality)="90")



			controlsettext,,100,ahk_id %impaxExportQuality%



ifwinexist,kReport ahk_exe Menu.exe,% "已無任何待判讀"



	controlclick,Button1



ifwinexist,ahk_exe Sleipnir.exe,簽章完成



	controlclick,Button1



;~ ifwinexist,% "Internet Explorer Script Error ahk_class Internet Explorer_TridentDlgFrame"



	;~ winclose,% "Internet Explorer Script Error ahk_class Internet Explorer_TridentDlgFrame"



;~ else ifwinexist,% "Internet Explorer 指令碼錯誤 ahk_class Internet Explorer_TridentDlgFrame"



	;~ winclose,% "Internet Explorer 指令碼錯誤 ahk_class Internet Explorer_TridentDlgFrame"



;~ ifwinexist,ahk_class #32770,已有程式執行中,是否確定重複開啟程式



	;~ controlclick,Button3



ifwinexist,,Unhandled exception



	controlclick,&Quit



ifwinexist,ahk_exe DW20.exe,發生問題



	controlclick,Button1



ifwinexist,,是否確定要離開放射線資訊管理



	controlclick,Button1



ifwinexist,,密碼輸入錯誤



	controlclick,Button1



ifwinexist,kReport,無符合篩選條件的資料



	winclose



ifwinexist,,查無使用者帳號



	controlclick,Button1



ifwinexist,ahk_exe dwwin.exe,simpleRIS



{



	controlclick,Button1



	sleep 100



	if(partialMode)



		run % root "\PacsIE\simpleRIS.exe"



	else



		run % root "\scripts\Radiology\PacsIE\simpleRIS.exe"



}



ifwinexist,simpleRIS.exe ahk_exe WerFault.exe



{



	winclose



	process,close,simpleRIS.exe



	if(partialMode)



		run % root "\PacsIE\simpleRIS.exe"



	else



		run % root "\scripts\Radiology\PacsIE\simpleRIS.exe"



}



ifwinexist,ahk_exe ContextServer.exe,HRESULT



	winclose



ifwinexist,ahk_class #32770,% "已有程式執行中,是否確定重複開啟程式"



	controlclick,Button1



IfWinExist,Handle is NULL,buffer



	WinClose



IfWinExist,OpenProcess Failed,Unable



	WinClose



If (dh:=WinExist("Incoming Connection ahk_class MozillaDialogClass")) || (dh1:=WinExist("連入連線 ahk_class MozillaDialogClass")) {



	winactivate,ahk_id %dh%



	ControlClick,x211 y181,ahk_id %dh%



	winactivate,ahk_id %dh1%



	ControlClick,x152 y147,ahk_id %dh1%



}



SetTimer,,-1000



return







lockSub:



if instr(a_thishotkey,"enter") {



	guicontrol,lock:,unlockPW,% ""



}else{



	mousegetpos,mx,my



	if(mx>a_screenwidth/2 && my>a_screenheight/2){



		gui,lock:submit,nohide



		if(unlockPW=loginPw)



			goto unlock



		++unlockRL



	}else if(mx<a_screenwidth/2 && my<a_screenheight/2){



		++unlockLU



	}else{



		unlockRL:=unlockLU:=0



	}



	ToolTip % "RL: " unlockRL "`nLU: " unlockLU



	if(unlockRL=3 && unlockLU=1){



		goto unlock



	}



}



return







^!k::



lockScreen:



;~ hotkey,^!+z,unlockSub



gui,lock:new







;~ SetTimer,setlockhotkey,-60000



gui,lock: +toolwindow -caption +alwaysontop +hwndlockHwnd



gosub setlockhotkey



gui,lock:color,black



gui,lock:add,edit,% "x" floor(a_screenwidth/4) " y" floor(a_screenheight/2) " w" floor(a_screenwidth/2) " vunlockPW password"



gui,lock:show,% "x0 y0 w" lastMonitorRight " h" lastMonitorBottom,lockscreen



unlockRL:=unlockLU:=0



return







setlockhotkey:



hotkey,ifwinexist,lockscreen ahk_class AutoHotkeyGUI



hotkey,enter,locksub,on



hotkey,numpadenter,locksub,on



hotkey,rbutton,locksub,on



hotkey,!F4,noQuit,on



hotkey,ifwinexist



SetTimer,keepActive,500



return







keepActive:



IfWinNotActive,ahk_id %lockHwnd%



	winactivate,ahk_id %lockHwnd%



return







noQuit:



return







^!+z::



if !(a_priorhotkey=a_thishotkey && a_timesincepriorhotkey<500)



	return 



unlock:



;~ msgbox



gui,lock:destroy



;~ hotkey,^!+z,,off



hotkey,ifwinexist,lockscreen ahk_class AutoHotkeyGUI



hotkey,enter,,off



hotkey,numpadenter,,off



hotkey,rbutton,,off



hotkey,!F4,,off



hotkey,ifwinexist



SetTimer,keepActive,off



ToolTip



return















parse_commands:



gui,1:Default



if !(nosubmit)



	gui,submit,nohide



nosubmit=0



loop,parse,commands,`,



{



	command:=trim(a_loopfield)



	if(!command)



		continue



	if command in rel,reload



		reload



	else if RegExMatch(command, "is)^kill (.+)", match){



		process,close,% match1 . InStr(match1,".exe")?"":".exe"



	}else if RegExMatch(command, "i)^(HKEY|HKCR|HKCU|HKLM|HKU|HKCC)"){



		RegJump(command)



	}else if command in lock



	{



		gosub lockScreen



		



	}



	else if command in pIE



	{



		



		if hwnd:=winexist("ahk_exe PacsIE.exe") {



			sendMessage,0______,,,,ahk_id %hwnd%



			if errorlevel 



				process,close,PacsIE.exe



		}



		;~ run % """" commandArr["pIE"] """ """ substr(commandArr["pIE"],1,-3) "ahk"" " (command="pIEo"?"-offline":"")



		run % """" commandArr["pIE"] """" 



			



	}



	else if(val:=commandArr[command]){



		hasExecuted:=false



		if command in YCH,YXR,CXR,brus,mamm



		{



			if(partialMode){



				if command=YCH



					val:=A_ScriptDir "\YCH_Enh.exe"



				else if command=YXR



					val:=A_ScriptDir "\YCH_XR_Enh.exe"



				else if command=mamm



					val:=A_ScriptDir "\YCH_mammo_Enh.exe"



				



				



			}else{



				RegExMatch(val,"is)Autohotkey.exe (.+)",match)



				if FileExist(SubStr(match1,1,-4) "_Enh.ahk")



					val:=SubStr(val,1,-4) "_Enh.ahk"



				



				try



					run % val



				hasExecuted:=true



				



				process,close,Hotstring Helper.exe



				loop,% root "\scripts\Radiology\Hotstring Helper\*.ahk"



					if !instr(a_loopfilename,"Hotstring")



						filedelete,% a_loopfilelongpath 



				



				fileappend,% joinScript(match1),% root "\scripts\Radiology\Hotstring Helper\" regexreplace(match1,"s).+(\\|\/)",""),utf-8



				;~ filecopy,% match1,% root "\scripts\Radiology\Hotstring Helper",1



				



				try {



				run % root "\scripts\Radiology\Hotstring Helper\Hotstring Helper.exe"



				



				if command=mamm



					run % ahkMain " " root "\scripts\Radiology\mammoMagMove.ahk"



				else if command=brus



					run % ahkMain " " root "\scripts\Radiology\breastUS.ahk"



				else if command=YXR



					run % commandArr["simple"]



				}



				winactivate,% "ahk_id " risstate[2]



				



			}



		}



		



		if !(hasExecuted)



			try {



				run,% val



			}



	}else if (command="rad"){



		;~ loop {



			;~ process,close,Menu.exe



		;~ } until !errorlevel



		work()



	}else if (command="rad1"){



		;~ loop {



			;~ process,close,Menu.exe



		;~ } until !errorlevel



		work(1)



	}else if (command="liu"){



		try {



		if fileexist(A_MyDocuments "\scsnake\XLiu\XLiu.exe")



			run % A_MyDocuments "\scsnake\XLiu\XLiu.exe"



		else if FileExist(root "\software\XLiu\Xliu.exe")



			run % root "\software\XLiu\Xliu.exe"



		else if FileExist(root "\XLiu\Xliu.exe")



			run % root "\XLiu\Xliu.exe"



		}



	}else if (command="slp"){



		gosub run_slp



		settimer,run_slp,3000



	}else if (command="boneage"){



		try {



			run,% root "\scripts\bone_age\boneage report.exe"



		



			IfWinNotExist,Skeletal Development of the Hand and Wrist - A Radiographic Atlas and Digital Bone Age Companion



				run,% root "\R2\PED\Skeletal Development of the Hand and Wrist - A Radiographic Atlas and Digital Bone Age Companion.pdf"



		}



	}else{



		try {



			run % command



		}



		;~ Run %comspec% /c "start ""%command%"""



	}



}



gui,1:Default



guicontrol,,commands,% ""



winactivate,ahk_id %lastActiveWin%



lastActiveWin:=0



return



work(para=0){



	global



	nosubmit=1



	commands:="ych"



	try {



	if (!winexist("ahk_exe firefox.exe")) 



		if fileexist(lnk:=A_Desktop "\FirefoxLogin.lnk") || fileexist(lnk:=A_Desktop "\FirefoxLogin.exe.lnk") 



			run % lnk



		else if fileexist(lnk:=A_ProgramFiles "\Mozilla Firefox\firefox.exe")



			run % lnk



		else if fileexist(lnk:=A_MyDocuments "\Mozilla Firefox\firefox.exe")



			run % lnk



		



		



	}



	settimer,parse_commands,-1



	;~ gosub run_slp



	;~ settimer,run_slp,3000



	alternativeLogin:=!!para



	settimer,~^!l,-500



	



}



#ifwinactive,Enter command ...



exe:



~NumpadEnter::



~Enter::



gosub parse_commands



guicontrol,focus,commands



return



~esc::



guicontrol,,commands,% ""



return



#IfWinActive



#ifwinactive,報告



~esc::



;~ winget,activeWin,hwnd,A



WinGetClass,winClass,A



if !instr(winClass,"WindowsForms10.Window.8.app")



	return



winclose,A



winactivate,% "ahk_id " risState[2]



return



#IfWinActive



~rbutton::



if !(a_thishotkey=a_priorhotkey && A_TimeSincePriorHotkey<300 && GetKeyState("RButton","P")) {



	return



}



mousemove,-1,-1,0,R



mousegetpos,,,activeWin



wingetTitle,activeWinTitle,% "ahk_id " activeWin



keywait,rbutton



if (instr(activeWinTitle,"放射線資訊管理系統(Radiology Information System)") || instr(activeWinTitle,"DisplayMenuForm")) {



	mouseclick,l,-2,-2,1,0,,r



	mouseclick,r,2,2,1,0,,r



	sleep 100



	mouseclick,l,5,5,1,0,,r



}



return



#ifwinactive,ahk_class #32770



~esc::



winclose,A



return



#ifwinactive











#1::



#2::



#3::



#4::



ahkArr:=["ych","yxr","mamm","bmd"]



guicontrol,,commands,% ahkArr[substr(a_thishotkey,2,1)+0]



gosub parse_commands



Sleep 1000



run % partialMode?root "\capslock_remap_alt.exe":ahkMain " " root "\scripts\Radiology\MouseKeyRemap\capslock_remap_alt.ahk"



return











renewRisReports:



if !(isobject(risReports) && controlexist(RisReports[1,1]))



	RisReports:=getRisReports(RisState[2])



return







~esc::



UnhookWindowsHookEx(hHookMouse)



return



;~ #ifwinactive,ahk_class WindowsForms10.Window.8.app.0.2bf8098











F10::



mousegetpos,,,win



winget,pName,processname,ahk_id %win%



if instr(pName,"impax")



	goto chestModule



else



	send {f10}



return







#ifwinactive,ahk_group pacs







;~ ~wheeldown::



;~ ~wheelup::



;~ scrollSeriesList:



;~ if GetKeyState("Rbutton"){



	;~ seriesList:=getSeriesList()



	;~ ,which:=seriesList.maxindex()>1?whichMonitor("","",monitorInfo).1-1:1



	;~ winactivate,% "ahk_id " seriesList[which].1



	;~ ControlFocus,,% "ahk_id " seriesList[which].2



	;~ send % "{" RegExReplace(A_ThisHotkey,"\W*","") "}"



;~ }



;~ return











focusImpression:



#space::



checkRis(RisState)



gosub renewRisReports



controlfocus,,% "ahk_id " RisReports[1,2]



winactivate,% "ahk_id " RisState[2]



controlfocus,,% "ahk_id " RisReports[1,2]



return







chestModule:



F10::



if (seriesX1 && seriesY1){



	mousegetpos,seriesX2,seriesY2



	



	impaxFrames:=getViewFrame(impaxState[2])



	controlgetpos,xx,yy,ww,hh,,% "ahk_id " impaxFrames[1,1,1]



	controlgetpos,xx2,yy2,ww2,hh2,,% "ahk_id " impaxFrames[2,1,1]



	xx+=firstMonitorRight-firstMonitorLeft



	mousemove,% xx+ww/2,% yy+hh/2,0



	click,2



	sleep 300



	



	mousemove,% seriesX1,% seriesY1,0



	send {lbutton down}



	sleep 100



	mousemove,% xx+ww/2,% yy+hh/4,2



	send {lbutton up}



	



	xx2+=firstMonitorRight-firstMonitorLeft



	mousemove,% seriesX2,% seriesY2,0



	send {lbutton down}



	sleep 100



	mousemove,% xx2+ww2/16,% yy2+hh2/4,2



	send {lbutton up}



	sleep 100



	send {F6}



	sleep 100



	send h







	gosub showSeriesList



	



	mousemove,% xx+ww/2,% yy,0



	send {F6}



	sleep 100



	send h



	



	seriesX1:=seriesY1:=seriesX2:=seriesY2:=0







}else{



	mousegetpos,seriesX1,seriesY1



}



return







setontop:



if(A_TickCount-setontoptick)<500



	goto setontopreturn



;~ simpleRis:=winexist("simple RIS ahk_class AutoHotkeyGUI")



IfWinNotActive,ahk_group pacs



	DllCall("SetWindowPos", "UINT", simpleRis, "UINT", 0, "INT", 0, "INT", 0, "INT", 0, "INT", 0, "UINT", 0x0013)



	,DllCall("SetWindowPos", "UINT", simpleRis, "UINT", -1, "INT", 0, "INT", 0, "INT", 0, "INT", 0, "UINT", 0x0013)



	;~ ,DllCall("SetWindowPos", "UINT", impaxOpened()[2,1], "UINT", guihwnd, "INT", 0, "INT", 0, "INT", 0, "INT", 0, "UINT", 0x0013)



	;~ settimer,setNotOnTop,-1000







setontopreturn:



setontoptick:=A_TickCount



return







focusRisReport:



~capslock up::



keywait,capslock,t1



checkRis(RisState)



if !(simpleRis:=winexist("simple RIS ahk_class AutoHotkeyGUI")) && RisState[1]!=2 



	return



if (simpleRis){



	;~ winactivate,% "ahk_id " risstate[2]



	;~ winset,alwaysontop,on,ahk_id %simpleRIS%



	settimer,setOnTop,-1



	winactivate,ahk_id %simpleRis%



	winwaitactive,,,1



	controlfocus,Scintilla1,ahk_id %simpleRis%



	;~ controlfocus,Scintilla1,ahk_id %simpleRis%



	if(winexist("ahk_exe PacsIE.exe")){



		winget,nextProcName,ProcessName,% "ahk_id " GetNextWindow(simpleRis)



		if(nextProcName!="PacsIE.exe") {



			SendMessage,0______,,,,ahk_exe PacsIE.exe



			winactivate,ahk_id %simpleRis%



			winwaitactive,,,1



			;~ controlfocus,Scintilla1,ahk_id %simpleRis%



			controlfocus,Scintilla1,ahk_id %simpleRis%



	



		}



	}



}else{



	winactivate,% "ahk_id " risstate[2]



	focused:=getFocused()



	gosub renewRisReports



	;~ risReports:=getRisReports(risstate[2])



	if (focused!=risReports[1,1] && focused!=risReports[1,2])



		controlfocus,,% "ahk_id " risReports[1,1]



}



return















~1::



~2::



~3::



~4::



;~ SendLevel,2



;~ leftDown:=getkeystate("Lbutton")



;~ mousegetpos,x,y



focused:=getFocused()



WinGetClass,focusedClass,ahk_id %focused%



if RegExMatch(focusedClass, "i)edit|text")



	return



RegExMatch(a_thishotkey, "\d+", key)



whichMonitor:=monitors[key=4?3:key]



;~ msgbox % whichMonitor.l



;~ t:=(A_OSVersion="WIN_XP")?100:400



if(key>1){



	;~ send {lbutton}



	;~ Sleep 100



	send {lbutton down}



	MouseMove,10,0,2,r



	Sleep 100



}



;~ if(whichMonitor=1 && )







;~ else



	mousemove,% newX:=(whichMonitor.l)+100,% newY:=floor((whichMonitor.h)/2),0



;~ if(leftDown){



	;~ sleep 100



	;~ send [lbutton up}



	;~ sleep 100



	;~ mousemove,% x,% y,0



;~ }else{



mousemove,10,0,2,r



sleep 100



if(key>1){



	send {lbutton up}



	sleep 100



}



if(key=4){



	settimer,toggleSeriesList,-1



	mousemove,% newX:=monitors.2.r-100,% newY:=floor((whichMonitor.h)/2),0



	mousemove,10,0,1,r



	;~ SetTimer,lungWindow,-1



	Sleep 500



	send {F6}



	sleep 100



	send h



}else{



	SetTimer,toggleSeriesList,-1000



}



frame:=400



settimer,show,-1



;~ }



return















keepLbuttonDown:



;~ tooltip % getkeystate("lbutton","P") "," lbuttondown



;~ if getkeystate("lbutton","P") || lbuttonDown



	;~ return



;~ send {lbutton down}



;~ lbuttonDown:=1



;~ tooltip , down



return







;~ lbutton up::



;~ send {lbutton down}



;~ return







;~ lbutton::



;~ send {lbutton up}



;~ return







scrolling:



send % scrolling>0?"{WheelDown}":"{WheelUp}"



settimer,scrolling,% (-1)*scrollingFreq



return











;~ ~PgDn::



;~ if (scrolling=-1){



	;~ settimer,scrolling,off



	;~ scrolling:=0



;~ }



;~ if !(a_thishotkey=a_priorhotkey && A_TimeSincePriorHotkey<500)



	;~ return



ScrollLock:: 



send {lbutton down}



;~ impaxMouseHook:=true



UnhookWindowsHookEx(mouseHook)



mouseHook:=SetWindowsHookEx(WH_MOUSE_LL   := 14, RegisterCallback("MouseHook", "Fast"))



;~ scrolling:=1



;~ settimer,scrolling,% (-1)*scrollingFreq



return











;~ ~PgUp::



;~ if (scrolling=1){



	;~ settimer,scrolling,off



	;~ scrolling:=0



;~ }



;~ if !(a_thishotkey=a_priorhotkey && A_TimeSincePriorHotkey<500)



	;~ return



;~ send {lbutton up}



;~ scrolling:=-1



;~ settimer,scrolling,% (-1)*scrollingFreq



;~ return







;~ ~wheelup::



;~ ~wheeldown::



;~ if scrolling=0



	;~ return



;~ scrollingFreq:=floor(scrollingFreq*(instr(a_thishotkey,"up")?(1/1.2):1.2))



;~ return



















;~ LButton & RButton::



;~ if RisState[1]!=2



	;~ return



;~ winactivate,% "ahk_id " risstate[2]



;~ return







;~ ~F2::



;~ ~F4::



;~ ~F5::



;~ ~F7::



;~ ~F8::



;~ gosub applyOtherStudy



return







F3::



send {F3}



sleep 100



send h



;~ SetTimer,toggleSeriesList,-1000



;~ gosub applyOtherStudy



return



lungWindow:



F6::



send {f6}



sleep 100



send h



;~ SetTimer,toggleSeriesList,-1000



;~ gosub applyOtherStudy



return







~F2::



;~ ~F3::



~F4::



~F5::



;~ ~F6::



~F7::



~F8::



;~ SetTimer,toggleSeriesList,-1000



return











toggleSeriesList:



toggleSeriesList(ImpaxState,"off","all",monitorInfo)



return







applyOtherStudy:



if getkeystate("Rbutton")



	return



RegExMatch(a_thishotkey,"i)F\d+",key)



if monitors.maxIndex()<3



	return



impaxAccNo1:=getImpaxAccNo(impaxState[2,1],1)



impaxAccNo2:=getImpaxAccNo(impaxState[2,1],0)



if(impaxAccNo1 = impaxAccNo2)



	return



mousegetpos,mx,my



mousemove,% 2*mx-monitors.2.r,% my,0



sleep 100



send {%key%}



if(key="F3" || key="F8"){



	sleep 100



	send h 



}



return











;~ detectLbuttonUp:



;~ if !GetKeyState("Lbutton") {



	;~ SetTimer,_lbuttonup,-500



	;~ SetTimer,detectLbuttonUp,Off



;~ }



;~ return







_lbuttonup:



~lbutton up::



;~ for k,v in mouseHooks



	;~ UnhookWindowsHookEx(v)



;~ impaxMouseHook:=false



UnhookWindowsHookEx(mouseHook)



MouseGetPos,mx,my,win



WinGetTitle,t,ahk_id %win%



;~ SetTimerF("dragGuiFinish",-1, [t, originalMouse])



if(dragGUIs.maxindex()){



	dragFinishFn:=Func("dragGuiFinish").bind(t, originalMouse, mx, my, win)



	settimer,% dragFinishFn,-1



}



;~ SystemCursor("On")



;~ settimer,hidecursor,off



lbuttonDown:=0



return



~lbutton::	



mousegetpos,mx,my,mouseWin,mouseControl



WinGetClass,mouseWinClass,ahk_id %mouseWin%



if(mouseWinClass="#32770" && mouseControl="SysListView321"){



	SetTimerFn("lbuttonStay",-200, [mx, my])



}



if !mouseDragUtil



	return



KeyWait, LButton, T0.1



if (errorlevel && regexmatch(mouseControl,"AfxWnd90u\d")) {



	UnhookWindowsHookEx(mouseHook)



	,mouseHook:=SetWindowsHookEx(WH_MOUSE_LL   := 14, RegisterCallback("MouseHook", "Fast"))



	;~ impaxMouseHook:=true



	;~ SetTimer,detectLbuttonUp,500



	;~ settimer,hideCursor,100



} else {



	UnhookWindowsHookEx(mouseHook)



	;~ for k,v in mouseHooks



		;~ UnhookWindowsHookEx(v)



	;~ impaxMouseHook:=false



	;~ mouseHooks:=[]



	;~ SystemCursor("On")



	;~ settimer,hideCursor,off



}



return







lbuttonStay(mx, my){



	global originalMouse



	if GetKeyState("Lbutton") {



		MouseGetPos,x,y,,mouseControlId,2



		if(x=mx && y=my){



			if(ControlGetText(mouseControlId)="List1"){



				originalMouse:={x:mx,y:my}



				gosub createSeriesDragGUI



			}



		}



	}







}







createSeriesDragGUI:



Thread, NoTimers



dragGUIs:=[]



,viewFrame:=getViewFrame(ImpaxState[2]), dimension:=[], w:=h:=0







,guiX:=mx+10, winStack:=[], dragWBs:=[]



Loop 



	if (viewFrame[dragGuiInd:=A_Index,1]!=""){



		gui,dragGUI%dragGuiInd%:New



		gui,+hwnddragGUIhwnd +ToolWindow -Border -Caption +AlwaysOnTop 



		gui,Color,black



		dragGUIs.push(dragGUIhwnd), winStack.push(dragGUIhwnd)



		winset,AlwaysOnTop,on,ahk_id %dragGUIhwnd%



		w:=(xCount:=viewFrame[dragGuiInd, 1].maxindex())*100



		,h:=(yCount:=viewFrame[dragGuiInd].maxindex())*100



		;~ w:=h:=200



		;~ ToolTip % ++iii



		gui,Add,ActiveX,% "x0 y0 w" w " h" h " vWBdrag" dragGuiInd, Shell.Explorer



		WBdrag%dragGuiInd%.silent:=true



		,WBdrag%dragGuiInd%.Navigate("about:blank")



		, dragWBs.push(WBdrag%dragGuiInd%)



		,cells:=""



		Loop % yCount {



			cells.="<tr>"



			Loop % xCount {



				cells.="<td></td>"



			}



			cells.="</tr>`n"



		}



		while (WBdrag%dragGuiInd%.busy)



			Sleep 10



		html=



		(LTrim



		<head>



		<style type="text/css">



		* {



			background-color: black;



		}



		body {



			overflow: hidden;



		}



		table {



			border-collapse: collapse; 



			left: 0; top: 0; position: absolute; 



			table-layout: fixed;



		}



		td {



			border: 1px white solid; 



			width: 100px; height: 100px; 



		}



		td:hover {



			background-color: gray;



		}



		</style>



		<script type="text/javascript">



		</script></head>



		<body>



		<table>



		%cells%



		</table></body>



		)



		WBdrag%dragGuiInd%.document.open()



		,WBdrag%dragGuiInd%.document.write(html)



		,WBdrag%dragGuiInd%.document.close()



		;~ MsgBox % guiX



		gui,show,% "x" guiX " y" my+10 " w" w " h" h, % "dragGUI" dragGuiInd



		guiX+=w+10



	}else 



		break



WinStack(winStack.push(mouesWin))



Thread, NoTimers,off



hoverFn:=Func("hoverDragGUI")



SetTimer,% hoverFn, -400



SetTimer,DestroyDragGUI,-10000



return







hoverDragGUI(){



	Critical



	global dragWBs, hoverFn



	static prevCell



	MouseGetPos,mx,my,win



	WinGetTitle,t,ahk_id %win%



	if RegExMatch(t, "dragGUI(\d+)", match){



		WinGetPos,wx,wy,,,ahk_id %win%



		targetX:=Floor((mx-wx)/100)+1



		,targetY:=Floor((my-wy)/100)+1



		try



			prevCell.style.backgroundColor:="black"



		;~ ToolTip % targetX "," targetY



		(prevCell:=dragWBs[match1+0].document.getElementsByTagName("table")[0].rows[targetY-1].cells[targetX-1]).style.backgroundColor:="grey"



	}



	settimer,% hoverFn, -400



}







DestroyDragGUI:



for k,v in dragGUIs



	gui,dragGUI%k%:Destroy



Settimer,% hoverFn, off



dragGUIs:=[]



return



dragGuiFinish(t, originalMouse, mx, my, win){



	global hoverFn, viewFrame



	Settimer,% hoverFn, off



	if RegExMatch(t, "dragGUI(\d+)", match){



		WinGetPos,wx,wy,,,ahk_id %win%



		targetX:=Floor((mx-wx)/100)+1



		,targetY:=Floor((my-wy)/100)+1



		



		gosub DestroyDragGUI



		wingetpos,x,y,w,h,% "ahk_id " viewFrame[match1+0, targetY, targetX]



		mousemove,% originalMouse.x, % originalMouse.y,0



		send {lbutton down}



		MouseMove,10,0,2,r



		Sleep 100



		mousemove,% x+floor(w/4),% y+floor(h/4),0



		mousemove,10,0,2,r



		sleep 100



		send {lbutton up}



		;~ mouseDragSeries(originalMouse, mouseWin, viewFrame[match1+0, targetY, targetX])



		;~ dragSeries(targetX,targetY,originalMouse,match1,seriesListStored,viewFrame)



		SetTimer,toggleSeriesList,-1



	}else{



		SetTimer,DestroyDragGUI,-1



	}



}







MouseHookOld(nCode, wParam, lParam){



	static lx,ly



	global impaxMouseHook, firstMonitorBottom, lastMonitorBottom, lastMonitorRight



	Critical



	if (wParam=0x202){ ;lbutton up



		;~ UnhookWindowsHookEx(hHookMouse)



		impaxMouseHook:=false



		;~ SetTimer,dragGuiFinish,-1



		return CallNextHookEx(nCode, wParam, lParam)



	}else if(wParam=0x200){



		x := NumGet(lParam+0, 0, "Int")



		,y := NumGet(lParam+0, 4, "Int")



		if (x=lastMonitorRight-1){



			if getkeystate("lbutton") || getkeystate("rbutton") || getkeystate("mbutton")



				return CallNextHookEx(nCode, wParam, lParam)



			mousemove,1,% Floor(y*firstMonitorBottom/lastMonitorBottom),0



 		}else if(x=0){



			if getkeystate("lbutton") || getkeystate("rbutton") || getkeystate("mbutton")



				return CallNextHookEx(nCode, wParam, lParam)



			mousemove,% lastMonitorRight,% Floor(y*lastMonitorBottom/firstMonitorBottom),0



		}



		if(impaxMousHook){



	;~ If nCode || !(wParam = 0x200)



	;~ return CallNextHookEx(nCode, wParam, lParam)



			VarSetCapacity(lpPoint,8)



			,DllCall("GetCursorPos", "Uint", &lpPoint)



			,lx := NumGet(lpPoint, 0, "Int")



			,ly := NumGet(lpPoint, 4, "Int")



			,mx := NumGet(lParam+0, 0, "Int")



			,my := NumGet(lParam+0, 4, "Int")



			,mx := lx + (mx-lx)



			,my := ly + (mx-lx) + (my-ly)



			,DllCall("SetCursorPos", "Int", mx, "Int", my)



			,NumPut(mx, lParam+0, 0, "Int")



			,NumPut(my, lParam+0, 4, "Int")



			;~ ,SystemCursor("Off")  ; not work on impax



			return 1



		}



	}



	



	return CallNextHookEx(nCode, wParam, lParam)



}







MouseHook(nCode, wParam, lParam){



	static lx,ly



	global mouseHook



	Critical



	if (wParam=0x202){



		UnhookWindowsHookEx(mouseHook)



		return CallNextHookEx(nCode, wParam, lParam)



	}



	If nCode || !(wParam = 0x200)



		return CallNextHookEx(nCode, wParam, lParam)



	VarSetCapacity(lpPoint,8)



	,DllCall("GetCursorPos", "Uint", &lpPoint)



	,lx := NumGet(lpPoint, 0, "Int")



	,ly := NumGet(lpPoint, 4, "Int")



	,mx := NumGet(lParam+0, 0, "Int")



	,my := NumGet(lParam+0, 4, "Int")



	,mx := lx + (mx-lx)



	,my := ly + (mx-lx) + (my-ly)



	,DllCall("SetCursorPos", "Int", mx, "Int", my)



	,NumPut(mx, lParam+0, 0, "Int")



	,NumPut(my, lParam+0, 4, "Int")



	return 1



}







ClipCursor( Confine=True, x1=0 , y1=0, x2=1, y2=1 ) {



	VarSetCapacity(R,16,0),  NumPut(x1,&R+0),NumPut(y1,&R+4),NumPut(x2,&R+8),NumPut(y2,&R+12)



	Return Confine ? DllCall( "ClipCursor", UInt,&R ) : DllCall( "ClipCursor" )



}



SetWindowsHookEx(idHook, pfn)



{



	Return DllCall("SetWindowsHookEx", "int", idHook, "Uint", pfn, "Uint", DllCall("GetModuleHandle", "Uint", 0), "Uint", 0)



}



CallNextHookEx(nCode, wParam, lParam, hHook = 0)



{



	Return DllCall("CallNextHookEx", "Uint", hHook, "int", nCode, "Uint", wParam, "Uint", lParam)



}



UnhookWindowsHookEx(hHook)



{



	Return DllCall("UnhookWindowsHookEx", "Uint", hHook)



}



mouseGesture:



if (abs(gestureY2-gestureY1)+abs(gestureX2-gestureX1)<20) {



	gestureValue:=0



	return



}



if (gestureX2=gestureX1) {



	gestureValue:=(gestureY2>gestureY1)?4:8



}else if (gestureX2>gestureX1){



	if (slope:=(gestureY2-gestureY1)/(gestureX2-gestureX1))>2.414



		gestureValue:=4



	else if slope>0.414



	gestureValue:=3



	else if slope>-0.414



	gestureValue:=2



	else if slope>-2.414



	gestureValue:=1



	else



	gestureValue:=8



}else if (gestureX2<gestureX1){



	if (slope:=(gestureY2-gestureY1)/(gestureX2-gestureX1))>2.414



		gestureValue:=8



	else if slope>0.414



	gestureValue:=7



	else if slope>-0.414



	gestureValue:=6



	else if slope>-2.414



	gestureValue:=5



	else



	gestureValue:=4



}







if gesturevalue=2



	send {right}



else if gesturevalue=6



	send {left}



else if gesturevalue=8



	send %modifier%{up}



else if gesturevalue=4



	send %modifier%{down}



return







gestureStart:



mbutton::



mousegetpos,gestureX1,gestureY1,mouseWin



WinGetClass,mouseWinClass,ahk_id %mouseWin%



winactivate,ahk_id %mouseWin%



mouseMonInd:=whichMonitor()



modifier:=(whichMonitor[1]=3?"^":"")



return



mbutton up::



mousegetpos,gestureX2,gestureY2



gosub mouseGesture



if (Impax:=ImpaxState)[1]!=2



	return



if (!gestureValue){



	cursorModeToggle:=!cursorModeToggle



	for k,v in impaxControls:=getControls(Impax[2,1])



		if (v.text="BMP_CURSOR_MODE_NEW" && instr(v.classNN,"WindowsForms10.BUTTON.app")){



			controlclick,,% "ahk_id " impaxCursorModeHwnd:=v.hwnd



			break



		}



	;~ msgbox % acc_objectfromwindow(impaxCursorModeHwnd).accState



	if (cursorModeToggle)



		settimer,cursorModeToggle,-100



}



gestureValue:=0



return







cursorModeToggle:



if(winactive("ahk_group pacs") && !getkeystate("Lbutton") && !getkeystate("mbutton") && !getkeystate("rbutton")){



	mousegetpos,mx,my



	if (mx-gestureX1)**2+(my-gestureY1)**2>2500 {



		controlclick,,% "ahk_id " impaxCursorModeHwnd



		cursorModeToggle:=!cursorModeToggle



		return



	}



}



settimer,cursorModeToggle,-100







return











`::



toggleImageText:



if (Impax:=ImpaxState)[1]!=2



	return



if(Impax[2,5]=2){



	if(Impax[2,4]=1){



		for k,v in (impaxControls:=getcontrols(Impax[2,1])){



			if (v.text="文字" || v.text="Text" || v.text="影像" || v.text="Image") && instr(v.ClassNN,"WindowsForms10.BUTTON") {



		controlclick,,% "ahk_id " v.hwnd



		return



			}



		}



	}else if(Impax[2,4]=3){



		winactivate,% "ahk_id " Impax[2,1]



	}



}else if(Impax[2,5]=1){



	for k,v in (impaxControls:=getcontrols(Impax[2,1])){



		if (v.text="文字" || v.text="Text" || v.text="影像" || v.text="Image") && instr(v.ClassNN,"WindowsForms10.BUTTON") {



			controlclick,,% "ahk_id " v.hwnd



			return



		}



	}



}



return



~!2::



winwait,ahk_class #32770,Screen_0_format,2



winmove,ahk_class #32770,Screen_0_format,% 0,% 0



mousemove,-99999,-99999,0,R



wingetpos,x,y,,,ahk_class #32770,Screen_0_format



mousemove,% x+550, % y+550,0



return



tab::	



showSeriesList:



if ImpaxState[1]!=2 && ImpaxState[2,4]!=1



	return



;~ msgbox,,,,0.5







;~ winget,impaxList,list,ahk_exe impax-client-main.exe



;~ loop % impaxList {



	;~ impaxId:=impaxList%a_index%



	;~ for k,v in (impaxControls:=getcontrols(impaxId)){



		;~ if v.text="BMP_VIRTUAL_SCREEN_BUTTON" && instr(v.ClassNN,"WindowsForms10.BUTTON") {



			;~ controlclick,,% "ahk_id " v.hwnd



		;~ }



	;~ }



;~ }



seriesListStored:=toggleSeriesList(ImpaxState, "toggle", "all", monitorInfo)



;~ if winvisible(seriesListStored[2]){



gosub adjustSeriesListWin



SetTimer,toggleSeriesList,-5000



winactivate,% "ahk_id " ImpaxState[2,1]



;~ KeyWait,lbutton,d T3



;~ if(!ErrorLevel){



	;~ KeyWait,lbutton,T3



	;~ if(!ErrorLevel)



		;~ SetTimer,toggleSeriesList,-2000



;~ }



;~ }



return







adjustSeriesListWin:



seriesListHwnd:=[]



if IsObject(seriesListStored){



	Loop % (seriesListStored.maxindex())/2



		seriesListHwnd.push(seriesListStored[A_Index*2])



}else{



	for k,v in seriesList:=getSeriesList()



		seriesListHwnd.push(v[1])



}







for k,v in seriesListHwnd {



	if !WinExist("ahk_id " seriesListWin:=v)



		continue



	;~ if winvisible(seriesListWin:=v.1) {



		WinGetPos,seriesListx,seriesListy,seriesListw,seriesListh,ahk_id %seriesListWin%



		seriesListAt:=whichMonitor(seriesListx+seriesListw/2,seriesListy+seriesListh/2,monitorInfo).1



		if(seriesListh<30){



			WinMove,ahk_id %seriesListWin%,,,,,270



			;~ WinRestore,ahk_id %seriesListWin%



		}



		MouseGetPos,mx,my



		mouseAt:=whichMonitor(mx,my, monitorInfo).1



		if(seriesListAt=mouseAt){



			WinMove,ahk_id %seriesListWin%,,% seriesListx,% ((my-seriesListh)>seriesListy?(my-seriesListh):seriesListy)+Floor(seriesListh/2)



			



		}else if (seriesList.maxindex()=1){



			WinMove,ahk_id %seriesListWin%,,% monitors[mouseAt].l,% ((my-seriesListh)>seriesListy?(my-seriesListh):seriesListy)+Floor(seriesListh/2)



			



		}



	;~ }else{



		;~ SetTimer,adjustSeriesListWinBack,off



	;~ }



}



return







adjustSeriesListWinBack:



	WinMove,ahk_id %seriesListWin%,,% seriesListx,% seriesListy



return







~rbutton::



if !(a_thishotkey=a_priorhotkey && A_TimeSincePriorHotkey<300 && GetKeyState("RButton","P")) {



	return



}



sleep 100



mousemove,10,10,0,r



mousegetpos,,,menuHwnd



controlgetpos,,,w,h,,ahk_id %menuHwnd%



mouseclick,l,% w/2-10,% (h/9)*3,1,0,,R



return







~numpadenter::



~enter::



if (Impax:=ImpaxState)[1]!=2 && Impax[2,4]!=2



	return



selectChartNo:



for k,v in (impaxControls:=getcontrols(id2:=Impax[2,2]|Impax[2,3])){



	if k<2



		continue



	if instr(v.classNN,"WindowsForms10.EDIT.app") && ((impaxControls[k-1].text="病歷號碼" ) || (impaxControls[k-1].text="Patient ID")) {



		controlfocus,,% "ahk_id " impaxChartnoControl:=v.hwnd



		controlget,selectedText,Selected,,,% "ahk_id " impaxChartnoControl



		if !selectedText



			ControlClick,,% "ahk_id " impaxChartnoControl,,l,1



		break



	}



}



return



f1::



if (Impax:=ImpaxState)[1]!=2



	return



bar:=ImpaxBar(id2:=Impax[2,2]|Impax[2,3])



if(Impax[2,5]=2){



	if(Impax[2,4]=1){



		winactivate,ahk_id %id2%



		wingetpos,,,,h,ahk_id %id2%



		if !(bar.h>h-37)



			controlclick,,% "ahk_id " bar.hwnd



	}else if(Impax[2,4]=3){



		wingetpos,,,,h,ahk_id %id2%



		if !(bar.h>h-37)



			controlclick,,% "ahk_id " bar.hwnd



	}else if(Impax[2,4]=2){



		winactivate,% "ahk_id " Impax[2,1]



	}



}else if(Impax[2,5]=1){



	if(Impax[2,4]=2){



		controlclick,,% "ahk_id " bar.hwnd,,,,% "x" a_screenwidth/2 " y5"



		loop {



			sleep 200



			if(ImpaxState[2,4]=1){



		break



			}else if(ImpaxState[2,4]=3){



		for k,v in (impaxControls:=getcontrols(ImpaxState[2,2]|ImpaxState[2,3])){



			if (v.text="影像" || v.text="Image") && instr(v.ClassNN,"WindowsForms10.BUTTON") {



				controlclick,,% "ahk_id " v.hwnd



				break



			}



		}



			}



		}



	}else if(Impax[2,4]=1||Impax[2,4]=3){



		controlclick,,% "ahk_id " bar.hwnd



	}



}



if (Impax[2,4]!=2) {



	gosub selectChartNo



}



return



backToList:



return



gosub selectChartNo



return



#ifwinactive







~lbutton::	



mousegetpos,mx,my,mouseWin,mouseControl



WinGetClass,mouseWinClass,ahk_id %mouseWin%



if(mouseWinClass="#32770" && mouseControl="SysListView321"){



	MouseGetPos,,,,mouseControlId,2



	if(ControlGetText(mouseControlId)="List1"){



		originalMouse:={x:mx,y:my}



		winactivate,ahk_id %mouseWin%



		gosub createSeriesDragGUI



	}



	return



}



return







~lbutton up::



UnhookWindowsHookEx(mouseHook)



if(dragGUIs.maxindex()){



	MouseGetPos,mx,my,win



	WinGetTitle,t,ahk_id %win%



	dragFinishFn:=Func("dragGuiFinish").bind(t, originalMouse, mx, my, win)



	settimer,% dragFinishFn,% -1



}



;~ mousegetpos,mx,my



;~ gosub dragGuiFinish



;~ SetTimer,DestroyDragGUI,-1



return







slp_login:



ifwinnotexist,SleipnirLogin ahk_class AutoHotkeyGUI



{



	settimer,slp_login,-500



	return



}



control,uncheck,,Button8,SleipnirLogin ahk_class AutoHotkeyGUI



controlsettext,Edit1,loginId,SleipnirLogin ahk_class AutoHotkeyGUI



controlsettext,Edit2,loginPw,SleipnirLogin ahk_class AutoHotkeyGUI



controlsettext,Edit3,428562,SleipnirLogin ahk_class AutoHotkeyGUI



sleep 100



controlclick,Button1,SleipnirLogin ahk_class AutoHotkeyGUI



return







run_slp:



ifwinnotexist,ahk_class SleipnirMainWindow



{



	if fileexist(path:=a_mydocuments "\scsnake\Sleipnir\SleipnirLogin.exe") || fileexist(path:=a_mydocuments "\Sleipnir\SleipnirLogin.exe") || fileexist(path:=root "\Sleipnir\SleipnirLogin.exe"){



		ifwinnotexist,ahk_exe SleipnirLogin.exe



		run % path



		sleep 200



		gosub slp_login



		settimer,run_slp,off



	}else{



		run,% root "\software\Sleipnir\Sleipnir.exe"



	}



}



else {



	settimer,run_slp,off



	settimer,slp_login,off



	settimer,renewsid,300000



}



return



renewSid:



SlpWb:=getSlpWb()



SlpSid:=[]



for k,v in SlpWb



if regexmatch(v.document.body.innerHTML,"i)SESSION=(\w+)",match)



	isobject(SlpSid["" match1])?(SlpSid["" match1].push(k)):(SlpSid["" match1]:=array(k))



for k,v in SlpSid



if !checksid(k)



	for x,y in v



renewSlpUrl(SlpWb[y],sid:=login(newusername,newpassword))



return



renewSlpUrl(wb,sid){



	if regexmatch(href:=wb.LocationUrl,"i)SESSION=\w+")



		wb.Navigate(RegExReplace(href,"i)SESSION=\w+","SESSION=" sid))



	else if regexmatch(href,"is)/[^/\?]+(\?)?$",match)



	wb.Navigate(href (match1=""?"?":"") "SESSION=" sid)



	else if regexmatch(href,"is)/[^/&\?]+\?[^/\?]+(&?)$",match)



	wb.Navigate(href . (match1=""?"&":"") . "SESSION=" sid)



}



getSlpWb(){



	arr:=[]



	winget,SlpControlList,ControlListHwnd,ahk_class SleipnirMainWindow



	loop,parse,SlpControlList,`n



	{



		WinGetClass,controlClass,ahk_id %a_loopfield%



		if(controlClass!="Internet Explorer_Server")



			continue



		static msg := DllCall("RegisterWindowMessage", "str", "WM_HTML_GETOBJECT")



		, IID := "{0002DF05-0000-0000-C000-000000000046}"



		SendMessage msg, 0, 0, ,ahk_id %a_loopfield%



		if (ErrorLevel != "FAIL") {



			lResult:=ErrorLevel, VarSetCapacity(GUID,16,0)



			if DllCall("ole32\CLSIDFromString", "wstr","{332C4425-26CB-11D0-B483-00C04FD90119}", "ptr",&GUID) >= 0 {



		DllCall("oleacc\ObjectFromLresult", "ptr",lResult, "ptr",&GUID, "ptr",0, "ptr*",pdoc)



		arr.push(ComObj(9,ComObjQuery(pdoc,IID,IID),1)), ObjRelease(pdoc)



			}



		}else{



			continue



		}



	}



	return arr



}



GUIClose:



WinMinimize,ahk_id %guiHWND%



return



close_RIS:



if RisState[1]!=2



	return



wingettitle,RisTitle,% "ahk_id " RisState[2]



if !instr(RisTitle,RisName)



	return



winclose,% "ahk_id " RisState[2]



settimer,RisCloseConfirm,500



return



RisCloseConfirm:



if (RisState[1]!=2){



settimer,RisCloseConfirm,off



return



}



ifwinexist,Menu ahk_class #32770,是否確定要離開放射線資訊管理(RIS)系統?



controlclick,Button1



else



settimer,RisCloseConfirm,off



return



close_impax:



if (Impax:=ImpaxState)[1]!=2



	return



for k,v in ImpaxControls:=getControls(Impax[2,2]|Impax[2,3])



if ((v.text="登出" || v.text="Logout") && instr(v.classNN,"WindowsForms10.BUTTON.app") && instr(ImpaxControls[k-1].classNN,"WindowsForms10.STATIC.app") && ImpaxControls[k-1].text!=impax_id){



	controlclick,,% "ahk_id " v.hwnd



	return



}



winclose,% "ahk_id " ImpaxState[2,2]|ImpaxState[2,3]



return



close_SLP:



winget,slpList,list,ahk_class SleipnirMainWindow



closingSlp:=0



settimer,closeSLPconfirm,500



loop % slpList {



	winget,slpPath,processpath,% "ahk_id " slpList%a_index%



	if instr(slpPath,root)!=1



		continue



	winclose,% "ahk_id " closingSlp:=slpList%a_index%



	break



}



return



closeSLPconfirm:



ifwinexist,Sleipnir ahk_class #32770



	controlClick,Button1



if closingSlp && !winexist("ahk_id " closingSlp)



	settimer,closeSLPconfirm,off



return



closeSCITE:



winget,sciteList,list,SciTE4AutoHotkey



loop % sciteList {



	winget,scitePath,processpath,% "ahk_id " sciteList%a_index%



	if instr(scitePath,root)!=1



		continue



	winclose,% "ahk_id " sciteList%a_index%



}



return



NumLock::



activeWin:=winexist("A")



;~ MsgBox % activeWin "," ImpaxState[2,1] "," IsObject(ImpaxState)



if (activeWin=ImpaxState[2,1]){



	for k,v in getControls(ImpaxState[2,1])



		if (v.text="BMP_STUDY_MODE" || v.text="BMP_STUDY_MODE_2"){



			controlclick,,% "ahk_id " v.hwnd



			break



		}



}else{



	send {bs}



}



return



!a::



winget,lastActiveWin,id,A



IfWinNotActive,ahk_id %guiHWND%



{



	winshow,ahk_id %guiHWND%



	winactivate,ahk_id %guiHWND%



}



else



winhide,ahk_id %guiHWND%



if(!hiddenWindows[0]){



	winget,fbWin,list,Facebook



	loop % fbWin



	{



		hiddenWindows[a_index]:=fbWin%a_index%



		winhide,% "ahk_id " fbWin%a_index%



	}



	hiddenWindows[0]:=1



}else {



	hiddenWindows[0]:=0



	while (hwnd:=hiddenWindows.pop())



	winshow,% "ahk_id " hwnd



}



return



~!p::



regread,proxy_state,HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyEnable



if !proxy_state



{



	RegWrite,reg_dword,HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyEnable,1



	RegWrite,reg_sz,HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyServer,proxy.hospital-n.local:3128



	RegWrite,reg_sz,HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyOverride,<local>



	tooltip,N Hospital Proxy On



}



else



{



	RegWrite,reg_dword,HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyEnable,0



	tooltip,Proxy Off



}



settimer,tooltip,-5000



return



tooltip:



tooltip



return



^!d::



clipboard=



send ^c



clipwait,1



fileappend,% """" clipboard """`n",words.csv,utf-8



return



#ifwinexist,放射線資訊管理系統(Radiology Information System)



^#tab::



keywait,LWIN,t1



keywait,RWIN,t1



keywait,tab,t1



keywait,ctrl,t1



if errorlevel



	return



sleep 100



clipboard=



send ^c



clipwait,1



if !regexmatch(clipboard,"(t|T|y|Y)\w{9}\d",match) && !regexmatch(clipboard,"\b\w{6}\d\b",match)



	return



clipboard:=match



winactivate,% "ahk_id " RisState[2]



searchRisChartNo(RisState[2],match)



return



#ifwinexist



mbutton::



;~ mousegetpos,gestureX1,gestureY1,mouseWin



;~ WinGetClass,mouseWinClass,ahk_id %mouseWin%



;~ winactivate,ahk_id %mouseWin%



gosub gestureStart



return



mbutton up::



if (!gestureValue)



	send {mbutton}



return



















#ifwinexist,ahk_group pacs



~wheeldown::



~wheelup::



;~ if impaxState[1]!=2



	;~ return



mousegetpos,,,mouseWin,mouseControl,2



;~ WinGetClass,mouseWinClass,ahk_id %mouseWin%



winget,ProcessName,ProcessName,ahk_id %mouseWin%



if(ProcessName~="impax-client-main\.exe|WEBVIE~1\.EXE") && !WinActive("ahk_group pacs"){



	;~ winactivate,% "ahk_id " (impaxState[2,4]>1?(impaxState[2,2]|impaxState[2,3]):impaxState[2,1])



	winactivate,% "ahk_exe " ProcessName



	ControlFocus,,ahk_id %mouseControl%



	winset,AlwaysOnTop,off,simple RIS ahk_class AutoHotkeyGUI



	DllCall("SetWindowPos", "UINT", WinExist("simple RIS ahk_class AutoHotkeyGUI"), "UINT", mouseWin, "INT", 0, "INT", 0, "INT", 0, "INT", 0, "UINT", 0x0013)



}







return



^!tab::



if (Impax:=ImpaxState)[1]!=2



	return



ifwinactive,UniReport ahk_class TMainForm



{	



	wingettitle,str,UniReport ahk_class TMainForm



	clipboard:=str



}else{



	keywait,alt,t1



	keywait,tab,t1



	keywait,ctrl,t1



	if errorlevel



		return



	sleep 100



	clipboard=



	send ^c



	clipwait,1



}



^!tab1:



if !regexmatch(clipboard,"\b\w{6}\d\b",match)



	return



chartNo:=match



winactivate,% "ahk_id " id2:=Impax[2,2]|Impax[2,3]



bar:=ImpaxBar(id2)



wingetpos,,,,h,ahk_id %id2%



if !(bar.h>h-37)



	controlclick,,% "ahk_id " bar.hwnd



gosub selectChartNo



acc_objectfromwindow(impaxChartnoControl).accValue:=chartNo



controlsend,,{enter},% "ahk_id " impaxChartnoControl



return



#ifwinexist



;~ ~!e::



;~ while(x:=winexist("Microsoft Internet Explorer"))



;~ winkill,ahk_id %x%



;~ return



^!q::



if !(a_priorhotkey=a_thishotkey && A_TimeSincePriorHotkey<300)



	return



winclose,autorun.exe,Quit?



settimer,close_RIS,-1



settimer,close_impax,-500



closeSLPind:=0



settimer,close_SLP,-1



process,close,XLiu.exe



settimer,closeUSBprocess,-1



return















closeUSBprocess:



;~ winget,pList,list



;~ loop % pList {



	;~ winget,pPath,processpath,% "ahk_id " pList%a_index%



	;~ if (instr(pPath,root)=1 && a_scripthwnd!=pList%a_index% )



		;~ winclose,% "ahk_id " pList%a_index%



;~ }



;~ p:=listProcess()[1]



;~ loop,parse,p,|



;~ {



	;~ if instr(GetModuleFileNameEx(a_loopfield),root)



		;~ process,close,% a_loopfield



;~ }







return







/* currently used 



*/



terminateUSBprocess:



msgbox,1,,Sure?



ifmsgbox,Cancel



return



WinClose,ahk_exe firefox.exe



process,close,XLiu.exe



settimer,unmountUSB3,-1



;~ gosub closeUSBprocess



winget,pList,list



loop % pList {



	winget,pPath,processpath,% "ahk_id " pList%a_index%



	if (instr(pPath,root)=1 && a_scripthwnd!=pList%a_index% && guiHwnd!=pList%a_index% && !instr(pPath,"Autorun.exe")){



		winclose,% "ahk_id " pList%a_index%



	}



}



sleep 1000



winget,pList,list



loop % pList {



	winget,pPath,processpath,% "ahk_id " pList%a_index%



	if !instr(pPath,"Autorun.exe") && (instr(pPath,root)=1 && a_scripthwnd!=pList%a_index% && guiHwnd!=pList%a_index%) || (pPath=root "\scripts\AutoHotkey\AutoHotkey.exe")   {



		winget,pid,pid,% "ahk_id " pList%a_index%



		process,close,% pid



	}



}



exitapp







return







unmountUSB:



;~ filecopy,% root "\scripts\Autorun\RemoveDrive\Win32\RemoveDrive.exe",% a_mydocuments,1



;~ run,% a_mydocuments "\RemoveDrive.exe " root " -L -w:3000 -s -h -a",% a_mydocuments



filecopy,% root "\software\USBDiskEjector\*.*",% a_mydocuments,1



;~ msgbox



run % a_mydocuments "\USB_Disk_Eject.exe /REMOVELETTER " substr(root,1,1)



exitapp



return







unmountUSBold:



;~ if (a_osversion!="WIN_XP")



	;~ exitapp



filecopy,% root "\software\USBDiskEjector\*.*",% a_mydocuments,1



FileAppend,% "`n@echo off`nping 1.1.1.1 -n 1 -w 2000`n:L1`nIF EXIST " root " (`USB_Disk_Eject.exe /REMOVELETTER " substr(root,1,1) "`nping 1.1.1.1 -n 1 -w 2000`ngoto L1 ) ELSE (`ndel USB_Disk_Eject.exe`ndel USB_Disk_Eject.cfg`ndel unmount.cmd )",% A_MyDocuments "\unmount.cmd",cp0



run,% A_MyDocuments "\unmount.cmd",% A_MyDocuments



exitapp



return







unmountUSB3:



ejectPath:=root "\software\EjectMedia\" (A_Is64bitOS?"x64":"Win32") "\EjectMedia.exe"



filecopy,% ejectPath,% A_MyDocuments,1



;~ FileDelete,% cmdPath:=% A_MyDocuments "\unmount.bat"



;~ FileAppend,



;~ (



;~ @echo off



;~ ping 1.1.1.1 -n 1 -w 2000



;~ del EjectMedia



;~ del unmount.bat



;~ taskkill /IM autorun.exe /F /T



;~ ),% cmdPath,cp0



run % """" A_MyDocuments "\EjectMedia.exe"" " root " -L -a -w:3000"



;~ exitapp



return







~^!l::



critical



;~ SetTimer,~^!i,-1



risLoging:=0,waiting:=0,tryLoginRis:=0



if(!alternativeLogin){



	RIS_id:=loginId



}else{



	RIS_id:="H00000"



	;~ settimer,login_IMPAX,-1



}



RisState1:=RisOpened(1)



if(!RisState1[2,1]){



	if(loginRis:=RisState1[1,1]){



		winshow,ahk_id %loginRis%



		winactivate,ahk_id %loginRis%s



		settimer,login_RIS_thread,-1



	}else if(hiddenRis:=RisState1[2,1] && !winvisible(hiddenRis)){



		winshow,ahk_id %hiddenRis%



		winactivate,ahk_id %hiddenRis%



	}else{



		settimer,login_RIS_thread,-1



	}



}



;~ settimer,loginAnotherRis,-60000



;~ settimer,login_RIS,-100



settimer,maximizeImpax,2000



alternativeLogin:=0



return







openAnotherRis:



thread,Priority,-1



RisState1:=RisOpened(1)



if(RisState1[1,1]){



	if (RisState1[2,1])



		winhide,% "ahk_id " RisState1[1,1]



	;~ settimer,openAnotherRisRoutine,off



	settimer,openAnotherRis,-60000



	return



}



if !(risPath:=getrispath()) {



	;~ settimer,openAnotherRisRoutine,off



	settimer,openAnotherRis,off



	return



}



run,% risPath,% RegExReplace(RISpath, "\\Menu\.exe$")



;~ settimer,openAnotherRisRoutine,200



while RisState1:=RisOpened(1) {



	IfWinNotExist,% "ahk_id " RisState1[1,1]



		sleep 500



	else 



		break



}



settimer,openAnotherRis,-60000



return







openAnotherRisRoutine:



return ;pauseThread



ahkmini("



(



;~ threadIds:=CriticalObject(" (&ThreadIds) "), threadIds[""openAnotherRisRoutine""]:=DllCall(""GetCurrentThreadId""), clipboard.=""openAnotherRisRoutine "" DllCall(""GetCurrentThreadId"") ""``n""







#persistent



#include <risimpax>



#include <winvisible>



#notrayicon



loop {



	ifwinexist,檔案更新精靈 ahk_exe Update.exe



		winhide



	RisState:=RisOpened()



	if (RisState[2,1]) {



		if (RisState[1,1]){



			winhide,`% ""ahk_id "" RisState[1,1]



		}



	}else if RisState[1,1] && !winvisible(RisState[1,1])



		winshow,`% ""ahk_id ""RisState[1,1]



	sleep 500



}



)")



return







loginAnotherRis:



RisState1:=RisOpened(1)



currentRisCount:=RisState1[2].maxindex()



if (!loginRis:=RisState1[1,1]){



	run % getRisPath(1)



	while !loginRis:=(RisState1:=RisOpened(1))[1,1]



		sleep 200



}



winactivate,ahk_id %loginRis%



winwaitactive,,,3



send % ris_id



winactivate,ahk_id %loginRis%



send {tab}



winactivate,ahk_id %loginRis%



send % ris_pw



winactivate,ahk_id %loginRis%



send {enter} 



while !((RisState1:=RisOpened(1))[2].maxindex() > currentRisCount)



	sleep 200



winhide,% "ahk_id " RisState1[2, currentRisCount+1]



return







~^!i::



settimer,login_impax,-1



return







sig1:



sig1:=(Impax:=ImpaxOpened())[1]=1 && i++<60



return



login_impax:







if (Impax:=ImpaxState)[1]=2



	return



if(Impax[1]=0){



	settimer,restartImpax,300



	run,% A_ProgramFiles "\Agfa\IMPAX Client\AppStart.exe"



	loop



		sleep % 200



	until (ImpaxOpened()[1]||a_index>300)



}







loginText:=GetControlIdByText(controls,"登入")?"登入":"Login"



gosub login_impax2



settimer,login_impax2,2000



return



login_impax2:



if((Impax:=ImpaxOpened())[1]=1 && i++<60){



	for k,v in controls:=GetControls(impaxHwnd:=Impax[2,1])



	if (v.classNN="WindowsForms10.EDIT.app.0.2bf80982") {



		controlsettext,,%IMPAX_id%,% "ahk_id " v.hwnd



		break



	}



	for k,v in controls



	if (v.classNN="WindowsForms10.EDIT.app.0.2bf80981") {



		controlsettext,,%IMPAX_pw%,% "ahk_id " v.hwnd



		break



	}



	for k,v in controls



	if (v.classNN="WindowsForms10.BUTTON.app.0.2bf80981") {



		controlfocus,,% "ahk_id " v.hwnd



		controlsend,,{enter},% "ahk_id " v.hwnd



		break



	}



}else{



	return



}



settimer,restartImpax,off



settimer,login_impax2,off



gosub maximizeImpax



settimer,maximizeImpax,2000



return



maximizeImpax:



WinGet,minmaxImpax,minmax,% "ahk_id " ImpaxState[2,3]



if (minmaxImpax=1)



	settimer,maximizeImpax,off



else



WinMaximize,% "ahk_id " ImpaxState[2,3]



return



restartImpax:



if restartImpaxId:=winexist("重新啟動 ahk_class WindowsForms10.Window.8.app.0.2bf8098")



	controlclick,WindowsForms10.BUTTON.app.0.2bf80982,ahk_id %restartImpaxId%



return







openSimpleRis:



if !simpleRis:=winexist("simple RIS ahk_class AutoHotkeyGUI"){



	run % partialMode?root "\PacsIE\simpleRIS.exe":root "\scripts\Radiology\PacsIE\simpleRIS.exe"



}



return







login_RIS_thread:



if risstate[1]=2



	return



else  {



	;~ while (RisState[1]!=2){



		;~ RISarr:=getControls(RisState[1,1])



		;~ ,RisIdHwnd:=GetControlIdByText(RISarr,"Password",-1)



	while (RisState[1]!=2) && (A_Index<5){



		WinActivate % "ahk_id " RisState[2]



		RISarr:=getControls(RisState[2])



		,RisIdHwnd:=GetControlIdByText(RISarr,"Password",-1)



		WinWaitActive % "ahk_id " RisState[2],,3



		;~ ToolTip % RisIdHwnd



		if(!ErrorLevel){



			ControlFocus,,ahk_id %RisIdHwnd%



			SendInput,% "{HOME}+{END}" ris_id "{tab}"



			Sleep 1000



			WinActivate % "ahk_id " RisState[2]



			WinWaitActive % "ahk_id " RisState[2],,3



			;~ ControlFocus,,ahk_id %RisIdHwnd%



			SendInput,% ris_pw "{Enter}"



		}



		Sleep 3000



	}







}



;~ settimer,fillRisIdPwThread,-1







return







login_RIS:



settimer,openSimpleRis,-1



if(!waiting && risopened()[1]!=1){



	if(risopened()[1]=0){



		;~ loop {



			;~ process,close,Menu.exe



		;~ } until !errorlevel



	}



	settimer,closeRisError,500



	RisLoginAttempt:=0



	if(risopened()[1]=2){



		return



	}



	if(risopened()[1]=0 && !risLoging){



		RISpath:=getrispath()



		settimer,disableRisUpdate,500



		run,% RISpath,% RegExReplace(RISpath,"\\Menu\.exe$")



		risLoging:=1



		waiting:=1



		settimer,login_RIS,-500



	}



}else{



	if(++waiting>120){



		return



	}



	if(risopened()[1]=1){



		waiting:=0



		RISarr:=getControls(risid:=risopened()[2])



		,RisIdHwnd:=GetControlIdByText(RISarr,"Password",-1)



		winactivate,% "ahk_id " risId



		winwaitactive,% "ahk_id " risId,,3



		controlfocus,,ahk_id %RisIdHwnd%



		ToolTip % tryLoginRis



		send {home}+{end}



		Sleep 200



		send % ris_id



		send {tab}



		Sleep 1000



		winactivate,% "ahk_id " risId



		send {home}+{end}



		Sleep 200



		send % ris_pw



		send {enter}



		



		if(++tryLoginRis>10){



			Loop 



				process,close,Menu.exe



			until !ErrorLevel



			return



		}



		



		settimer,RisSetDefaultSearch,2000



		settimer,disableRisUpdate,off



	}else{



		settimer,login_RIS,-500



	}



}



return







fillRisIdPwThread:



script=



( %



#persistent



#include <risimpax>



settimer,<fillRisIdPw,-500







return







<fillRisIdPw:



if(risopened()[1]!=2){



	RISarr:=getControls(risid:=risopened()[2])



	,RisIdHwnd:=GetControlIdByText(RISarr,"Password",-1)



	controlfocus,,ahk_id %RisIdHwnd%



	winactivate,% "ahk_id " risId



	winwaitactive,% "ahk_id " risId,,3



	if(!errorlevel){



		controlfocus,,ahk_id %RisIdHwnd%



		send {home}+{end}



		Sleep 200



		send % ris_id



		send {tab}



		Sleep 1000



		winactivate,% "ahk_id " risId



		send {home}+{end}



		Sleep 200



		send % ris_pw



		send {enter}



	}



	if(++tryLoginRis>10){



		Loop 



			process,close,Menu.exe



		until !ErrorLevel



		exitappy



	}



}else{



	ExitApp



}



settimer,<fillRisIdPw,-500



fillRisIdPw>:



return



)



;~ return ;pauseThread



ahkmini("



(



;~ threadIds:=CriticalObject(" (&ThreadIds) "), threadIds[""fillRisIdPw""]:=DllCall(""GetCurrentThreadId""), clipboard.=""fillRisIdPw "" DllCall(""GetCurrentThreadId"") ""``n""



ris_id:=""" ris_Id """,ris_pw:=""" ris_pw """



)" script)



return







disableRisUpdate:



runRisThread:



script=



(



#persistent



#include <risimpax>



risPath:=getrispath()



fill:=0



currentRis:=risopened(1)[2].maxIndex()



settimer,<disableRisUpdate,500



settimer,exitapp,-10000



settimer,newRis,-8000



return



newRis:



run,`% risPath:=getrispath(),`% RegExReplace(RISpath, "\\Menu\.exe$")



return







exitapp:



exitapp



return







<disableRisUpdate:







if (risid:=(RisState1:=risopened(1))[1,1]){



	settimer,<disableRisUpdate,off



	settimer,exitapp,-10000



	gosub <fillRisIdPw



	



	return



}



ifwinexist,檔案更新精靈 ahk_exe Update.exe



{



	;~ controlclick,WindowsForms10.BUTTON.app.0.218f99c1



	controlclick,取消(&C)



	winwait,取消更新 ahk_exe Update.exe,,1



	settimer,exitapp,-10000



}



ifwinexist,取消更新 ahk_exe Update.exe



{



	controlclick,Button1



	sleep 1500



	settimer,exitapp,-10000



}



disableRisUpdate>:



return



<fillRisIdPw:



if( winexist("ahk_id " risid) && fill<2){



	RISarr:=getControls(risid)



	,RisIdHwnd:=GetControlIdByText(RISarr,"Password",-1)



	controlfocus,,ahk_id `%RisIdHwnd`%



	winactivate,`% "ahk_id " risId



	winwaitactive,`% "ahk_id " risId,,3



	if(!errorlevel){



		controlfocus,,ahk_id `%RisIdHwnd`%



		;~ msgbox `% ris_id



		send {home}+{end}



		Sleep 200



		send `% ris_id



		send {tab}



		Sleep 1000



		send {home}+{end}



		Sleep 200



		send `% ris_pw



		send {enter}



		if(++tryLoginRis>10){



			Loop 



				process,close,Menu.exe



			until !ErrorLevel



			exitapp



		}



	}



}else{



	ExitApp



}



settimer,<fillRisIdPw,-500



fillRisIdPw>:



return







)



;~ return ;pauseThread



ahkmini("



(



;~ threadIds:=CriticalObject(" (&ThreadIds) "), threadIds[""<fillRisIdPw""]:=DllCall(""GetCurrentThreadId""), clipboard.=""<fillRisIdPw "" DllCall(""GetCurrentThreadId"") ""``n""



ris_id:=""" ris_Id """,ris_pw:=""" ris_pw """



)" script)



return







RisSetDefaultSearch:



if (RisState[1]=2){



	settimer,closeRisError,off



	control,choosestring,所有撰打住院醫師,,% "ahk_id " getNetControl2(RisState[2],"撰打住院醫師","FID_LABEL","撰打住院醫師","WindowsForms10.STATIC.app","","","",1)[1]



	controlfocus,,% "ahk_id " getNetControl2(RisState[2],"報告醫師","FID_LABEL","報告醫師","WindowsForms10.STATIC.app","","","",1)[1]



	



	settimer,RisSetDefaultSearch,off



}



return



closeRisError:



IfWinExist,Menu ahk_class #32770,查無使用者



{



	controlclick,Button1



	if (++RisLoginAttempt)>10 {



		settimer,closeRisError,off



		settimer,RisSetDefaultSearch,off



		RisLoginAttempt:=0



	}



}



ifwinexist,Menu ahk_class #32770,查無



	controlclick,Button1



return



~!q::



winactivate,ahk_exe autorun.exe,Quit?



msgbox,1,,Quit?



ifmsgbox,cancel



return



ExitApp



return







showCursor:



settimer,hideCursor,off



SystemCursor("On")



return







hideCursor:



SystemCursor("Off")



return







onexit:



PostMessage,0______,,,,ahk_exe ImpaxContextServer.exe



settimer,showCursor,-1



;~ for k,v in mouseHooks



	;~ UnhookWindowsHookEx(v)



UnhookWindowsHookEx(mouseHook)



;~ impaxMouseHook:=false



;~ UnhookWindowsHookEx(mouseHook)



RegWrite,reg_dword,HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyEnable,0



while hwnd:=hiddenWindows.pop()



winshow,% "ahk_id " hwnd



if himc



	DllCall("Imm32.dll\ImmAssociateContext","UInt", risState[2], "UInt", himc)



for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process where name = 'Autohotkey.exe' and processID  <>" thisPid) {



	PostMessage,0______,,,,% "ahk_pid " process.ProcessId



	PostMessage,0______,,,,% "ahk_pid " process.ProcessId



}



RisState1:=RisOpened(1)



for k,v in RisState1



	for x,y in v



		winshow,% "ahk_id " y



for k,v in ["textHotkey.exe", "capslock_remap_alt.exe", "AutoNum.exe", "RazerNaga.exe", "UIAutomationServer.exe", "ImpaxContextServer.exe"]



		WinClose % "ahk_exe " v



ExitApp











relativeDate(theDay,relative=-1){



	Formattime,d,% theDay,yyyyMMddHHmmss



	d+=%relative%,d



	return d



}







StringUpperFirst(str){



	a:=substr(str,1,1)



	b:=substr(str,2)



	StringUpper,a,a



	return a b



}



#!b::



#b::



if (RisState[1]!=2 || winactive("ahk_group pacs"))



	return



while GetKeyState("RWin") || GetKeyState("Lwin") || GetKeyState("b") || GetKeyState("shift")



	Sleep 10



sendmessage,0x2021,,,,ahk_exe simpleRIS.exe



clipboard=



send ^c



clipwait,1



gosub renewRisReports



;~ RisReports:=getRisReports(RisState[2])



focused:=getFocused()



simpleRis:=winexist("simple RIS ahk_class AutoHotkeyGUI")



clipboard:=RegExReplace(clipboard, "(^\s+)|(\s+$)", "")



controlget,editHwnd,hwnd,,Scintilla1,ahk_id %simpleRis%



if (focused=RisReports[1,1] || winactive("ahk_id " simpleRis)){



	controlsettext,,% sentText:=(txt:=controlgettext(RisReports[1,2])) (regexmatch(txt,"\n$")||txt=""?"":"`r`n") StringUpperFirst(trim(clipboard)),% "ahk_id " risreports[1,2]



	Edit_SetSel(RisReports[1,2],strlen(sentText),strlen(sentText))



	Edit_ScrollCaret(RisReports[1,2])



	return



}







if (newText:=clipboard)=""



	return



paste:="",oldText:=controlgettext(RisReports[1,1])



;~ StringReplace,paste,paste,`r,,all



;~ paste:=RegExReplace(paste,"\s*\n+\s*","`n")



;~ paste:=RegExReplace(paste,"\n+","`n")



;~ paste:=RegExReplace(paste,"\s*\n\s*","; ")



moreDelim:=instr(a_thishotkey,"!")?".":""



if (oldText="") || regexmatch(oldText,"i)History:\s+$") || (regexmatch(oldText,"i)History: ") && regexmatch(oldText,";\s*$")) {



	loop,parse,newText,`n`r



		if (trim(a_loopfield)!="")



			paste.=RegExReplace(trim(a_loopfield),"[^\w\+\)]+$","") "; "



	;~ Controlsettext,,% text:=RegExReplace(sentText:=abbr((oldText=""?"History: ":oldText) paste),"(\d).\r?\n- (\d)","$1.$2"),% "ahk_id " RisReports[1,1]



	text:=RegExReplace(sentText:=abbr((oldText=""?"History: ":oldText) paste),"(\d).\r?\n- (\d)","$1.$2")



} else if InStr(oldText,"  -- ") {



	



	Edit_GetSel(editHwnd, s, e)







	newText:=RegExReplace(newText,"m)^\d*\W+","")



	loop,parse,newText,`n`r%moreDelim%



		if (trim(a_loopfield)!="")



			paste.=capitalize(trim(a_loopfield)) moreDelim "`r`n  -- "



	text:= (sentText:= SubStr(oldText, 1, s) paste ) SubStr(oldText, s+1)



	



} else if regexmatch(oldText,"\n(\W+)$",match) {



	newText:=RegExReplace(newText,"m)^\d*\W+","")



	loop,parse,newText,`n`r%moreDelim%



		if (trim(a_loopfield)!="")



			paste.=capitalize(trim(a_loopfield)) moreDelim "`r`n" match1



	



	;~ Controlsettext,,% RegExReplace(sentText:=oldText capitalize(paste),"(\d).\r?\n- (\d)","$1.$2"),% "ahk_id " RisReports[1,1]



	text:=RegExReplace(sentText:=oldText capitalize(paste),"(\d).\r?\n- (\d)","$1.$2")



} else if regexmatch(oldText,"\n(\d+)(\W+)$",match) {



	newText:=RegExReplace(newText,"m)^\d*\W+","")	



	loop,parse,newText,`n`r%moreDelim%



		if (trim(a_loopfield)!="")



			paste.=capitalize(trim(a_loopfield)) moreDelim "`r`n" (++match1) match2



	;~ Controlsettext,,% RegExReplace(sentText:=oldText capitalize(paste),"(\d).\r?\n- (\d)","$1.$2"),% "ahk_id " RisReports[1,1]



	text:=RegExReplace(sentText:=oldText capitalize(paste),"(\d).\r?\n- (\d)","$1.$2")



}



controlsettext,,% text, % "ahk_id " RisReports[1,1]



Edit_SetSel(RisReports[1,1],len:=strlen(sentText),len)



Edit_ScrollCaret(RisReports[1,1])



if (simpleRis){



	;~ controlget,editHwnd,hwnd,,Scintilla1,ahk_id %simpleRis%



	;~ controlsettext,,% text, % "ahk_id " editHwnd



	Edit_SetText(editHwnd, text)



	



	Edit_SetSel(editHwnd,len,len)



	Edit_ScrollCaret(editHwnd)



}



tooltip,% "History added"



settimer,tooltip,-1000



return











abbr(str){



	str:=RegExReplace(str,"status post","s/p")



	str:=RegExReplace(str,"squamous cell carcinoma","SCC")



	str:=RegExReplace(str,"hepatocellular carcinoma","HCC")



	str:=RegExReplace(str,"left lower lobe","LLL")



	str:=RegExReplace(str,"right lower lobe","RLL")



	str:=RegExReplace(str,"left upper lobe","LUL")



	str:=RegExReplace(str,"right upper lobe","RUL")



	str:=RegExReplace(str,"right middle lobe","RML")



	str:=RegExReplace(str,"transarterial embolization","TAE")



	return str



}



capitalize(str){



	a:=substr(str,1,1)



	StringUpper,a,a



	return a substr(str,2)



}







~capslock up::



keywait,capslock,t1



mousegetpos,mx,my



if (mx>a_screenwidth || my>a_screenheight)



	gosub focusRisReport



else if winactive("ahk_exe Sleipnir.exe") || winactive("ahk_exe firefox.exe")



	gosub focusRisReport



return







#ifwinactive,ahk_group RisGroup











#space::



gosub focusImpression



return











!f4::



winclose,放射線資訊管理系統(Radiology Information System) ahk_exe Menu.exe



return











F5::



;~ controlclick,,% "ahk_id " getNetControl2(RisOpened()[2],"IMPAX","cmdDs3000","IMPAX","WindowsForms10.BUTTON.app","","","",0)[1]



risOpenStudyImpax(RisState[2])



return











F4::



controlclick,,% "ahk_id " getNetControl2(RisOpened()[2],"臨床報告","cmdHisReport","臨床報告","WindowsForms10.BUTTON.app","","","",0)[1]



return















~capslock up::



gosub focusRisReport



return







^down::



^up::



focused:=getFocused()



RisHistory:=getRisHistoryId(RisState[2])



ControlFocus,,ahk_id %RisHistory%



controlsend,,% "{ctrl up}{" substr(a_thishotkey,2) "}",ahk_id %RisHistory%



controlfocus,,ahk_id %focused%



return







^w::



^y::



send {home}+{end}{del}{del}



Click up



return



`::



send ^+{left}{bs}



return



^i::



imageNumber:=getSEIM(ImpaxState)



if (imageNumber[1]!="")



	send % "SE" imageNumber[1] " IM" imageNumber[2]



return







^+d::



^d::



keywait,shift,t1



clipboard:=(instr(a_thishotkey,"+")?"History: ":"") getIndicationText(RisState[2]) ";"



send ^v



return











~^r::



if(RisState[1]!=2)



	return



control,choosestring,所有類別,,% "ahk_id " getNetControl2(RisState[2],"檢查類別","FID_LABEL","檢查類別","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,未發送,,% "ahk_id " getNetControl2(RisState[2],"狀態","FID_LABEL","狀態","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,所有診別,,% "ahk_id " getNetControl2(RisState[2],"診別","FID_LABEL","診別","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,所有報告醫師,,% "ahk_id " getNetControl2(RisState[2],"報告醫師","FID_LABEL","報告醫師","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,所有撰打住院醫師,,% "ahk_id " getNetControl2(RisState[2],"撰打住院醫師","FID_LABEL","撰打住院醫師","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,所有執行住院醫師,,% "ahk_id " getNetControl2(RisState[2],"執行住院醫師","FID_LABEL","執行住院醫師","WindowsForms10.STATIC.app","","","",1)[1]



controlsettext,,% "",% "ahk_id " getNetControl2(RisState[2],"病歷號","FID_LABEL","病歷號","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,% "N總院",,% "ahk_id " (test:=getNetControl2(RisState[2],"檢查地","FID_LABEL","檢查地","WindowsForms10.STATIC.app","","","",1))[1]



;~ Gui +LastFound +OwnDialogs +AlwaysOnTop



return







;~ #h::



RisListHwnd:=getRisList(RisState[2])



RisListRowsAcc:=acc_children(acc_objectfromwindow(RisListHwnd))



reportList:=[]



parseDataGrid(RisListRowsAcc,reportList,1,1)



for k,v in reportList[1] {



	if (v="照會單號") {



		AccNoCol:=k



	}



	if (v="病歷號") {



		chartNoCol:=k



	}



	if (v="檢查名稱") {



		examNameCol:=k



	}



	if (v="狀態") {



		statusCol:=k



	}



	if (v="檢查日") {



		examDateCol:=k



	}	



}



if !checksid(sid) && !sid:=login(IMPAX_id, IMPAX_pw) {



	MsgBox % "Can't login!"



	return



}



for k,v in ThreadPool 



	v.ahkTerminate()



ThreadMax:=10



,ThreadCount:=0



,ThreadPool:=[]



,RisListRowsAcc[2].accSelect(ComObj(3,3),0)



,RisListRowsAcc[2].accSelect(ComObj(3,16),0)



for k,RisListRowAcc in RisListRowsAcc {



	RisListCellsAcc:=acc_children(RisListRowAcc)



	if !RegExMatch(examName:=RisListCellsAcc[examNameCol].accValue, "is)^CT.+Chest$")



		continue



	while ThreadCount>ThreadMax



		Sleep 1000



	ThreadPool.push(ahkmini("



	(Ltrim



	#notrayicon



	#include <portalLib>



	SetBatchLines,-1



	Alias(ThreadCount, " getVar(ThreadCount) ")



	,++ThreadCount



	,chartNo:=""" RisListCellsAcc[chartNoCol].accValue """



	,AccNo:=""" RisListCellsAcc[accNoCol].accValue """



	,ExamDate:=SubStr(RegExReplace(""" RisListCellsAcc[examDateCol].accValue """,""\D"",""""),1,8)



	,ExamName:=""" examName """



	,sid:=""" sid """



	,PacsCTHx:=patientBasicInfoWebTree(patientBasicInfoWeb(chartNo, sid)).getNodeByNames(""置頂"",""報告"",""影核醫報告"").arr



	,moreBodyPart:=0



	,RisListHwnd:=" RisListHwnd "



	,rowIndex:=" k "



	SetTimer,exit,-120000



	for k,v in PacsCTHx {



		RegExMatch(v.innerText,""is)^([\d\/]{10})\_(.+)"", match)



		,match1:=RegExReplace(match1, ""\D"", """")



		



		if (ExamDate=match1 && ExamName!=match2){



			moreBodyPart:=1



			break



		}



	}



	if !(moreBodyPart){



		acc_children(acc_objectfromwindow(RisListHwnd))[rowIndex].accSelect(ComObj(3,8),0)



	}



	goto exit



	return 



	



	exit:



	--ThreadCount



	ExitApp



	return



	



	)"))



}



while ThreadCount {



	Sleep 2000



}



ToolTip % "Finished!"



SetTimer,ToolTip,-1000



return











#h::



RisListHwnd:=getRisList(RisState[2])



,RisListRowsAcc:=acc_children(acc_objectfromwindow(RisListHwnd))



,reportList:=[]



,parseDataGrid(RisListRowsAcc,reportList,1,1)



for k,v in reportList[1] {



	if (v="照會單號") {



		AccNoCol:=k



	}



	if (v="病歷號") {



		chartNoCol:=k



	}



	if (v="檢查名稱") {



		examNameCol:=k



	}



	if (v="狀態") {



		statusCol:=k



	}



	if (v="檢查日") {



		examDateCol:=k



	}	



}



if !checksid(sid) && !sid:=login(IMPAX_id, IMPAX_pw) {



	MsgBox % "Can't login!"



	return



}



RisListRowsAcc[2].accSelect(ComObj(3,3),0)



,RisListRowsAcc[2].accSelect(ComObj(3,16),0)



,searchedResults:=[]



for k,RisListRowAcc in RisListRowsAcc {



	RisListCellsAcc:=acc_children(RisListRowAcc)



	;~ if !RegExMatch(examName:=RisListCellsAcc[examNameCol].accValue, "is)^CT.+Chest$")



		;~ continue



	chartNo:=RisListCellsAcc[chartNoCol].accValue



	;~ ,AccNo:=RisListCellsAcc[accNoCol].accValue



	;~ ,ExamDate:=SubStr(RegExReplace(RisListCellsAcc[examDateCol].accValue,"\D",""),1,8)



	,rowIndex:=k



	



	if !(searchedResults.hasKey("" chartNo))



		Pacs2YrHx:=RisReport2Yr(sid, chartNo), select:=false



	else



		select:=searchedResults["" chartNo]



	



	



	if select || (Pacs2YrHx~="i)s\/p|status post|post[\- ]op"){



		acc_children(acc_objectfromwindow(RisListHwnd))[rowIndex].accSelect(ComObj(3,8),0)



		searchedResults["" chartNo]:=true



	}



	ToolTip % "Processing: " k



}



ToolTip % "Finished!"



SetTimer,ToolTip,-1000



return











reportListProgress(k, ByRef rowAcc, ByRef cellsAcc){



	PacsHx:=getPacsHx(sid,chartNo)



	



}











#j::



MouseGetPos,mx,my



inputbox,changeVS,改派VS,,,150,120



if !errorlevel {



	MouseMove,% mx,% my



	sleep 100



	mouseclick,r



	sleep 100



	mouseclick,l,20,10,1,1,,r



	winwait,報告醫師改派 ahk_exe Menu.exe,,1



	control,choosestring,%changeVS%,,% "ahk_id " getNetAcc(changeVShwnd:=winexist("報告醫師改派 ahk_exe Menu.exe"),"cboReAssignDoctor","COMBOBOX",0,0)



	control,choosestring,% (changeVS="err")?"影像不足":"Group 分派",,% "ahk_id " control:=getNetAcc(changeVShwnd,"cboReasonCode","COMBOBOX",0,0)



	controlfocus,,% "ahk_id " control



}



return







~^j::



gosub ~^r



control,choosestring,% "金山分院",,% "ahk_id " (test:=getNetControl2(RisState[2],"檢查地","FID_LABEL","檢查地","WindowsForms10.STATIC.app","","","",1))[1]



return



~^m::



if (RisState[1]=2){



	if (modalityHwnd:=getNetControl2(RisState[2],"檢查類別","FID_LABEL","檢查類別","WindowsForms10.STATIC.app","","","",1)[1]) {



		inputbox,modalityInput,檢查類別,,,150,120



		if !errorlevel {



			if trim(modalityInput)=""



				control,choosestring,所有類別,,% "ahk_id " modalityHwnd



			else if (modalityInput="1" || modalityInput="plain")



				control,choosestring,一般攝影,,% "ahk_id " modalityHwnd



			else if (modalityInput="2" || modalityInput="special")



				control,choosestring,特殊攝影,,% "ahk_id " modalityHwnd



			else



				control,choosestring,%modalityInput%,,% "ahk_id " modalityHwnd



			



			



		}



	}



}



return



~^n::



if(RisState[1]!=2)



	return



control,choosestring,所有報告醫師,,% "ahk_id " getNetControl2(RisState[2],"報告醫師","FID_LABEL","報告醫師","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,所有撰打住院醫師,,% "ahk_id " getNetControl2(RisState[2],"撰打住院醫師","FID_LABEL","撰打住院醫師","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,所有執行住院醫師,,% "ahk_id " getNetControl2(RisState[2],"執行住院醫師","FID_LABEL","執行住院醫師","WindowsForms10.STATIC.app","","","",1)[1]



controlsettext,,% "",% "ahk_id " getNetControl2(RisState[2],"病歷號","FID_LABEL","病歷號","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,CT,,% "ahk_id " getNetControl2(RisState[2],"檢查類別","FID_LABEL","檢查類別","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,未發送,,% "ahk_id " getNetControl2(RisState[2],"狀態","FID_LABEL","狀態","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,急診,,% "ahk_id " getNetControl2(RisState[2],"診別","FID_LABEL","診別","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,N總院,,% "ahk_id " getNetControl2(RisState[2],"檢查地","FID_LABEL","檢查地","WindowsForms10.STATIC.app","","","",1)[1]



return



~^f::



if (RisState[1]=2){



	;~ for k,v in RISarr:=getControls(RisState[2]) {



		;~ if(v.text="報告醫師"){



			;~ reportDrHwnd:=RISarr[k+1].hwnd



			;~ break



		;~ }



	;~ }



	if (reportDrHwnd:=getNetControl2(RisState[2],"報告醫師","FID_LABEL","報告醫師","WindowsForms10.STATIC.app","","","",1)[1]) {



		inputbox,reportDrInput,報告VS,,,150,120



		if !errorlevel



			control,choosestring,% (reportDrInput:=trim(reportDrInput))=""?"所有報告醫師":reportDrInput " ",,% "ahk_id " reportDrHwnd



	}



}



return



~^g::



if (RisState[1]=2){



	;~ for k,v in RISarr:=getControls(RisState[2]) {



		;~ if(v.text="撰打住院醫師"){



			;~ reportDrHwnd:=RISarr[k+1].hwnd



			;~ break



		;~ }



	;~ }



	if (reportDrHwnd:=getNetControl2(RisState[2],"撰打住院醫師","FID_LABEL","撰打住院醫師","WindowsForms10.STATIC.app","","","",1)[1]) {



		inputbox,reportDrInput,撰打R,,,150,120



		if !errorlevel



			control,choosestring,% trim(reportDrInput)=""?"所有撰打住院醫師":trim(reportDrInput),,% "ahk_id " reportDrHwnd



	}



}



return



~^h::



if (RisState[1]=2){



	;~ for k,v in RISarr:=getControls(RisState[2]) {



		;~ if(v.text="執行住院醫師"){



			;~ reportDrHwnd:=RISarr[k+1].hwnd



			;~ break



		;~ }



	;~ }



	if (reportDrHwnd:=getNetControl2(RisState[2],"執行住院醫師","FID_LABEL","執行住院醫師","WindowsForms10.STATIC.app","","","",1)[1]) {



		inputbox,reportDrInput,執行R,,,150,120



		if !errorlevel



			control,choosestring,% trim(reportDrInput)=""?"所有執行住院醫師":trim(reportDrInput),,% "ahk_id " reportDrHwnd



	}



}



return



AppsKey::



tmp:=clipboardall



send ^+{left}^c



regexmatch(clipboard,"is)(.+?)(\W*)$",match)



send {bs}%match1%



clipboard:=tmp



return



^numpadenter::



^Enter::



;~ for k,v in RISarr:=getControls(RisState[2])



;~ if (k>3 && RISarr[k-3].text="改派原因" && instr(v.classNN,"WindowsForms10.BUTTON.app.")) {



	;~ ControlClick,,% "ahk_id " v.hwnd



	;~ break



;~ }



controlclick,,% "ahk_id " getNetControl2(RisState[2],"","cmdSearch","","WindowsForms10.BUTTON.app","","","",0)[1]



return



#IfWinActive



!#ctrl::



ifwinactive,UniReport ahk_class TMainForm



{



	wingettitle,str,UniReport ahk_class TMainForm



	clipboard:=str



}else{



	keywait,alt,t1



	if errorlevel



		return



	keywait,lwin,t1



	if errorlevel



		return



	keywait,ctrl,t1



	if errorlevel



		return



	sleep 100



	clipboard=



	send ^c                                                               



	clipwait,1



}



slpwb:=getSlpWb()



if (slpWb.maxIndex() || WinExist("ahk_class MozillaWindowClass"))



	settimer,!#tab1,-100



if (Impax:=ImpaxState)[1]=2



	settimer,^!tab1,-200



return











!#tab::











keywait,alt,t1



if errorlevel



   return



keywait,tab,t1



if errorlevel



   return



keywait,lwin,t1



if errorlevel



   return



sleep 100



clipboard=



send ^c



clipwait,1







if (!regexmatch(clipboard,"\b\w{6}\d\b",match) && winactive("放射線資訊管理系統(Radiology Information System)")) {



	clipboard:=(chartNo:=getRisChartNo(RisState[2]))?chartNo:controlgettext(temp[2])



}







!#tab1:



if !regexmatch(clipboard,"\b\w{6}\d\b",match) {



	return



}



chartNo:=match



queryPageOpened:=0



slpwb:=getSlpWb()



if slpWb.maxIndex(){



	Loop {



		for k,v in slpWb:=getSlpWb() {



			if instr(v.LocationUrl,"WebApplication/OtherIndependentProj/PatientBasicInfoEdit/PatientMedicalRecordListQuery.aspx") {



				queryPageOpened:=1



				while (v.busy) || v.document.getElementsByTagName("INPUT").length<2 {



					Sleep 500



					if(A_Index>10)



						break,2



				}



				



				loop % (inputs:=v.document.getElementsByTagName("INPUT")).length {



					if (inputs[a_index-1].name="NWeb1$PatientBasicInfoQueryByIDAndName1$ctl01"){



				inputs[a_index-1].value:=chartNo



				break



					}



				}



				loop % (inputs:=v.document.getElementsByTagName("INPUT")).length {



					if (inputs[a_index-1].name="NWeb1$PatientBasicInfoQueryByIDAndName1$ctl09"){



				inputs[a_index-1].click()



				break



					}



				}



				Loop



				sleep 200



				until !v.busy



				v.document.getElementById("NWeb1_PatAccountListRecord1_ButtonWebEMR").click()



				break



			}



		}



		



		if(!queryPageOpened){



			for k,v in slpWb:=getSlpWb() {



				if InStr(v.LocationUrl, ".hospital-n.local") {



					js=javascript:b=document.selection.createRange().text;b=b.match(/(?:\w)\w{5}\d/);a=location.href.match(/[\?&](SESSION=[^=&]+)&?/i);if(!a){a=document.documentElement.innerHTML.match(/(SESSION=[a-zA-Z0-9]+)/i);}if(a){o=open('http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/PatientMedicalRecordListQuery.aspx?QueryBySelf=N&'+a[1]);o.onload=function(){if(!b){return 0}o.document.all('NWeb1$PatientBasicInfoQueryByIDAndName1$ctl01').value=b;o.document.all('NWeb1$PatientBasicInfoQueryByIDAndName1$ctl09').click();}}else{open('http://portal.hospital-n.local/General/Login.aspx');alert('Log in Portal first!');}void 0;



					v.Navigate(js)



					Sleep 1000



					break



				}



			}



		}



		



	}until queryPageOpened



	winactivate,ahk_class SleipnirMainWindow



}else if WinExist("ahk_class MozillaWindowClass"){



	Send_WM_COPYDATA(WinExist("ahk_exe FirefoxLoginApp.exe"), 0, jxon_dump({"searchChartNo": chartNo}))



	winactivate,ahk_class MozillaWindowClass



}



return











checkExam:



if RisState[1]!=2



	return



for k,v in risControls:=getcontrols(risstate[2]) {



	if (instr(v.text,"下筆") && instr(v.classNN,"WindowsForms10.BUTTON")) {



		temp:=k



		break



	}



}



for k,v in risControls {



	if (v.text="Exam." && instr(risControls[k+1]["classNN"],"WindowsForms10.EDIT.app") && abs(k-temp)<13) {



		controlgettext,examText,,% "ahk_id " risControls[k+1]["hwnd"]



		break



	}



}



examTextTransform(examText)



return



examTextTransform(str){



	t:="",numbering:=false,ind:=0,



	loop,parse,str,`n,`r



	{



		if(regexmatch(a_loopfield,"is)^(\d)[^\d\w]?\s*?(.*)",m)){



		}



	}



}



^!t::



ifwinexist,Convert first word



return



gui, 2: +lastfound



gui2hwnd:=winexist()



gui, 2: font,s10,Verdana



gui, 2: add,edit,w800 h600 vreport hwndreportEditHwnd



gui, 2: add,edit,r1 w20 vfirstword,1



gui, 2: add,button,x+5 yp gConvertFirstWord,Convert



gui, 2: add,button,x+5 yp gCopyPaste,% "Copy && Paste"



gui, 2: show,w850 h650,Convert first word



return



CopyPaste:



clipboard:=""



controlgettext,clipboard,,% "ahk_id " reportEditHwnd



clipwait,1



winactivate,% "ahk_id " RisState[2]



winwaitactive,% "ahk_id " RisState[2],,1



send ^v



return



ConvertFirstWord:



gui, 2: submit,NoHide



firstword:=trim(firstword)



if !regexmatch(firstword,"\d+")



{



	report:=regexreplace(report,"\n\d+.\s*","`n" firstword " ")



}else{



	ind:=0



	while ind:=regexmatch(report,"\n[^\s\w\(\[]+(.|\)|\s+)\s*",match,ind+1)



	{



		report:=regexreplace(report,match,"`n" a_index ". ","",1,ind)



	}



}



guicontrol, 2: ,report,% report



guicontrol, 2: focus,report



sendmessage,0xB1,0,-1,, ahk_id %reportEditHwnd%



return



2GUIClose:



gui, 2: destroy



return



#ifwinactive,Convert first word



~esc::



gui, 2: destroy



return



#ifwinactive



:*:pxy1::proxy.hospital-n.local{tab}3128



:*:a;::



input,code,i L2 T1 V *



if(code+0!=a_min+mod(a_hour,12)){



	send a;



	return



}



;~ keywait,enter



;~ sleep 100



loop % strlen(code)



	send {bs}



send {alt down}{numpad1}{numpad0}{numpad9}{alt up}{alt down}{numpad1}{numpad0}{numpad3}{alt up}{alt down}{numpad1}{numpad1}{numpad2}{alt up}{alt up}{alt down}{numpad1}{numpad1}{numpad5}{alt up}{alt up}{alt down}{numpad1}{numpad1}{numpad0}{alt up}{alt up}{alt down}{numpad1}{numpad2}{numpad2}{alt up}



return















::;rp::radiopaedia



::;rg::radiographics



::;ra::radiology assistant



::;lr::learning radiology



::;conct::Please send consult sheet and patient stickers to CT room for scheduling. Thanks.



::;conan::Please send consult sheet and patient stickers to angioroom for scheduling. Thanks.



::;cns::We were consulted for



::qov0::kenbo_14586298



:*:s2g::scsnake@gmail.com



:*:b2n::user@hospital-n.local



::scss::scsnake



:*:mdlb::medlib@hospital-n.local{tab}MOCK_PASSWORD{enter}



::ahkk::autohotkey



:*:ych1::YCH1{tab}YCH1{enter}







commandArr:



commandArr:=[]



commandArr["note"]:=root "\software\Notepad++\notepad++.exe"



commandArr["scite"]:=root "\scripts\Autohotkey\SciTE\SciTE.exe"



commandArr["script"]:=root "\scripts\"



commandArr["lib"]:=root "\scripts\Autohotkey\Lib\"



commandArr["word"]:=(fileexist(path:=a_mydocuments "\Office 2010 Portable\WINWORD.EXE")?path:root "\software\Office 2010 Portable\WINWORD.EXE")



commandArr["access"]:=(fileexist(path:=a_mydocuments "\Office 2010 Portable\MSACCESS.EXE")?path:root "\software\Office 2010 Portable\MSACCESS.EXE")



commandArr["excel"]:=(fileexist(path:=a_mydocuments "\Office 2010 Portable\EXCEL.EXE")?path:root "\software\Office 2010 Portable\EXCEL.EXE")



commandArr["ppt"]:=(fileexist(path:=a_mydocuments "\Office 2010 Portable\POWERPNT.EXE")?path:root "\software\Office 2010 Portable\POWERPNT.EXE")



commandArr["office"]:=root "\software\Office 2010 Portable\"



commandArr["vfss"]:=root "\scripts\VFSS2\"



commandArr["chm"]:=root "\scripts\Autohotkey\AutoHotkey.chm"



commandArr["spy"]:=root "\scripts\Autohotkey\AU3_Spy.exe"



commandArr["seah"]:=root "\software\Sleipnir\plugins\seahorse\"



commandArr["seah1"]:=A_MyDocuments "\scsnake\Sleipnir\plugins\seahorse\"



;~ commandArr["liu"]:=root "\software\XLiu\Xliu.exe"



commandArr["autorun"]:=root "\scripts\Autorun\"



commandArr["wjl"]:=ahkMain " " root "\scripts\Radiology\WJL.ahk"



commandArr["YCH"]:=ahkMain " " root "\scripts\Radiology\YCH.ahk"



commandArr["YCHm"]:=root "\scripts\Autohotkey\SciTE\SciTE.exe " root "\scripts\Radiology\YCH_main.ahk"



commandArr["YCHe"]:=root "\scripts\Autohotkey\SciTE\SciTE.exe " root "\scripts\Radiology\YCH.ahk"



commandArr["YCHx"]:=root "\scripts\Autohotkey\SciTE\SciTE.exe " root "\scripts\Radiology\YCH_XR.ahk"



commandArr["YCHmm"]:=root "\scripts\Autohotkey\SciTE\SciTE.exe " root "\scripts\Radiology\YCH_mammo.ahk"



commandArr["YXR"]:=ahkMain " " root "\scripts\Radiology\YCH_XR.ahk"



commandArr["BMD"]:=ahkMain " " root "\scripts\Radiology\YCH_BMD.ahk"



commandArr["CXR"]:=ahkMain " " root "\-----------R3\chest\AutoHotkey_chest\Chest_CXJ.ahk"



commandArr["brus"]:=ahkMain " " root "\-----------R3\chest\AutoHotkey_chest\breast_CXJ.ahk"



;~ commandArr["mamm"]:=ahkMain " " root "\-----------R3\chest\AutoHotkey_chest\CUCmammo.ahk"



commandArr["mamm"]:=ahkMain " " root "\scripts\Radiology\YCH_mammo.ahk"



commandArr["chrome"]:=root "\software\GoogleChromePortable\GoogleChromePortable.exe --proxy-server=proxy.hospital-n.local:3128"



commandArr["pcman"]:=root "\software\PCMan Combo\PCMan.exe"



commandArr["firefox"]:=a_desktop "\FirefoxLogin.lnk"



;~ commandArr["chrome"]:=root "\software\ChromePlusPortable\chrome.exe"



;~ commandArr["msn"]:=root "\software\MSN 8.5\msnmsgr.exe"



commandArr["7z"]:=root "\software\7-Zip\"



commandArr["tshark"]:=root "\software\tshark\"



commandArr["server"]:=root "\software\TWAMPd\"



commandArr["cmd"]:=root "\software\PowerCmd\PowerCmd.exe"



commandArr["teamviewer"]:=root "\software\TeamViewerPortable\TeamViewer.exe"



commandArr["ugi"]:=ahkMain " " root "\scripts\Radiology\YCH-UGI.ahk"



commandArr["hct"]:=ahkMain " " root "\scripts\Radiology\YCH-HCT.ahk"



commandArr["info"]:=root "\scripts\AHK_Window_Info_v1.7.exe"



commandArr["nginx"]:=root "\software\WNMP\"



commandArr["diff"]:=root "\scripts\Radiology\diffReport.exe"



commandArr["case"]:=(fileexist(path:=a_mydocuments "\Office 2010 Portable\EXCEL.EXE")?path " ":root "\software\Office 2010 Portable\EXCEL.EXE ") """" root "\case list.xlsx"""



commandArr["pdf"]:=root "\software\PDF-XChange Viewer\PDFXCview.exe"



commandArr["ftp"]:=root "\software\FileZillaPortable\FileZillaPortable.exe"



commandArr["icon"]:=root "\scripts\IconChanger\IconChangerMain.exe"



commandArr["simple"]:=root "\scripts\Radiology\AntiImpaxFlash.exe"



commandArr["type"]:=root "\scripts\Radiology\RisTyper\RisTyper.exe"



commandArr["rfa"]:=root "\scripts\Radiology\RFA note.exe"



commandArr["nhi"]:=root "\scripts\Radiology\NHIform"



commandArr["radtem"]:=root "\scripts\Radiology\RadTemplate\RadTemplate.exe"



commandArr["reg"]:=root "\software\RegAlyzerPortable\RegAlyzerPortable.exe"



commandArr["pIE"]:=root "\scripts\Radiology\PacsIE\PacsIEMain.exe"



commandArr["feed"]:=root "\scripts\Radiology\PacsIE\feedRIS.exe"



commandArr["ahks"]:=ahkMain " " root "\scripts\Autohotkey\AHKStudio\AHKStudio.ahk"



commandArr["vnc"]:=root "\scripts\RemoteList\UltraVNC_List.exe"



commandArr["msr"]:=root "\scripts\Radiology\MammoSR\MammoSR.exe"















return



listProcess(){



	d := "  |  "



	s := 4096



	Process, Exist



	h := DllCall("OpenProcess", "UInt", 0x0400, "Int", false, "UInt", ErrorLevel, "Ptr")



	DllCall("Advapi32.dll\OpenProcessToken", "Ptr", h, "UInt", 32, "PtrP", t)



	VarSetCapacity(ti, 16, 0)



	NumPut(1, ti, 0, "UInt")



	DllCall("Advapi32.dll\LookupPrivilegeValue", "Ptr", 0, "Str", "SeDebugPrivilege", "Int64P", luid)



	NumPut(luid, ti, 4, "Int64")



	NumPut(2, ti, 12, "UInt")



	r := DllCall("Advapi32.dll\AdjustTokenPrivileges", "Ptr", t, "Int", false, "Ptr", &ti, "UInt", 0, "Ptr", 0, "Ptr", 0)



	DllCall("CloseHandle", "Ptr", t)



	DllCall("CloseHandle", "Ptr", h)



	hModule := DllCall("LoadLibrary", "Str", "Psapi.dll")



	s := VarSetCapacity(a, s)



	c := 0



	DllCall("Psapi.dll\EnumProcesses", "Ptr", &a, "UInt", s, "UIntP", r)



	Loop, % r // 4



	{



		id := NumGet(a, A_Index * 4, "UInt")



		h := DllCall("OpenProcess", "UInt", 0x0010 | 0x0400, "Int", false, "UInt", id, "Ptr")



		if !h



			continue



		VarSetCapacity(n, s, 0)



		e := DllCall("Psapi.dll\GetModuleBaseName", "Ptr", h, "Ptr", 0, "Str", n, "UInt", A_IsUnicode ? s//2 : s)



		if !e



			if e := DllCall("Psapi.dll\GetProcessImageFileName", "Ptr", h, "Str", n, "UInt", A_IsUnicode ? s//2 : s)



			SplitPath n, n



		DllCall("CloseHandle", "Ptr", h)



		if (n && e)



			l .= n . d, c++



	}



	DllCall("FreeLibrary", "Ptr", hModule)



	return array(l,c)



}



GetModuleFileNameEx( p_pid )



{



	h_process := DllCall( "OpenProcess", "uint", 0x10|0x400, "int", false, "uint", p_pid )



	if ( ErrorLevel or h_process = 0 )



		return



	name_size = 255



	VarSetCapacity( name, name_size )



	result := DllCall( "psapi.dll\GetModuleFileNameExA", "uint", h_process, "uint", 0, "str", name, "uint", name_size )



	DllCall( "CloseHandle", h_process )



	return, name



}











RisHistoryBreakline:



for breakLineControlKey,breakLineControlValue in breakLineControls



	if breakLineControl:=getNetControl2(risState[2],"",breakLineControlValue,"","WindowsForms10.EDIT","","","",0)[1] 



		acc_objectfromwindow(breakLineControl).accValue:=RegExReplace(RegExReplace(controlgettext(breakLineControl),"\r|\n","€"),"€+","`r`n")



return







getFocused(){



	static GuiThreadInfoSize = 48



	VarSetCapacity(GuiThreadInfo, GuiThreadInfoSize)



	NumPut(GuiThreadInfoSize, GuiThreadInfo, 0)



	DllCall("GetGUIThreadInfo", uint, 0, str, GuiThreadInfo)



	return FocusedHWND := NumGet(GuiThreadInfo, 12)



}











;~ ~ctrl::



;~ mousegetpos,x,y



;~ if (x>=firstMonitorLeft&&x<=firstMonitorRight && y>=firstMonitorTop&&y<=firstMonitorBottom)



	;~ mouseBoundaryLimit:=[firstMonitorLeft,firstMonitorRight,firstMonitorTop,firstMonitorBottom]



;~ else if(x>=lastMonitorLeft&&x<=lastMonitorRight && y>=lastMonitorTop&&y<=lastMonitorBottom)



	;~ mouseBoundaryLimit:=[lastMonitorLeft,lastMonitorRight,lastMonitorTop,lastMonitorBottom]



;~ else 



	;~ mouseBoundaryLimit:=[firstMonitorRight+1,lastMonitorLeft-1,lastMonitorTop,lastMonitorBottom]



;~ hHookMouse2 := SetWindowsHookEx(WH_MOUSE_LL:= 14, RegisterCallback("MouseHook2", "Fast"))



;~ settimer,cyclicMonitor,off



;~ return







;~ ~ctrl up::



;~ UnhookWindowsHookEx(hHookMouse2)



;~ settimer,cyclicMonitor,200



;~ return











;~ MouseHook2(nCode, wParam, lParam){



	;~ static lx,ly



	;~ global mouseBoundaryLimit



	;~ Critical



	;~ }



	;~ If nCode || !(wParam = 0x200)



		;~ return CallNextHookEx(nCode, wParam, lParam)



	;~ VarSetCapacity(lpPoint,8)



	;~ ,DllCall("GetCursorPos", "Uint", &lpPoint)



	;~ ,mx := NumGet(lParam+0, 0, "Int")



	;~ ,my := NumGet(lParam+0, 4, "Int")



	;~ ,mx:=mx<mouseBoundaryLimit[1]?mouseBoundaryLimit[1]:mx



	;~ ,mx:=mx>mouseBoundaryLimit[2]?mouseBoundaryLimit[2]:mx



	;~ ,my:=my<mouseBoundaryLimit[3]?mouseBoundaryLimit[3]:my



	;~ ,my:=my>mouseBoundaryLimit[4]?mouseBoundaryLimit[4]:my



	;~ ,DllCall("SetCursorPos", "Int", mx, "Int", my)



	;~ ,NumPut(mx, lParam+0, 0, "Int")



	;~ ,NumPut(my, lParam+0, 4, "Int")



	;~ return 1



;~ }











#ifwinactive AutoHotkey Help ahk_exe SciTE.exe



esc::



WinClose,AutoHotkey Help ahk_exe SciTE.exe



return



#ifwinactive



#ifwinactive AutoHotkey_L Help ahk_exe SciTE.exe



esc::



WinClose,AutoHotkey_L Help ahk_exe SciTE.exe



return



#ifwinactive











#j::



mousegetpos,x,y,win,conC



mousegetpos,,,,con,2



clipboard:=listcontrols(win)



msgbox % conC ", " con



return







#p::



gosub getChartNo



run % root "\scripts\Radiology\updateOpPatho\searchPatho.exe " chartNo



return







getChartNo:



chartNo:=""



if winactive("ahk_id " RisOpened()[2]) && rChartNo:=getRisChartNo(RisOpened()[2])



	chartNo:=rChartNo



if !chartNo && winactive("ahk_id " ImpaxOpened()[2,1]) && iChartNo:=getImpaxChartNo(ImpaxOpened()[2])



	chartNo:=iChartNo



if !chartNo && regexmatch(clipboard,"\b\w{6}\d\b",match)



	chartNo:=match







if !chartNo {



	msgbox,,,Failed to get chart No.,3



	goto fail



}







return







#i::



gosub getChartNo



ip:="http://10.0.0.100:8042/"



;~ chartNo:="3______"







examDate:=getRisExamDate(RisOpened()[2])



dateStr:=SubStr(examDate,1,4) SubStr(examDate,6,2) SubStr(examDate,9,2)











httprequest(url:=ip "patients/" SHA1dash(chartNo),post:="",header:="","charset: utf-8")



if !post



	goto fail







patient:=json_from(post)



url:="",processed:=0



Loop % patient.studies.maxindex() {



	httprequest(ip "studies/" patient.studies[A_Index],post:="",header:="","charset: utf-8") 



	if !post



		continue



	study:=json_from(post)



	if(study.MainDicomTags.StudyDate=dateStr){



		Loop % study.series.maxindex() {



			httprequest(ip "series/" study.series[A_Index],post:="",header:="","charset: utf-8") 



			if(!post)



				continue



			series:=json_from(post)



			;~ else if ()



			if(series.MainDicomTags.SeriesDescription="Evidence Documents MM Oncology Reading"){



				processed:=1



			}else if(series.MainDicomTags.SeriesDescription="Results MM Oncology Reading" || series.MainDicomTags.SeriesDescription="Hologic R2 ImageChecker CAD SC"){



				clipboard:=url:=ip "web-viewer/app/viewer.html?series=" study.series[A_Index]



				break 2



			}



			



		}



	}



}



if(url=""){



	if(processed)



		goto noResult



	else



		goto fail



}	







;~ test:



;~ clipboard:=url:=ip:="http://www.yahoo.com.tw/"







ifwinexist,ahk_class MozillaWindowClass



	winactivate



else ifwinexist,ahk_class Chrome_WidgetWin_1



	WinActivate



else



	goto openNewChromeOrFirefox







winwaitactive,,,2



if(ErrorLevel)



	return







if !InStr(activeUrl:=GetActiveBrowserURL(),ip) && activeUrl!="" {



	send ^t



	Sleep 100



}



send !d



sleep 100



send ^v



sleep 100



send {enter}



recoverClip:



;~ clipboard:=pClip



;~ ExitApp



return







openNewChromeOrFirefox:



appPath:=""



Loop,% a_desktop "\*.lnk"



	if InStr(A_LoopFileName, "firefox"){



		FileGetShortcut,% A_LoopFileFullPath, appPath



		break



	}



if(appPath!=""){



	run % """" appPath """ """ url """"



	return



}



Loop,% A_DesktopCommon "\*.lnk"



	if InStr(A_LoopFileName, "firefox"){



		FileGetShortcut,% A_LoopFileFullPath, appPath



		break



	}



if(appPath!=""){



	run % """" appPath """ """ url """"



	return



}



Loop,% a_desktop "\*.lnk"



	if InStr(A_LoopFileName, "chrome"){



		FileGetShortcut,% A_LoopFileFullPath, appPath



		break



	}



if(appPath!=""){



	run % """" appPath """ """ url """"



	return



}



Loop,% A_DesktopCommon "\*.lnk"



	if InStr(A_LoopFileName, "chrome"){



		FileGetShortcut,% A_LoopFileFullPath, appPath



		break



	}



if(appPath!=""){



	run % """" appPath """ """ url """"



	return



}



MsgBox % "Please open Firefox or Chrome first!"



return







noResult:



MsgBox,,,% "No lesion found by CAD",3



goto recoverClip



return







fail:







settimer,dcmqr,-1



goto recoverClip



return











dcmqr:



if !IsObject(dcmRAID)



	dcmRAID:=new dcm4che(), dcmSyngovia:= new dcm4che("SYNGOVIA")



;~ MsgBox % dcmRAID.root "," dcmRAID.dcmqrPath



seriesInfoSyngovia:=dcmSyngovia.getSeriesInfo(thisAccNo:=getRisAccNo(RisState[2]))



;~ MsgBox % seriesInfo.maxindex()



if(seriesInfoSyngovia.maxindex()>0){



	MsgBox,,,Not processed yet in Syngovia!,3



	return



}



	



seriesInfo:=dcmRAID.getSeriesInfo(thisAccNo)



if(seriesInfo.maxindex()<1){



	msgbox,,,Not found in RAID!,3



	return



}



gui,dcmqr:Default



gui,destroy



for k,v in seriesInfo {



	;~ MsgBox % v.SeriesDescription



	gui,Add,Checkbox,% "vdcmqrCb" k " w400 " (v.InstanceCount>300?"checked":""),% v.SeriesDescription " (" v.InstanceCount ")"



}



gui,Add,button,gdcmqrSubmit,to Syngovia



gui,show,AutoSize,Select series



return







dcmqrSubmit:



gui,Submit



for k,v in seriesInfo {



	if (dcmqrCb%k%)



		dcmRAID.Move([v.SeriesUID], "SYNGOVIA")



}







return















SHA1dash(str){



	str:=SHA(str)



	stringlower,str,str



	return substr(str,1,8) "-" substr(str,9,8) "-" substr(str,17,8) "-" substr(str,25,8) "-" substr(str,33,8)



}















impaxContextServer:



;~ return ;pauseThread



;~ Sleep 5000



if !winexist("ahk_exe ImpaxContextServer.exe") {



	if  FileExist(path:=root "\scripts\Radiology\MammoSR\ImpaxContextServer\ImpaxContextServer.exe")



		|| FileExist(path:=root "\send string by windows message\bin\Release\ImpaxContextServer.exe")



		|| fileexist(path:=A_ScriptDir "\ImpaxContextServer.exe")



		|| fileexist(path:=A_ScriptDir "\ImpaxContextServer\ImpaxContextServer.exe")



		||  fileexist(path:=a_mydocuments "\ImpaxContextServer\ImpaxContextServer.exe") 



		contextServerPath:=path



	run % contextServerPath



}



winwait,ahk_exe ImpaxContextServer.exe,,5



winminimize,ahk_exe ImpaxContextServer.exe



;~ winactivate,% "ahk_id " RisOpened()[2]



;~ msgbox % winexist("ImpaxContextServer.exe")



;~ cmdContextServer(loginId loginPw)



return











UIAutomationServer:



;~ return ;pauseThread



if !winexist("ahk_exe UIAutomationServer.exe") {



	if fileexist(path:=a_mydocuments "\UIAutomationServer\UIAutomationServer.exe")



		|| FileExist(path:=A_ScriptDir "\UIAutomationServer\UIAutomationServer.exe")



		|| FileExist(path:=A_ScriptDir "\UIAutomationServer.exe")



		|| FileExist(path:=root "\UIAutomationServer\UIAutomationServer\UIAutomationServer\bin\Release\UIAutomationServer.exe")



		UIAutomationServerPath:=path



	else 



		UIAutomationServerPath:=root "\UIAutomationServer\UIAutomationServer\UIAutomationServer\bin\Release\UIAutomationServer.exe"



	run % UIAutomationServerPath



}







;~ winactivate,% "ahk_id " RisOpened()[2]



return







;~ ~ctrl::



;~ if(A_PriorHotkey = A_ThisHotkey && A_TimeSincePriorHotkey<500){



	;~ SendLevel,3



	;~ send {ctrl up}{Left}{Right}



;~ }



;~ return







:*b0:.,::



xetf:



keyboardLayout:=["1qaz!","2wsx@","3edc#","4rfv$","5tgb%","6yhn^","7ujm&","8ik,*","9ol.(","0p;/)"]



;~ kw:=$.value(2)



;~ code:=$.value(1)



input,en,T5 L4 i * V



if !RegExMatch(en,"i)(\w\w)(\d\d)", match)



	return



kw:=match1, code:=match2



if(code+0!=a_min+mod(a_hour,12))



	return



input,ed,T1 L3 i * V



if(ed!="/.,"){



	;~ send % $.value(0)



	return



}



;~ keywait,enter



;~ sleep 100



;~ loop % strlen(code)



	;~ send {bs}



send {bs 9}



str1:=str2:=""



stringupper,kw,kw



Loop,parse,kw



{



	ch:=A_LoopField



	for k,v in keyboardLayout



		if InStr(v,ch){



			str1.=SubStr(v,1,1), str2.=SubStr(v,0,1)



			break



		}



}



Sleep 50



send:=kw str2 str1



Loop,parse,Send



{



	send % "{" A_LoopField " down}{" A_LoopField " up}"



	Sleep 10



}



send {alt down}{numpad1}{numpad0}{numpad9}{alt up}{alt down}{numpad1}{numpad0}{numpad3}{alt up}{alt down}{numpad1}{numpad1}{numpad2}{alt up}{alt up}{alt down}{numpad1}{numpad1}{numpad5}{alt up}{alt up}{alt down}{numpad1}{numpad1}{numpad0}{alt up}{alt up}{alt down}{numpad1}{numpad2}{numpad2}{alt up}







return







:*:.,.,::



send {lwin up}{RWin up}{shift up}{ctrl up}{alt up}



return







^!+#r::



Reload



return











:*:qz13::



send % loginId



send {tab}



send % loginPw



send {Enter}



return