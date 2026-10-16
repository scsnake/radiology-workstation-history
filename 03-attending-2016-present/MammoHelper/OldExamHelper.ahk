#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,Off
SetBatchLines, -1
SetKeyDelay,-1,-1
coordMode,mouse,screen
coordMode,pixel,screen
coordMode,tooltip,screen
SetTitleMatchMode,2
setformat,float,0.2
SetControlDelay,-1
#SingleInstance,force
DetectHiddenWindows,on
#include <risimpax>
#include <.netgetcontrol>
#include <ImpaxContextServer>
OnExit,OnExit

SetTimer,onexit,-120000

if SubStr(A_IPAddress1 "," A_IPAddress2 "," A_IPAddress3 "," A_IPAddress1, "172.26.") 
    global __is_NTUCC:=true
else
    global __is_NTUCC:=false

args:=[]
Loop %0%
	if !(%a_index%=A_ScriptName)
		args.push(%a_index%)
	
if !(args.maxindex()>0){
	MsgBox,
(
Function:
Open old film, store exam dates to clipboard

Usage: 
%a_scriptname% ExamRule [openOldFilm=6] [dateFormat=yyyy/MM/dd] [newestFirst=1] [send=1]

ExamRule: regular expression. for mammo, use "Mammogra|乳房|LOCALIZATION- BREAST|Medio-lateral oblique|Mammotome|Stereotic|tomosynthesis", or just use "mammo" for default

openOldFilm: how many old study to be included, default = 6, set 0 for none

dateFormat: store dates in clipboard, as (default) format of yyyy/MM/dd

newestFirst: (default) newest date first, set 0 to reverse

send: send text of all dates, default = 1 (yes) 
)
	ExitApp
}

settings:=[]
,args[1]:=RegExReplace(args[1], "^""", "")
,args[1]:=Trim(RegExReplace(args[1], """$", ""))
,settings["ExamRule"]:=(args[1]="mammo"||args[1]="")?"Mammogra|乳房|LOCALIZATION- BREAST|Medio-lateral oblique|Mammotome|Stereotic|tomosynthesis":args[1]
for k,v in args
	if RegExMatch(v, "(\w+)=([^=]+)", match)
		settings[match1]:=match2
    

for k,v in DefaultSettings:={openOldFilm: 6, dateFormat: "yyyy/MM/dd", newestFirst: 1, send:1}
   if !settings.haskey(k)
    settings[k]:=v
;~ MsgBox % settings.newestFirst
;~ settings["dateFormat"]:="dd-mm-yy"
;~ settings["newestFirst"]:=0

RisHwnd:=risopened()[2]
, ImpaxState:=impaxOpened()
if (thisAccNo:=getRisAccNo(RisHwnd))!=getImpaxAccNo(ImpaxState[2,1])
	risOpenStudyImpax(risHwnd)
RisHistoryAcc:=acc_ObjectFromWindow(getRisHistoryId(RisHwnd))
,priorDates:=[],count:=0,prior:=""

if !__is_NTUCC && !(impaxContextServerHwnd:=ImpaxContextServer_Init())  {
    for k,v in rows:=acc_children(RisHistoryAcc) {
         if(k=1){
            Cols:=[]
            for x,y in cells:=acc_children(v) 
                Cols[Trim(y.accValue)]:=Trim(x)
            
        }else if regexmatch((cells:=acc_children(v))[Cols["檢查名稱"]].accValue,"is)" settings.ExamRule) {
            ;~ priorDate.=acc_children(v)[2].accValue ", "
            if !prior
                prior:=v, prior.accSelect(ComObj(3,3),0)
            if (++count<=settings.openOldFilm)  {
                v.accSelect(ComObj(3,3),0)
                sleep 200
                loc:=Acc_Location(v)
                mouseclick,r,% loc.x+50,% loc.y+5,1,0
                sleep 200
                mouseclick,l,10,10,1,0,,R
                
                AddDate(thisDate:=cells[Cols["檢查日"]].accValue)
                
                
            }else{
                break
            }
        }
    }
}else{
    ;~ sendStr:=""
    AccNos:=[]
    for k,v in rows:=acc_children(RisHistoryAcc) {
        if(k=1){
            Cols:=[]
            for x,y in cells:=acc_children(v) 
                Cols[y.accValue]:=x
                
        }else if regexmatch((cells:=acc_children(v))[Cols["檢查名稱"]].accValue,"is)" settings.ExamRule) {
            if !prior
                prior:=v, prior.accSelect(ComObj(3,3),0)
            if (++count<=settings.openOldFilm) {
                ;~ sendStr.="ADD_TO_DISPLAY_LIST || " Trim(acc_children(v)[Cols["照會單號"]].accValue) " || "
                AccNos.push(Trim(cells[Cols["照會單號"]].accValue))
                ,AddDate(thisDate:=cells[Cols["檢查日"]].accValue)
                
            }else{
                
                break
            }
        }
    }
    
    Sleep 1000
    
    for k,v in AccNos
        ImpaxContextServer_Add(v)
    ;~ sendStr.="SYNC_DISPLAY || " thisAccNo " || "
    ImpaxContextServer_Show(thisAccNo)
    
    ;~ if(Count=0)
        ;~ sendStr.="ADD_TO_DISPLAY_LIST_WITH_PRIORS || " thisAccNo " || "
    ;~ Sleep 1000
    

}

if (Count){
    sortDates(priorDates)
    priorDate:=""
    for k,v in priorDates    
        priorDate.=v ", "
    clipboard:=priorDate:=SubStr(priorDate,1,-2)
}


if (simpleRis:=WinExist("simple RIS ahk_class AutoHotkeyGUI")){
    winactivate,% "ahk_id " simpleRis
    ControlFocus,Scintilla1,ahk_id %simpleRIS%
}else{
    ;~ send {f6}
    RisReports:=getRisReports(RisHwnd)
    winactivate,ahk_id %RisHwnd%
    ControlFocus,,% "ahk_id " RisReports[1,1]
}
if settings.send
    SendRaw % priorDate
ExitApp
return

AddDate(d){
    global priorDates, settings
    RegExMatch(Trim(d), "(\d+)\/(\d+)\/(\d+)", match)
    FormatTime,newDate,% match1 match2 match3 "000000",% RegExReplace(settings.dateFormat, "i)m", "M")
    priorDates[hash:=match1*13*32+match2*32+match3]:=newDate
    
}

sortDates(ByRef dates){
    global settings
    ret:=[]
    if !(settings.newestFirst){
        for k,v in dates
            ret.push(v)
    }else{
        hash:=[]
        ,mx:=dates.SetCapacity(0)
        for k,v in dates
            hash[mx+1-A_Index]:=k
        for k,v in hash
            ret.push(dates[v])
    }
    dates:=ret
}


;~ esc::
OnExit:
ExitApp