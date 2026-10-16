#persistent
;~ #notrayicon
setbatchlines,-1
#include <portallib>
#include <risimpax>
#SingleInstance,ignore
DetectHiddenWindows,on

if !winexist("ahk_exe PacsIE.exe") {
	hotkey,~!#q,onexit	
}

reportList:=[]
reportListCount:=parseDataGrid(controlexist(RisListHwnd)?RisListHwnd:(RisListHwnd:=getRisList(RisState[2])),reportList, 0, 1)
for k,v in reportList[1] {
	if (v="照會單號") {
		AccNoCol:=k
	}
	if (v="病歷號") {
		chartNoCol:=k
	}
	if (v="檢查名稱") {
		examNameCol:=k
	}
	if (v="狀態") {
		statusCol:=k
	}
	if (v="檢查日") {
		examDateCol:=k
	}
	
}
settimer,getAllReportList,-1
;~ loadedPicCount:=criticalobject(" (&loadedPicCount) ")
;~ thisStudyInd:=2
reportDir:=a_mydocuments "\feedRIS"
monitors:=monitorInfo()
PicWidth:=monitors[2].w-6
loginId:=loginId, loginPw:=loginPw
if !PacsWebLogin(loginId,loginPw) {
	MsgBox, 8256, ,% "Can not log in PacsWeb!"
	exitapp
}
i:=2
;~ settimer,routine,1000
sleep 1000
loop {
	thisStudy:=reportList[i]
	AccNo:=reportList[i,AccNoCol],chartNo:=reportList[i,chartNoCol],examName:=reportList[i,examNameCol]
	if(i>reportListCount){
		exitapp
	}else if (AccNo!="" && chartNo!="") {
		;~ msgbox % fileexist(reportDir "\" AccNo " " chartNo "\" AccNo " " chartNo " 1.jpeg")
		if !fileexist(reportDir "\" AccNo " " chartNo "\" AccNo " " chartNo " 1.jpeg") {
			; tooltip `% "downloading:" AccNo "," chartNo "," reportDir " " loginId loginPw 
			; PacsWebDownloadJpeg(AccNo,chartNo,"",reportDir,PicWidth,loginId,loginPw)
			output:=PacsWebInfoFlatten(PacsWebInfo(output,AccNo,chartNo,loginId,loginPw))
			;~ loadedPicCount[AccNo " " chartNo]:=output.maxindex()
			max:=output.maxindex()
			for k,v in output {
				PacsWebDownloadJpeg2(v.url,AccNo,chartNo,AccNo " " chartNo " " k ".jpeg",reportdir "\" AccNo " " chartNo,PicWidth,loginId,loginPw)
				if !winexist("ahk_exe PacsIE.exe") {
					traytip,% "Downloaded: " k "/" max " images (" (i-1) "/" (reportListCount-1) " studies)"
					settimer,traytip,-2000
				}
				sleep 2000
			}
			
		}
		
		if(monitors.maxindex()>2){
			anyPriorImage:=0
			loop % reportDir "\" AccNo " " chartNo "\* " chartNo " 1.jpeg"
				if regexmatch(a_loopfilename,"(\w+) \w+ 1\.jpeg",match) && (match1!=AccNo) {
					anyPriorImage:=1
					oldAccNo:=match1
					break
				}
			
			if (!anyPriorImage && regexmatch(thisStudy[examNameCol],"is)(Chest.*(AP|PA))|(Chest.*Lateral)")){
				
				for k,v in PacsHx:=PacsWebQuery(chartNo)
					if relatedExam(v.ExamName,examName) && (regexreplace(v.ExamDate,"\D","")<regexreplace(thisStudy[examDateCol],"\D","")) {
						;~ WBp[thisGuiInd].Navigate("about:blank")
						;~ WBp[thisGuiInd].Navigate(PacsWebUrl(v.AccessNo,thisStudy[chartNoCol],loginId,loginPw))
						anyPriorImage:=1,oldAccNo:=v.AccessNo
						if !fileexist(reportDir "\" accno " " chartNo "\" oldAccNo " " chartNo " 1.jpeg") {
							output:=PacsWebInfoFlatten(PacsWebInfo(output, oldAccNo,chartNo,loginId,loginPw))
							loadedPicCount[ oldAccNo " " chartNo ]:=output.maxindex()
							max:=output.maxindex()
							for q,r in output {
								PacsWebDownloadJpeg2(r.url,oldAccNo,chartNo,oldAccNo " " chartNo " " q ".jpeg",reportdir "\" AccNo " " chartNo,PicWidth,loginId,loginPw)
								if !winexist("ahk_exe PacsIE.exe") {
									traytip,% "Downloaded: " k "/" max " old images (" (i-1) "/" (reportListCount-1) " studies)"
									settimer,traytip,-2000
								}
								sleep 2000
							}
							;~ PacsWebDownloadJpeg(oldAccNo,chartNo,"",reportDir,thisMonitor.w-6,loginid,loginpw)
						}
						
						break
					}
			}
		}
		
		
		
		++i
	}else{
		sleep 2000
	}
	
	if(leave)
		exitapp
	
}
leave:=1
exitapp
return

relatedExam(exam,thisExam){
	if (exam=thisExam)
		return 1
	else if regexmatch(exam,"is)chest\b.+?view") && regexmatch(thisExam,"is)chest\b.+?view")
		return 1
	
	return 0
}

getAllReportList:
parseDataGrid(RisListHwnd,reportList)
return

traytip:
TrayTip
return

;~ routine:
;~ ifwinnotexist,ahk_exe PacsIE.exe
	;~ exitapp
;~ return
onexit:
if (++leave>1){
	;~ winclose,ahk_exe PacsIE.exe
	exitapp
}else{
	sleep 5000
	;~ winclose,ahk_exe PacsIE.exe
	exitapp
}
return