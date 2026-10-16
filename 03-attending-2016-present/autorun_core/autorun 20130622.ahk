﻿#NoEnv
#SingleInstance,force
SetBatchLines,-1
DetectHiddenWindows, On
SetTitleMatchMode,2
coordmode,mouse,screen
#NoTrayIcon
#include <Acc>
#include <.NetGetControl>

IMPAX_id:=loginId
IMPAX_pw:=loginPw
RIS_id:=loginId
RIS_pw:=loginPw
IMPAX_title:="IMPAX 6.5.2.114 Radiologist with QC"
RisName:="陳醫師"
imageWinToggle=1
RegExMatch(a_scriptdir,"^[^\\]*",root)

onexit,onexit
;~ OnMessage(0x200, "WM_MOUSEMOVE")

gui,+lastfound
winget,guiHWND,id

gui,add,edit,vcommands,
gui,add,button,gterminateUSBprocess,Unmount USB
gui,show,w300 h100,Enter command ...


process,close,AgfaDTIWatchDog.exe
process,close,AgfaDTIBridge.exe


openedWindows:=object()
hiddenWindows:=[]


autofocus=1

setTimer,killUpdate,500
setTimer,noIdle,540000
settimer,autofocus,200
settimer,checkExam,-1

return

~^!z::
if !(a_priorhotkey=a_thishotkey && A_TimeSincePriorHotkey<300)
    return
tooltip,% "Autofocus " ((autofocus:=!autofocus)?"":"de") "activated!"
sleep 1000
tooltip
return 

autofocus:
risState:=risOpened(),impaxState:=impaxOpened()
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




; deprecatedd
AppsKey:
if ImpaxState[1]!=2
	return  
winget,list,list,ahk_class WindowsForms10.Window.8.app.0.2bf8098

