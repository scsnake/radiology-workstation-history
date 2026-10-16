#SingleInstance,Ignore
CoordMode,mouse,Screen
SetBatchLines,-1
crossInd:=0



;~ MouseGetPos,x,y
;~ gui,Show,x%x% y%y% w30 h30
return

~F1::

createCross:


Loop, 4
{
	i:=crossInd*4+A_Index
	Gui, %i%: -Caption +ToolWindow +AlwaysOnTOp
	Gui, %i%: Color, red
}
;~ ++s
;~ if(s=1)
	;~ createCross(40,5,20)
;~ else if (s=2)
	;~ createCross(30,3,10)
;~ else if (s=3)
	createCross(20,3,5)
	;~ ,s:=0

;~ SetTimer,createCross,% s=0?"off":"-150"
crossInd++
return

createCross(length=20, thickness=3, Space=5){
	global
	local x,y
	MouseGetPos,x,y
	gui,% (crossInd*4+1) ":Show",% "x" x-(length+Space) " y" y-Floor(thickness/2) " w" length " h" thickness
	gui,% (crossInd*4+2) ":Show",% "x" x+(Space) " y" y-Floor(thickness/2) " w" length " h" thickness
	gui,% (crossInd*4+3) ":Show",% "x" x-Floor(thickness/2) " y" y-(length+Space) " w" thickness " h" length
	gui,% (crossInd*4+4) ":Show",% "x" x-Floor(thickness/2) " y" y+(Space) " w" thickness " h" length
}

~F2::
Loop % 4*crossInd
	Gui, %A_Index%: Destroy
crossInd:=0
return


;~ esc::
!q::
ExitApp