﻿﻿; RIS/HIS/PACS control
; YL branch

getHISExamID(type = "AccessNo")
{
  EnvGet, I, I
  SetTitleMatchMode 2
  WinGetText, WinText, 檢查報告
  Loop, 10
  {
    if (type == "AccessNo")
	  FoundPos := RegExMatch(WinText, "(X\S{2}\d{5})", ExamID)
	else
	  FoundPos := RegExMatch(WinText, "000*(\d*)", ExamID)
	if FoundPos > 0
	  break
	Sleep 100
  }
  if (I == "RDP")
  {
    clipboard = %ExamID%
  }
  return ExamID
}

getImpaxExamID(type=1)
{
  SetTitleMatchMode 2
  WinGetText, WinText, IMPAX
  if (type == 1)
  {
    RegExMatch(WinText, "(X\S{2}\d{5})", ExamID)
  }
  else
  {
    RegExMatch(WinText, "m)^(\d+)$", ExamID)
  }
  return ExamID
}

getImpaxExamDate(format=0)
{
  SetTitleMatchMode 2
  WinGetText, WinText, IMPAX
  RegExMatch(WinText, "\| (\d+)/(\d+)/(\d+)", ExamDate)
  y := ExamDate1 - 1911
  if (ExamDate2 >= 10)
    m = %ExamDate2%
  else
    m = 0%ExamDate2%
  if (ExamDate3 >= 10)
    d = %ExamDate3%
  else
    d = 0%ExamDate3%
  if (%format% == 0)
    date = 0%y%%m%%d%
  return date
}

InputPACS(type="ChartNo", Str="", Status="", date="", reset=1)
{
  CoordMode, Mouse, Screen
  MouseGetPos, xpos, ypos 
  CoordMode, Mouse, Relative
  worklistPACS(1)
  ; reset
  if (reset = 1)
  {
    MouseClick, left,  1066,  362
    Sleep, 100
  }

  ; Expand date
  if (date = "today")
  {
    MouseClick, left, 800, 240
    sleep 100
    MouseClick, left, 800, 280
    sleep 100
  }
  else if (date = "yesterday")
  {
    MouseClick, left, 800, 240
    sleep 100
    MouseClick, left, 800, 300
    sleep 100
  }
  else if (date = "unchanged")
  {
  }
  else
  {
    MouseClick, left, 800, 240
    sleep 100
    MouseClick, left, 800, 260
    Sleep, 100
  }

  if (Status = "new")
  {
    MouseClick, left,  400, 300
    Sleep, 100
    MouseClick, left,  400,  345
    Sleep, 100  
  }

  ; Input ChartNo
  if (type == "ChartNo")
  {
    MouseClick, left, 125, 235
    SendInput, *
  }
  else if (type == "AccessNo")
    MouseClick, left, 125, 300
  if (Str != "")
  {
    Sleep 100
    SendInput %Str%{Enter}
  }

  CoordMode, Mouse, Screen
;  MouseMove, xpos, ypos 
  CoordMode, Mouse, Relative
}

worklistPACS(main = 0)
{
  ; 0: switch, 1: worklist, 2: pt info
  CoordMode, Mouse, Screen
  MouseGetPos, xpos, ypos 
  MouseMove 0,0
  CoordMode, Mouse, Relative
  title = IMPAX
  WinActivate, %title%
  Sleep 250
  Loop, 50
  {
    IfWinNotActive, %title%
      WinActivate, %title%
    else
      break
  }
  PixelGetColor, Color, 5, 70
  if ((Color == 0X3F3F26 && main == 1) or (Color == 0X000000 && main == 2))
  {
  }
  else
  {
    MouseClick, left, 400, 40
    loop, 50
    {
      PixelGetColor, Color, 5, 70
      if ((Color == 0X3F3F26 && main == 1) or (Color == 0X000000 && main == 2) or (main == 0))
        break
      Sleep 100
    }
  }
  if (main == 0 or main == 2)
  {
    CoordMode, Mouse, Screen
    MouseMove, xpos, ypos
    CoordMode, Mouse, Relative
  }
  WinGet, active_id, ID, A
  return %active_id%
}

RefreshPACS()
{
  worklistPACS(1)
  CoordMode, Mouse, Screen
  MouseGetPos, xpos, ypos 
  MouseMove 0,0
  CoordMode, Mouse, Relative
  WinWait, IMPAX
  WinActivate
  Sleep 250
  MouseClick, left, 350, 120
  CoordMode, Mouse, Screen
  MouseMove, xpos, ypos
  CoordMode, Mouse, Relative
}

