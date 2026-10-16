﻿﻿﻿n = 3

activate_tamis(n=1)
{
  loop, %n%
  {
    RunWait C:\cwin\tamisgui.bat
    WinWait TAMIS-GUI
    GroupAdd TAMIS, ahk_class AcucobolWClass
  }
}

login_tamis(type=1,x=0,y=0)
{
  SetTitleMatchMode 2
  ;Run C:\cwin\tamisgui.bat
  GroupAdd, TAMIS, TAMIS-GUI ahk_class AcucobolWClass
  ;loop, %n%
  {
    GroupActivate TAMIS
    WinWaitActive, TAMIS

    if (x > 0 || y > 0)
      WinMove, %x%, %y%
;    MouseClick, left,  100,  231
;    Sleep, 100
    ControlSend, Edit1, {Home}{Shift Down}{End}{Shift Up}{Delete}1048
	ControlSend, Edit2, {Home}{Shift Down}{End}{Shift Up}{Delete}1048
	ControlClick, AcuBitButtonClass1
    ;MouseClick, left,  74,  360
    Sleep, 100
    WinWait, 線路重設作業, ,3
    IfWinExist
    {
      WinActivate
      ;ControlClick, Button2
      ControlClick, 離 開
      ;MouseClick, left,  193,  170
      ;Sleep, 100
    }
    WinWait, 權限密碼確認後方可使用線路維護作業, ,3 
    IfWinExist, 權限密碼確認後方可使用線路維護作業
    {
      WinActivate
      ControlClick, Button2
	  ;MouseClick, left,  202,  135
      ;Sleep, 100
    }
    WinWait, 院區設定作業, 
    WinActivate
	ControlClick, Button2
    ;MouseClick, left,  333,  276
    ;Sleep, 100
	
    WinWait, TAMIS-GUI, N醫院Y分院
    WinActivate
	
    if (type == 1)
    {
      MouseClick, left, 113, 296, 2
      Sleep, 100
      WinWait, 放射線科, 
      WinActivate
      SendPlay, !21
    }
    if (type == 2)
    {
      MouseClick, left, 95, 194, 2
      Sleep, 100
      WinWait, 住院醫令系統,
      WinActivate
      SendPlay, !17
    }
    if (type == 3)
    {
      MouseClick, left, 95, 194, 2
      Sleep, 100
      WinWait, 住院醫令系統,
      WinActivate
      SendPlay, !13
    }
  }
}

login_impax6(id,passwd)
{
	WinWait, IMPAX 6, 
	WinActivate
	ControlSend, WindowsForms10.EDIT.app72, {Home}{Shift Down}{End}{Shift Up}{Delete}%id%
	ControlSend, WindowsForms10.EDIT.app71, {Home}{Shift Down}{End}{Shift Up}{Delete}%passwd%
	ControlClick, 登入,
}

^!l::
login_tamis(1,0,1000)
return

^!k::
login_tamis(2,0,1000)
return

^!2::
login_tamis(1,0,1000)
login_tamis(2,390,1000)
return

^!3::
login_tamis(1,0,1000)
login_tamis(1,390,1000)
login_tamis(2,200,700)
return

^!4::
login_tamis(1,0,1000)
login_tamis(1,390,1000)
login_tamis(3,0,700)
login_tamis(2,390,700)
return

!^6::login_impax6("cyyang","cyyang")
