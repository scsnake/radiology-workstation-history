CoordMode, Mouse, Screen
CoordMode,pixel,screen
SetBatchLines, -1
comobjerror(false)
SetTitleMatchMode,2
DetectHiddenWindows,on

onexit,onexit

LButton_Held = 0

Loop, 4
{
	Gui, %A_Index%: -Caption +ToolWindow +AlwaysOnTOp
	Gui, %A_Index%: Color, Red
}



gui,arrange: +toolwindow +AlwaysOnTop
gui,arrange: font,s14,Verdana
gui,arrange: add,edit,vrow,2
gui,arrange: add,text,xs,% "   ×"
gui,arrange: add,edit,vcol x+14,2
gui,arrange: font,s8,Verdana
gui,arrange: add,checkbox,xs vincludePrior checked,Include prior image
;~ gui,show,autosize,Arrangement

gui,color,00000
gui,5: +alwaysontop +hwndbgGUI
winset,transparent,1,ahk_id %bgGUI%
gui,5: -caption +toolwindow

clipBuffer0:=0
Return


MButton::
if !(a_priorhotkey=a_thishotkey && a_timesincepriorhotkey<500){
	send {mbutton}
	return
}
mousegetpos,,,,con,3
controlgetpos,x,y,w,h,,ahk_id %con%
sysget,mon,MonitorCount
if mon>1
	CaptureScreen((captureX1:=a_screenwidth+x+1) ",  " (captureY1:=y+1) ", " (captureX2:=a_screenwidth+x+w-1) ", " (captureY2:=y+h-1))
else
	CaptureScreen((captureX1:=x+1) ",  " (captureY1:=y+1) ", " (captureX2:=x+w-1) ", " (captureY2:=y+h-1))
gosub pasteToPpt

Return

$^v::
if (clipbuffer0>0) {
	gui,arrange: show,autosize,Arrangement
	loop {
		sleep 500
	}until !winactive("Arrangement ahk_class AutoHotkeyGUI")
	gosub guisubmit
	loop % clipBuffer0+(includePrior?1:0) {
		clipboard=
		i:=includePrior?a_index-1:a_index
		clipboard:=clipBuffer%i%
		clipwait,1
		if !(a_index=1 && includePrior)
			send ^v
		if a_index=1
			imageSetting:=imageSettings(clipbuffer0+(includePrior?1:0),(captureX2-captureX1)/(captureY2-captureY1))
		else
			;~ pause
			imageSet(imageSetting,a_index)
		;~ gosub setImageSize
	}
}else{
	send ^v
}
clipBuffer0:=0
return

imageSet(imageSetting,i){
	global row,col,includePrior
	gosub rbuttonMenu
	controlgetfocus,t,ahk_class NUIDialog

	
	r:=floor((i-1)/col)+1
	c:=i-(r-1)*col
	
	if (r>row)
		r:=row+1,c:=col+1
	
	setformat,float,0.2
	RegExMatch(t,"is)(.+?)(\d+)$",match)
	controlsettext,% t,% "",ahk_class NUIDialog
	controlsend,% t,% imageSetting[0,2]*1,ahk_class NUIDialog
	ControlFocus,% t:=(match1 . (match2+1)),ahk_class NUIDialog
	sleep 200
	controlsettext,% t,% "",ahk_class NUIDialog
	controlsend,% t,% imageSetting[0,1]*1,ahk_class NUIDialog
	ControlFocus,% t:=(match1 . (match2-1)),ahk_class NUIDialog
	
	acc_get("DoDefaultAction","1.4.1.3.14",0,acc_objectfromwindow(winexist("ahk_class NUIDialog")))
	ControlFocus,% t:=(match1 . (match2+5)),ahk_class NUIDialog
	controlsettext,% t,% "",ahk_class NUIDialog
	if (imageSetting[r,c,1]=0)
		controlsend,% t,% 0.01,ahk_class NUIDialog
	else
		controlsend,% t,% imageSetting[r,c,1]*1,ahk_class NUIDialog
	ControlFocus,% t:=(match1 . (match2+6)),ahk_class NUIDialog
	controlsettext,% t,% "",ahk_class NUIDialog
	if (imageSetting[r,c,2]=0)
		controlsend,% t,% 0.01,ahk_class NUIDialog
	else
		controlsend,% t,% imageSetting[r,c,2]*1,ahk_class NUIDialog
	ControlFocus,% t:=(match1 . (match2+5)),ahk_class NUIDialog
	sleep 200
	controlsend,,{enter},ahk_class NUIDialog
	setformat,float,0.6
}

