﻿﻿﻿;

; AutoHotkey Version: 1.x

; Language:       English

; Platform:       Win9x/NT

; Author:         A.N.Other <physician@hospital.example.com>

;

; Script Function:

;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)

;



#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.





; 自動啟動 RIS + IMPAX 並輸入帳號密碼 (VS)

#v::   ; 按Win-key + v 鍵自動啟動

ris="http://10.0.0.100:8888/NH/NH.jnlp"

impax="C:\impax\select\bin\impax_select.exe"

runame=019467         ;RIS的帳號 (6位數字員工代號)

iuname=019467         ;IMPAX的帳號

rpasswd=7      ;RIS密碼

ipasswd=7      ;IMPAX密碼



Run, %impax%,,,

WinWait,登入,,,,

WinActivate,ahk_class ThunderRT6FormDC,,,

control,editpaste,%iuname%,ThunderRT6TextBox2,ahk_class ThunderRT6FormDC,,,

control,editpaste,%ipasswd%,ThunderRT6TextBox1,ahk_class ThunderRT6FormDC,,,

controlclick,ToolbarWindow321,ahk_class ThunderRT6FormDC,,,,,,



Run, %ris%,,,

Winwait, Login,,,,

WinActivate,ahk_class SunAwtDialog,,,

winget,rpid,PID, ahk_class SunAwtDialog,,,

controlsend, ,%runame%{enter}, ahk_pid %rpid%

controlsend, ,%rpasswd%{enter}, ahk_pid %rpid%

Return



; 自動啟動 RIS + IMPAX 並輸入帳號密碼  (R)

#r::   ; 按Win-key + r 鍵自動啟動

ris="http://10.0.0.100:8888/NH/NH.jnlp"

impax="C:\impax\select\bin\impax_select.exe"

runame=ILS         ;RIS的帳號 (6位數字員工代號)

iuname=019467         ;IMPAX的帳號

rpasswd=ILS      ;RIS密碼

ipasswd=7      ;IMPAX密碼



Run, %impax%,,,

WinWait,登入,,,,

WinActivate,ahk_class ThunderRT6FormDC,,,

control,editpaste,%iuname%,ThunderRT6TextBox2,ahk_class ThunderRT6FormDC,,,

control,editpaste,%ipasswd%,ThunderRT6TextBox1,ahk_class ThunderRT6FormDC,,,

controlclick,ToolbarWindow321,ahk_class ThunderRT6FormDC,,,,,,



Run, %ris%,,,

Winwait, Login,,,,

WinActivate,ahk_class SunAwtDialog,,,

winget,rpid,PID, ahk_class SunAwtDialog,,,

controlsend, ,%runame%{enter}, ahk_pid %rpid%

controlsend, ,%rpasswd%{enter}, ahk_pid %rpid%

Return



; 按Window Key + N 啟動 N hospital intranet (logged-in)

#n::

nhosp="http://sama.cyyang.org/nhosp.htm"

Run, %nhosp%,,,

Return



; 按Window Key + L 啟動 N Hospital lab (logged-in)

#l::

nhosp="http://10.0.0.100/nhosp.htm"

Run, %nhosp%,,,

Return



; 按Window Key+ C 啟動 Case Collection Database (PHPmyAdmin)

#c::

casedb="http://10.0.0.100/phpmyadmin/"

casedb_login=

casedb_passwd=



Run, %casedb%

WinWait,phpMyAdmin - Microsoft Internet Explorer,

IfWinNotActive,phpMyAdmin - Microsoft Internet Explorer, WinActivate,phpMyAdmin - Microsoft Internet Explorer,

WinWaitActive,phpMyAdmin - Microsoft Internet Explorer,



ControlSetText, Edit1

   , javascript:void(document.login_form.pma_username.focus());

   , phpMyAdmin - Microsoft Internet Explorer

ControlSend, Edit1, {Enter},phpMyAdmin - Microsoft Internet Explorer

Send {Home}%casedb_login%{Del 3}



