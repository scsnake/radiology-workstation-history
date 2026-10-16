﻿#Include ../COM.ahk
#SingleInstance,ignore
#NoEnv

coordMode,mouse,screen
coordMode,pixel,screen
coordMode,tooltip,screen
SetBatchLines, -1
SetWorkingDir, %a_scriptdir%
SetTitleMatchMode,2

generalDelay=200 
;~ portalURL:="http://portal.hospital-n.local/General/Login.aspx"
portalURL:="http://testenv.hospital-n.local/General/Login.aspx"
wardURL:="http://tihisaw.hospital-n.local/WebApplication/InPatient/Ward/OpenWard.aspx?SESSION="
SessionId=
sig:=object()

onexit,on_exit
setTimer,closePop,200


gosub main
return

closePop:
ifwinexist,網頁訊息 ahk_class #32770
	WinClose
return

main:
gui,+lastfound +border +resize
winget,mainGUIhwnd,id
Gui, Font, S8 CDefault, Verdana

labNameArr:=["CXR","BUN","Cr","TBil","DBil","AST","ALT","Mg","CBC","DC","PT","PTT","CRP","Alb","Other"]
bedNoArr:=["01","02","03","05","06","07","08","09","10","11","12","13","15","16","17","18"]
gosub buildCheckboxTable
gui,add,button,% "xs yp+" rowInterval " gstartBatch",GO!
gui,show
OnMessage(0x200, "WM_MOUSEMOVE")

return

WM_MOUSEMOVE()
{    
	static CurrControl, PrevControl 
	CurrControl:=a_guicontrol
    If (CurrControl <> PrevControl)
    {
		if(regexmatch(PrevControl,"C_([^_]+)_([^_]+)",match))
		{
			guicontrol,font,% "text" match1
			guicontrol,font,% "title" match2
		}
		if(regexmatch(CurrControl,"C_([^_]+)_([^_]+)",match))
		{
			gui,font,W700 underline
			guicontrol,font,% "text" match1
			guicontrol,font,% "title" match2
			gui,font,norm
		}
		
    }
	PrevControl := CurrControl
    return

}

fill_space(byref str,fullLen)
{
	b:=fullLen-strlen(str)
	if(b<=0)
		return % str
	loop % b
		str.=" "
	return % str
}

buildCheckboxTable:
columnInterval:=40,rowInterval:=20
gui,add,text,,% "    "
gui,add,text,% "yp xp+" columnInterval,% "    "
for k,v in labNameArr
	gui,add,text,% "xp+" columnInterval " yp vtitle" v,% fill_space(v,5)

gui,add,text,% "xs yp+" rowInterval,% "    "
gui,add,checkbox,% "yp xp+" columnInterval " gcheck_all vC_All_All"
for k,v in labNameArr
	gui,add,checkbox,% "xp+" columnInterval " yp gcol_check_all vC_All_" v,

for k1,v1 in bedNoArr
{
	gui,add,text,% "xs yp+" rowInterval " vtext" v1,% v1 " "
	gui,add,checkbox,% "xp+" columnInterval " yp grow_check_all vC_" v1 "_All"
	for k2,v2 in labNameArr
		gui,add,checkbox,% "xp+" columnInterval " yp vC_" v1 "_" v2
}
return

check_all:
guicontrolget,v,,% a_guicontrol
for k1,v1 in bedNoArr
{
	guicontrol,,% "C_" v1 "_All",% v
	for k2,v2 in labNameArr
	{
		if k1=1
			guicontrol,,% "C_All_" v2,% v
		guicontrol,,% "C_" v1 "_" v2,% v
	}
}
return

col_check_all:
RegExMatch(a_guicontrol,"C_All_([^_]+)",match)
guicontrolget,v,,% a_guicontrol
for k1,v1 in bedNoArr
	guicontrol,,% "C_" v1 "_" match1,% v
return

row_check_all:
RegExMatch(a_guicontrol,"C_([^_]+)_All",match)
guicontrolget,v,,% a_guicontrol
for k1,v1 in labNameArr
	guicontrol,,% "C_" match1 "_" v1,% v
return

arr_or(byref arr,starti,startj,endi,endj)
{
	v:=false
	loop % endi-starti+1
	{
		i:=starti+a_index-1
		loop % endj-startj+1
			v:=v || arr[i,startj+a_index-1]
	}
	return,v
}
		
msgArr(byref arr)
{
	str:=""
	if(!isobject(arr))
	{
		msgbox % arr
		return
	}
	
	for k1,v1 in arr
	{
		if IsObject(v1)
			for k2,v2 in v1
				if isobject(v2)
					str.="obj`t"
				else
					str.=v2 "`t"
		else
			str.=v1
		
		str.="`n"
	}
	msgbox % str
}

startBatch:
gui,submit
dataArr:=object(),dataArr2:=object()
for k1,v1 in bedNoArr
{
	for k2,v2 in labNameArr
	{
		guicontrolget,v,,% "C_" v1 "_" v2
		dataArr[k1,k2]:=v
	}
}

