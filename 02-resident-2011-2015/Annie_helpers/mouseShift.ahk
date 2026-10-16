#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;~ #NoTrayIcon

CoordMode,mouse,screen

sysget,monitorcount,monitorcount
if (monitorcount!=2){
	MsgBox, 0, ,Only 2 montiors are supported!
	exitapp
}
sysget,mon1,monitor,1
sysget,mon2,monitor,2
mon1width:=mon1right-mon1left
mon1height:=mon1bottom-mon1top
mon2width:=mon2right-mon2left
mon2height:=mon2bottom-mon2top
;~ Loop, 4
;~ {
	;~ Gui, %A_Index%: -Caption +ToolWindow +AlwaysOnTOp
	;~ Gui, %A_Index%: Color, Red
;~ }
mousegetpos,pX,pY
settimer,monitorMouse,100

return

whichMonitor(x,y){
	global
	if (x>=mon1left && x<=mon1right && y>=mon1top && y<=mon1bottom)
		return 1
	else if (x>=mon2left && x<=mon2right && y>=mon2top && y<=mon2bottom)
		return 2
	return 0
}

monitorMouse:
mousegetpos,cX,cY
cMon:=whichMonitor(cX,cY)
pMon:=whichMonitor(pX,pY)
if (cMon!=pMon)
	settimer,activate,-300
pX:=cX
pY:=cY
return

activate:
mousegetpos,,,winA
winactivate,ahk_id %winA%
return

rbutton::
if !(a_thishotkey=a_priorhotkey && a_timesincepriorhotkey<500){
	send {rbutton}
	return
}
mousegetpos,x,y
n:=whichMonitor(x,y)
m:=3-n
newX:=mon%m%left+floor((x-mon%n%left)/mon%n%width*mon%m%width)
newY:=mon%m%top+floor((y-mon%n%top)/mon%n%height*mon%m%height)

;~ if (x<=mon1right && y<=mon1bottom){
	;~ newX:=floor(x/mon1width*mon2width)+mon1right
	;~ newY:=floor(y/mon1height*mon2height)
;~ }else{
	;~ newX:=floor((x-mon1right)/mon2width*mon1width)
	;~ nexY:=floor(y/mon2height*mon1height)
;~ }
mousemove,% newX,% newY,0
mousegetpos,,,win
winactivate,ahk_id %win%
;~ frame:=200
;~ settimer,show,-1

return

show:
if (frame<20){
	settimer,show,off
	settimer,hide,-1
	return
}
cornerX1:=floor(newX-frame/2),cornerY1:=floor(newY-frame/2)
,cornerX2:=floor(newX+frame/2),cornerY2:=floor(newY+frame/2)
Gui, 1: Show, % "x" cornerX1 " y" cornerY1 " w" frame " h2 NoActivate"
Gui, 4: Show, % "x" cornerX1 " y" cornerY2 " w" frame " h2 NoActivate"
Gui, 2: Show, % "x" cornerX1 " y" cornerY1 " w2 h" frame " NoActivate"
Gui, 3: Show, % "x" cornerX2 " y" cornerY1 " w2 h" frame " NoActivate"
frame:=floor(frame/1.618)
settimer,show,-100

return


hide:
loop 4
	gui, %a_index%:hide
return

;~ rbutton::
;~ if !getkeystate("LButton")
	;~ send {rbutton}
;~ return

;~ ~lbutton::
;~ return

;~ esc::
;~ ExitApp
;~ return
