﻿﻿﻿/*



20130801



scsnake@gmail.com



*/







#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.



SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.



SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.



#SingleInstance,off



SetBatchLines, -1



coordMode,mouse,screen



coordMode,pixel,screen



coordMode,tooltip,screen



SetTitleMatchMode,2



SetControlDelay,-1



DetectHiddenWindows,on



ComObjError(false)



onexit,onexit







#include <portalLib>











askForPortalIdPw()











gui,+lastfound



guiHwnd:=winexist()



gui,font,s10,Verdana



gui,add,text,,Enter Chart No.:



gui,add,edit,vchartNos r5 w800, ;1______



gui,add,button,,Go!











gui,show,,OPD History Parser











return







ButtonGo!:



guicontrol,disable,Go!



gui,submit,nohide







;~ settimer,closeIE,200







if fileexist("total.html") {



	msgbox,4,,% "The file ""total.html"" already exists. Backup it ?"



	ifmsgbox,Yes



		filemove,total.html,% "total (backup " a_now ").html",1



}











FileDelete,total.html



htmlHead:="<meta charset=""utf-8""><style type=""text/css"">table,tr,td {border-collapse:collapse;border: solid 1px black}</style>"



FileAppend,% htmlHead,total.html,utf-8



totalCSV:="""病歷號"",""性別"",""生日年"",""生日月"",""生日日"",""姓名"",""門診日期"",""診斷"",""處方"",""醫令"",""年齡"",""帳號"",""院區"",""部門"",""主治醫師"",""Subjective"",""Objective"",""未來影像檢查排程"",""未來其他檢查排程"",""未來門診預約""`n"



tick:=0



loop,parse,chartNos,`,%a_tab%%a_space%`n



{



	if ((chartNo:=trim(a_loopfield))!=""){



		gosub parse







		if (OpdHtml!=""){



			tick:=101



			gosub save



		}



	}



}



guicontrol,enable,Go!



setTimer,closeIE,off



msgbox % "完成!"



return







closeIE:



ifwinexist,http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleInfoSh ahk_class IEFrame



	winclose



return



;1______,3______,3______,3______,4______,5______,5______,5______,5______



parse:



OpdHx:=[]



if !checksid(sid)



	sid:=login(loginId,loginPw)



personId:=patientBasicInfo(chartNo,sid).personId



webInfo:=patientBasicInfoWeb(chartNo,sid,personId)



OpdNewArr:=getNewOpdLinks(webInfo)



OpdOldArr:=getOldOpdLinks(webInfo)



if (!floor(OpdOldArr.list.maxIndex()))&&!(floor(OpdNewArr.list.maxIndex())) {



	fileappend,% a_now "," chartNo ",OPD history not available`n",getOPDdata.log,utf-8



	return



}







;3______



;~ if fileexist(fileName:=(chartNo ".html")) {



	;~ msgbox,4,,% "The file """ fileName """ already exists. Backup it ?"



	;~ ifmsgbox,Yes



		;~ filemove,% fileName,% chartNo " (backup " a_now ").html",1



;~ }







fileDelete,% fileName:=(chartNo ".html")



FileAppend,% htmlHead,% fileName,utf-8



fileappend,% "<table width=100% bgColor=yellow><td>" chartNo "</td></table>",total.html,utf-8







str:=""



for k,v in OpdNewArr.list



	str.="<a href=""#" a_index """>"  v  "</a><br/>"



