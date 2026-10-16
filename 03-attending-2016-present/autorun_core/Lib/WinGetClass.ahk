WinGetClass(ByRef title="",ByRef Text="",ByRef exclude_title="",ByRef exclude_text=""){
	if title is integer
	{
	if(text exclude_title exclude_text==""){
		WinGetClass,t,ahk_id %title%
		return t
	}
	}
	WinGetClass,var,% title,% Text,% exclude_title,% exclude_text
	return var
}