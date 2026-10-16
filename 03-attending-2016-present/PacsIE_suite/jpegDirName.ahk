jpegDirName(reportdir, accno, chartNo, oldAccNo="", oldChartNo="", ind="1", ext=".jpeg"){
	global ____
	if fileexist(reportdir "\" accNo " " chartNo)
		return reportdir "\" accNo " " chartNo (oldAccNo=""?""
			: ( "\" oldAccNo " " oldChartNo " " ind ext))
	else
		return reportdir "\" __CryptStr(accNo " " chartNo,____) (oldAccNo=""?""
			: "\" __CryptStr(oldAccNo " " oldChartNo,____) " " ind ext)
	
}