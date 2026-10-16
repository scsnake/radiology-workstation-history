#include <socket>
#Persistent

ip:="addr_any"
port:="54321"



inUdp:=new SocketUDP()
inUdp.bind(ip, port)
inUdp.onRecv:=Func("OnUDPRecv")

outUdp:=[]
return

OnUDPRecv(this){
	global ip, port
	t:=this.recvText()
	if(t="tryConnect"){
		;~ outUdp:=new SocketUDP()
		;~ outUdp.connect(ip, port+1)
		outUdp("connected")
		ToolTip % "server: connected"
		;~ outUdp.disconnect()
	}else if(t="startTransfer"){
		;~ outUdp:=new SocketUDP()
		outUdp("yes")
		ToolTip % "server: yes"
		;~ outUdp.disconnect()
	}
	
}

outUdp(txt){
	global ip, port, outUdp
	
	if !IsObject(this:=outUdp[ip ":" port+1]){
		this:=outUdp[ip ":" port+1]:=new SocketUDP()
		this.connect(ip, port+1)
	}
	return this.sendText(txt)
}
 
 

esc::
inUdp.disconnect()
for k,v in outUdp
	v.disconnect()
ExitApp
