SetBatchLines,-1

#include <ImpaxContextServer>
#include <RegExSplit>
OnExit,OnExit

clip:=clipboard

res:=RegExMatchall(clip, "is)\b[TYH]\w{10}\b")

;~ Loop,Parse,clip,`n,`r
;~ {
for k,v in res.list
{
	
	match:=v[0]
	;~ if RegExMatch(A_LoopField, "is)\b[a-zA-Z\d]{7}\b", match)
		;~ chartNo:=match
	;~ if RegExMatch(A_LoopField, "is)\b[TY]\w{10}\b", match)
		ImpaxContextServer_Add(match)
		,ImpaxContextServer_Show(match)
	Sleep 300
}
ExitApp
return

OnExit:
ExitApp