rbuttonMenu:
controlsend,paneClassDC1,{appskey},ahk_class PPTFrameClass
winwait,ahk_class Net UI Tool Window,,2
controlsend,NetUIHWND1,z,ahk_class Net UI Tool Window
winwait,ahk_class NUIDialog,,2
controlsend,NetUIHWND1,e,ahk_class NUIDialog
sleep 100
return
;~ rbuttonMenu:
;~ loop {
	;~ hwnd:=0
	;~ loop {
		;~ controlsend,paneClassDC1,{appskey},ahk_class PPTFrameClass
		;~ sleep 200
	;~ }until (hwnd:=winexist("ahk_class Net UI Tool Window")) || a_index=5
	;~ controlsend,NetUIHWND1,z,% hwnd?"ahk_id " hwnd:"ahk_class Net UI Tool Window"
	;~ sleep 200
;~ }until (hwnd:=winexist("Format Picture ahk_class NUIDialog")) ||(hwnd:=winexist("圖片 ahk_class NUIDialog")) || a_index=5
;~ controlsend,NetUIHWND1,e,% hwnd?"ahk_id " hwnd:"ahk_class NUIDialog"
;~ return

imageSettings(n,imageWHratio){
	global row,col,includePrior
	static pptwidth:=25.4,pptheight:=19.05
	gosub rbuttonMenu
	controlgetfocus,t,ahk_class NUIDialog

	;~ controlgettext,imageHeight,% t,ahk_class NUIDialog
	;~ imageHeight:=RegExReplace(imageHeight,"[^\d\.]","")
	;~ imageWidth:=imageHeight*imageWHratio
	if (pptWidth/col/imageWHratio<pptHeight/row/1)
		imageWidth:=pptWidth/col,imageHeight:=imageWidth/imageWHratio,x:=0.01,y:=(pptHeight-row*imageHeight)/2
	else
		imageHeight:=pptHeight/row,imageWidth:=imageHeight*imageWHratio,y:=0.01,x:=(pptWidth-col*imageWidth)/2
	
	arr:=[]
	arr[0,1]:=imageWidth,arr[0,2]:=imageHeight
	loop % row {
		i:=A_Index
		loop % col {
			arr[i,a_index,1]:=x+(a_index-1)*imageWidth
			arr[i,a_index,2]:=y+(i-1)*imageHeight
		}
	}
	arr[row+1,col+1,1]:=x,arr[row+1,col+1,2]:=y+row*imageHeight
	
	setformat,Float,0.2
	RegExMatch(t,"is)(.+?)(\d+)$",match)
	controlsettext,% t,% "",ahk_class NUIDialog
	controlsend,% t,% imageHeight*1,ahk_class NUIDialog
	ControlFocus,% t:=(match1 . (match2+1)),ahk_class NUIDialog
	sleep 200
	controlsettext,% t,% "",ahk_class NUIDialog
	controlsend,% t,% imageWidth*1,ahk_class NUIDialog
	ControlFocus,% t:=(match1 . (match2-1)),ahk_class NUIDialog
		
	acc_get("DoDefaultAction","1.4.1.3.14",0,acc_objectfromwindow(winexist("ahk_class NUIDialog")))

	ControlFocus,% t:=(match1 . (match2+5)),ahk_class NUIDialog
	controlsettext,% t,% "",ahk_class NUIDialog
	if (x=0)
		controlsend,% t,0.01,ahk_class NUIDialog
	else
		controlsend,% t,% x*1,ahk_class NUIDialog
	ControlFocus,% t:=(match1 . (match2+6)),ahk_class NUIDialog
	controlsettext,% t,% "",ahk_class NUIDialog
	if (y=0)
		controlsend,% t,% 0.01,ahk_class NUIDialog
	else
		controlsend,% t,% y*1,ahk_class NUIDialog
	ControlFocus,% t:=(match1 . (match2+5)),ahk_class NUIDialog
	sleep 200
	controlsend,,{enter},ahk_class NUIDialog

	setformat,Float,0.6
	
	return arr
}

