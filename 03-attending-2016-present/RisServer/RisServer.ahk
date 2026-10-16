#NoEnv
#SingleInstance,Ignore
SetBatchLines,-1
SetControlDelay,-1
DetectHiddenWindows, On
SetTitleMatchMode,2
coordmode,mouse,screen

#include <RisImpax>
#include <SetTimerF>

args:=ParseArg()
,RisImpaxDecodePw:=args[1]
,RisImpaxLoginInfo:=RisImpaxLoadPw("000000")
;~ ,RisImpaxLoginInfo:=RisImpaxLoadPw(RisImpaxDecodePw)
,RisPaths:=GetRisPath(1)
,RisPath:=RisPaths.length()==1?RisPaths[1]:""
,lastQueueTime:=0
if !WinExist("killUpdate ahk_exe killUpdate.exe")
	try
		run killUpdate.exe
openedRIS:=[]
settimer,noidle,600000
loginRIS(1)
return


loginRIS(which){
	global risLogining, openedRIS, RisImpaxLoginInfo, RISpath, lastQueueTime, RisPaths
	if risLogining
		return SetTimerF("loginRIS", -(3000+lastQueueTime), [which]), lastQueueTime+=3000
	
	risLogining:=true
	,risUser:=RisImpaxLoginInfo.ris[which].user
	,risPw:=RisImpaxLoginInfo.ris[which].pw
	,lastQueueTime:=max(lastQueueTime-3000,0)
	,oldOpenedRis:=risopened(1)[2].clone()
	Loop {
		if (risopened(1)[2].length()>oldOpenedRis.length()){
			openedRIS[which]:=risopened(1)[2, oldOpenedRis.length()+1]
			break
		}
		Loop {
			ifwinexist,ahk_class #32770,% "已有程式執行中,是否確定重複開啟程式"
			{ 
				controlclick,Button1
				Sleep 1000
			}
			if (RisOpened(1)[1,1]) {
				RISarr:=getControls(risid:=risopened(1)[1,1])
				,RisIdHwnd:=GetControlIdByText(RISarr,"Password",-1)
				controlfocus,,ahk_id %RisIdHwnd%
				winactivate,% "ahk_id " risId
				winwaitactive,% "ahk_id " risId,,3
				if(!errorlevel){
					controlfocus,,ahk_id %RisIdHwnd%
					send {home}+{end}
					Sleep 200
					winactivate,% "ahk_id " risId
					winwaitactive,% "ahk_id " risId,,3
					SendRaw % risUser
					send {tab}
					Sleep 1000
					winactivate,% "ahk_id " risId
					winwaitactive,% "ahk_id " risId,,3
					send {home}+{end}
					Sleep 200
					winactivate,% "ahk_id " risId
					winwaitactive,% "ahk_id " risId,,3
					SendRaw % risPw
					send {enter}
					Sleep 3000
					break
				}
			}else{
				;~ RisPath:=getrispath(1)
				if (RisPath=""){
					for k,v in RisPaths
						try {
							run,% v,% RegExReplace(v, "\\Menu\.exe$")
							Loop {
								Sleep 500
							}until risopened(1)[1,1] || A_Index>10
							if risopened(1)[1,1] {
								RisPath:=v
								break
							}
							
						}
							
				}else
					run,% risPath,% RegExReplace(RISpath, "\\Menu\.exe$")
				Sleep 3000
			}
		}
	}
	risLogining:=false
}


noIdle:
map("RisNoIdle", openedRIS)
return