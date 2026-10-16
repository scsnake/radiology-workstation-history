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
onexit,onexit
;~ #include <portalLib>
#include <risimpax>
#include <editfunctions>

gosub readRFAtip


gui,+lastfound
mainGUIhwnd:=winexist()
gui,font,s10,verdana
gui,add,text,,History: 
gui,add,edit,r1 w900 vhistory,
gui,add,text,,% "Indication: For CT-guided RFA (" 
gui,add,edit,r1 w50 x+0 vindication,% "1"
gui,add,text,x+0,% ")." 
gui,add,text,xm,% "CT-guided RFA was performed smoothly as procedures described as below:"
gui,add,text,xm,% "1. Patient in the "
gui,add,combobox,x+0 vnote1,supine||right anterior oblique
gui,add,text,x+0,% " position."
gui,add,text,xm,% "2. Total Dormicum "
gui,add,edit,x+0 vDormicum,7.5
gui,add,text,x+0,% "mg and Fentanyl "
gui,add,edit,x+0 vFentanyl,0.175
gui,add,text,x+0,% " mg IV push slowly and local anesthesia with 2% Xylocaine 10mL SC before and during RFA."
gui,add,text,xm,% "3. The RFA needle ("
gui,add,combobox,x+0 w200 vtip,% RFAtip
gui,add,edit,x+0 vtip2,1530
gui,add,text,x+0,% ") was inserted in the "
gui,add,edit,x+0 vnote4,% "lipiodol retention of the tumor at S of liver: "

;~ gui,add,text,,% "RFA needle:"

gui,add,button,gaddAblation xm,% "+"
gui,add,button,gSubmitRis x+50,% "Export"
gui,add,button,gRestart x+50,% "Restart"
gui,add,button,gHelp x+50,% "?"

colWidth:=[30,100,150,150,100,100,150,100]
height:=30
title:=["","Aspect","Initial imp","Imp range","Power","Time","Ending Temp","Pulse"]
for k,v in title {
    if k=1
        gui,add,text,xs vloc1,% title[1]
    else
        gui,add,text,% "xp+" colWidth[k-1],% v
}
gosub addAblation


gui,show,autosize,RFA note


return




restart:
Reload
return

readRFAtip:
iniread,tmp,RFA note.ini,RFA,tip
RFAtip:=""
loop,parse,tmp,;
    RFAtip.=trim(a_loopfield) "|"
return

addAblation:
++ablationCount
;~ guicontrolget,pos,pos,loc1

for k,v in colWidth {
    if k=1
        gui,add,text,% "xs yp+" height,% ablationCount ")"
    else 
        gui,add,edit,% "xp+" colWidth[k-1] " w" v " vt" ablationCount "_" k-1
}
guicontrol,,% "t" ablationCount "_" 5,12
wingetpos,,,,h,% "ahk_id " mainGUIhwnd
guicontrolget,pos,pos,% "t" ablationCount "_" k-1
gui,show,% "h" posy+height
return

