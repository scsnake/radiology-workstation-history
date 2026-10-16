﻿#SingleInstance,ignore
#NoEnv
#include <portalLib>
#include <Class_CTLCOLORS>

coordMode,mouse,screen
coordMode,pixel,screen
coordMode,tooltip,screen
SetBatchLines, -1
SetWorkingDir, %a_scriptdir%
SetTitleMatchMode,2
SendMode Input
SetControlDelay,-1
onexit,onexit
ComObjError(false)

;~ portalURL:="http://testenv.hospital-n.local/General/Login.aspx"
;~ wardURL:="http://tihisaw.hospital-n.local/WebApplication/InPatient/Ward/OpenWard.aspx"
portalURL:="http://portal.hospital-n.local/General/Login.aspx"
wardURL:="http://ihisaw.hospital-n.local/WebApplication/InPatient/Ward/OpenWard.aspx"

askForPortalIdPw()


firstColWidth=120
colWidth=40
rowHeight=20



orders:=[labs:=[],rad:=[]]
orderData:=[labsData:=[],radData:=[]]
orderType:=["NWeb1_OrderSearch1_rblOrderType_1","NWeb1_OrderSearch1_rblOrderType_3"]
orderTypeStr:=["Lab","Rad"]
subCategory:=["NWeb1_OrderSearch1_ddlMainCategory","NWeb1_OrderSearch1_ddlSubCategory"]
fileread,settings,% RegExReplace(a_scriptname,"s)\..+?$",".ini")
labCount:=0,radCount:=0
loop,parse,settings,`n
{
	if(regexmatch(a_loopfield,"s)^\[(.+)\]",match)){
		if(match1="settings")
			section=1
		else if(match1="檢驗")
			section=2
		else if(match1="影醫")
			section=3
		else
			section=0
	}else if(regexmatch(a_loopfield,"s)^(.+)=([^\n]+)",match)){
		if(section=1&&match1="defaultWard")
			defaultWard:=RegExReplace(trim(match2),"\W")
		else if(section=2){
			loadIni(labs,trim(match1),trim(match2))
		}else if(section=3){
			loadIni(rad,trim(match1),trim(match2))
			if(match1="CXR")
				CXRcol:=floor(labs.maxindex())+floor(rad.maxindex())
		}
	}
}



if !(labs.maxindex()||rad.maxindex()) {
	Msgbox Please configure settings in orderBatch.ini first!
	run,orderBatch.ini
	exitapp
}



askForPortalIdPw()

;~ ;test
;~ gosub guicheckbox
;~ return
setTimer,closePop,200
gosub main

;~ portalURL:="http://portal.hospital-n.local/General/Login.aspx"









return

loadIni(byref orderArr,key,value,orderCount=-1){
	arr:=[]
	arr["name"]:="" trim(key)
			value:=regexreplace(value,"\/{2}","¢")
			loop,parse,value,`,
			{
				i:=a_index
				if !(instr(a_loopfield,"/"))
					arr["code" i]:="" trim(a_loopfield)
				else
					loop,parse,a_loopfield,/
						arr["code" i,a_index]:="" regexreplace(regexreplace(a_loopfield,"¢","/"),"[\n\r\s]$")
			}	
	
	if(orderCount<0)
		orderArr.push(arr.Clone())
	else
		orderArr[orderCount]:=arr.Clone()
	
}



ChooseAnother:
secondChoice=1
main:
gui,destroy
gosub getWards
gui,+lastfound -resize
winget,guiHwnd,id
gui,font,s10,Verdana
;~ gui,add,text,,Choose ward
gui,add,DropDownList,vward gonWardChange,% toStr(wards)
gui,font,s5,Verdana
gui,add,text,xs y+5,scsnake@gmail.com
gui,show,w240 h60,Choose ward

if(defaultWard&&!secondChoice){
	;~ guicontrol,ChooseString,ward,% defaultWard
	for k,v in wards
		if(RegExReplace(v,"^0+|\W")=defaultWard){
			guicontrol,choose,ward,% "|" k
			break
		}
	
	;~ gosub onWardChange
}
return

