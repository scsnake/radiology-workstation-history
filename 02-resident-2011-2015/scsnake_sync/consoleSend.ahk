;Server

#include <Socket>
#include <jxon>
OnExit,OnExit
;~ sleep 3000
outTcp:=new SocketTcp()
;~ outTcp.connect("10.0.0.100",TcpPort())
;~ outTcp.connect("addr_broadcast",TcpPort())
;~ outTcp.enableBroadcast()
;~ outTcp.sendText("{""cmd"":""test"",""ip"":""1.1.1.1"",""msg"":""test""}")
;~ pause
;~ myTcp.sendText("cmd start notepad.exe")

gui,add,ComboBox,vip w250,10.0.0.100||localhost|10.0.0.100
;~ gui,add,edit,vsend w300 h100,{"cmd":"test","ip":"10.0.0.100","msg":"test"}
gui,Add,Text,xm,cmd
gui,Add,ComboBox,yp xp+50 vcmd w200,test||update|sync|cmd_ln|ahk|vnc
gui,Add,Text,xm,msg
gui,Add,Edit,yp xp+50 vmsg r5 w200,test
gui,Add,Text,xm,url
gui,Add,Edit,yp xp+50 vurl w200
gui,Add,Text,xm,path
gui,Add,Edit,yp xp+50 vpath w200
gui,add,edit,xm vrecv w300 h100
gui,add,button,gsend,Send
gui,show,autosize


;~ myTcp.sendText("refresh")


return


send:

gui,submit,nohide
guicontrol,,recv,% ""
;~ myTcp.disconnect()
myTcp:=new SocketTcp()
;~ myTcp.connect("addr_any",TcpPort())
;~ myTcp.connect("10.0.0.100",TcpPort())
;~ if (ip="broadcast")
	;~ ip:="addr_broadcast"
	;~ try
	myTcp.connect(ip,TcpPort())
	;~ catch e
		;~ MsgBox % myTcp.getLastError()

;~ sleep 1000
;~ myTcp.onAccept:=Func("OnTcpAccept")
myTcp.onRecv:=func("OnTcpRecv")
;~ txt={"cmd":"%cmd%", "ip":"%a_ipaddress1%", "msg":"%msg%", "url":"%url%", "path":"%path%"}
txt:={}
,txt.cmd:=cmd
,txt.ip:=A_IPAddress1
,txt.msg:=msg
,txt.url:=url
,txt.path:=path
;~ ToolTip % txt
r:=myTcp.sendText(jxon_dump(txt))
return

;~ OnTcpAccept(this){
	;~ newTcp:=this.accept()
	;~ newTcp.onRecv:=func("OnTcpRecv")
;~ }

OnTcpRecv(this){
	global 
	t:=this.recvText()
	;~ MsgBox % t
	guicontrol,,recv,% t	
	this.disconnect()
}



TcpPort(){
	;~ seed:=abs(sin(a_mon/12*3.14)-sin(a_dd/31*3.14)+sin(a_hour/23*3.14))
	;~ return floor((65535-49152)*seed)+49152
	return 29999
}

guiclose:
esc::
exitapp
return


OnExit:
;~ myTcp.disconnect()
myTcp:=""
ExitApp