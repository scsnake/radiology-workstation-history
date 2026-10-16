#persistent
#notrayicon
DetectHiddenWindows,on
ComObjError(false)
coordmode,mouse,screen
setbatchlines,-1
#include <WM_COPYDATA>
#include <JXON>
gui,main: +hwndguihwnd
WinSetTitle,% "ahk_id " guihwnd,,% "dragGUI_main"
SetTimer,exit,3000


OnMessage(0x4a, "ON_WM_COPYDATA")
mx:=" mx "
,my:=" my "
,mouseWIn:=" mouseWin "
,Alias(originalMouse, " getvar(originalMouse) ")
,Alias(viewFrame, " getvar(viewFrame) ")
,alive:=1
<createSeriesDragGUI:
dragGUIs:=[]
,dimension:=[], w:=h:=0
,guiX:=mx+10, winStack:=[], dragWBs:=[]		
Loop 
	if (viewFrame[A_Index,1]!=""){
		gui,dragGUI%a_index%:New
		gui,+hwnddragGUIhwnd +ToolWindow -Border -Caption +AlwaysOnTop 
		gui,Color,black
		dragGUIs.push(dragGUIhwnd), winStack.push(dragGUIhwnd)
		winset,AlwaysOnTop,on,ahk_id %dragGUIhwnd%
		w:=(xCount:=viewFrame[A_Index, 1].maxindex())*100
		,h:=(yCount:=viewFrame[A_Index].maxindex())*100
		;~ w:=h:=200
		;~ ToolTip % ++iii
		gui,Add,ActiveX,% "x0 y0 w" w " h" h " vWBdrag" A_Index, Shell.Explorer
		WBdrag%a_index%.silent:=true
		,WBdrag%a_index%.Navigate("about:blank")
		, dragWBs.push(WBdrag%a_index%)
		,cells:=""
		Loop % yCount {
			cells.="<tr>"
			Loop % xCount {
				cells.="<td></td>"
			}
			cells.="</tr>"
		}
		while (WBdrag%a_index%.ReadyState != 4)
			Sleep 10
		html:="<head> <style type=text/css> * { background-color: black; } body { overflow: hidden; } table { border-collapse: collapse; left: 0; top: 0; position: absolute; table-layout: fixed; } td { border: 1px white solid; width: 100px; height: 100px; } td:hover { background-color: gray; } </style> <script type=text/javascript> </script></head> <body> <table>" cells "</table></body>"
		,WBdrag%a_index%.document.open()
		,WBdrag%a_index%.document.write(html)
		,WBdrag%a_index%.document.close()
		gui,show,% "x" guiX " y" my+10 " w" w " h" h, % "dragGUI" A_Index
		guiX+=w+10
	}else 
		break
SetTimer,<hoverDragGUI,-400
SetTimer,<DestroyDragGUI,-100000
return
<DestroyDragGUI:
Loop 4
	gui,dragGUI%a_index%:destroy
return
<hoverDragGUI:
MouseGetPos,mx,my,win
WinGetTitle,t,ahk_id %win%

if RegExMatch(t, "dragGUI(\d+)", match){
	WinGetPos,wx,wy,,,ahk_id %win%
	targetX:=Floor((mx-wx)/100)+1
	,targetY:=Floor((my-wy)/100)+1
	ToolTip % targetX targetY
	try
		prevCell.style.backgroundColor:="black"
	;~ ToolTip % targetX "," targetY
	(prevCell:=WBdrag%match1%.document.getElementsByTagName("table")[0].rows[targetY-1].cells[targetX-1]).style.backgroundColor:="grey"
}
SetTimer,<hoverDragGUI,-400
return
<dragGuiFinish:
if RegExMatch(t, "dragGUI(\d+)", match){
	WinGetPos,wx,wy,,,ahk_id %win%
	targetX:=Floor((mx-wx)/100)+1
	,targetY:=Floor((my-wy)/100)+1
	
	wingetpos,x,y,w,h,% "ahk_id " viewFrame[match1+0, targetY, targetX]
	mousemove,% originalMouse.x, % originalMouse.y,0
	send {lbutton down}
	MouseMove,10,0,1,r
	Sleep 100
	mousemove,% x+floor(w/4),% y+floor(h/4),0
	mousemove,10,0,1,r
	sleep 100
	send {lbutton up}
	sleep 100

	;~ mouseDragSeries(originalMouse, mouseWin, viewFrame[match1+0, targetY, targetX])
	;~ dragSeries(targetX,targetY,originalMouse,match1,seriesListStored,viewFrame)
}
SetTimer,<DestroyDragGUI,-1
return



exit:
if !WinExist("scsnake_autorun_main ahk_class AutoHotkeyGUI")
	ExitApp
return