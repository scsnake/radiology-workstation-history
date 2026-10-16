FileEncoding,utf-8

#NoEnv
#SingleInstance,Off
SetBatchLines,-1
;~ DetectHiddenWindows, On
;~ SetTitleMatchMode,2
;~ coordmode,mouse,screen
#NoTrayIcon
#persistent
#include <portalLib>
#include <JXON>
;~ #include <class_sqlitedb>
onexit,onexit



;~ MsgBox
args:=[]
Loop %0%
	args.push(%a_index%)
	;~ args.push("-verbose")
	;~ args.push("-clipboard")
	;~ args.push("47F9A6C17E94E3461EA80C838B839108C9")
	;~ args.push("-jsonFolder ")
	;~ args.push("lungca")
	;~ args.push("""" A_ScriptDir "\mammo_reports""")
	;~ args.push("5______")
	;~ args.push("""is)Mammogra|乳房|LOCALIZATION- BREAST|Medio-lateral oblique|Mammotome|Stereotic|tomosynthesis""")
	;~ args.push("-sqlite")
	;~ args.push("""C:\Users\Administrator\PycharmProjects\portallib\RisReports.db""")
;~ MsgBox % exploreobj(args)
;~ ExitApp

if (args[0]~="i)^(-+|\/|\\)h(elp)?$") || args.maxindex()<1{
	MsgBox % "Usage: `nreportMining.exe [-verbose] [sid] chartNo1 AccNo1_1 [AccNo1_2] [AccNo1_3] ... [chartNo2 AccNo2_1 [AccNo2_2] [AccNo2_3] ... ] ... `n`nsid: session id after portal login`n-verbose: show tool tip for chart no and accession no`n-jsonFolder: specify where json saved`n-clipboard: using clipboard data as input"
	ExitApp
}


SplitPath,A_ScriptFullPath,,,,fileNameNoExt

;~ MsgBox % ExploreObj(args)
;~ MsgBox % fileNameNoExt

sid:="", info:=[], Count:=0, verbose:=false, jsonFolder:="",sqliteFile:=""
for k,v in args {
	;~ MsgBox % k ":" v
	if (v~="i)^(-+|\/|\\)verbose$"){
		verbose:=true
		continue
	}
	if (v~="i)-jsonFolder"){
		nextJsonFolder:=true
		continue
	}
	if (nextJsonFolder){
		jsonFolder:=SubStr(v,1,1)=""""?SubStr(v,2,-1):v
		nextJsonFolder:=false
		continue
	}
	if (v~="i)-sqlite"){
		nextSqlite:=true
		continue
	}
	if (nextSqlite){
		sqliteFile:=SubStr(v,1,1)=""""?SubStr(v,2,-1):v
		nextSqlite:=false
		continue
	}
	
	if  (v~="i)-clipboard"){
		arr:=ParseTable()
		for k,v in arr {
			chartNo:=AccNo:=usePattern:=""
			for m,n in v {
				if (n~="\b\w{6}\d\b"){
					chartNo:=n
					break
				}
			}
			for m,n in v {
				if (n~="\b(T|Y)\w{9}\d\b"){
					AccNo:=n
					break
				}
			}
			if (AccNo=""){
				for m,n in v {
					if (n!=chartNo){
						usePattern:=n
						break
					}
			}
			}
			
			if (chartNo!="" && (AccNo!="" || usePattern!="")){
				if !info.haskey("_" chartNo)
					info["_" chartNo]:=[], ++Count
				info["_" chartNo].push(AccNo=""?usePattern:AccNo)
				
			}
		}
	}

	if (v~="\w{32,}"){
		sid:=v
		continue
	}
	if (v~="\d{1,6}")
		while StrLen(v)<6
			v:="0" v

	if (v~="^\w{6}\d$")	{
		chartNo:=v
		if  !info.haskey("_" chartNo)
			info["_" chartNo]:=[],++Count
		
	}else if (v~="^(T|Y)\w{9}\d$"){
		info["_" chartNo].push(v)
		
	}else{
		info["_" chartNo].push(v)
	}
}

if (sid="") && ((sid:=askForPortalIdPw())=""){
	MsgBox % "Can't login portal!"
	ExitApp
}
	
;~ MsgBox % exploreobj(info)
;~ MsgBox % Count
;~ ExitApp
if (Count=1){
	AccNo:=info["_" chartNo]
	goto main
}else{
	for k,v in info
		dispatch(SubStr(k,2), v)
}

ExitApp
return 


dispatch(chartNo, AccNo){
	global sid, jsonFolder, sqliteFile
	
	
	
	args:="""" RegExReplace(A_ScriptFullPath, "i).ahk$", ".exe") """ " sid " " (jsonFolder?"-jsonFolder """ jsonFolder """ ":"") (sqliteFile?"-sqlite """ sqliteFile """ ":"")
	,args.=chartNo " "
	
	for k,v in AccNo
		if(v~="^(T|Y)\w{9}\d$")
			args.=v " "
		else
			args.="""" v """ "
	;~ MsgBox % args
	run, % args,,UseErrorLevel
	;~ if ErrorLevel
		;~ MsgBox % ErrorLevel
	Sleep 1000
}

main:
PacsHx:="", result:=[]
for k,v in AccNo {
	SetTimer,OnExit,-120000
	if verbose
		ToolTip % "Searching: " chartNo ", " v " ..."
	if (v~="i)[TY]\w{9}\d")
		result[v]:=getReportByPortal(sid, chartNo, v, PacsHx)
	else{
		res:=getReportByPortal(sid, chartNo, "", PacsHx, personId, RegExReplace(v, "^""|""$", ""))
		for AccNo_, result_ in res
			result[AccNo_]:=result_
	}
}
if (sqliteFile)
	gosub trySqlite

dir:=FileExist(dirPath:=jsonFolder?jsonFolder:A_ScriptDir "\reports")
if !InStr(dir, "D")
	FileCreateDir,% dirPath

if FileExist(jsonPath:=dirPath "\" chartNo ".json"){
	fileread,oldJson,% jsonPath
	try {
		oldResult:=jxon_load(oldJson)
		for k, v in result
			oldResult[k]:=v
		result:=oldResult
	}
	FileDelete,% jsonPath
}	
FileAppend,% str:=JXON_dump(result),% jsonPath,utf-8

;~ MsgBox % exploreobj(jxon_load(str))
ExitApp
return

trySqlite:
	db:=new SqliteDB
	if !db.opendb(sqliteFile){
		sqliteFail:=true
		return
		
	}
	DB.Exec("BEGIN TRANSACTION;")
	
	sql:=""
	for k,v in result {
		sql.="INSERT INTO CXR ("
		,val:="("
		for m,n in v {
			sql.=m ","
			;~ db.EscapeStr(n)
			val.="'" n "',"
		}
		sql.="ChartNo) VALUES " val "'" chartNo "');"
		
	}
	db.exec(sql)
	DB.Exec("COMMIT TRANSACTION;")
	
	DB.CloseDB()
	;~ sqliteFail:=false
	ExitApp

return


OnExit:
ExitApp