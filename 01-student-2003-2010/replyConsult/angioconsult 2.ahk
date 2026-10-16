﻿;;;;;;;;;;Setting;;;;;;;;;;
DetectHiddenWindows, On
DetectHiddenText, On
SetTitleMatchMode, 2
SetTitleMatchMode, fast
SendMode, Input
SetWorkingDir %A_ScriptDir%
#Hotstring EndChars -()[]{}:;'"/\,.?!`n `t
#include <sleipnir>

today:=substr(a_now,1,8)
date1:=date2:=date3:=a_now
date1 +=1,days
date2 +=2,days
date3 +=3,days
FormatTime, date1, %date1%, yyyy/MM/dd ddd
FormatTime, date2, %date2%, yyyy/MM/dd ddd
FormatTime, date3, %date3%, yyyy/MM/dd ddd


AngioconsultList =
Loop, *.txt,,1
     AngioconsultList = %AngioconsultList%%A_LoopFileName%|

;list box
Gui, Add, Text, x5 y6 w250 h20 , Angioconsult List
Gui, Add, ListBox, vlistbox1 sort x6 y37 w250 h330 +Left glistbox1,%AngioconsultList% 

; edit text
Gui, Add, Text, x265 y6 w330 h20 , Text
Gui, Add, Edit, vangioedit x265 y36 w430 h330 , 

;date
Gui, Add, Text, x6 y387 w250 h30 , 日期
Gui, Add, Radio, vdateradio1 gdate1 x6 y417 w250 h30 checked, 明天 %date1%
Gui, Add, Radio, vdateradio2 gdate2 x6 y457 w250 h30 , 後天 %date2%
Gui, Add, Radio, vdateradio3 gdate3 x6 y497 w250 h30 , 大後天 %date3%
Gui, Add, Radio, vdateradio0 gdate4 x6 y537 w15 h30 , 
Gui, Add, DateTime, vday gday x25 y537 w160, yyyy/MM/dd ddd
;time
Gui, Add, Text, x290 y387 w70 h30 , 時間
Gui, Add, Radio, vam gam x290 y417 w70 h30 , AM
Gui, Add, Radio, vpm gpm x290 y457 w70 h30 , PM
;side
Gui, Add, Text, x390 y387 w80 h30 , 部位
Gui, Add, Radio, vright gright x390 y417 w80 h30 , Right
Gui, Add, Radio, vleft gleft x390 y457 w80 h30 , Left
Gui, Add, Radio, vbilateral gbilateral x390 y497 w80 h30 , Bilateral


;button
Gui, Add, Button, vunselect gunselect x6 y577 w100 h30 , Unselect
Gui, Add, Button, vcopy gcopy x146 y577 w100 h30 , Copy
Gui, Add, Button, vsave gsave x286 y577 w100 h30 , Save
Gui, Add, Button, vreadme greadme x426 y577 w100 h30 , ReadMe
Gui, Add, Button, vexit gexit x566 y577 w100 h30 , Exit

Gui, Show,xCenter yCenter w710 h625, Angioconsult
gosub date1
return

GuiClose:
ExitApp

listbox1:
GuiControlGet, listbox1
FileRead, Currentselected, %A_ScriptDir%\%listbox1%
gui, submit, nohide
; for date
if (dateradio1 = 1)
  StringReplace, Currentselected, Currentselected, "date", "%date1%",
if (dateradio2 = 1)
  StringReplace, Currentselected, Currentselected, "date", "%date2%",
if (dateradio3 = 1)
  StringReplace, Currentselected, Currentselected, "date", "%date3%",
if (dateradio0= 1)
{
  FormatTime, date4, %day%, yyyy/MM/dd ddd
  StringReplace, Currentselected, Currentselected, "date", "%date4%",
}
;for time
if (am = 1)
     StringReplace, Currentselected, Currentselected, "time", "AM",
if (pm = 1)
     StringReplace, Currentselected, Currentselected, "time", "PM",
;for side
if (right = 1)
     StringReplace, Currentselected, Currentselected, "side", "Right",
