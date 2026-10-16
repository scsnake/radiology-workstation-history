FileEncoding,utf-8
#NoEnv
#SingleInstance,Off
SetBatchLines,-1
DetectHiddenWindows, On
SetTitleMatchMode,2
coordmode,mouse,screen
#NoTrayIcon
#include <RisImpax>
#include <reportAnalysis>
#include <portallib>
#include <ProcessList>
;~ #include <JXON>
;~ #include <WM_COPYDATA>


SplitPath,A_ScriptFullPath,,,,fileNameNoExt

reportDir:=a_mydocuments "\feedRIS"
,args:=[]
Loop %0%
	if !InStr(%a_index%, fileNameNoExt)
		args.push(%a_index%)

if !args.maxindex()
	goto main
else
	goto create


return 

create:
for k,v in ["sid", "chartNo", "accNo", "examName"]
	%v%:=args[k]
report:=AutoBriefReport(chartNo, accNo, sid, ByRef PacsHx)
if (report){
	FileAppend, % Trim(RegExReplace(report, "\r?\n", "`r`n")) " (This study is reassigned to current radiologist on " A_YYYY "/" a_mm "/" a_dd ".) ## `r`n-=-=-=-=-`r`n", % reportDir "\" accNo " " chartNo ".txt"
}
ExitApp
return



main:

sid:=askForPortalidpw()
,reportList:=[]
,RisState:=risopened()
,AccNoHwnd:=getRisAccNoHwnd(RisState[2])
,RisListHwnd:=getRisList(RisState[2])
,reportList:=parseDataGrid2(RisListHwnd)
,PacsHxPool:={}


for k,v in reportList[1] {
	if (v="照會單號") {
		AccNoCol:=k
	}
	if (v="病歷號") {
		chartNoCol:=k
	}
	if (v="檢查名稱") {
		examNameCol:=k
	}
	if (v="狀態") {
		statusCol:=k
	}
	if (v="檢查日") {
		examDateCol:=k
	}
	
}

for k,v in reportList {
	if k=1 
		continue
	AccNo:=v[AccNoCol]
	if !(accNo~="\w{11}")
		continue
	examName:=v[examNameCol]
	if !(examName~="i)^Chest : (AP|PA) View")
		continue
	
	chartNo:=v[chartNoCol]
	,newArg:=sid " " chartNo " " accNo " """ examName """"
	;~ report:=AutoBriefReport(chartNo, accNo, sid, ByRef PacsHx)
	run % fileNameNoExt ".exe " newArg
	
	Loop {
		Count:=0
		for m,n in ProcessList()
			if(n.name = fileNameNoExt ".exe")
				Count+=1
		Sleep 1000
	}until Count<12
	;~ if ++Count>30
		;~ ExitApp
}
ExitApp

return


;~ esc::ExitApp