#Persistent
SetBatchLines,-1
CoordMode,mouse,Screen
#NoTrayIcon
#include <WindowShellEvent>
#SingleInstance,force
#InstallMouseHook
#InstallKeybdHook
WindowShellEvent("ShellMessage")


;~ SetTimer, DrawRect, 50
border_thickness = 2
border_color =00ffff

return


~LButton up::
~RButton::
~MButton::
~WheelDown::
~WheelUp::
~!Tab::
~#m::
~#d::
SetTimer,DrawRect,-1
return

~LButton::
SetTimer,DrawRect,10
return

ShellMessage( wParam,lParam ) { 
	;~ ToolTip % wParam
  If ( wParam=4 || wParam=32772) { ; HSHELL_WINDOWACTIVATED
	SetTimer,DrawRect,-1
		
  }
} 


DrawRect:

WinGetPos, x, y, w, h, A
if (x="")
    return

WinGet, isMaxed , MinMax, A
if (isMaxed=0)
{

  Gui, +Lastfound +AlwaysOnTop +Toolwindow
  iw:= w + border_thickness
  ,ih:= h + border_thickness
  ,w:=  w + ( border_thickness * 2 )
  ,h:=  h + ( border_thickness * 2 )
  ,x:=  x - border_thickness
  ,y:=  y - border_thickness
  Gui, Color, %border_color%
  Gui, -Caption

  ; outer rectangle
  o1a := 0
  ,o1b := 0
  ,o2a := w 
  ,o2b := 0 
  ,o3a := w 
  ,o3b := h 
  ,o4a := 0 
  ,o4b := h 
  ,o5a := 0
  ,o5b := 0

  ; inner rectangle
  ,i1a := border_thickness
  ,i1b := border_thickness
  ,i2a := iw
  ,i2b := border_thickness
  ,i3a := iw
  ,i3b := ih
  ,i4a := border_thickness
  ,i4b := ih
  ,i5a := border_thickness
  ,i5b := border_thickness

  ; Draw outer & inner window(s)
  WinSet, Region, %o1a%-%o1b% %o2a%-%o2b% %o3a%-%o3b% %o4a%-%o4b% %o5a%-%o5b%   %i1a%-%i1b% %i2a%-%i2b% %i3a%-%i3b% %i4a%-%i4b% %i5a%-%i5b%
  Gui, Show, w%w% h%h% x%x% y%y% NoActivate, Table awaiting Action
  
} else {

  WinSet, Region, 0-0 0-0 0-0 0-0 0-0 0-0 0-0 0-0 0-0 0-0 
  Gui, Show, w0 h0 x0 y0 NoActivate, Table awaiting Action

}
SetTimer,DrawRectOff,-1000
return

DrawRectOff:
SetTimer,DrawRect,Off
return
