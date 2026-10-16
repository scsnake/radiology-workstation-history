;~ SetBatchLines,-1
;~ #include <JoinScript>

;~ FileDelete, % "F:\scripts\Radiology\YCH_Enh.ahk"
;~ FileAppend,% HotstringEnhancer(JoinScript("F:\scripts\Radiology\YCH.ahk"), 15), F:\scripts\Radiology\YCH_Enh.ahk, utf-8
;~ FileDelete, % "F:\scripts\Radiology\YCH_CXR_Enh.ahk"
;~ FileAppend,% HotstringEnhancer(JoinScript("F:\scripts\Radiology\YCH_CXR.ahk"), 15), F:\scripts\Radiology\YCH_CXR_Enh.ahk, utf-8
;~ FileDelete, % "F:\scripts\Radiology\YCH_mammo_Enh.ahk"
;~ FileAppend,% HotstringEnhancer(JoinScript("F:\scripts\Radiology\YCH_mammo.ahk"), 15), F:\scripts\Radiology\YCH_mammo_Enh.ahk, utf-8


;~ param:=[]
;~ Loop %0% 
	;~ param.push(%a_index%)

;~ for k,v in param
	;~ if FileExist(v)
		;~ HotstringEnhance(v)

;~ test=
;~ ( %
;~ sendbyclipboard("%exam% of the %part% %contrast% contrast enhancement shows:")
;~ )

;~ clipboard:=HotstringEnhancer(JoinScript("F:\scripts\Radiology\YCH.ahk"))
;~ MsgBox % clipboard:=HotstringEnhancer(test)
;~ ExitApp
;~ return


