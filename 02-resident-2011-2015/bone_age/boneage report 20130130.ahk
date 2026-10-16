/*
20130118
scsnake@gmail.com
*/

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,force
SetBatchLines, -1
coordMode,mouse,screen
coordMode,pixel,screen
coordMode,tooltip,screen
SetTitleMatchMode,2
SetControlDelay,-1
SetFormat, float, 2.1

#include ../portalLib/portalLib.ahk

iniRead,loginId,login.ini,portal,id
iniRead,loginPw,login.ini,portal,pw



while !checkSid(sid:=Login(loginId,loginPw)) {
	if a_index>50
		exitapp
	inputbox,loginId,Enter portal login ID,,,,,,,,,% (loginId="ERROR")?"":loginId
	if errorlevel
		exitapp
	inputbox,loginPw,Enter portal login password
	if errorlevel
		exitapp
	sleep 200
}
iniwrite,% loginId,login.ini,portal,id
iniwrite,% loginPw,login.ini,portal,pw

OnExit,exitsub

gui,font,s8,Verdana
gui,+LastFound +AlwaysOnTop
;~ winset,transparent,200
winget,guiHwnd,id
gui,add,edit,vChartNo disabled w100
gui,add,edit,vptGender disabled xp+110 w30
gui,add,edit,yp xp+40 vboneAge w80 hwndboneAgeId,
;~ gui,add,text,yp x+5,"12.5" for "12y5m"
gui,add,checkbox,xs vifCountCenters,ossified centers
gui,add,button,yp xp+150,CopyPaste
gui,font,s7,Verdana
gui,add,edit,w300 h80 xs vreport
gui,show,y100,% "Bone Age Report System"

settimer,renewChartNo,500
;~ settimer,getAge,500
settimer,refreshReport,250
;---------------- bone age data

BoneAgeArr:=[]

BoneAgeArr[1,"M"]:=2.1
BoneAgeArr[1,"F"]:=2.7
BoneAgeArr[2,"M"]:=4.0
BoneAgeArr[2,"F"]:=4.0
BoneAgeArr[3,"M"]:=6.0
BoneAgeArr[3,"F"]:=5.6
BoneAgeArr[4,"M"]:=7.0
BoneAgeArr[4,"F"]:=7.2
BoneAgeArr[5,"M"]:=8.4
BoneAgeArr[5,"F"]:=8.6
BoneAgeArr[6,"M"]:=9.3
BoneAgeArr[6,"F"]:=9.0
BoneAgeArr[7,"M"]:=10.1
BoneAgeArr[7,"F"]:=8.3
BoneAgeArr[8,"M"]:=10.8
BoneAgeArr[8,"F"]:=8.8
BoneAgeArr[9,"M"]:=11.0
BoneAgeArr[9,"F"]:=9.3
BoneAgeArr[10,"M"]:=11.4
BoneAgeArr[10,"F"]:=10.8
BoneAgeArr[11,"M"]:=10.5
BoneAgeArr[11,"F"]:=12.3
BoneAgeArr[12,"M"]:=10.4
BoneAgeArr[12,"F"]:=14.0
BoneAgeArr[13,"M"]:=11.1
BoneAgeArr[13,"F"]:=14.6
BoneAgeArr[14,"M"]:=12.0
BoneAgeArr[14,"F"]:=12.6
BoneAgeArr[15,"M"]:=14.2
BoneAgeArr[15,"F"]:=11.2
BoneAgeArr[16,"M"]:=15.1
BoneAgeArr[17,"M"]:=15.4
BoneAgeArr[1.5,"M"]:=2.7
BoneAgeArr[1.5,"F"]:=3.4
BoneAgeArr[2.5,"M"]:=5.4
BoneAgeArr[2.5,"F"]:=4.8
BoneAgeArr[3.5,"M"]:=6.6
BoneAgeArr[3.5,"F"]:=6.5
BoneAgeArr[4.5,"M"]:=7.8
BoneAgeArr[4.5,"F"]:=8.0
BoneAgeArr[5.5,"M"]:=9.1
BoneAgeArr[5.5,"F"]:=8.9

