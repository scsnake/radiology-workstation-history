applyIcon(){
	SplitPath,A_ScriptName,,,,n
	try
		menu, tray, icon,% a_scriptdir "\" n ".ico",1,0
}