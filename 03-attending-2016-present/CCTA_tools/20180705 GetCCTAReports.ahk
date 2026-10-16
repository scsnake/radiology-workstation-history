#include <portallib>
#include <JXON>
;~ #include <XML>


SetBatchLines,-1

;~ DOM:=ComObjCreate("HtmlFile")
;~ dom.write("&lt;")
;~ MsgBox % dom.documentElement.innerText
;~ ExitApp

;~ s:=RegExReplace(Clipboard, "<\w+[^>]+\/>","")
;~ s:=RegExReplace(s, "<![^>]+>","")
;~ s:=RegExReplace(s, "i)<(meta|link)[^>]+>","")
;~ s:=RegExReplace(s, "is)<(script|style)[^>]*>.*?<\/(script|style)>","")
;~ Clipboard:=s
;~ RegExMatch(clipboard, "is)<table [^>]*id=[^>]*TableRisReport[^>]*>.+?</table>", match)
;~ x:=new xml(clipboard:=match)
;~ a:=getHtmlByTagName(match, "TR")


;~ ExitApp

dir:="C:\Users\Administrator\Downloads\reports"
id:="000000", pw:="MOCK_PASSWORD"
sid:=login(id, pw)
Loop,% dir "\*.json"
{
	if InStr(A_LoopFileName,"_") || FileExist(RegExReplace(A_LoopFileLongPath, ".json$", "_.json"))
		continue
	
	FileGetSize,s,% A_LoopFileLongPath,k
	if s>1
		continue
	fileread,r,% A_LoopFileLongPath
	if InStr(r, "Coronary CT angiography")
		continue
	
	
	SplitPath,A_LoopFileLongPath,,,,chartNo
	b:=RisReport2Yr(sid,chartNo)
	c:=parseRisReport2Yr(b)
	for k,v in c {
		if InStr(v[2], "Coronary CT angiography") {
			j:={OrderDescription: v[1][1]
				, ReportDr: v[1][2]
				, ExamDate: v[1][3]
				, ReportDate: v[1][5]
				, ReportBody: v[2]
				, Impression: v[3]}
			FileAppend,% JXON_dump(j),% dir "\" chartNo "_.json",utf-8
			break
		}
	}
}
ExitApp
esc::
ExitApp