; <COMPILER: v1.1.09.02>
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#persistent
comobjerror(false)
CoordMode,mouse,screen
gosub loadKeyWords
settimer,routine,-5000

return

loadKeyWords:
fileread,keywords,Blocked Keywords.txt

return

routine:
url:=GetActiveBrowserURL()
regexmatch(url,"\/\/([^\/]+)",match)
domain:=match1
loop,parse,keywords,`n,`r 
{
	if (trim(a_loopfield)!="") && instr(domain,trim(a_loopfield)) {
		send ^w
		MsgBox, 262192, WARNING!, YOU SHOULD CONCENTRATE!!!, 5
		break
	}
}
settimer,routine,-5000
return