#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,force
SetBatchLines, -1
coordMode,mouse,screen
coordMode,pixel,screen
coordMode,tooltip,screen
SetTitleMatchMode,2
setformat,float,0.2
SetControlDelay,-1
#SingleInstance,force
DetectHiddenWindows,on
#include <risimpax>
;~ #include <Class_RichEdit>
#include <SCI>
#include <prettyReport>
#include <JXON>
onexit,onexit

RisState:=risopened()
reportDir:=a_mydocuments "\feedRIS"
settimer,routine,200
;~ OnMessage(0x10101,"sendReport")

return


routine:
checkRIS(RisState)
if(!controlexist(RisAccNoHwnd)){
	RisAccNoHwnd:=getRisAccNoHwnd(RisState[2])
}
thisAccNo:=controlgettext(RisAccNoHwnd)
if(priorAccNo!=thisAccNo){
	if(!controlexist(RisReports[1,1])){
		RisReports:=getRisReports(RIsState[2])
	}
	text:=controlgettext(RisReports[1,1])
	settimer,AccChanged,-1
	SetTimer,routine,1000
}
priorAccNo:=thisAccNo
return




AccChanged:
GuiControlGet,ButtonPos,2:Pos, sendButton
WinGetPos,pX,pY,,,ahk_id %guihwnd%
gui,destroy
gui,2:Destroy

if (!reportListLoaded){
	SetTimer,openCurrentImage,-1
	gosub loadReportList
}


gui,+toolwindow +caption +alwaysontop
gui,font,s12.5,Georgia
gui,2:+hwndguihwnd +toolwindow +caption +alwaysontop
gui,2:font,s14 w500,Verdana
gui,2:add,text,,% getRisChartNo(RisState[2]) " - " thisAccNo
Position := 0,ind:=0,TextInd:=0
buffer:="",clickTrack:=[],delArr:=[],SCIind:=0,SCIarr:=[]
text:=RegExReplace(text, "(\d+)\.(\d)(\d*) ?cm", "$1$2mm")
text:=RegExReplace(text, "0(\d+)mm", "$1mm")
loop,parse,text,.;`n`r`t
{
	Position += StrLen(A_LoopField) + 1
	Delimiter := SubStr(text, Position, 1)
	if Trim(A_LoopField)="" {
		delArr[delArr.maxindex()]:=delArr[delArr.maxindex()] Delimiter
		continue
	}
	buffer:= a_loopfield 
	
	;~ if !regexmatch(a_loopfield,"\d+$")  {
		arr:=[]
		loop,parse,buffer,`,
			arr.push(a_loopfield)
		for k,v in arr {
			++ind
			gui,add,button,% (k=1?"y+20 x10 ":"yp x+5 ") "gclickEvent vbutton" ind " hwndButtonHwnd" ind  " ",% v
			GuiControlGet,T, Pos, % "button" ind
			++SCIind
			sci%SCIind%:=new scintilla(guihwnd,TX,lastY:=TY+20,TW,TH)
			,sr%SCIind%:=new StyleRange("")
			;~ ,sci%SCIind%.SETCARETSTYLE(0)
			,sciSetting(sci%SCIind%)
			,sci%SCIind%.SetText(unused,vv:=RegExReplace(v, "^ +", ""))
			;~ ,sci%SCIind%.SetReadOnly(1)
			,SCI_ColorRadReport(sci%SCIind%,sr%SCIind%,0)
			,SCIarr.push(sci%SCIind%.hwnd)
			
			if (k<arr.maxindex()){
				gui,Add,Text,% "yp x+5 vtext" ++TextInd,`,
				GuiControlGet,T, Pos, % "text" TextInd
				gui,2:Add,Text,% "x" TX " y" (lastY:=TY+20) " w" TW " h" TH,`,
				delArr.push(", ")
			}
			clickTrack[ind]:=0
		}
		if !RegExMatch(Delimiter,"\s"){
			gui,Add,Text,% "yp x+5 vtext" ++TextInd,% Delimiter
			GuiControlGet,T, Pos, % "text" TextInd
			gui,2:Add,Text,% "x" TX " y" (lastY:=TY+20) " w" TW " h" TH,% Delimiter
		}
		delArr.push(Delimiter)
		buffer:=""
	;~ }
	
}
;~ gui,add,edit,% "x10 y+15 vedit w600 r3 hwndeditHwnd"
;~ gui,add,button,% "x10 y+15 gsend",Send
;~ gui,show,autosize,
gui,2:Font,s12 w400,Verdana
gui,2:add,edit,% "x10 y" lastY+35 " vedit w600 r3 hwndeditHwnd"
gui,2:add,button,% "x10 y+15 gsend vsendButton",Send
gui,2:add,button,% "x+10 yp gsendWithTitle",Send with Title
gui,2:add,button,% "x+10 yp gIMPAX",IMPAX
GuiControlGet,thisButtonPos,2:pos,sendButton
ControlFocus,,ahk_id %editHwnd%
gui,2:show,% "autosize" (pX?"x" pX+ButtonPosX-thisButtonPosX " y" pY+ButtonPosY-thisbuttonPosY:""),Check R Report

