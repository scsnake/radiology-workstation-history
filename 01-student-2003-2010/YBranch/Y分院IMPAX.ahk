SetTitleMatchMode,2
SetMouseDelay, 0

str:="Y09999"

IfWinNotExist,IMPAX ahk_class WindowsForms10.Window.8.appa
{
	Run,"C:\Program Files\Agfa\IMPAX Client\IMPAX Client.cmd"
	WinWait,IMPAX ahk_class WindowsForms10.Window.8.appa,,10
}

ControlGetText,txt,WindowsForms10.EDIT.appa2,IMPAX ahk_class WindowsForms10.Window.8.appa
If Not ErrorLevel
{
	sleep 100
	ControlSend,WindowsForms10.EDIT.appa2,%str%,IMPAX ahk_class WindowsForms10.Window.8.appa
	ControlSend,WindowsForms10.EDIT.appa1,%str%,IMPAX ahk_class WindowsForms10.Window.8.appa
;	ControlFocus,WindowsForms10.BUTTON.appa1,IMPAX ahk_class WindowsForms10.Window.8.appa
;	ControlClick,WindowsForms10.BUTTON.appa1,IMPAX ahk_class WindowsForms10.Window.8.appa
	WinActivate,IMPAX ahk_class WindowsForms10.Window.8.appa
	WinWaitActive
	Click,557,413
	WinWait,IMPAX 6.2.1.191 Enterprise Unlimited
;	ControlFocus,WindowsForms10.EDIT.appa11
	Click,138,305
}
return

