#include <portalLib>

askForPortalIdPw()
output:=RegExReplace(a_scriptname,".[^.]*$","") ".txt"
outputCSV:=RegExReplace(a_scriptname,".[^.]*$","") ".csv"

ex=
(
CT
OPD
4______ 6/7-6/13
4______ 6/7-6/11

IPD
5______ 6/13-6/14
5______ 6/13-6/14

ER
2______ 6/20 22:00-23:47
6______ 6/20 19:38-21:35

MR
OPD
4______ 6/6-6/6
6______ 6/6-6/10

IPD
6______ 6/20-6/23
3______ 6/20-6/21

ER
6______ 6/27 22:07-00:31
4______ 6/27 18:35-19:55
)


gui,font,s10,Verdana
gui,add,edit,w300 h600 vinput,% ex
gui,add,button,gGo,Go!
gui,add,edit,w300 disabled vinfo


gui,show,,病歷審查

return


Go:
guicontrol,disable,Go!
gui,submit,nohide
result:=""

if !checkSid(sid)
	sid:=login(loginId,loginPw)

modality:=""
csv:="病歷號,姓名,報告醫師`n"

loop,parse,input,`n
{
	if regexmatch(a_loopfield,"i)^CT"){
		modality:="CT with"
	}else if regexmatch(a_loopfield,"i)^MR"){
		modality:="MRI with"
	}
	if !regexmatch(a_loopfield,"^(\w{6}\d)[\s\t]+(?:(\d+)\/(\d+))?[^-]*-?\s*(?:(\d+)\/(\d+))?",match){
		result.=a_loopfield "`n"
		continue
	}
	
	guicontrol,,info,% "Searching: " chartNo:=match1
	if !match2
		examDate:=""
	else
        examDate:=(match2>a_mm?a_year-1:a_year) (strlen(match2)=1?"0":"") match2 (strlen(match3)=1?"0":"") match3
	
	if !match4
		reportDate:=""
	else
        reportDate:=(match4>a_mm?a_year-1:a_year) (strlen(match4)=1?"0":"") match4 (strlen(match5)=1?"0":"") match5
	
	
	EMR:=EMRViewerMobile(sid,chartNo)
	html:=regexreplace(EMR.getReport(modality,examDate,"影核醫",1,reportDate)[1],"is)PACS影像|顯示修改記錄","")
	result.=a_loopfield "`n" (text:=EMR.radReportText(html)) "----------------------------------------`n" 
	
	RegExMatch(text,"is)姓名 ([^\s]+).+報告醫師 ([^\s\n]+)",match)
	csv.=chartNo "," match1 "," match2 "`n"
		
}
tooltip
clipboard:=result:=RegExReplace(result,"\r\n|\n","`r`n")
if fileexist(output)
	FileDelete,% output
if !errorlevel
	fileappend,% result,% output,utf-8
if fileexist(outputCSV)
	FileDelete,% outputCSV
if !errorlevel
	fileappend,% csv,% outputCSV,utf-8

msgbox Finished!
guicontrol,,info,% ""
guicontrol,enable,Go!
return




guiclose:
;~ ~esc::
exitapp
return
