max(params*){
	ret:=params[1]
	for k,v in params
		if (v>ret)
			ret:=v
	return ret
}

;~ MsgBox % max(1,-1)