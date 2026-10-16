﻿#singleinstance,off
#NoTrayIcon
#include <portalLib>



Loop, %0%  ; For each parameter:
{
    param := %A_Index%  ; Fetch the contents of the variable whose name is contained in A_Index.
    break
}


;~ if (param="")
	;~ param=TACEγHCCγ2013/04/12γ12:00γ2013/04/12γ13:00γ劉高郎γ卓怡萱,陳醫師γHCCγHCCγ200γγγγγright femoral artery,γRC1 5Fr, Progreat 2.7Fr/110cmγγIA: Doxorubicin 40mg, Lipiodol 10ml, Gelfoam fine particlesγUltravistγ80γγTACE is done via RHA for righ hepatic hypervascular tumors.γ黃柔瑄γ2013/04/12γ15:23γchartNo

processList:=getAllProcess()
i:=0
loop,parse,processList,|
	if(a_loopfield=a_scriptName)
		if((++i)>1){
			random,rnd,10,20
			settimer,restart,% (-1000)*rnd
			return
		}

askForPortalIdPw()

if (trim(param)="")
	exitapp

item:=array("procedure","indication","上台日期","上台時間","下台日期","下台時間","範例醫師","範例醫師","pre_diagnosis","post_diagnosis","local anesthesia dose","other anesthesia","specimen number","specimen size","specimen location","route","catheter","other equipment","medication","contrast media","contrast media dose","complication","findings","record by","record date","record time")

value:=[]
loop,parse,param,γ
{
	value.push(trim(regexreplace(regexreplace(a_loopfield,"'","''"),"\n","`r`n")))
}

chartNo:=value[value.maxindex()]

if item.maxIndex()!=value.maxIndex()-1 {
	msgbox % "Error! Please contact scsnake for script REVISION!"
	exitapp
}

pair:=[]

itemStr:=""
for k,v in item
	itemStr.="``" v "``,"
	,pair["" v]:=value[k]
itemStr.="``病歷號``"

valueStr:=""
for k,v in value
	valueStr.="'" v "',"
valueStr:=RegExReplace(valueStr,",$")


dbName:="angioroom.mdb"
tableName:="BODY_ANGIO"

ptInfo:=patientBasicInfo(chartNo,sid)


Con := ComObjCreate( "ADODB.Connection" )
dbcon:="Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" a_scriptdir "\" dbName
Con.ConnectionString:=dbcon
Con.Open()
sql:="INSERT INTO [" tableName "] (" itemStr ",``姓名``,``生日``,``性別``,``年齡``,``病人單位``,``身份證字號``) VALUES (" valueStr ",'" ptInfo.name "','" ptInfo.birthYear "/" ptInfo.birthMonth "/" ptInfo.birthDay "','" ptInfo.gender "','" ptInfo.age "','" ptInfo.ward "','" ptInfo.personId "');"
Con.Execute(sql)
;~ clipboard:=sql
;~ msgbox % sql



