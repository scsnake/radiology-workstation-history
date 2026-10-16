SetTimerFn(FuncName, Period, param="", Priority=0, autoFree=true){
	static toBeFree:=[]
	if IsFunc(FuncName){
		fn:=Func(FuncName).Bind(param*)
	}else if IsBoundFunc(FuncName)
		fn:=FuncName
	else if (FuncName+0=FuncName && Period="Delete"){
		if (fn:=toBeFree[FuncName]){
			try{
				SetTimer,% fn, Delete
				SetTimer,, Delete
			}
			toBeFree.delete(FuncName)
			return
		}
	}
	try
		SetTimer,% fn,% Period,% Priority
	if(autoFree && Period!="Delete"){
		if(Period=0 || Period="off")
			try
				SetTimer,% fn,Delete
		else if (Period<0){
			self:=Func("SetTimerFn").Bind(t:=A_TickCount, "Delete")
			,toBeFree[t]:=fn
			try
				SetTimer,% self,% Period-1000,% Priority
		}
	}
	return fn
}



IsBoundFunc(obj) {
	static dummy := Func("Abs").Bind(1) ; dummy BoundFunc object
	return NumGet(&obj) == NumGet(&dummy)
}

;~ t(i){
	;~ ToolTip % i
;~ }
;~ #Persistent
;~ s:=SetTimerFn("t", 1000, [1])
;~ SetTimerFn("t", 300, [2])
;~ Sleep 3000
;~ SetTimerFn(s, "off")

;~ esc::ExitApp