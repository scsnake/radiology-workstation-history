CoordMode,mouse,screen




sFile   := a_scriptdir "\degree-wheel.gif" 
;~ i:=10,picw:=pich:=200
iniFile:=a_scriptdir "\archCal.ini"
iniread,i,% iniFile,settings,zoomInterval
iniread,pich,% iniFile,settings,initialPicHeight
iniread,picw,% iniFile,settings,initialPicWidth
gosub gui
settimer,mousemove,1
return

mousemove:
if !show
	return
mousegetpos,x,y
;~ wingetpos,,,w,h,ahk_id %guihwnd%
winmove,ahk_id %guiHwnd%,,% x-picw/2,% y-pich/2
return

gui:
mousegetpos,x,y
Gui, Add, Picture, w%picw% h%pich% x0 y0 vpic, % sfile
Gui, Color, FFFFFF
Gui, +LastFound +hwndguiHwnd -caption -border +alwaysontop +toolwindow
WinSet, TransColor, FFFFFF
Gui, Show,% "autosize x" x-picw/2 " y" y-pich/2
show:=1
return

wheelup::
if !show
	return
show:=0
gui,destroy
picw+=i
pich+=i
gosub gui
return

wheeldown::
if !show
	return
show:=0
gui,destroy
picw-=i
pich-=i
gosub gui
return

shift::
mousegetpos,x,y
if show:=!show
	Gui, Show,% "autosize x" x-picw/2 " y" y-pich/2
else
	gui,hide
return


~!q::
ExitApp
return
