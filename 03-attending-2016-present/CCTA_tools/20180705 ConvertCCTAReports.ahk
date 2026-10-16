#include <JXON>

SetBatchLines,-1

dir:="C:\Users\Administrator\Downloads\CCTA_reports"

css=
(
<style type="text/css">
.red {
	font-weight: 700;
	color: red;
}
.gr {
	font-weight: 700;
	color: green;
}
</style>
)

red_kw:=["i)\b(CHD|ICD|pacemaker)\b"
	, "i)\b(defib\w+)", "i)(?<!No evidence of )congenital\b"]
gr_kw:="AccessNo,ExamDate,ReportDate,ReportDr,----------Report----------,----------Impression----------"
gr_kw2:="CLINICAL STATEMENT,PROCEDURE DATA,RESULTS,Agatston score,Coronary artery analysis,Dominance,Left main coronary artery,Left anterior descending artery,Left circumflex artery,Right coronary artery,LV functional analysis,Noncoronary cardiac findings,Noncardiac findings"

Loop,% dir "\*.json" 
{
	
	if FileExist(RegExReplace(A_LoopFileLongPath, ".json$", "_.json"))
		continue
	FileGetSize,s,% A_LoopFileLongPath,k
	if s<1
		continue
	fileread,r,% A_LoopFileLongPath
	if !InStr(r, "Coronary CT angiography")
		continue
	
	try
		j:=JXON_load(r)
	catch
		continue
	
	t:=""
	
	if InStr(A_LoopFileName, "_.json"){
		s:="ExamDate,ReportDate,ReportDr"
		Loop,Parse,s,`,
			t.=A_LoopField ": " j[A_LoopField] "`r`n"
		t.="`r`n----------Report----------: `r`n" j.ReportBody "`r`n"
		,t.="`r`n----------Impression----------: `r`n" j.Impression "`r`n"
		
		
	}else{
		for AccNo,jj in j {
			s:="AccessNo,ExamDate,ReportDate"
			Loop,Parse,s,`,
				t.=A_LoopField ": " jj[A_LoopField] "`r`n"
			t.="ReportDr: " RegExReplace(jj.ReportDr, "is)^([^ ]+).+?$", "$1") "`r`n"
			,t.="`r`n----------Report----------: `r`n" jj.ReportBody "`r`n"
			,t.="`r`n----------Impression----------: `r`n" jj.Impression "`r`n`r`n"
		}
		
	}
	FileDelete,% RegExReplace(A_LoopFileLongPath, ".json$", ".txt")
	FileAppend,% t, % RegExReplace(A_LoopFileLongPath, ".json$", ".txt"),utf-8
	Loop,Parse,gr_kw,`,
	{
		StringReplace,t,t,% A_LoopField ": ",% "<span class=gr>" A_LoopField ": </span>",All
	}
	Loop,Parse,gr_kw2,`,
	{
		StringReplace,t,t,% A_LoopField ":",% "<span class=gr>" A_LoopField ":</span>",All
	}
	t:=RegExReplace(t, "i)(cad\Wrads *[\w\/\\]+)", "<span class=gr>$1</span>")
	for k,v in red_kw {
		t:=RegExReplace(t, v, "<span class=red>$1</span>")
	}
	html:=RegExReplace(t, "\r?\n", "<br/>")
	FileDelete,% RegExReplace(A_LoopFileLongPath, ".json$", ".html")
	FileAppend,% css html, % RegExReplace(A_LoopFileLongPath, ".json$", ".html"),utf-8
}
ExitApp