callPACS(type = "AccessNo", ExamID = 0)
{
  InputPACS(%type%, %ExamID%)
  if (type == "AccessNo")
    viewImage("this")
}

switch_system(s=0)
{
  if (s == 0) ; N_HOSPITAL/Y_BRANCH
  {
    EnvGet, HIS, HIS
    HIS *= -1
    EnvSet, HIS, %HIS%
    if (HIS > 0)
      MsgBox, YLH
    else
      MsgBox, N_HOSPITAL
  }
  else if (s == 1) ;Approval
  {
    EnvGet, Approval, Approval
    Approval *= -1
    EnvSet, Approval, %Approval%
    if (Approval > 0)
      MsgBox, Approval
    else
      MsgBox, No Approval
  }
  else if (s == 2) ; IdType
  {
    EnvGet, IdType, IdType
    IdType *= -1
    EnvSet, IdType, %IdType%
    if (IdType > 0)
      MsgBox, AssessNo
    else
      MsgBox, ChartNo
  }
}

activateReport()
{
  EnvGet, I, I
  EnvGet, HIS, HIS
  SetTitleMatchMode 2
;  if (I == "N_HOSPITAL")
;  {
;    if HIS > 0
;      title = 172.22.111
;    else
      title = RADIOLOGICAL INFORMATION SYSTEM
;  }
;  else
;  {
;    title = 檢查報告
;  }
  WinActivate, %title%
  Sleep 250
  Loop, 10
  {
    IfWinNotActive, %title%
    {
      ifWinExist, 訊息視窗 ahk_class AcucobolWClass
        ControlClick, 確定
      WinActivate, %title%
    }
    else
      break
  }
  if (I == "N_HOSPITAL")
  {
;    if (HIS < 0)
      SendInput, {F4}
  }
  else
    ControlFocus, Edit1
;  if (I == "N_HOSPITAL" and HIS > 0)
;  { 
;    SendPlay, !r
;  }
}

viewHISNote()
{
  EnvGet, I, I
  CoordMode, Mouse, Screen
  MouseGetPos, xpos, ypos 
  CoordMode, Mouse, Relative
  activateReport()
  if  (I = "N_HOSPITAL")
    SendPlay, !i
  else
    ControlClick, 類別醫令備註
  CoordMode, Mouse, Screen
  MouseMove, xpos, ypos
  CoordMode, Mouse, Relative
}

viewImage(dir)
{
  CoordMode, Mouse, Screen
  MouseGetPos, xpos, ypos 
  CoordMode, Mouse, Relative
  active_id := worklistPACS(1)
  Sleep, 100
  WinGetPos, X, Y, W, H
  PixelSearch, x1, y1, 20, 180, 40, %H%, 0x333333, 3, Fast 
;  if ErrorLevel <> 0
    MouseClick, left, %x1%, %y1%   ; go found
  Sleep 100
  if (dir == "Down")
  {
    SendInput {Down}
  }
  if (dir == "Up")
  {
    SendInput {Up}
  }
  X := W - 200
  Y := 200
  Sleep 250
  PixelSearch, x1, y1, %X%, %Y%, %W%, %H%, 0xC8D0D4, 3, Fast ; get first non-selected row position
  PixelSearch, x2, y2, %X%, %Y%, %W%, %H%, 0xB2B17F, 3, Fast ; get current row position
  if ErrorLevel
  {
    ; go first
    MouseClick, left, %x1%, %y1%+5, 2
  }
  else
  {
    ; go first found
    MouseClick, left, %x2%, %y2%+5, 2
  }
  WinWaitActive, , STUDY_NAV_TOOLBAR0, 3
  WinWait, , Slider1, 3,
  WinWait, IMPAX, 檢查流水號, 3,
  ;worklistPACS(2)
  ;Sleep 200
  ExamDate := getImpaxExamDate()
  EnvGet Idtype, Idtype
  if (Idtype > 0)
  {
    callHIS(1)
  }
  else
  {
    callHIS(2, ExamDate)
    SendInput, {Enter}
  }
  CoordMode, Mouse, Screen
  MouseMove, xpos, ypos 
  CoordMode, Mouse, Relative
}

nextImage()
{
  viewImage("Down")
}

prevImage()
{
  viewImage("Up")
}

listImage()
{
  ChartNo := getHISExamID("ChartNo")
  callPACS("ChartNo", %ChartNo%)
}

checkImage(next=1)
{
  ImpaxApprovalReport()
  if (next == 1)
  {
    Sleep, 100
    nextImage()
  }
}