arrangeguiclose:
gosub guisubmit
return

#ifwinactive,Arrangement ahk_class AutoHotkeyGUI
numpadenter::
enter::
guisubmit:
gui,arrange: submit
gui,arrange: hide
if row=0
	row:=1
if col=0
	col:=1
return
#ifwinactive

rbutton:
send {rbutton}
return

tooltip:
ToolTip
return

testPPT(){
	mousegetpos,,,win
	wingetclass,cl,ahk_id %win%
	return cl="PPTFrameClass"?1:0
}

;~ #ifwinnotactive,ahk_class PPTFrameClass

guishow:
gui,5: show,% "x" x-10 " y" y-10 " w30 h30"
return

*Lbutton::
if testPPT() {
	send {lbutton down}
	return
}
mousegetpos,x,y,win,con,3
;~ winget,mouseOnExe,ProcessName,ahk_id %win%
;~ gosub guishow
if shiftPressed:=getkeystate("shift","P") {
	gosub ShiftLButton
}else if ctrlPressed:=getkeystate("ctrl","P") {
	blockinput,mousemove
	ctrl_Held:=0
	Loop, 5
		Gui, %A_Index%: Hide
	sleep 100	
	;~ gosub impaxLbutton
	CaptureScreen((captureX1:=Mouse_X) ", " (captureY1:=Mouse_Y) ", " (captureX2:=Mouse_X2) ", " (captureY2:=Mouse_Y2))
	blockinput,mousemoveoff
	gosub pasteToPpt
}else if altPressed:=getkeystate("alt","P")  {
	;~ alt_Held:=0
	blockinput,mousemove
	
	Loop, 5
		Gui, %A_Index%: Hide
	sleep 100
	clipboard=
	;~ gosub impaxLbutton
	settimer,impaxLbutton,-1
	CaptureScreen((captureX1:=Mouse_X) ", " (captureY1:=Mouse_Y) ", " (captureX2:=Mouse_X2) ", " (captureY2:=Mouse_Y2))
	blockinput,mousemoveoff
	tooltip % "Screen captures: " ++clipbuffer0
	settimer,tooltip,-500
	clipwait,1
	clipBuffer%clipBuffer0%:=clipboardall
	
}else{
	gui,5: hide
	send {lbutton down}
}
return

*wheelup::
if !(ctrl_held || alt_held){
	send {wheelup}
	return
}
resizeFrame(1)
return

*wheeldown::
if !(ctrl_held || alt_held){
	send {wheeldown}
	return
}
resizeFrame(-1)
return

resizeFrame(r){
	global
	captureX2:=captureX1+(captureX2-captureX1)*(1+r*0.05)
	captureY2:=captureY1+(captureY2-captureY1)*(1+r*0.05)
	Gui, 1: Show, % "x" Mouse_X " y" Mouse_Y " w" captureX2-captureX1 " h1 NoActivate"
	Gui, 4: Show, % "x" Mouse_X " y" (mouse_y2:=Mouse_Y+captureY2-captureY1) " w" captureX2-captureX1 " h1 NoActivate"
	Gui, 2: Show, % "x" Mouse_X " y" Mouse_Y " w1 h" captureY2-captureY1 " NoActivate"
	Gui, 3: Show, % "x" (Mouse_X2:=Mouse_X+captureX2-captureX1) " y" Mouse_Y " w1 h" captureY2-captureY1 " NoActivate"

}

templateArea:
CaptureX1:=captureY1:=0,CaptureX2:=254,captureY2:=191
return

~Ctrl::
if testPPT()
	return
if (CaptureX1="")
	gosub templateArea
