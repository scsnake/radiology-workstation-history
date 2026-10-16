StringLowerFirst(str){
	f:=SubStr(str,1,1)
	StringLower,f,f
	return f SubStr(str,2)
}