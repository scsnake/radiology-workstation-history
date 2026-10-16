﻿#NoEnv
#SingleInstance,force
SetBatchLines,-1
DetectHiddenWindows, On
SetTitleMatchMode,2

IMPAX_id:=loginId
IMPAX_pw:="3"
RIS_id:=loginId
RIS_pw:="3"
IMPAX_title:="IMPAX 6.5.2.114 Radiologist with QC"
RisName:="陳醫師"
RegExMatch(a_scriptdir,"^[^\\]*",root)

gui,+lastfound
winget,guiHWND,id

gui,add,edit,vcommands,

gui,show,w300 h100,Enter command ...


process,close,AgfaDTIBridge.exe


openedWindows:=object()





setTimer,killUpdate,500
setTimer,noIdle,10000

return

noIdle:
if (tmp:=RisOpened())[1]!=2
   return


for k,v in risControls:=GetControls(tmp[2])
   if instr(v.ClassNN,"WindowsForms10.SysTreeView32") {
      controlsend,,{space},% "ahk_id " v.Hwnd
      break
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
return

parse_commands:
gui,submit,nohide
loop,parse,commands,`,
{
   command:=trim(a_loopfield)
   if(!command)
      continue
   
   if command in pad+,pad++,notepad++,notepad+,note
   {
      run,% root "\software\Notepad++\unicode\notepad++.exe"
   }
   else if command in slp,sleipnir,slpnr
   {
      gosub run_slp
      settimer,run_slp,3000
   }
   else if command in scite
   {
      run,% root "\scripts\Autohotkey\SciTE\SciTE.exe"
   }
   else if command in scripts,script
   {
      run,% root "\scripts\"
   }
   else if command in word
   {
      run,% root "\software\Office 2007 portable (win7可用)\WINWORD.EXE"
   }
   else if command in excel
   {
      run,% root "\software\Office 2007 portable (win7可用)\EXCEL.EXE"
   }
   else if command in powerpoint,ppt
   {
      run,% root "\software\Office 2007 portable (win7可用)\POWERPNT.EXE"
   }
   else if command in office
   {
      run,% root "\software\Office 2003 SP3\"
   }
   else if command contains pdfx,pdfxch,pdfxcview
   {
      run,% root "\software\PDF-XChange Viewer\PDFXCview.exe"
   }
   else if command contains vfss
   {
      run,% root "\scripts\VFSS2\"
   }
   else if command in ahkchm,ahk.chm,autohotkey.chm,chm
   {
      run,% root "\scripts\Autohotkey\AutoHotkey.chm"
   }
   else if command in spy,au3spy
   {
      run,% root "\scripts\Autohotkey\AU3_Spy.exe"
   }
   else if command in seahorse,seah
   {
      run,% root "\software\Sleipnir\plugins\seahorse\"
   }
   else if command in liu,xliu
   {
      run,% root "\software\XLiu\Xliu.exe"
   }
   else if command in autorun
   {
      run,% root "\scripts\Autorun\"
   }
   else if command in YCH
   {
      run,% root "\scripts\Autohotkey\AutoHotkey.exe " root "\scripts\Radiology\YCH.ahk"
   }
   else if command in chrome
   {
      run,% root "\software\ChromePlusPortable\chrome.exe"
   }
   else if command in pcman,bbi,bbs
   {
      run,% root "\software\PCManBBI Portable\PCMan.exe"
   }
   else if command in firefox
   {
      run,% root "\software\FirefoxPortable\FirefoxPortable.exe"
   }
   else if command in chrome,chromeplus
   {
      run,% root "\software\ChromePlusPortable\chrome.exe"
   }
   else if command in msn
   {
      run,% root "\software\MSN 8.5\msnmsgr.exe"
   }
   else if command in 7z,7zip,zip
   {
      run,% root "\software\7-Zip\"
   }
   else if command in tshark
   {
      run,% root "\software\tshark\"
   }
   else if command in server
   {
      run,% root "\software\TWAMPd\"
   }
   else if command in cmd
   {
      run,% root "\software\PowerCmd\PowerCmd.exe"
   }
   else if command in teamviewer
   {
      run,% root "\software\TeamViewerPortable\TeamViewer.exe"
   }
   else if command in noidle
   {
      run,% root "\scripts\Radiology\noIdle.exe"
   }
   else if command in pdf,xchange,xcview
   {
      run,% root "\software\PDF-XChange Viewer\PDFXCview.exe"
   }
   else if command in ugi
   {
      run,% root "\scripts\Autohotkey\AutoHotkey.exe " root "\scripts\Radiology\YCH-UGI.ahk"
   }
   else if command in hct
   {
      run,% root "\scripts\Autohotkey\AutoHotkey.exe " root "\scripts\Radiology\YCH-HCT.ahk"
   }
   else if command in boneage
   {
      run,% root "\scripts\bone_age\boneage report.exe"
      IfWinNotExist,Skeletal Development of the Hand and Wrist - A Radiographic Atlas and Digital Bone Age Companion
         run,% root "\R2\PED\Skeletal Development of the Hand and Wrist - A Radiographic Atlas and Digital Bone Age Companion.pdf"
   }
   else if command in quiz
   {
      run,% root "\scripts\Radiology\quiz.exe"
   }
   else if command in info
   {
      run,% root "\scripts\AHK_Window_Info_v1.7.exe"
   }
   else if command in nginx
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



#ifwinactive,IMPAX 6.5.2.114 Radiologist with QC
;press enter to select chart no edit control
~numpadenter::
~enter::
if (ImpaxState:=ImpaxOpened())[1]!=2
   return
selectChartNo:
for k,v in (impaxControls:=getcontrols(ImpaxState[2])){
   if k<2
      continue
   if (impaxControls[k-1].text="病歷號碼" && instr(v.classNN,"WindowsForms10.EDIT.app") && impaxControls[k+2].text="檢查之日期") {
      controlfocus,,% "ahk_id " v.hwnd
      controlget,selectedText,Selected,,,% "ahk_id " v.hwnd
      if !selectedText
         ControlClick,,% "ahk_id " v.hwnd,,l,1
      ;~ controlsend,,{home}+{end},% "ahk_id " v.hwnd
      break
   }
}

return
f1::
backToList:
if (ImpaxState:=ImpaxOpened())[1]!=2
   return
for k,v in (impaxControls:=getcontrols(ImpaxState[2])){
   if (v.text="登出" && instr(v.classNN,"WindowsForms10.BUTTON.app") && instr(impaxControls[k-2].classNN,"WindowsForms10.Window.8.app")) {
      controlclick,,% "ahk_id " impaxControls[k-2].hwnd
      break
   }
}
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
if(RisState:=RisOpened())[1]!=2
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
if(ImpaxState:=ImpaxOpened())[1]!=2
    return
for k,v in ImpaxControls:=getControls(ImpaxState[2])
    if (v.text="登出" && instr(v.classNN,"WindowsForms10.BUTTON.app") && instr(ImpaxControls[k-1].classNN,"WindowsForms10.STATIC.app") && ImpaxControls[k-1].text!=impax_id)
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
   ifwinexist,Sleipnir ahk_class #32770,,3 
   {
      controlClick,Button1,Sleipnir ahk_class #32770
      break
   }
   if a_index>150
      break
   sleep 200
}


return

closeMSNPopup:
ifwinexist,ahk_class MSBLPopupMsgWClass
   winhide
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

if (DllCall("IsWindowVisible", "UInt", WinExist("Facebook")) or DllCall("IsWindowVisible", "UInt", WinExist("ahk_class MSBLWindowClass")) or DllCall("IsWindowVisible", "UInt", WinExist("ahk_class IMWindowClass")))
{
   WinHide, Facebook
   WinHide, ahk_class MSBLWindowClass
   winget,MSN_windows,list,ahk_class IMWindowClass
   loop % MSN_windows
      WinHide,% "ahk_id " MSN_windows%a_index%
   settimer,closeMSNPopup,200
}
else
{
   WinShow, Facebook
   WinShow, ahk_class MSBLWindowClass
   winget,MSN_windows,list,ahk_class IMWindowClass
   loop % MSN_windows
      WinShow,% "ahk_id " MSN_windows%a_index%
   settimer,closeMSNPopup,off
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

!^tab::
if (ImpaxState:=ImpaxOpened())[1]!=2
   return
gosub backToList
sleep 100
send ^c

if !regexmatch(clipboard,"(\w)\w{5}\d",match){
   winactivate,% "ahk_id " ImpaxState[2]
   gosub selectChartNo
   return
}
sleep 100
for k,v in (impaxControls:=getcontrols(ImpaxState[2])){
   if k<2
      continue
   if (impaxControls[k-1].text="病歷號碼" && instr(v.classNN,"WindowsForms10.EDIT.app") && impaxControls[k+2].text="檢查之日期") {
      controlfocus,,% "ahk_id " v.hwnd
      controlsettext,,% match,% "ahk_id " v.hwnd
      controlsend,,{enter},% "ahk_id " v.hwnd
      break
   }
}
winactivate,% "ahk_id " ImpaxState[2]
return


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
winclose,autorun.exe,Quit?
settimer,close_RIS,-1
settimer,close_impax,-1
settimer,close_SLP,-1
;~ process,close,XLiu.exe
;~ settimer,closeSCITE,-1
settimer,closeUSBprocess,-1
return

closeUSBprocess:
winget,pList,list

loop % pList {
    winget,pPath,processpath,% "ahk_id " pList%a_index%
    if (instr(pPath,root)=1 && a_scripthwnd!=pList%a_index% )
        winclose,% "ahk_id " pList%a_index%
}

return

~^!l::	;login RIS and impax
settimer,login_impax,-200
settimer,login_RIS,-200
return
login_impax:
ImpaxState:=ImpaxOpened(),i=0
if(ImpaxState.1=2){
	return
}
if(ImpaxState.1=0){
	run,% A_ProgramFiles "\Agfa\IMPAX Client\AppStart.exe"
	while(!ImpaxOpened()[1]&&i++<300)
		sleep % 200
}
i=0
while((ImpaxState:=ImpaxOpened())[1]=1 && i++<60){
    ;~ traytip,,% impaxstate.2
	controls:=GetControls(ImpaxState[2])
	ControlSetText,,%IMPAX_id%,% "ahk_id " GetControlIdByText(controls,"登入",-1)
	controlsettext,,%IMPAX_pw%,% "ahk_id " GetControlIdByText(controls,"登入",-2)
	ControlFocus,,% "ahk_id " GetControlIdByText(controls,"登入")
	controlsend,,{enter},% "ahk_id " GetControlIdByText(controls,"登入")
    sleep 2000
}
winwait,% IMPAX_title,,60
WinMaximize,% IMPAX_title

return
login_RIS:
RisState:=RisOpened(),j=0
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
while((RisState:=risopened())[1]=1 && j++<60){
	winactivate,% "ahk_id " RisState[2]
	RISarr:=getControls(RisState[2])
	controlsettext,,,% "ahk_id " GetControlIdByText(RISarr,"Password",-1)
	controlsend,,%RIS_id%{tab},% "ahk_id " GetControlIdByText(RISarr,"Password",-1)
    k=0
    while k++ {
        if k>300
            return
        for k,v in RISarr
            if v.text="HospitalGroup" && !trim(RISarr[k+1].text) && !trim(RISarr[k+2].text)
                break
    
        sleep 100
    }
    
	controlfocus,,% "ahk_id " GetControlIdByText(RISarr,"Password",-2)
	controlsettext,,%RIS_pw%,% "ahk_id " GetControlIdByText(RISarr,"Password",-2)
	;~ controlsend,,{enter},%	 "ahk_id " GetControlIdByText(RISarr,"Login")
	controlsend,,{enter},% "ahk_id " GetControlIdByText(RISarr,"Password",-2)	
	winactivate,% "ahk_id " risopened()[2]
    sleep 2000
}

winwait,放射線資訊管理系統(Radiology Information System)
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
*/
ImpaxOpened()
{
   IMPAX_title:="IMPAX 6.5.2.114 Radiologist with QC"
	winget,winList,list,% IMPAX_title
    winget,activeWin,id,A
	loop % winList
	{
		wingetclass, winClass,% "ahk_id " winList%a_index%
		if instr(winClass,"WindowsForms10.Window.8.app.")
			return array(2,winList%a_index%)
	}
	
	winget,winList,list,IMPAX 6.5.2.114
	loop % winList
	{
		wingetclass, winClass,% "ahk_id " winList%a_index%
		if instr(winClass,"WindowsForms10.Window.8.app.")
			return array(1,winList%a_index%)
	}
			
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




~!q::

msgbox,1,,Quit?
ifmsgbox,cancel
   return
RegWrite,reg_dword,HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyEnable,0

;~ if GetKeyState("shift")
    

ExitApp
return


#ifwinactive,放射線資訊管理系統(Radiology Information System)
:?*:``::^+{left}{bs}
#IfWinActive