Con.Close()
msgbox,4,,% "Patient " chartNo " saved successfully!`n`n是否貼上到RIS?"
IfMsgBox,Yes 
{
	toBeCopied:="Procedure name: " pair["procedure"] "`nIndication: " pair["indication"] "`nStart date and time: " pair["上台日期"] " " pair["上台時間"] "`nEnd date and time: " pair["下台日期"] " " pair["下台時間"] "`nOperator: " pair["範例醫師"] "`nAssistant: " pair["範例醫師"] "`nPre-procedure diagnosis: " pair["pre_diagnosis"] "`nPost-procedure diagnosis: " pair["post_diagnosis"] "`nAnesthesia:" ((str:=pair["local anesthesia dose"])?" Lidocaine HCL (Xylocaine 2%, 20 mg/mL): " str " mg local injection":"") (str:=pair["other anesthesia"]?" Others: " str:"") "`nSpecimens: " (trim(pair["specimen number"] pair["specimen size"] pair["specimen location"])?("number " pair["specimen number"] "; size " pair["specimen size"] "; location " pair["specimen location"]):"nil") "`nRoute: " pair["route"] "`nCatheters/needles: " pair["catheter"] "`nOther equipment used: " (str:=trim(pair["other equipment"])?str:"nil") "`nMedication: " pair["medication"] "`nContrast medium: " ((pair["contrast media"]="nil"||!pair["contrast media dose"])?"nil":(pair["contrast media"]) " " pair["contrast media dose"] "ml") "`nComplication: " (str:=pair["complication"]?str:"nil") "`nPost procedures image findings: " pair["findings"] "`nRecorded by: " pair["record by"] "`t" pair["record date"] " " pair["record time"]
	stringreplace,toBeCopied,toBeCopied,`n,`r`n,A
	clipboard:=toBeCopied
}
	
exitapp
return

getAllProcess(){
	d := "|"  ; string separator
	s := 4096  ; size of buffers and arrays (4 KB)

	Process, Exist  ; sets ErrorLevel to the PID of this running script
	; Get the handle of this script with PROCESS_QUERY_INFORMATION (0x0400)
	h := DllCall("OpenProcess", "UInt", 0x0400, "Int", false, "UInt", ErrorLevel, "Ptr")
	; Open an adjustable access token with this process (TOKEN_ADJUST_PRIVILEGES = 32)
	DllCall("Advapi32.dll\OpenProcessToken", "Ptr", h, "UInt", 32, "PtrP", t)
	VarSetCapacity(ti, 16, 0)  ; structure of privileges
	NumPut(1, ti, 0, "UInt")  ; one entry in the privileges array...
	; Retrieves the locally unique identifier of the debug privilege:
	DllCall("Advapi32.dll\LookupPrivilegeValue", "Ptr", 0, "Str", "SeDebugPrivilege", "Int64P", luid)
	NumPut(luid, ti, 4, "Int64")
	NumPut(2, ti, 12, "UInt")  ; enable this privilege: SE_PRIVILEGE_ENABLED = 2
	; Update the privileges of this process with the new access token:
	r := DllCall("Advapi32.dll\AdjustTokenPrivileges", "Ptr", t, "Int", false, "Ptr", &ti, "UInt", 0, "Ptr", 0, "Ptr", 0)
	DllCall("CloseHandle", "Ptr", t)  ; close this access token handle to save memory
	DllCall("CloseHandle", "Ptr", h)  ; close this process handle to save memory

	hModule := DllCall("LoadLibrary", "Str", "Psapi.dll")  ; increase performance by preloading the library
	s := VarSetCapacity(a, s)  ; an array that receives the list of process identifiers:
	c := 0  ; counter for process idendifiers
	DllCall("Psapi.dll\EnumProcesses", "Ptr", &a, "UInt", s, "UIntP", r)
	Loop, % r // 4  ; parse array for identifiers as DWORDs (32 bits):
	{
	   id := NumGet(a, A_Index * 4, "UInt")
	   ; Open process with: PROCESS_VM_READ (0x0010) | PROCESS_QUERY_INFORMATION (0x0400)
	   h := DllCall("OpenProcess", "UInt", 0x0010 | 0x0400, "Int", false, "UInt", id, "Ptr")
	   if !h
		  continue
	   VarSetCapacity(n, s, 0)  ; a buffer that receives the base name of the module:
	   e := DllCall("Psapi.dll\GetModuleBaseName", "Ptr", h, "Ptr", 0, "Str", n, "UInt", A_IsUnicode ? s//2 : s)
	   if !e    ; fall-back method for 64-bit processes when in 32-bit mode:
		  if e := DllCall("Psapi.dll\GetProcessImageFileName", "Ptr", h, "Str", n, "UInt", A_IsUnicode ? s//2 : s)
			 SplitPath n, n
	   DllCall("CloseHandle", "Ptr", h)  ; close process handle to save memory
	   if (n && e)  ; if image is not null add to list:
		  l .= n . d, c++
	}
	DllCall("FreeLibrary", "Ptr", hModule)  ; unload the library to free memory
	;Sort, l, C  ; uncomment this line to sort the list alphabetically
	return l
}

restart:
run % a_scriptname " """ param """"
exitapp
return