if (Ctrl_Held )
	return
Ctrl_Held:=1
Loop
{
	MouseGetPos, Mouse_X, Mouse_Y
	
	loop 4 
		gui, %a_index%: color, % (mouse_x>a_screenwidth)?"white":"red"
	Gui, 1: Show, % "x" Mouse_X " y" Mouse_Y " w" captureX2-captureX1 " h1 NoActivate"
	Gui, 4: Show, % "x" Mouse_X " y" (mouse_y2:=Mouse_Y+captureY2-captureY1) " w" captureX2-captureX1 " h1 NoActivate"
	Gui, 2: Show, % "x" Mouse_X " y" Mouse_Y " w1 h" captureY2-captureY1 " NoActivate"
	Gui, 3: Show, % "x" (Mouse_X2:=Mouse_X+captureX2-captureX1) " y" Mouse_Y " w1 h" captureY2-captureY1 " NoActivate"
	If (!getkeystate("Ctrl","P") || !Ctrl_Held){
		Ctrl_held:=0
		Break
	}
}
Loop, 4
	Gui, %A_Index%: Hide
return

~alt::
if testPPT()
	return
if (CaptureX1="")
	gosub templateArea
if (alt_Held )
	return
alt_Held:=1
Loop
{
	MouseGetPos, Mouse_X, Mouse_Y
	loop 4 
		gui, %a_index%: color, % (mouse_x>a_screenwidth)?"white":"red"

	Gui, 1: Show, % "x" Mouse_X " y" Mouse_Y " w" captureX2-captureX1 " h1 NoActivate"
	Gui, 4: Show, % "x" Mouse_X " y" (mouse_y2:=Mouse_Y+captureY2-captureY1) " w" captureX2-captureX1 " h1 NoActivate"
	Gui, 2: Show, % "x" Mouse_X " y" Mouse_Y " w1 h" captureY2-captureY1 " NoActivate"
	Gui, 3: Show, % "x" (Mouse_X2:=Mouse_X+captureX2-captureX1) " y" Mouse_Y " w1 h" captureY2-captureY1 " NoActivate"
	If (!getkeystate("alt","P") || !alt_Held){
		alt_held:=0
		Break
	}
}
Loop, 4
	Gui, %A_Index%: Hide
return


ShiftLButton:
;~ if testPPT()
	;~ return
;~ if !getkeystate("shift")
	;~ return
If (LButton_Held == 0)
{
	LButton_Held = 1
	MouseGetPos, Mouse_X, Mouse_Y
	loop 4 
		gui, %a_index%: color, % (mouse_x>a_screenwidth)?"white":"red"

	Loop
	{
		MouseGetPos, Mouse_X_2, Mouse_Y_2

		If (Mouse_X_2 > Mouse_X)
		{
			Gui, 1: Show, % "x" Mouse_X " y" Mouse_Y " w" Mouse_X_2 - Mouse_X " h1 NoActivate"
			Gui, 4: Show, % "x" Mouse_X " y" Mouse_Y_2 " w" Mouse_X_2 - Mouse_X " h1 NoActivate"
		}	
		Else
		{
			Gui, 1: Show, % "x" Mouse_X_2 " y" Mouse_Y " w" Mouse_X - Mouse_X_2 " h1 NoActivate"
			Gui, 4: Show, % "x" Mouse_X_2 " y" Mouse_Y_2 " w" Mouse_X - Mouse_X_2 " h1 NoActivate"
		}
		If (Mouse_Y_2 > Mouse_Y)
		{
			Gui, 2: Show, % "x" Mouse_X " y" Mouse_Y " w1 h" Mouse_Y_2 - Mouse_Y " NoActivate"
			Gui, 3: Show, % "x" Mouse_X_2 " y" Mouse_Y " w1 h" Mouse_Y_2 - Mouse_Y " NoActivate"
		}
		Else
		{
			Gui, 2: Show, % "x" Mouse_X_2 " y" Mouse_Y_2 " w1 h" Mouse_Y - Mouse_Y_2 " NoActivate" 
			Gui, 3: Show, % "x" Mouse_X " y" Mouse_Y_2 " w1 h" Mouse_Y - Mouse_Y_2 " NoActivate"
		}
		ToolTip, % "Width: " Mouse_X_2 - Mouse_X " - Height: " Mouse_Y_2 - Mouse_Y 
		;~ msgbox % getkeystate("LButton","P")
		If (!getkeystate("LButton","P") || !getkeystate("Shift")){
			Lbutton_Held:=0
			Break
		}
	}
	Loop, 5
		Gui, %A_Index%: Hide
	ToolTip
	Final_Width := Mouse_X_2 - Mouse_X
	Final_Height := Mouse_Y_2 - Mouse_Y
	If (Final_Width > 0)
		X_Coordinate := Mouse_X
	Else
	{
		Final_Width *= -1
		X_Coordinate := Mouse_X_2
	}
	If (Final_Height > 0)
		Y_Coordinate := Mouse_Y
	Else
	{
		Final_Height *= -1
		Y_Coordinate := Mouse_Y_2
	}
	
	sleep 100
	;~ settimer,impaxLbutton,-1
	CaptureScreen((captureX1:=X_Coordinate) ", " (captureY1:=Y_Coordinate) ", " (captureX2:=X_Coordinate + Final_Width) ", " (captureY2:=Y_Coordinate + Final_Height))
	gosub pasteToPpt
}
return 


