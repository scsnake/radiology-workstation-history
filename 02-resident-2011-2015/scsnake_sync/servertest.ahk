;Server

#include <Socket>


/*  tcp
myTcp := new SocketTCP()
myTcp.bind("addr_any", 54321)
myTcp.listen()
myTcp.onAccept := Func("OnTCPAccept")
return

OnTCPAccept(this)
{
	;~ global newTcp
    newTcp := this.accept()
    newTcp.onRecv := func("OnTCPRecv")
    newTcp.sendText("Connected")
}
OnTCPRecv(this)
{
	t:=this.recvText()
    if(t="update"){
		;~ gosub update
		this.sendText("From: " a_IPAddress1 "," a_computername "," a_username "," a_osversion "," a_scriptdir)
	}
}
*/

myUdp:=new SocketUDP()
myUdp.bind("addr_any",54321)
myUdp.onRecv:=func("OnUDPRecv")

return

OnUDPRecv(this){
	t:=this.recvText()
	;~ tooltip % "server receive: " t
	sleep 100
	if(t="update"){
		;~ run 
		;~ this.sendText("From: " a_IPAddress1 "," a_computername "," a_username "," a_osversion "," a_scriptdir)
	}
}


esc::exitapp
