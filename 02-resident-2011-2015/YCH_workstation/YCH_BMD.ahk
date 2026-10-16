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
#SingleInstance,force
#include <RisImpax>
DetectHiddenWindows,on

CloseOtherYCHAHK()
global thisPlace:=getPlace()
OnMessage(0x10101,"Exit")


Loop {
	input,var,v,{/}{NumpadDiv}
	gosub bmd
}



return


::sarco::
t=
(%
Body composition was performed by dual-energy X-ray absorptiometry (DXA).

Findings:
- Total Body % fat:  % 
(overweight: male>23 %, female>35 %; obese: male>25%, female>38%)
- Total lean mass:  kg
- Appendicular lean mass index:  kg/m^2 
(sarcopenia: male<7 kg/m^2, female<5.4 kg/m^2)

Impression:
Normal/overweight/obese/sarcopenia.
)
send % t
return


bmd:
/*
aaa = value of BMD(g/cm2) * 1000
bb = abs(T or Z score)*10
c = / if use z score else empty
d = + if score>0 else empty

score_info = aaacdbb


lumbar:
default level = L1-L4 
other level: xy = Lx-Ly

input: [xy]score_info


hip:
side = r or l
score_info1 = femoral neck info
score_info2 = total BMD info

input: side score_info1 score_info2

*/

hotstr:=var,keys:=[]
lowest:=999
;~ send % "{bs " strlen(var) "}"
Loop,Parse,hotstr,;
{
	this_part:=Trim(A_LoopField)
loop,parse,this_part,.
	keys.push(Trim(a_loopfield))
part:="",level:="L1-L4",outstr:="",t:=999,z:=999
for k,v in keys {
	if v in r,l
		part:=v
	else if regexmatch(v,"is)(\d{3})(\/?)(\+?\d{1,2}) (\d{3})(\/?)(\+?\d{1,2})",match){
		useZ:=!!match2,score:=scoreVal(match3)
		,useZ2:=!!match5,score2:=scoreVal(match6)
		bmd:=bmdVal(match1, score), bmd2:=bmdVal(match4, score2)
		
		
	
		if useZ
			z:=min(score, score2)<z?min(score, score2):z
		else
			t:=min(score, score2)<t?min(score, score2):t
		if (outstr!="")
			outstr.="`r`n"
		outstr.="Bone Mineral Density (BMD) of the " (part="r"?"right":"left") " hip with quantitative dual-energy X-ray absorptiometry shows:`r`n- The BMD of femoral neck is " bmd " g/cm2 (" (useZ?"Z":"T") "-score = " score ").`r`n- The total BMD of " (part="r"?"right":"left") " hip is " bmd2 " g/cm2 (" (useZ2?"Z":"T") "-score = " score2 ").`r`n"
	}else if regexmatch(v,"(\d{3})(\/?)(\+?\d{1,2})",match){
		useZ:=!!match2,score:=scoreVal(match3), bmd:=bmdVal(match1,score)
		if useZ
			z:=score<z?score:z
		else
			t:=score<t?score:t
		if (outstr!="")
			outstr.="`r`n"
		outstr.="Bone Mineral Density (BMD) of the lumbar spine (A-P) with quantitative dual-energy X-ray absorptiometry shows:`r`n- The BMD of lumbar spine (" level ") is " bmd " g/cm2 (" (useZ?"Z":"T") "-score = " score ").`r`n"
	}else if regexmatch(v,"(\d)(\d)(\d?)",match)
		level:="L" match1 "-L" match2 (match3?"-L" match3:"")
		
}

lowest:=min(lowest, t)
}
t:=lowest
if InStr(thisPlace, "N_HOSPITAL") || InStr(thisPlace, "NTUH"){
checkRis(RisState)
gosub renewRisReports
controlsettext,,% outstr,% "ahk_id " risReports[1,1]
;~ controlsettext,Scintilla1,% outstr,simple RIS ahk_class AutoHotkeyGUI
Controlget,editHwnd,hwnd,,Scintilla1, simple RIS ahk_class AutoHotkeyGUI
Edit_SetText(editHwnd, outstr)
controlsettext,,% (t<-2.5?"Osteoporosis":t<-1?"Osteopenia":t<2?"Normal":t!=999?"High BMD":z<-2?"Below the expected range for age":z!=999?"Normal":"") ".",% "ahk_id " risReports[1,2]
}
else if InStr(thisPlace, "CTH"){
	send % outstr "`r`n`r`nImpression:`r`n" (t<-2.5?"Osteoporosis":t<-1?"Osteopenia":t<2?"Normal":t!=999?"High BMD":z<-2?"Below the expected range for age":z!=999?"Normal":"") "."
}
return
renewRisReports:
if !(isobject(risReports) && controlexist(RisReports[1,1]))
	RisReports:=getRisReports(RisState[2])