onWardChange:
guicontrolget,ward,,ward
if(!trim(ward))
	return
guicontrol,disable,ward
#(pwb,"NWeb1_QueryInPatientPersonAccountControl1_DropListWard").value:=ward
#(pwb,"NWeb1_QueryInPatientPersonAccountControl1_DropListWard").onchange()
if !waitLoaded(pwb,func("fn2")){
	msgbox Can not find bed in %ward% ward
	guicontrol,enable,ward
	return
}
sleep 1000
beds:=[]
loop % #(pwb,"NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList").getElementsByTagName("TR").length-1 {
	ind:=fill0(a_index+1)
	beds[a_index,"room"]:=#(pwb,"NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl" ind "_RoomLabel").innerText
	beds[a_index,"bed"]:=#(pwb,"NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl" ind "_BedLabel").innerText
	beds[a_index,"name"]:=#(pwb,"NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl" ind "_LinkPatientName").innerText
	beds[a_index,"chartNo"]:=#(pwb,"NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl" ind "_PatChartNo").innerText
	beds[a_index,"link"]:=RegExReplace(RegExReplace(#(pwb,"NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl" ind "_LinkTreatOrder").outerHTML,"is).+window\.open\(\'([^\']+)\'.+","$1"),"&amp;","&")
}
if(!beds.maxIndex()){
	guicontrol,enable,ward
	return
}
gosub guiCheckBox
return


onChangeDate:
formattime,weekDay,% orderDate,WDay
emergentOrder:=(mod(weekDay,6)=1)?1:0
color("checkEmergentOrder",!emergentOrder)
guicontrol,,checkEmergentOrder,%emergentOrder%
return

color(var,black=0){
	return black?CTLCOLORS.detach(getHwnd(var)):CTLCOLORS.Attach(getHwnd(var), "FF2222")
}

getHwnd(var){
	GuiControlGet,id,hwnd,%var%
	return id
}

checkEmergentOrder:
guicontrolget,emergentOrder,,checkEmergentOrder
color("checkEmergentOrder",!emergentOrder)
return


ICUmode:
guicontrolget,ICUmode,,ICUmode
guicontrol,,checkEmergentOrder,% ICUmode
guicontrol,disable%ICUmode%,checkEmergentOrder
color("checkEmergentOrder",!(emergentOrder:=ICUmode))
color("ICUmode",!emergentOrder)
guicontrolget,orderDate,,orderDate
guicontrol,,orderDate,% substr(orderDate,1,8) (ICUmode?"000000":"080000")
return

export:
exportFile:=a_scriptdir "\orderBatch" loginId ".sav"
guicontrolget,orderDate,,orderDate
guicontrolget,checkEmergentOrder,,checkEmergentOrder
guicontrolget,ICUmode,,ICUmode


export:=ward "," orderDate "," checkEmergentOrder "," ICUmode "`n"
for k,v in orders
	for x,y in v
		export.=y.name ","
export.="`n"

gosub getMatrixData
for k,v in beds {
	export.=v.chartNo ":"

	;include orderMatrix[k,0]
	for x,y in orderMatrix[k]
		export.=y
	loop % x
		export.=!!emergentArr[k,a_index]
	loop % x
		export.=!!CXRAParr[k,a_index]
	loop % x
		export.=!!CXRbedarr[k,a_index]
	
	export.="`n"
}


if fileexist(exportFile) {
	msgbox,4,File existed,Replace old save?
	ifmsgbox,No
		return
	else
		filedelete,% exportFile
}
FileAppend,% export,% exportFile,utf-8
msgbox Saved!
return


import:
exportFile:=a_scriptdir "\orderBatch" loginId ".sav"
if !fileexist(exportFile) {
	msgbox No existed save!
	return
}
msgbox,4,,Overwrite current profile?
ifmsgbox,no
	return


fileread,import,% exportFile
i:=0
loop,parse,import,`n`r 
{
	if(a_loopfield="")
		continue
	++i
	if(i=1){
		regexmatch(a_loopfield,"([^,]+),(\d+),(\d),(\d)",match)
		if(match1!=ward){
			msgbox % "Ward not matched! (" match1 ")"
			return
		}
		orderDate:=match2,checkEmergentOrder:=match3,ICUmode:=match4
	}else if(i=2){
		str:="",orderCount:=0
		for k,v in orders
			for x,y in v
				str.=y.name ",",++orderCount
		if(trim(str)!=trim(a_loopfield)){
			msgbox % "Lab items not matched! (" regexreplace(a_loopfield,"`,$") ")"
			return
		}
	}else{
		regexmatch(a_loopfield,"(\w+):([^\n]+)",match)
		if(!ind:=checkChartNo(beds,match1)){
			msgbox % "No matched patient (" match1 ")!"
		}else{
			data:=substr(match2,2,orderCount)
			loop,parse,data
				guicontrol,,% "C" ind "_" a_index,% a_loopfield
			
			data:=substr(match2,orderCount+2,orderCount)
			loop,parse,data 
				color("C" ind "_" a_index,!(emergentArr[ind,a_index]:=a_loopfield))
			
			data:=substr(match2,2*orderCount+2,orderCount),data2:=substr(match2,3*orderCount+2,orderCount)
			loop,parse,data 
			{
				zz1:=CXRAParr[ind,a_index]:=a_loopfield,zz2:=CXRbedarr[ind,a_index]:=substr(data2,a_index,1)
				if(zz1&&zz2)
					guicontrol,,% "C" ind "_" a_index,+
				else if (zz1)
					guicontrol,,% "C" ind "_" a_index,-
				else if (zz2)
					guicontrol,,% "C" ind "_" a_index,|
				else
					guicontrol,,% "C" ind "_" a_index,% ""
			}
				
				
		}
	}

				
}
guicontrol,,orderDate,% orderDate
guicontrol,,ICUmode,% ICUmode
gosub ICUmode
guicontrol,,checkEmergentOrder,% checkEmergentOrder
gosub checkEmergentOrder
return

checkChartNo(byref beds,chartNo){
	for k,v in beds
		if(chartNo=v.chartNo)
			return k
	return 0
}

changeUser:
oldSid:=Sid
askForPortalIdPw(1)
guicontrol,,textLoginId,% loginId
for k,v in beds
	beds[k,"link"]:=regexreplace(v["link"],"i)" oldsid,sid)
return

guiCheckBox:
gui,destroy
loop 
	sleep 200
until (!winexist("ahk_id "guihwnd)) || a_index>25

gosub reset

gui,+lastfound -0xC00000 +0x800000
winget,guihwnd,id
gui,font,s8,Verdana
gui,add,datetime,2 vorderDate w200 Choose%orderDate% gonChangeDate,yyyy/MM/dd HH

gui,add,checkbox,vcheckEmergentOrder x+300 yp gcheckEmergentOrder,急單
gui,add,checkbox,vICUmode x+30 yp gICUmode,ICU模式
gui,add,text,x+40 yp gchangeUser,登入者：
gui,add,text,gchangeUser yp x+5 vtextLoginId,% loginId "      "
gosub onChangeDate
if (emergentOrder)
	color("checkEmergentOrder")

gui,font,s10 w700,Verdana
gui,add,text,xs y+5,% RegExReplace(ward,"^0+|\W")
gui,font,s8 w400,Verdana

;~ if ((beds.maxIndex()+1)*20+100>a_screenheight){
	;~ gui,font,s6,Verdana
;~ }

makeOrderTitle(orders)
makeOrderCheckall(orders)

;;;;;;;;;;;;;;; what if too many beds than can't be all displayed ? 
for x,y in beds {
	gui,add,text,% "xs yp+" rowHeight " vBed" x " gbedInfo",% y.room "-" y.bed "  "
	gui,add,checkbox,% "xp+" firstColWidth-colWidth " yp gcheckAll vC" x "_0"
	makeOrderCheckbox(orders)
}
gui,font,s8 w400,Verdana
gui,add,button,% "xs y+5 gGo",GO!
gui,add,button,% "xp+100 yp gReset",Reset
gui,add,button,% "xp+150 yp gChooseAnother",Choose another ward
gui,add,button,% "x+150 yp gGoExit",Exit
gui,add,button,% "x+50 yp gexport",Save
gui,add,button,% "x+10 yp gimport",Load

;~ if ((beds.maxIndex()+1)*20+100>a_screenheight){
	;~ gui,font,s6,Verdana
;~ }else{
	;~ gui,font,s8,Verdana
;~ }
gui,show,% "h" (beds.maxIndex()+1)*20+100,Batch Order
OnMessage(0x200, "WM_MOUSEMOVE")
return

makeOrderTitle(byref OrdersArr){
	global
	currentCol:=0
	for i,orderArr in OrdersArr {
		for k,v in OrderArr {
			if(currentCol+k=1)
				gui,add,text,% "xp+" firstColWidth " yp vLab" currentCol+k,% v.name "  "
			else
				gui,add,text,% "xp+" colWidth " yp vLab" currentCol+k,%  v.name "  "
		}
		currentCol+=k
	}
}	

makeOrderCheckall(byref OrdersArr){
	global
	currentCol:=0
	for i,orderArr in OrdersArr {
		for k,v in OrderArr {
			if(currentCol+k=1)
				gui,add,checkbox,% "xs+" firstColWidth " yp+" rowHeight " vC0_" (currentCol+k) " gcheckAll"
			else
				gui,add,checkbox,% "xp+" colWidth " yp vC0_" (currentCol+k) " gcheckAll"
		}
		currentCol+=k
	}
}	

makeOrderCheckbox(byref OrdersArr){
	global
	currentCol:=0
	for i,orderArr in OrdersArr {
		for k,v in OrderArr {
			if(currentCol+k=1)
				gui,add,checkbox,% "gitems xp+" colWidth " yp vC" x "_" currentCol+k
			else
				gui,add,checkbox,% "gitems xp+" colWidth " yp vC" x "_" currentCol+k
		}
		currentCol+=k
	}
}	




Reset:
orderDate:=a_now
if !(floor(substr(orderDate,9,2))<8)
	orderDate+=1,days
orderDate:=substr(orderDate,1,8) "080000"
guicontrol,,orderDate,% orderDate
guicontrol,,ICUmode,0
gosub ICUmode
gosub onchangedate

emergentOrder:=0
emergentArr:=[]
CXRAParr:=[]
CXRbedarr:=[]

loop % beds.maxindex()+1 {
	i:=a_index
	loop % labs.maxindex()+1 {
		guicontrol,,% "C" i-1 "_" a_index-1,0
		guicontrol,,% "C" i-1 "_" a_index-1,% ""
		color("C" i-1 "_" a_index-1,1)
	}
}
return

GoExit:
msgbox,4,Exit?
IfMsgBox,Yes
	gosub onexit
else 
	return
return

getMatrixData:
orderMatrix:=[]
for i,j in beds {
	any1:=0,currentCol:=0
	for k,orderArr in orders {
		any2:=0
		for m,n in orderArr {
			guicontrolget,v,,% "C" i "_" currentCol+m
			any2|=(orderMatrix[i,currentCol+m]:=orderData[k,i,m]:=v)
		}
		currentCol+=m
		any1|=(orderData[k,i,0]:=any2)
	}
	orderMatrix[i,0]:=any1
}
return

Go:
gui,hide
pwb.visible:=true
guicontrolget,orderDate,,orderDate
guicontrolget,ICUmode,,ICUmode
FormatTime,orderDate,% orderDate,yyyy/MM/dd HH

gosub getMatrixData

if !checkSid(sid)
	sid:=login(loginId,loginPw)

currentCol:=0
for k,v in orderMatrix {
	;for each bed (k)
	orderCountArr:=[]
	
	currentCol:=0

	if(!orderMatrix[k,0])
		continue
	
	pwb.Navigate(beds[k,"link"])
	if !waitLoaded(pwb,func("fn3")) {
		msgbox % "Can not connect to " beds[k,"link"]
		gosub end
	}
	if !instr(#(pwb,"NWeb1_OrderEntryCommonSelection1_PatientAbstractBasicInfo1_LabelAbstractInfo").innerText,beds[k,"chartNo"]) {
		lg("Patient " beds[k,"name"] " (" beds[k,"chartNo"] ") is not at " ward beds[k,"room"] "-" beds[k,"bed"] " !")
		continue
	}
	
	for i,categoryData in orderData {
		;for each category (i)
		orderCount:=0
		if(!categoryData[k,0]){
			currentCol+=floor(categoryData[k].maxIndex())
			continue
		}
		
			
				
		for m,n in categoryData[k] {
			;for each category item (m) and its value (n)
			
			emergent:=emergentArr[k,currentCol+m]
			if !n || !m || ((ICUmode||emergent) && !orders[i,m,"code2"] && i=1) || (!(ICUmode||emergent) && !orders[i,m,"code1"] && i=1)
				continue
			
			
			
			if(i=1){
				currentOrder:=object("name",orders[i,m,"name"],"code",(ICUmode||emergent)?orders[i,m,"code2"]:orders[i,m,"code1"])
				readyFunc:=func("fn5")
			}else if(i=2){
				currentOrder:=object("name",orders[i,m,"name"],"code",((CXRAParr[k,currentCol+m]||ICUmode)?orders[i,m,"code2"]:orders[i,m,"code1"]))
				readyFunc:=func("fn55")
			}
			
			
			if(!isobject(currentOrder.code)){
				continue:=0
				if(#(pwb,"NWeb1_OrderSearch1_rblOrderType_0").checked!="true"){
						#(pwb,"NWeb1_OrderSearch1_rblOrderType_0").click()
						if !waitLoaded(pwb,func("ready3")) {
							msgbox % "Can not load " orderType[i]
							continue:=1
						}			
				}
				if(continue)
					continue
				
				#(pwb,"NWeb1_OrderEntryCommonSelection1_txbKeywordInput").value:=currentOrder.code
				#(pwb,"NWeb1_OrderEntryCommonSelection1_btnKeywordQuery").click()
				if !waitLoaded(pwb,func("fn4")) {
					msgbox % "Can not find " currentOrder.name " (" currentOrder.code ")"
					continue
				}
				#(pwb,"NWeb1_OrderSearch1_dlsOrders_ctl00_lbnName").click()
				
			}else{
				continue:=0
				if(#(pwb,orderType[i]).checked!="true"){
						#(pwb,orderType[i]).click()
						if !waitLoaded(pwb,func("ready3")) {
							msgbox % "Can not load " orderType[i]
							continue:=1
						}			
				}
				if(continue)
					continue
				
				continue:=0
				for x,y in currentOrder.code {
					if x>2
						break
					el:=#(pwb,subCategory[x])
					el.selectedIndex:=(getOptionByText(el,y).index)
					el.onchange()
					if !waitLoaded(pwb,func("ready3")){
						msgbox % "Can not load category " subCategory[x] " for " currentOrder.name
						continue:=1
						break
					}
					
				}
				if(continue)
					continue
				el:=0
				continue:=0
				loop {
					el:=#(pwb,"NWeb1_OrderSearch1_dlsOrders_ctl" fill0(a_index-1) "_lbnName")
					if(a_index>100 || !el.id){
						msgbox % "Can not find " currentOrder.name " under subcategory"
						continue:=1
						break
						
					}
				}until instr(trim(el.innerText),currentOrder["code",x])
				if(continue)
					continue
				el.click()
			}
			
			if !waitLoaded(pwb,readyFunc) {
				msgbox % "Can not add " currentOrder.name 
				continue
			}
			
			if(i=2){
				#(pwb,"NWeb1_EditTempOrders1_RadTempOrders1_lvwOrders_ctrl" RadCount "_cbxIsEmergency").checked:=((ICUmode||emergent)?"checked":"")
				#(pwb,"NWeb1_EditTempOrders1_RadTempOrders1_lvwOrders_ctrl" RadCount "_cbxIsBedSide").checked:=((CXRbedarr[k,currentCol+m]||ICUmode)?"checked":"")
			}
			++orderCount			
		}
		orderCountArr.push(orderCount)
		loop {
			el:=#(pwb,"NWeb1_EditTempOrders1_" orderTypeStr[i] "TempOrders1_lvwOrders_ctrl" a_index-1 "_txbPlanExecuteDateTime")
			if(!el.id)
				break
			el.value:=orderDate
		}
		currentCol+=m
	}
	
	any:=0
	for tmp,anyOrderCount in orderCountArr
		any|=anyOrderCount
	if !(any)
		continue
		
	#(pwb,"NWeb1_EditTempOrders1_btnConfirm").click()
	if !waitLoaded(pwb,func("fn6")) {
		msgbox Can not confirm temporary orders !
		continue
	}
	
	confirmLink:=RegExReplace(beds[k,"link"],"DoctorEnterOrder.aspx\?","OrderConfirm.aspx?ManagerKey=__PageOrderConfirm&") "&PIN="
	if (!pwb2.locationURL) && !((pwb2:=WBGet(beds[k,"chartNo"] " ahk_class IEFrame")) && pwb2.locationURL && instr(pwb2.locationURL,confirmLink)){
		run % "iexplore.exe """ confirmLink """"
		loop {
			if (a_index>300) {
				msgbox Can not connect to ward page!
				return
			}
			sleep 100
		} until (pwb2:=WBGet(beds[k,"chartNo"] " ahk_class IEFrame")) && pwb2.locationURL && instr(pwb2.locationURL,confirmLink)
	}
	pwb2.visible:=false
	pwb2.Navigate(confirmLink)
	if !waitLoaded(pwb2,func("fn7"),10) {
		msgbox Can not connect to order confirm page !
		continue
	}
		
	userName:=#(pwb2,"vertical").innerText
	loop % #(pwb2,"NWeb1_grvOrders").getElementsByTagName("TR").length-1 {
		if (#(pwb2,"NWeb1_grvOrders_ctl" fill0(a_index+1) "_lblCreateEmpName").innerText=userName)
			#(pwb2,"NWeb1_grvOrders_ctl" fill0(a_index+1) "_ckbSelect").checked:=1
		else
			#(pwb2,"NWeb1_grvOrders_ctl" fill0(a_index+1) "_ckbSelect").checked:=0
	}
	#(pwb2,"NWeb1_btnConfirm").click()
}
end:
gui,show
pwb.Navigate(wardURL "?SESSION=" sid)
return

Restart:
reload
return



lg(msg){
	FormatTime,logTime,% a_now,yyyy/MM/dd HH:mm:ss
	FileAppend,% logTime "`t" msg "`n",% regexreplace(a_scriptname,"s)\..+?$",".log"),utf-8
}

checkAll:
if !RegExMatch(a_guicontrol,"C0_(\d+)|C(\d+)_0",match)
	return
itemEmergentOrder:=(getkeystate("shift"))?(!emergentOrder):emergentOrder
CXRAP:=(getkeystate("ctrl")&&(match1=CXRcol))
CXRbed:=(getkeystate("alt")&&(match1=CXRcol))

guicontrolget,checkState,,% a_guicontrol

if(checkState&&CXRAP&&CXRbed)
	str:="+"
else if (checkState&&CXRAP&&!CXRbed)
	str:="-"
else if (checkState&&!CXRAP&&CXRbed)
	str:="|"
else
	str:=""

if (match1){
	loop % beds.maxIndex() {
		guicontrol,,% "C" a_index "_" match1,% checkState
		color("C" a_index "_" match1,!(emergentArr[a_index,match1]:=(checkState&&itemEmergentOrder)))
		
		CXRAParr[a_index,match1]:=(checkState&&CXRAP)
		CXRbedarr[a_index,match1]:=(checkState&&CXRbed)
		guicontrol,,% "C" a_index "_" match1,% str
	}
}else if (match2){
	loop % labs.maxIndex() {
		guicontrol,,% "C" match2 "_" a_index,% checkState
		color("C" match2 "_" a_index,!(emergentArr[match2,a_index]:=(checkState&&itemEmergentOrder)))
		
		CXRAParr[match2,a_index]:=(checkState&&CXRAP)
		CXRbedarr[match2,a_index]:=(checkState&&CXRbed)
		guicontrol,,% "C" match2 "_" a_index,% str
	}
}
return

items:
if !RegExMatch(a_guicontrol,"C(\d+)_(\d+)",match)
	return
itemEmergentOrder:=(getKeystate("shift"))?(!emergentOrder):emergentOrder
CXRAP:=(getkeystate("ctrl")&&(match2=CXRcol))
CXRbed:=(getkeystate("alt")&&(match2=CXRcol))

guicontrolget,itemCheckState,,% a_guicontrol
color(a_guicontrol,!(emergentArr[match1,match2]:=(itemCheckState&&itemEmergentOrder)))

CXRAParr[match1,match2]:=(itemCheckState&&CXRAP)
CXRbedarr[match1,match2]:=(itemCheckState&&CXRbed)
if(itemCheckState&&CXRAP&&CXRbed)
	str:="+"
else if (itemCheckState&&CXRAP&&!CXRbed)
	str:="-"
else if (itemCheckState&&!CXRAP&&CXRbed)
	str:="|"
else
	str:=""
guicontrol,,% "C" match1 "_" match2,% str


return


bedInfo:
if !RegExMatch(a_guicontrol,"Bed(\d+)",match)
	return
tooltip,% beds[match1,"name"] "`n" beds[match1,"chartNo"]
setTimer,tooltip,-2000
return

tooltip:
tooltip
return


;// Access an IE object by WinTitle and Internet Explorer_Server Number:
WBGet(WinTitle="ahk_class IEFrame", Svr#=1) {               ;// based on ComObjQuery docs
   static msg := DllCall("RegisterWindowMessage", "str", "WM_HTML_GETOBJECT")
        , IID := "{0002DF05-0000-0000-C000-000000000046}"   ;// IID_IWebBrowserApp
;//     , IID := "{332C4427-26CB-11D0-B483-00C04FD90119}"   ;// IID_IHTMLWindow2
   SendMessage msg, 0, 0, Internet Explorer_Server%Svr#%, %WinTitle%
   if (ErrorLevel != "FAIL") {
      lResult:=ErrorLevel, VarSetCapacity(GUID,16,0)
      if DllCall("ole32\CLSIDFromString", "wstr","{332C4425-26CB-11D0-B483-00C04FD90119}", "ptr",&GUID) >= 0 {
         DllCall("oleacc\ObjectFromLresult", "ptr",lResult, "ptr",&GUID, "ptr",0, "ptr*",pdoc)
         return ComObj(9,ComObjQuery(pdoc,IID,IID),1), ObjRelease(pdoc)
      }
   }
}

getWards:
ComObjError(false)
if (!pwb.locationURL) && !((pwb:=WBGet("病房首頁選擇病人 ahk_class IEFrame")) && pwb.locationURL && instr(pwb.locationURL,wardURL)){
	run % "iexplore.exe """ wardURL "?SESSION=" sid """"
	loop {
		if (a_index>300) {
			msgbox Can not connect to ward page!
			return
		}
		sleep 100
	} until (pwb:=WBGet("病房首頁選擇病人 ahk_class IEFrame")) && pwb.locationURL && instr(pwb.locationURL,wardURL)
}
pwb.visible:=true
Loop
	sleep 200
until  (!pwb.busy) || a_index>150


if(#(pwb,"NWeb1_QueryInPatientPersonAccountControl1_DropListHosp").selectedIndex!=1){
	#(pwb,"NWeb1_QueryInPatientPersonAccountControl1_DropListHosp").selectedIndex:=1
	#(pwb,"NWeb1_QueryInPatientPersonAccountControl1_DropListHosp").onchange()
	if !waitLoaded(pwb,func("fn1"))
		return
}
sleep 500
wards:=[]
loop % #(pwb,"NWeb1_QueryInPatientPersonAccountControl1_DropListWard").options.length
	wards.push(#(pwb,"NWeb1_QueryInPatientPersonAccountControl1_DropListWard").options[a_index-1].value)
if(#(pwb,"NWeb1_QueryInPatientPersonAccountControl1_CheckBoxShowDrMainColumn").checked!=-1)
	#(pwb,"NWeb1_QueryInPatientPersonAccountControl1_CheckBoxShowDrMainColumn").click()
return

login:
while !checkSid(sid:=login(loginId,loginPw)){
	while !loginId
		inputbox,loginId,Enter portal ID,,,300,120
	while !loginPw
		inputbox,loginPw,Enter portal password,,HIDE,300,120
}
gosub main
return


closePop:
 ifwinexist,網頁訊息 ahk_class #32770
	WinClose,網頁訊息 ahk_class #32770
ifwinexist,ahk_class #32770,您正在檢視的網頁嘗試要關閉視窗
	controlclick,Button1,ahk_class #32770,您正在檢視的網頁嘗試要關閉視窗
return

ready(byref pwb){
	return !pwb.busy
}
ready2(byref pwb){
	return (#(pwb,"NWeb1_UpdateProgress1").style.display="none")
}
ready3(byref pwb){
	return (#(pwb,"NWeb1_UpdateProgress1").style.display="none")&&!pwb.busy
}
fn1(byref pwb){
	return (#(pwb,"NWeb1_QueryInPatientPersonAccountControl1_DropListWard").options.length=117)
}
fn2(byref pwb){
	global ward
	return (instr(#(pwb,"NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl02_WardLabel").innerText,ward))?1:0
}
fn3(byref pwb){
	return ready(pwb)&&ready2(pwb)&&(#(pwb,"NWeb1_OrderEntryCommonSelection1_txbKeywordInput").id)
}
fn4(byref pwb){
	return ready(pwb)&&ready2(pwb)&&(#(pwb,"NWeb1_OrderSearch1_dlsOrders_ctl00_lbnName").innerText)
}
fn5(byref pwb){
	global orderCount
	return ready(pwb)&&ready2(pwb)&&(#(pwb,"NWeb1_EditTempOrders1_LabTempOrders1_lvwOrders_ctrl" orderCount "_lblOrderName").innerText)
}
fn55(byref pwb){
	global orderCount
	return ready(pwb)&&ready2(pwb)&&(#(pwb,"NWeb1_EditTempOrders1_RadTempOrders1_lvwOrders_ctrl" orderCount "_lblOrderName").innerText)
}
fn6(byref pwb){
	return ready(pwb)&&ready2(pwb)&&(!#(pwb,"NWeb1_EditTempOrders1_LabTempOrders1_lvwOrders_ctrl0_lblOrderName").innerText)
}
fn7(byref pwb){
	return ready(pwb)&&(#(pwb,"NWeb1_grvOrders").innerText)
}

toStr(byref arr,output=0){
	str:=""
	if (!output){
		for k,v in arr
			str.=v "|"
		return regexreplace(str,"\|$")
	}
}

WM_MOUSEMOVE(){    
	static CurrControl, PrevControl 
	CurrControl:=a_guicontrol
    If (CurrControl <> PrevControl)
    {
		if(regexmatch(PrevControl,"C(\d+)_(\d+)",match)){
			guicontrol,font,% "bed" match1
			guicontrol,font,% "lab" match2
		}else if(regexmatch(PrevControl,"Bed(\d+)",match)){
			guicontrol,font,% "bed" match1
		}
		;~ else if(regexmatch(PrevControl,"Lab(\d+)",match)){
			;~ guicontrol,font,% "lab" match1
		;~ }
		
		gui,font,W700 underline
		if(regexmatch(CurrControl,"C(\d+)_(\d+)",match)){
			guicontrol,font,% "bed" match1
			guicontrol,font,% "lab" match2
		}else if(regexmatch(CurrControl,"Bed(\d+)",match)){
			guicontrol,font,% "bed" match1
		}
		;~ else if(regexmatch(CurrControl,"Lab(\d+)",match)){
			;~ guicontrol,font,% "lab" match1
		;~ }
		gui,font,norm
    }
	PrevControl := CurrControl
    return
}

onexit:
pwb.visible:=true
pwb2.quit()
ExitApp
return

GuiClose:
~esc::
gosub goexit
return
