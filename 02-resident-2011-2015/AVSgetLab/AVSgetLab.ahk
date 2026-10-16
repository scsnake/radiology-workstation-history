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
DetectHiddenWindows,on
ComObjError(false)
#notrayicon
#include <portalLib>


gui,font,s12,Verdana
gui,add,text,,% "1. 複製表格資料（含檢查日、病歷號）"
gui,add,text,,% "2. "
gui,add,button,default x+0 ggetdata,% "抓Lab Data"
gui,show,autosize
return

getdata:
;~ exitapp
askForPortalIdPw()
clip:=Clipboard
source:=[],data:=[]
loop,parse,clip,`n,`r
{
	if(a_index=1){
		loop,parse,a_loopfield,`t
			if(a_loopfield="檢查日")
				examDateCol:=a_index
			else if(a_loopfield="病歷號")
				chartNoCol:=a_index
		
	}else{
		pt:=[]
		loop,parse,a_loopfield,`t
			if(a_index=examDateCol)
				pt[1]:=A_LoopField
			else if(a_index=chartNoCol)
				pt[2]:=A_LoopField
		source.push(pt)
	}
}

outputStr:=""
for k,v in source {
	RegExMatch(v.1,"(\d{4})\D(\d\d)\D(\d\d)",match)
	tempDate:=match1 match2 match3 "000000"
	tempDate+=7,d
	FormatTime,endTime,% tempDate,yyyy-MM-ddTHH:mm:ss
	lab:=getLab2(v.2,sid,14,0,match1 "-" match2 "-" match3 "T00:00:00",endTime)
	
	pt:=[]
	for x,y in lab {
		if !(y.SpecimenName="BLOOD" && (instr(y.ItemName,"Cortisol") || instr(y.ItemName,"Aldosterone")))
			continue
		text:=y.ViewCondition
		regexmatch(text,"([^\s]+)\s+([^\s]+)\D*(\d)",match)
		value:=y.Value
	}
	
	outputStr.=""
}

return

guiclose:
esc::
ExitApp
return
