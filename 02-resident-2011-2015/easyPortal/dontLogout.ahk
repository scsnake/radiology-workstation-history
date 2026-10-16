﻿/* 
scsnake@gmail.com 
scsnake @ ptt & ptt2
*/


#Include ../COM.ahk
;~ #include ../ACC.ahk
#SingleInstance,ignore
#NoEnv

coordMode,mouse,screen
coordMode,pixel,screen
coordMode,tooltip,screen
SetBatchLines, -1
SetWorkingDir, %a_scriptdir%
SetTitleMatchMode,2
DetectHiddenWindows,on

Onexit,on_exit
renewMin=10


COM_AtlAxWinInit()

settimer,main,% renewMin*60*1000
gosub main

return

main:
gosub getCurrentSID
for k1,v1 in SessionIDs
	if ! testSIDalive(k1)
		for k2,v2 in v1
			;~ WinSetTitle,%k2% ahk_id %v2%,,%k2% - Idle too long !! You have to re-login !!
			

return




getCurrentSID:
SessionIDs:=object()
For pwb in ComObjCreate("Shell.Application").Windows
	if instr(pwb.FullName,"iexplore.exe")
		if (IEurl:=pwb.LocationURL) contains portal/General,hospital-n.local
			if (SID:=RegExReplace(IEurl,"is).*?SESSION=([^&]+).*","$1",found,1)) && found
			{
				if ! SessionIDs.haskey(SID)
					SessionIDs.push(SID,object())
				SessionIDs[SID].push(pwb.hwnd,pwb.LocationName)
			}


;~ For pwb in ComObjCreate("Shell.Application").Windows
	;~ if instr(pwb.FullName,"iexplore.exe")
	;~ {
		;~ IEhwnd:=pwb.hwnd
		;~ winget,IEcontrols,controllisthwnd,ahk_id %IEhwnd%
		;~ loop,parse,IEcontrols,`n
		;~ {
			;~ WinGetClass,thisControlClass,ahk_id %a_loopfield%
			;~ If (thisControlClass = "Internet Explorer_Server") && (DllCall("IsWindow", UInt, A_LoopField))
			;~ {
               ;~ IID_IHTMLWindow2 := "{332C4427-26CB-11D0-B483-00C04FD90119}"
               ;~ ACC_Init()
               ;~ pacc := ACC_AccessibleObjectFromWindow(A_LoopField)
               ;~ pwin := COM_QueryService(pacc,IID_IHTMLWindow2,IID_IHTMLWindow2)
               ;~ COM_Release(pacc)
			   ;~ msgbox % pwin.LocationURL
		   ;~ }
	   ;~ }
   ;~ }
	   ;~ if IEurl:=pwb.LocationURL contains portal/General,hospital-n.local
			;~ if (SID:=RegExReplace(IEurl,"is).*?SESSION=([^&]+).*","$1",found,1)) && found ; && (! SessionIDs.haskey(SID))
			;~ {
				;~ if ! SessionIDs.haskey(SID)
					;~ oIEs:=object(), SessionIDs.push(SID,oIEs)
				;~ SessionIDs[SID].push(pwb.HWND)
			;~ }
return


testSIDalive(sid)
{
	Gui, +LastFound +Resize
	
	pwb := COM_AtlAxGetControl(COM_AtlAxCreateContainer(WinExist(),0,0,a_screenwidth,a_screenheight-100, "Shell.Explorer") )
	;~ IOleInPlaceActiveObject_Interface:="{00000117-0000-0000-C000-000000000046}"
	;~ pipa := COM_QueryInterface(pwb, IOleInPlaceActiveObject_Interface)
	
	
	
	;~ pwb := ComObjCreate( "InternetExplorer.Application" )
	;~ pwb.visible:=false
	pwb.navigate("http://portal.hospital-n.local/General/Redirect.aspx?SESSION=" sid)
	gui,show,maximize
	waitLoaded(pwb)
	gui,destroy
	return % (Instr(pwb.LocationURL,"Login.aspx") ? 0 : 1)
}



waitLoaded(pwb,timeOutMin=2)
{
   sleep 100
   loop
   {
      If pwb.readyState=4
         return 1
      if a_index>timeOutMin*60*1000/200
		return 0
      sleep 200
   }
}




on_exit:
!q::
;~ com_release(pwb)
;~ com_term()
exitapp