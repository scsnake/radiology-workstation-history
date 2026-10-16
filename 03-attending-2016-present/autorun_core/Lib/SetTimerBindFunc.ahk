SetTimerBindFunc(interval, ByRef fn, ByRef param*){
	if !IsFunc(fn)
		return
	if !IsObject(fn)
		fn:=Func(fn)
	bF:=fn.bind(param*)
	settimer,%bf%,% interval
	return bF
}