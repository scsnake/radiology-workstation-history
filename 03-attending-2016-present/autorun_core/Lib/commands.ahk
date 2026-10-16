commands(args*){
	com:=""
	for k, v in args {
		if IsObject(v)
			com.=commands(v)
		else{
			v:=RegExReplace(v, """", "\""""")
			if InStr(v, " ")
				v:= """" v """"
			com.=v " "
		}
	}
	return com 
}
