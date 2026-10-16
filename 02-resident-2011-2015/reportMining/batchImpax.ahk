#NoEnv
#SingleInstance,Off
SetBatchLines,-1
;~ DetectHiddenWindows, On
SetTitleMatchMode,2
;~ coordmode,mouse,screen
#NoTrayIcon
#persistent
#include <RisImpax>
#include <ImpaxContextServer>
#include <JXON>
onexit,onexit


;~ MsgBox
args:=[]
Loop %0%
	args.push(%a_index%)
	;~ args.push("8______")
	;~ args.push("T__________")
	

if (args[0]~="i)^(-+|\/|\\)h(elp)?$") || args.maxindex()<1{
	MsgBox, 
	(LTrim
	Usage: 
	1. Login IMPAX.
	2. Run ImpaxContextServer.exe
	3. batchImpax.exe AccNo1 [AccNo2] [AccNo3] ... 
	)
	ExitApp
}


impaxState:=ImpaxOpened()
if (impaxState[1]!=2){
	MsgBox % "Login IMPAX first!"
	ExitApp
}

if !(hwnd:=ImpaxContextServer_Init()){
	MsgBox % "Run ImpaxContextServer.exe first!"
	ExitApp
}


;~ SplitPath,A_ScriptFullPath,,,,fileNameNoExt

;~ MsgBox % ExploreObj(args)
;~ MsgBox % fileNameNoExt

for k,v in args {
	if (v~="^(T|Y)\w{9}\d$"){
		ImpaxContextServer_Add(v, hwnd)
		Sleep 500
	}
}
MsgBox,,,% "Finished!",3
ExitApp
return 

OnExit:
ExitApp