﻿#NoEnv
#SingleInstance,force
SetBatchLines,-1
DetectHiddenWindows, On
SetTitleMatchMode,2
coordmode,mouse,screen
;~ #NoTrayIcon
SendMode,Input
OnExit,OnExit
#include <RisImpax>
#include <HttpRequest>
#include <JXON>
#include <SetTimerF>
;~ #include <SetWindowsHookEx>
;~ #include <SetTimerF>

magicUrl:="http://10.0.1.100/lungNoduleResult/"

loadState:=[]
increment:=0

;~ MsgBox,,,,1

;~ gosub test


;~ test:
;~ thisAccNo:="T__________"
;~ ,thisChartNo:="5______"
;~ gosub loadMagicResult
return


!WheelUp::
!WheelDown::
if(impaxSelectImageWorking)
	return
impaxSelectImageWorking:=true
;~ if !(risHwnd:=RisOpened()[2]){
	;~ MsgBox % "Can't find RIS!"
	;~ goto return
;~ }
if !(impaxHwnd:=ImpaxOpened()[2,1]){
	MsgBox % "Can't find IMPAX!"
	goto return
}
thisChartNo:=getImpaxChartNo(impaxHwnd)
,thisAccNo:=getImpaxAccNo(impaxHwnd)
if(thisChartNo="" || thisAccNo=""){
	MsgBox % "Can't get chart no. or accession no."
	goto return
}
;~ if(getImpaxAccNo()!=thisAccNo){
	
;~ }
if(gui.results.AccNo!=thisAccNo)
	if (loadMagicResult()=-1)
		goto return
if !(thisResult.lesionCount>0){
	MsgBox % "No nodule found by magic!"
	goto return
}
if InStr(A_ThisHotkey, "DOWN")
	gui.scrollNext()
else
	gui.scrollPrior()
;~ if(!resultInd)
	;~ resultInd:=InStr(A_ThisHotkey, "DOWN")?1:0
;~ else
	;~ resultInd+=InStr(A_ThisHotkey,"DOWN")?1:-1
;~ resultInd:=Mod(resultInd-1+thisResult.lesionCount, thisResult.lesionCount)+1
;~ , result:=thisResult.lesions.nodules[resultInd]
;~ ,SE:=thisResult.lesions.SeriesNumber
;~ ,IM:=result[2]
;~ impaxSelectImage(IM, SE, {x: result[4], y: result[3]})
;~ ToolTip % "Lesion " resultInd " / " thisResult.lesionCount "`nSE: " (SE) "`nIM: " (IM)
;~ SetTimer,ToolTip,-2000
return:
impaxSelectImageWorking:=false
return

loadMagicResult(){
	global 
	thisResult:={AccNo: thisAccNo, lesions: [], lesionCount: 0}
	resultInd:=0
	httprequest(magicUrl thisChartNo "_" thisAccNo ".json", post:="", header:="", "charset: utf-8")
	;~ Loop,Parse,post,`n,`r
	;~ {
		;~ resultLine:=[]
		;~ Loop,Parse,A_LoopField,csv
			;~ resultLine.push(Trim(A_LoopField))
		;~ thisResult.lesions.push(resultLine)
	;~ }

	if(post="" ||  InStr(post, "Not found")){
		
		MsgBox % "No result found"
		return -1
	}
	try {
		thisResult.lesions:=jxon_load(post)
		thisResult.lesionCount:=thisResult.lesions.nodules.maxIndex()-1
	}catch, e {
		MsgBox % "Lung nodule result JSON error!"
		return -1
	}
	gui:=new ShowMagicResults(thisResult)
}


ToolTip:
ToolTip
return

;~ esc::
OnExit:
ExitApp

class ShowMagicResults {
	static Counter:=0
	static monitorInfo:=monitorInfo()
	__New(results, Show=true){
		local Counter, fn, x, y
		
		Counter:=++ShowMagicResults.Counter
		,this.guiName:=Counter
		gui,%Counter%:Default
		gui,Color,121212
		
		gui +hwndGuihwnd +ToolWindow -Caption +AlwaysOnTop +lastfound
		winset,TransColor,121212
		winset,Transparent,200
		gui,Font,s30 cWhite,Verdana
		this.guihwnd:=guihwnd
		,this.results:=results
		,this.lesionCount:=results.lesionCount
		,this.selectedInd:=""
		,this.lastSelected:=1
		,this.hideFn:=this.Hide.bind(this)
		,this.selectFn:=this.selectOnImage.bind(this)
		,this.selectLock:=false
		
		,this.nodules:=[]
		for k, result in results.lesions.nodules {
			if(k=1)
				continue
			i:=k-1
			
			this.nodules[i]:=result

			gui,Add,Text,% "xm vcheck" i,% "=>>"
			gui,Add,Text,% "yp x+10 vresult" i " hwndresulthwnd" i ,% this.padRight("SE: " results.lesions.SeriesNumber,10) "IM: " result[2]
			guicontrol,,check%i%,% "    "
			fn:=this.resultOnClick.bind(this)
			GuiControl +g,% resulthwnd%i%, % fn
		}
		
		;~ this.ScrollGUI:=ScrollGUI:=new ScrollGUI(guihwnd, 0, 500, "+ToolWindow -Caption +AlwaysOnTop", 2, 2)
		
		if(show){
			this.show()
		}
	}
	
