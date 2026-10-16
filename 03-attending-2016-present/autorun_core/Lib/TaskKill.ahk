TaskKill(ProcessNameOrId, force=true, tree=false){
	force:=force?" /F":""
	,tree:=tree?" /T":""
	if (ProcessNameOrId+0==ProcessNameOrId)
		Run,% comspec " /c ""taskkill /PID " ProcessNameOrId force tree """",,Hide
	else
		Run,% comspec " /c ""taskkill /IM " match1  ((match1~="i).exe$")?"":".exe")  force tree """",,Hide
}