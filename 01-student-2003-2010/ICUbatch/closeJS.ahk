#NoTrayIcon 

SetTitleMatchMode,2

loop
{
	ifwinexist,ICU 批次開單
	{
		if winexist("ahk_class #32770")
		{
			wingettitle,x
			if x contains ICU,工作管理員
			{
				continue
			}
			ControlClick,% "Button1"
			winclose
		}
		if winexist("Internet Explorer","索引標籤")
		{
			ControlClick,% "Button4"
		}
	}
	else
	{
		exitapp
	}
;	sleep 300
}

~!q::
winclose,ICU 批次開單
return
