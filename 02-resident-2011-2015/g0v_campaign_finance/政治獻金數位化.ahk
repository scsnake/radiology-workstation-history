SetTitleMatchMode,2
DetectHiddenWindows,on
onexit,onexit
coordmode,mouse,screen
comobjerror(false)

n=6


loop % n {
	run % "iexplore.exe http://campaign-finance.g0v.ctiml.tw/cell"
	sleep 1000
}

sleep % n*1000

IEarr:=getIE("政治獻金數位化","http://campaign-finance.g0v.ctiml.tw/cell")

n:=IEarr.maxindex()
focus:=-1
flag:=1

for k,v in IEarr {
	winhide,% "ahk_id " v.HWND
	v.document.getElementById("quick-trigger").click()
}

gosub next


return


getIE(name="",url="") {
	arr:=[]
   IfEqual, Name,, WinGetTitle, Name, ahk_class IEFrame     ;// Get active window if no parameter
   Name := (Name="New Tab - Windows Internet Explorer")? "about:Tabs":RegExReplace(Name, " - (Windows|Microsoft) Internet Explorer")
   for wb in ComObjCreate("Shell.Application").Windows
      if instr(wb.LocationName,Name) and InStr(wb.FullName, "iexplore.exe") && ((!url) || instr(wb.LocationUrl,url))
         arr.push(wb)
		 
	return arr
}

#IfWinActive,政治獻金數位化 ahk_class IEFrame
~pgup::
~enter::
~+enter::
~numpadenter::
next:
sleep 200
if !(flag)
	settimer,next,-500
flag:=0
focus:=mod(++focus,n)
winshow,% "ahk_id " IEarr[focus+1].HWND
winmove,% "ahk_id " IEarr[focus+1].HWND,,0,0,% a_screenwidth,% a_screenheight/2
winshow,% "ahk_id " IEarr[mod(focus+1,n)+1].HWND
winmove,% "ahk_id " IEarr[mod(focus+1,n)+1].HWND,,0,% a_screenheight/2,% a_screenwidth,% a_screenheight/2
winactivate,% "ahk_id " IEarr[mod(focus+1,n)+1].HWND
winhide,% "ahk_id " IEarr[mod(focus-1,n)+1].HWND
winactivate,% "ahk_id " IEarr[focus+1].HWND
;~ v.document.getElementById("ans").select()
flag:=1
return
#IfWinActive


onexit:
~!q::
for k,v in IEarr {
	winshow,% "ahk_id " v.HWND
	v.quit()
	winclose,% "ahk_id " v.HWND
}
exitapp
return