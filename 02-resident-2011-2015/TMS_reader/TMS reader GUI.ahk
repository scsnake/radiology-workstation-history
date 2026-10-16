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
#Persistent
#include <portalLib>
#include <Class_CTLCOLORS>
comobjerror(false)
onexit,exit


;~ MsgBox %0%1% %2% %3% %4%
if %0% 
{
	; param: id pw courseId1 courseId2 ...
	param:=[]
	Loop %0%
		v:=%a_index%
		,param.push(v)
	if (param.maxindex()>2){
		paramMode:=true
		,loginId:=param[1]
		,loginPw:MOCK_PASSWORD
	}
}

if(!paramMode){
	loop {
		loop {
			inputbox,loginId,TMS reader,輸入 TMS ID,,200,180,,,,,% loginId?loginId:""
			if errorlevel=1
				exitapp
		}until loginId!=""
		loop {
			inputbox,loginPw,TMS reader,輸入 TMS 密碼,hide,200,180
			if errorlevel=1
				exitapp
		}until loginPw!=""
	} until checkTMSaccount(loginId,loginPw)
;~ loginId:="000000"
;~ loginPw:MOCK_PASSWORD"mgpsnz4246"
;~ checkTMSaccount(loginId,loginPw)
}else{
	checkTMSaccount(loginId, loginPw)
}

courseArr:=[]
;134171,134166,134160,134114,134067,133699
;~ courseArr:=[134171,134166,134160,134114,134067,133699]
;~ courseArr:=[134430]

if ! phpId
	if ! phpId:=getTmsPhpId() {
		msgbox Cannot get php ID !
		exitapp
	}

