/*
HOTKEY:
ctrl+alt+z

USAGE:
parse a column of addresses to several fields

INSTRUCTION:
open excel file,
select a column (of addresses),
press hotkey to parse these addresses
*/


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

;~ #include ../COM.ahk



return


!^z::
WinGetClass,activeWinClass,A
if ! (activeWinClass="XLMAIN") 
	return
winget,activeWinHwnd,id,A
;~ xls:=Acc_ObjectFromWindow(activeWinHwnd, -16)
xls := ComObjActive("Excel.Application")
refCount=1
wb:=xls.activeworkbook.name
sh:=xls.activesheet.name
sel:=xls.selection.cells.address
col:=xls.sheets(sh).range(selection).cells(1).column
loop % xls.sheets(sh).range(sel).cells.count
{
	currentCell:=xls.sheets(sh).range(sel).cells(a_index)
	
	if !currentCell.value || currentCell.column!=col
		continue
	
	
	
	
	
	
	if match1 && !regexmatch(match1,regexescape(wb) "$")
		continue
	
	;~ xls.sheets(sh).range(sel).cells(a_index).activate
	;~ msgbox % formula
	if xls.sheets(sh).cells(1,xls.sheets(sh).range(sel).cells(a_index).offset(0,1).column).value!="reference"
	{
		xls.sheets(sh).columns(xls.sheets(sh).range(sel).cells(a_index).offset(0,1).column).insert
		xls.sheets(sh).cells(1,xls.sheets(sh).range(sel).cells(a_index).offset(0,1).column).value:="reference"
	}
	xls.sheets(sh).range(sel).cells(a_index).offset(0,1).formula:="=hyperlink(""#" xls.sheets(sh).name "!" match3 """,""ref" refCount """)"
	if xls.sheets(sh).cells(1,xls.sheets(sh).range(match3).cells(a_index).offset(0,1).column).value!="reference"
	{
		xls.sheets(sh).columns(xls.sheets(sh).range(match3).cells(a_index).offset(0,1).column).insert
		xls.sheets(sh).cells(1,xls.sheets(sh).range(match3).cells(a_index).offset(0,1).column).value:="reference"
	}
	xls.sheets(sh).range(match3).offset(0,1).formula:="=hyperlink(""#" xls.sheets(sh).name "!"  xls.sheets(sh).range(sel).cells(a_index).address """,""ref" refCount """)"
	refCount++
}
return


regexescape(str)
{
	stringreplace,str,str,+,\+,a
	stringreplace,str,str,[,\[,a
	stringreplace,str,str,{,\{,a
	stringreplace,str,str,(,\(,a
	stringreplace,str,str,),\),a
	stringreplace,str,str,^,\^,a
	stringreplace,str,str,$,\$,a
	stringreplace,str,str,.,\.,a
	return str
	
}


esc::exitapp