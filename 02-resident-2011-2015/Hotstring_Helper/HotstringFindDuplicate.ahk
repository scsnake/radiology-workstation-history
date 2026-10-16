/*
scsnake@gmail.com
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
SetControlDelay,-1
SetFormat, float, 2.1
comobjerror(false)

gosub gui
gosub find

return

find:
all:=[],singleFile:=0,allStr:=[]
loop 1
{
	param:= %a_index%
	if fileexist(param) {
		dic:=[],dic["" param]:=array(RegExReplace(param,"^[^\n]+(\\|\/)",""),parseAhk(param))
		,singleFile:=1
		;~ msgbox % all["ao"].maxIndex()
	} else
		dic:=parseAhkFolder(a_scriptdir)
}



;~ for k,v in dic {
	;~ for x,y in v.2 {
		;~ if !isobject(all[x]) 
			;~ all[x]:=[]
		;~ arr:=[y,v.1,k]
		;~ ,all[x].push(arr)
	;~ }
;~ }

txt:=""

for k,v in all
	if v.maxIndex()>1 {
		for x,y in v {
			if !singleFile
				txt.=";---" y.2 "`n" 
			txt.="::" k "::" y.1 "`n"
		}
		txt.="`n"
		guicontrol,,txt,% txt
	}
for k,v in allStr
	if v.maxIndex()>1 {
		for x,y in v {
			if !singleFile
				txt.=";---" y.2 "`n" 
			txt.="::" y.1 "::" k "`n"
		}
		txt.="`n"
		guicontrol,,txt,% txt
	}

return	

gui:
gui, +hwndguiHwnd
gui,font,s10,Verdana
gui,add,edit,% "w" a_screenwidth/2 " h" a_screenheight/2 " vtxt",% txt
gui,show,autosize,Find Duplicate Hotstring


return

guiclose:
exitapp
return

#ifwinactive,Find Duplicate Hotstring ahk_class AutoHotkeyGUI
esc::
ExitApp
return

f5::
guicontrol,,txt,% ""
gosub find
;~ guicontrol,,txt,% txt
return
#IfWinActive


parseAhk(path){
	global all,allStr
	arr:=[],hotstring:="",str:=""
	loop,read,% path
	{
		if RegExMatch(a_loopreadline,"is)^:[^:]*?:(.+):[^:]?:([^\n]*)",match) {
			if match2 {
				arr["" match1]:=match2
				if !isobject(all["" match1])
					all["" match1]:=[]
				if !isobject(allStr["" trim(match2)])
					allStr["" trim(match2)]:=[]
				all["" match1].push(array("" match2,RegExReplace(path,"^[^\n]+(\\|\/)",""),path))
				allStr["" trim(match2)].push(array("" match1,RegExReplace(path,"^[^\n]+(\\|\/)",""),path))
			} else 
				hotstring:=match1
			
			continue
		}
		
		if (hotstring!="") {
			if(a_loopreadline=")" || trim(a_loopreadline)="return") {
				if !isobject(all["" hotstring])
					all["" hotstring]:=[]
				if !isobject(allStr["" trim(str)])
					allStr["" trim(str)]:=[]
				all["" hotstring].push(array("" str,RegExReplace(path,"^[^\n]+(\\|\/)",""),path))
				allStr["" trim(str)].push(array("" hotstring,RegExReplace(path,"^[^\n]+(\\|\/)",""),path))
				
				
				arr["" hotstring]:=str
				,hotstring:="",str:=""
			}else if (a_loopreadline!="(") {
				str.=a_loopreadline "`n"
			}
			
		}
	}
	return arr
	
}

parseAhkFolder(folder,recurse=0){
	arr:=[]
	loop,%folder%\*.ahk,0,% recurse
	{
		arr[A_LoopFileLongPath]:=array(A_LoopFileName,parseAhk(A_LoopFileLongPath))
	}
	return arr
}
