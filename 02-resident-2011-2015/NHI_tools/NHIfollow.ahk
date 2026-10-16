#include <ADO_ACCESS>
#include <portallib>
#SingleInstance,force


onexit,onexit
askForPortalIdPw()


gosub search


return


importList:
listPath:=a_scriptdir "\NHIfollow.csv"
fileread,list,% listPath
NHIlist:=[]
loop,parse,list,`n`r
{
	arr:=[]
	if (trim(a_loopfield)="")
		continue
	loop,parse,a_loopfield,`,           ; chartNo, GSM
		arr.push(trim(a_loopfield))
	NHIlist.push(arr)
}


iniread,xlsURL,% a_scriptdir "\NHIfollow.ini",url,excel
return

search:
gosub importList
if !checksid(sid)
	sid:=login(loginId,loginPw)
filedelete,% sDbFile
URLDownloadToFile,% xlsURL,% sDbFile:=a_scriptdir "\NHI.xls"

;~ sDbFile:=a_desktop "\101102103orthtb(1).xls"
Loop
	sleep 200
until fileexist(sDbFile) || (ind:=a_index)>300
if (ind>300){
	msgbox Can't download file. Please check network or URL of file.
	return
}

	pcn := ComObjCreate("ADODB.Connection")
	pcn.ConnectionString := "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" . sDbFile . ";Extended Properties=Excel 8.0;"
	pcn.Open()
	If (pcn.State != 1)
	{
		ErrorLevel := "The connection to the database failed"
		;;; msgbox % errorlevel
		return
	}
	oRS:=pcn.OpenSchema(20) ;adSchemaTables=20
	if oRS.EOF
	{
		ErrorLevel := "No tables in the database"
		;;; msgbox % errorlevel
		return
	}
	
	sSheetName:=oRS.Fields("table_name").Value
	
	/*
	ColumnsSchema := pcn.OpenSchema(4, ["", "", sSheetName]) ; not work, need to study data structure of SafeArray
	*/
	
for k,v in NHIlist {
	if (instr(v.3,"Y") || instr(v.3,"B"))
		continue
	rs:=query(pcn,sSheetName,chartNo:=v.1)
	rs:=filterDate(rs,backwardDays:=2)
	if (rs.maxIndex()){
		for m,n in rs {
			if (strlen(n["核定結果"])>0) {
				portalMessage(sid,(strlen(phoneNo:=v.2)=5)?("09726" phoneNo):phoneNo,msg:=n["病歷號碼"] n["姓名"] " " n["核定日期"] n["申請品名"] "核定" n["核定結果"],msgType:=3)
				NHIlist[k,3].=n["核定結果"]
			}
		}
	}

}

	
	pcn.Close()
	
	gosub settimer
	gosub saveCurrentList
return
	
settimer:
settimer,search,% ((a_hour-12)-24)*60*60*1000
return

saveCurrentList:
filedelete,% listPath
listStr:=""
for x,y in NHIlist
	listStr.=y.1 "," y.2 "," y.3 "`r`n"
fileappend,% listStr,% listPath,utf-8
return
	
filterDate(rs,backwardDays:=2){
	arr:=[]
	for k,v in rs {
		RegExMatch(v["核定日期"],"(\d+)\.(\d+)\.(\d+)",match)
		checkDate:=(match1+1911) fill0(match2) fill0(match3)
		today:=substr(a_now,1,8)
		EnvSub,today,%checkDate%,days
		if today<=backwardDays
			arr.push(v)
	}
		
	return arr
}
	
query(pcn,table,chartNo){
	
		
	SQL:="SELECT * FROM [" table "] WHERE [病歷號碼]='" chartNo "';"
	
		
	prs := pcn.Execute(SQL)
	;~ If ErrorLevel := ADO_GetError(pcn)
	;~ {
		
		;~ ;;; msgbox % errorlevel
		;~ return
	;~ }
	If (prs.BOF) and (prs.EOF)
	{
		ErrorLevel := "The returned RecordSet contains no records"
		;;; msgbox % errorlevel
		return []
	}
	arr:=[]
	While !prs.EOF
	{
		prsFields := prs.Fields
		Names =
		arr2:=[]
		Loop, % prsFields.Count ;%
		{
			
			prsField := prsFields.Item(A_Index-1)
			Data .= prsField.Value . "|"
			Names .= prsField.Name . "|"
			arr2["" prsField.Name]:=prsField.Value
		}
		StringTrimRight, Data, Data, 1
		Data .= "`n"
		arr.push(arr2)
		prs.MoveNext()
	}
	
	StringTrimRight, Names, Names, 1
    StringTrimRight, Data, Data, 1
	return arr
}	
	
	onexit:
	;~ ~esc::
	exitapp
