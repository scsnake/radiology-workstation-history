#include <socket>
#persistent

ip:="localhost"
port:="54321"

;~ inUdp:=new SocketUDP()
;~ inUdp.bind(ip, port+1)
;~ inUdp.onRecv:=Func("OnUDPRecv")

inUdp:=new SocketUDP()
inUdp.bind(ip, port+1)
inUdp.onRecv:=Func("OnUDPRecv")

outUdp:=[]
outUdp("tryConnect")

return


OnUDPRecv(this){
global ip, port, myUdp
	t:=this.recvText()
	if(t="connected"){
		outUdp("startTransfer")
		ToolTip % "client: startTransfer"
	}else if(t="yes"){
		MsgBox % "client: disconnect"
		ExitApp
		
	}
	
}
 
outUdp(txt){
	global ip, port, outUdp
	
	if !IsObject(this:=outUdp[ip ":" port]){
		this:=outUdp[ip ":" port]:=new SocketUDP()
		this.connect(ip, port)
	}
	return this.sendText(txt)
}
 
 

esc::
inUdp.disconnect()
for k,v in outUdp
	v.disconnect()
ExitApp
