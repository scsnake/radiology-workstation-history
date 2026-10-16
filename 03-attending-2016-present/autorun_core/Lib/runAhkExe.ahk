runAhkExe(exePath, AddQuote=false){
	exePath:=RegExReplace(exePath, "^""|""$", "")
	,q:=AddQuote?"""":""
	return q exePath q (A_IsCompiled?" ":" " q  SubStr(exePath,1,-3) "ahk" q " ")
}