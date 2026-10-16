PathConcat(Abs, rels*){
	ret:=Abs
	for k,v in rels
		ret:=PathCombine(ret, v)
	return ret
}

;~ MsgBox % PathConcat("a", "", "*")