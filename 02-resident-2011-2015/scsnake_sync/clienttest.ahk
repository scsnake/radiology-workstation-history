;Server

#include <Socket>

;~ sleep 3000
outUdp:=new SocketUDP()
outUdp.connect("addr_broadcast",udpPort())
outUdp.enableBroadcast()
outUdp.sendText("{""cmd"":""test"",""ip"":""1.1.1.1"",""msg"":""test""}")
pause
;~ myUdp.sendText("cmd start notepad.exe")

gui,add,edit,vip w300,localhost
gui,add,edit,vsend w300 h100,{"cmd":"test","ip":"1.1.1.1","msg":"test"}
gui,add,edit,vrecv w300 h100
gui,add,button,gsend,Send
gui,show,autosize


;~ myUdp.sendText("refresh")


return


send:

gui,submit,nohide
myUdp:=new SocketUDP()
myUdp.bind("addr_any",udpPort())
;~ myUdp.connect("10.0.0.100",udpPort())
if (ip="broadcast")
	ip:="addr_broadcast"
myUdp.connect(ip,udpPort())
;~ sleep 1000
myUdp.onRecv:=func("OnUDPRecv")
myUdp.sendText(send)
return


OnUDPRecv(this){
	global 
	t:=this.recvText()
	guicontrol,,recv,% t	
}



udpPort(){
	;~ seed:=abs(sin(a_mon/12*3.14)-sin(a_dd/31*3.14)+sin(a_hour/23*3.14))
	;~ return floor((65535-49152)*seed)+49152
	return 29999
}

guiclose:
esc::
exitapp
return
