SetBatchLines,-1
#NoEnv
#NoTrayIcon
#SingleInstance,Off
#Persistent
#include <JXON>
#include <WM_COPYDATA>
#include <portallib>
#include <RXMS>
#include <ParseArg>
DetectHiddenWindows,on


;~ args:=["sid", "chartNo", "AccNo"]
;~ ,i:=0
;~ Loop %0%
	;~ if (%a_index%!=A_ScriptName)
		;~ var:=args[A_Index]
		;~ ,%var%:=%a_index%
		;~ ,++i

;~ if i!=3
	;~ ExitApp
	
args:=ParseArg()
vars:=["sid", "chartNo", "AccNo"]
for k,v in vars
	%v%:=args[k]

;~ ToolTip % sid "," chartNo "," accNo

boneKeywords:=["rib","fracture","bone","bony","\bsclero","lytic"]
,lungKeyWords:=["(lung|pulmonary) (nodule|mass|tumor|lesion|metasta)"]
,cancerKeywords:=["cancer","malignant","malignancy","lymphoma","leukemia","tumor"]
,dwData:=17
SetTimer,exit,-300000
gosub main

return


main:
	keyword:="",loadHistoryFlag:=1
	;~ ToolTip % "loadin chartNo: " chartNo
	
	,RisReport2Yr:=parseRisReport2Yr(RisReport2Yr(sid, chartNo))
		;~ ,hx2Yr[chartNo]:=RisReport2Yr.clone()
	
	
	for k,v in RisReport2Yr {
		if regexmatch(priorExamItem:=v.1.1,"is)Chest.*(AP|PA)") && (++CXRind<11) {
			tmp:=matchText(v.2,boneKeyWords)
			,keyWord.=tmp=""?"":(RegExReplace(substr(v.1.3,1,10),"\/","") "CXR: " tmp)
		}else if regexmatch(priorExamItem,"is)CT.*Chest|low dose (lung|chest)") && (++CTind<2) {
			tmp:=matchText(v.3,lungKeyWords)
			,keyWord.=tmp=""?"":(RegExReplace(substr(v.1.3,1,10),"\/","") "CT: "  tmp)
		}
	}
	
	;~ msgbox % thisStudyInd
	;~ hx[thisStudyInd]:=keyword "   "
	
	dict:={"oldHx": {}}
	,dict["oldHx", accNo]:=keyword "   "
	,Send_WM_COPYDATA(getListenerHwnd(), dwData, jxon_dump(dict))
	
	;~ MsgBox % keyword
	;~ ToolTip % "keyword: " keyword
	;~ if(show)
		;~ showHx(thisStudyInd)
		exit:
	ExitApp
	;~ loadHistoryFlag:=0
	;~ return true
	
return

matchText(byref str,byref arrOfKeyWords){
	ret:=""
	for k,v in arrOfKeyWords {
		;~ ret.=(s:=RXMS(str,"is)[^\.;\r\n]*" v "[^\.;\r\n]*([\.;\r\n]|$)","r"))=""?"":s "`n"
		s:=RXMS(str,"is)[^\.;\r\n]*" v "[^\.;\r\n]*([\.;\r\n]|$)","r")
		Loop,parse,s,`n
			if !(A_LoopField~="i)\b(no|without)\b")
				ret.=A_LoopField "`n"
	}
	return ret
}

getListenerHwnd(){
	return WinExist("WM_COPYDATA_Listener_miniPACS")
}

