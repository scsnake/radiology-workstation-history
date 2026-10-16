﻿﻿﻿; <COMPILER: v1.1.09.02>



;decompiled on 2014/7/29



#NoEnv



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







IMPAX_id:=loginId



IMPAX_pw:=loginPw



RIS_id:=loginId



RIS_pw:=loginPw



IMPAX_title:="IMPAX 6.5.2.114 Radiologist with QC"



RisName:="陳醫師"



imageWinToggle:=1



scrollImageConst:=0



RegExMatch(a_scriptdir,"^[^\\]*",root)



onexit,onexit



gui,+lastfound



winget,guiHWND,id



gui,add,edit,vcommands,



gui,add,button,gterminateUSBprocess,Unmount USB



gui,add,button,gexe yp x+5,Execute



gui,show,w300 h100,Enter command ...



process,close,AgfaDTIWatchDog.exe



process,close,AgfaDTIBridge.exe



gosub commandArr



openedWindows:=object()



hiddenWindows:=[]



autofocus=1



setTimer,killUpdate,500



setTimer,noIdle,540000



settimer,autofocus,200



settimer,checkExam,-1



settimer,RisImpaxRoutine,200



sysget,monitorCount,monitorcount



if (monitorcount>1){



sysget,firstMonitor,monitor,1



sysget,lastMonitor,monitor,% monitorCount



settimer,cyclicMonitor,200



}



return



cyclicMonitor:



mousegetpos,x,y