if (left = 1)
     StringReplace, Currentselected, Currentselected, "side", "Left",
if (bilateral = 1)
     StringReplace, Currentselected, Currentselected, "side", "Bilateral",
GuiControl,, angioedit, %Currentselected%
return



;;;;;;;;;;;;;;;;;;;;;;;;; DATE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
date1:
GUIcontrolGet, angioedit,,,text
Currentselected = %angioedit%
Gui, submit, nohide
FormatTime, date4, %day%, yyyy/MM/dd ddd
StringReplace, Currentselected, Currentselected, "date", "%date1%",
StringReplace, Currentselected, Currentselected, "%date2%", "%date1%",
StringReplace, Currentselected, Currentselected, "%date3%", "%date1%",
StringReplace, Currentselected, Currentselected, "%date4%", "%date1%",
selectedDate:=date1
GuiControl,, angioedit, %Currentselected%
return

date2:
GUIcontrolGet, angioedit,,,text
Currentselected = %angioedit%
Gui, submit, nohide
FormatTime, date4, %day%, yyyy/MM/dd ddd
StringReplace, Currentselected, Currentselected, "date", "%date2%",
StringReplace, Currentselected, Currentselected, "%date1%", "%date2%",
StringReplace, Currentselected, Currentselected, "%date3%", "%date2%",
StringReplace, Currentselected, Currentselected, "%date4%", "%date2%",
selectedDate:=date2
GuiControl,, angioedit, %Currentselected%
return

date3:
GUIcontrolGet, angioedit,,,text
Currentselected = %angioedit%
Gui, submit, nohide
FormatTime, date4, %day%, yyyy/MM/dd ddd
StringReplace, Currentselected, Currentselected, "date", "%date3%",
StringReplace, Currentselected, Currentselected, "%date2%", "%date3%",
StringReplace, Currentselected, Currentselected, "%date1%", "%date3%",
StringReplace, Currentselected, Currentselected, "%date4%", "%date3%",
selectedDate:=date3
GuiControl,, angioedit, %Currentselected%
return

date4:
GUIcontrolGet, angioedit,,,text
Currentselected = %angioedit%
Gui, submit, nohide
FormatTime, date4, %day%, yyyy/MM/dd ddd
StringReplace, Currentselected, Currentselected, "date", "%date4%",
StringReplace, Currentselected, Currentselected, "%date2%", "%date4%",
StringReplace, Currentselected, Currentselected, "%date3%", "%date4%",
StringReplace, Currentselected, Currentselected, "%date1%", "%date4%",
selectedDate:=date4
GuiControl,, angioedit, %Currentselected%
return

day:
GUIcontrolGet, angioedit,,,text
Currentselected = %angioedit%
StringReplace, Currentselected, Currentselected, "%date4%", "date",
GuiControl,, angioedit, %Currentselected%
Gui, submit, nohide
guicontrol, ,dateradio0,1
goto, date4
return

;;;;;;;;;;;;;;;;;;;;;;;;; TIME ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
am:
GUIcontrolGet, angioedit,,,text
Currentselected = %angioedit%
StringReplace, Currentselected, Currentselected, "time", "AM",
StringReplace, Currentselected, Currentselected, "pm", "AM",
selectedTime:="AM"
GuiControl,, angioedit, %Currentselected%
return

pm:
GUIcontrolGet, angioedit,,,text
Currentselected = %angioedit%
StringReplace, Currentselected, Currentselected, "time", "PM",
StringReplace, Currentselected, Currentselected, "AM", "PM",
selectedTime:="PM"
GuiControl,, angioedit, %Currentselected%
return

;;;;;;;;;;;;;;;;;;;;; SIDE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
right:
GUIcontrolGet, angioedit,,,text
Currentselected = %angioedit%
StringReplace, Currentselected, Currentselected, "side", "Right",
StringReplace, Currentselected, Currentselected, "left", "Right",
StringReplace, Currentselected, Currentselected, "bilateral", "Right",
GuiControl,, angioedit, %Currentselected%
return

