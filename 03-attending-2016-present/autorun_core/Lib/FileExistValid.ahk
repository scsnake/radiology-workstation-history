FileExistValid(file){
	f:=FileExist(file)
	if (!f || InStr(f,"D"))
		return false
	FileGetSize,s,% file
	return s>0
}