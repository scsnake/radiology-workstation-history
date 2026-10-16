; <COMPILER: v1.1.09.02>
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#persistent
comobjerror(false)
CoordMode,mouse,screen
settimer,routine,-5000
return
routine:
url:=GetActiveBrowserURL()
regexmatch(url,"\/\/([^\/]+)",match)
if instr(match,"facebook") {
send ^w
MsgBox, 262192, Concentrate!, No Facebook!!, 3
}
settimer,routine,-5000
return