HotstringEnhancer(fileOrText, minStrCount=20, alsoReturnArr=false){

	
	if FileExist(fileOrText)
		fileread,fullscript,% fileOrText
	else
		fullscript:=fileOrText
	;~ clipboard:=fullscript
	arr:=[],hotstring:=[],str:="",hotstringText:=[]
	newScript:=""
	
	loop,parse,fullscript,`n,`r 
	;~ loop,read,% path 
	{ 
		;~ if InStr(A_LoopField,"brainLobe:")
			;~ aaa:=1
		if RegExMatch(A_LoopField, "is)^\s*\/\*"){
			blockComment:=1
		}else if RegExMatch(A_LoopField, "is)^\s*\*\/"){
			blockComment:=0
		}
		
		if(blockComment){
			newScript.=A_LoopField "`n"
			continue
		}
		
		RegExMatch(A_LoopField, "is)^(.*?)( +;.*)?$", thisLine)
		
		
		if (inHotstring)
			++inHotstring
		
		
		if RegExMatch(thisLine1,"is)(^:([^:]*?):(.+):[^:]?:)(.*)$",match) {
			if(inHotstring=2 && str=""){
				arr["" hotstring[1]]:=""
				,hotstring:=[], hotstringText:=[]
			}
			
			newScript.=match1 thisLine2 "`n", inHotstring:=1
			omitEndChar:=!!RegExMatch(match2, "i)o(?!0)")
			
			if (Trim(match4)!=""){
				arr["" match3]:=match4, hotstring:=[], hotstringText:=[], newScript.=str2clip(match4 ,1, minStrCount) "`n" (omitEndChar?"":"send % A_EndChar`n") "return`n", inHotstring:=0
				continue
			}else {
				hotstring.push(match3), str:="", blockStr:="", hotstringText.push(match1)
				continue
			}
			
			
		}
		
		
		if (hotstring.maxindex()>0) {
			if RegExMatch(thisLine1,"is)^(\s*)\(\s*$") && (inHotstring=2) {
				blockStr:="", inBlockStr:=1
			}else if RegExMatch(thisLine1,"is)^(\s*)\)\s*$") && inBlockStr {
				inBlockStr:=0, blockStr:=SubStr(blockStr,1,-1)
				for k,v in hotstring
					arr["" v]:=blockStr
					
				hotstring:=[], hotstringText:=[], newScript.="sendByClipboard(""`n(`n" blockStr "`n)"")`n" (omitEndChar?"":"send % a_endchar`n") "return`n", inHotstring:=0
			}else if RegExMatch(thisLine1, "is)^(\s*)return *(?!:?=)"){
				inHotstring:=0, newScript.="return`n", hotstring:=[], hotstringText:=[], str:=""
			}else{
				if(inBlockStr)
					blockStr.=Trim(A_LoopField) "`n"
				else
					str.=A_LoopField "`n"
					,newScript.=A_LoopField "`n"
			}
			
			
		}else{
			newScript.=A_LoopField "`n"
		}
		
	}
	;~ clipboard:=newScript
	;send command
	script2:=""
	i:=0 , match:="0", ind:=1
	while i:=RegExMatch(newScript,"i)([^\r\n]*)\bsend\b *(,)? *(?:(\r?\n\(\r?\n(.*?)(\r?\n\)))|([^\r\n]+))", match, ind) {
		script2.=SubStr(newScript, ind, i-ind)
		;~ if InStr(SubStr(newScript, ind, i-ind), "brainLobe:")
			;~ aaa:=1
		ind:=i+StrLen(match)
		if RegExMatch(match1,"(^|\s);") {
			script2.=match
			continue
		}
		
		if(match4){
			script2.=match1 "sendByclipboard(""`n(`n" doublingQuote(match4) "`n)"")"
		}else if(match6){
			if RegExMatch(match6, "^[\^\!\#\+]") {
				script2.=match
			}else if !RegExMatch(match6, "i)^ *(%) +([^\r\n]+)", m) && SubStr(match6,1,1)!="," {
				script2.=match1 str2clip(match6, 1, minStrCount, match1) "" 
			}else{
				match4:=m2
				if StrLen(match4)<minStrCount
					script2.=match
				else 
					script2.=match1 "sendByClipboard(" match4 ")"
			}
		}
		
		;~ ToolTip % A_Index
	}
	if(ind<StrLen(newScript))
		script2.=SubStr(newScript, ind)
	
	script2:=RegExReplace(script2, "i)sendByclipboard\(""""\)\s*","")
	script2:=RegExReplace(script2, "\s*\r?\n\s*(\r?\n\s*\})","$1")
	
	freeVar(script2)
	
	Func1=
	(Ltrim
	
	sendByClipboard(byref str){
		clipboard:=str
		send ^v
	}
	)
	
	if(alsoReturnArr)
		return ["#Hotstring o`n" script2 "`n" Func1, arr]
	else
		return "#Hotstring o`n" script2 "`n" Func1

	
}

freeVar(ByRef script){
	i:=0,match:="0",newScript:="",ind:=1
	while i:=RegExMatch(script, "i)(sendByClipboard\("")([^""\r\n]+)(""\))",match,ind){
		newScript.=SubStr(script,ind,i-ind)
		str:=match1 RegExReplace(match2,"\%(\w+)\%\%(\w+)\%", """ $1 $2 """) match3
		str:=RegExReplace(str,"\%(\w+)\%", """ $1 """)
		str:=RegExReplace(str,"i)^sendbyclipboard\("""" ","sendbyclipboard(")
		str:=RegExReplace(str," """"\)$",")")
		newScript.=str
		ind:=i+StrLen(match)
	}
	newScript.=SubStr(script, ind)
	
	i:=0,match:="0",script:="",ind:=1
	while i:=RegExMatch(newScript, "i)(send \% "")([^""\r\n]+)("")",match,ind){
		script.=SubStr(newscript,ind,i-ind)
		str:=match1 RegExReplace(match2,"\%(\w+)\%\%(\w+)\%", """ $1 $2 """) match3
		str:=RegExReplace(str,"\%(\w+)\%", """ $1 """)
		str:=RegExReplace(str,"i)^send \% """" ","send % ")
		str:=RegExReplace(str," """"$","")
		script.=str
		ind:=i+StrLen(match)
	}
	script.=SubStr(newscript, ind)
	
}


doublingQuote(str){
	return RegExReplace(str, """", """""")
}

encloseBracket(str){
	str:=RegExReplace(str, "i)sendByclipboard\(""""\)\s*","")
	str:=RegExReplace(str, "i)send *\% +""""(?=\s)","")
	str:=RegExReplace(str,"^\s+","")
	str:=RegExReplace(str,"\s+$","")
	str:=RegExReplace(str,"\s*(\n\s*(?!\n))+","$1")
	if InStr(str,"`n")
		return RegExReplace("{`n" str "`n}","\s*(\n\s*(?!\n))+","$1")
	else
		return str
}

CountExpStrLen(str){
	str:=RegExReplace(str,"\%[\w]+\%","#")
	str:=RegExReplace(str,"[\#\!\^\+]*\{[^\}]+\}","#")
	str:=RegExReplace(str,"s)``.","#")
	str:=RegExReplace(str,"""""","""")
	return StrLen(str)
}

; send abcd%var%^{up}`n
; -> send % "abcd" var 
;    send ^{up}`n
toStrArr(str){
	arr:=[]
	str:=RegExReplace(str,"\%([\w]+)\%","|$1|")
	
	expression:=0
	Loop,Parse,str,|
	{
		arr.push([A_LoopField, expression])
		expression:=!expression
	}
	
	return arr
	;~ str:=""""
	;~ for k,v in arr
		;~ if v.2
			;~ str.="""" v.1 """"
		;~ else
			;~ str.=doublingQuote(v.1)
		
	;~ return str
}

str2clip(script, Mode=0, minStrCount=20, indent=""){
	str:=""
	if(Mode=0){
		Text:=doublingQuote(Text)
		if CountExpStrLen(Text)<minStrCount
			return % "send % """ Text """"
		else
			return % "sendByclipboard(""" Text """)"
	}else if(Mode=1){
		i:=0, match:="0",ind:=1,sendByClipboard:=""
		while i:=RegExMatch(script, "{[^}]+}", match, ind) {
			if(match="{enter}")
				s:="``n" 
			else if (match="{space}")
				s:=" "
			else
				s:=""
			
			if(ps!="")
				str:=SubStr(str,1,-3)
			closure:=(sendByClipboard)?")`n":" `n"
			Text:=doublingQuote(SubStr(script,ind,i-ind))
			if CountExpStrLen(Text)<minStrCount {
				str.=(ps=""?"send % """:"") Text ((s!="")?( s """" (sendByClipboard=""?" `n":closure) ): """" (sendByClipboard=""?" `n":closure) indent "send " match "`n" indent)
				if(ps="")
					sendByClipboard:=0
			}else{
				str.=(ps=""?"sendByclipboard(""":"") Text ((s!="")?( s """" (sendByClipboard=""?")`n":closure) ): """" (sendByClipboard=""?")`n":closure) indent "send " match "`n" indent)
				if(ps="")
					sendByClipboard:=1
			}
			
			if(s="")
				sendByClipboard:=0
			
			ind:=i+StrLen(match), ps:=s
		}
		if(ind<=StrLen(script)){
			if(ps!="")
				str:=SubStr(str,1,-3)
			Text:=doublingQuote(SubStr(script,ind))
			closure:=(sendByClipboard)?")`n":" `n"
			if CountExpStrLen(Text)<minStrCount || sendByClipboard=0
				str.=(ps=""?"send % """:"") Text """" (sendByClipboard=""?" `n":closure)
			else
				str.=(ps=""?"sendbyclipboard(""":"") Text """" (sendByClipboard=""?")`n":closure)
		}
		
		return encloseBracket(str)
		;~ ret:=RegExReplace(str, "i)sendByclipboard\(""""\)\s*","")
		;~ ret:=RegExReplace(ret,"(^\n)|(\n$)","")
		
		;~ if InStr(ret, "`n")
			;~ return "{`n" indent ret "`n" indent "}"
		;~ else 
			;~ return ret
	
	}else if(Mode=2){
		Text:=doublingQuote(indent script)
		if CountExpStrLen(Text)<minStrCount
			return "send, `n(`n" Text "`n" ")"
		else
			return "sendByclipboard(""`n(`n" Text "`n" ")"")"
	}
	
	
}