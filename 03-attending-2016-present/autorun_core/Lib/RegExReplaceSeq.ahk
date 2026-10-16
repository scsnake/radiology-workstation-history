RegExReplaceSeq(str, regexseq, repl){
	ret:=""
	for k,v in regexseq {
		ret:=RegExReplace(str, v, repl, var)
		if var
			return ret
	}
	return str
}
