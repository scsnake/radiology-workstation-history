RandomChar(len){
	static choices:="0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_"
	ret:="", ch:=StrLen(choices)
	Loop % len {
		Random,r,1,% ch
		ret.=SubStr(choices,r,1)
	}
	return ret
}

;~ MsgBox % RandomChar(512)