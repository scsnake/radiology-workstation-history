#Persistent
#NoTrayIcon
#SingleInstance,off

settimer,routine,200
return

routine:
process,exist,電子簽章.exe
if !errorlevel
	exitapp
ifwinexist,ahk_class #32770,簽章完成：共產生
{
    ControlClick,Button1,ahk_class #32770,簽章完成：共產生
    winkill,ahk_class #32770,簽章完成：共產生
    finish=1
}
ifwinexist,網頁訊息 ahk_class #32770
{
    controlclick,Button1,網頁訊息 ahk_class #32770
}
return