;~ submit:
;~ gui,submit,nohide
;~ if ((len:=matchArr.maxIndex())<1`){
	;~ clipboard:=template
	;~ return
;~ }
;~ var%len%:=""
;~ export:=""
;~ for k,v in matchArr {
	;~ export.=substr(template,v.1,v.2-v.1+1) var%k%
;~ }
;~ clipboard:=export
;~ return

submitRis:
gosub export
if (RisOpened()[1]!=2){
    tooltip,Copied!
    settimer,tooltip,-1000
	return
}
;~ RegExMatch(export,"is)^(.*?)[\s\r\n]*(?:Impression\W*(.*))?$",match)
ris:=getRisReports(RisOpened()[2])
controlsettext,,% export,% "ahk_id " ris[1,1]
;~ controlsettext,,% LineBreakConvert(match2),% "ahk_id " ris[1,2]
winactivate,% "ahk_id " RisOpened()[2]
return


Export:
gui,submit,nohide
str:= "History: " trimLineBreak(history) "`nIndication: For CT-guided RFA (" trimLineBreak(indication) ").`n`nCT-guided RFA was performed smoothly as procedures described as below:`n1. Patient in the " trimLineBreak(note1) " position.`n2. Total Dormicum " dormicum "mg and Fentanyl " fentanyl " mg IV push slowly and local anesthesia with 2% Xylocaine 10mL SC before and during RFA.`n" 
str.="3. The RFA needle (" tip tip2 ") was inserted in the " trimLineBreak(note4) "`n"
loop % ablationCount {
    str.="  " a_index ") the "
    
    str.=seq(a_index)
    
    RegExMatch(t%a_index%_1,"is)([^\,]+)\,?(\d*)",match)
    
    str.= "ablation of RFA at the " match1 " aspect" (match2?" of " seq(match2) "tumor":"") ": " (instr(tip,"cooltip")?"initial impedance " t%a_index%_2 " ohm, ":"") "impedance range during RFA " t%a_index%_3 " ohm, power " t%a_index%_4 " watt, time " t%a_index%_5 " min, ending temperature " t%a_index%_6 " degree Celsius, pulse " t%a_index%_7 " times.`n"
}

str.="4. post-procedure images showed no obvious intra- or extra-hepatic hematoma. Low density changes and bubbles at the ablation area.`n5. Please bed rest for 4 hours and follow up serum ALT and T-bil.`n6. Suggest CT study one month later for the treatment effect."
clipboard:=export:=RegExReplace(str,"\n","`r`n")
;~ tooltip,Copied!
;~ settimer,tooltip,-1000
return

seq(n){
    
    if n=1
        str.="1st "
    else if n=2
        str.="2nd "
    else if n=3
        str.="3rd "
    else
        str.=n "th "
    
    return str
}

tooltip:
ToolTip
return

trimLineBreak(str){
    return regexreplace(str,"(^[\n\r]+)|([\n\r]+$)","")
}

guiclose:
onexit:
;~ esc::
~!q::
ExitApp
return

#ifwinactive,RFA note ahk_class AutoHotkeyGUI
f1::
help:
msgbox,4096,, 
(
> RFA note.ini檔案內設定針的種類
> 多一列：按鈕「+」或 ctrl + n
> 輸出到RIS：按鈕「Export」或 ctrl + e
> 重新開始：按鈕「Restart」或 ctrl + r
> 離開：alt + q
> 多於一個tumor時，在aspect可多輸入「,n」表示第n個tumor，eg. central,3
> 上下左右鍵在格子間移動，(shift + ) enter 或 tab 在格子間移動並選取文字
)
return


^n::
gosub addAblation
return
^e::
gosub Export
return
^r::
msgbox Restart?
ifmsgbox,Yes
    gosub restart
return

enter::
numpadenter::
+enter::
+numpadenter::
up::
down::
left::
right::
guicontrolget,focusedCon,focus
guicontrolget,val,,% focusedCon
RegExMatch(focusedCon,"^Edit(\d+)$",match)
firstCell:=8,upEq:=dnEq:=0
if a_thishotkey in +enter,+numpadenter
    upEq:=1
else if a_thishotkey in enter,numpadenter
    dnEq:=1

if (match1="") || !(match1>firstCell)
    goto ret
if (a_thishotkey="up" || upEq){
    if (match1>firstCell+7)
        match1-=7
    else if (match1>firstCell+1)
        match1+=7*(ablationCount-1)-1
}else if (a_thishotkey="down" || dnEq){
    if (match1<=ablationCount*7+firstCell-7)
        match1+=7
    else if (match1<firstCell+ablationCount*7)
        match1-=7*(ablationCount-1)-1
    else
        goto ret
}else if (a_thishotkey="left" && match1>7){
    Edit_GetSelection(start,end,focusedCon,"ahk_id " mainGuiHwnd)
    if (start=end && end=0) || val=""
        match1-=1,Edit_Select(-1,-1,"Edit" match1,"ahk_id " mainGuiHwnd),nosend=1
    else
        goto ret
}else if (a_thishotkey="right" && match1<ablationCount*7+firstCell){
    Edit_GetSelection(start,end,focusedCon,"ahk_id " mainGuiHwnd)
    if (start=end && end=strlen(val)) || val=""
        match1+=1,Edit_Select(0,0,"Edit" match1,"ahk_id " mainGuiHwnd),nosend=1
    else
        goto ret
}
guicontrol,focus,% "Edit" match1
if (upEq || dnEq)
    Edit_Select(0,-1,"Edit" match1,"ahk_id " mainGuiHwnd),nosend=1
ret:
if !nosend
    send % "{" a_thishotkey "}"
nosend=0
return
#ifwinactive

/*
History: Hepatocellular carcinoma, right lobe, status post right posterior segmentectomy and cholecystectomy on 2002/05/17, with recurrence at S6, status post S6 segmentectomy on 2006/03/29, with recurrence, status post transarterial embolization (12). 
Indication: For CT Guide RFA (1).

Non-contrast and contrast enhanced CT-guided RFA was performed smoothly as procedures described as below:
1. Patient in the supine position.
2. Total Dormicum 7.5 mg and Fentanyl 0.175 mg IV push slowly and local anesthesia with 2% Xylocaine 10mL SC before and during RFA.
3. The RFA needle (Cooltip, ACT1530, 1-1x, SP) was inserted in the lipiodol defect of the large tumor at left lobe of liver:  
 1). the 1st course of RFA at the central aspect: initial impedance 65 ohm, impedance range during RFA 63-84 ohm, power 141-106 watt, time 12 min, ending temperature 88 degree Celsius, pulse 3 times.
 2). the 2nd course of RFA at the deep central aspect: initial impedance 63 ohm, impedance range during RFA 61-82 ohm, power 136-100 watt, time 12 min, ending temperature 87 degree Celsius, pulse 4 times.
 3). the 3rd course of RFA at the right aspect: initial impedance 63 ohm, impedance range during RFA 60-81 ohm, power 133-99 watt, time 12 min, ending temperature 88 degree Celsius, pulse 2 times.
 4). the 4th course of RFA at the deep right aspect: initial impedance 60 ohm, impedance range during RFA 60-79 ohm, power 196-151 watt, time 12 min, ending temperature 88 degree Celsius, pulse 4 times.
 5). the 5th course of RFA at the inferior right aspect: initial impedance 63 ohm, impedance range during RFA 60-83 ohm, power 160-76 watt, time 12 min, ending temperature 91 degree Celsius, pulse 3 times.
 6). the 6th course of RFA at the inferior deep right aspect: initial impedance 63 ohm, impedance range during RFA 61-81 ohm, power 127-96 watt, time 13 min, ending temperature 89 degree Celsius, pulse 3 times.
 7). the 7th course of RFA at the inferior central aspect: initial impedance 66 ohm, impedance range during RFA 64-85 ohm, power 123-94 watt, time 12 min, ending temperature 86 degree Celsius, pulse 3 times.
 8). the 8th course of RFA at the inferior aspect: initial impedance 68 ohm, impedance range during RFA 65-87 ohm, power 148-110 watt, time 13 min, ending temperature 87 degree Celsius, pulse 4 times.
4. post-procedure images showed no obvious intra- or extra-hepatic hematoma. The post-procedural after the ablation showed low density changes and bubbles at the ablation area.
5. Please bed rest for 4 hours and follow up serum ALT and T-bil. 
6. Suggest CT study one month later for the treatment effect. 

*/
