ParseDate(ByRef inputStr,ByRef match1_var, ByRef match2_var, ByRef match3_var,  ByRef ParseRegex="(\d{4})\W?(\d{2})\W?(\d{2})"){
	if RegExMatch(inputStr, ParseRegex, m)
		match1_var:=m1,match2_var:=m2, match3_var:=m3
	else 
		return 1
}