BoneAgeArr["1m","M"]:=[4.11,1.41]
BoneAgeArr["1m","F"]:=[4.58,1.76]
BoneAgeArr["3m","M"]:=[6.63,1.86]
BoneAgeArr["3m","F"]:=[7.78,2.16]
BoneAgeArr["6m","M"]:=[9.61,1.95]
BoneAgeArr["6m","F"]:=[11.44,2.53]
BoneAgeArr["9m","M"]:=[11.88,2.66]
BoneAgeArr["9m","F"]:=[15.36,4.92]
BoneAgeArr["12m","M"]:=[13.96,3.96]
BoneAgeArr["12m","F"]:=[22.40,6.93]
BoneAgeArr["18m","M"]:=[19.27,6.61]
BoneAgeArr["18m","F"]:=[34.10,8.44]
BoneAgeArr["24m","M"]:=[29.21,8.10]
BoneAgeArr["24m","F"]:=[43.44,6.65]
BoneAgeArr["30m","M"]:=[37.59,7.40]
BoneAgeArr["30m","F"]:=[48.91,6.50]
BoneAgeArr["36m","M"]:=[43.42,5.34]
BoneAgeArr["36m","F"]:=[52.73,5.48]
BoneAgeArr["42m","M"]:=[47.06,5.26]
BoneAgeArr["42m","F"]:=[56.61,3.98]
BoneAgeArr["48m","M"]:=[51.24,4.59]
BoneAgeArr["48m","F"]:=[57.94,3.91]
BoneAgeArr["54m","M"]:=[53.94,4.35]
BoneAgeArr["54m","F"]:=[59.89,3.36]
BoneAgeArr["60m","M"]:=[56.24,4.07]
BoneAgeArr["60m","F"]:=[61.52,2.69]



func2(b,gender){
	global BoneAgeArr
	arr:=[1,3,6,9,12,18,24,30,36,42,48,54,60]
	for k,v in arr
		if BoneAgeArr[v "m",gender][1]>b
			break
	k:=k=1?2:k
	return round(arr[k-1]+(arr[k]-arr[k-1])*(b-BoneAgeArr[arr[k-1] "m",gender][1])/(BoneAgeArr[arr[k] "m",gender][1]-BoneAgeArr[arr[k-1] "m",gender][1]))
}

; update needed 
near(str,gender){
	tmp:=[]
	stringreplace,n,str,m
	
	
	
	
	if instr(str,"m")
	{
		if n>=60
			tmp:=["54m","60m"]
		else if n>=54
			tmp:=["48m","54m","60m"]
		else if n>=48
			tmp:=["42m","48m","54m"]
		else if n>=42
			tmp:=["36m","42m","48m"]
		else if n>=36
			tmp:=["30m","36m","42m"]
		else if n>=30
			tmp:=["24m","30m","36m"]
		else if n>=24
			tmp:=["18m","24m","30m"]
		else if n>=18
			tmp:=["12m","18m","24m"]
		else if n>=12
			tmp:=["9m","12m","18m"]
		else if n>=9
			tmp:=["6m","9m","12m"]
		else if n>=6
			tmp:=["3m","6m","9m"]
		else if n>=3
			tmp:=["1m","3m","6m"]
		else
			tmp:=["1m","3m"]
		
		n:=n/12		
	}
	else if(n>=17&&gender="m")
		tmp:=[16,17]
	else if(n>=15&&gender="f")
		tmp:=[14,15]
	else if n>=6
		tmp:=[floor(n),floor(n)+1]
	else if n>=1
		tmp:=[RegExReplace(floor(n*2)/2,".0+$"),regexreplace(floor(n*2)/2+0.5,".0+$")]
	else
		tmp:=[1]
	
	
	
	return tmp	
}



boneAgeReport(age,gender,ifCountCenters,boneage){
	global BoneAgeArr
	str:=""
	
	RegExMatch(age,"(?:(\d+)y)?(?:(\d+)m)?(?:(\d+)d)?",match)
	if match1=
		match1=0
	if match2=
		match2=0
	
	if !ifCountCenters {
		for k,v in near(match1+match2/12,gender)
			str.="Standard deviation of " v " y/o: " BoneAgeArr[v][gender] " M`r`n"
		
		
		
		str.="Chronological age:  " match1 " Yr and " match2 " M`r`n"
		
		RegExMatch(boneage,"(\d+)(?:\.(\d+))?",match)
		match1:=match1?match1:0
		match2:=match2?match2:0
		str.="Examed skeletal bone age:  " match1 " Yr and " match2 " M"
		
	}else {
		str.="Chronological age:  " match1*12+match2 " M`r`n"
		str.="Number of ossification centers: " boneage "`r`n"
		
		near:=near(match1*12+match2 "m",gender)
		;~ if near.maxIndex()=3 {
			;~ a:=RegExReplace(near[2],"m"),b:=RegExReplace(near[3],"m")
			;~ c:=BoneAgeArr[near[2]][gender][1],d:=BoneAgeArr[near[3]][gender][1]
			;~ str.="Examed skeletal bone age:  " round(a+(b-a)*(boneage-c)/(d-c)) " M`r`n`r`n"
			
		;~ }else{
			;~ str.="Examed skeletal bone age:   M`r`n`r`n"
		;~ }
		str.="Examed skeletal bone age:  " func2(boneage,gender) " M`r`n`r`n"
		
		for k,v in near
			str.="Mean number of ossification centers at " RegExReplace(v,"m") " M: " BoneAgeArr[v][gender][1] "`t`tSD: " BoneAgeArr[v][gender][2] "`r`n"
	}
	return str
}