return

#IfWinExist,Check R Report ahk_class AutoHotkeyGUI
~LButton::
MouseGetPos,,,win,con0,2
if (win!=guihwnd)
	return
LButtonDownTick:=A_TickCount
return 

~LButton up::
MouseGetPos,,,win,con,2
if (win!=guihwnd)
	return

if (A_TickCount - LButtonDownTick)>400 && con0=con
	return

;~ ~RButton::


for k,v in SCIarr 
	if (v=con){
		if(clickTrack[k]:=!clickTrack[k])
			newBG:=0xcccccc
		else
			newBG:=0x000000
		
		sci%k%.StyleSetBack(SCLEX_CONTAINER, newBG)
		sci%k%.StyleSetBack(STYLE_DEFAULT, newBG)
		sci%k%.StyleSetBack(SCE_AHKL_USERDEFINED1, newBG)
		
		break
	}
return

#IfWinExist

#IfWinActive,Check R Report ahk_class AutoHotkeyGUI
tab::
ControlGetFocus,hEdit,ahk_id %guihwnd%
found:=0
if RegExMatch(hEdit, "i)Scintilla(\d+)", match){
	if (++match1) > SCIind 
		ControlFocus,,% "ahk_id " editHwnd
	else
		ControlFocus,,% "ahk_id " sci%match1%.hwnd
}else{
	send {tab}
}
return
#IfWinActive

sciSetting(sci){
	global
	sci.SetWrapMode(true), sci.SetLexer(SCLEX_CONTAINER), sci.StyleClearAll()
	,sci.SetCodePage(65001)
	,sci.AUTOCSETCASEINSENSITIVEBEHAVIOUR(1)
	,sci.AUTOCSETSEPARATOR(0xA)
	;~ SciAutoCompleteList=


	; Change a style
	,sci.SETSELALPHA(100)
	;~ ,sci.SETCARETWIDTH(2)
	;~ sci.StyleSetBack(32, 0x000000)
	sci.StyleSetFore(SCLEX_CONTAINER, 0xDDDDDD), sci.StyleSetBack(SCLEX_CONTAINER, 0x000000), sci.StyleSetBold(SCLEX_CONTAINER, false), sci.StyleSetFont(SCLEX_CONTAINER, "Georgia"), sci.StyleSetSize(SCLEX_CONTAINER, 12)
	,sci.StyleSetFore(STYLE_DEFAULT, 0xDDDDDD), sci.StyleSetBack(STYLE_DEFAULT, 0x000000), sci.StyleSetBold(STYLE_DEFAULT, false), sci.StyleSetFont(STYLE_DEFAULT, "Georgia"), sci.StyleSetSize(STYLE_DEFAULT, 12)
	,sci.StyleSetFore(SCE_AHKL_USERDEFINED1, 0xFFFFFF), sci.StyleSetBack(SCE_AHKL_USERDEFINED1, 0x000000), sci.StyleSetBold(SCE_AHKL_USERDEFINED1, true), sci.StyleSetFont(SCE_AHKL_USERDEFINED1, "Georgia"), sci.StyleSetSize(SCE_AHKL_USERDEFINED1, 11)
	,sci.SetCaretFore(0xFFFFFF)
	,sci.SetText(unused, ""),  sci.GrabFocus(), sci.SetMarginWidthN(1,0)
	
	return
}

