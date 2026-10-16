filelog(txt, filepath=""){
	static _filepath
	
	if(filepath=""){
		filepath:=_filepath
	}else{
		_filepath:=filepath
	}
	if(_filepath="")
		_filepath:=A_ScriptDir "\fileLog.txt"
	
	FileAppend,% a_now "," A_TickCount ":" A_ScriptName ":" txt "`n",% _filepath,utf-8-Raw
}