#persistent
#NoTrayIcon 
#SingleInstance,force
CoordMode,mouse,screen

settimer,routine,400

OnMessage(0x10101,"Exit")
return
Exit(){
	Exitapp
}

lctrl up::
routine:
if (mirrWheelUp||mammoClickEndX) && !getkeystate("lbutton") && (++impaxMammoCount)>1 {
	send {lctrl up}
	
	mousegetpos,x,y
	
	monitor:=whichMonitor(mammoClickEndX?mammoClickStartX:x,mammoClickEndX?mammoClickStartY:y)
	crossMonitor:=(monitor.0>1 && getKeystate("Alt"))?1:0
	
	
	
	;~ if (monitorCount=1) {
		;~ mousemove,% a_screenwidth-x,% y,0
	;~ }else if (monitorCount=2) {
		;~ sysget,mon2,monitor,2
		;~ if (x>=mon2left)
			;~ mousemove,% mon2right-x+mon2left,% y,0
		;~ else
			;~ mousemove,% a_screenwidth-x,% y,0
	;~ }else if (monitorCount=3){
		;~ sysget,mon2,monitor,2
		;~ sysget,mon3,monitor,3
		;~ mousemove,% mon3right-x+mon2left,% y,0
	;~ }
			
	if(mirrWheelUp){	
		mousemove,% crossMonitor?(2*monitor.right-2*x):(monitor.right+monitor.left-2*x),0,0,R
		loop % abs(mirrWheelUp) {
			if mirrWheelUp>0
				send {wheelup}
			else
				send {wheeldown}
			sleep 100
		}
		sleep 100
	}
	if(mammoClickEndX){
		mousemove,% -mammoClickEndX+mammoClickStartX,% -mammoClickEndY+mammoClickStartY,1,R
		mousemove,% crossMonitor?(2*monitor.right-2*mammoClickStartX):(monitor.right+monitor.left-2*mammoClickStartX),0,1,R
		send {lbutton down}
		sleep 100
		mousemove,% -mammoClickEndX+mammoClickStartX,% mammoClickEndY-mammoClickStartY,3,R
		send {lbutton up}
		sleep 100
	}
	
	mousemove,% x,% y,0
	impaxMammoCount:=mirrWheelUp:=mammoClickEndX:=0
}
return

lctrl & lbutton up::
mousegetpos,mammoClickEndX,mammoClickEndY
send {lbutton up}
impaxMammoCount:=0
return

#ifwinactive,ahk_class WindowsForms10.Window.8.app.0.2bf8098
lctrl & wheelup:: 
++mirrWheelup
impaxMammoCount:=0
send {wheelup}
return
lctrl & wheeldown:: 
--mirrWheelup
impaxMammoCount:=0
send {wheeldown}
return
lctrl & lbutton::
mousegetpos,mammoClickStartX,mammoClickStartY
send {lbutton down}
return


#IfWinActive

whichMonitor(x="",y=""){
	if(x="" && y="")
		mousegetpos,x,y
	sysget,c,monitorcount
	loop % c {
		sysget,monitor,monitor,% a_index
		if(x>=monitorLeft&&x<=monitorRight&&y<=monitorBottom&&y>=monitorTop)
			return object(0,a_index,"left",monitorLeft,"right",monitorRight,"top",monitorTop,"bottom",monitorBottom)
	}
}
	

~!^q::exitapp