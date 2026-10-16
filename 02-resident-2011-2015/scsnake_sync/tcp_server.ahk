#include <socket>
#Persistent

;~ ip:="addr_any"
port:="54321"
TCPclients:=[]


myTCP:=new SocketTCP()
myTCP.bind("addr_any", port)
myTCP.onAccept:=Func("OnTCPAccept")
myTCP.onRecv:=Func("OnTCPRecv")
myTCP.listen()
SetTimer,runclient,-1000
return

runclient:
run tcp_client.exe
return

OnTCPAccept(this){
	global TCPclients
	TCPclients.push(newTcp:=this.accept())
	;~ global newTcp
	;~ newTcp:=this.accept()
	newTcp.sendText("Connected")
	newTcp.onRecv:=Func("OnTCPRecv")
	newTcp.__GetPeerName(host, port)
	MsgBox % host "," port
}

OnTCPRecv(this){
	t:=this.recvText()
	ToolTip % t
	Sleep 1000
	if(t="A")
		this.sendText("B")
	else if(t="C")
		a:=1
		;~ this.disconnect()
	
}
 


esc::
myTCP.disconnect()
for k,v in TCPclients
	v.disconnect()
ExitApp
