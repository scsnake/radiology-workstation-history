;~ #NoTrayIcon
SetTitleMatchMode,2

errors=0
scriptstart2=0

~*lbutton::
~*enter::
if !scriptstart2
{
	scriptstart2=1
	Loop
	{
		process,exist,copyppt.exe 									; ahk <-> exe
		if !errorlevel
		{
			IfNotExist,%a_scriptdir%\copyppt.exe
			{
				send ^!+z
				exitapp
			}
			Else
			{
				run,copyppt.exe											; ahk <-> exe
				process,wait,copyppt.exe
			}
		}
		ifwinexist,ahk_class #32770 ;,,Powerpoint
		{
			winclose
			errors++
		}
;~ 		ifwinexist,,COM Error ;,Powerpoint
;~ 		{
;~ 			WinClose
;~ 			errors++
;~ 		}
		sleep 200
	}
}
return
	
	
	
	
	
	
	
	
~*^!+z::
exitapp