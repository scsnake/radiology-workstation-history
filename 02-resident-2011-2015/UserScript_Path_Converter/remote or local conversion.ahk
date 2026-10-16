#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


gui,font,s10,Verdana
gui,add,text,,Remote link:
gui,add,edit,vlink w300,
gui,add,button,gconvLocal w300 y+20,Convert to local files
gui,add,button,gconvRemote w300,Convert for remote link

gui,show,,Seahorse JS Converter

return

convLocal:
gosub selectFolder
return

convRemote:
gui,submit,nohide
if((link:=trim(link))="")
	return
if !regexmatch(link,"\/$")
	link.="/"
guicontrol,,link,% link
gosub selectFolder
FileCreateDir,local
loop,% selectedFolder "\*.user.js" {
	fileread,f,% A_LoopFileLongPath
	f:=RegExReplace(f,"is)(\/\/\s==UserScript==.*)(\/\/\s==\/UserScript==).*
}
	
return

selectFolder:
selectedFolder=
FileSelectFolder,selectedFolder,% "*" a_scriptdir,,Select Folder
if (errorlevel || selectedFolder="")
	return
selectedFolder:=RegExReplace(selectedFolder,"\\$")

return

GuiClose:
esc::
exitapp
return