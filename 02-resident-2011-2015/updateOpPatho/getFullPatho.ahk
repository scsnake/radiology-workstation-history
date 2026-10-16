/*
scsnake@gmail.com
*/

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
;~ onexit,onexit
ComObjError(false)

#include <portalLib>
#include <jxon>



param:=""
Loop, %0%  
{
    param:=%A_Index%  ; Fetch the contents of the variable whose name is contained in A_Index.
	if FileExist(param)
		break
}

if(!param){
	if !FileExist(param:=A_ScriptDir "\updateOpPatho.html"){
		MsgBox % "Please specify result HTML file!"
		ExitApp
	}
}

fileread,inputHtml,% param
RegExMatch(inputHtml, "i)(?<=SESSION=)\w+", oldSid)
,sid:=askForPortalIdPw()
,inputHtml:=RegExReplace(inputHtml, "i)" oldSid , sid)
,dom:=ComObjCreate("HtmlFile")
,dom.write(inputHtml)
,table:=dom.getElementById("result").getElementsByTagName("table")[0]
,dir:=A_ScriptDir "\json\"
FileCreateDir,% dir
Loop % (rows:=table.rows).length-1 {
	j:=[]
	,row:=rows[A_Index]
	,j["ChartNo"]:=chartNo:=row.cells[0].innerText
	,Links:=row.cells[1].getElementsByTagName("a")
	,j["Op"]:=[]
	,j["Patho"]:=[]
	
	if FileExist(dir chartNo ".json")
		continue
	Loop % Links.length {
		item:=[], Link:=Links[A_Index-1]
		,item["url"]:=Link.href
		,item["date"]:=Link.date
		,item["text"]:=Link.innerText
		,httprequest(link.href, post:="", header:="", "charset: utf-8")
		;~ ,dom2:=ComObjCreate("HtmlFile")
		;~ ,dom2.write(post)
		;~ ,item["report"]:=dom2.getElementById("rReportTab_lsvReportBody_ctrl0_ctl00_TextBox2").innerText
		,item["report"]:=post
		if InStr(item["text"], "Patho")
			j["Patho"].push(item)
		else
			j["Op"].push(item)
	}
	FileDelete,% dir chartNo ".json"
	FileAppend,% jxon_dump(j),% dir chartNo ".json",utf-8
	ToolTip % "Saved JSON for " chartNo
}
ExitApp
;