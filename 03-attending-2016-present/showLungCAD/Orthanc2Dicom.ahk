#include <hash>
;~ #include <risimpax>

setbatchlines,-1

param:=[]
loop %0% {
	param.push(%a_index%)
}

for k,v in param
	if RegExMatch(v,"i)^[TY]\w{9}\d$")
		AccNo:=v
	else if regexmatch(v,"^\w{6}\d$")
		ChartNo:=v

ip:="http://10.0.0.100:8042/"
;~ ip:="http://localhost:8042/"
gosub getDicom

return


getDicom:


chartNo:="0______"
AccNo:="T__________"
httprequest(url:=ip "patients/" SHA1dash(chartNo),post:="",header:="","charset: utf-8")
if !post
	goto fail

try{
	patient:=json_from(post)
}catch{
	goto fail
}

foundStudy:=0
for k,v in patient.studies {
	httprequest(url:=ip "studies/" v,post:="",header:="","charset: utf-8")
	if !post
		continue
	try {
		study:=json_from(post)
	}catch{
		continue
	}
	if(study.MainDicomTags.AccessionNumber=AccNo){
		foundStudy:=1
		break
	}
}

if(!foundStudy)
	goto fail

foundSeries:=0
for k,v in study.series {
	httprequest(url:=ip "series/" v,post:="",header:="","charset: utf-8")
	if !post
		continue
	try {
		series:=json_from(post)
	}catch{
		continue
	}
	if(series.Instances.maxindex()>200){
		foundSeries:=1
		break
	}

}

if !foundSeries
	goto fail

FileCreateDir,% dir:= a_scriptdir "\" ChartNo " " AccNo
;~ for k,v in series.Instances {
	URLDownloadToFile,% ip "series/" series.ID "/archive",% zip:=a_scriptdir "\" ChartNo " " AccNo ".zip"
;~ }
unzip(zip, a_scriptdir "\" ChartNo " " AccNo )
filedelete,% zip
SetWorkingDir,% a_scriptdir "\" ChartNo " " AccNo 
loop,*.dcm,0,1 
	filemove,% A_LoopFileFullPath,% a_scriptdir "\" ChartNo " " AccNo
loop,*,1,0
	if instr(fileexist(A_LoopFileFullPath),"D")
		FileRemoveDir,% A_LoopFileFullPath,1

;~ if post
	;~ clipboard:=url:=ip "web-viewer/app/viewer.html?series=" json_from(post).series.1
;~ else 
	;~ goto fail
;~ ifwinexist,ahk_class Chrome_WidgetWin_1
	;~ WinActivate
;~ else ifwinexist,ahk_class MozillaWindowClass
	;~ winactivate
;~ winwaitactive,,,2
;~ send !d
;~ sleep 100
;~ send ^v
;~ sleep 100
;~ send {enter}
return

fail:
msgbox,,,Failed!,3
return

SHA1dash(str){
	str:=SHA(str)
	stringlower,str,str
	return substr(str,1,8) "-" substr(str,9,8) "-" substr(str,17,8) "-" substr(str,25,8) "-" substr(str,33,8)
}

unzip( source, outdir )
	{
	objShell := ComObjCreate( "Shell.Application" )
	objSource := objShell.NameSpace( source ).Items()
	objTarget := objShell.NameSpace( outdir )
    ;~ https://msdn.microsoft.com/en-us/library/windows/desktop/bb787866(v=vs.85).aspx
	intOptions = 256 + 128
	objTarget.CopyHere(objSource, intOptions)
	ObjRelease( objShell )
	}

fill0(s,n=2){
	if(s="")
		return
	while strlen(s)<n
		s:="0" s
	return s
}

^!q::
exitapp
return