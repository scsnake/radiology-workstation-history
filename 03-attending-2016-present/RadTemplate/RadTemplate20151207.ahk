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
;~ #notrayicon
onexit,onexit
#include <RisImpax>
#include <Scrollable GUI>



checkedCheckbox:="■"
uncheckedCheckbox:="□"
checkedRadio:="●"
uncheckedRadio:="○"

gui,1: font,s10,Verdana
Gui,1: -Resize -0x300000 

;~ 0:=1
;~ 1:="HCC.txt"

Loop %0%
	if fileexist(param:=%a_index%)
		goto parseInput
	

templateList:=""
loop,% a_scriptdir "/*.txt"
	if (a_loopfilename!="ReadMe.txt")
		templateList.=A_LoopFileName "|"

;~ gui,1: font,s10,Verdana
gui,add,dropdownlist,% "gGoTemplate vchoosen " DropDownSize(templateList,"Verdana",10,30),% templateList
gui,show,autosize,Radiology Template 
;~ gosub readTemplate
;~ gosub gui

return

tabToSpaces:
template:=RegExReplace(template,"\t","    ")
return

parseInput:
fileread,template,% param
gosub tabToSpaces
parsed:=1
gosub gui
return

GoTemplate:
pChoosen:=choosen
gui,submit,nohide
fileread,template,% a_scriptdir "\" choosen
gosub tabToSpaces
if pChoosen!=choosen
	gosub gui
return

readTemplate:
fileread,template,% a_scriptdir "\CT guided biopsy.txt"
return

gui:
OnMessage(0x115, "OnScroll") ; WM_VSCROLL
OnMessage(0x114, "OnScroll") ; WM_HSCROLL

gui,2:New
gui,2: +resize +0x200000
gui,2: +hwndtemplateHwnd 
if not %0%
	gui,2:+Owner1
gui,2: font,s8,Verdana
gui,2: +lastfound
GroupAdd, MyGui, % "ahk_id " . WinExist()


i:=0,j:=1,match:=pMatch:="",matchArr:=[],matchArr[1,1]:=1,lineLen:=0,lineLenLim:=120

/*
matchArr[n,1] = text start position
matchArr[n,2] = text end position
matchArr[n,3] = control var name
matchArr[n,4] = control type
*/

