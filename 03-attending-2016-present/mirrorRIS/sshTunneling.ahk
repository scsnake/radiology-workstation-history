﻿#include <httprequest>
#include <jxon>
#include <AHKhttp>
#include <WM_COPYDATA>
#Persistent
SetBatchLines,-1
#SingleInstance,Ignore
OnExit,OnExit

root:=SubStr(A_ScriptDir, 1, 2)
,BvsshPath:="""" root "\software\Bitvise SSH Client\BvSsh.exe"""
,profilePath:="""" A_ScriptDir "\MAGIC_SSH.tlp"""
,sshTunnelLocalPort:=12322
,localServerPort:=12321
;~ ,sshTunnelRemotePort:=10005
,Proxy:="10.0.1.100:1080"

server:=new HttpServer()
,server.SetPaths({"/": Func("root")})
,server.Serve(localServerPort)
,dwData:=19

;~ WinClose,ahk_exe BvSsh.exe
;~ run,% BvsshPath " -profile=" profilePath " -loginOnStartup -exitOnLogout",,Hide
tunnel:=new sshTunnel(sshTunnelLocalPort, proxy)
if !tunnel.checkValid() 
	MsgBox("Cannot connect remote server!")

;~ if tunnel.requestToken() 
	;~ MsgBox("Cannot connect with token")


return

esc::
OnExit:
;~ WinClose,ahk_exe BvSsh.exe
ExitApp
return

root(ByRef req, ByRef res, ByRef server){
	global tunnel, dwData
	try 
		body:=req.body
		,r:=jxon_load(body)
	catch 
		return res.status:=200
		
	if tunnel.token != r.token
		return res.status:=200
	
	Send_WM_COPYDATA(WinExist("mirrorRIS_main ahk_class AutoHotkeyGUI"), dwData, body)
	
	return res.status:=200
}

MsgBox(info, ExitApp=true){
	MsgBox % info
	if ExitApp
		ExitApp
}

class sshTunnel {
	__New(sshTunnelLocalPort, proxy){
		this.sshTunnelLocalPort:=sshTunnelLocalPort
		this.proxy:=proxy
	}
	
	checkValid(){
		httprequest("localhost:" this.sshTunnelLocalPort , post:="", header:="", "proxy: " this.proxy)
		return (header~="^[^\r\n]+200 OK")
	}
	
	requestToken(tried=0){
		Random,token,0,999999
		
		res:=this.req({"client_try_token":token})
		try
			j:=jxon_load(res)
		catch
			return 1
		
		if (j.status="connected")
			this.token:=j.token
			,this.connected:=true
		else if(j.status="used" && tried>3)
			return this.requestToken(tried+1)
		else if (j.status="wait")
			this.connected:=true
		else
			return 1
	}
	
	req(data){
		global sshTunnelLocalPort, proxy
		httprequest("localhost:" sshTunnelLocalPort , post:=jxon_dump(data), header:="", "proxy: " proxy)
		return post
	}
}
