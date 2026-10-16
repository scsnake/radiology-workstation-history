convertUnit(value,frameToDeci)
{
	if !value="" || !instr(value,".")
		return value
	
	value:=RegExReplace(value,"\.+",".")
	value:=RegExReplace(value,"^0+([^0]\d*\.)","$1")
	value:=RegExReplace(value,"^0+\.","0.")
	int:=floor(value)
	rem:=value-int
	if frameToDeci
	{
		while rem*100>30
			rem-=0.3,int++
		return int + round(rem/30*10000)/100
	}
	else
		return int "." round(rem*30)
}

v:="017.23"
msgbox % v*2
exitapp