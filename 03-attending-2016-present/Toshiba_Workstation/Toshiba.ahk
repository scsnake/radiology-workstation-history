#include <.NetGetControl>
#include <acc>
#include <risimpax>
SetControlDelay,-1
SetBatchLines,-1
CoordMode,mouse,screen

;~ sleep 3000
;~ winget,hwnd,id,A
;~ a:=getFocused()
;~ msgbox % a
;~ exitapp

t:=new Toshiba()
;~ clipboard:=listcontrols( t.loginState[2])
;~ exitapp
;~ t.login()
;~ t.getListAcc()
t.searchChartNo(chartNo)
return


getFocused(){
	static GuiThreadInfoSize = 48
	VarSetCapacity(GuiThreadInfo, GuiThreadInfoSize)
	NumPut(GuiThreadInfoSize, GuiThreadInfo, 0)
	DllCall("GetGUIThreadInfo", uint, 0, str, GuiThreadInfo)
	return FocusedHWND := NumGet(GuiThreadInfo, 12)
}
class Toshiba {
	__New() {
		this.url:="http://10.0.1.100/Default.aspx"
		this.user:="advuser2"
		this.pw:="advuser2"
		this.state:=this.loginState()
		this.imageFolder:=a_scriptdir "\images"
	}
	
	;return non-zero if error
	activate(){
		loginState:=this.loginState()
		if (loginState[1]!=2)
			this.login()
		if (loginState:=this.loginState())[1]=2 {
			IfWinNotActive,% "ahk_id " hwnd:=loginState[2]
			{
				winactivate,% "ahk_id " hwnd
				winwaitactive,% "ahk_id " hwnd,,5
				return errorlevel
			}else
				return 0
		}
		return 1
	}
	
	login(){
		this.loginState:=this.loginState()
		if(this.loginState[1]=2)
			return
		if(this.loginState[1]!=1){
			run % "iexplore.exe """ this.url """"
			if !(this.loginState:=this.waitState(1))
				return 0
		}
		js:="javascript:document.getElementById('ctl00_UserName').value='" this.user "';document.getElementById('ctl00_Password').value='" this.pw "';document.getElementById('ctl00_Login').click();void 0;"
		this.loginState[2].Navigate(js)
		
		if !(this.loginState:=this.waitState(2))
			return 0
		else
			return this.loginState
		
	}
		
	waitState(s, maxTry=100, interval=500){
		while (this.loginState:=this.loginState())[1]!=s && (tried:=a_index)<maxTry
			sleep % interval
		if (tried>=maxTry)
			return 0
		else
			return this.loginState
	}
	
	getListAcc(){
		;~ this.loginState:=this.loginState()
		;~ if (this.loginState[1]!=2)
			;~ return 
		
		controlget,hwnd,hwnd,,MFCReportCtrl1,% "ahk_id " this.loginState[2]
		acc:=acc_objectfromwindow(hwnd)
		msgbox % acc_children(acc).maxindex()
	}

	/*
	0
	1: login window
	2: did login
	*/
	loginState(){
		winget,list,list,ahk_exe iexplore.exe
		loop % list {
			hwnd:=list%a_index%
			WinGetClass,cl,ahk_id %hwnd%
			if regexmatch(cl,"i)^Afx:") {
				return [2, hwnd]
			}
		}
		
		for wb in ComObjCreate("Shell.Application").Windows
			if (wb.LocationURL=this.url)
				return [1,wb]
		
	}
	
	imageSearch(file,x=0,y=0,w="",h="",var=10){
		if (w="")
			w:=A_ScreenWidth
		if (h="")
			h:=A_ScreenHeight
		
		this.activate()
		ImageSearch,xx,yy,% x,% y,% w,% h,% "*" var " " this.imageFolder "\" file
		if errorlevel
			return errorlevel
		return {x:xx,y:yy}
	}
	
	searchChartNo(chartNo){
		if !isobject(chartNoEditLoc:=this.imageSearch("ChartNo.png"))
			return 1
		MouseClick,l,% chartNoEditLoc.x+5,% chartNoEditLoc.y+5,1,0
		sleep 100
		send {tab}
		sleep 10
		send +{home}
		sleep 10
		sendraw % chartNo
		
	}


}



Capture2Text(x,y,w,h){
	Clipboard:=""
	run % a_mydocuments "\Capture2Text\Capture2Text.exe " x " " y " " w " " h " output.txt"
	clipwait,2
	return clipboard
}


esc::exitapp

