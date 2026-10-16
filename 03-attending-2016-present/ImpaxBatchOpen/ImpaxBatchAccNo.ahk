#include <RisImpax>
#include <PortalLib>
#include <ImpaxContextServer>
SetBatchLines,-1
#SingleInstance,Off
;~ OnExit,OnExit

;~ portalId:=loginId
;~ portalPw:=loginPw
gosub main
return

main:

clip:=clipboard
;~ ,sid:=askForPortalIdPw()
,source:=[]
Loop,Parse,clip,`n
{
	;~ i:=RegExMatch(A_LoopField, "is)", match)
	;~ match:=Trim(A_LoopField)
	RegExMatch(Trim(A_LoopField), "\b\w{10}\d\b", match)
	if (match="")
		continue
	AccNo:=match
	ImpaxContextServer_Add(AccNo)
	,ImpaxContextServer_Show(AccNo)
	;~ if Mod(A_Index,10)=0 {
		;~ Sleep 5000
		;~ ImpaxContextServer_RemoveAll()
	;~ }
	Sleep 300
	;~ ExitApp
}
ExitApp
return

;~ esc::ExitApp