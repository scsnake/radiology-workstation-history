#NoEnv
#SingleInstance,force
SetBatchLines,-1
DetectHiddenWindows, On
SetTitleMatchMode,2

;~ OnMessage(WM_MOUSEMOVE:=0x200, "MouseMove")

options:=["angioConsult","angioSchedule","diffReport","Hotstring Lookup","portalMessage","Sleipnir","XLiu","ChangeSchedule3","upDateOpPatho2","boneage report","searchLab","TMS reader GUI","VFSS2","執行住院醫師"]
defaultChecked:=[0,0,0,0,0,1,0,0,0,0,1,0,0,1]
text:=["定時查詢照會","查詢lab data並轉為excel"]

gui,+lastfound
guiHwnd:=winexist()
gui,font,s10,Verdana

for k,v in options
	gui,add,checkbox,% "vcb" k " " (defaultChecked[k]?"checked":""),% v

gui,add,button,gput,Put Shortcuts

gui,show,w200,Put shortcuts
return

put:
gui,submit,nohide
for k,v in options {
	var:=cb%k%
	if (!var)
		continue
	
	if (v="Sleipnir"){
		FileCreateShortcut,% a_scriptdir "\Sleipnir\SleipnirLogin.exe",% a_desktop "\SleipnirLogin.lnk"
	}else if fileexist(exe:=a_scriptdir "\" v ".exe"){
		FileCreateShortcut,% exe,% a_desktop "\" v ".lnk"
	}else if fileexist(exe:=a_scriptdir "\" v "\" v ".exe"){
		FileCreateShortcut,% exe,% a_desktop "\" v ".lnk"
	}

}
msgbox Done!
return


GUIClose:
~esc::
exitapp
return


MouseMove(){
	global text
	static prior,currn,lastT
	mousegetpos,,,,currn
	if (currn){
		if(currn!=prior){
			lastT:=a_tickCount
			tooltip
		}else{
			if(lastT&&(a_tickcount-lastT>100)){
				tooltip,% text[regexreplace(currn,"\D")]
				lastT:=0
			}
		}
	}else{
		tooltip
	}
	prior:=currn
}