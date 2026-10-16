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
comobjerror(false)
onexit,exit

;~ loop {
	;~ loop {
		;~ inputbox,loginId,TMS reader,輸入 TMS ID,,200,180,,,,,% loginId?loginId:""
		;~ if errorlevel=1
			;~ exitapp
	;~ }until loginId!=""
	;~ loop {
		;~ inputbox,loginPw,TMS reader,輸入 TMS 密碼,,200,180
		;~ if errorlevel=1
			;~ exitapp
	;~ }until loginPw!=""
;~ } until checkTMSaccount(loginId,loginPw)
loginId:=loginId
loginPw:MOCK_PASSWORD"mgpsnz4246"



;~ loop {
	;~ inputbox,courseList,TMS reader,% "輸入 TMS 課程ID`n(以逗號分隔)",,200,180
	;~ if errorlevel=1
		;~ exitapp
;~ }until courseList!=""
;~ courseArr:=[]
;~ loop,parse,courseList,`,
	;~ if id:=trim(a_loopfield)
		;~ courseArr.push(id)
courseArr:=array(83133,83132,83053,83048,76339,74629,73798,69710,251,108,104,102)
;~ courseArr:=array(73993)
;~ courseArr:=array(85939,85699,85598)


phpId:=getTmsPhpId()

cookie:="PHPSESSID=" phpId "; cookie_account=" loginId "; cookie_passwd=" md5(loginPw)
cookieJS:="javascript:document.cookie='PHPSESSID=" phpId "';document.cookie='cookie_account=" loginId "';document.cookie='cookie_passwd=" md5(loginPw) "';void 0;"


;~ readCourseItem(TMScookie,"http://edu.hospital-n.local/course.php?courseID=85133&f=doc&cid=6839&rnd=290-1360676142",1/60)


;~ return




readingPool:=[]


readCourse(cookie,courseArr)

return



keepConnect(cookie){
	global readingPool
	
	for k,v in readingPool {
		link:="http://edu.hospital-n.local/course.php?courseID=" v.courseId "&f=" v.f "&cid=" v.cid "&rnd=" v.rnd
		static url:="http://edu.hospital-n.local/http_get_count.php"
		header:="Accept: */*`nAccept-Language: zh-tw`nReferer: " link "`nIf-Modified-Since: 0`nContent-Type: application/x-www-form-urlencoded; charset=UTF-8`nCache-Control: no-cache`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nHost: edu.hospital-n.local`nConnection: Close`nPragma: no-cache`nCookie: " cookie
		post:="limit=300&logID=" v.logId
		
		httprequest(url,post,header,"charset: utf-8")
	}
}