~Ctrl up::
Ctrl_Held:=0
return
~alt up::
alt_Held:=0
return
*Lbutton up::
if ((altPressed || shiftPressed || ctrlPressed)){
	;~ gosub guishow
}else{
	send {lbutton up}
}
altPressed:=shiftPressed:=ctrlPressed:=0
blockinput,mousemoveoff
gui,5: hide
LButton_Held:=0
return

impaxLbutton:
;~ ifwinactive,ahk_exe impax-client-main.exe
	;~ send {rbutton}
return

;~ #ifwinnotactive

;~ lbutton::
;~ send {lbutton down}
;~ return

;~ lbutton up::
;~ send {lbutton up}
;~ return

;~ ~alt up::
;~ send {alt up}
;~ alt_Held:=0
;~ return

;~ ~shift up::
;~ LButton_Held = 0
;~ Return



pasteToPpt:
list:=AltTab_window_list()
loop % AltTab_ID_list_0 {
	winget,processName,processName,% "ahk_id " AltTab_ID_list_%a_index%
	wingetclass,winclass,% "ahk_id " AltTab_ID_list_%a_index%
	if (winclass="PPTFrameClass" || processName="POWERPNT.EXE"){
		;~ winactivate,% "ahk_id " AltTab_ID_list_%a_index%
		;~ WinWaitActive,% "ahk_id " AltTab_ID_list_%a_index%
		;~ sleep 500
		;~ send ^v
		controlsend,paneClassDC1,^v,% "ahk_id " AltTab_ID_list_%a_index%
		;~ controlsend,NetUIHWND1,^v,% "ahk_id " AltTab_ID_list_%a_index%
		winactivate,% "ahk_id " AltTab_ID_list_%a_index%
		
		;~ if (ppt:=ComObjCreate("PowerPoint.Application"))
			;~ gosub adjustSize
		
		break
	}
}
blockinput,mousemoveoff
return
;~ esc::exitapp

adjustSize:
sh:=ppt.ActivePresentation.PageSetup.SlideHeight
sw:=ppt.ActivePresentation.PageSetup.SlideWidth
shape:=ppt.ActiveWindow.Selection.ShapeRange
w:=shape.Width
h:=shape.Height

if (sw/w*h>sh){
	shape.Height:=sh
	shape.Top:=0
	shape.Left:=(sw-shape.Width)/2
}else{
	shape.Width:=sw
	shape.Left:=0
	shape.Top:=(sh-shape.Height)/2
}
return

^!x::
Suspend
return

~esc::
if(a_priorhotkey=a_thishotkey && A_TimeSincePriorHotkey<500)
	exitapp
return

onexit:
blockinput,mousemoveoff
exitapp