allCheckbox:=false
for k,v in bedNoArr
{
	dataArr2[k,1]:=dataArr[k,1]
	dataArr2[k,2]:=arr_or(dataArr,k,2,k,k2)
	allCheckbox:=allCheckbox||dataArr2[k,1]||dataArr2[k,2]
}

if(!allCheckbox)
	return



COM_AtlAxWinInit()
Gui, 2: +LastFound +Resize
winget,portalGUIhwnd,id
pwb := COM_AtlAxGetControl(COM_AtlAxCreateContainer(WinExist(),0,0,a_screenwidth,a_screenheight-100, "Shell.Explorer") )
;~ IOleInPlaceActiveObject_Interface:="{00000117-0000-0000-C000-000000000046}"
;~ pipa := COM_QueryInterface(pwb, IOleInPlaceActiveObject_Interface)
pwb.Navigate(portalURL)


gui,2: show,maximize,ICU批次開單

setTimer,waitLogin,200
while(!sig[0])
	sleep 200
sig[0]:=0
setTimer,waitLogin,off
;~ msgbox % SessionId

pwb.Navigate(wardURL . SessionId)
targetObj:="NWeb1_QueryInPatientPersonAccountControl1_DropListHosp"
sleep % generalDelay
if(waitDomObj(pwb,targetObj))
	msgExit("連線至病房系統錯誤")
if(pwb.document.getElementById(targetObj).value<>"T0")
{
	pwb.document.getElementById(targetObj).value="T0"
	msgbox set
	sleep % generalDelay
}
	msgbox pass

targetObj:="NWeb1_QueryInPatientPersonAccountControl1_DropListWard"
if (waitDomObj(pwb,targetObj))
	msgExit("連線至病房系統錯誤")
if (pwb.document.getElementById(targetObj).value<>"06PE")
{
	pwb.document.getElementById(targetObj).value="06PE"
	sleep % generalDelay
}

targetObj:="NWeb1_QueryInPatientPersonAccountControl1_CheckBoxShowDrMainColumn"
if (waitDomObj(pwb,targetObj))
	msgExit("連線至病房系統錯誤")
if (not pwb.document.getElementById(targetObj).checked)
{
	pwb.document.getElementById(targetObj).click()
	sleep % generalDelay
}

targetObj:="NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList"
if (waitDomObj(pwb,targetObj))
	msgExit("經查詢無病人")

for k1,v1 in dataArr
{
	if(! dataArr2[k1,1]&&dataArr2[k1,2])
		continue
	
	ptDataRows:=pwb.document.getElementById("NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList").rows
	loop % ptDataRows.length-1
	{
		if(ptDataRows[a_index].cells[1]=bedNoArr[k1])
		{
			treatOrderText:=pwb.document.getElementById("NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl" fil(k1+1,2) "_LinkTreatOrder").onclick
			msgbox % treatOrderText
			RegExMatch(treatOrderText,"(?=')[^']+",treatOrderURL)
			msgbox % treatOrderURL
			break
		}
	}
	
	Gui, 3: +LastFound +Resize
	winget,treatOrderGUIhwnd,id
	pwb2 := COM_AtlAxGetControl(COM_AtlAxCreateContainer(WinExist(),0,0,a_screenwidth,a_screenheight-100, "Shell.Explorer") )
	pwb2.Navigate(treatOrderURL)
	gui,3: show,診療醫令

}




return


waitLogin:
;~ if(RegExMatch(pwb.LocationURL,"is)portal.+?General\/Redirect.aspx\?SESSION=(.+?)",match))
sleep % generalDelay
if(RegExMatch(pwb.LocationURL,"is)testenv.+?Redirect.aspx\?SESSION=(.+)",match))
	SessionId:=match1, sig[0]:=1
return

msgExit(str,ex=0)
{
	msgbox % str
	if ex=0
		exitapp
}

waitDomObj(byref pwb,objId,timeOut=10,checkInterval=200)
{
	Loop
	{
		if(a_index>timeOut*1000/checkInterval)
			return 1
		if(pwb.readyState=4 && pwb.document.getElementById(objId))
			return 0
		sleep % checkInterval
	}
}

waitLoaded(byref pwb,urlRegEx="",timeOut=10,checkInterval=200)
{
	Loop
	{
		if(a_index>timeOut*1000/checkInterval)
			return 1
		if(pwb.readyState=4 && RegExMatch(pwb.LocationURL,urlRegEx))
			return 0
		sleep % checkInterval
	}
			
}

fil(str,len,fill=" ")
{
	tmp:=""
	if strlen(tmp)>=len
		return,str
	loop % len-strlen(tmp)
		tmp:=fill
	return,fill . str
}

~esc::
pause
return

GuiClose:
if a_gui=2
{
	gui,show
	return
}
else if a_gui=1
~!q::
on_exit:
exitapp
return