#SingleInstance ignore
#NoTrayIcon
#include COM.ahk   ; library from http://www.autohotkey.com/forum/viewtopic.php?t=22923
DetectHiddenText,on
DetectHiddenWindows,on
settitlematchmode,2
COM_CoInitialize()
scriptstart=0
;~ pathindex=1
;~ menu,tray,icon,ppt2.ico
;~ OnMessage(0x80048240,"msgmonitor")

;~ msgmonitor(wparam,iparam,msg,hwnd)
;~ {
;~ 	msgwin := hwnd
;~ 	winclose,ahk_id %hwnd%
;~ 	Return
;~ }

gui,add,text,,filestobecopy:


~*lbutton::
~*enter::
if !scriptstart
{
	scriptstart=1
	Loop
	{
		process,exist,__.exe 				
		if !errorlevel
		{
			IfNotExist,%a_scriptdir%\__.exe
			{
				send ^!+z
				exitapp
			}
			Else
			{
				run,__.exe											
				process,wait,__.exe
				send {lbutton}
			}
		}
		obj=
		oppt_2007=
		oppt_2003=
		pptfullname=
		pptpath=
		diskspace=
		SetWorkingDir,%a_mydocuments%
		ifnotexist,test\
		{
			FileCreateDir,test
		}
	;~ 	ifnotexist,test\copylog
	;~ 	{
	;~ 		fileappend,,test\copylog
	;~ 	}
		ifwinactive,Microsoft PowerPoint
		{
			obj := COM_GetActiveObject("PowerPoint.Application")
;~ 			version := com_invoke(obj,"Version")
;~ 			msgbox % version
;~ 			if version=12.0
;~ 			{
			oppt := com_invoke(obj,"ActivePresentation")
;~ 			}
;~ 			else
;~ 			{
;~ 				oppt := com_invoke(obj,"Presentations")
;~ 			}
			pptname := com_invoke(oppt,"Name")
			pptpath := com_invoke(oppt,"FullName")
			SetWorkingDir,%a_mydocuments%\test
			ifnotexist,*%pptname%
			{
				ifwinnotexist,,%pptpath%
				{
					gui,add,text,,%pptpath%
					oSlides := com_invoke(oppt,"Slides")
					loop, % com_invoke(oSlides,"Count")
					{
						oSlide := com_invoke(oppt,"Slides",a_index)
						oLinks := com_invoke(oSlide,"Hyperlinks")
						loop, % com_invoke(oLinks,"Count")
						{
							oLink := com_invoke(oSlide,"Hyperlinks",a_index)
							linkpath := com_invoke(oLink,"Address")
							gui,add,text,,%linkpath%
						}
					}
;~ 					pathindex++
;~ 					gui,show
;~ 					filegetsize,pptsize,%pptpath%,m
;~ 					DriveSpaceFree,diskspace,%a_workingdir%
;~ 					if diskspace>%pptsize%
;~ 					{
;~ 						FileCopy,%pptpath%,%a_now%%pptfullname%
;~ 						FileSetAttrib,+H,*%pptfullname%
;~ 					}
				}
			}
		}
		sleep 1000
	}
}
Return

~*^!+z::
exitapp





