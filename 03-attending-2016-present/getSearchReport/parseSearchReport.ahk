#include <xml>
#include <HotstringEnhancer>
#include <JoinScript>
#SingleInstance,force


xml:=new xml("save.xml")

gosub AhkHotstrings

;~ MsgBox % xml.selectSingleNode("//SearchReport/study[1]/exam").Text
FileAppend,% "<?xml version=""1.0"" encoding=""UTF-8""?>`n<ParsedReport>`n",Parsed.xml,utf-8

studies:=xml.SelectNodes("//SearchReport/study")
;~ ToolTip % studies.length
result:=""
Loop % studies.length {
	study:=studies.item(A_Index-1)
	;~ if(pExamDate = (examDate:=study.selectSingleNode("//檢查日").Text))
		;~ continue
	;~ pExamDate:=examDate
	
	if(pExam = (exam:=study.selectSingleNode(".//exam").Text))
		continue
	pExam:=exam
	
	if InStr(exam, "Imaging Body Parts") 
		continue
	
	examType:=study.selectSingleNode(".//檢查名稱").Text
	if InStr(examType, "Requesting") || InStr(examType, "EnCor") || InStr(examType, "COMMON CAROTID ARTERY") || InStr(examType, "guide")
		continue
	else if RegExMatch(examType, "i)^CT")
		examType:="CT"
	else if RegExMatch(examType, "i)^MRI")
		examType:="MRI"
	else if InStr(exam, "digital mammogra")
		examType:="mammo"
	else
		examType:="plain"
	
	str:=""
	;chest ct template
	if InStr(exam, "TECHNIQUE: CT of the chest"){
		Loop,Parse,exam,`n,`r 
		{
			if RegExMatch(A_LoopField, "i)^-- ([^\r\n]+)", match){
				str.=match1 "`n"
			}else if RegExMatch(A_LoopField, "i)^- [^:]+:([^\n\r]+)", match) && Trim(match1)!="" {
				str.=match1 "`n"
			}
		}
		Parsed:=AhkHotstring(str)
	}else if (examType="CT" || examType="MRI") {
		Loop,Parse,exam,`n,`r 
		{
			if RegExMatch(A_LoopField, "i)(?:\W|\d+\W) ([^\n\r]+)", match) && Trim(match1)!="" {
				str.=match1 "`n"
			}
		}
		Parsed:=AhkHotstring(str)
	}else if !InStr(exam, "FINDINGS:") {
		Loop,Parse,exam,`n,`r 
		{
			if RegExMatch(A_LoopField, "i)^(?:\W|\d+\W) ([^\r\n]+)", match) && Trim(match1)!="" {
				str.=match1 "`n"
			}
		}
		if(examType="mammo")
			str:=RegExReplace(str, "[^\r\n]+\r?\n", "", "", 1)
		Parsed:=AhkHotstring(str, (examType="mammo")?3:1)
	}else{
		RegExMatch(exam, "i)FINDINGS:\r?\n([^\r\n]+)", match)
		RegExMatch(match1, "i)placement of (([^\.])+)\. ?", tubes)
		RegExReplace(tubes1, "\,", "", Count)
		match1:=RegExReplace(match1, "i)placement of ([^\.])+\. ?", "") (tubes1=""?"":repeat("░", Count+1))
		if Trim(match1)!=""
			str.=match1 "`n"
			,Parsed:=AhkHotstring(str, 2)
	}
	
	newStr:="<study>`n<examType>" examType "</examType>`n<exam>" XML_escape(SubStr(str,1,-1)) "</exam>`n<code>" XML_escape(Parsed) "</code>`n</study>`n"
	
	FileAppend,% newStr,Parsed.xml,utf-8

	result.=examType "`t" StrLen(str)-1 "`t" StrLen(Parsed) "`n"
	;~ if(str="")
		;~ bbb:=1
}
FileAppend,% "</ParsedReport>",Parsed.xml,utf-8
clipboard:=result

ExitApp

AhkHotstrings:
ctahk:=HotstringEnhancer(JoinScript("F:\scripts\Radiology\YCH.ahk"), 15, 1)[2]
cxrahk:=HotstringEnhancer(JoinScript("F:\scripts\Radiology\YCH_XR.ahk"), 15, 1)[2]
mmahk:=HotstringEnhancer(JoinScript("F:\scripts\Radiology\YCH_mammo.ahk"), 15, 1)[2]
;~ clipboard:=mmahk["bcal"]
AllAhk:=[ctahk, cxrahk, mmahk]
return

TrimEnd(ahk){
	ahk:=RegExReplace(ahk, "\{[^\}]+\}","")
	ahk:=RegExReplace(ahk, "i)([ \-]|\``\w)+$", "")
	return ahk
}

encodeReport(Text, ByRef ahk){
	l:=StrLen(Text), i:=1, newStr:="", EndChar:="█", SubStr:=Text
	

	found:=[]
	for k,v in ahk {
		v:=TrimEnd(v)
		;~ if InStr(v, "There are benign scattered calcifications present bilaterally.")
		;~ bbb:=1
		if pos:=RegExMatch(Text, "i)(^|\b)" RegExEscape(v) "(\b|\s|$)") {
			if (len:=StrLen(v))=1
				continue
			if !IsObject(found[pos])
				found[pos]:=[]
			if !IsObject(found[pos, 9999-len])
				found[pos, 9999-len]:=[]
			found[pos, 9999-len].push([k, v])
		}
	}
	
	map:=[]
	for k,v in found {
		if (i>k+0)
			continue
		for x,y in v {
			map.push([k, 9999-x, y[1,1], y[1,2]])
			,i:=k+(9999-x)
			break
		}
	}
	
	newText:=Text
	for k,v in map {
		newText:=SubStr(newText, 1, v[1]-1) StringUpper(v[3]) repeat(EndChar, v[2]-StrLen(v[3])) SubStr(newText, v[1]+v[2])
	}
	
	
	;~ Loop {
		;~ if(i>l)
			;~ break
		;~ foundPos:=0, foundLen:=0, foundPair:=[]
		;~ for k,v in ahk
			;~ if pos:=InStr(SubStr, v) {
				;~ len:=StrLen(v)
				;~ if (!foundPos || pos<foundPos) || (foundPos=pos && foundLen<len)
					;~ foundPos:=pos, foundLen:=len, foundPair:=[k, v]
			;~ }
		;~ if !foundPos
			;~ break
		;~ newStr:=SubStr(Text, 1, foundPos-1) foundPair[1] repeat(EndChar, foundLen-StrLen(foundPair[1])) (SubStr:=SubStr(Text, foundPos+foundLen)) 
	;~ }
	newText:=RegExReplace(newText, EndChar "+", EndChar)
	newText:=RegExReplace(newText, EndChar "([\.\;\)\(\,\/\\\$\#])", "$1")
	newText:=RegExReplace(newText, EndChar " ", EndChar)
	return newText
}

;~ StringUpper(str){
	;~ StringUpper,str,str
	;~ return str
;~ }

RegExEscape(str){
	return RegExReplace(str, "\W", "\$0")
	
}

repeat(Chr, n){
	str:=""
	Loop % n
		str.=Chr
	return str
}

AhkHotstring(str, ahkType=1){
	global AllAhk
	return encodeReport(str, AllAhk[ahkType])
}


XML_escape(str){
	str:=RegExReplace(str, """", "&quot;")
	str:=RegExReplace(str, "'", "&apos;")
	str:=RegExReplace(str, "<", "&lt;")
	str:=RegExReplace(str, ">", "&gt;")
	str:=RegExReplace(str, "&", "&amp;")
	return str
}