2GUIClose:
ExitApp
return

IMPAX:
gosub openCurrentImage
sendstr:=""
for k,v in reportList
	if (k>1 && v[AccNoCol]=thisAccNo) {
		thisStudyInd:=k
		sendStr.="SYNC_DISPLAY || " v[AccNoCol] " || "
		sendStr.="ADD_TO_DISPLAY_LIST_WITH_PRIORS || " reportList[k+1,AccNoCol] " || "
		cmdContextServer(sendStr,impaxContextServerHwnd)
		break
	}
return

openCurrentImage:
;~ controlclick,,% "ahk_id " getNetControl2(RisState[2],"IMPAX","cmdDs3000","IMPAX","WindowsForms10.BUTTON.app","","","",0)[1]
;~ getNetAcc(RisState[2], "cmdDs3000", "WindowsForms10.BUTTON").accDoDefaultAction()
risOpenStudyImpax(RisState[2])
return

loadReportList:
parseDataGrid(RisListHwnd?RisListHwnd:RisListHwnd:=getRisList(RisState[2]),reportList, 0, 1)
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
}
SendStr:=""
parseDataGrid(RisListHwnd,reportList, 0, 4, 0, [AccNoCol, thisAccNo])
impaxContextServerHwnd:=winexist("ahk_exe ImpaxContextServer.exe")
for k,v in reportList
	if (k>1 && v[AccNoCol]=thisAccNo) {
		thisStudyInd:=k
		sendStr.="SYNC_DISPLAY || " v[AccNoCol] " || "
		;~ sendStr.="ADD_TO_DISPLAY_LIST_WITH_PRIORS || " reportList[k+1,AccNoCol] "\" reportList[k+2,AccNoCol] "\" reportList[k+3,AccNoCol] " || "
		sendStr.="ADD_TO_DISPLAY_LIST_WITH_PRIORS || " reportList[k+1,AccNoCol] " || "
		;~ sendStr.="ADD_TO_DISPLAY_LIST_WITH_PRIORS || " reportList[k+1,AccNoCol] " || "
		;~ sendStr.="ADD_TO_DISPLAY_LIST_WITH_PRIORS || " reportList[k+2,AccNoCol] " || "
		;~ sendStr.="ADD_TO_DISPLAY_LIST_WITH_PRIORS || " reportList[k+3,AccNoCol] " || "
		cmdContextServer(sendStr,impaxContextServerHwnd)
		break
	}
;~ parseDataGrid(RisListHwnd?RisListHwnd:RisListHwnd:=getRisList(RisState[2]),reportList)
RisSearchResultCount:=(RisSearchResultCount(RisOpened()[2])+1)
RisListRowsAcc:=acc_children(Acc_objectfromwindow(RisListHwnd))

if FileExist(reportDir "\reportList.json") {
	fileread,jxon,% reportDir "\reportList.json"
	reportList:=jxon_load(jxon)
}else{
	parseDataGrid(RisListRowsAcc,reportList,1,0,"","","reportListProgress")
	tooltip
}
reportListLoaded:=1
return

reportListProgress(k){
	global RisSearchResultCount
	tooltip % "Get list from RIS: " k-1 " / " RisSearchResultCount-1 " ..."
}

stringUpper(str){
	StringUpper,str,str	
	return str
}

#IfWinActive,ahk_exe checkRReport.exe
sendWithTitle:
withTitle:=1
F3::
send:
gui,hide
str:=""
loop % SCIind {
	
	;~ tmp:=controlgettext(ButtonHwnd%a_index%)
	sci%A_Index%.gettext(sci%A_Index%.GetTextLength()+1,tmp:="")
	
	if clickTrack[A_Index]
		continue
	
	tmp:=RegExReplace(tmp, "(^ +)","")
	delimit:=delArr[A_Index]
	if !RegExMatch(delimit, "[\r\n]")
		delimit.=" "
	
	if regexmatch(str,"(\. *$)|([\r\n]$)") || str=""
		str.= stringUpper(substr(tmp,1,1)) substr(tmp,2) delimit 
	else
		str.= tmp delimit
	
}
delimit:=""
app:=controlgettext(editHwnd)
str.=" " StringUpper(SubStr(app,1,1)) SubStr(app,2)
str:=RegExReplace(trim(str)," +"," ")
;~ str:=RegExReplace(str, ", ;", ";")
str:=RegExReplace(str,"; \.",".")
str:=RegExReplace(str,"(\r?\n) +","$1")
str:=RegExReplace(str,", \.",".")
controlsettext,,% withTitle?AddTitle(str):str,% "ahk_id " RisReports[1,1]
;~ controlclick,
sheetNo:=thisAccNo
SetTimer,sendReport,-1
if WinExist("ahk_exe PacsIE.exe")
	SetTimer,PacsIEnextStudy,-10
