LineBreakConvert(str, regex="\r?\n", replace="`r`n"){
	return regexreplace(str, regex, replace)
}