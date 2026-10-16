; ---------------------------------------- part1

#persistent
SetTitleMatchMode,2
settimer,subRIS,200
SetBatchLines,-1

; ---------------------------------------- part2
#ifwinactive,放射線資訊管理系統(Radiology Information System)
; press ` to backspace a word
:?*:``::^+{left}{bs}

; press ctrl+enter to search
^numpadenter::
^Enter::
for k,v in RISarr:=getControls(RisState[2])
   if (k>3 && RISarr[k-3].text="改派原因" && instr(v.classNN,"WindowsForms10.BUTTON.app.")) {
      ControlClick,,% "ahk_id " v.hwnd
      break
   }
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
	mouseclick,l,5,5,1,0,,r
}else if (instr(activeWinTitle,"IMPAX 6.5.2.114")) {
	mouseclick,l,21,50,1,0,,r
}
return



#ifwinactive,臨床報告
; press esc to close clinical reports
~esc::
WinGetClass,winClass,A
if !instr(winClass,"WindowsForms10.Window.8.app")
	return
send !{F4}
return
#IfWinActive

; ---------------------------------------- part3



; ---------------------------------------- part4
subRIS:
risState:=risOpened()
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