ImpaxApprovalReport()
{
  CoordMode, Mouse, Screen
  MouseGetPos, xpos, ypos 
  worklistPACS(1)
  EnvGet Approval, Approval
  if (Approval > 0)
    ControlClick, Approval Report, 
  MouseMove, xpos, ypos
  CoordMode, Mouse, Relative
;  Sleep 100
}

checkExam2(next=1)
{
  SendPlay {F9}
  checkImage(next)
}

checkExam()
{
  EnvGet, I, I
  if (I == "N_HOSPITAL")
  {
    SendPlay {F9}
    Sleep 750
    SendPlay {Down}
    Sleep 250
    SendPlay {Enter}
    Sleep 750
    clip := clipboard
	SendPlay ^e
    Sleep 100
    ExamID := clipboard
  }
  else
  {
    SendInput, {F9}
    Sleep 750
    SendInput {Down}
    Sleep 250
    SendInput {Enter}
    Sleep 750
    ExamID := getHISExamID("AccessNo")
    if (I == "RDP")
      clipboard := %ExamID%
  }
  ImpaxApprovalReport()
  InputPACS("AccessNo", ExamID)
  viewImage("this")
}

worklistHIS()
{
  EnvGet, I, I
  activateReport()
  if (I == "N_HOSPITAL")
  {
    SendPlay, ^!f
  }
  else
  {
    Winactivate, 檢查報告登錄
    ControlClick, 離開, 檢查報告登錄, 存檔
    WaitworklistHIS:
	Winwaitactive, 檢查報告登錄,, 1,, 存檔
    If ErrorLevel<>0
      goto, WaitworklistHIS
  }
}

inputHIS(type=1,ExamID="",ExamDate="")
{
  EnvGet, I, I
  if (I != "N_HOSPITAL")
  {
    worklistHIS()
    if (type == 2)
    {
      ;ControlSend, Edit4, {Home}{Shift Down}{End}{Shift Up}{Delete}
      ;ControlSend, Edit5, {Home}{Shift Down}{End}{Shift Up}{Delete}
      ControlSend, Edit4, {Ctrl Down}a{Ctrl Up}{Delete}%ExamDate%
      ControlSend, Edit5, {Ctrl Down}a{Ctrl Up}{Delete}%ExamDate%
    }
    ControlFocus, Edit%type%
    ;ControlSend, Edit%type%, {Home}{Shift Down}{End}{Shift Up}{Delete}
    ControlSend, Edit%type%, {Ctrl Down}a{Ctrl Up}{Delete}
    if ExamID
      ControlSend, Edit%type%, %ExamID%{Enter}
    
  }
  else ; N_HOSPITAL
  {
    ActivateReport()
    Sleep 100
    SendPlay, ^!c
    SendPlay, %type%:%ExamID%{Enter}
  }
}

viewAdmissionNote(ExamID="")
{
  EnvGet, I, I
  if (I != "RDP")
  {
    ExamID := getImpaxExamID(2)
    Sleep 100
  }
  if (I != "N_HOSPITAL")
  {
    CoordMode, Mouse, Screen
    MouseGetPos, xpos, ypos 
    CoordMode, Mouse, Relative
    WinActivate, 病歷摘要維護作業
    MouseClick, left, 180, 40
    Sleep 100
    MouseClick, left, 130, 95, 2
    CoordMode, Mouse, Screen
    MouseMove, xpos, ypos
    CoordMode, Mouse, Relative
    Sleep, 100
  }
  else ; N_HOSPITAL
  {
    ActivateReport()
    SendPlay, !m
    Sleep 100
    ;SendPlay, %type%:
  }
  if ExamID
  {
    SendPlay, %ExamID%{Enter}
  }
}


callHIS(type=1, ExamDate="")
{
  EnvGet, I, I
  if (I != "RDP")
  {
    ExamID := getImpaxExamID(type)
    Sleep 100
  }
  InputHIS(type, ExamID, ExamDate)
}

ReloadHIS(type=1)
{
  CoordMode, Mouse, Screen
  MouseGetPos, xpos, ypos 
  CoordMode, Mouse, Relative
  worklistPACS(2)
  callHIS(type)
  CoordMode, Mouse, Screen
  MouseMove, xpos, ypos 
  CoordMode, Mouse, Relative
}

viewExam(dir="Down")
{
  EnvGet, I, I
  worklistHIS()
  Sleep 100
  if (dir == "Down")
    SendInput {Down}
  else if (dir == "Up")
    SendInput {Up}
  Sleep 100
  SendInput {Enter}
  Sleep 250
  if (I != "RDP")
  {
    ExamID := getHISExamID("AccessNo")
    callPACS("AccessNo", %ExamID%)
  }
  else
  {
    clipboard := getHISExamID("AccessNo")
  }
}

