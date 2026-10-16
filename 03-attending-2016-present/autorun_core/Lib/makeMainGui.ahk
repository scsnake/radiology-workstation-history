makeMainGUI(title, guiTag="__OnMessageGUI"){
	static mainHwnd
	gui,%guiTag%:new,+hwndmainHwnd +ToolWindow
	WinSetTitle,ahk_id %mainHwnd%,,% title
}