RemoveBOM(ByRef str){
	StringReplace,str,str,ï»¿,,All
	return str
}