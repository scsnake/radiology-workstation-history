FileEncoding,utf-8-Raw
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,Ignore
SetBatchLines, -1
coordMode,mouse,screen
CoordMode,caret,screen
DetectHiddenWindows,on
SetTitleMatchMode,2
SetControlDelay,-1
comobjerror(false)
#include <portallib>
onexit,onexit
;~ #NoTrayIcon

fileread,website_list,website_list.txt
;~ website_list = 
;~ (%
;~ http://intra.hospital-n.local/kid/default.aspx
;~ http://intra.hospital-n.local/kid/about_us/%e6%94%b6%e6%89%98%e8%be%a6%e6%b3%95.aspx
;~ )

gosub main
SetTimer,main,% 60*60*1000
return


main:
;~ sid:=askforportalidpw()
Loop,Parse,website_list,`n
{
	url:=A_LoopField
	;~ if !WinExist("ahk_id " pwb.hwnd)
		;~ pwb:=ComObjCreate("InternetExplorer.Application")
	
	file_name_md5:=md5(url)  ".html"
	
	;~ ,pwb.NAvigate(url)
	;~ ,pwb.Visible:=true
	;~ Loop
		;~ Sleep 1
	;~ until !pwb.busy
	httprequest(url, post:="", "", "charset: utf-8")
	,post:=RegExReplace(post, "<input type=""hidden"" name=""__REQUESTDIGEST"" id=""__REQUESTDIGEST"" value=""[^""]+"" />")
	if !FileExist(file_name_md5)
		FileAppend,% post,% file_name_md5,utf-8-Raw
	else {
		fileread,oldFile,% file_name_md5 
		if md5(oldFile)!=md5(post)
		{
			portalMessage(sid:=askforportalidpw(),"0972652579","Website contents changed! (" A_Index ")")
			FileDelete,% file_name_md5
			FileAppend,% post,% file_name_md5,utf-8-Raw
		}
	}
	
	
}

return

;~ esc::
OnExit:
;~ pwb.quit()
ExitApp