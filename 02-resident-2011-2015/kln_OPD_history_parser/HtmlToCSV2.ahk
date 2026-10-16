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
DetectHiddenWindows,on
ComObjError(false)
#include <portalLib>


Loop 1  ; For each parameter:
{
    sourceFile := %A_Index%  ; Fetch the contents of the variable whose name is contained in A_Index.
}
;~ sourceFile:="3______.html"


if regexmatch(sourceFile,"i)((\w)\w{5}\d)[^\/\\]*.html$",match) {
	whatFile:=match1
}else if RegExMatch(sourceFile,"i)total[^\/\\]*.html$") {
	whatFile:="total"
}else if fileexist("total.html") {
	whatFile:="total",sourceFile:="total.html"
}else{
	msgbox Please drag and drop the OPD file me !!
	exitapp
}

if fileexist(whatFile " - Converted.csv") {
	msgbox,4,,% "The file """ whatFile " - Converted.csv"" already exists. Backup it ?"
	ifmsgbox,Yes
		filemove,% whatFile " - Converted.csv",% whatFile " - Converted (backup " a_now ").csv",1
}

traytip,,% "Loading ... "
fileread,html,% sourceFile
dom:=ComObjCreate("HtmlFile")
dom.write(html)
filedelete,%whatFile% - Converted.csv
csv:="""病歷號"",""性別"",""生日年"",""生日月"",""生日日"",""姓名"",""門診日期"",""診斷"",""處方"",""醫令"",""年齡"",""帳號"",""院區"",""部門"",""主治醫師"",""Subjective"",""Objective"",""未來影像檢查排程"",""未來其他檢查排程"",""未來門診預約""`n"

tick:=0

if (whatFile="total")
	gosub convertTotal
else
	gosub convertChartNo

tick:=101
gosub save
traytip



msgbox % "Finished !!!"
exitapp
return


convertTotal:
loop % (tables:=dom.body.childNodes).length/2 {
	chartNo:=tables[a_index*2-2].innerText
	
	ptHtml:="<table>" tables[a_index*2-1].innerHTML "</table>"
	gosub convertPtHtml
}
	
return

convertChartNo:
chartNo:=whatFile
ptHtml:=dom.body.innerHTML
gosub convertPtHtml
return

convertPtHtml:
ptDom:=ComObjCreate("HtmlFile")
ptDom.write(ptHtml)
if (trim((ptDom.getElementsByTagName("TD"))[0].innerText)="")
	return
links:=[]
loop % (link:=((tr:=ptDom.body.firstChild.firstChild.childNodes)[0].firstChild.getElementsByTagName("A"))).length 
	links.push(link[a_index-1].innerText)

loop % tr.length  {
	ptOpdHtml:=(div:=tr[a_index-1].lastChild.getElementsByTagName("DIV")[1]).innerHTML
	if((len:=div.firstChild.firstChild.childNodes.length)=3){
		csv.=OpdHxToCSV(ptOpdHtml,chartNo)
	}else if(len=2){
		csv.=OldOpdHxToCSV(ptOpdHtml,chartNo)
	}else{
		fileappend,% a_now "," chartNo ",Parse error of OPD data (" link[a_index-1].innerText ")`n",HtmlToCSV.log,utf-8
	}
	traytip,,% "Patient " chartNo " - " a_index
	gosub save
}
return


save:
if ((tick++)>100) {
	tick:=0
	fileappend,% csv,%whatFile% - Converted.csv,utf-8
	csv:=""
}
return



~esc::
msgbox,4,,Exit?
IfMsgBox,yes
	exitapp
return