for k,v in OpdOldArr.list



	str.="<a href=""#" (OpdNewArr.link.maxIndex()+a_index) """>"  v  "</a><br/>"







opdInd:=0



for k,v in OpdNewArr.link {



	opdInd:=k



	traytip,,% "Patient " chartNo " recent OPD - " a_index " / " opdNewArr.link.maxIndex()



	



	;4______



	



	while !httprequest(v,post:="",header:="","charset: utf-8`nNO_COOKIES") || !opd:=trim(extractNewOpdContents(post))



		if (a_index>10) {



			;~ msgbox



			traytip,,% "Oops, can't get opd data @@"""



			fileappend,% a_now "," chartNo ",Unable to get recent OPD data: `t" OpdNewArr.list[k] "`n",getOPDdata.log,utf-8



			break



		}else{



			sleep 1000



		}



	OpdHx.push(opd)



	if(opdInd=1){



		OpdHtml:="<table><tr><td width=20% rowspan=" floor(OpdOldArr.list.maxIndex())+floor(OpdNewArr.list.maxIndex()) " style=""vertical-align:top"">" str "</td><td><div width=100% style=""background:red;align:center""><a name=""#1"">1</a></div><br/><div>"  opd "</div><br/></td></tr>"



	}else{



		OpdHtml.="<tr><td><div width=100% style=""background:red;align:center""><a name=""" a_index """>" a_index "</a></div><br/><div>" opd "</div><br/></td></tr>"



	}



		



	gosub save



	



}















for k,v in OpdOldArr.link {



	traytip,,% "Patient " chartNo " old OPD - " a_index " / " opdOldArr.link.maxIndex()



	



	



	while !httprequest(v,post:="",header:="","charset: utf-8`nNO_COOKIES") || !opd:=trim(extractOldOpdContents(post))



		if (a_index>10) {



			;~ msgbox 



			traytip,,% "Oops, can't get opd data @@"""



			fileappend,% a_now "," chartNo ",Unable to get old OPD data (" OpdOldArr.list[k] ")`n",getOPDdata.log,utf-8



			break



		}else{



			sleep 1000



		}



		



	OpdHx.push(opd)



	if(opdInd=0){



		OpdHtml:="<table><tr><td width=20% rowspan=" floor(OpdOldArr.list.maxIndex())+floor(OpdNewArr.list.maxIndex()) " style=""vertical-align:top"">" str "</td><td><div width=100% style=""background:red;align:center""><a name=""#1"">1</a></div><br/><div>"  opd "</div><br/></td></tr>"



	}else{



		OpdHtml.="<tr><td><div width=100% style=""background:red;align:center""><a name=""" opdInd+a_index """>" opdInd+a_index "</a></div><br/><div>" opd "</div><br/></td></tr>"



	}



	



	gosub save



		



	



}















traytip







;~ FileAppend,% OpdHtml "</table>",% fileName,utf-8



;~ FileAppend,% OpdHtml "</table>",total - old OPD.html,utf-8



OpdHtml.="</table>"







return







save:



if((++tick)>100){



	FileAppend,% OpdHtml,% fileName,utf-8



	fileappend,% OpdHtml,total.html,utf-8



	OpdHtml:="",tick:=0



}







return







getOldOpdLinks(byref webInfo){



	global sid,personId



	i:=0,arr:=[],arr2:=[]



	while i:=regexmatch(webInfo,regex:="i)(http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleInfoShowUsingPlaceHolder\.aspx\?SESSION=" sid "&amp;Func=HistoryClinics&amp;AccountIDSE=([^&]+)&amp;PersonID=" personId "&amp;Hosp=&amp;WinPup=True&amp;Seed=(\d+))[^>]+>([^<]+)<\/a",match,i+1) {



		arr.push(RegExReplace(match1,"&amp;","&"))



		arr2.push(match4)



	}



	return {link:arr,list:arr2}



}











getNewOpdLinks(byref webInfo){



	global sid,personId



	i:=0,arr:=[],arr2:=[]



	dom:=comobjcreate("HtmlFile")



	dom.write(webInfo)



	



	loop % (a:=dom.getElementsByTagName("A")).length {



		if(instr(a[a_index-1].innerText,"N總院區門診")){



			div:=a[a_index-1].parentNode.parentNode.parentNode.parentNode.nextSibling



			break



		}



	}



	



	loop % (ele:=div.childNodes).length {



		if instr((e:=ele[a_index-1]).tagName,"TABLE")



			arr2.push(trim(e.innerText))



		else if instr(e.tagName,"DIV")



			arr.push(RegExReplace(e.getElementsByTagName("A")[0].href,"is)(.+)(http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleInfoShowUsingPlaceHolder\.aspx\?SESSION=" sid "&Func=Clinics&AccountIDSE=([^&]+?)&PersonID=&PatClass=O&Hosp=[^&]+?&WinPup=True&Seed=\d+)(.+)","$2"))



	}



	



	return {link:arr,list:arr2}



}















getNew:



OpdHx:=[]



if !checksid(sid)



	sid:=login(loginId,loginPw)



;~ chartNo:=chartNo



patientBasicInfoPage:=PatientBasicInfoPage(chartNo,sid)



if !OpdInfo:=getAllOpdInfo(patientBasicInfoPage,sid) {



	fileappend,% a_now ": OPD history not available for patient " chartno,getOPDdata.log,utf-8



	return



}



OpdHx.push(firstOpd:=getFirstOpd(OpdInfo,sid))



traytip,,% "Patient " chartNo " OPD - 1"







str:=""



for k,v in arr:=createMenu(firstOpd)



	str.="<a href=""#" a_index """>"  v  "</a><br/>"



OpdHtml:="<table><tr><td rowspan=" arr.maxIndex() " style=""vertical-align:top"">" str "</td><td><div width=100% style=""background:red;align:center""><a name=""#1"">1</a></div><br/><div>"  extractOpdContents(firstOpd) "</div><br/></td></tr>"















i:=0



loop,parse,keyCodeList,| 



{



	if ((++i)>1) {



		OpdHx.push(opd:=getMoreOpd(a_loopfield,sid,i-1))



		traytip,,% "Patient " chartNo " OPD - " i



		



		OpdHtml.="<tr><td><div width=100% style=""background:red;align:center""><a name=""" i """>" i "</a></div><br/><div>" (AAA:=extractOpdContents(opd)) "</div><br/></td></tr>"



	;~ }else if (i=2){



		;~ OpdHx.push(clipboard:=opd:=getSecondOpd(a_loopfield,sid))



		;~ traytip,,% "Patient " chartNo " OPD - " i



		



		;~ OpdHtml.="<tr><td><div width=100% style=""background:red""><a name=""" i """>" i "</a></div><br/><div>" (AAA:=extractOpdContents(opd)) "</div><br/></td></tr>"



	}



}



traytip







OpdHtml.="</table>"



totalHtml.="<table width=100% bgColor=yellow><td>" chartNo "</td></table>" OpdHtml



OpdHtml:=htmlHead OpdHtml



if fileexist(fileName:=chartNo ".html")



	FileDelete,% fileName



i:=1



if (errorlevel) 



	while fileexist(fileName:=(chartNo " (" i ").html"))



		i++



FileAppend,% OpdHtml,% fileName,utf-8







csv:=OpdHxArrToCSV(OpdHx,chartNo)



totalCSV.=RegExReplace(csv,"is)^.+?`n")



if fileexist(fileName:=chartNo ".csv")



	FileDelete,% fileName



i:=1



if (errorlevel) 



	while fileexist(fileName:=(chartNo " (" i ").csv"))



		i++



FileAppend,% csv,% fileName,utf-8











FileDelete,total.html



FileAppend,% totalHtml,total.html,utf-8



FileDelete,total.csv



FileAppend,% totalCSV,total.csv,utf-8











return







createMenu(byref html){



	dom:=ComObjCreate("HtmlFile")



	dom.write(html)



	



	arr:=[]



	loop % (table:=$(dom,"PanelTreeView").getElementsByTagName("TABLE")).length 



		arr.push(trim(table[a_index-1].innerText))



	



	return arr







}







extractOpdContents(byref html){



	RegExMatch(html,"is)<div class=""?reportQuery""?>(.+?)<\/div>",match)



	return trim(regexreplace(match1," cellSpacing=""?1""? cellPadding=""?1""? "," "))



}



extractOldOpdContents(byref html){



	;~ RegExMatch(html,"is)<div id=""?UpdatePlaceHolderShowContent""?>(.+)<\/div>",match)



	dom:=ComObjCreate("HtmlFile")



	dom.write(html)



	return trim(removeTableSpacing($(dom,"UpdatePlaceHolderShowContent").getElementsByTagName("P")[0].innerHTML))



	



}



extractNewOpdContents(byref html){



	;~ RegExMatch(html,"is)<div id=""?UpdatePlaceHolderShowContent""?>(.+)<\/div>",match)



	dom:=ComObjCreate("HtmlFile")



	dom.write(html)



	return trim(removeTableSpacing($(dom,"UpdatePlaceHolderShowContent").firstChild.firstChild.firstChild.childNodes[2].firstChild.innerHTML))



	



}







removeTableSpacing(html){



	return RegExReplace(html,"i)(border=""?1""?)|(cellSpacing=""?1""?)|(cellPadding=""?1""?)"," ")



}



getFirstOpd(byref OpdInfo,sid){



	global __VIEWSTATE,__EVENTVALIDATION,keyCodeList



	



	if !keyCodeList:=get(OpdInfo,"KeyCodeList","name","value")



		return



	



	KeyNameList:=get(OpdInfo,"KeyNameList","name","value")



	AccountIDSE:=get(OpdInfo,"AccountIDSE","name","value")



	



	url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleInfoShowUsingPlaceHolder.aspx?SESSION=" sid



	



	header:="Accept: */*`nReferer: http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/PatientMedicalRecordListQuery.aspx?QueryBySelf=N&SESSION=" sid "`nAccept-Language: zh-tw`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; BTRS105843; GTB7.4; SIMBAR={170CCC21-65EC-11E2-B538-FEB49644ABDD}; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: ihisaw.hospital-n.local`nConnection: Close`nPragma: no-cache"



	



	post:="KeyCodeList=" encodeurl(keyCodeList) "&KeyNameList=" encodeurl(KeyNameList) "&AccountIDSE=" encodeurl(AccountIDSE) "&Func=Clinics"



	



	httprequest(url,post,header,"charset: utf-8`n+NO_COOKIES")



	__VIEWSTATE:=get(post,"__VIEWSTATE")



	__EVENTVALIDATION:=get(post,"__EVENTVALIDATION")



	



	return post



	



	



}







getSecondOpd(keycode,sid,choosenIndex){



	global __VIEWSTATE,__EVENTVALIDATION,keyCodeList



	



	url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleInfoShowUsingPlaceHolder.aspx?SESSION=" sid



	



	header:="Accept: */*`nAccept-Language: zh-tw`nReferer: " url "`nx-microsoftajax: Delta=true`nContent-Type: application/x-www-form-urlencoded; charset=utf-8`nCache-Control: no-cache`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; BTRS105843; GTB7.4; SIMBAR={170CCC21-65EC-11E2-B538-FEB49644ABDD}; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nHost: ihisaw.hospital-n.local`nConnection: Close`nPragma: no-cache"



	



	str:=""



	loop,parse,keyCodeList,|



		str.="n"



	



	post:="ScriptManager1=UpdatePlaceHolderShowContent%7CTreeViewItem&TreeViewItem_ExpandState=" str "&TreeViewItem_SelectedNode=TreeViewItemt" choosenIndex "&__EVENTTARGET=TreeViewItem&__EVENTARGUMENT=" encodeurl("s" keyCode) "&TreeViewItem_PopulateLog=&__VIEWSTATE=" encodeurl(__VIEWSTATE) "&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION) "&HiddenFieldFunctionCategory=Clinics&__ASYNCPOST=true&"



	



	httprequest(url,post,header,"charset: utf-8`n+NO_COOKIES")



	RegExMatch(post,"is)<table.+</table>",match)



	__VIEWSTATE:=RegExReplace(post,"is).+__VIEWSTATE\|([^\|]+).+","$1")



	__EVENTVALIDATION:=RegExReplace(post,"is).+__EVENTVALIDATION\|([^\|]+).+","$1")



	return match



	



}











getMoreOpd(keycode,sid,choosenIndex){



	global __VIEWSTATE,__EVENTVALIDATION,keyCodeList



	



	url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleInfoShowUsingPlaceHolder.aspx?SESSION=" sid



	



	header:="Accept: */*`nAccept-Language: zh-tw`nReferer: " url "`nx-microsoftajax: Delta=true`nContent-Type: application/x-www-form-urlencoded; charset=utf-8`nCache-Control: no-cache`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nHost: ihisaw.hospital-n.local`nConnection: Close`nPragma: no-cache"



	



	str:=""



	loop,parse,keyCodeList,|



		str.="n"



	



	post:="ScriptManager1=UpdatePlaceHolderShowContent%7CTreeViewItem&HiddenFieldFunctionCategory=Clinics&__EVENTTARGET=TreeViewItem&__EVENTARGUMENT=" encodeurl("s" keyCode) "&__VIEWSTATE=" encodeurl(__VIEWSTATE) "&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION) "&TreeViewItem_ExpandState=" str "&TreeViewItem_SelectedNode=TreeViewItemt" choosenIndex "&TreeViewItem_PopulateLog=&__ASYNCPOST=true&"



	



	httprequest(url,post,header,"charset: utf-8`n+NO_COOKIES")



	RegExMatch(post,"is)<table.+</table>",match)



	__VIEWSTATE:=RegExReplace(post,"is).+__VIEWSTATE\|([^\|]+).+","$1")



	__EVENTVALIDATION:=RegExReplace(post,"is).+__EVENTVALIDATION\|([^\|]+).+","$1")



	return match



	



}







getAllOpdInfo(byref patientBasicInfoPage,sid){



	global __VIEWSTATE,__EVENTVALIDATION



	



	if !firstOpd:=get(patientBasicInfoPage,"NWeb1_PatAccountListRecord1_GridViewOutPatRecord_ctl02_ShowMedicalRecord","id","name")



		return 



	



	chartNo:=get(patientBasicInfoPage,"NWeb1\$PatientBasicInfoQueryByIDAndName1\$ctl01","name","value")



	personId:=get(patientBasicInfoPage,"NWeb1_PatAccountListRecord1_personidHidden")



	



	



	url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/PatientMedicalRecordListQuery.aspx?QueryBySelf=N&SESSION=" sid



	



	header:="Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/msword, application/xaml+xml, application/vnd.ms-xpsdocument, application/x-ms-xbap, application/x-ms-application, */*`nReferer: " url "`nAccept-Language: zh-tw`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; BTRS105843; GTB7.4; SIMBAR={170CCC21-65EC-11E2-B538-FEB49644ABDD}; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: ihisaw.hospital-n.local`nConnection: Close`nPragma: no-cache"



	



	post:="scrollLeft=&scrollTop=&__EVENTTARGET=&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATE=" encodeurl(__VIEWSTATE) "&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION) "&NWeb1%24PatientBasicInfoQueryByIDAndName1%24ctl00=&NWeb1%24PatientBasicInfoQueryByIDAndName1%24ctl01=" chartNo "&NWeb1%24PatientBasicInfoQueryByIDAndName1%24ctl02=&NWeb1%24PatAccountListRecord1%24personidHidden=" personId "&" encodeurl(firstOpd) "=%E7%97%85"



	



	httprequest(url,post,header,"charset: utf-8`n+NO_COOKIES")



	__VIEWSTATE:=get(post,"__VIEWSTATE")



	__EVENTVALIDATION:=get(post,"__EVENTVALIDATION")



	



	return post







	



}







PatientBasicInfoPage(chartNo,sid){



	if !checkSid(sid)



		return []



	



	while strlen(chartNo)<7



		chartNo:="0" chartNo



	



	if !regexmatch(chartNo,"(\w)\w{5}\d")



		return



	



	global portalAspId,__VIEWSTATE,__EVENTVALIDATION



	



	httprequest(url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/PatientMedicalRecordListQuery.aspx?QueryBySelf=N&SESSION=" sid,html:="")



	



	header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nReferer: http://portal/General/Login.aspx`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; InfoPath.2; .NET4.0C; .NET4.0E)`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: ihisaw.hospital-n.local`nConnection: Close`nPragma: no-cache"



	



	post:="__VIEWSTATE=" encodeurl(get(html,"__VIEWSTATE")) "&__EVENTVALIDATION=" encodeurl(get(html,"__EVENTVALIDATION")) "&NWeb1%24PatientBasicInfoQueryByIDAndName1%24ctl01=" chartNo "&NWeb1%24PatientBasicInfoQueryByIDAndName1%24ctl05=%E6%9F%A5%E8%A9%A2"



	



	httprequest(url,post,header,"charset: utf-8`n+NO_COOKIES")



	__VIEWSTATE:=get(post,"__VIEWSTATE")



	__EVENTVALIDATION:=get(post,"__EVENTVALIDATION")



	return post



	



	



}











guiclose:



;~ ~esc::



msgbox,4,,Exit?



IfMsgBox,yes



	exitapp



return







onexit:



exitapp



return







~^c::



if !(a_priorhotkey=a_thishotkey && a_timesincepriorhotkey<500)



	return



ind:=0,copied:=clipboard,match:="1",str:=""



while ind:=regexmatch(copied,"\w{6}\d",match,ind+strlen(match))



	str.="," match  



if str=



	return



guicontrolget,v,,chartNos



guicontrol,,chartNos,% trim(v)=""?substr(str,2):(v str)



tooltip,% "Chart No Copied!"



settimer,tooltip,-1000



return















tooltip:



ToolTip



return







#ifwinactive,OPD History Parser ahk_class AutoHotkeyGUI



^v::



ind:=0,copied:=clipboard,match:="1",str:=""



while ind:=regexmatch(copied,"\w{6}\d",match,ind+strlen(match))



	str.="," match  



if str=



	return



guicontrolget,v,,chartNos



guicontrol,,chartNos,% trim(v)=""?substr(str,2):(v str)



return



#IfWinActive



