;Server

#include <Socket>
#include <JXON>

myUdp:=new SocketUDP()
myUdp.bind("addr_any",udpPort())
myUdp.onRecv:=func("OnUDPRecv")
;~ sleep 3000
outUdp:=new SocketUDP()
;~ outUdp.connect("localhost",udpPort())
;~ outUdp.connect("10.0.0.100",udpPort())
outUdp.connect("10.0.0.100",udpPort())
outUdp.enableBroadcast()
;~ outUdp.sendText("{""cmd"":""test"",""ip"":""1.1.1.1"",""msg"":""test""}")
msg1:=[]
msg1.cmd:="update"
msg1.url:=""

msg2:=[]
msg2.cmd:="cmd_ln"
msg2.msg:="start calc.exe"

msg3:=[]
msg3.cmd:="vnc"
msg3.msg:=""

outUdp.sendText(jxon_dump(msg3))
ExitApp
return



OnUDPRecv(this){
	global 
	t:=this.recvText()
	msgbox % t
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