cookie:="PHPSESSID=" phpId "; cookie_account=" loginId "; cookie_passwd=" md5(loginPw)
,cookieJS:="javascript:document.cookie='PHPSESSID=" phpId "';document.cookie='cookie_account=" loginId "';document.cookie='cookie_passwd=" md5(loginPw) "';void 0;"


	
if(!paramMode){
	linkTMSpage("http://edu.hospital-n.local/home.php")

	Gui +LastFound +OwnDialogs +AlwaysOnTop
	loop {
		inputbox,courseList,TMS reader,% "輸入 TMS 課程編號`n`n手動輸入：以逗號分隔`n或`n選取課程編號後按Ctrl + c + c (快按兩次c)",,320,280
		if errorlevel=1
			exitapp
	}until courseList!=""
	loop,parse,courseList,`,
		if (id:=trim(a_loopfield))!=""
			courseArr.push(id)
}else{
	for k,v in param
		if(k>2)
			courseArr.push(v)
}

;~ clipboard:=httprequestTMS("http://edu.hospital-n.local/course.php?courseID=85671",cookie)
;~ exitapp


;~ readCourseItem(TMScookie,"http://edu.hospital-n.local/course.php?courseID=85133&f=doc&cid=6839&rnd=290-1360676142",1/60)


;~ return




readingPool:=[],courses:=[]
readCourse(cookie,courseArr)

gui,+lastfound -alwaysontop
guiHwnd:=winexist()
gui,font,s10,Verdana
gui,add,text,gopenCourseList,Course List


gosub listCourse
gui,Add,button,xm gcopyCourseId,Copy IDs
gui,Add,button,yp x+10 greloadAll,Reload All
gui,show,% "autosize",% "TMS reader - " loginId
setTimer,updateList,6000
tick=0
gosub updateList

return

copyCourseId:
str:=""
for k,v in courseArr
	str.=v ","
clipboard:=SubStr(str,1,-1)
return

ReloadAll:
str:=loginId " " loginPw " "
for k,v in courseArr
	str.= v " "
run,% """" A_ScriptFullPath """ " SubStr(str,1,-1) 
ExitApp
return

#ifwinexist,TMS reader ahk_class #32770,輸入 TMS 課程編號
~^c::
ifwinactive,TMS reader ahk_class #32770,輸入 TMS 課程編號
	return
if !(a_priorhotkey=a_thishotkey && a_timesincepriorhotkey<500)
	return
clipboardTxt:=Clipboard
,newList:=""
Loop,parse,clipboardTxt,`n
	if RegExMatch(A_LoopField, "\d+", match)
		newList.= match ","
if(newList="")
	return
controlgettext,courseIdList,Edit1,TMS reader ahk_class #32770,輸入 TMS 課程編號
courseIdList:=RegExReplace(courseIdList, "\,+$", "") 
courseIdList.=(courseIdList=""?"":",") SubStr(newList, 1, -1)

controlsettext,Edit1,% courseIdList,TMS reader ahk_class #32770,輸入 TMS 課程編號
tooltip,% "已加入課程：" SubStr(newList, 1, -1)
settimer,tooltip,-2000
return
#ifwinexist


openCourseList:
linkTMSpage("http://edu.hospital-n.local/home.php?f=my&m=course")
return

listCourse:
rowHeight:=25
colWidth:=array(300,300,30)
ind=0
for k,v in courseArr {
	ind:=a_index
	gui,add,text,% "vt" ind "_0 xs yp+" rowHeight,% "" (strlen(k)<2?"  " k:" " k) ")"
	gui,add,text,% "vt" ind "_4 x+10 yp" " h" rowHeight " hwndHwnd" ind " gshowCourseInfo",% "  000000"
	gui,add,edit,% "vt" ind "_1 readonly -wrap x+10 yp h" rowHeight " w" colWidth[1] " h" rowHeight,
	gui,add,progress,% "vt" ind "_2 x+10 yp w" colWidth[2] " h" rowHeight/1.5,50
	gui,add,text,% "vt" ind "_5 yp xp w" colWidth[2] " +BackgroundTrans +Center +cRed",% "00.0%"
	gui,add,button,% "vt" ind "_3 x+10 yp w" colWidth[3] " h" rowHeight " gopenCourse",開
	gui,add,button,% "vt" ind "_6 x+5 yp w" colWidth[3] " h" rowHeight " gfillQuest",卷
	;~ gui,add,edit,% "vt" ind "_4 x+0 readonly -wrap yp w0 h" rowHeight,
	
}
return

showCourseInfo:
GuiControlGet,thisCourseId,,% A_GuiControl
showInfo("" thisCourseId)
return

showInfo(courseId){
	global courses
	course:=courses["ID" courseId]
	,str:=""
	for k,v in course
		if k is Integer
			str.="(" v.Type ") " v.name (v.pass?" - PASS!":"") "`n"
	ToolTip % str
	settimer,ToolTip,-5000
}

openCourse:
RegExMatch(a_guicontrol,"t(\d+)_(\d+)",match)
pwb:=ComObjCreate("InternetExplorer.Application")
guicontrolget,tmp,,% "t" match1 "_4"
if (tmp)
	linkTMSpage("http://edu.hospital-n.local/course.php?courseID=" tmp)
return

fillQuest:
RegExMatch(a_guicontrol,"t(\d+)_(\d+)",match)
fillQuest1:
guicontrolget,tmp,,% "t" match1 "_4"
fillQuest(cookie,courses["ID" tmp], match1)
;~ SetTimerFn("updateReadingPool",-1)
return

updateReadingPool(){
	global readingPool,cookie
	for k,v in readingPool {
		if checkCourseStatus(cookie,v.courseId).pass {
			readingPool[k,"pass"]:=1
			CTLCOLORS.Change(hwnd%k%,"green")
		}
			
	}
		
}


showProgress:
RegExMatch(a_guicontrol,"t(\d+)_(\d+)",match)
v:=readingPool[match1]
tooltip,% (((v.hasRead+tick)/v.passTime)<=1?(v.hasRead+tick):v.passTime) " / " v.passTime " min"
return

updateList:
ind:=0
for k,v in readingPool {
	if(courses["ID" v.courseId].pass)
		continue
	ind++
	guicontrol,,t%ind%_1,% v.name
	setformat,float,0.1
	if (((v.hasRead+tick)/v.passTime)<=1){
		courseProgress:=(v.hasRead+tick)/v.passTime*100
		Loop 7 {
			guicontrol,enable,% "t" ind "_" A_Index-1
			guicontrol,show,% "t" ind "_" A_Index-1
		}
	}else{
		courseProgress:=100
		; course finished? try to fill questionaire and reload the course state
		if(courses["ID" v.courseId].readTimes<3){
			readCourse(cookie, v.courseId, courses["ID" v.courseId].readTimes)
			;~ ,courses["ID" v.courseId, "readTimes"]:=courses["ID" v.courseId, "readTimes"]?1:courses["ID" v.courseId, "readTimes"]+1
		}
	}
	guicontrol,,t%ind%_2,% courseProgress
	guicontrol,,t%ind%_5,% (courseProgress=100?"":(v.passTime-v.hasRead-tick) " min, ")  courseProgress "%"
	guicontrol,,t%ind%_4,% v.courseId
}
loop % courseArr.maxindex()-ind {
	guicontrol,hide,% "t" a_index+ind "_0"
	guicontrol,hide,% "t" a_index+ind "_1"
	guicontrol,hide,% "t" a_index+ind "_2"
	guicontrol,hide,% "t" a_index+ind "_3"
	guicontrol,hide,% "t" a_index+ind "_4"
	guicontrol,hide,% "t" a_index+ind "_5"
	guicontrol,hide,% "t" a_index+ind "_6"
}
setformat,float,0.2
tick+=0.1
return

keepConnect(cookie){
	global readingPool
	
	for k,v in readingPool {
		if(v.pass)
			continue
		link:="http://edu.hospital-n.local/course.php?courseID=" v.courseId "&f=" v.f "&cid=" v.cid "&rnd=" v.rnd
		static url:="http://edu.hospital-n.local/http_get_count.php"
		header:="Accept: */*`nAccept-Language: zh-tw`nReferer: " link "`nIf-Modified-Since: 0`nContent-Type: application/x-www-form-urlencoded; charset=UTF-8`nCache-Control: no-cache`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nHost: edu.hospital-n.local`nConnection: Close`nPragma: no-cache`nCookie: " cookie
		post:="limit=300&logRefresh=1&logID=" v.logId
		
		httprequest(url,post,header,"charset: utf-8")
	}
}






/* start reading course
courseId can be an array
course items of 教材 are read in a row
*/
readCourse(cookie,courseId,readTimes=""){
	global readingPool,courses
	
	if isobject(courseId){
		for k,v in courseId {
			readCourse(cookie,v)
		}
		return
	}
	
	course:=checkCourseStatus(cookie,courseId)
	courses["ID" course.courseId]:=course
	courses["ID" course.courseId, "readTimes"]:=readTimes?readTimes+1:1
	
	
	if (course.pass) {
		
		;~ item:=object("courseId",courseId,"f",0,"cid",0,"rnd",0,"t",0,"src",0,"logId",0,"passTime",1,"link",0,"hasRead",1,"name",course[1,"name"],"pass",true)
		;~ readingPool[courseId "_0_0_0"]:=item	
		return 1
	}
		
	
	;~ clipboard.=courseId "`n"
	
	
	delayMin:=0
	hasExam:=false
	for k,v in course {
		if k is not number
			continue
		if (v.type="教材" && v.passTime>0) {
			if (!v.pass) {
				if(delayMin=0){
					SetTimerFn("readCourseItem",delayMin=0?(-1000):(-1)*(delayMin+1)*60*1000,object(1,cookie,2,v.link,3,v.passTime,4,v.hasRead,5,v.name))	
					;~ clipboard.=courseId ": " v.name " - " (delayMin=0?(-1000):(-1)*(delayMin+1)*60*1000) "`n"
					;~ SetTimerFn("keepConnect", -3000, [cookie])
					
					sleep 1000
				}
				delayMin+=v.passTime-v.hasRead+1
			}
		}
		else if (v.type="問卷" && delayMin=0 && !v.pass){
			SetTimerFn("fillQuest",delayMin=0?(-1000):(-1)*delayMin*60*1000,object(1,cookieJS,2,course))	
		}
	}
	
	
	
	if (!delayMin) && (courseId) {
		;~ linkTMSpage("http://edu.hospital-n.local/course.php?courseID=" courseId)
		item:=object("courseId",courseId,"f",0,"cid",0,"rnd",0,"t",0,"src",0,"logId",0,"passTime",1,"link",0,"hasRead",1,"name",course[1,"name"],"pass",true)
		readingPool[courseId "_0_0_0"]:=item	
	}else {
		SetTimerF("keepConnect",300000,object(1,cookie))
	}
	
}

/*
back to main page of course, check course status, 
if all read but non-教材 -> open new window with main page of course (the window won't quit when script exit)
else -> quit the window
*/

closeCourse(item,cookie){
	setformat,float,0.16
	global readingPool,courses
	traytip,,% "Closing: " item.name
	url:="http://edu.hospital-n.local/course/http_doc_log.php?rnd=" item.rnd "&fresh=" item.t
	header:="Accept: */*`nAccept-Language: zh-tw`nReferer: http://edu.hospital-n.local/course.php?courseID=" item.courseId "&f=" item.f "&cid=" item.cid "&rnd=" item.rnd "`nIf-Modified-Since: 0`nContent-Type: application/x-www-form-urlencoded; charset=UTF-8`nCache-Control: no-cache`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; GTB7.4; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nHost: edu.hospital-n.local`nConnection: Close`nPragma: no-cache`nCookie: " cookie
	httprequest(url,post:="logRefresh=1&logID=" item.logId,header,"charset: utf-8")
		
	
	;~ readingPool.Delete(item.courseId "_" item.f "_" item.cid "_" item.rnd)
	readingPool["" item.courseId "_" item.f "_" item.cid "_" item.rnd,"pass"]:=true
	traytip
	
	url:="http://edu.hospital-n.local/course.php?courseID=" item.courseId
	header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nReferer: http://edu.hospital-n.local`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nAccept-Encoding: gzip, deflate`nHost: edu.hospital-n.local`nConnection: Close`nCookie: " cookie
	httprequest(url,post,header,"charset: utf-8")
	
	dom:=ComObjCreate("HtmlFile")
	dom.write(post)
	arr:=parseCourseStatus(dom)
	courses["ID" arr.courseId]:=arr
	
	if (arr.pass)
		return
	
	allPass=1
	for k,v in arr {
		if k is not number
			break
		allPass&=v.pass
	}
	
	if allPass {
		
		linkTMSpage(url)
	}

	;~ return post
}


linkTMSpage(link){
	global cookieJS
	
	pwb:=comobjcreate("InternetExplorer.Application")
	,pwb.visible:=true
	,pwb.Navigate("http://edu.hospital-n.local/")
	if !waitLoaded(pwb,func("fn1"))
		return
	pwb.Navigate(cookieJS)
	sleep 1000
	pwb.Navigate(link)
	if !waitLoaded(pwb,func("fn1"))
		return
	
	return pwb
}

httprequestTMS(url,cookie,post="",referer="http://edu.hospital-n.local"){
	header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nReferer: " referer "`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nAccept-Encoding: gzip, deflate`nHost: edu.hospital-n.local`nConnection: Close`nCookie: " cookie
	,httprequest(url,post,header,"charset: utf-8")
	return post
}





/*
read course item of 教材 with sufficient time to pass
*/
readCourseItem(cookie,link,passTime=60,hasRead=0,courseName=""){
	global readingPool
	;~ clipboard.="init: " courseName "`n"
	traytip,,% "Initiating: " courseName,5
	RegExMatch(link,"i)courseID=(\d+)&f=(\w+?)&cid=(\d+)&rnd=([\d-]+)",match)
	;~ url:="http://edu.hospital-n.local/course.php?courseID=84786&f=doc&cid=6673&rnd=290-1360650515"
	header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nReferer: http://edu.hospital-n.local`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nAccept-Encoding: gzip, deflate`nHost: edu.hospital-n.local`nConnection: Close`nCookie: " cookie
	httprequest(link,post,header,"charset: utf-8")
	
	logId:=RegExReplace(post,"is).+logID\s?=\s?(\d+).+","$1")

; below steps to be changed

	;~ url:="http://edu.hospital-n.local/slideshow2.swf?playtype=fs&src=http://edu.hospital-n.local/slideshow2.php%3fid=" match3 "%26from=content&slide=&script=1&playurl=http://edu.hospital-n.local/course/play.php%3fid=" match3 "%26from=content%26logID=" logId
	;~ header:="Accept: */*`nAccept-Language: zh-TW`nReferer:" link "`nx-flash-version: 11,3,300,271`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; GTB7.4; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nHost: edu.hospital-n.local`nConnection: Close`nCookie: " cookie
	;~ httprequest(url,post,header,"charset: utf-8")
	
	
	;~ url:="http://edu.hospital-n.local/slideshow2.php?id=" match3 "&from=content"
	;~ header:="Accept: */*`nAccept-Language: zh-TW`nReferer: http://edu.hospital-n.local/slideshow2.swf?playtype=fs&src=http://edu.hospital-n.local/slideshow2.php%3fid=" match3 "%26from=content&slide=&script=1&playurl`nx-flash-version: 11,3,300,271`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; GTB7.4; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nHost: edu.hospital-n.local`nConnection: Close`nCookie: " cookie
	;~ httprequest(url,post,header,"charset: utf-8")
	
	;~ src:=RegExReplace(post,"is).+<src>(.+)<\/src>.+","$1")
	
	
	priorFormat:=A_FormatFloat
	setformat,float,0.16
	
	rnd:="0."
	loop 16 {
		random,rand,0,9
		rnd.=rand
	}
	if (rnd=0)
		rnd:="0.0000000000000001"
	
	
	
	;~ url:=src "project.fsp?t=" rnd
	;~ header:="Accept: */*`nAccept-Language: zh-TW`nReferer: http://edu.hospital-n.local/slideshow2.swf?playtype=fs&src=http://edu.hospital-n.local/slideshow2.php%3fid=" match3 "%26from=content&slide=&script=1&playurl`nx-flash-version: 11,3,300,271`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; GTB7.4; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nHost: edu.hospital-n.local`nConnection: Close`nCookie: " cookie
	;~ httprequest(url,post,header,"charset: utf-8")
	
	
	
	;~ url:="http://edu.hospital-n.local/AVM1.swf?randCha=1526201237 HTTP/1.1
;~ Accept: */*
;~ Accept-Language: zh-TW
;~ Referer: http://edu.hospital-n.local/slideshow2.swf?playtype=fs&src=http://edu.hospital-n.local/slideshow2.php%3fid=6673%26from=content&slide=&script=1&playurl
;~ x-flash-version: 11,3,300,271
;~ Accept-Encoding: gzip, deflate
;~ User-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; GTB7.4; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)
;~ Host: edu.hospital-n.local
;~ Connection: Keep-Alive
;~ Cookie: PHPSESSID=9a9d0bcb9d2336e1ab108ffa5bfd4912; cookie_account=loginId; cookie_passwd=08ea8b0838cc3ff6fbf08ea643eecf2d


	;~ url:="http://edu.hospital-n.local/goToFsUrl.swf?go2fs=http%3A//edu.hospital-n.local/course/play.php%3Fid%3D" match3 "%26from%3Dcontent%26logID%3D" logId "%26slide%3D1"
	;~ header:="Accept: */*`nAccept-Language: zh-TW`nReferer: http://edu.hospital-n.local/slideshow2.swf?playtype=fs&src=http://edu.hospital-n.local/slideshow2.php%3fid=" match3 "%26from=content&slide=&script=1&playurl`nx-flash-version: 11,3,300,271`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; GTB7.4; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nHost: edu.hospital-n.local`nConnection: Clsoe`nCookie: " cookie
	;~ httprequest(url,post,header,"charset: utf-8")
	
	;~ return object("courseId",match1,"f",match2,"cid",match3,"rnd",match4,"t",rnd,"src",src,"logId",logId)
	item:=object("courseId",match1,"f",match2,"cid",match3,"rnd",match4,"t",rnd,"src",src,"logId",logId,"passTime",passTime,"link",link,"hasRead",hasRead,"name",courseName,"pass",false)
	readingPool[match1 "_" match2 "_" match3 "_" match4]:=item
	SetTimerFn("closeCourse",passTime-hasRead<=0?(-1000):(-1)*((passTime-hasRead+0.5)*60)*1000,object(1,item,2,cookie))
	;~ SetTimerFn("closeCourse",-2000,object(1,item,2,cookie))
	traytip
	setformat,float,%priorFormat%
}



/* 
parse the window of main page of course
return array of status
*/

parseCourseStatus(dom){
	arr:=[]
	
	,arr.courseId:=RegExReplace(dom.documentElement.innerHTML,"is).+courseId=(\d+).+","$1")
	;whether the course passed
	,arr.pass:=instr($(dom,"main").innerText,"** 通過 **")?true:false
	,arr.name:=$(dom,"main").getElementsByTagName("A")[0].innerText
	
	,i=0
	while($(dom,"t1_tr" i).innerText) {
		
		arr[i+1,"type"]:=$(dom,"t1_tr" i).cells[1].innerText
		
		if !instr(link:=regexreplace($(dom,"t1_tr" i).cells[2].getElementsByTagName("A")[0].href,"^about:"),"http:")
			link:="http://edu.hospital-n.local" link
		
		arr[i+1,"link"]:=link
		,arr[i+1,"name"]:=trim($(dom,"t1_tr" i).cells[2].innerText)
		,arr[i+1,"passTime"]:=RegExReplace($(dom,"t1_tr" i).cells[4].innerText,"\D")
		,arr[i+1,"pass"]:=instr($(dom,"t1_tr" i).cells[5].getElementsByTagName("IMG")[0].src,"passcheck")?true:false
		,RegExMatch($(dom,"t1_tr" i).cells[5].getElementsByTagName("IMG")[0].title,"(\d\d):(\d\d):(\d\d)",match)
		,arr[i+1,"hasRead"]:=match1*60+match2+match3/60
		,i++
	}
	return arr
}


/* check course status
create new window -> set cookie -> go to main page of course -> parse status -> return array of status
*/

checkCourseStatus(cookie,courseId){
	url:="http://edu.hospital-n.local/course.php?courseID=" courseId
	,header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nReferer: http://edu.hospital-n.local`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nAccept-Encoding: gzip, deflate`nHost: edu.hospital-n.local`nConnection: Close`nCookie: " cookie
	,httprequest(url,post,header,"charset: utf-8")
	
	
	
	if instr(post,"權限不足")
		if !signUpCourse(cookie,courseId)
			return
		else {
			httprequest(url,post,header,"charset: utf-8")
			if instr(post,"權限不足")
				return
		}
	
	dom:=ComObjCreate("HtmlFile")
	dom.write(post)
	
	return parseCourseStatus(dom)
	
	
}

;; fill questionnaires
fillQuest(cookie,course, whichButton=""){
	global readingPool, courses
	
	if course.Pass
		return
	
	
	keepConnect(cookie)
	;~ for k,v in readingPool {
		;~ setformat,float,0.16
		;~ url:="http://edu.hospital-n.local/course/http_doc_log.php?rnd=" v.rnd "&fresh=" v.t
		;~ header:="Accept: */*`nAccept-Language: zh-tw`nReferer: http://edu.hospital-n.local/course.php?courseID=" v.courseId "&f=" v.f "&cid=" v.cid "&rnd=" v.rnd "`nIf-Modified-Since: 0`nContent-Type: application/x-www-form-urlencoded; charset=UTF-8`nCache-Control: no-cache`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; GTB7.4; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nHost: edu.hospital-n.local`nConnection: Close`nPragma: no-cache`nCookie: " cookie
		;~ httprequest(url,post:="logRefresh=1&logID=" v.logId,header,"charset: utf-8")
	;~ }
	
	hasExam:=0
	
	
	
	
	for k,v in course {
		if k is not number
			continue
		if (v.type="測驗") && !v.pass
			hasExam:=1
		else if (v.type!="問卷") || v.pass
			continue
		
		
		RegExMatch(v.link,"i)pollID=(\d+)",match)
		pollID:=match1
		
		header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nReferer: http://edu.hospital-n.local`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nAccept-Encoding: gzip, deflate`nHost: edu.hospital-n.local`nConnection: Close`nCookie: " cookie
		httprequest(v.link,post:="",header,"charset: utf-8")
		if instr(post,"本份問卷不可重複填寫"){
			if(whichButton)
				disableGuiControl("t" whichButton "_6")
			continue
		}
		if instr(post,"請先完成前一個課程活動") {
			tooltip % "此課程內容須按順序依序完成`n請先完成課程或測驗!"
			settimer,tooltip,-2000
			if(whichButton)
				disableGuiControl("t" whichButton "_6")
			return 1
		}
		
		RegExMatch(v.link,"i)pollID=(\d+)",match)
		post:="pollID=" pollID "&fmSubmit=yes&s=" extractQuest(post) 	;&no93427=3&no93428=3&no93429=3&no93430=3&no93431=3&no93432=3&misc93433="

		url:="http://edu.hospital-n.local/course.php?courseID=" course.courseId "&f=poll"
		header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nReferer: http://edu.hospital-n.local/course.php?courseID=" v.courseId "&f=poll&pollID=" pollID "`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nAccept-Encoding: gzip, deflate`nHost: edu.hospital-n.local`nConnection: Close`nCookie: " cookie
		
		
		httprequest(url,post,header,"charset: utf-8")
		
		if instr(post,"問卷填寫已經完成，感謝您撥空填寫!") {
			tooltip,填寫問卷完成！
			settimer,tooltip,-2000
			if(whichButton)
				disableGuiControl("t" whichButton "_6")
			
			if((courses["ID" course.courseId]:=checkCourseStatus(cookie, course.courseId)).pass){
				for k,v in readingPool
					if (v.courseId=courseId){
						readingPool[k, "pass"]:=true
						break
					}
				return
			}
		}
		
	}
	
	if hasExam {
		tooltip,還有測驗未完成！
		settimer,tooltip,-2000
		if(whichButton)
				disableGuiControl("t" whichButton "_6")
		return 1
	}
	
}

disableGuiControl(var){
	global
	guicontrol,disable,% var
	triedFillQuest(SubStr(var,2,1))
}

triedFillQuest(whichRow){
	global
	GuiControlGet,courseIdTxt,,t%whichrow%_4
	courses["ID" courseIdTxt, "triedFillQuest"]:=true
	;~ for k,v in readingPool
		;~ if (v.courseId=courseIdTxt){
			;~ readingPool[k, "triedFillQuest"]:=true
			;~ break
		;~ }
}

extractQuest(html){
	dom:=ComObjCreate("HtmlFile")
	dom.write(html)
	
	html:=dom.getElementById("fm").innerHTML
	arr:=[]
	
	i:=0
	while i:=regexmatch(html,"name=\W?(\w+)\W?",match,i+1) {
		if match1 in pollID,fmSubmit,s
			continue
		arr["" match1]:=1
	}
	
	str:=""
	for k,v in arr
		if regexmatch(k,"no\d+")
			str.="&" k "=3"
		else
			str.="&" k "="
		
	return str
}


/* get PHPSESSID of TMS, for login
*/
getTmsPhpId(){
	url:="http://edu.hospital-n.local/"
	
	header:="Accept: */*`nAccept-Language: zh-tw`nReferer: http://edu.hospital-n.local/`nIf-Modified-Since: 0`nContent-Type: application/x-www-form-urlencoded; charset=UTF-8`nCache-Control: no-cache`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nHost: edu.hospital-n.local`nConnection: Close`nPragma: no-cache"
	httprequest(url,post,header,"charset: utf-8")
	RegExMatch(header,"PHPSESSID=(\w{32});",match)
	return match1
}

/* check if TMS account is valid
*/
checkTMSaccount(loginId,loginPw){
	global phpId
	if !phpId
		phpId:=getTmsPhpId()
	
	url:="http://edu.hospital-n.local/sys/lib/ajax/login_submit.php"
	
	header:="Accept: */*`nAccept-Language: zh-tw`nReferer: http://edu.hospital-n.local/`nIf-Modified-Since: 0`nContent-Type: application/x-www-form-urlencoded; charset=UTF-8`nCache-Control: no-cache`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nHost: edu.hospital-n.local`nConnection: Close`nPragma: no-cache`nCookie: PHPSESSID=" phpId
	
	post:="account=" EncodeURL(loginId) "&password=" EncodeURL(loginPw) "&secCode=na&stay=0"
	
	httprequest(url,post,header,"charset: utf-8")
	
	RegExMatch(post,"""status"":""(\w+?)""",match)
	
	return (match1="true")?1:0
}

/* login TMS with http request
not needed though because TMS is cookie-based
*/
loginTMS(cookie){
	if !phpId
		phpId:=getTmsPhpId()
	
	url:="http://edu.hospital-n.local/home.php"
	
	header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nAccept-Encoding: gzip, deflate`nConnection: Close`nHost: edu.hospital-n.local`nCookie: " cookie
	
	httprequest(url,post,header,"charset: utf-8")
	return post
}

/* sign up course
return 1 if successful
reutrn 0 if failed
*/
signUpCourse(cookie,courseId){
	
	if isobject(courseId) {
		arr:=[]
		for k,v in courseId {
			if v is not integer
				continue
			arr.push(signUpCourse(cookie,v))
		}
		return arr
	}
	
	if courseId is not integer
		return 0
	
	url:="http://edu.hospital-n.local/home/course/approve_apply.php?applyMode=1&id=" courseId
	
	header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nReferer: http://edu.hospital-n.local/home.php?f=course&m=internal&tab=new&public=1&divID=-1&mode=0&catID=151&keyword=`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nAccept-Encoding: gzip, deflate`nHost: edu.hospital-n.local`nConnection: Close`nCookie: " cookie
	
	httprequest(url,post,header,"charset: utf-8")
	
	if instr(post,"您已是課程學員")
		return 1
	
	/* get key and encrypt it with RC4 and base64
	*/
	
	key:=getKey(cookie,courseId)
	enc:=base64enc(RC4txt2ascarr("courseID=" courseId "&reason=",key))
	
	url:="http://edu.hospital-n.local/home/course/http_member_insert.php"
	
	header:="Accept: */*`nAccept-Language: zh-tw`nReferer: http://edu.hospital-n.local/home/course/approve_apply.php?applyMode=1&id=" courseId "`nIf-Modified-Since: 0`nContent-Type: application/x-www-form-urlencoded; charset=UTF-8`nCache-Control: no-cache`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nHost: edu.hospital-n.local`nConnection: Close`nPragma: no-cache`nCookie: " cookie
	
	post:= "encrypt=" encodeurl(enc)
	
	httprequest(url,post,header,"charset: utf-8")
	
	RegExMatch(post,"""status"":""(\w+?)""",match)
	
	return match1="true"?1:0
	
}

/* get key to be encrypted
*/
getKey(cookie,courseId){
	url:="http://edu.hospital-n.local/sys/getkey.php"
	
	header:="Accept: */*`nAccept-Language: zh-tw`nReferer: http://edu.hospital-n.local/home/course/approve_apply.php?applyMode=1&id=" courseId "`nIf-Modified-Since: 0`nContent-Type: application/x-www-form-urlencoded; charset=UTF-8`nCache-Control: no-cache`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nHost: edu.hospital-n.local`nConnection: Close`nPragma: no-cache`nCookie: " cookie
	
	httprequest(url,post,header,"charset: utf-8")
	
	RegExMatch(post,"""key"":""(\w+?)""",match)
	return match1
}


/* RC4 encryption
txt -> array of asci code
*/
RC4txt2ascarr(Data,Pass) {
	result:=[],key:=[],sbox:=[]
   b := 0, j := 0
   ;~ VarSetCapacity(Result,StrLen(Data)*2)
   Loop 256
      a := A_Index - 1
     ,key[a] := Asc(SubStr(Pass, Mod(a,StrLen(Pass))+1, 1))
     ,sBox[a] := a
   Loop 256
      a := A_Index - 1
     ,b := b + sBox[a] + Key[a]  & 255
     ,sBox[a] := (sBox[b]+0, sBox[b] := sBox[a]) ; SWAP(a,b)
   Loop Parse, Data 
	{
      i := A_Index & 255
     ,j := sBox[i] + j  & 255
     ,k := sBox[i] + sBox[j]  & 255
     ,sBox[i] := (sBox[j]+0, sBox[j] := sBox[i]) ; SWAP(i,j)
     Result.push(Asc(A_LoopField)^sBox[k])
 }
   Return Result
}


/* base64 encryption (adapted from javascript version: http://hellerim.net/base64_src.php)
array or text -> text
*/
base64enc(inp, uc=true, safe=false){
	readBuf:=[]
	enc:=safe?"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-/":"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	b:=!isobject(inp)
	n:=(!b||!uc)?1:2
	out:=""
	c:=0,j=1,l=0,s=0
	inp_length:=b?strlen(inp):inp.maxindex()
	loop % inp_length
	{
		i:=a_index-1
		c:=b?asc(substr(inp,i+1,1)):inp[i+1]
		k:=n-1
		while(k>=0){
			readBuf[k+1]:=c & 0xff
			c>>=8
			k--
		}
		m=0
		while(m<n){
			l:=((l<<8)&0xff00)|readBuf[m+1]
			s:=(0x3f<<(2*j))&l
			l-=s
			out.=substr(enc,(s>>(2*j))+1,1)
			j++
			if(j=4){
				out.=substr(enc,(l&0x3f)+1,1)
				j=1
			}
			m++
		}
	}
	
	if(j=2){
		s:=0x3f & (16*l)
		out.=substr(enc,s+1,1)
		out.="=="
	}else if(j=3){
		s:=0x3f & (4*l)
		out.=substr(enc,s+1,1)
		out.="="
	}
	
	return out
	
}


fn1(byref pwb){
	return !pwb.busy
}

guiclose:
;~ ~esc::
msgbox,4,,Exit?
ifmsgbox,No
	return
exit:
for k,v in readingPool {
	setformat,float,0.16
	url:="http://edu.hospital-n.local/course/http_doc_log.php?rnd=" v.rnd "&fresh=" v.t
	header:="Accept: */*`nAccept-Language: zh-tw`nReferer: http://edu.hospital-n.local/course.php?courseID=" v.courseId "&f=" v.f "&cid=" v.cid "&rnd=" v.rnd "`nIf-Modified-Since: 0`nContent-Type: application/x-www-form-urlencoded; charset=UTF-8`nCache-Control: no-cache`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; GTB7.4; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nHost: edu.hospital-n.local`nConnection: Close`nPragma: no-cache`nCookie: " cookie
	httprequest(url,post:="logRefresh=1&logID=" v.logId,header,"charset: utf-8")
	readingPool.Delete(k)
}
ExitApp
return


tooltip:
ToolTip
return
