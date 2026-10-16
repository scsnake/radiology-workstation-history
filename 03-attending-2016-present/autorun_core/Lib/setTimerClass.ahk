class setTimerClass {
	setTimer(method, period){
		if this.__setTimerBindFn.has(method)
			fn:=this.__setTimerBindFn[method]
		else
			this.__setTimerBindFn[method]:= fn := this[method].bind(this)	
		settimer % fn, % period
	}
}

;~ class test extends setTimerClass {
	;~ __New(){
		;~ this.i:=0
		;~ this.setTimer("test",10)
	;~ }
	;~ test(){
		;~ ToolTip % ++this.i
	;~ }
;~ }


;~ new test()
;~ esc::ExitApp