return
bmdVal(str, score=""){
	SetFormat, float, 0.3
	if strlen(str)=3
		return str>450||score<0?str/1000:(str/1000+1)
	else
		return str/1000
}
scoreVal(str){
	SetFormat, float, 0.1
	return (0.0+str)/10**(strlen(str)-(instr(str,"+"))-1)*(instr(str,"+")?1:-1)
}


;~ esc::exitapp
Hotstring(trigger, label, mode := 1, clearTrigger := 1, cond := ""){
	global $
	
	;symbols exclude ' \ / . + for special use in this script
	static keysBound := false,hotkeyPrefix := "~$", hotstrings := {}, typed := "", keys := {"symbols": "!""#$%&()*,-:;<=>?@[]^_``{|}~", "num": "0123456789", "alpha":"abcdefghijklmnopqrstuvwxyz", "other": "BS,Return,Tab,Space", "breakKeys":"Left,Right,Up,Down,Home,End,RButton,LButton,LControl,RControl,AppsKey,LAlt,RAlt,Lwin,Rwin,WheelDown,WheelUp,f1,f2,f3,f4,f5,f6,f7,f8,f9,f6,f7,f9,f10,f11,f12", "numpad":"Numpad0,Numpad1,Numpad2,Numpad3,Numpad4,Numpad5,Numpad6,Numpad7,Numpad8,Numpad9,NumpadDot,NumpadDiv,NumpadMult,NumpadAdd,NumpadSub,NumpadEnter"}, effect := {"Return" : "`n", "Tab":A_Tab, "Space": A_Space, "Enter":"`n", "Mult":"*"}
	
	if (!keysBound){
		;Binds the keys to watch for triggers.
		for k,v in ["symbols", "num", "alpha"]
		{
			;alphanumeric/symbols
			v := keys[v]
			Loop,Parse, v
				Hotkey,%hotkeyPrefix%%A_LoopField%,__hotstring
		}
		
		v := keys.alpha
		Loop,Parse, v
			Hotkey, %hotkeyPrefix%+%A_Loopfield%,__hotstring
		for k,v in ["other", "breakKeys", "numpad"]
		{
			;comma separated values
			v := keys[v]
			Loop,Parse, v,`,
				Hotkey,%hotkeyPrefix%%A_LoopField%,__hotstring
		}
		keysBound := true ;keysBound is a static varible. Now, the keys won't be bound twice.
	}
	if (mode == "CALLBACK"){
		; Callback for the hotkey.s
		Hotkey := SubStr(A_ThisHotkey,3)
		if (StrLen(Hotkey) == 2 && Substr(Hotkey,1,1) == "+" && Instr(keys.alpha, Substr(Hotkey, 2,1))){
			Hotkey := Substr(Hotkey,2)
			if (!GetKeyState("Capslock", "T")){
				StringUpper, Hotkey,Hotkey
			}
		}
		
		shiftState := GetKeyState("Shift", "P")
		uppercase :=  GetKeyState("Capslock", "T") ? !shiftState : shiftState 
		;If capslock is down, shift's function is reversed.(ie pressing shift and a key while capslock is on will provide the lowercase key)
		if (uppercase && Instr(keys.alpha, Hotkey)){
			StringUpper, Hotkey,Hotkey
		}
		if (Instr("," . keys.breakKeys . ",", "," . Hotkey . ",")){
			typed := ""
			return
		} else if Hotkey in Return,Tab,Space
		{
			typed .= effect[Hotkey]
		} else if (Hotkey == "BS"){
			; trim typed var if Backspace was pressed.
			StringTrimRight,typed,typed,1
			return
		} else if (RegExMatch(Hotkey, "Numpad(.+?)", numKey)) {
			if (numkey1 ~= "\d"){
				typed .= numkey1
			} else {
				typed .= effects[numKey1]
			}
		} else {
			typed .= Hotkey
		}
		matched := false
		for k,v in hotstrings
		{
			matchRegex := (v.mode == 1 ? "Oi)" : "")  . (v.mode == 3 ? RegExReplace(v.trigger, "\$$", "") : "\Q" . v.trigger . "\E") . "$"
			
			if (v.mode == 3){
				if (matchRegex ~= "^[^\s\)\(\\]+?\)"){
					matchRegex := "O" . matchRegex
				} else {
					matchRegex := "O)" . matchRegex
				}
			}
			if (RegExMatch(typed, matchRegex, local$)){
				matched := true
				if (v.cond != "" && IsFunc(v.cond)){
					; If hotstring has a condition function.
					A_LoopCond := Func(v.cond)
					if (A_LoopCond.MinParams >= 1){
						; If the function has atleast 1 parameters.
						A_LoopRetVal := A_LoopCond.(v.mode == 3 ? local$ : local$.Value(0))
					} else {
						A_LoopRetVal := A_LoopCond.()
					}
					if (!A_LoopRetVal){
						; If the function returns a non-true value.
						matched := false
						continue
					}
				}
				if (v.clearTrigger){
					;Delete the trigger
					SendInput % "{BS " . StrLen(local$.Value(0))  . "}"
				}
				if (IsLabel(v.label)){
					$ := v.mode == 3 ? local$ : local$.Value(0)
					gosub, % v.label
				} else if (IsFunc(v.label)){
					callbackFunc := Func(v.label)
					if (callbackFunc.MinParams >= 1){
						callbackFunc.(v.mode == 3 ? local$ : local$.Value(0))
					} else {
						callbackFunc.()
					}
				} else {
					toSend := v.label
				
					;Working out the backreferences
					Loop, % local$.Count()
						StringReplace, toSend,toSend,% "$" . A_Index,% local$.Value(A_index),All
					toSend := RegExReplace(toSend,"([!#\+\^\{\}])","{$1}") ;Escape modifiers
					SendInput,%toSend%
				}
				
			}
		}
		if (matched){
			typed := ""
		} else if (StrLen(typed) > 350){
			StringTrimLeft,typed,typed,200
		}
	} else {
		if (hotstrings.HasKey(trigger) && label == ""){
			; Removing a hotstring.
			hotstrings.Delete(trigger)
		} else {
			; Add to hotstrings object.
			hotstrings[trigger] := {"trigger" : trigger, "label":label, "mode":mode, "clearTrigger" : clearTrigger, "cond": cond}
		}
		
	}
	return

	__hotstring:
	; This label is triggered every time a key is pressed.
	Hotstring("", "", "CALLBACK")
	return
}
exit(){
	ExitApp
}

^!r::
Reload
return

^!x::
suspend
return

^!q::
ExitApp
return

#ifwinactive,ahk_exe simpleRIS.exe
F3::
if (__is_NTUH){
	RisState:=RisOpened()
	if (!sendButton || !controlexist(sendButton))
			sendButton:=getNetControl2(RisState[2],"存檔發送","cmdRunVerifySend","存檔發送","WindowsForms10.BUTTON.app","","","",0)[1]
		controlclick,,% "ahk_id " sendButton
}else if (__is_CTH){
	risSendReport(RisState[2], 3)
}
return
#IfWinActive