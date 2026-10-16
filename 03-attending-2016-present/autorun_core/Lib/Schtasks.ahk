#include <StdoutToVar_CreateProcess>

;~ clipboard:=SchTasks_Do("query",{fo: "LIST"})


; schtasks [/query] [/fo {TABLE | LIST | CSV}] [/nh] [/v] [/s computer [/u [domain\]user /p password]]

SchTasks_Query(ByRef arg=""){
	cmd:="schtasks /query /FO LIST "
	for k,v in arg
		if (k!="FO")
			cmd.="/" k " " v " "
	str:=StdoutToVar_CreateProcess(cmd)
	
	ret:=[]
	Loop,Parse,str,`n,`r
	{
		if !RegExMatch(A_LoopField, "is)([^:]+): +(.*)", match){
			if(A_Index!=1)
				ret.push(item)
			item:=[]
			if(folder)
				item["資料夾"]:=folder
			continue
		}
		if(match1="資料夾")
			folder:=match2
		item[match1]:=match2
	}
	return ret
}

; schtasks /create /sc <ScheduleType> /tn <TaskName> /tr <TaskRun> [/s <Computer> [/u [<Domain>\]<User> [/p <Password>]]] [/ru {[<Domain>\]<User> | System}] [/rp <Password>] [/mo <Modifier>] [/d <Day>[,<Day>...] | *] [/m <Month>[,<Month>...]] [/i <IdleTime>] [/st <StartTime>] [/ri <Interval>] [{/et <EndTime> | /du <Duration>} [/k]] [/sd <StartDate>] [/ed <EndDate>] [/it] [/z] [/f]
; schtasks /delete /tn {<TaskName> | *} [/f] [/s <Computer> [/u [<Domain>\]<User> [/p <Password>]]]
SchTasks_Do(action, ByRef arg=""){
	cmd:="schtasks /" action " "
	for k,v in arg
		cmd.="/" k " " v " "
	return StdoutToVar_CreateProcess(cmd)
}

;~ ExitApp