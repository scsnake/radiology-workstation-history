#include <RisImpax>
#include <JXON>
#NoTrayIcon
SetTitleMatchMode,2
DetectHiddenWindows,On
CoordMode,Mouse,Screen


gosub registerMsg

gui,+hwndguiHwnd +toolwindow -caption -border -Resize
gui,add,text,vRisInfo,
gui,add,text,vImpaxInfo,

ris:=[], impax:=[]
settimer,risInfo,500
SetTimer,impaxInfo,500

return


risInfo:
checkRisChange()
checkRisAccChange()
checkRisReportChange()
checkRisOldReportChange()

return

impaxInfo:
checkImpaxChange()
checkImpaxAccChange()

return


registerMsg:
RisImpaxMsgProtocol()
changeNotify:=[]
for k,v in RisImpaxChangeMsg2Item {
	OnMessage(k, "registerChange")
	,changeNotify[v]:=[]
}

return

checkImpaxChange(){
	global cImpaxState, pImpaxState
	if (cImpaxState[1]!=pImpaxState[1]){
		RisImpaxChangeNotify("Impax")
		goto checkImpaxChangeReturn
	}
	
	for k,v in cImpaxState[2]
		if (v!=pImpaxState[2]){
			RisImpaxChangeNotify("Impax")
			goto checkImpaxChangeReturn
		}
	
	checkImpaxChangeReturn:	
	pImpaxState:=cImpaxState
	return
}


checkImpaxAccChange(){
	global cImpaxAcc, pImpaxAcc, cImpaxState
	
	if((cImpaxAcc:=getImpaxAccNo(cImpaxState[2,1]))!=pImpaxAcc){
		RisImpaxChangeNotify("ImpaxAcc")
		goto checkImpaxAccChangeReturn
	}
	
	checkImpaxAccChangeReturn:	
	pImpaxAcc:=cImpaxAcc
	return
}


checkRisChange(){
	global cRisState, pRisState
	if (cRisState[1].MaxIndex()!=pRisState[1].MaxIndex() || cRisState[2].MaxIndex()!=pRisState[2].MaxIndex()){
		RisImpaxChangeNotify("ris")
		goto checkRisChangeReturn
	}
	loop 2
		for k,v in cRisState[A_Index]
			if (v!=pRisState[A_Index, k]){
				RisImpaxChangeNotify("ris")
				goto checkRisChangeReturn
			}
	
	checkRisChangeReturn:	
	pRisState:=cRisState
	return
}


checkRisAccChange(){
	global cRisAcc, pRisAcc, cRisState
	
	if((cRisAcc:=ControlGetText(getRisAccNoHwnd(cRisState[2,1])))!=pRisAcc){
		RisImpaxChangeNotify("risAcc")
		goto checkRisAccChangeReturn
	}
	
	checkRisAccChangeReturn:	
	pRisAcc:=cRisAcc
	return
}
checkRisReportChange(){
	global cRisReport, pRisReport, cRisState, risReport
	risReport:=getRisReports(cRisState[2,1])
	if((cRisReport:=ControlGetText(risReport[1,1]) ControlGetText(risReport[1,2]))!=pRisReport){
		RisImpaxChangeNotify("risReport")
		goto checkRisReportChangeReturn
	}
	
	checkRisReportChangeReturn:	
	pRisReport:=cRisReport
	return
}
checkRisOldReportChange(){
	global cRisOldReport, pRisOldReport, cRisState, risReport
	if((cRisOldReport:=ControlGetText(risOldReport[2,1]) ControlGetText(risOldReport[2,2]))!=pRisOldReport){
		RisImpaxChangeNotify("risOldReport")
		goto checkRisOldReportChangeReturn
	}
	
	checkRisOldReportChangeReturn:	
	pRisOldReport:=cRisOldReport
	return
}

RisImpaxChangeNotify(item){
	global changeNotify, RisImpaxChangeItem2Msg
	for k,v in changeNotify[item] {
		if !WinExist(v)
			changeNotify[item].Delete(k)
		else
			SendMessage,% RisImpaxChangeItem2Msg[item],,,,ahk_id %v%
	}
}

registerChange(wParam, lParam, msg, hwnd){
	global changeNotify, RisImpaxChangeMsg2Item
	
	if((item:=RisImpaxChangeMsg2Item[msg])="")
		return
	
	for k,v in changeNotify[item]	{
		if !WinExist(v)
			changeNotify[item].Delete(k)
		else if v=hwnd
			duplicated:=1
	}
	
	if(duplicated)
		return
	
	changeNotify[item].push(hwnd)
}
