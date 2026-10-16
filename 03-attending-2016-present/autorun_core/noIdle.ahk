; ---------------------------------------- part1

#persistent
SetTitleMatchMode,2
settimer,subRIS,200
SetBatchLines,-1

; ---------------------------------------- part2
; every 540000ms=540s=9min
settimer,noIdle,540000
return


; ---------------------------------------- part3

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



