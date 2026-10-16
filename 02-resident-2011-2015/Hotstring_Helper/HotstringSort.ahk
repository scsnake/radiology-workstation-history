/*
20131121
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

FileSelectFile,ahkFile,M,% a_scriptdir,Select AHK file,(*.ahk)
if errorlevel
	ExitApp
loop,parse,ahkFile,`n
	if a_index=1
		path:=a_loopfield "\"
	else
		parseAhk2(path a_loopfield)
		
;~ arr:=parseAhk2("G:\scripts\Radiology\YCH.ahk")
		

;~ dic:=parseAhkFolder(a_scriptdir)
;~ dic:=[]
;~ dic["cwy37.ahk",1]:="cwy37.ahk"
;~ dic["cwy37.ahk",2]:=parseAhk("cwy37.ahk")
msgbox Finished!
ExitApp


return

parseAhk2(path){
	arr:=[],hotstring:="",str:="",others:=""
	loop,read,% path 
	{
		if RegExMatch(a_loopreadline,"is)^:[^:]*?:(.+):[^:]?:([^\n]*)",match) {
			if !(trim(match2)="")
				arr["" match1]:=match "`n"
			else
				hotstring:=match1,str:=match "`n"
		}else if (hotstring!="") {
			if (trim(a_loopreadline)=")") {
				arr["" hotstring]:=str ")`n"
				,hotstring:="",str:=""
			}else if (trim(a_loopreadline)="return"){
				arr["" hotstring]:=str "return`n"
				,hotstring:=str:=""
			}else if (trim(a_loopreadline)="("){
				str.="(`n"
			}else{
				str.=a_loopreadline "`n"
			}
			
		}else{
			others.=a_loopreadline "`n"
		}	
	}
	
	firstChar:=""
	others.="`n; ---------------------HOTSTRING---------------------`n"
	for k,v in arr
		if (substr(k,1,1)!=firstChar)
			others.="`n" v,firstChar:=substr(k,1,1)
		else
			others.=v
		
	regexmatch(path,"is)(.+)([^\/\\]).ahk+$",match)
	
	if fileexist(saved:=match1 match2 " - sorted.ahk")
		filedelete,% saved
	fileappend,% others,% saved,utf-8
}
