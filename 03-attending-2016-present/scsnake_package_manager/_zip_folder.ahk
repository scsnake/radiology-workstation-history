SetBatchLines,-1
#SingleInstance,force

if %0%
	goto param
else
	goto main

return 



main:
Loop,% A_ScriptDir "\*",1,0
{
	if !InStr(FileExist(A_LoopFileLongPath), "D")
		continue
	
	SplitPath,A_LoopFileLongPath,n
	if (n="_zip_folder")
		continue
	
	run % "7z.exe a ""_zip_folder\" n ".zip"" """ n """"
}
ExitApp


param:
Loop,%0%
{
	p:=%A_Index%
	
	if !InStr(FileExist(p), "D")
		continue
	
	SplitPath,p,n
	if (n="_zip_folder")
		continue
	
	run % "7z.exe a ""_zip_folder\" n ".zip"" """ n """"
}


ExitApp