nextExam()
{
  viewExam("Down")
}

prevExam()
{
  viewExam("Up")
}

#IfWinActive ahk_class AcucobolWClass
!v::  
  ControlClick, PACS 影像,,, LEFT, 1, NA, ,
return
;!l::listImage()
;+Enter::checkExam()
!Enter::checkExam2(1)
^Enter::checkExam2(0)
!c::ReloadHIS(1)
!d::ReloadHIS(2)
;!f::ReloadHIS(3)
!n::nextImage()
!p::prevImage()
!Down::nextImage()
!Up::prevImage()
;!n::nextExam(1)
;!p::prevExam(1)
;F3::checkExam()
F3::viewHISNote()
F4::viewHISNote()
F12::nextExam()
F11::prevExam()
#IncludeAgain include\radiology.ahk
#ifWinActive

#ifWinActive ahk_class TSSHELLWND
!v::
  SendPlay ^e
  Sleep 100
  ExamID := clipboard
  viewImage(ExamID)
return

;!l::
;  SendPlay !c
;  Sleep 100
;  listImage()
;return

!c::ReloadHIS(1)
!d::ReloadHIS(2)
!n::nextImage()
!p::prevImage()
;!j::nextExam()
;!k::prevExam()
;+Enter::checkExam()
!Enter::checkExam2(1)
^Enter::checkExam2(0)
!Down::nextImage()
!Up::prevImage()

!a::
  SendInput, Chest shows normal cardiomediastinal silhouette. The costophrenic sulci are sharp. The lungs are clear. `
  Sleep 1000
  checkExam2(1)
return
!b::SendInput Bone structures are anatomic in alignment. No evident fracture or dislocation. `
!z::
  SendInput Chest PA and lateral shows normal cardiomediastinal silhouette. The costophrenic sulci are sharp. The lungs are clear. `
  Sleep 1000
  checkExam2(1)
return
;!k::
;  SendInput KUB/Abdomen shows unremarkable bowel gas pattern. There is no evidence of free intraperitoneal air. No abnormal gas distribution is seen. No abnormal calcification is seen. `
;  Sleep 1500
;  checkExam2(1)
return
!s::
  SendInput KUB/Abdomen shows unremarkable bowel gas pattern. There is no evidence of free intraperitoneal air. No abnormal gas distribution is seen. No abnormal calcification is seen. `
  Sleep 1500
  checkExam2(1)
return
!l::
  SendInput, Lumbar spine shows fine alignment of lumbar spine. No evident fracture or dislocation. Preserved disc spaces.
  Sleep 1000
  checkExam2(1)
return
!j::
  SendInput, Fine alignment of spinal curve. No evident fracture or dislocation. Preserved disc spaces. No obvious prevertebral soft tisue swelling.
  Sleep 1000
  checkExam2(1)
return

#IfWinActive


#ifWinActive IMPAX 6
!c::callHIS(1)
!d::callHIS(2)
!n::nextImage()
!p::prevImage()
!Down::nextImage()
!Up::prevImage()
!Enter::viewImage("this")
#IfWinActive 

!r::
  activateReport()
return

!x::worklistPACS()
!w::worklistPACS(1)
!q::worklistPACS(2)
;!y::findcolor()
!0::InputPacs("ChartNo", "", "", "unchanged", 0)
!1::InputPACS("ChartNo")
!2::InputPACS("AccessNo")
!Numpad1::InputPACS("AccessNo","*XHM","new","today")
!Numpad2::InputPACS("AccessNo","*X33","new","today")
!Numpad3::InputPACS("AccessNo","*X35","new","today")
!Numpad4::InputPACS("AccessNo","*XHM","new","yesterday")
!Numpad5::InputPACS("AccessNo","*X33","new","yesterday")
!Numpad6::InputPACS("AccessNo","*X35","new","yesterday")
!Numpad7::InputPACS("AccessNo","*XHM","new","unchanged",0)
!Numpad8::InputPACS("AccessNo","*X33","new","unchanged",0)
!Numpad9::InputPACS("AccessNo","*X35","new","unchanged",0)
^!c::
  Input, ExamID, C I L13 T1, {Enter}
  RegExMatch(ExamID, "(\d):(\S*)", ID)
  inputHIS(ID1,ID2)
return
^!f::worklistHIS()
!i::viewHISNote()
!m::viewAdmissionNote()
!n::nextImage()
!p::prevImage()
!Down::nextImage()
!Up::prevImage()
!c::ReloadHIS(1)
!d::ReloadHIS(2)
;!l::RefreshPACS()
^F12::switch_system(2)
^F11::switch_system(1)
^F10::switch_system(0)
