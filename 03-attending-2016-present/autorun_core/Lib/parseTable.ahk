parseTable(data="", line_delimit="`n", tab_delimit="`t"){
	arr:=[]
	if data=
		data:=clipboard
	
	loop,parse,data,%line_delimit%,`r
	{
		if Trim(A_LoopField)=""
			continue
		tmp:=[]
		loop,parse,A_LoopField,%tab_delimit%
			tmp.push(A_LoopField)
		arr.push(tmp)
	}
	
	return arr
	
}