return

ButtonCopyPaste:
gui,submit,nohide
if (RisID:=RisOpened())[1]!=2
	return
for k,v in risControls:=getcontrols(risId[2]) {
	if v.text="Exam." && instr(risControls[k+1]["classNN"],"WindowsForms10.EDIT.app") && risControls[k+3]["text"]="Impression" {
		ControlSetText,,% boneAgeReport(ptInfo.age,ptInfo.gender,ifCountCenters,boneage),% "ahk_id " risControls[k+1]["hwnd"]
		break
	}
}

winactivate,% "ahk_id " risid[2]
for k,v in risControls:=getcontrols(risId[2]) {
	if instr(v.text,"暫存") && instr(v.classNN,"WindowsForms10.BUTTON.app") {
		controlclick,,% "ahk_id " v.hwnd
		break
	}
}

return

renewChartNo:
if (RisID:=RisOpened())[1]!=2
	return
for k,v in risControls:=getcontrols(risId[2]) {
	if RegExMatch(v.text,"(?:\w)\w{5}\d") && instr(v.classNN,"WindowsForms10.EDIT.app") && risControls[k-1].text="病歷號" && risControls[k+2].text="姓名" {
		guicontrol,,chartNo,% v.text
		break
	}
}
gosub getAge
return


/* check if RIS opened
[0, 0]: no
[1, HWND]: wait for login
[2, HWND]: opened
*/
RisOpened()
{
	winget,winList,list,放射線資訊管理系統(Radiology Information System)
    winget,activeWin,id,A
	loop % winList
	{
		wingetclass, winClass,% "ahk_id " winList%a_index%
		if instr(winClass,"WindowsForms10.Window.8.app.")
			return array(2,winList%a_index%)
	}
	
	winget,winList,list,RIS系統登入<<陽明資訊>>
	loop % winList
	{
		wingetclass, winClass,% "ahk_id " winList%a_index%
		if instr(winClass,"WindowsForms10.Window.8.app.")
			return array(1,winList%a_index%)
	}
			
	return array(0,0)
}

GetControls(hwnd)
{
	controls:=[]
	winget,classnn,ControlList,ahk_id %hwnd%
	winget,controlId,controllisthwnd,ahk_id %hwnd%
	loop,parse,classnn,`n
	{
		controls[a_index]:=[]
		controls[a_index]["ClassNN"]:=a_loopfield
	}
	
	loop,parse,controlId,`n
	{
		controls[a_index]["Hwnd"]:=a_loopfield
		controlgetText,txt,,ahk_id %a_loopfield%
		controls[a_index]["text"]:=txt
	}
	return controls
}



GetControlIdByText(byref arr,RefControlText,offset=0,UseRegEx=0)
{
	if !isobject(arr)||!arr.maxIndex()
        return
	k=0
	if UseRegEx
	{
		for k,v in arr
			if RegExMatch(v.text,RefControltext)
				break
	}
	else
	{
		for k,v in arr
			if v.text=RefControltext
				break
		if !k
			for k,v in arr
				if instr(v.text,RefControltext)
					break
	}
	
	if !offset
		i:=k
	else
	{
		i:=k+offset
		l:=arr.MaxIndex()
		while i>l
			i-=l
		while i<1
			i+=l
	}
	return (k=0 ? 0 : arr[i]["Hwnd"])
	
}




submit: 
return

getAge:
gui,submit,nohide
if(chartNo=prevChartNo)
	return
else
	prevChartNo:=chartNo


if !sid || !checkSID(sid)
	sid:=Login(loginId,loginPw)

ptInfo:=patientBasicInfo(chartNo,sid)
guicontrol,,boneage,% ""
guicontrol,,ifCountCenters,0
guicontrol,,report,% boneAgeReport(ptInfo.age,ptInfo.gender,0,"")
guicontrol,,ptGender,% ptInfo.gender
return


refreshReport:
gui,submit,nohide
;~ traytip,,% prevBoneAge "=" boneAge
if(boneAge=prevBoneAge && strlen(boneage)=strlen(prevBoneage) && ifCountCenters=previfcountcenters)
	return
else
	prevBoneAge:=boneAge,previfcountcenters:=ifCountCenters

if boneage && !regexmatch(boneAge,"^\d+(\.\d+?)?$")
	return

guicontrol,,report,% boneAgeReport(ptInfo.age,ptInfo.gender,ifCountCenters,boneage)
return






#ifwinactive,Bone Age Report System
numpadEnter::
enter::
gosub ButtonCopyPaste
return

tab::
guicontrolget,focused,focus
if (focused!="boneAge")
	controlfocus,,% "ahk_id " boneAgeId
return

#ifwinactive










GuiClose:
exitsub:
!q::
exitapp
return