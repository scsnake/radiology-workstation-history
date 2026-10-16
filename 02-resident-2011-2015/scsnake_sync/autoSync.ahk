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
run % "FreeFileSync.exe LastRun.ffs_batch",% a_mydocuments "\FreeFileSync"
;~ fileremovedir,% A_MyDocuments "\scsnake\Dropbox\.dropbox.cache",1
;~ loop,% A_MyDocuments "\scsnake\Dropbox\*.*",1,1
	;~ if instr(A_LoopFileLongPath,"conflicted copy") || instr(A_LoopFileLongPath,"衝突的複本")
		;~ filedelete,% a_loopfilelongpath
settimer,schedule,-86400000
return