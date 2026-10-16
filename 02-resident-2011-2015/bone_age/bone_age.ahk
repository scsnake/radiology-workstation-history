#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,off
SetBatchLines, -1
coordMode,mouse,screen
coordMode,pixel,screen
coordMode,tooltip,screen
SetTitleMatchMode,2
SetControlDelay,-1

#include ../portalLib/portalLib.ahk

iniRead,loginId,login.ini,account,id
iniRead,loginPw,login.ini,account,pw

while ! sid:=Login(loginId,loginPw)
{
	inputbox,loginId,Enter portal login ID,,,,,,,,,% loginId
	inputbox,loginPw,Enter portal login password
}
iniwrite,% loginId,login.ini,account,id
iniwrite,% loginPw,login.ini,account,pw

OnExit,exitsub


;---------------- bone age data

BoneAge:=object()

BoneAge["1"]["b"]:=2.1
BoneAge["1"]["g"]:=2.7
BoneAge["2"]["b"]:=4.0
BoneAge["2"]["g"]:=4.0
BoneAge["3"]["b"]:=6.0
BoneAge["3"]["g"]:=5.6
BoneAge["4"]["b"]:=7.0
BoneAge["4"]["g"]:=7.2
BoneAge["5"]["b"]:=8.4
BoneAge["5"]["g"]:=8.6
BoneAge["6"]["b"]:=9.3
BoneAge["6"]["g"]:=9.0
BoneAge["7"]["b"]:=10.1
BoneAge["7"]["g"]:=8.3
BoneAge["8"]["b"]:=10.8
BoneAge["8"]["g"]:=8.8
BoneAge["9"]["b"]:=11.0
BoneAge["9"]["g"]:=9.3
BoneAge["10"]["b"]:=11.4
BoneAge["10"]["g"]:=10.8
BoneAge["11"]["b"]:=10.5
BoneAge["11"]["g"]:=12.3
BoneAge["12"]["b"]:=10.4
BoneAge["12"]["g"]:=14.0
BoneAge["13"]["b"]:=11.1
BoneAge["13"]["g"]:=14.6
BoneAge["14"]["b"]:=12.0
BoneAge["14"]["g"]:=12.6
BoneAge["15"]["b"]:=14.2
BoneAge["15"]["g"]:=11.2
BoneAge["16"]["b"]:=15.1
BoneAge["17"]["b"]:=15.4
BoneAge["1.5"]["b"]:=2.7
BoneAge["1.5"]["g"]:=3.4
BoneAge["2.5"]["b"]:=5.4
BoneAge["2.5"]["g"]:=4.8
BoneAge["3.5"]["b"]:=6.6
BoneAge["3.5"]["g"]:=6.5
BoneAge["4.5"]["b"]:=7.8
BoneAge["4.5"]["g"]:=8.0
BoneAge["5.5"]["b"]:=9.1
BoneAge["5.5"]["g"]:=8.9

BoneAge["1m"]["b"]=[4.11,1.41]
BoneAge["1m"]["g"]=[4.58,1.76]
BoneAge["3m"]["b"]=[6.63,1.86]
BoneAge["3m"]["g"]=[7.78,2.16]
BoneAge["6m"]["b"]=[9.61,1.95]
BoneAge["6m"]["g"]=[11.44,2.53]
BoneAge["9m"]["b"]=[11.88,2.66]
BoneAge["9m"]["g"]=[15.36,4.92]
BoneAge["12m"]["b"]=[13.96,3.96]
BoneAge["12m"]["g"]=[22.40,6.93]
BoneAge["18m"]["b"]=[19.27,6.61]
BoneAge["18m"]["g"]=[34.10,8.44]
BoneAge["24m"]["b"]=[29.21,8.10]
BoneAge["24m"]["g"]=[43.44,6.65]
BoneAge["30m"]["b"]=[37.59,7.40]
BoneAge["30m"]["g"]=[48.91,6.50]
BoneAge["36m"]["b"]=[43.42,5.34]
BoneAge["36m"]["g"]=[52.73,5.48]
BoneAge["42m"]["b"]=[47.06,5.26]
BoneAge["42m"]["g"]=[56.61,3.98]
BoneAge["48m"]["b"]=[51.24,4.59]
BoneAge["48m"]["g"]=[57.94,3.91]
BoneAge["54m"]["b"]=[53.94,4.35]
BoneAge["54m"]["g"]=[59.89,3.36]
BoneAge["60m"]["b"]=[56.24,4.07]
BoneAge["60m"]["g"]=[61.52,2.69]

near(str){
	tmp:=[]
	stringreplace,n,str,m
	
	
	
	
	if instr(str,"m")
	{
		if n>=60
			tmp.push("54m","60m")
		else if n>=54
			tmp.push("48m","54m","60m")
		else if n>=48
			tmp.push("42m","48m","54m")
		else if n>=42
			tmp.push("36m","42m","48m")
		else if n>=36
			tmp.push("30m","36m","42m")
		else if n>=30
			tmp.push("24m","30m","36m")
		else if n>=24
			tmp.push("18m","24m","30m")
		else if n>=18
			tmp.push("12m","18m","24m")
		else if n>=12
			tmp.push("9m","12m","18m")
		else if n>=9
			tmp.push("6m","9m","12m")
		else if n>=6
			tmp.push("3m","6m","9m")
		else if n>=3
			tmp.push("1m","3m","6m")
		else
			tmp.push("1m","3m")
		
		n:=n/12		
	}
	
	if n>=6
		tmp.push(floor(n),floor(n)+1)
	else if n>=1
		tmp.push(floor(n*2)/2,floor(n*2)/2+0.5)
	else
		tmp.push("1")
	
	return tmp	

	
}

;---------------- GUI
;~ gui,font,Verdana s10
;~ gui,add,text,,first copy the column of chart number, then...
;~ gui,add,button,gsubmit,GO!
;~ gui,show,,Bone age batch

return


submit: 
return


^b::
;~ ifwinnotexist,放射線資訊管理系統(Radiology Information System) ahk_class WindowsForms10.Window.8.app.0.378734a
	RegExMatch(clipboard,"(\w)\w{5}\d",chartNo)
;~ else
	;~ ControlGetText,chartNo,WindowsForms10.EDIT.app.0.378734a25
	;~ ControlGetText,chartNo,WindowsForms10.EDIT.app.0.378734a27

if !chartNo
	return

domain:="http://portal"
if !sid || !checkSID(sid)
	sid:=Login(loginId,loginPw)
html:=patientBasicInfo(chartNo,sid)
info:=parsePatientBasicInfo(html)
msgbox,,Bone Age,% info["name"] " - " info["age"]
return

RegExMatch(info["age"],"(\d*)y(\d*)m(\d*)d",match)
y:=match1,m=match2,d=match3

output=


return



#ifwinactive,Bone age batch
enter::
gosub submit
return
#ifwinactive










GuiClose:
exitsub:
!q::
exitapp
return