left:
GUIcontrolGet, angioedit,,,text
Currentselected = %angioedit%
StringReplace, Currentselected, Currentselected, "side", "Left",
StringReplace, Currentselected, Currentselected, "right", "Left",
StringReplace, Currentselected, Currentselected, "bilateral", "Left",
GuiControl,, angioedit, %Currentselected%
return

bilateral:
GUIcontrolGet, angioedit,,,text
Currentselected = %angioedit%
StringReplace, Currentselected, Currentselected, "side", "Bilateral",
StringReplace, Currentselected, Currentselected, "right", "Bilateral",
StringReplace, Currentselected, Currentselected, "left", "Bilateral",
GuiControl,, angioedit, %Currentselected%
return

;;;;;;;;;;;;;;;;;;;;;;;;Buttons;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Unselect:
GUicontrol,,dateradio0,0
guicontrol,,dateradio1,0
guicontrol,,dateradio2,0
guicontrol,,dateradio3,0
guicontrol,,am,0
guicontrol,,pm,0
guicontrol,,right,0
guicontrol,,left,0
guicontrol,,bilateral,0
GUIcontrolGet, angioedit,,,text
Currentselected = %angioedit%
Gui, submit, nohide
FormatTime, date4, %day%, yyyy/MM/dd ddd
StringReplace, Currentselected, Currentselected, "%date1%", "date",
StringReplace, Currentselected, Currentselected, "%date2%", "date",
StringReplace, Currentselected, Currentselected, "%date3%", "date",
StringReplace, Currentselected, Currentselected, "%date4%", "date",
StringReplace, Currentselected, Currentselected, "am", "time",
StringReplace, Currentselected, Currentselected, "pm", "time",
StringReplace, Currentselected, Currentselected, "left", "side",
StringReplace, Currentselected, Currentselected, "right", "side",
StringReplace, Currentselected, Currentselected, "bilateral", "side",
GuiControl,, angioedit, %Currentselected%
return

copy:
GUIcontrolGet, angioedit,,,text
if instr(angioedit,"""side""") || instr(angioedit,"""date""") || instr(angioedit,"""time""") {
    msgbox Please fill all fields!
    return
}
StringReplace, angioedit, angioedit, `n,`r`n, All
StringReplace, angioedit, angioedit, ",, All
Clipboard = %angioedit%

slpWin:=getSlpWb()
if slpWin.maxIndex()<1 || !instr(slpWin[1].LocationURL,"WebApplication/InPatient/Ward/NotifyOtherDoctor.aspx")
    return
if trim(slpWin[1].document.getElementById("NWeb1_TextboxSuggestion").value)=""
    slpWin[1].document.getElementById("NWeb1_TextboxSuggestion").value:=angioedit
else 
    slpWin[1].document.getElementById("NWeb1_TextboxSuggestion").value:=slpWin[1].document.getElementById("NWeb1_TextboxSuggestion").value "`r`n`r`n" angioedit

if trim(slpWin[1].document.getElementById("NWeb1_TextboxDiagnosis").value)=""
    slpWin[1].document.getElementById("NWeb1_TextboxDiagnosis").value:="The procedure is arranged on " selectedDate " " selectedTime " on call."

winactivate,ahk_class SleipnirMainWindow

return

save:
gui, submit, nohide
GUIcontrolGet, angioedit,,,text
Currentselected = %angioedit%
GuiControlGet, listbox1
FileDelete, %A_ScriptDir%\%listbox1%
FileAppend, %Currentselected%, %A_ScriptDir%\%listbox1%
return

readme:
msgbox, 
(
文本請以.txt存檔
內容中:
- 日期請用 "date" 標記
- AM/PM 請用 "time" 標記
- 左右邊或者是雙側請用 "side" 標記
例:
"Side" PCN is scheduled on "date" "time" on call.
Please: 
- Obtain informed consent.
- Check patient laboratory data before the procedure (PLT, PT/PTT, and renal function).
- NPO for 6 hours before angiography except medicines (but OHA and insulin should be held during NPO)
- Presence of family during the whole procedure

Unselect 按鈕可以取消全部選擇
)
return

exit:
ExitApp
return