,checkBoxCount:=0,radioBoxCount:=0,formArr:=[]
while i:=regexmatch(template,"is)\[(.*?)\]|\{(.*?)\}",match,j) {
	RegExMatch(match1?match1:match2,"is)^(?:(c|r)\))?(.*)$",lst)
	matchArr[a_index,2]:=i-1,list:=match1?lst2:match2,listBox:=match2&&instr(match2,"|")?1:0
	,box:=lst1?1:0
	whileInd:=a_index
;~ if instr(match,"angio-seal")
	;~ tooltip

;~ RegExMatch(substr(template,j,i-j),"is)^(\r?\n?)(.+?)(\r?\n?)$",mtc)
	;~ RegExMatch(substr(template,j,i-j),"is)^(?: *)([\r\n]*)(.+?)([\r\n]*)$",txt)
	txt:=substr(template,j,i-j)
	
	loop,parse,txt,`n
	{
		t:=RegExReplace(A_LoopField,"\r")
		parseInd:=a_index,startPoint:=1
		loop {
			if(parseInd=1 && a_index=1)
				t1:=substr(t,startPoint,linelenlim-linelen),len:=strlen(t1),startPoint:=linelenlim-linelen+1
			else
				t1:=substr(t,startPoint,linelenlim),len:=strlen(t1),startPoint+=linelenlim+1
			
			if (len){
				if(parseInd=1 && a_index=1){
					try
						gui,add,text,% "x+5",% t1
					linelen+=len
				}else{
					try
						gui,add,text,% "xm",% t1
					lineLen:=len
				}
			}else
				break
		
		}

	}
	vars:=[]
	if RegExMatch(list,"is)\/\/(.*)$",m)
		m3:=m1,m1:=substr(list,1,(-1)*strlen(m))
	else
		m3:="",m1:=list
	
	m3:=RegExReplace(m3,"\bv\w+\b"," ")
	if (box){
		boxArr:=[],boxWidth:=[],matchArr[a_index,4]:=boxType:=(lst1="c"?"checkbox":"radio")
		
		;~ stringreplace,list,list,||,€,all
		
		;~ loop,parse,list,€ 
		;~ {
			;~ boxRow:=a_index
			;~ loop,parse,a_loopfield,|
			;~ {
				;~ boxCol:=a_index
				;~ RegExMatch(a_loopfield,"is)^(.+?)(\/\/(.*))?$",ma)
				;~ boxArr[boxRow,boxCol,2]:=RegExReplace(ma3,"\bv\w+\b"," ")
				;~ if (w:=BoxSize(boxArr[boxRow,boxCol,1]:=ma1,boxType,"Verdana"))>boxWidth[boxCol]
					;~ boxWidth[boxCol]:=w
				
			;~ }
		;~ }
		stringreplace,list,list,||,€|,all
		;~ loop,parse,list,€ 
		;~ {
			boxRow:=1
			loop,parse,list,|
			{
				if a_loopfield=
					continue
				boxCol:=a_index
				RegExMatch(a_loopfield,"is)^(.+?)(\/\/(.*))?$",ma)
				if substr(ma1,0,1)="€"
					ma1:=substr(ma1,1,-1),ma3:=instr(ma3,"i) checked|checked ")?ma3:(ma3 " checked"),ma3:=RegExReplace(ma3,"unchecked")
				boxArr[boxRow,boxCol,2]:=RegExReplace(ma3,"\bv\w+\b"," ")
				if (w:=BoxSize(boxArr[boxRow,boxCol,1]:=ma1,boxType,"Verdana"))>boxWidth[boxCol]
					boxWidth[boxCol]:=w
				
			}
		;~ }
		outer_index:=a_index
		;~ regexmatch(,"\bw(\d+)\b",boxW)
		if (boxType="checkbox"){
			
			for k,v in boxArr 
				for x,y in v {
					if (lineLen+(len:=strlen(y.1)+5)>linelenlim) || regexmatch(txt,"[\r\n]$") || (whileInd=1 && txt="")
						s:="xm",lineLen:=len
					else
						s:="x+5", lineLen+=len
					try
						gui,add,checkbox,% "vcb" ++checkBoxCount " " s " " y.2,% y.1
					matchArr[outer_index,3].="cb" checkBoxCount ","
				}
					;~ vars.push(
		}else{
			for k,v in boxArr 
				for x,y in v {
					if (lineLen+(len:=strlen(y.1)+5)>linelenlim) || regexmatch(txt,"[\r\n]$") || (whileInd=1 && txt="")
						s:="xm",lineLen:=len
					else
						s:="x+5", lineLen+=len
					try
						gui,add,radio,% ("vrb" ++radioBoxCount " group ") " " s " " y.2,% y.1
					matchArr[outer_index,3].="rb" radioBoxCount ","
				}

		}
	}else if instr(m1,"|") {
		max:=0
		loop,parse,m1,|
			if strlen(a_loopfield)>max
				max:=strlen(a_loopfield)
				,maxStr:=a_loopfield
		(s:=regexmatch(txt,"[\r\n]$")?"xm":"x+5") ,t:=m1
				
		,m3.=" " maxWidth(lineLen,maxStr)
		,matchArr[a_index,4]:=boxType:=listBox?"listbox":"combobox"
		,matchArr[a_index,3]:="var" a_index
		
		if (lineLen+max>linelenlim){
			try
				gui,add,% boxType,% "vvar" a_index " " "xm" " " m3 " 0x8",% t
			lineLen:=max

		}else{
			try
				gui,add,% boxType,% "vvar" a_index " " s " " m3 " 0x8",% t
			lineLen+=max
		}
		
	}else{
		(s:=regexmatch(txt,"[\r\n]$")?"xm":"x+5") ,t:=RegExReplace(m1,"^[\r\n]+")
		,m3.=regexmatch(m3,"i)w\d+")?" ":" " (t=""?"w100":maxWidth(lineLen,t))
		,matchArr[a_index,4]:="edit"
		,matchArr[a_index,3]:="var" a_index
		;~ y:=matchArr[a_index-1,4]="edit"&&txt=""?"yp":"yp+3"
		;~ y2:=y="yp"?"yp":"yp+3"
		
		if (lineLen+strlen(t)>linelenlim){
			try {
				gui,add,edit,% "vvar" a_index " " "xm yp-3 " " " m3,% t
				gui,add,text,% "x+0 w0 yp+3",% " "
			}
			lineLen:=strlen(t)
		}else{
			try {
				gui,add,edit,% "vvar" a_index " " s " yp-3 " m3,% t
				gui,add,text,% "x+0 w0 yp+3",% " "
			}
			lineLen+=strlen(t)
		}
		;~ gui,add,edit,% "vvar" a_index " " (regexmatch(txt3,"[\r\n]")?"xm":"x+5") " " m3,% RegExReplace(m1,"^[\s\r\n]+")
	}
	matchArr[a_index+1,1]:=j:=i+strlen(match)
}
matchArr[matchArr.maxIndex(),2]:=strlen(template)
lastTxt:=substr(template,j)
gui,add,text,% lineLen+strlen(lastTxt)>linelenlim?"":"x+5",% substr(template,j)

gui,add,button,gsubmit xs,To Clipboard
gui,add,button,gsubmitRis x+20,To RIS

gui,show,autosize,% RegExReplace(choosen,"\.\w+$","")

return

submit:
gui,submit,nohide
if ((len:=matchArr.maxIndex())<1){
	clipboard:=template
	return
}
var%len%:=""
export:=""


for k,v in matchArr {
		;~ test:=var%k%
		;~ if instr(test,"supine")
			;~ tooltip

	if (v.4="checkbox"){
		tempStr:="",tempVar:=v.3
		loop,parse,tempVar,`,
			if (a_loopfield!=""){
				guicontrolget,tempCbVar,,% a_loopfield
				guicontrolget,tempCbText,,% a_loopfield,text
				tempStr.=(tempCbVar?checkedCheckbox:uncheckedCheckbox) tempCbText " " 
			}
		export:=conc(export,substr(template,v.1,v.2-v.1+1),tempStr)
	}else if (v.4="radio"){
		tempStr:="",tempVar:=v.3
		loop,parse,tempVar,`,
			if (a_loopfield!=""){
				guicontrolget,tempRbVar,,% a_loopfield
				guicontrolget,tempRbText,,% a_loopfield,text
				tempStr.=(tempRbVar?checkedRadio:uncheckedRadio) tempRbText " " 
			}
		export.=conc(substr(template,v.1,v.2-v.1+1),tempStr)
	}else if (v.4="listbox"){
		tempStr:="",tempVar:=var%k%
		loop,parse,tempVar,|
			tempStr.=a_loopfield "`n"
		export:=conc(export,substr(template,v.1,v.2-v.1+1),regexreplace(tempStr,"\n$",""))
	}else{
		export:=conc(export,substr(template,v.1,v.2-v.1+1),var%k%)
	}
	
}
clipboard:=export
tooltip,Copied!
settimer,tooltip,-2000
return



