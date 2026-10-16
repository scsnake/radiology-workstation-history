﻿#include <portallib>
#include <RisImpax>
#include <ParseTable>
#include <JXON>
#NoTrayIcon
SetBatchLines,-1
#SingleInstance,Off
SplitPath,A_ScriptFullPath,,,,fileName
OnExit,OnExit

if %0%
	goto main2

main:
sid:=askForPortalIdPw()
FileDelete,tempResult.txt
FileCreateDir,% A_ScriptDir "\PacsHx"
;~ fileread,tempResult,tempResult1.txt
clip:=new DataGridTable(ParseTable())
;~ ,orderPricePercentage:=[]

;~ a=AccNo,chartNo,ExamName,ExamDate
;~ b=照會單號,病歷號,檢查名稱,檢查登錄時間

;~ gosub loadOrdercodes


for k,row in clip {
	ToolTip % k
		

	if (k=1) {
		s:="1`t"
		for _,v in row
			s.=v "`t"
		s.="part`t"
		,s.="multiple same day CT/MR`t"
		,s.="price(NIH)`t"
		,s.="price(self-paid)`t"
		,s.="percentage`t"
		,s.="order code`t"
		,s.="is self-paid`t"
		,s.="same day CT`t"
		,s.="same day MR`t"
		,s.="same day exams`t"
		,s.="same week exams`r`n"
		FileAppend,% s, tempResult.txt, utf-8
		continue
	}
	
	;~ part:=0
	;~ s:=""
	;~ for _,v in row 
		;~ s.= v "`t"
	;~ Loop,read,tempResult1.txt
	;~ {
		;~ if InStr(A_LoopReadLine, s){
			;~ rw:=[]
			;~ Loop,parse,A_LoopReadLine,`t
				;~ rw.push(Trim(A_LoopField))
			;~ if (rw[28]){
				;~ part:=rw[28]
				;~ break
			;~ }
				
		;~ }
	;~ }

	AccNo:=row[clip.colNos["照會單號"]]
	,ChartNo:=row[clip.colNos["病歷號"]]
	,ExamName:=row[clip.colNos["檢查名稱"]]
	,ExamDate:=SubStr(RegExReplace(row[clip.colNos["檢查日"]], "\D", ""),1,8)
	;~ ,err:=""
	;~ if orderPricePercentage.hasKey(ExamName){
		;~ price:=orderPricePercentage[ExamName].price
		;~ ,percentage:=orderPricePercentage[ExamName].percentage
		;~ ,orderCode:=orderPricePercentage[ExamName].orderCode
	;~ }else{
	,hospitalCode:=getHospitalCode(ExamName, AccNo)
		,match_oc:=getOrderCode(ExamName, AccNo)
	;~ if (match_oc){
		,orderCode:=match_oc[1]
		,price1:=match_oc[3]
		,price2:=match_oc[4]
		,percentage:=match_oc[5]
	;~ }else{
		;~ for _, v in result:=queryOrderPriceIE(SubStr(ExamName,1,30), sid, pwb, "name") {
			;~ orderCode:=v["醫令代碼"]
			;~ if (orderCode && !v["停用日期"]){
				;~ price1:=v["健保價"]
				;~ ,price2:=v["自費價"]
				;~ ,percentage:=queryPerformancePercentage(orderCode, sid)
				;~ if(percentage.maxIndex()){
					;~ percentage:=percentage[1]["是否提成"]="要提成"?percentage[1]["提成比率"]:0
					;~ ,orderCodes[orderCode]:=[ExamName, price1, price2, percentage]
					;~ FileAppend,% orderCode "`t" ExamName "`t" price1 "`t" price2 "`t" percentage "`r`n" ,orderCodes.txt,utf-8
					;~ break
				;~ }
				
			;~ }
		;~ }
	
		
	;~ }
		
		;~ ,orderPricePercentage[ExamName]:={price: price, percentage: percentage, orderCode: orderCode}
	;~ }
	
	;~ price:=price[1]["健保價"]
	;~ ,percentage:=percentage[1]["是否提成"]="要提成"?percentage[1]["提成比率"]:0
	
	;~ if RegExMatch(ExamName,"i)^CT|MRI", Modality) && part=0 {
		;~ goto test
		data:={i: k
			,sid: sid
			,AccNo: AccNo
			,ChartNo: ChartNo
			,ExamName: ExamName
			,ExamDate: ExamDate
			,orderCode: orderCode
			,row: row
			,price1: price1
			,price2: price2
			,hospitalCode: hospitalCode
			,percentage: percentage}
		
		run % fileName ".exe """ RegExReplace(JXON_dump(data), """", """""") """"
		Sleep 50
		
		Loop {
			pind:=0
			for _,v in ProcessList() {
				if(v.NAme="performance.exe")
					pind++
			}
			if (pind<50)
				break
			else
				Sleep 1000
		}
	;~ }else{
		;~ part:=part?part:1
		;~ str:=k "`t"
		;~ for _,v in row
			;~ str.=v "`t"
		;~ str.= part "`t"
		;~ ,str.=price1 "`t"
		;~ ,str.=price2 "`t"
		;~ ,str.=percentage "`t"
		;~ ,str.=orderCode  "`r`n"


		FileAppend,% str,tempResult.txt,utf-8
	;~ }
	
	;~ clipboard:=exploreobj(row)
	
}
pwb.quit()
ExitApp
return

loadOrdercodes(hospitalCode="T0"){
	fileread,orderCodesTxt,OrderCodes_%hospitalCode%.txt
	; orderCodes[ orderCode ] := [[ ExamName1, 健保價, 自費價, 提成 ], [ ExamName2, 健保價, 自費價, 提成 ], ...]
	orderCodes:=[]
	Loop,parse,orderCodesTxt,`n,`r
	{
		row:=[]
		Loop,parse,A_LoopField,`t
			if (A_Index=1)
				code:=Trim(A_LoopField)
				,row.push(code)
			else
				row.push(Trim(A_LoopField))
		
		if orderCodes.hasKey(code)
			orderCodes[code].push(row)
		else
			orderCodes[code]:=[row]
	}
	return orderCodes
}



searchRisOrdercodes:

fileread,orders,orderCode.txt
orderCodes:=[], s:=""
Loop,parse,orders,`n,`r
	if RegExMatch(A_LoopField, "is)([^\t]+)\t([^\t]+)$", m) && !orderCodes.hasKey(m2) {
		price:=queryOrderPriceIE(orderCode:=m1, sid, pwb)
		,percentage:=queryPerformancePercentage(orderCode, sid)
		FileAppend,% A_LoopField "`t" price[1]["健保價"] "`t" price[1]["自費價"] "`t" (percentage[1]["是否提成"]="要提成"?percentage[1]["提成比率"]:0)  "`r`n"
			,tempOrderCodes.txt,utf-8
	}
	
return

pad0(k, len=8){
	while StrLen(k)<len
		k:="0" k
	return k
}

getHospitalCode(ExamName, AccNo){
	; known limitation: exam in another branch of N hospital
	RegExMatch(ExamName, "\bCT\b|\bMRI?\b|\bmammo|乳房", Modality)
	if RegExMatch(AccNo, "i)T\d", hc)
		return hc="T2"&&Modality?"T0":hc
	else if (AccNo~="i)^Y")
		return "Y0"
	else if (AccNo~="i)^TH")
		return "T0"
	else if (AccNo~="i)^HH")
		return "T4"
	else 
		return "T0"
	
}

getOrderCode(ExamName, AccNo){
	global sid, pwb
	static OrderCodes_T0, OrderCodes_T2, OrderCodes_T3, OrderCodes_T4, OrderCodes_T5, OrderCodes_Y0, notFoundExamName

	hospitalCode:=getHospitalCode(ExamName, AccNo)
	
	
	if !IsObject(orderCodes_%hospitalCode%)
		orderCodes_%hospitalCode%:=loadOrdercodes(hospitalCode)
	
	if !IsObject(notFoundExamName){
		fileread,nfen,notFoundExamName.txt
		notFoundExamName:=nfen=""?[]:ParseTable(nfen)
	}
	
	for _,v in notFoundExamName
		if (v[1]=ExamName && v[2] = hospitalCode){
			notFoundExamName.push([ExamName, hospitalCode, AccNo])
			FileAppend,% ExamName "`t" hospitalCode "`t" AccNo "`r`n",% notFoundExamName.txt,utf-8
			return
		}
	
	
	for k,x in orderCodes_%hospitalCode%
		for _,v in x
			if (v.2 = ExamName && v.5)
				return v
	
	len :=StrLen(ExamName)
	Loop % len-20 
	{
		s:=SubStr(ExamName, 1, len-A_Index)
		for k,x in orderCodes_%hospitalCode%
			for _,v in x
				if (v.2 = s && v.5)
					return v
	}
	
	en:=RegExReplace(ExamName, " ", "")
	,len:=StrLen(en)
	for k,x in orderCodes_%hospitalCode%
		for _,v in x
			if (RegExReplace(v.2, " ", "") = en && v.5)
				return v
	
	en:=RegExReplace(ExamName, "[\W]", "")
	,len:=StrLen(en)
	for k,x in orderCodes_%hospitalCode%
		for _,v in x
			if (RegExReplace(v.2, "[\W]", "") = en && v.5)
				return v
		
	en:=RegExReplace(ExamName, "[^A-Z]", "")
	,len:=StrLen(en)
	for k,x in orderCodes_%hospitalCode%
		for _,v in x
			if (RegExReplace(v.2, "[^A-Z]", "") = en && v.5)
				return v
	Loop % len-15 
	{
		s:=SubStr(en, 1, len-A_Index)
		for k,v in orderCodes_%hospitalCode%
			for _,v in x
				if (RegExReplace(v.2, "[\W]", "")=s) && v.5
					return v
	}
	
	
	;~ found:=false
	for _, v in result:=queryOrderPriceIE(SubStr(ExamName,1,30), sid, pwb, "name", hospitalCode) {
		orderCode:=v["醫令代碼"]
		if (orderCode && !v["停用日期"]){
			price1:=v["健保價"]
			,price2:=v["自費價"]
			,percentage:=queryPerformancePercentage(orderCode, sid, hospitalCode)
			if(percentage.maxIndex()){
				percentage:=percentage[1]["是否提成"]="要提成"?percentage[1]["提成比率"]:0
				,orderCodes_%hospitalCode%.push(row:=[orderCode, ExamName, price1, price2, percentage])
				FileAppend,% orderCode "`t" ExamName "`t" price1 "`t" price2 "`t" percentage "`r`n" ,orderCodes_%hospitalCode%.txt,utf-8
				return row
			}
			
		}
	}
	
	notFoundExamName.push([ExamName, hospitalCode, AccNo])
	FileAppend,% ExamName "`t" hospitalCode "`t" AccNo "`r`n",% notFoundExamName.txt,utf-8
}

is_SameWeek(date1, date2){
	date1-=date2,Days
	return Abs(date1)<=7
		
}

main2:
s=%1%
data:=jxon_load(s)

for k,v in data
	%k%:=v
test:
chartNo:=pad0(chartNo, 7)
,orderCode:=pad0(orderCode, 8)
,part:=0, part2:=0
,sameDayCT:=sameDayMR:=0, sameDayExams:=sameWeekExams:="", selfPaid:=is_selfPaid(sid, AccNo)
,RegExMatch(ExamName,"i)(\bCT\b|\bMRI?\b)", Modality)
	;~ if RegExMatch(ExamName,"i)^CT|MRI", Modality){
		if FileExist(json_path:=A_ScriptDir "\PacsHx\" chartNo ".json"){
			fileread,PacsHx,% json_path
			PacsHx:=jxon_load(PacsHx)
			, patientId:=PacsHx[1].personId
		}else
			getPacsHxByPortal(sid, chartNo, PacsHx, patientId:="")
		if FileExist(json_path2:=A_ScriptDir "\PacsHx\" chartNo "_2.json"){
			fileread,PacsHx2,% json_path2
			PacsHx2:=jxon_load(PacsHx2)
		}else
			PacsHx2:=getPacsHx(sid, patientId?patientId:chartNo, hospitalCode)
		
		sameDayCTMR:=[]
		for k,v in  PacsHx2 
			if (v.ExamDate = ExamDate && v.ExamName~="i)\bCT\b|\bMRI?\b")
				sameDayCTMR.push(v)
		
		;~ if (ret.maxIndex()=1){
			;~ for k,v in PacsHx 
				;~ if  (v.ExamDate = ExamDate) && (v.ExamName~="i)^" Modality)
					;~ part++
			
		;~ }else{
			
			;~ for k,v in PacsHx
				;~ if  (v.AccNo = AccNo){
					;~ reportKey:=v.ReportKey
					;~ break
				;~ }
			for k,v in PacsHx {
				if(v.ExamDate=ExamDate){
					if (v.ExamName~="i)\bCT\b") {
						sameDayCT++
						if (Modality="CT")
							part++
					}else if (v.ExamName~="i)\bMRI?\b") {
						sameDayMR++
						if InStr(Modality,"MR")
							part++
					}else if(v.AccNo != AccNo)
						sameDayExams.=v.ExamName "|"
				}else if(is_SameWeek(v.ExamDate, ExamDate))
					sameWeekExams.=v.ExamName "|"
				else if (v.ExamDate<ExamDate)
					break
			}
				
			
		;~ }
		
	;~ }else
		;~ part:=1

part:=part?part:1

str:=i "`t"
for k,v in row
	str.=v "`t"
str.=part "`t"
,str.=(sameDayCTMR.maxIndex()?sameDayCTMR.maxIndex()-1:0) "`t"
,str.=price1 "`t"
,str.=price2 "`t"
,str.=percentage "`t"
,str.=orderCode  "`t"
,str.=selfPaid  "`t"
,str.=sameDayCT  "`t"
,str.=sameDayMR  "`t"
,str.=sameDayExams "`t"
,str.=sameWeekExams "`r`n"

if !FileExist(json_path)
	FileAppend,% JXON_dump(PacsHx), % json_path,utf-8
if !FileExist(json_path2)
	FileAppend,% JXON_dump(PacsHx2), % json_path2,utf-8



FileAppend,% str,tempResult.txt,utf-8
pind:=0
for k,v in ProcessList() {
	if(v.NAme="performance.exe")
		pind++
}
if pind=1
	MsgBox,,,Finish!,5
ExitApp
return

OnExit:
pwb.quit()
ExitApp