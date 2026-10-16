DateDiff(date, refDate, AbsValue=true){
	date-=refDate, Days
	return AbsValue?abs(date):date
}