maxWidth(lineLen,maxStr){
	global linelenlim
	;~ if maxStr=
		;~ tooltip
	max:=strlen(maxStr)
	if(lineLen+max>linelenlim){
		return maxWidth:=dropdownsize(substr(maxStr,1,maxStrlen:=linelenlim-lineLen),"Verdana",8,30)
	}else{
		return maxWidth:=dropdownsize(maxStr,"Verdana",8,30)
	}
}

conc(param*){
	a:=b:=""
	for k,b in param {
		;~ a:=RegExReplace(a," +$","")
		;~ b:=RegExReplace(b,"^ +","")
		;~ regexmatch(a,"is)(.)$",m)
		;~ RegExMatch(b,"is)^(.)",n)
		m1:=substr(a,0,1)
		n1:=substr(b,1,1)
		
		;~ if instr(a,"YCH")
			;~ bbbb=1

		if regexmatch(m1 n1,"\w[\w\(\[\{]") 
			a.=" " b
		else if m1 in `,,;,.,!,?,),:,
			a.=" " b
		else 
			a.=b
	}
	return a
}


submitRis:
gosub submit
if (RisOpened()[1]!=2){
    tooltip,Copied!
    settimer,tooltip,-1000
	return
}
RegExMatch(export,"is)^(.*?)[\s\r\n]*(?:Impression\W*(.*))?$",match)
ris:=getRisReports(RisOpened()[2])
controlsettext,,% LineBreakConvert(match1),% "ahk_id " ris[1,1]
controlsettext,,% LineBreakConvert(match2),% "ahk_id " ris[1,2]
winactivate,% "ahk_id " RisOpened()[2]
return

tooltip:
ToolTip
return

~esc::
if !(a_priorhotkey=a_thishotkey && a_timesincepriorhotkey<500){
	if %0%
{
	goto guiclose
}
	if winactive("ahk_id " templateHwnd){
		gui,2:destroy
}	return
}
;~ !q::
2guiclose:
if %0%
{
	goto guiclose
}
if (!parsed) {
	gui,2:destroy
	return
}
guiclose:
MsgBox, 4, , Quit?
ifmsgbox,yes
	exitapp
return

onexit:
ExitApp
return

DropDownSize(List, Font:="", FontSize:=10, Padding:=30)
{
	x:=0
	Loop, Parse, List, |
	{
		if Font
			Gui DropDownSize:Font, s%FontSize%, %Font%
		Gui DropDownSize:Add, Text, R1, %A_LoopField%
		GuiControlGet T, DropDownSize:Pos, Static1
		Gui DropDownSize:Destroy
		TW > X ? X := TW :
	}
	return "w" X + Padding
}
BoxSize(text,boxType, Font:="", FontSize:=10, Padding:=0)
{
	
	
		if Font
			Gui BoxSize:Font, s%FontSize%, %Font%
		Gui BoxSize:Add, % boxType,,% text
		GuiControlGet,T, BoxSize:Pos, Button1
		Gui BoxSize:Destroy
		return TW+Padding
}



GuiSize:
    UpdateScrollBars(A_Gui, A_GuiWidth, A_GuiHeight)
return

#IfWinActive ahk_group MyGui
WheelUp::
WheelDown::
+WheelUp::
+WheelDown::
    ; SB_LINEDOWN=1, SB_LINEUP=0, WM_HSCROLL=0x114, WM_VSCROLL=0x115
    OnScroll(InStr(A_ThisHotkey,"Down") ? 1 : 0, 0, GetKeyState("Shift") ? 0x114 : 0x115, WinExist())
return
#IfWinActive
