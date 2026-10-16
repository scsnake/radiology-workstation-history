min(params*){
	ret:=params[1]
	for k,v in params
		if (v<ret)
			ret:=v
	return ret
}

;~ MsgBox % min(1,-1)