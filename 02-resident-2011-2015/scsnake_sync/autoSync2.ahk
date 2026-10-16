#NoTrayIcon
#persistent
#SingleInstance,force

runas,Admin,impaxds,@XRAYRPT-51

run % "FreeFileSync.exe LastRun.ffs_batch",% a_mydocuments "\FreeFileSync"

if (t:=a_hour*60+a_min-12*60-30)<0
	settimer,schedule,% t*60000
else if t>0
	settimer,schedule,% (t-1440)*60000
else
	settimer,schedule,-86400000

schedule:
run % "FreeFileSync.exe LastRun.ffs_batch",% a_mydocuments "\FreeFileSync"
settimer,schedule,-86400000
return