﻿#include <portallib>
#include <RisImpax>
#include <ParseTable>
#include <JXON>
#NoTrayIcon
SetBatchLines,-1
#SingleInstance,Off
SplitPath,A_ScriptFullPath,,,,fileName
#MaxMem 4095
OnExit,OnExit
;~ estimatedPerformanceTable()
;~ Loop {
	;~ if (clipboard!=" ")
		;~ break
	;~ else
		;~ Sleep 1000
;~ }
;~ renewOrderCodes("Y0")
;~ uniqueOrderCodes()
estimatedPerformanceTable()
;~ extendOrderCodes()
ExitApp
return

extendOrderCodes(){
	
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

estimatedPerformanceTable(){
	clip:=new DataGridTable(ParseTable())
	
	,dataE:=[]
	,dataI:=[]
	,dataO:=[]
	
	for k,row in clip {
		if k=1
			continue
		
		AccNo:=row[clip.colNos["照會單號"]]
		,ExamName:=row[clip.colNos["檢查名稱"]]
		if getHospitalCode(ExamName, AccNo)!="T0"
			continue
		
		IOE:=SubStr(row[clip.colNos["診別"]],1,1)
		,orderCode:=row[clip.colNos["order code"]]
		,data:=data%IOE%
		,is_selfpaid:=row[clip.colNos["is self-paid"]]
		if(!data.haskey("_" orderCode))
			
			data["_" orderCode]:=["T0"
			, SubStr(row[clip.colNos["診別"]],3,2)
			, orderCode
			, row[clip.colNos["檢查名稱"]]
			, "15100"
			, price:=is_selfpaid?row[clip.colNos["price(self-paid)"]]:row[clip.colNos["price(NIH)"]]
			, part:=is_selfpaid?1:1/row[clip.colNos["part"]]
			, p:=InStr(percentage:=row[clip.colNos["percentage"]], "%")?SubStr(percentage,1,-1)/100:percentage
			, price*part*p]
		else
			price:=is_selfpaid?row[clip.colNos["price(self-paid)"]]:row[clip.colNos["price(NIH)"]]
			, part:=is_selfpaid?1:1/row[clip.colNos["part"]]
			, p:=InStr(percentage:=row[clip.colNos["percentage"]], "%")?SubStr(percentage,1,-1)/100:percentage
			, data["_" orderCode][7]+=part
			, data["_" orderCode][9]+= price*part*p
		
	}
	ret:="院區`t門住急`t醫令碼`t醫令名稱`t成本中心`t單價`t數量`t提成`t點數`r`n"
	for k,v in ["E","I","O"]
		for x,y in data%v%
		{
			s:=""
			for a,b in y
				s.=b "`t"
			ret.=SubStr(s,1,-1) "`r`n"
		}
			
	return clipboard:=ret
	
}

uniqueOrderCodes(){
	str:=""
	Loop,read,orderCodes.txt
		if !InStr(str, A_LoopReadLine)
			str.=A_LoopReadLine "`r`n"
	return clipboard:=str
}


renewOrderCodes(hospitalCode="T0"){
	global pwb
	clip:=new DataGridTable(ParseTable())
	fileread,orderCodes,orderCodes.txt
	orderCodeData:=[], found:=[]
	Loop,parse,orderCodes,`n,`r
	{
		row:=[]
		Loop,parse,A_LoopField,`t
			row.push(Trim(A_LoopField))
		orderCodeData.push(row)
	}
	for k,row in clip {
		ToolTip % k
		if k=1
			continue
		examName:=Trim(row[clip.colNos["檢查名稱"]])
		,orderCode1:=orderCode:=Trim(row[clip.colNos["醫令代碼"]])
		
		,match:=false, matchline:=[]
		for _,oc in orderCodeData
			if(oc[1]=orderCode && examName=oc[2]){
				match:=true
				break
			}else if(oc[1]=orderCode){
				matchline:=oc.clone()
			}
		
		if(!match){
			if(matchline.maxIndex()){
				matchline[2]:=examName
				,orderCodeData.push(matchline)
				,s:=""
				for _,v in matchline
					s.=v "`t"
				FileAppend,% SubStr(s,1,-1) "`r`n",orderCodes.txt,utf-8
			}else{
				if !sid
					sid:=askForPortalIdPw()
				found:=false
				for _, v in result:=queryOrderPriceIE(orderCode1, sid, pwb, "code", hospitalCode) {
					orderCode:=v["醫令代碼"]
					if (orderCode && !v["停用日期"]){
						price1:=v["健保價"]
						,price2:=v["自費價"]
						,percentage:=queryPerformancePercentage(orderCode, sid, hospitalCode)
						if(percentage.maxIndex()){
							percentage:=percentage[1]["是否提成"]="要提成"?percentage[1]["提成比率"]:0
							,orderCodeData.push([orderCode, ExamName, price1, price2, percentage])
							FileAppend,% orderCode "`t" ExamName "`t" price1 "`t" price2 "`t" percentage "`r`n" ,orderCodes.txt,utf-8
							found:=true
							break
						}
						
					}
				}
				if (!found){
					found:=false
					for _, v in result:=queryOrderPriceIE(SubStr(ExamName,1,30), sid, pwb, "name", hospitalCode) {
						orderCode:=v["醫令代碼"]
						if (orderCode && !v["停用日期"]){
							price1:=v["健保價"]
							,price2:=v["自費價"]
							,percentage:=queryPerformancePercentage(orderCode, sid, hospitalCode)
							if(percentage.maxIndex()){
								percentage:=percentage[1]["是否提成"]="要提成"?percentage[1]["提成比率"]:0
								,orderCodeData.push([orderCode, ExamName, price1, price2, percentage])
								FileAppend,% orderCode "`t" ExamName "`t" price1 "`t" price2 "`t" percentage "`r`n" ,orderCodes.txt,utf-8
								found:=true
								break
							}
							
						}
					}
				}
				
				
				if (!found){
					orderCodeData.push([orderCode1, ExamName, "", "", ""])
					FileAppend,% orderCode1 "`t" ExamName "`t"  "`t"  "`t"  "`r`n" ,orderCodes.txt,utf-8
				}
					
				
			}
		}
		
	}
}

OnExit:
pwb.quit()
ExitApp