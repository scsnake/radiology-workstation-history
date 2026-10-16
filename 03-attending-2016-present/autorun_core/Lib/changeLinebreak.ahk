changeLineBreak(ByRef str, linebreak = "`r`n", inplace = true){
	s:=RegExReplace(str, "\r?\n|\r", linebreak)
	if inplace
		str:=s
	return s
}