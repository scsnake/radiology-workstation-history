class Timer {
	__New(){
		this.start()
	}
	start(){
		this.tick:=A_TickCount
	}
	stop(){
		_t:=(A_TickCount-this.tick)
		,this.tick:=A_TickCount
		return _t
	}
}