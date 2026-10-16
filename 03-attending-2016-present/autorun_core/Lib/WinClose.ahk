WinClose(ByRef title="",ByRef Text="",ByRef exclude_title="",ByRef exclude_text=""){
	if title is integer
	{
	if (text exclude_title exclude_text == ""){
		WinClose,ahk_id %title%
	}
		
	}
	WinClose,% title,% Text,% exclude_title,% exclude_text
	return ErrorLevel
}