	show(HideAfter=800){
		MouseGetPos,x,y
		gui,% this.guihwnd ":show", % "x" x+20 " y" y+20,% results.AccNo
		WinGetPos,x,y,w,h,% "ahk_id " this.guihwnd
		whichMonitor:=whichMonitor(x,y,monitorInfo).1
		if(x+w>ShowMagicResults.monitorInfo[whichMonitor].r)
			WinMove,% "ahk_id " this.guihwnd,,% ShowMagicResults.monitorInfo[whichMonitor].r-w
		if(y+h>ShowMagicResults.monitorInfo[whichMonitor].b)
			WinMove,% "ahk_id " this.guihwnd,,,% ShowMagicResults.monitorInfo[whichMonitor].b-h
		;~ this.ScrollGUI.show(this.results.AccNo, "x" x+20 " y" y+20)
		;~ , this.isShown:=true
		fn:=this.hideFn
		settimer,% fn,% HideAfter?(-1)*HideAfter:"off"
	}
	
	settimerOff(){
		fn1:=this.hideFn
		,fn2:=this.selectFn
		settimer,% fn1,Off
		settimer,% fn2,Off
	}
	
	scrollNext(){
		if this.selectLock || this.selectingImage
			return
		this.selectLock:=true
		,this.settimerOff()
		
		if(this.selectedInd="") ||  (++this.selectedInd > this.lesionCount)
			this.selectedInd:=1
		this.selectNodule(this.selectedInd, 500)
	}
	
	scrollPrior(){
		if this.selectLock || this.selectingImage
			return
		this.selectLock:=true
		,this.settimerOff()
		
		if(this.selectedInd="") || (--this.selectedInd < 1)
			this.selectedInd:=this.lesionCount
		
		this.selectNodule(this.selectedInd, 500)
	}
	
	selectNodule(selectedInd, delayed=false){
		;~ local fn1, fn2
		
		fn1:=this.hideFn
		,fn2:=this.selectFn
		
		if(delayed){
			if(!this.isShown)
				this.show(false)
			
			settimer,% fn1, Off
		}
		
		guicontrol,% this.guihwnd ":",% "check" this.lastSelected,% "     "
		guicontrol,% this.guihwnd ":",% "check" this.lastSelected:=this.selectedInd:=selectedInd,% "=>"
		settimer,% fn2,Off
		settimer,% fn2,% delayed?(-1)*delayed:-100
		
		if(delayed)
			settimer,% fn1,-800
		else
			this.hide(false)
		
		this.selectLock:=false
			
	}
	
	selectOnImage(){
		if(this.selectingImage)
			return
		this.selectingImage:=true
		,result:=this.nodules[this.selectedInd]
		;~ MsgBox % result[2]
		,SE:=this.results.lesions.SeriesNumber
		,IM:=result[2]
		
		
		gui,% this.guihwnd ":hide"
		this.isShown:=false
		Sleep 500
		
		MouseGetPos,,,win
		winget,ProcessName,ProcessName,ahk_id %win%
		if(ProcessName!="impax-client-main.exe"){
			frames:=getViewFrame()
			WinGetPos,x,y,w,h,% "ahk_id " frames[2,1,1]
			MouseMove,% Floor(x+w*2/3),% Floor(y+h/2),1
		}
		
		SEIM:=getSEIM()
		send {Alt Up}
		if(SEIM.1=SE)
			impaxSelectImage(IM, SE, {x: result[4], y: result[3]})
		else{
			impaxSelectImage(Floor(IM/5), SEIM.1, {x: result[4], y: result[3]})
			;~ ToolTip % "Thick slice"
			;~ settimer,ToolTip,-500
		}
		;~ ToolTip % SE "," IM
		this.selectingImage:=false
	}
	
	padRight(str, len, pad=" "){
		while StrLen(str)<len
			str.=" "
		return str
	}
	
	hide(checkOnWin=true){
		if(checkOnWin){
			MouseGetPos,,,win
			if(win=this.guihwnd){
				fn:=this.Hide.bind(this)
				settimer,% fn,-1000
				return
			}
		}
		;~ WinHide,% "ahk_id " this.ScrollGUI.hwnd
		gui,% this.guihwnd ":hide"
		this.isShown:=false
	}
	
	resultOnClick(){
		local selectedInd 
		while this.selectLock || this.selectingImage
			Sleep 100
		this.selectLock:=true
		,this.settimerOff()
		selectedInd:=RegExReplace(A_GuiControl, "\D", "")
		,this.selectNodule(selectedInd, false)
	}
	
	__Delete(){
		gui, % this.guihwnd ":destory"
		;~ this.ScrollGUI.Destroy()
	}
}