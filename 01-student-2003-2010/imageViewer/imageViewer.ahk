#include <gdip>


#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,ignore
SetBatchLines, -1
coordMode,mouse,screen
coordMode,pixel,screen
coordMode,tooltip,screen
SetTitleMatchMode,2
SetControlDelay,-1
DetectHiddenWindows,on
ComObjError(false)
#notrayicon
onexit,onexit

ScriptTitle = AHK Picture Viewer
pattern = jpeg,jpg,bmp,png,gif
Loop 9
	OnMessage( 255+A_Index, "PreventKeyPressBeep" ) ; 0x100 to 0x108 


return


esc::
onexit:
exitapp



;by SKAN http://www.autohotkey.com/forum/post-386538.html
PreventKeyPressBeep() 
{	
	IfEqual,A_Gui,1,Return 0 ; prevent keystrokes for GUI 1 only
}