#NoTrayIcon
#persistent
#SingleInstance,force

gosub,schedule

if (t:=a_hour*60+a_min-12*60-30)<0
	settimer,schedule,% t*60000
else if t>0
	settimer,schedule,% (t-1440)*60000
else
	settimer,schedule,-86400000
return





schedule:
loop,% a_scriptdir "\.dropbox.cache\*.*",1,1
{
	FileSetAttrib,-R,% a_loopfilelongpath
	filedelete,% a_loopfilelongpath
}
fileremovedir,% a_scriptdir "\.dropbox.cache",1
loop,% a_scriptdir "\*.*",1,1
	if (instr(A_LoopFileLongPath,"conflicted copy") || instr(A_LoopFileLongPath,"衝突的複本")){
		FileSetAttrib,-R,% a_loopfilelongpath
		filedelete,% a_loopfilelongpath
	}
settimer,schedule,-86400000
return