if (x=lastMonitorRight-1){



mousemove,1,% y*firstMonitorBottom/lastMonitorBottom,0



}else if(x=0){



mousemove,% lastMonitorRight,% y*lastMonitorBottom/firstMonitorBottom,0



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



risState:=risOpened(),impaxState:=impaxOpened()



return



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



killUpdate:



ifwinexist,Sleipnir ahk_class #32770,Latest version of Sleipnir



controlclick,Button2,Sleipnir ahk_class #32770,Latest version of Sleipnir



ifwinexist,SciTE4AutoHotkey Updater ahk_class #32770



controlclick,Button2,SciTE4AutoHotkey Updater ahk_class #32770



ifwinexist,Microsoft Office Activation Wizard ahk_class NUIDialog



controlsend,NetUIHWND1,{esc},Microsoft Office Activation Wizard ahk_class NUIDialog



ifwinexist,ahk_class #32770,The type initializer for 'HL7.HL7Port' threw an exception.



controlclick,Button1,ahk_class #32770,The type initializer for 'HL7.HL7Port' threw an exception.



winshow,Sleipnir ahk_class SleipnirMainWindow



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



ifwinexist,錯誤 ahk_class #32770,發生問題，應用程式無法繼續執行



controlclick,Button1,錯誤 ahk_class #32770,發生問題，應用程式無法繼續執行



return



parse_commands:



if !(nosubmit)



gui,submit,nohide



nosubmit=0



loop,parse,commands,`,



{



command:=trim(a_loopfield)



if(!command)



continue



if(val:=commandArr[command]){



run,% val



if command in YCH,CXR,brus,mamm



{



process,close,Hotstring Helper.exe



loop,% root "\scripts\Radiology\Hotstring Helper\*.ahk"



if !instr(a_loopfilename,"Hotstring Helper")



filedelete,% a_loopfilelongpath



RegExMatch(val,"is)Autohotkey.exe (.+)",match)



filecopy,% match1,% root "\scripts\Radiology\Hotstring Helper",1



run % root "\scripts\Radiology\Hotstring Helper\Hotstring Helper.exe"



if command=mamm



run % root "\scripts\Autohotkey\AutoHotkey.exe " root "\scripts\Radiology\mammoMagMove.ahk"



else if command=brus



run % root "\scripts\Autohotkey\AutoHotkey.exe " root "\scripts\Radiology\breastUS.ahk"



}



}else if (command="rad"){



work()



}else if (command="slp"){



gosub run_slp



settimer,run_slp,3000



}else if (command="boneage"){



run,% root "\scripts\bone_age\boneage report.exe"



IfWinNotExist,Skeletal Development of the Hand and Wrist - A Radiographic Atlas and Digital Bone Age Companion



run,% root "\R2\PED\Skeletal Development of the Hand and Wrist - A Radiographic Atlas and Digital Bone Age Companion.pdf"



}else{



run % command



}



}



guicontrol,,commands,% ""



return



work(){



global



nosubmit=1



commands:="slp,ych"



settimer,parse_commands,-1



settimer,~^!l,-1



}



#ifwinactive,Enter command



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



~esc::



UnhookWindowsHookEx(hHookMouse)



return



#ifwinactive,ahk_class WindowsForms10.Window.8.app.0.2bf8098



F3::



send {F3}



sleep 100



send h



return



F6::



send {f6}



sleep 100



send h



return



~lbutton::



mousegetpos,,,,mouseControl



KeyWait, LButton, T0.1



if (errorlevel && regexmatch(mouseControl,"AfxWnd90u\d"))



hHookMouse := SetWindowsHookEx(WH_MOUSE_LL   := 14, RegisterCallback("MouseHook", "Fast"))



else



UnhookWindowsHookEx(hHookMouse)



return



MouseHook(nCode, wParam, lParam){



static lx,ly



global hHookMouse



Critical



if (wParam=0x202){



UnhookWindowsHookEx(hHookMouse)



return CallNextHookEx(nCode, wParam, lParam)



}



If nCode || !(wParam = 0x200)



return CallNextHookEx(nCode, wParam, lParam)



VarSetCapacity(lpPoint,8)



DllCall("GetCursorPos", "Uint", &lpPoint)



lx := NumGet(lpPoint, 0, "Int")



ly := NumGet(lpPoint, 4, "Int")



mx := NumGet(lParam+0, 0, "Int")



my := NumGet(lParam+0, 4, "Int")



mx := lx + (mx-lx)



my := ly + (mx-lx) + (my-ly)



DllCall("SetCursorPos", "Int", mx, "Int", my)



NumPut(mx, lParam+0, 0, "Int")



NumPut(my, lParam+0, 4, "Int")



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



if abs(gestureY2-gestureY1)+abs(gestureX2-gestureX1)<10



return



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



send {up}



else if gesturevalue=4



send {down}



return



mbutton::



mousegetpos,gestureX1,gestureY1



return



mbutton up::



mousegetpos,gestureX2,gestureY2



gosub mouseGesture



if (Impax:=ImpaxState)[1]!=2



return



if (!gestureValue)



for k,v in impaxControls:=getControls(Impax[2,1])



if (v.text="BMP_CURSOR_MODE_NEW" && instr(v.classNN,"WindowsForms10.BUTTON.app")){



controlclick,,% "ahk_id " v.hwnd



return



}



gestureValue:=0



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



if (Impax:=ImpaxState)[1]!=2 && Impax[2,4]!=1



return



for k,v in (impaxControls:=getcontrols(Impax[2,1])){



if v.text="BMP_VIRTUAL_SCREEN_BUTTON" && instr(v.ClassNN,"WindowsForms10.BUTTON") {



controlclick,,% "ahk_id " v.hwnd



}



}



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



return



~numpadenter::



~enter::



if (Impax:=ImpaxState)[1]!=2 && Impax[2,4]!=2



return



selectChartNo:



for k,v in (impaxControls:=getcontrols(id2:=Impax[2,2]|Impax[2,3])){



if k<2



continue



if instr(v.classNN,"WindowsForms10.EDIT.app") && ((impaxControls[k-1].text="病歷號碼" && impaxControls[k+2].text="檢查之日期") || (impaxControls[k-1].text="Patient ID" && impaxControls[k+2].text="Study Date")) {



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



run_slp:



ifwinnotexist,ahk_class SleipnirMainWindow



run,% root "\software\Sleipnir\Sleipnir.exe"



else {



settimer,run_slp,off



settimer,renewsid,300000



}



return



renewSid:



SlpWb:=getSlpWb()



SlpSid:=[]



for k,v in SlpWb



if regexmatch(v.document.body.innerHTML,"i)SESSION=(\w{32})",match)



isobject(SlpSid["" match1])?(SlpSid["" match1].push(k)):(SlpSid["" match1]:=array(k))



for k,v in SlpSid



if !checksid(k)



for x,y in v



renewSlpUrl(SlbWb[y],sid:=login(newusername,newpassword))



return



renewSlpUrl(wb,sid){



if regexmatch(href:=wb.LocationUrl,"i)SESSION=\w{32}")



wb.Navigate(RegExReplace(href,"i)SESSION=\w{32}","SESSION=" sid))



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



settimer,RisCloseConfirm,200



return



RisCloseConfirm:



ifwinexist,Menu ahk_class #32770,是否確定要離開放射線資訊管理(RIS)系統?



controlsend,Button1,{Enter},Menu ahk_class #32770,是否確定要離開放射線資訊管理(RIS)系統?



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



settimer,closeSLPconfirm,200



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



controlClick,Button1,Sleipnir ahk_class #32770



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



keywait,LWIN,1



keywait,RWIN,1



keywait,tab,1



keywait,ctrl,1



if errorlevel



return



sleep 100



clipboard=



send ^c



clipwait,1



if !regexmatch(clipboard,"(t|T|y|Y)\w{9}\d",match) && !regexmatch(clipboard,"(\w)\w{5}\d",match)



return



clipboard:=match



winactivate,% "ahk_id " RisState[2]



searchRisChartNo(RisState[2],match)



return



#ifwinexist



#ifwinexist,ahk_class WindowsForms10.Window.8.app.0.2bf8098



~wheeldown::



~wheelup::



if impaxState[1]!=2



return



mousegetpos,,,mouseWin



WinGetClass,mouseWinClass,ahk_id %mouseWin%



if(mouseWinClass="WindowsForms10.Window.8.app.0.2bf8098")



winactivate,% "ahk_id " (impaxState[2,4]>1?(impaxState[2,2]|impaxState[2,3]):impaxState[2,1])



return



!^tab::



if (Impax:=ImpaxState)[1]!=2



return



ifwinactive,UniReport ahk_class TMainForm



{



wingettitle,str,UniReport ahk_class TMainForm



clipboard:=str



}else{



keywait,alt,1



keywait,tab,1



keywait,ctrl,1



if errorlevel



return



sleep 100



clipboard=



send ^c



clipwait,1



}



if !regexmatch(clipboard,"(\w)\w{5}\d",match)



return



clipboard:=match



winactivate,% "ahk_id " id2:=Impax[2,2]|Impax[2,3]



bar:=ImpaxBar(id2)



wingetpos,,,,h,ahk_id %id2%



if !(bar.h>h-37)



controlclick,,% "ahk_id " bar.hwnd



gosub selectChartNo



acc_objectfromwindow(impaxChartnoControl).accValue:=match



controlsend,,{enter},% "ahk_id " impaxChartnoControl



return



#ifwinexist



~!e::



while(x:=winexist("Microsoft Internet Explorer"))



winkill,ahk_id %x%



return



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



winget,pList,list



loop % pList {



winget,pPath,processpath,% "ahk_id " pList%a_index%



if (instr(pPath,root)=1 && a_scripthwnd!=pList%a_index% )



winclose,% "ahk_id " pList%a_index%



}



p:=listProcess()[1]



loop,parse,p,|



{



if instr(GetModuleFileNameEx(a_loopfield),root)



process,close,% a_loopfield



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



FileAppend,% "`n@echo off`n:L1`nIF EXIST " root " (`ndeveject.exe -EjectDrive:" root "`nping 1.1.1.1 -n 1 -w 2000`ngoto L1 ) ELSE (`ndel deveject.exe`ndel unmount.cmd )",% A_MyDocuments "\unmount.cmd",utf-8



run,% A_MyDocuments "\unmount.cmd",% A_MyDocuments



exitapp



return



~^!l::



settimerF("login_RIS",-100,0,0)



~^!i::



settimer,login_impax,-1



return



sig1:



sig1:=(Impax:=ImpaxOpened())[1]=1 && i++<60



return



login_impax:



i=0



if (Impax:=ImpaxState)[1]=2



return



if(Impax[1]=0){



settimer,restartImpax,300



run,% A_ProgramFiles "\Agfa\IMPAX Client\AppStart.exe"



while(!ImpaxState[1]&&i++<300)



sleep % 200



}



i=0



loginText:=GetControlIdByText(controls,"登入")?"登入":"Login"



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



settimer,maximizeImpax,2000



settimer,restartImpax,off



settimer,login_impax2,off



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



login_RIS(){



global



j=0



if(RisState.1=2)



return



if(RisState.1=0){



if RISpath:=getrispath() {



run,% RISpath,% RegExReplace(RISpath,"\\Menu\.exe$")



while(!RisState[1]&&j++<300)



sleep 200



}else{



msgbox % "Can not find path of RIS, please run RIS first !!!"



return



}



winwait,RIS系統登入<<陽明資訊>>,,60



if errorlevel



return



}



j=0



settimer,closeRisError,200



while(RisState[1]=1 && j++<60){



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



controlsend,,{enter},% "ahk_id " GetControlIdByText(RISarr,"Password",-2)



winactivate,% "ahk_id " risopened()[2]



sleep 2000



}



settimer,RisSetDefaultSearch,500



}



return



RisSetDefaultSearch:



if (RisState[1]=2){



settimer,closeRisError,off



for k,v in RISarr:=getControls(RisState[2]) {



if(v.text="撰打住院醫師"){



Control,choose,1,,% "ahk_id " RISarr[k+1].hwnd



}else if(v.text="執行住院醫師"){



}else if(v.text="報告醫師"){



reportDrHwnd:=RISarr[k+1].hwnd



}



}



controlfocus,,% "ahk_id " reportDrHwnd



settimer,RisSetDefaultSearch,off



}



return



closeRisError:



IfWinExist,Menu ahk_class #32770,查無使用者



controlclick,Button1



return



::s@g::scsnake@gmail.com



::b@n::user@hospital-n.local



~!q::



msgbox,1,,Quit?



ifmsgbox,cancel



return



ExitApp



return



onexit:



UnhookWindowsHookEx(hHookMouse)



RegWrite,reg_dword,HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyEnable,0



while hwnd:=hiddenWindows.pop()



winshow,% "ahk_id " hwnd



ExitApp



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



relativeDate(theDay,relative=-1){



Formattime,d,% theDay,yyyyMMddHHmmss



d+=%relative%,d



return d



}



#ifwinactive,放射線資訊管理系統(Radiology Information System)



~^r::



if(RisState[1]!=2)



return



control,choosestring,所有類別,,% "ahk_id " getNetControl2(RisState[2],"檢查類別","FID_LABEL","檢查類別","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,待判讀,,% "ahk_id " getNetControl2(RisState[2],"狀態","FID_LABEL","狀態","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,所有診別,,% "ahk_id " getNetControl2(RisState[2],"診別","FID_LABEL","診別","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,所有報告醫師,,% "ahk_id " getNetControl2(RisState[2],"報告醫師","FID_LABEL","報告醫師","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,所有撰打住院醫師,,% "ahk_id " getNetControl2(RisState[2],"撰打住院醫師","FID_LABEL","撰打住院醫師","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,所有執行住院醫師,,% "ahk_id " getNetControl2(RisState[2],"執行住院醫師","FID_LABEL","執行住院醫師","WindowsForms10.STATIC.app","","","",1)[1]



controlsettext,,% "",% "ahk_id " getNetControl2(RisState[2],"病歷號","FID_LABEL","病歷號","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,% "所有檢查地",,% "ahk_id " (test:=getNetControl2(RisState[2],"檢查地","FID_LABEL","檢查地","WindowsForms10.STATIC.app","","","",1))[1]



return



~^n::



if(RisState[1]!=2)



return



control,choosestring,所有報告醫師,,% "ahk_id " getNetControl2(RisState[2],"報告醫師","FID_LABEL","報告醫師","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,所有撰打住院醫師,,% "ahk_id " getNetControl2(RisState[2],"撰打住院醫師","FID_LABEL","撰打住院醫師","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,所有執行住院醫師,,% "ahk_id " getNetControl2(RisState[2],"執行住院醫師","FID_LABEL","執行住院醫師","WindowsForms10.STATIC.app","","","",1)[1]



controlsettext,,% "",% "ahk_id " getNetControl2(RisState[2],"病歷號","FID_LABEL","病歷號","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,CT,,% "ahk_id " getNetControl2(RisState[2],"檢查類別","FID_LABEL","檢查類別","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,待判讀,,% "ahk_id " getNetControl2(RisState[2],"狀態","FID_LABEL","狀態","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,急診,,% "ahk_id " getNetControl2(RisState[2],"診別","FID_LABEL","診別","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,N總院,,% "ahk_id " getNetControl2(RisState[2],"檢查地","FID_LABEL","檢查地","WindowsForms10.STATIC.app","","","",1)[1]



return



~^f::



if (RisState[1]=2){



for k,v in RISarr:=getControls(RisState[2]) {



if(v.text="報告醫師"){



reportDrHwnd:=RISarr[k+1].hwnd



break



}



}



if (reportDrHwnd) {



inputbox,reportDrInput,Enter VS code,,,150,120



if !errorlevel



control,choosestring,% reportDrInput,,% "ahk_id " reportDrHwnd



}



}



return



~^g::



if (RisState[1]=2){



for k,v in RISarr:=getControls(RisState[2]) {



if(v.text="撰打住院醫師"){



reportDrHwnd:=RISarr[k+1].hwnd



break



}



}



if (reportDrHwnd) {



inputbox,reportDrInput,Enter R code,,,150,120



if !errorlevel



control,choosestring,% reportDrInput,,% "ahk_id " reportDrHwnd



}



}



return



~^h::



if (RisState[1]=2){



for k,v in RISarr:=getControls(RisState[2]) {



if(v.text="執行住院醫師"){



reportDrHwnd:=RISarr[k+1].hwnd



break



}



}



if (reportDrHwnd) {



inputbox,reportDrInput,Enter R code,,,150,120



if !errorlevel



control,choosestring,% reportDrInput,,% "ahk_id " reportDrHwnd



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



for k,v in RISarr:=getControls(RisState[2])



if (k>3 && RISarr[k-3].text="改派原因" && instr(v.classNN,"WindowsForms10.BUTTON.app.")) {



ControlClick,,% "ahk_id " v.hwnd



break



}



return



#IfWinActive



!#tab::



slpwb:=getSlpWb()



if !slpWb.maxIndex()



return



keywait,alt,1



keywait,tab,1



keywait,shift,1



if errorlevel



return



sleep 100



clipboard=



send ^c



clipwait,1



if !regexmatch(clipboard,"(\w)\w{5}\d",match) {



return



}



for k,v in slpWb {



if instr(v.LocationUrl,"WebApplication/OtherIndependentProj/PatientBasicInfoEdit/PatientMedicalRecordListQuery.aspx") {



loop % (inputs:=v.document.getElementsByTagName("INPUT")).length {



if (inputs[a_index-1].name="NWeb1$PatientBasicInfoQueryByIDAndName1$ctl01"){



inputs[a_index-1].value:=match



break



}



}



loop % (inputs:=v.document.getElementsByTagName("INPUT")).length {



if (inputs[a_index-1].name="NWeb1$PatientBasicInfoQueryByIDAndName1$ctl05"){



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



winactivate,ahk_class SleipnirMainWindow



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



~Pause::



if RisState[1]!=2



return



winactivate,% "ahk_id " risstate[2]



winwaitactive,% "ahk_id " RisState[2]



send {F6}



return



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



::pxy1::proxy.hospital-n.local{tab}3128



::spw1::



input,code,i L2 T1 V *



if(code!=a_min+mod(a_hour,12)){



send spw1



return



}



keywait,enter



sleep 100



loop % strlen(code)



send {bs}



send {alt down}{numpad1}{numpad0}{numpad3}{alt up}{alt down}{numpad1}{numpad1}{numpad2}{alt up}{alt up}{alt down}{numpad1}{numpad1}{numpad5}{alt up}{alt up}{alt down}{numpad1}{numpad1}{numpad0}{alt up}{alt up}{alt down}{numpad1}{numpad2}{numpad2}{alt up}{alt down}{numpad5}{numpad2}{alt up}{alt down}{numpad5}{numpad0}{alt up}{alt down}{numpad5}{numpad2}{alt up}{alt down}{numpad5}{numpad4}{alt up}{home}{alt down}{numpad4}{numpad6}{alt up}{alt down}{numpad4}{numpad4}{alt up}{alt down}{numpad1}{numpad0}{numpad9}{alt up}{enter}



return



::spw2::



input,code,i L2 T1 V *



if(code!=a_min+mod(a_hour,12)){



send spw2



return



}



keywait,enter



sleep 100



loop % strlen(code)



send {bs}



send {alt down}{numpad1}{numpad2}{numpad0}{alt up}{alt down}{numpad1}{numpad1}{numpad4}{alt up}{alt down}{numpad1}{numpad0}{numpad5}{alt up}{alt down}{numpad1}{numpad1}{numpad7}{alt up}{alt down}{numpad1}{numpad0}{numpad8}{alt up}{alt down}{numpad1}{numpad0}{numpad0}{alt up}{alt down}{numpad1}{numpad0}{numpad5}{alt up}{Home}{alt down}{numpad5}{numpad0}{alt up}{enter}



return



::spw3::



input,code,i L2 T1 V *



if(code!=a_min+mod(a_hour,12)){



send spw3



return



}



keywait,enter



sleep 100



loop % strlen(code)



send {bs}



send {alt down}{numpad1}{numpad0}{numpad3}{alt up}{alt down}{numpad1}{numpad1}{numpad2}{alt up}{alt up}{alt down}{numpad1}{numpad1}{numpad5}{alt up}{alt up}{alt down}{numpad1}{numpad1}{numpad0}{alt up}{alt up}{alt down}{numpad1}{numpad2}{numpad2}{alt up}{home}{alt down}{numpad1}{numpad0}{numpad9}{alt up}{enter}



return



::spw4::



input,code,i L2 T1 V *



if(code!=a_min+mod(a_hour,12)){



send spw4



return



}



keywait,enter



sleep 100



loop % strlen(code)



send {bs}



send {alt down}{numpad1}{numpad0}{numpad3}{alt up}{alt down}{numpad1}{numpad1}{numpad2}{alt up}{alt up}{alt down}{numpad1}{numpad1}{numpad5}{alt up}{alt up}{alt down}{numpad1}{numpad1}{numpad0}{alt up}{alt up}{alt down}{numpad1}{numpad2}{numpad2}{alt up}{alt down}{numpad5}{numpad2}{alt up}{alt down}{numpad5}{numpad0}{alt up}{alt down}{numpad5}{numpad2}{alt up}{alt down}{numpad5}{numpad4}{alt up}{home}{alt down}{numpad1}{numpad0}{numpad9}{alt up}{enter}



return



::;rp::radiopaedia



::;rg::radiographics



::;ra::radiology assistant



::;lr::learning radiology



::;conct::Please send consult sheet and patient stickers to CT room for scheduling. Thanks.



::;conan::Please send consult sheet and patient stickers to angioroom for scheduling. Thanks.



::;cns::We were consulted for



::qov0::kenbo_14586298



commandArr:



commandArr:=[]



commandArr["note"]:=root "\software\Notepad++\unicode\notepad++.exe"



commandArr["scite"]:=root "\scripts\Autohotkey\SciTE\SciTE.exe"



commandArr["script"]:=root "\scripts\"



commandArr["lib"]:=root "\scripts\Autohotkey\Lib\"



commandArr["word"]:=root "\software\Office 2010 Portable\WINWORD.EXE"



commandArr["access"]:=root "\software\Office 2010 Portable\MSACCESS.EXE"



commandArr["excel"]:=root "\software\Office 2010 Portable\EXCEL.EXE"



commandArr["ppt"]:=root "\software\Office 2010 Portable\POWERPNT.EXE"



commandArr["office"]:=root "\software\Office 2010 Portable\"



commandArr["vfss"]:=root "\scripts\VFSS2\"



commandArr["chm"]:=root "\scripts\Autohotkey\AutoHotkey.chm"



commandArr["spy"]:=root "\scripts\Autohotkey\AU3_Spy.exe"



commandArr["seah"]:=root "\software\Sleipnir\plugins\seahorse\"



commandArr["liu"]:=root "\software\XLiu\Xliu.exe"



commandArr["autorun"]:=root "\scripts\Autorun\"



commandArr["YCH"]:=root "\scripts\Autohotkey\AutoHotkey.exe " root "\scripts\Radiology\YCH.ahk"



commandArr["CXR"]:=root "\scripts\Autohotkey\AutoHotkey.exe " root "\R3\chest\AutoHotkey_chest\Chest_CXJ.ahk"



commandArr["brus"]:=root "\scripts\Autohotkey\AutoHotkey.exe " root "\R3\chest\AutoHotkey_chest\breast_CXJ.ahk"



commandArr["mamm"]:=root "\scripts\Autohotkey\AutoHotkey.exe " root "\R3\chest\AutoHotkey_chest\CUCmammo.ahk"



commandArr["chrome"]:=root "\software\ChromePlusPortable\chrome.exe --proxy-server=proxy.hospital-n.local:3128"



commandArr["pcman"]:=root "\software\PCMan Combo\PCMan.exe"



commandArr["firefox"]:=root "\software\FirefoxPortable\FirefoxPortable.exe"



commandArr["chrome"]:=root "\software\ChromePlusPortable\chrome.exe"



commandArr["msn"]:=root "\software\MSN 8.5\msnmsgr.exe"



commandArr["7z"]:=root "\software\7-Zip\"



commandArr["tshark"]:=root "\software\tshark\"



commandArr["server"]:=root "\software\TWAMPd\"



commandArr["cmd"]:=root "\software\PowerCmd\PowerCmd.exe"



commandArr["teamviewer"]:=root "\software\TeamViewerPortable\TeamViewer.exe"



commandArr["ugi"]:=root "\scripts\Autohotkey\AutoHotkey.exe " root "\scripts\Radiology\YCH-UGI.ahk"



commandArr["hct"]:=root "\scripts\Autohotkey\AutoHotkey.exe " root "\scripts\Radiology\YCH-HCT.ahk"



commandArr["info"]:=root "\scripts\AHK_Window_Info_v1.7.exe"



commandArr["nginx"]:=root "\software\WNMP\"



commandArr["diff"]:=root "\scripts\Radiology\diffReport.exe"



commandArr["case"]:=root "\software\Office 2010 Portable\EXCEL.EXE " """" root "\case list.xlsx"""



commandArr["pdf"]:=root "\software\PDF-XChange Viewer\PDFXCview.exe"



commandArr["ftp"]:=root "\software\FileZillaPortable\FileZillaPortable.exe"



commandArr["icon"]:=root "\scripts\IconChanger\IconChangerMain.exe"



commandArr["simple"]:=root "\scripts\Radiology\AntiImpaxFlash.exe"



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







