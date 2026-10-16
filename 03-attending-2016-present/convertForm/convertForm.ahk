SetBatchLines,-1
#NoEnv
#include <RisImpax>

;~ MsgBox % Format("{:02}", 1)
;~ ExitApp

hollidays=
(
0101
0123
0124
0125
0126
0127
0128
0129
0228
0402
0403
)


;~ ~^c::
if (A_ThisHotkey=A_PriorHotkey && A_TimeSincePriorHotkey<400){
	data:=parseTable()
	
	for k,v in data[1] {
		if(v="報告日")
			ReportTimeCol:=k
		if(v="病歷號")
			chartNoCol:=k
	}
	
	sorted:=[]
	for k,v in data {
		if k=1
			continue
		
		ReportTime:=Trim(v[ReportTimeCol])
		
		if RegExMatch(ReportTime, "(\d+)\/(\d+)\/(\d+) (下|上)午 (\d+):(\d+):(\d+)", m)
			reportTime:=Format("{:04}{:02}{:02}{:02}{:02}{:02}", m1, m2, m3, InStr(m4, "下")?(m5+12):m5,m6,m7)
		
		if !sorted.haskey("_" reportTime)
			sorted["_"reportTime]:=[]
		
		sorted["_" reportTime].push(Trim(v[chartNoCol]))
	}
	included:={}
	str:=""
	sorted["_99999999999999"]:=[]
	for k,v in sorted {
		k:=SubStr(k,2)
		FormatTime,wday,% k,WDay
		if (wday=1 || wday=7 || hollidays~="\b" SubStr(k,5,4) "\b"){
			if !included.haskey(SubStr(k,5,4)) {
				if(lastDate){
					Hours:=SubStr(EndTime,1,2) - SubStr(StartTime,1,2)
					if (Hours=0 || SubStr(EndTime,3,2) - SubStr(StartTime,3,2)>30)
						Hours+=1
					str.=(SubStr(lastDate,5,2)+0) "/" (SubStr(lastDate,7,2)+0) "`t" startTime "`t" EndTime "`t" Hours "`t" lastChartNo "`n"
				}
				startTime:=SubStr(k,9,2) ":" SubStr(k,11,2)
				included[SubStr(k,5,4)]:=1
			}
			lastDate:=k
			,EndTime:=SubStr(k,9,2) ":" SubStr(k,11,2)
			,lastChartNo:=v[v.length()]
		}
	}
	clipboard:=result:=SubStr(str,1,-1)
	Showtooltip("Done!")
}
return

^v::
Loop,parse,result,`n,`r
{
	Loop,parse,A_LoopField,`t
		Send % A_LoopField "{tab}"
	Loop 5
		send +{tab}
	send {Down}
}
return


esc::ExitApp