else
	SetTimer,impaxNextStudy,-10
withTitle:=0
return
#IfWinActive


PacsIEnextStudy:
wingettitle,title,PacsIE Log GUI ahk_exe PacsIE.exe
regexmatch(title,"PacsIE Log GUI (\w+):",pacsIeHwnd)
sendmessage,0x10504,,,,ahk_id %pacsIeHwnd1%
return

addTitle(newText,exam="",accNo="",chartNo=""){
	global risstate,fastMode
	if instr(newText,"EXAMINATION:")
		return newText
	if instr(newText,"shows")
		newText:=RegExReplace(newText,"is)^.+shows\s*","")
		,newText:=stringupper(substr(newText,1,1)) substr(newText,2)
	;~ if(!fastMode){
		RegExMatch(clinicalHx:=getClinicalInfo(RisState[2]),"【SPECIAL MEDICAL】\r?\n小部位:([^\r\n\[]+)",match)
		if !regexmatch(match1:=trim(match1),"\w")
			match1:=""
		if(exam=""){
			for k,v in parseRisExamItems(getRisExamItems(RisState[2]))[2]
				exam.=trim(v) "; "
			exam:=substr(exam,1,-2)
		}
			
	;~ }
	if RegExMatch(exam,"is)Chest : (PA|AP) View") && !regexmatch(newText,"i)normal heart size|cardiomegaly|borderline heart size|heart border")
		heartSize:="Normal heart size. "
	exam:=RegExReplace(exam," ?: ?"," - ")
	return  (chartNo=""?"":"Chart No: " chartNo "`r`n") (accNo=""?"":"Accession No: " accNo "`r`n") "EXAMINATION: " exam (match1=""?"":" (" match1 ")") ".`r`nFINDINGS:`r`n" heartSize RegExReplace(newText,"(^(\r?\n)+)|((\r?\n)+$)","")
}


impaxNextStudy:
impaxCyclicListDo()
sendStr:=""
for k,v in reportList
	if (k>1 && v[AccNoCol]=sheetNo) {
		thisReport:=v
		sendStr.="SYNC_DISPLAY || " reportList[k+1,AccNoCol] " || "
		sendStr.="ADD_TO_DISPLAY_LIST_WITH_PRIORS || " reportList[k+2,AccNoCol] " || "
		cmdContextServer(sendstr,impaxContextServerHwnd)
		;~ msgbox % sendStr
		break
	}
return


sendReport:
if (!sendButtonAcc)
	sendButtonAcc:=getNetAcc(RisState[2],"cmdRunVerifySend","WindowsForms10.BUTTON.app")
;~ controlclick,,% "ahk_id " sendButton
sendButtonAcc.accDoDefaultAction()
SetTimer,routine,200
return

clickEvent:
ButtonInd:=substr(a_guicontrol,7)
control,style,^0x8000,,% "ahk_id " buttonhwnd%buttonInd%
clickTrack[ButtonInd]:=!clickTrack[ButtonInd]
winset,redraw,,ahk_id %guihwnd%
return


guiclose:
onexit:
CTLCOLORS.Free()
ExitApp
return




cmdContextServer(str,hwnd=""){
	DetectHiddenWindows,on
	if !hwnd && !hwnd:=winexist("ahk_exe ImpaxContextServer.exe")
		return 1
	loop,parse,str
	{
		PostMessage,0x10303,,% asc(a_loopfield),,ahk_id %hwnd%
		sleep 20
	}
	PostMessage,0x10303,,0x0,,ahk_id %hwnd%
	
}