/* start reading course
courseId can be an array
course items of 教材 are read in a row
consider auto fill questionnaire in the future
*/
readCourse(cookie,courseId){
	global readingPool
	
	if isobject(courseId){
		for k,v in courseId
			readCourse(cookie,v)
		return
	}
	
	course:=checkCourseStatus(cookie,courseId)
	if course.pass
		return 1
	
	delayMin=0
	
	for k,v in course {
		if k is not number
			continue
		if (v.type="教材") {
			if (!v.pass) {
				SetTimerF("readCourseItem",delayMin=0?(-1000):(-1)*(delayMin+1)*60*1000,object(1,cookie,2,v.link,3,v.passTime-v.hasRead))	
				delayMin+=v.passTime-v.hasRead+1
			}
		}
		;~ else if (v.type="問卷"){
			;~ SetTimerF("fillQ",delayMin=0?(-1000):(-1)*delayMin*60*1000,object(1,cookieJS,2,v.link))	
		;~ }
	}
	
	if !delayMin {
		pwb:=ComObjCreate("InternetExplorer.Application")
		pwb.Navigate("http://edu.hospital-n.local/course.php?courseID=" match1)
		pwb.visible:=true
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
	global readingPool
	
	url:="http://edu.hospital-n.local/course/http_doc_log.php?rnd=" item.rnd "&fresh=" item.t
	header:="Accept: */*`nAccept-Language: zh-tw`nReferer: http://edu.hospital-n.local/course.php?courseID=" item.courseId "&f=" item.f "&cid=" item.cid "&rnd=" item.rnd "`nIf-Modified-Since: 0`nContent-Type: application/x-www-form-urlencoded; charset=UTF-8`nCache-Control: no-cache`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; GTB7.4; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nHost: edu.hospital-n.local`nConnection: Close`nPragma: no-cache`nCookie: " cookie
	httprequest(url,post:="logID=" item.logId,header,"charset: utf-8")
	
	readingPool.Delete(item.courseId "_" item.f "_" item.cid "_" item.rnd)
	
	
	url:="http://edu.hospital-n.local/course.php?courseID=" item.courseId
	header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nReferer: http://edu.hospital-n.local`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nAccept-Encoding: gzip, deflate`nHost: edu.hospital-n.local`nConnection: Close`nCookie: " cookie
	httprequest(url,post,header,"charset: utf-8")
	
	dom:=ComObjCreate("HtmlFile")
	dom.write(post)
	arr:=parseCourseStatus(dom)
	
	if (arr.pass)
		return
	
	allPass=1
	for k,v in arr {
		if k is not number
			break
		allPass&=v.pass
	}
	
	if allPass {
		
		pwb:=comobjcreate("InternetExplorer.Application")
		pwb.visible:=true
		pwb.Navigate(url)
	}

	;~ return post
}







/* fill questionnaire
to be added in the future
*/
fillQ(cookieJS,link){

}

/*
read course item of 教材 with sufficient time to pass
*/
readCourseItem(cookie,link,passTime=60){
	global readingPool
	
	
	RegExMatch(link,"i)courseID=(\d+)&f=(\w+?)&cid=(\d+)&rnd=([\d-]+)",match)
	;~ url:="http://edu.hospital-n.local/course.php?courseID=84786&f=doc&cid=6673&rnd=290-1360650515"
	header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nReferer: http://edu.hospital-n.local`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nAccept-Encoding: gzip, deflate`nHost: edu.hospital-n.local`nConnection: Close`nCookie: " cookie
	httprequest(link,post,header,"charset: utf-8")
	
	logId:=RegExReplace(post,"is).+logID=(\d+).+","$1")


	url:="http://edu.hospital-n.local/slideshow2.swf?playtype=fs&src=http://edu.hospital-n.local/slideshow2.php%3fid=" match3 "%26from=content&slide=&script=1&playurl=http://edu.hospital-n.local/course/play.php%3fid=" match3 "%26from=content%26logID=" logId
	header:="Accept: */*`nAccept-Language: zh-TW`nReferer:" link "`nx-flash-version: 11,3,300,271`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; GTB7.4; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nHost: edu.hospital-n.local`nConnection: Close`nCookie: " cookie
	httprequest(url,post,header,"charset: utf-8")
	
	
	url:="http://edu.hospital-n.local/slideshow2.php?id=" match3 "&from=content"
	header:="Accept: */*`nAccept-Language: zh-TW`nReferer: http://edu.hospital-n.local/slideshow2.swf?playtype=fs&src=http://edu.hospital-n.local/slideshow2.php%3fid=" match3 "%26from=content&slide=&script=1&playurl`nx-flash-version: 11,3,300,271`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; GTB7.4; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nHost: edu.hospital-n.local`nConnection: Close`nCookie: " cookie
	httprequest(url,post,header,"charset: utf-8")
	
	src:=RegExReplace(post,"is).+<src>(.+)<\/src>.+","$1")
	
	
	priorFormat:=A_FormatFloat
	setformat,float,0.16
	random,rnd,0.0000000000000001,0.9999999999999999
	setformat,float,%priorFormat%
	
	
	url:=src "project.fsp?t=" rnd
	header:="Accept: */*`nAccept-Language: zh-TW`nReferer: http://edu.hospital-n.local/slideshow2.swf?playtype=fs&src=http://edu.hospital-n.local/slideshow2.php%3fid=" match3 "%26from=content&slide=&script=1&playurl`nx-flash-version: 11,3,300,271`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; GTB7.4; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nHost: edu.hospital-n.local`nConnection: Close`nCookie: " cookie
	httprequest(url,post,header,"charset: utf-8")
	
	
	
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


	url:="http://edu.hospital-n.local/goToFsUrl.swf?go2fs=http%3A//edu.hospital-n.local/course/play.php%3Fid%3D" match3 "%26from%3Dcontent%26logID%3D" logId "%26slide%3D1"
	header:="Accept: */*`nAccept-Language: zh-TW`nReferer: http://edu.hospital-n.local/slideshow2.swf?playtype=fs&src=http://edu.hospital-n.local/slideshow2.php%3fid=" match3 "%26from=content&slide=&script=1&playurl`nx-flash-version: 11,3,300,271`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; GTB7.4; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nHost: edu.hospital-n.local`nConnection: Clsoe`nCookie: " cookie
	httprequest(url,post,header,"charset: utf-8")
	
	;~ return object("courseId",match1,"f",match2,"cid",match3,"rnd",match4,"t",rnd,"src",src,"logId",logId)
	item:=object("courseId",match1,"f",match2,"cid",match3,"rnd",match4,"t",rnd,"src",src,"logId",logId)
	readingPool[match1 "_" match2 "_" match3 "_" match4]:=item.clone()
	SetTimerF("closeCourse",passTime=0?(-1000):(-1)*((passTime+0.5)*60)*1000,object(1,item.clone(),2,cookie))
}



/* 
parse the window of main page of course
return array of status
*/

parseCourseStatus(dom){
	arr:=[]
	
	arr.courseId:=RegExReplace(dom.documentElement.innerHTML,"is).+courseId=(\d+).+","$1")
	;whether the course passed
	arr.pass:=instr($(dom,"main").innerText,"** 通過 **")?true:false
	
	i=0
	while($(dom,"t1_tr" i).innerText) {
		
		arr[i+1,"type"]:=$(dom,"t1_tr" i).childNodes[1].innerText
		arr[i+1,"link"]:=$(dom,"t1_tr" i).childNodes[2].getElementsByTagName("A")[0].href
		arr[i+1,"passTime"]:=RegExReplace($(dom,"t1_tr" i).childNodes[4].innerText,"\D")
		arr[i+1,"pass"]:=instr($(dom,"t1_tr" i).childNodes[5].getElementsByTagName("IMG")[0].src,"passcheck")?true:false
		RegExMatch($(dom,"t1_tr" i).childNodes[5].getElementsByTagName("IMG")[0].title,"(\d\d):(\d\d):(\d\d)",match)
		arr[i+1,"hasRead"]:=match1*60+match2+match3/60
		i++
	}
	return arr
}


/* check course status
create new window -> set cookie -> go to main page of course -> parse status -> return array of status
*/

checkCourseStatus(cookie,courseId){
	url:="http://edu.hospital-n.local/course.php?courseID=" courseId
	header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nReferer: http://edu.hospital-n.local`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nAccept-Encoding: gzip, deflate`nHost: edu.hospital-n.local`nConnection: Close`nCookie: " cookie
	httprequest(url,post,header,"charset: utf-8")
	
	dom:=ComObjCreate("HtmlFile")
	dom.write(post)
	
	if instr(dom.document.body.innerText,"權限不足")
		if !signUpCourse(cookie,courseId)
			return
		else {
			httprequest(url,post,header,"charset: utf-8")
			dom:=ComObjCreate("HtmlFile")
			dom.write(post)
		}
	
	return parseCourseStatus(dom)
	
	
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
checkTMSaccount(loginId,loginPw,phpId=""){
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

/* settimer analog for function
Function: function name
Period: repeated interval; execute once if period < 0
ParmObject: array object of parameter passed to function, eg. object(1,param1,2,param2,3,param3)
Priority:
*/
SetTimerF( Function, Period=0, ParmObject=0, Priority=0 ) { 
 Static current,tmrs:=Object() ;current will hold timer that is currently running
 If IsFunc( Function ) {
    if IsObject(tmr:=tmrs[Function]) ;destroy timer before creating a new one
       ret := DllCall( "KillTimer", UInt,0, UInt, tmr.tmr)
       , DllCall("GlobalFree", UInt, tmr.CBA)
       , tmrs.Delete(Function) 
    if (Period = 0 || Period ? "off")
       return ret ;Return as we want to turn off timer
	 ; create object that will hold information for timer, it will be passed trough A_EventInfo when Timer is launched
    tmr:=tmrs[Function]:=Object("func",Function,"Period",Period="on" ? 250 : Period,"Priority",Priority
								,"OneTime",(Period<0),"params",IsObject(ParmObject)?ParmObject:Object()
								,"Tick",A_TickCount)
    tmr.CBA := RegisterCallback(A_ThisFunc,"F",4,&tmr)
    return !!(tmr.tmr  := DllCall("SetTimer", UInt,0, UInt,0, UInt
								, (Period && Period!="On") ? Abs(Period) : (Period := 250)
								, UInt,tmr.CBA)) ;Create Timer and return true if a timer was created
				, tmr.Tick:=A_TickCount
 }
 tmr := Object(A_EventInfo) ;A_Event holds object which contains timer information
 if IsObject(tmr) {
	 DllCall("KillTimer", UInt,0, UInt,tmr.tmr) ;deactivate timer so it does not run again while we are processing the function
	 If (!tmr.active && tmr.Priority<(current.priority ? current.priority : 0)) ;Timer with higher priority is already current so return
		 Return (tmr.tmr:=DllCall("SetTimer", UInt,0, UInt,0, UInt, 100, UInt,tmr.CBA)) ;call timer again asap
	 current:=tmr
	 tmr.tick:=ErrorLevel :=Priority ;update tick to launch function on time
	 tmr.func(tmr.params*) ;call function
	 current= ;reset timer
    if (tmr.OneTime) ;One time timer, deactivate and delete it
       return DllCall("GlobalFree", UInt,tmr.CBA)
				 ,tmrs.Delete(tmr.func)
	 tmr.tmr:= DllCall("SetTimer", UInt,0, UInt,0, UInt ;reset timer
				,((A_TickCount-tmr.Tick) > tmr.Period) ? 0 : (tmr.Period-(A_TickCount-tmr.Tick)), UInt,tmr.CBA)
 }
}

fn1(byref pwb){
	return !pwb.busy
}

exit:
;~ ~esc::
;~ for k,v in readingPool
	;~ v.quit()

ExitApp
return