WinWait,phpMyAdmin - Microsoft Internet Explorer,

IfWinNotActive,phpMyAdmin - Microsoft Internet Explorer, WinActivate,phpMyAdmin - Microsoft Internet Explorer,

WinWaitActive,phpMyAdmin - Microsoft Internet Explorer,



ControlSetText, Edit1

   , javascript:void(document.login_form.pma_password.focus());

   , phpMyAdmin - Microsoft Internet Explorer

ControlSend, Edit1, {Enter},phpMyAdmin - Microsoft Internet Explorer

Send {Home}%casedb_passwd%{Del 10}+{Enter}



Return





; 一般



::hof::History of

::nhis::Clinical history is not available.

::l::left

::r::right

::bi::bilateral

::mol::more on the left side

::mor::more on the right side



::nab::No definite abnormality in this study.

::ro::R/O

::jw::(CTY/JW)







; CXR and plain film



::ap::Chest AP shows

::bpl::bilateral pleural effusion,

::bl::blurred

::c0::Chest PA shows normal heart size and no definite lung lesion.

::c0m::Chest PA shows cardiomegaly and no definite lung lesion.

::clc::suggest clinical correlation.

::cm::cardiomegaly,

::con::consolidation

::cpa::costophrenic angle

::cpm::placement of a cardiac pacemaker,

::cvp::placement of a central venous catheter,

::et::placement of an endotracheal tube,

::inf::mild increased infiltration over both perihilar regions,

::lpl::left pleural effusion,

::ndll::no definite lung lesion,

::ng::placement of a nasogastric tube,

::nh::normal heart size 

::pa::Chest PA shows

::pl::placement of

::pm::pacemaker

::poc::post-operative change

::por::placement of a port-A catheter,

::rpl::right pleural effusion,

::str::sternal wires

::swa::placement of a Swan-Ganz catheter

::tr::status post tracheostomy,

::ycc::(CTY/YCC)





; from SJC



;1. 打完報告按Ctrl-Alt-Q關閉RIS與退出autohotkey:

^!q:: ; Assign Ctrl-Alt-Q as a hotkey to quit RIS and the script.

IfWinExist ahk_class com.pohai.client.application.MainFrame

{

 WinActivate ahk_class com.pohai.client.application.MainFrame

 SendPlay !{F4}

}

ExitApp

 

 

;2. 設定Ctrl-Alt-E 叫出Notepad編輯autohotkey:

^!e:: ; Assign Ctrl-Alt-E as a hotkey to edit the script.

Edit

return

 

;3. 設定Ctrl-Alt-R reload script

^!r:: ; Assign Ctrl-Alt-R as a hotkey to restart the script.

Reload

Sleep 1000 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.

MsgBox, 4,, The script could not be reloaded. Would you like to open it for editing?

IfMsgBox, Yes, Edit

return



 ;4. 設定Ctrl-0 switch to Impression

^0::

Click 28,1064

return





 ;5. 設定Window-1 Open the last ONE report

#1::

Click 857,570

Click 2

return



 ;6.  設定Window-2 Open the last ONE report and Copy it

#2::

Click 857,570

Click 2

Sleep 100

Click 170,400

Click 2

return





;7.  設定Window-3 Open the last ONE PACS image parallel 

; ( 1238,42 ) at report room-3 ( 1095,42 ) at room-1 & Ped-2 ( 1088,42 ) at CT & room-4

#3::

Click 857,570

Click right

Sleep 200

Click right 1012,650

Sleep 200

WinActivate, ahk_class #32770

Sleep 100

Click 1095,42 

Sleep 300

WinActivate, ahk_class com.pohai.client.application.MainFrame

Sleep 200

Click 26,579

return





; open the images parallel...

#4::

WinActivate, ahk_class #32770

Sleep 100

Click 1095,42 

Sleep 500

WinActivate, ahk_class com.pohai.client.application.MainFrame

Sleep 100

Click 26,579

return



