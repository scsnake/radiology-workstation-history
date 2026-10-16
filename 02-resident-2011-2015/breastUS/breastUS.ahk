﻿

#persistent

#NoTrayIcon 

#SingleInstance,force



settimer,kill,200

return



kill:

ifwinactive,報告內容載入 ahk_class TPutLine1

	winclose,報告內容載入 ahk_class TPutLine1

return



#ifwinactive,UniReport ahk_class TMainForm

:?*:``::^+{left}{bs}



^e::

controlfocus,TBitBtn2,UniReport ahk_class TMainForm

controlclick,TBitBtn2,UniReport ahk_class TMainForm

return



return



~F9::

winwait,影像瀏覽 ahk_class TSingleImage,,2

winactivate,影像瀏覽 ahk_class TSingleImage

return



~f2::

controlclick,TBitBtn2,UniReport ahk_class TMainForm

winwait,報告視窗 ahk_class TMainForm,,5

send {F4}

return



end::

if (a_priorhotkey=a_thishotkey && a_timesincepriorhotkey<500){

	

	control,ChooseString,陳醫師,TComboBox3,UniReport ahk_class TMainForm

	FormatTime,wday,% a_now,wday

	if(wday=4)

		control,ChooseString,張醫師,TComboBox2,UniReport ahk_class TMainForm

	else if(wday=5)

		control,ChooseString,王醫師,TComboBox2,UniReport ahk_class TMainForm

}else if !winexist("影像瀏覽 ahk_class TSingleImage") {

	send {end}

}

return

home::

if !winexist("影像瀏覽 ahk_class TSingleImage") {

	send {home}

}else{

	

}

return

~esc::

winclose,影像瀏覽 ahk_class TSingleImage

return

pgup::

controlsend,TAnnForm11,{pgup},影像瀏覽 ahk_class TSingleImage

return

pgdn::

controlsend,TAnnForm11,{pgdn},影像瀏覽 ahk_class TSingleImage

return

#ifwinactive



#ifwinactive,影像瀏覽 ahk_class TSingleImage

~wheeldown::

controlsend,TAnnForm11,{pgdn},影像瀏覽 ahk_class TSingleImage

return

~wheelup::

controlsend,TAnnForm11,{pgup},影像瀏覽 ahk_class TSingleImage

return

#ifwinactive



#ifwinactive,ahk_exe impax-client-main.exe

^b::

clipboard:=""

send ^c

clipwait,1

report:=clipboard

report:=regexreplace(report,"\r\n","`n")

if !regexmatch(report,"s)主訴:\n\s*(.*)\n\sSONAR FINDINGS:\n\s*(.*)\n\sIMPRESSION:\n\s*(.*)",match)

    return

controlsettext,TMemo1,% trimSpaces(match1),ahk_class TMainForm ahk_exe Breast.exe

controlsettext,TMemo3,% trimSpaces(match2),ahk_class TMainForm ahk_exe Breast.exe

controlsettext,TMemo2,% trimSpaces(match3),ahk_class TMainForm ahk_exe Breast.exe

winactivate,ahk_class TMainForm ahk_exe Breast.exe

return

#ifwinactive



trimSpaces(str){

    return regexreplace(regexreplace(RegExReplace(str,"\s*\n\s*(\d)","\/$1"),"\s+"," "),"\\/(\d)","`r`n$1")

}





~!^q::exitapp