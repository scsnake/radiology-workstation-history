/*
scsnake@gmail.com
Last update: 2013/01/14
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
#include <Acc>
ComObjError(false)

hotkey:=[]

gosub getWord
gosub mainGUI

return

getWord:
/* winget,wordHwnd,list,Microsoft Word ahk_class OpusApp
 * word:=[]
 * loop % wordHwnd {
 * 	word[a_index,"hwnd"]:=wordHwnd%a_index%
 * 	WinGetTitle,this_title,% "ahk_id " wordHwnd%a_index%
 * 	word[a_index,"title"]:=RegExReplace(this_title,"\s-\sMicrosoft\sWord")
 * }
 */
 
 word:=[]
 if !oWord:=getWordCOM()
	return
loop % oWord.Documents.count
	word.push(oWord.Documents[a_index].Name)
word:=invertArr(word)
return

saveAll:
 if !oWord:=getWordCOM()
	return

loop % oWord.Documents.count
	oWord.Documents[a_index].Save()
return

mainGUI:
gui,+lastfound
winget,guiHwnd,id
gui,font,s10,Verdana
loop, 10
	guiRow(a_index)
gui,add,button,% "xs yp+50 gGo",Activate Hotkey
gui,add,button,% "yp xp+150 gexit",Exit
gui,add,button,% "xs yp+50 grefresh",Refresh
gui,add,button,% "yp xp+100 gsaveAll",Save all Word
gui,show,w300 h450
return

refresh:
gosub getWord
loop 10 {
	guicontrol,,% "ddl" a_index,% "|"
	guicontrol,,% "ddl" a_index,% listStr(word,a_index)
}

return

Go:
gui,submit,nohide
WinMinimize,ahk_id %guiHwnd%
loop 10 {
	if !(cb%a_index%)
		continue
	if (ddl%a_index%=1){
		guicontrol,,cb%a_index%,0
		continue
	}
	
	guicontrolget,t%a_index%,,t%a_index%
	hotkey[this_hotkey:=RegExReplace(t%a_index%,"Ctrl\+","^")]:=word[ddl%a_index%-1]
	hotkey,% this_hotkey,hotkeys
}
traytip,,Hotkey Activated !
settimer,tt,-1000
return

hotkeys:
IfWinNotExist,% (wordTitle:=hotkey[A_ThisHotkey]) " ahk_class OpusApp"
	return

keywait,% RegExReplace(a_thishotkey,"\D")
keywait,ctrl
sleep 50
send ^c
sleep 100
;~ ControlSend,_WwG1,^{HOME}
;~ sleep 100
;~ ControlSend,_WwG1,^v
;~ sleep 100
;~ ControlSend,_WwG1,{enter 2}
if !oWord:=getWordCOM()
	return
oDoc:=oWord.Documents(wordTitle)
oDoc.Words[1].InsertBefore(Chr(13))
oDoc.Words[1].InsertBreak()
oDoc.Words[1].InsertBefore(Chr(13) Chr(13))
oDoc.Words[1].Paste()
traytip,,Mail Copied !
settimer,tt,-500
return

guiRow(i){
	global
	
	if i<5
		gui,add,checkbox,% "vcb" i " checked xs yp+30",% " "
	else
		gui,add,checkbox,% "vcb" i " xs yp+30",% " "
	gui,add,text,% "yp xp+40 vt" i,% "Ctrl+" mod(i,10)
	gui,add,dropdownlist,% "yp xp+80 altsubmit vddl" i,% listStr(word,i)
}

listStr(arr,selected=1){
	str:=""
	
	for k,v in arr {
		str.=v "|"
		if(k=selected)
			str.="|"
	}
	str:=" " (instr(str,"||")?"|":"||") str
	return (k!=selected&&k>1)?RegExReplace(str,"\|$"):str
}

getWordCOM(){
	ControlGet, id, HWND,,_WwG1,ahk_class OpusApp
	return Acc_ObjectFromWindow(id, -16).Application
}

invertArr(arr){
	n:=arr
	x:=[]
	while k:=n.pop()
		x.push(k)
	return x
}

/* 
 * ~^c::
 * if !(a_timesincepriorhotkey<500 && a_priorhotkey=a_thishotkey)
 * 	return
 * IfWinNotExist,LotusMailBackup ahk_class OpusApp
 * 	return
 * ControlSend,_WwG1,^{HOME}
 * sleep 100
 * ControlSend,_WwG1,^v
 * sleep 100
 * ControlSend,_WwG1,{enter 2}
 * traytip,,Copied!
 * settimer,tt,-500
 * return
 */

tt:
traytip
return

exit:
guiclose:
!q::
;~ esc::
ExitApp
return