loop % list {
	for k,v in getControls(list%a_index%)
		if (instr(v.text,"BMP_SERIES_MODE") && instr(v.classNN,"WindowsForms10.BUTTON.app")) {
			;~ controlclick,,% v.hwnd 
			;~ controlsend,,{lbutton},% v.hwnd
			loc:=Acc_Location(acc_objectfromwindow(v.hwnd))
			;~ controlclick,% "x" loc.x-1200+5 " y" loc.y+5,% list%a_index%
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
;~ for k,v in risControls {
	;~ if v.text="Exam." && instr(risControls[k+1]["classNN"],"WindowsForms10.EDIT.app") && risControls[k+3]["text"]="Impression" {
		;~ ControlFocus,,% "ahk_id " risControls[k+1]["hwnd"]
        ;~ break
	;~ }
;~ }

return

killUpdate:
ifwinexist,Sleipnir ahk_class #32770,Latest version of Sleipnir
   controlclick,Button2,Sleipnir ahk_class #32770,Latest version of Sleipnir
ifwinexist,SciTE4AutoHotkey Updater ahk_class #32770
   controlclick,Button2,SciTE4AutoHotkey Updater ahk_class #32770
return

parse_commands:
gui,submit,nohide
loop,parse,commands,`,
{
   command:=trim(a_loopfield)
   if(!command)
      continue
   
   if command=note
   {
      run,% root "\software\Notepad++\unicode\notepad++.exe"
   }
   else if command=slp
   {
      gosub run_slp
      settimer,run_slp,3000
   }
   else if command=scite
   {
      run,% root "\scripts\Autohotkey\SciTE\SciTE.exe"
   }
   else if command=script
   {
      run,% root "\scripts\"
   }
   else if command=word
   {
      run,% root "\software\Office 2007 portable (win7可用)\WINWORD.EXE"
   }
   else if command=excel
   {
      run,% root "\software\Office 2007 portable (win7可用)\EXCEL.EXE"
   }
   else if command=ppt
   {
      run,% root "\software\Office 2007 portable (win7可用)\POWERPNT.EXE"
   }
   else if command=office
   {
      run,% root "\software\Office 2003 SP3\"
   }
   else if command=vfss
   {
      run,% root "\scripts\VFSS2\"
   }
   else if command=chm
   {
      run,% root "\scripts\Autohotkey\AutoHotkey.chm"
   }
   else if command=spy
   {
      run,% root "\scripts\Autohotkey\AU3_Spy.exe"
   }
   else if command=seah
   {
      run,% root "\software\Sleipnir\plugins\seahorse\"
   }
   else if command=liu
   {
      run,% root "\software\XLiu\Xliu.exe"
   }
   else if command=autorun
   {
      run,% root "\scripts\Autorun\"
   }
   else if command=YCH
   {
      run,% root "\scripts\Autohotkey\AutoHotkey.exe " root "\scripts\Radiology\YCH.ahk"
   }
   else if command=chrome
   {
      run,% root "\software\ChromePlusPortable\chrome.exe"
   }
   else if command=pcman
   {
      run,% root "\software\PCManBBI Portable\PCMan.exe"
   }
   else if command=firefox
   {
      run,% root "\software\FirefoxPortable\FirefoxPortable.exe"
   }
   else if command=chrome
   {
      run,% root "\software\ChromePlusPortable\chrome.exe"
   }
   else if command=msn
   {
      run,% root "\software\MSN 8.5\msnmsgr.exe"
   }
   else if command=7z
   {
      run,% root "\software\7-Zip\"
   }
   else if command=tshark
   {
      run,% root "\software\tshark\"
   }
   else if command=server
   {
      run,% root "\software\TWAMPd\"
   }
   else if command=cmd
   {
      run,% root "\software\PowerCmd\PowerCmd.exe"
   }
   else if command=teamviewer
   {
      run,% root "\software\TeamViewerPortable\TeamViewer.exe"
   }
   ;~ else if command=noidle
   ;~ {
      ;~ run,% root "\scripts\Radiology\noIdle.exe"
   ;~ }
   else if command=pdf
   {
      run,% root "\software\PDF-XChange Viewer\PDFXCview.exe"
   }
   else if command=ugi
   {
      run,% root "\scripts\Autohotkey\AutoHotkey.exe " root "\scripts\Radiology\YCH-UGI.ahk"
   }
   else if command=hct
   {
      run,% root "\scripts\Autohotkey\AutoHotkey.exe " root "\scripts\Radiology\YCH-HCT.ahk"
   }
   else if command=boneage
   {
      run,% root "\scripts\bone_age\boneage report.exe"
      IfWinNotExist,Skeletal Development of the Hand and Wrist - A Radiographic Atlas and Digital Bone Age Companion
         run,% root "\R2\PED\Skeletal Development of the Hand and Wrist - A Radiographic Atlas and Digital Bone Age Companion.pdf"
   }
   else if command=quiz
   {
      run,% root "\scripts\Radiology\quiz.exe"
   }
   else if command=info
   {
      run,% root "\scripts\AHK_Window_Info_v1.7.exe"
   }
   else if command=nginx
   {
      run,% root "\software\WNMP\"
   }
   else
   {
      ;~ traytip,,No such command...,5
      run, % command
   }
}
guicontrol,,commands,% ""
return

#ifwinactive,Enter command
~NumpadEnter::
~Enter::
;~ IfWinActive,ahk_id %guiqHWND%
   gosub parse_commands
return
#IfWinActive

#ifwinactive,臨床報告
~esc::
WinGetClass,winClass,A
if !instr(winClass,"WindowsForms10.Window.8.app")
	return
send !{F4}
return
#IfWinActive


~rbutton::
if !(a_thishotkey=a_priorhotkey && A_TimeSincePriorHotkey<300 && GetKeyState("RButton","P")) {
	return 
}
;~ wingettitle,activeWin,,A
mousemove,-1,-1,0,R
mousegetpos,,,activeWin
wingetTitle,activeWinTitle,% "ahk_id " activeWin
keywait,rbutton
if (instr(activeWinTitle,"放射線資訊管理系統(Radiology Information System)") || instr(activeWinTitle,"DisplayMenuForm")) {
	mouseclick,l,-2,-2,1,0,,r
	mouseclick,r,2,2,1,0,,r
	mouseclick,l,5,5,1,0,,r
	;~ send {click 5,5 relative}
}else if (instr(activeWinTitle,"IMPAX 6.5.2.114")) {
	mouseclick,l,21,50,1,0,,r
	;~ send {click 21,46 relative}
}
return





#ifwinactive,ahk_class WindowsForms10.Window.8.app.0.2bf8098
;press ` toggle text and image
`::
toggleImageText:
if ImpaxState[1]!=2
   return
winget,activeWin,id,A
state=0
if (activeWin=ImpaxState[2,1]) {
    for k,v in (impaxControls:=getcontrols(ImpaxState[2,1])){
        if (v.text="文字" || v.text="Text") && instr(v.ClassNN,"WindowsForms10.BUTTON") {
            controlclick,,% "ahk_id " v.hwnd
			state=1
            break
        }
    }
}else if (!state) {
    for k,v in (impaxControls:=getcontrols(ImpaxState[2,2])){
        if (v.text="文字" || v.text="Text" || v.text="影像" || v.text="Image") && instr(v.ClassNN,"WindowsForms10.BUTTON") {
            controlclick,,% "ahk_id " v.hwnd
			state=1
            break
        }
    }
}else if(!state) {
	winget,list,list,ahk_class WindowsForms10.Window.8.app.0.2bf8098
	loop % list {
		id:=list%a_index%
		wingettitle,title,ahk_id %id%
		if(title!="")
			continue
		
		for k,v in (impaxControls:=getControls(id)) {
			if (v.text="文字" || v.text="Text" || v.text="影像" || v.text="Image") && instr(v.ClassNN,"WindowsForms10.BUTTON") {
				controlclick,,% "ahk_id " v.hwnd
				state=1
				break
			}
		}
	}
}
    
    
    
return





;press tab to toggle image series
tab::
if ImpaxState[1]!=2
   return
winget,activeWin,id,A
if (activeWin=ImpaxState[2,1]) {
    for k,v in (impaxControls:=getcontrols(ImpaxState[2,1])){
        if v.text="BMP_VIRTUAL_SCREEN_BUTTON" && instr(v.ClassNN,"WindowsForms10.BUTTON") {
            controlclick,,% "ahk_id " v.hwnd
            break
        }
    }
}else {
    for k,v in (impaxControls:=getcontrols(ImpaxState[2,2])){
        if v.text="BMP_VIRTUAL_SCREEN_BUTTON" && instr(v.ClassNN,"WindowsForms10.BUTTON") {
            controlclick,,% "ahk_id " v.hwnd
            break
        }
    }
}

return




;press enter to select chart no edit control
~numpadenter::
~enter::
if ImpaxState[1]!=2
   return
IfWinNotActive,% "ahk_id " impaxState[2,2]
	return
selectChartNo:
Winactivate,% "ahk_id " ImpaxState[2,2]
for k,v in (impaxControls:=getcontrols(ImpaxState[2,2])){
    if k<2
        continue
    if instr(v.classNN,"WindowsForms10.EDIT.app") && ((impaxControls[k-1].text="病歷號碼" && impaxControls[k+2].text="檢查之日期") || (impaxControls[k-1].text="Patient ID" && impaxControls[k+2].text="Study Date")) {
        controlfocus,,% "ahk_id " impaxChartnoControl:=v.hwnd
        controlget,selectedText,Selected,,,% "ahk_id " impaxChartnoControl
        if !selectedText
         ControlClick,,% "ahk_id " impaxChartnoControl,,l,1
        ;~ controlsend,,{home}+{end},% "ahk_id " v.hwnd
        break
   }
}



return
f1::
if ImpaxState[1]!=2
   return
bar:=ImpaxBar(ImpaxState[2,2])
if(!bar.hwnd){
	gosub toggleImageText
	WinWaitActive,IMPAX ahk_class WindowsForms10.Window.8.app.0.2bf8098,,5
	gosub toggleImageText
	loop {
		wingettitle,activeTitle,A
		wingetclass,activeClass,A
		if(activeTitle="" && activeClass="WindowsForms10.Window.8.app.0.2bf8098")
			break
	}
	bar:=ImpaxBar(ImpaxState[2,2])
}

wingetpos,winx,winy,,,% "ahk_id " ImpaxState[2,2]
if(ImpaxState[2,1]){
    If WinActive("ahk_id " ImpaxState[2,1]) {
        winactivate,% "ahk_id " ImpaxState[2,2]
        controlclick,,% "ahk_id " bar.hwnd
        gosub selectChartNo
    }else {
        winactivate,% "ahk_id " ImpaxState[2,1]
    }
}else{
    if(bar.h>100) {
        mousegetpos,x,y
        mouseclick,,% winx+bar.x+bar.w/3,% winy+bar.y+10,,0
        mousemove,% x,% y,0
    } else {
        controlclick,,% "ahk_id " bar.hwnd
        gosub selectChartNo
    }
}

return

backToList:
return


/*
backToList:
if (ImpaxState:=ImpaxOpened())[1]!=2
   return

if ImpaxState[2,1] && !winactive("ahk_id " ImpaxState[2,1]) && imageWinToggle {
    winactivate,% "ahk_id " ImpaxState[2,1]
    return
}

Winactivate,% "ahk_id " ImpaxState[2,2]
if(ImpaxState[2,1]){
    controlclick,WindowsForms10.Window.8.app.0.2bf8098170,% "ahk_id " ImpaxState[2,2]
}else {
    wingetpos,,,w,,% "ahk_id " ImpaxState[2,2]
    ;~ controlgetpos,x,y,,h,WindowsForms10.Window.8.app.0.2bf809817,% "ahk_id " ImpaxState[2,2]
    ;~ if (h>100) 
        ;~ mouseclick,,% x+(w/3),% y+10,,0
    ;~ else
        ;~ controlclick,WindowsForms10.Window.8.app.0.2bf809817,% "ahk_id " ImpaxState[2,2]

    for k,v in (impaxControls:=getcontrols(ImpaxState[2,2])){
        if ((v.text="登出"||v.text="Logout") && instr(v.classNN,"WindowsForms10.BUTTON.app") && instr(impaxControls[k-2].classNN,"WindowsForms10.Window.8.app")) {
            ;~ controlclick,,% "ahk_id " impaxControls[k-2].hwnd
            controlgetpos,x,y,,h,,% "ahk_id " barId:=impaxControls[k-2].hwnd
            break
        }
    }
    if (h>100) 
        mouseclick,,% x+(w/3),% y+10,,0
    else
        controlclick,,% "ahk_id " barId
    
    
}
*/
;~ }
;~ controlclick,,% "ahk_id " getByControlName(ImpaxState[2],"listXPander")
gosub selectChartNo
return
#ifwinactive

run_slp:
ifwinnotexist,ahk_class SleipnirMainWindow
   run,% root "\software\Sleipnir\Sleipnir.exe"
else
   settimer,run_slp,off
return

GUIClose:
WinMinimize,ahk_id %guiHWND%
return

close_RIS:
if RisState[1]!=2
   return
wingettitle,RisTitle,% "ahk_id " RisState[2]
if !instr(RisTitle,RisName)
   return
winclose,放射線資訊管理系統(Radiology Information System)

loop {
   ifwinexist,Menu ahk_class #32770,是否確定要離開放射線資訊管理(RIS)系統? 
   {
      controlClick,Button1,Menu ahk_class #32770,是否確定要離開放射線資訊管理(RIS)系統?
      break
   }
   if a_index>150
      break
   sleep 200
}
return

close_impax:
if ImpaxState[1]!=2
    return
for k,v in ImpaxControls:=getControls(ImpaxState[2,2])
    if ((v.text="登出" || v.text="Logout") && instr(v.classNN,"WindowsForms10.BUTTON.app") && instr(ImpaxControls[k-1].classNN,"WindowsForms10.STATIC.app") && ImpaxControls[k-1].text!=impax_id)
        return
winclose,IMPAX 6.5.2.114 Radiologist with QC ahk_class WindowsForms10.Window.8.app.0.2bf8098
return

close_SLP:

winget,slpList,list,ahk_class SleipnirMainWindow
loop % slpList {
    winget,slpPath,processpath,% "ahk_id " slpList%a_index%
    if instr(slpPath,root)!=1
        continue
    winclose,% "ahk_id " slpList%a_index%
    
}
loop {
   ifwinexist,Sleipnir ahk_class #32770
   {
      controlClick,Button1,Sleipnir ahk_class #32770
      break
   }
   if a_index>150
      break
   sleep 200
}


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
send {bs}
return


~!a::
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
   traytip,,N Hospital Proxy On,5
}
else
{
   RegWrite,reg_dword,HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyEnable,0
   traytip,,Proxy Off,5
}

return


^!d::
clipboard=
send ^c
clipwait,1
fileappend,% """" clipboard """`n",words.csv,utf-8
return

#ifwinexist,ahk_class WindowsForms10.Window.8.app.0.2bf8098
!^tab::
if (ImpaxState:=ImpaxOpened())[1]!=2
   return
keywait,alt,1
keywait,tab,1
keywait,ctrl,1
if errorlevel
   return
sleep 100
clipboard=
send ^c
clipwait,1

if !regexmatch(clipboard,"(\w)\w{5}\d",match){
    winactivate,% "ahk_id " ImpaxState[2,2]
    gosub selectChartNo
    return
}

winactivate,% "ahk_id " ImpaxState[2,2]
controlclick,,% "ahk_id " ImpaxBar(ImpaxState[2,2]).hwnd
gosub selectChartNo

;~ sleep 100
;~ for k,v in (impaxControls:=getcontrols(ImpaxState[2])){
   ;~ if k<2
      ;~ continue
   ;~ if (impaxControls[k-1].text="病歷號碼" && instr(v.classNN,"WindowsForms10.EDIT.app") && impaxControls[k+2].text="檢查之日期") {
      ;~ controlfocus,,% "ahk_id " v.hwnd
      ;~ controlsettext,,% match,% "ahk_id " v.hwnd
      ;~ controlsend,,{enter},% "ahk_id " v.hwnd
      ;~ break
   ;~ }
;~ }
;chartNo
;~ controlsettext,,% match,% "ahk_id " impaxChartnoControl
acc_objectfromwindow(impaxChartnoControl).accValue:=match
controlsend,,{enter},% "ahk_id " impaxChartnoControl
imageWinToggle:=1
return
#ifwinexist

~!e::
while(x:=winexist("Microsoft Internet Explorer"))
   winkill,ahk_id %x%
return

;~ ~!w::
;~ USBOpenedFiles=
;~ FileDelete,USBOpenedFiles.txt
;~ Runwait, OpenedFilesView.exe /nosort /filefilter %root%\ /stext USBOpenedFiles.txt
;~ while(!fileexist("USBOpenedFiles.txt"))
   ;~ sleep 0
;~ fileread,USBOpenedFiles,USBOpenedFiles.txt
;~ m=0
;~ while(m:=regexmatch(USBOpenedFiles,"Process ID        : (\d*)",match,m+1))
;~ {
   ;~ process,exist,% match1
   ;~ if errorlevel
      ;~ process,close,%match1%
;~ }
;~ return

^!q::
if !(a_priorhotkey=a_thishotkey && A_TimeSincePriorHotkey<300)
    return
winclose,autorun.exe,Quit?
settimer,close_RIS,-1
settimer,close_impax,-1
;~ settimer,close_SLP,-1
gosub close_SLP
process,close,XLiu.exe
;~ settimer,closeSCITE,-1
settimer,closeUSBprocess,-1
return

closeUSBprocess:
winget,pList,list

loop % pList {
    winget,pPath,processpath,% "ahk_id " pList%a_index%
    ;~ if instr(pPath,scite)
        ;~ continue
    if (instr(pPath,root)=1 && a_scripthwnd!=pList%a_index% )
        winclose,% "ahk_id " pList%a_index%
}
return


terminateUSBprocess:
msgbox,1,,Sure?
ifmsgbox,Cancel
   return
gosub closeUSBprocess
winget,pList,list
loop % pList {
    winget,pPath,processpath,% "ahk_id " pList%a_index%
    ;~ if instr(pPath,scite)
        ;~ continue

    if (instr(pPath,root)=1 && a_scripthwnd!=pList%a_index% && guiHwnd!=pList%a_index%){
        winget,pid,pid,% "ahk_id " pList%a_index%
        process,close,% pid
    }
}
gosub unmountUSB
return

unmountUSB:
if (a_osversion!="WIN_XP")
   exitapp
FileCopy,% root "\deveject.exe",% A_MyDocuments,1
;~ FileAppend,% "`n@echo off`nping 1.1.1.1 -n 1 -w 3000`ndeveject.exe -EjectDrive:" root "`nping 1.1.1.1 -n 1 -w 3000`ndel deveject.exe`ndel unmount.cmd",% a_desktop "\unmount.cmd",utf-8
FileAppend,% "`n@echo off`n:L1`nIF EXIST " root " (`ndeveject.exe -EjectDrive:" root "`nping 1.1.1.1 -n 1 -w 2000`ngoto L1 ) ELSE (`ndel deveject.exe`ndel unmount.cmd )",% A_MyDocuments "\unmount.cmd",utf-8
run,% A_MyDocuments "\unmount.cmd",% A_MyDocuments
exitapp 
return


~^!l::	;login RIS and impax
settimer,login_impax,-200
settimer,login_RIS,-200
return

login_impax:
i=0
if(ImpaxState.1=2){
	return
}
if(ImpaxState.1=0){
	settimer,restartImpax,300
	run,% A_ProgramFiles "\Agfa\IMPAX Client\AppStart.exe"
	
	while(!ImpaxOpened()[1]&&i++<300)
		sleep % 200
}


i=0

loginText:=GetControlIdByText(controls,"登入")?"登入":"Login"
while((ImpaxState:=ImpaxOpened())[1]=1 && i++<60){
    ;~ traytip,,% impaxstate.2
	for k,v in controls:=GetControls(impaxHwnd:=ImpaxState[2])
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
        
        
	;~ ControlSetText,,%IMPAX_id%,% "ahk_id " GetControlIdByText(controls,loginText,-1)
	;~ controlsettext,,%IMPAX_pw%,% "ahk_id " GetControlIdByText(controls,loginText,-2)
	;~ ControlFocus,,% "ahk_id " GetControlIdByText(controls,loginText)
	;~ controlsend,,{enter},% "ahk_id " GetControlIdByText(controls,loginText)
    sleep 2000
}
winwait,% IMPAX_title,,60
WinMaximize,% IMPAX_title
settimer,restartImpax,off
return

restartImpax:
if restartImpaxId:=winexist("重新啟動 ahk_class WindowsForms10.Window.8.app.0.2bf8098")
	controlclick,WindowsForms10.BUTTON.app.0.2bf80982,ahk_id %restartImpaxId%
return

login_RIS:
j=0
if(RisState.1=2)
    return
if(RisState.1=0){
    if RISpath:=getrispath(){
        run,% RISpath,% RegExReplace(RISpath,"\\Menu\.exe$")
        while(!RisOpened()[1]&&j++<300)
            sleep 200
    }else 
        msgbox % "Can not find path of RIS, please run RIS first !!!"

    winwait,RIS系統登入<<陽明資訊>>,,60
    if errorlevel
        return
}
j=0
settimer,closeRisError,200
while((RisState:=risopened())[1]=1 && j++<60){
	winactivate,% "ahk_id " RisState[2]
	RISarr:=getControls(RisState[2])
	controlfocus,,% "ahk_id " GetControlIdByText(RISarr,"Password",-2)
	controlsettext,,%RIS_pw%,% "ahk_id " GetControlIdByText(RISarr,"Password",-2)
	controlfocus,,% "ahk_id " GetControlIdByText(RISarr,"Password",-1)
	controlsettext,,,% "ahk_id " GetControlIdByText(RISarr,"Password",-1)
	controlsend,,%RIS_id%{tab},% "ahk_id " GetControlIdByText(RISarr,"Password",-1)
    k=0
    while k++ {
        if k>60
            return
        for k,v in RISarr
            if (v.text="HospitalGroup" && !trim(RISarr[k+1].text) && !trim(RISarr[k+2].text))
                break
    
        sleep 500
    }
    sleep 500
	;~ controlsend,,{enter},%	 "ahk_id " GetControlIdByText(RISarr,"Login")
	controlsend,,{enter},% "ahk_id " GetControlIdByText(RISarr,"Password",-2)	
	winactivate,% "ahk_id " risopened()[2]
    sleep 2000
}

winwait,放射線資訊管理系統(Radiology Information System)
settimer,closeRisError,off
j=0
while(j++<60){
    for k,v in RISarr:=getControls(RisOpened()[2])
        if(v.text="撰打住院醫師"){
            Control,choose,1,,% "ahk_id " RISarr[k+1].hwnd
            return
        }
      
    sleep 500
}

return

closeRisError:
IfWinExist,Menu ahk_class #32770,查無使用者
   controlclick,Button1
return


/* check if RIS opened
[0, 0]: no
[1, HWND]: wait for login
[2, HWND]: opened
*/
RisOpened()
{
	winget,winList,list,放射線資訊管理系統(Radiology Information System)
    winget,activeWin,id,A
	loop % winList
	{
		wingetclass, winClass,% "ahk_id " winList%a_index%
		if instr(winClass,"WindowsForms10.Window.8.app.")
			return array(2,winList%a_index%)
	}
	
	winget,winList,list,RIS系統登入<<陽明資訊>>
	loop % winList
	{
		wingetclass, winClass,% "ahk_id " winList%a_index%
		if instr(winClass,"WindowsForms10.Window.8.app.")
			return array(1,winList%a_index%)
	}
			
	return array(0,0)
}

GetControls(hwnd)
{
	controls:=[]
	winget,classnn,ControlList,ahk_id %hwnd%
	winget,controlId,controllisthwnd,ahk_id %hwnd%
	loop,parse,classnn,`n
	{
		controls[a_index]:=[]
		controls[a_index]["ClassNN"]:=a_loopfield
	}
	
	loop,parse,controlId,`n
	{
		controls[a_index]["Hwnd"]:=a_loopfield
		controlgetText,txt,,ahk_id %a_loopfield%
		controls[a_index]["text"]:=txt
	}
	return controls
}



/* check if IMPAX opened
[0, 0]: no
[1, HWND]: wait for login
[2, HWND]: opened
[3, HWND]: image window
*/
ImpaxOpened()
{
	winget,ImpaxIdList,list,ahk_class WindowsForms10.Window.8.app.0.2bf8098
	
	loop % ImpaxIdList
	{
		id:=ImpaxIdList%a_index%
		wingettext,text,ahk_id %id%
		if instr(text,"STUDY_NAV_TOOLBAR0") {
			WinGetTitle,winTitle,ahk_id %id%
			if(trim(winTitle)!="")
				return array(2,array(0,id))
			else
				imageId:=id
			break
        }
	}
	
	loop % ImpaxIdList
	{
		id:=ImpaxIdList%a_index%
		wingettext,text,ahk_id %id%
		if (instr(text,"RIS 使用者可定義的內容") && instr(text,"一般開業醫師") && instr(text,"檢查狀態")) || (instr(text,"Show List") && instr(text,"Accession Number") && instr(text,"Add results to last search")){
            return array(2,array(imageId,id))
        }
	}
    
	if imageId
		return array(2,array(imageId,0))
	
	loop % ImpaxIdList
	{
		id:=ImpaxIdList%a_index%
		wingettext,text,ahk_id %id%
		if (instr(text,"登入") && instr(text,"密碼") && instr(text,"選項")) || (instr(text,"Login") && instr(text,"Options") && instr(text,"User ID"))
			return array(1,id)
	}
	
	
    ;~ IMPAX_title:="IMPAX 6.5.2.114 Radiologist with QC"
    ;~ winget,id,id,ahk_class WindowsForms10.Window.8.app.0.2bf8098,STUDY_NAV_TOOLBAR0
	;~ if (id){
		;~ return array(3,id)
	;~ }
	;~ winget,id,id,% IMPAX_title "ahk_class WindowsForms10.Window.8.app.0.2bf8098",影像檢查設備
	;~ if (id) {
		;~ return array(2,id)
	;~ }
		
	
    ;~ winget,id1,id,IMPAX 6.5.2.114 ahk_class WindowsForms10.Window.8.app.0.2bf8098,登入
    ;~ winget,id2,id,IMPAX 6.5.2.114 ahk_class WindowsForms10.Window.8.app.0.2bf8098,登入
	;~ if (id) {
		;~ return array(1,id)
	;~ }
    
	
	
	return array(0,0)
}

GetControlIdByText(byref arr,RefControlText,offset=0,UseRegEx=0)
{
	if !isobject(arr)||!arr.maxIndex()
        return
	k=0
	if UseRegEx
	{
		for k,v in arr
			if RegExMatch(v.text,RefControltext)
				break
	}
	else
	{
		for k,v in arr
			if v.text=RefControltext
				break
		if !k
			for k,v in arr
				if instr(v.text,RefControltext)
					break
	}
	
	if !offset
		i:=k
	else
	{
		i:=k+offset
		l:=arr.MaxIndex()
		while i>l
			i-=l
		while i<1
			i+=l
	}
	return (k=0 ? 0 : arr[i]["Hwnd"])
	
}
GetRisPath(){
	loop,HKCU,Software\Microsoft\Windows\ShellNoRoam\MUICache
		if instr(a_loopregname,"Menu.exe") && fileexist(a_loopregname)
			return a_loopregname
	loop,HKCU,Software\Microsoft\Internet Explorer\TypedURLs
	{
		regread,v
		if instr(a,"Menu.exe") && fileexist(v)
			return v
	}
	if (a:=searchFile("Menu.exe",substr(a_windir,1,3) "Documents and Settings\" a_username "\Local Settings\Apps\2.0")).maxindex()
		return a.pop()
	return 0

}
searchFile(f,dir){
	arr:=[]
	originalWorkingDir:=A_WorkingDir
	SetWorkingDir,% dir
	loop,% f,0,1
		arr.push(a_loopfilelongpath)
	SetWorkingDir,% originalWorkingDir
	return arr
}


::s@g::scsnake@gmail.com
::b@n::user@hospital-n.local


~!q::

msgbox,1,,Quit?
ifmsgbox,cancel
   return
   
ExitApp
return

onexit:
RegWrite,reg_dword,HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyEnable,0

;~ if GetKeyState("shift")
    
while hwnd:=hiddenWindows.pop()
    winshow,% "ahk_id " hwnd

ExitApp
return

#ifwinactive,ahk_class SleipnirMainWindow
:?*:``::^+{left}{bs}
#ifwinactive




#ifwinactive,放射線資訊管理系統(Radiology Information System)
:?*:``::^+{left}{bs}
^numpadenter::
^Enter::
for k,v in RISarr:=getControls(RisState[2])
   if (k>3 && RISarr[k-3].text="改派原因" && instr(v.classNN,"WindowsForms10.BUTTON.app.")) {
      ControlClick,,% "ahk_id " v.hwnd
      break
   }
return

!f::
keywait,alt,1
keywait,f,1
sleep 100
clipboard:=
send ^c
clipwait,1
If !lookupHwnd:=winexist("Hotstring Lookup ahk_class AutoHotkeyGUI")
    run % root "\scripts\Radiology\Hotstring Lookup.exe"
WinWait,Hotstring Lookup ahk_class AutoHotkeyGUI,,5
WinActivate,% "ahk_id " lookupHwnd:=winexist("Hotstring Lookup ahk_class AutoHotkeyGUI")
;~ controlget,id,hwnd,,Edit2,Hotstring Lookup ahk_class AutoHotkeyGUI
;~ SendMessage, 0x00B1, 0, -1,, ahk_id %id% ;EM_SETSEL
;~ if (clipboard) {
   ;~ send ^v
   ;~ controlclick,Button2,Hotstring Lookup ahk_class AutoHotkeyGUI
;~ }
PostMessage,0x1001,0,0,,% "ahk_id " lookupHwnd
return



#IfWinActive


ListControls(hwnd)
{
	str=
	arr:=GetControls(hwnd)
	for k,v in arr
		str.="""" v["Hwnd"] """,""" v["ClassNN"] """,""" v["text"] """`n"
	return str
}

/* 
return switch bar: hwnd, x,y,w,h
*/
ImpaxBar(hwnd){
    ;~ for k,v in (impaxControls:=getcontrols(hwnd){
        ;~ if ((v.text="搜尋"||v.text="Search") && instr(v.classNN,"WindowsForms10.BUTTON.app")) {
			;~ winactivate,% "ahk_id " hwnd
			;~ WinWaitActive,% "ahk_id " h,,5
            ;~ controlgetpos,x,y,,,,% "ahk_id " v.hwnd
			;~ return ((name:=acc_objectfrompoint("",x,y).accName)="搜尋"||name="Search")?1:0
        ;~ }
    ;~ }
	
    for k,v in (impaxControls:=getcontrols(hwnd)) {
        if ((v.text="登出"||v.text="Logout") && instr(v.classNN,"WindowsForms10.BUTTON.app") && instr(impaxControls[k-2].classNN,"WindowsForms10.Window.8.app")) {
            controlgetpos,x,y,w,h,,% "ahk_id " barId:=impaxControls[k-2].hwnd
            break
        }
    }
	return {hwnd:barId, x:x, y:y, w:w, h:h}
}

/*
ImpaxStateArr[1]=image window (in pacs monitor), ImpaxStateArr[2]=search window
which=0, switch to search page
which=1, switch to image page
*/
ImpaxSwitchPage(ImpaxStateArr,which=0,bar=""){
	if !bar
		bar:=ImpaxBar(ImpaxStateArr[2])
	wingetpos,winx,winy,,,% "ahk_id " ImpaxStateArr[2]
	if (which=0){
		winactivate,% "ahk_id " ImpaxStateArr[2]
		controlclick,,% "ahk_id " bar.hwnd
	} else if (which=1) {
		if(ImpaxState[1]) {
			winactivate,% "ahk_id " ImpaxStateArr[1]
		}else if !(bar.h>100) {
				mouseclick,,% winx+bar.x+bar.w/3,% winy+bar.y+10,,0
		}
			
	}
}


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