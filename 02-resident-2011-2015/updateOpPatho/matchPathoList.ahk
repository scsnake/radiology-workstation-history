﻿/*
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
#include <ParseTable>

old_clip:=clipboard
clip:=ParseTable()
output:=""
dir:="D:\Users\raduser\Documents\scsnake\updateOpPatho"
Loop,Parse,old_clip,`n,`r
{
	line:=""
	Loop,parse,A_LoopField,`t
		line.=EscapeQuote2(A_LoopField) ","
	
	if(A_Index=1){
		output .= line ",""PathoReport"",""malignant""`n"
		continue
	}
	
	chartNo:=clip[A_Index][5]
	,date:=SubStr(RegExReplace(clip[A_Index][3], "\D", ""), 1, 8)
	ToolTip % chartNo "," date
	if !FileExist(f:=dir "\json" chartNo ".json"){
		output.=line ",,`n"
	}else{
		fileread,j,% f
		j:=jxon_load(j)
		t:=""
		ma:=false
		dt:=9999
		for k,p in j["Patho"]
			if within(p.date,date)<=3 && p.date>=date{
				dom:=ComObjCreate("HtmlFile")
				,dom.write(p.Report)
				,t.=(re:=dom.getElementById("rReportTab_lsvReportBody_ctrl0_ctl00_TextBox2").innerText) "`n------`n"
				,ma|=isMalignant(re)
			}
		
		if (!t){
			for k,p in j["Patho"]
				if (p.date>=date) {
					dom:=ComObjCreate("HtmlFile")
					,dom.write(p.Report)
					,re:=dom.getElementById("rReportTab_lsvReportBody_ctrl0_ctl00_TextBox2").innerText
					if InStr(re, "calcification") && InStr(re, "breast") && InStr(re, "without")
						t.=re "`n------`n"
						,ma|=isMalignant(re)
				}
		}
		
		
		i:=0
		if (!t){
			for k,p in j["Patho"]
				if p.date>=date && within(p.date,date)<dt
					dt:=within(p.date,date), i:=k
			if i
				{
					dom:=ComObjCreate("HtmlFile")
					,dom.write(j["Patho"][i].Report)
					,t.=(re:=dom.getElementById("rReportTab_lsvReportBody_ctrl0_ctl00_TextBox2").innerText) "`n------`n"
					,ma|=isMalignant(re)
				}
		}
		
		output.=line "," EscapeQuote2(t) "," !!ma "`n"
	}
}
clipboard:=output
ExitApp


EscapeQuote2(ByRef s){
	return """" RegExReplace(s, """", """""") """"
}

within(date1, date2){
	date1-=date2, Days
	return Abs(date1)
}

isMalignant(s){
	ma:=false
	Loop,parse,s,`n,`r
		if(A_Index>2)
			return ma
		else if (A_LoopField~="i)malignan|invasive|carcinoma")
			return true
	return ma
}