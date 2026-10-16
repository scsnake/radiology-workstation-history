﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,force
SetBatchLines, -1
coordMode,mouse,screen
coordMode,pixel,screen
coordMode,tooltip,screen
SetTitleMatchMode,2
setformat,float,0.2
SetControlDelay,-1

#include <PortalLib>
ComObjError(false)
;~ #Include ../COM.ahk
ComObjError(0)

askForPortalIdPw()
sid:=Login(loginId,loginPw)

examDate:=""
Today:=a_now
Today+=1, Day
FormatTime,defaultDate,% Today,yyyy/M/d
while !RegExMatch(examDate,"^\d{4}\/\d{1,2}\/\d{1,2}$")
	inputbox,examDate,Enter ICT date,date form example: 2000/1/1,,,,,,,,% defaultDate
if errorlevel
	exitapp


gosub RISpage

patients:=[]
;~ clipboard:=pwb.document.documentElement.innerHTML


if !$(pwb,"NWeb1_grvPatientOrderList").id
{
	msgbox % examdate "沒有檢查"
	reload
}

patients:=[]
Loop % pwb.document.getElementById("NWeb1_grvPatientOrderList").getElementsByTagName("TR").length-1
{
	k:=a_index
	patients[k]:=[]
	patients[k].chartNo:=pwb.document.getElementById("NWeb1_grvPatientOrderList").getElementsByTagName("TR")[k].getElementsByTagName("TD")[5].innerText
	patients[k].orderName:=pwb.document.getElementById("NWeb1_grvPatientOrderList").getElementsByTagName("TR")[k].getElementsByTagName("TD")[10].innerText
}
for k,v in patients
{
	html:=patientBasicInfo(v.chartNo,sid)
	info:=parsePatientBasicInfo(html)
	patients[k].BW:=getPatientBWBH(info.personId,sid).BW
	patients[k].BH:=getPatientBWBH(info.personId,sid).BH
}

gosub generateHTML


return

RISpage:
COM_AtlAxWinInit()
Gui,+LastFound +Resize
winget,GUIhwnd,id
;pwb := COM_AtlAxGetControl(COM_AtlAxCreateContainer(WinExist(),top,left,width,height, "Shell.Explorer") )  ;left these here just for reference of the parameters
pwb := COM_AtlAxGetControl(COM_AtlAxCreateContainer(WinExist(),0,0,a_screenwidth,a_screenheight-100, "Shell.Explorer") )
;http://msdn.microsoft.com/en-us/library/microsoft.visualstudio.ole.interop.ioleinplaceactiveobject(VS.80).aspx
IOleInPlaceActiveObject_Interface:="{00000117-0000-0000-C000-000000000046}"
pipa := COM_QueryInterface(pwb, IOleInPlaceActiveObject_Interface)
OnMessage(WM_KEYDOWN:=0x0100, "WM_KEYDOWN") 
OnMessage(WM_KEYUP:=0x0101, "WM_KEYDOWN") 

gui,show,maximize

pwb.Navigate("http://hisaw.hospital-n.local/WebApplication/Radiology/RISPatientRegistration.aspx?SESSION=" sid)
loop
	sleep 200
until !pwb.busy && getElements(pwb,"NWeb1_ddlUnitList")

;~ js=javascript:function $(a){return document.getElementById(a);}$('NWeb1_ddlUnitList').selectedIndex=9;$('NWeb1_txbQueryStartDate').value="%examDate%";$('NWeb1_btnQueryBySchedule').click();void 0;
;~ pwb.Navigate(js)
pwb.document.getElementById("NWeb1_ddlUnitList").selectedIndex:=9
pwb.document.getElementById("NWeb1_txbQueryStartDate").value:=examDate
pwb.document.getElementById("NWeb1_btnQueryBySchedule").click()

loop
	sleep 200
until !pwb.busy && !stillLoading(pwb)

return

generateHTML:
html:="<html> <head> <meta http-equiv=""content-type"" content=""text/html;charset=UTF-8"" /> <style type=""text/css""> * {font-family: Verdana, ""標楷體"", DFKai-sb;margin:0;padding:0;border:none;} table {border-collapse: collapse;} thead {font-size: 18px; display: table-header-group;} .row1 {font-size: 14px; } td {height:50px;border: solid 1px; text-align:center; }  </style> </head> <body> <table width=""100%"" align=""center""> <thead style=""vertical-align: center""> <tr> <td colspan=""14"" style=""text-align:left"">Coronary CTA 登記表　　　<span style=""font-size: 10px"">IV cath位置：1:R cubital, 2:L cubital, 3:R forearm, 4:L forearm, 5:R hand, 6:L hand</span></td> </tr> <tr class=""row1""> <td>日期</td> <td>病歷號</td> <td>cath #</td> <td>cath位置</td> <td>身高</td> <td>體重</td> <td>HR</td> <td>Flow rate(ml/s)</td> <td colspan=""2"">Second phase(s)</td> <td colspan=""2"">Scan delay(s)</td> <td>放射師</td> <td>住院醫師</td>  </tr>  </thead> <tbody style=""vertical-align: top""> "

patientIndex=0
patientsPerPage=11

for k,v in patients
{
	if !(instr(v.orderName,"Coronary CT Angiography") || instr(v.orderName,"CT-Coronary Calcium Score"))
		continue
	html.="<tr> <td width=""10%"">" examDate "</td> <td width=""10%"">" v.chartNo "</td> <td width=""5%"">20</td> <td width=""5%""></td> <td width=""8%"">" v.BH "</td> <td width=""6%"">" v.BW "</td> <td width=""6%""></td> <td width=""6%""></td> <td width=""9%"" style=""text-align: right"">　　 -7-　　=</td> <td width=""4%""></td> <td width=""7%"" style=""text-align: right"">　　 +10=</td> <td width=""4%""></td> <td width=""10%"">戴美華</br>張芳慈</td> <td width=""10%""></td></tr>"
	patientIndex++
}

loop % patientsPerPage-mod(patientIndex,patientsPerPage)
	html.="<tr> <td width=""10%""></td> <td width=""10%""></td> <td width=""5%""></td> <td width=""5%""></td> <td width=""8%""></td> <td width=""6%""></td> <td width=""6%""></td> <td width=""6%""></td> <td width=""9%"" style=""text-align: right""></td> <td width=""4%""></td> <td width=""7%"" style=""text-align: right""></td> <td width=""4%""></td> <td width=""10%""></td> <td width=""10%""></td></tr>"


html.="</tbody> </table> </body>    </html>"
StringReplace,examDate,examDate,`/,-,a
filedelete,% a_scriptdir "\Table-" examDate ".html"
FileAppend,%html%,%a_scriptdir%\Table-%examDate%.html,utf-8
traytip,,Finished!,5
run %a_scriptdir%\Table-%examDate%.html
gui,destroy
sleep 5000
exitapp
return

~!q::
exitapp
return
