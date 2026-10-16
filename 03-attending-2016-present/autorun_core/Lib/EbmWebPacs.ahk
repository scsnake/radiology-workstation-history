﻿;~ #include <portalLib>
#include <httprequest>
;~ #include <DoublyLinkedList>
FileEncoding,utf-8

;~ a:=new EbmWebPacs("hc", loginId , loginPw)
;~ b:=a.queryIE("T__________")
;~ ExitApp

class EbmWebPacs {
	static maxOpened:=4
	
	;whichBranch= hc, yl
	__New(whichBranch="hc", loginId="", loginPw=""){
		
		if(whichBranch="hc"){
			this.host:="hchwebpacs.hospital-h.local"
			,this.url:="http://" this.host "/DicomWeb/"
		}else if (whichBranch="yl"){
			this.host:="dlpacs.hospital-y.local"
			,this.url:="http://" this.Host "/dicomweb/"
		}else{
			MsgBox % "Please specify branch of hospital: hs, yl"
			this.__Delete()
		}
		
		ComObjError(false)
		
		if this.waitPwb(this.createIE()){
			MsgBox % "Can't connect to " this.url
			return
		}
		
		if(loginId!="" && loginPw!="")
			this.loginIE(loginId, loginPw)
		
		FileRead,jquery,% A_ScriptDir "\jquery-3.1.1.slim.min.js"
		this.jquery:=jquery "`n$jq=jQuery.noConflict();"
		
	}
	
	createIE(Count=1){
		ind:=this.IECount?this.IECount+1:1
		Loop % Count
			this["IE", ind, "pwb"]:=ComObjCreate("InternetExplorer.Application")
			,this["IE", ind, "pwb"].Navigate(this.url)
			,this["IE", ind, "pwb"].Visible:=true
			,ind++
		this.IECount:=ind-1
		return this["IE", ind, "pwb"]
	}
	waitPwb(pwb="", timeout=60, checkEveryMS=100, preSleep=500, postSleep=500){
		pwb:=this.selectPwb(pwb)
		checkCount:=timeout*1000/checkEveryMS
		Sleep %preSleep%
		Loop
			Sleep %checkEveryMS%
		until (!pwb.busy && pwb.ReadyState=4) || (A_Index>checkCount)
		if(pwb.busy || pwb.ReadyState!=4)
			return -1
		else{
			Sleep %postSleep%
			return 0
		}
	}
	injectJS(js, pwb="", wait=true){
		pwb:=this.selectPwb(pwb)
		,s:=pwb.document.createElement("script")
		,s.type:="text/javascript"
		,s.Text:=js 
		,pwb.document.documentElement.appendChild(s)
		if(wait)
			return this.waitPwb(pwb)
	}
	selectPwb(pwb="", ByRef pwbInd=1){
		if IsObject(pwb)
			return pwb
		
		if(pwb="")
			pwbInd:=1
		else if pwb is Integer
			pwbInd:=0+pwb
		
		return this.IE[pwbInd].pwb
	}
	
	loginIE(loginId, loginPw, pwb=""){
		if(loginId="" || loginPw="")
			return -1
		
		pwb:=this.selectPwb(pwb, pwbInd)
		
		js=
		(Ltrim
		document.getElementsByName('User')[3].value='%loginId%';
		document.getElementsByName('Password')[3].value='%loginPw%';
		document.getElementsByName('RAction')[0].click();
		document.getElementById('btnLogin').click();
		)
		;~ pwb.Navigate(RegExReplace(js, "[\r\n]", " "))
		this.injectJS(js, pwb)
		;~ pwb.document.parentWindow.execScript(js)
		
		if RegExMatch(pwb.locationURL, "\?([^\r\n]+)$", match){
			this["IE", pwbInd, "loginId"]:=loginId, this["IE", pwbInd, "loginPw"]:=loginPw
			,this["IE", pwbInd, "loginUrl"]:=pwb.locationURL
			
			Loop,Parse,match1,&
				if RegExMatch(A_LoopField, "is)([^=]+)=(.+)", match)
					this["IE", pwbInd, "login", match1]:=match2
			
			
			if RegExMatch(pwb.document.cookie, "TS=([^;])+; SN=([^;]+)", match)
				this["IE", pwbInd, "login", "TS"]:=match1, this["IE", pwbInd, "login", "SN"]:=match2
			
			httprequest(pwb.locationURL, post:=""
				, header:="Host: " this.host "`nReferer: " this.url, "+NO_AUTO_REDIRECT")
			
			;~ for k,v in ["AccKey", "LicInfo"]
				;~ this["IE", pwbInd, "login", "" v]:=pwb.document.parentWindow.Queryfrm
				;~ if RegExMatch(header, "Set-Cookie: " v "=([^;]+)", match)
					;~ this["IE", pwbInd, "login", "" v]:=match1
					
			this["IE", pwbInd, "login", "AccKey"]:=pwb.document.parentWindow.Queryfrm.AccKey
			,this["IE", pwbInd, "login", "LicInfo"]:=pwb.document.parentWindow.Queryfrm.LicInfo
			
			;~ httprequest(pwb.locationURL, post:=""
				;~ , header:="Host: " this.host "`nReferer: " this.url, "+NO_AUTO_REDIRECT")
			
			;~ clipboard.=header
			
			;~ Loop % this.pwb.document.getElementsByName("AccKey").length
				;~ if ((val:=this.pwb.document.getElementsByName("AccKey")[A_Index-1].value) != ""){
					;~ this.login.AccKey:=val 
					;~ break
				;~ }
				
			
			return 0
		}
	}
	
	parseQueryResultIE(pwb=""){
		pwb:=this.selectPwb(pwb, pwbInd)
		
		Sleep 1000
		results:=[]
		
		Loop % pwb.document.getElementsByName("Patientfrm")[0].contentWindow.document.getElementById("RTable").rows.length-3 {
			i:=A_Index+1
			item:=[]
			Loop % pwb.document.getElementsByName("Patientfrm")[0].contentWindow.document.getElementById("RTable").rows[i].cells.length-1 
				item.push(Trim(pwb.document.getElementsByName("Patientfrm")[0].contentWindow.document.getElementById("RTable").rows[i].cells[A_Index].innerText))
			for k,v in ["PTN_ID_ID", "STUDY_UID_ID", "BodyPart", "Mark"]
				item[v]:=pwb.document.getElementsByName("Patientfrm")[0].contentWindow.document.getElementById("RTable").rows[i].getAttribute(v)
			results.push(item)
		}
		
		; {ChartNo: 1, PtName: 2, PtBirth: 3, PtGender: 4, ExamDate: 5, ExamTime: 6, AccNo: 7, ExamNo: 8, ReferDr: 9, ExamName: 10, Modality: 14, ImageCount: 17}
		
		return results
	}
	
	queryIE(queryObj, pwb="", openFirstStudy=false){
		if(!IsObject(queryObj)){
			if StrLen(queryObj)=7
				queryObj:={"CHARTID": queryObj}
			else if StrLen(queryObj)=11 && SubStr(queryObj, 1, 1)="T"
				queryObj:={"AID": queryObj}
			else
				queryObj:={"NAME": queryObj}
		}
		
		
		
		pwb:=this.selectPwb(pwb, pwbInd)
		,AccKey:=this.IE[pwbInd].login.AccKey
		
		;~ this.injectJS(this.jquery, pwb)
		;~ pwb.document.parentWindow.execScript(clipboard:=this.jquery)
		;~ pwb.document.parentWindow.execScript("try { window.execScript(" this.jquery "); } catch (e) {alert(e);}")
		
		js=
		(Ltrim
		function populateForm(dom, data)
		{
			var i, j, k, e, tagName, type, op, ele;
			for (k in data){
				ele = dom.getElementsByName(k);
				for (i=0; i<ele.length; i++){
					e = ele[i];
					tagName=e.tagName?e.tagName.toLowerCase():'';
					
					if(tagName==='select'){
						op = e.options;
						for (j=0; j<op.length; j++){
							if(op[j].value===data[k]){
								op[j].selected=true;
							}
						}
					}else if(tagName==='textarea'){
						e.value=data[k];
					}else if(tagName==='input'){
						type=e.type?e.type.toLowerCase():'';
						if(type==='text' || type==='hidden'){
							e.value=data[k];
						}else if(type==='checkbox' || type==='radio'){
							e.checked=!!data[k];
						}
					}
				}
			}
		}
		function __q(a){
			return document.getElementById('mainframeset').getElementsByTagName('frame')[0].contentWindow.document.getElementById('pnQueryForm').querySelectorAll('[name='+a+']')[0];
		}
		
		)
		
		
		
		
		; todo: use js 
		params:={"AETitle": "", "HOSPITALCODE": "", "CHARTID": "", "CHARTID2": "", "VPwd": "", "OTHERPTNID": "", "NAME": "", "BOD": "", "DATEOPTION": "0", "DATE": "", "DATE2": "", "EXACTDATE": A_YYYY a_mm A_DD, "TIME1": "", "TIME2": "", "AID": "", "CID": "", "selectDOCTOR": "", "DOCTOR": "", "selectStudyDesc": "", "STUDYDESC": "", "selectREQSERVICE": "", "REQSERVICE": "", "selectREQPHY": "", "REQPHY": "", "textPART": "", "textMECHINE": "", "JPGQ": "-1", "COMPARISON": "", "SortKey": "", "SortMode": "", "AccKey": AccKey, "STUDYUID": "", "Page": "0", "SERIESUID": "", "INSTANCEUID": "", "PART": "", "MECHINE": "", "QueryBtn.x": "9", "QueryBtn.y": "18"}
		;~ params:={"DATEOPTION": "0", "JPGQ": "-1", "Page": "0", "QueryBtn.x": "9", "QueryBtn.y": "18"}
		
		for k,v in queryObj
			params["" k]:=v
		
		txt:="{"
		for k,v in params
			txt.="'" k "': '" v "', "
		txt:=SubStr(txt, 1, -2) "}"
		
		js2=
		(Ltrim
		var __queryParams = %txt%;
		populateForm(document.getElementById('mainframeset').getElementsByTagName('frame')[0].contentWindow.document, __queryParams);
		document.getElementById('mainframeset').getElementsByTagName('frame')[0].contentWindow.document.getElementById('QueryBtn').click();
		)
		
		
		pwb.document.parentWindow.execScript(js js2)
		
		;~ this.pwb.document.getElementById("lbQueryBtnHint").getElementsByName("QueryBtn")[0].Click()
		;~ ComObjError(true)
		;~ while 1 {
			
			;~ try
				;~ pwb.document.getElementsByName("Patientfrm")[0].contentWindow.RTableCols
			;~ catch e {
				;~ ToolTip loading...
			;~ }
			;~ if(!e)
				;~ break
			;~ Sleep 100
			
		;~ }
		;~ ComObjError(false)
		;~ Sleep 500
		
		;~ clipboard:=this.pwb.document.documentElement.innerHTML
		this.waitPwb(pwb)
		
		,this["IE", pwbInd, "login", "AccKey"]:=pwb.document.parentWindow.Queryfrm.AccKey
		,this["IE", pwbInd, "login", "LicInfo"]:=pwb.document.parentWindow.Queryfrm.LicInfo
		
		if(openFirstStudy)
			this.openStudy(1, pwb)
		else 
			return this.parseQueryResultIE(pwb)
	}
	
	openStudy(which, pwb=""){
		pwb:=this.selectPwb(pwb)
		, pwb.document.getElementsByName("Patientfrm")[0].contentWindow.document.getElementById("RTable").rows[which+1].cells[0].firstChild.click()
		;~ static i:=0
		;~ ToolTip % a_now ": " ++i 
	}
	
	__Delete(){
		Loop % this.IECount
			this.pwb[A_Index].quit()
	}

	login(loginId, loginPw){
		if(loginId="" || loginPw= "")
			return -1
		
		;~ if (this.loadLoginPage()=-1){
			;~ return "loadLoginPage error"
		;~ }
		
		url:=this.url "DicomWeb.dll/Login"
		;~ url:="http://EbmWebPacs.hospital-h.local/DicomWeb/DicomWeb.dll/Login "
		
		header:="Referer: " this.url "`n"
		
		post:="User=" loginId "&Password=" loginPw
		httprequest(url, post, header, "+NO_AUTO_REDIRECT")
		
		if RegExMatch(header, "Location: ([^\r\n]+)", match){
			this.loginId:=loginId, this.loginPw:MOCK_PASSWORD
			redirectUrl:=match1
			,location:=SubStr(match1, StrLen(url)+2)
			Loop,Parse,location,&
				if RegExMatch(A_LoopField, "is)([^=]+)=(.+)", match)
					this["login", match1]:=match2
			
			header=
			(Ltrim
			Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*
			Referer: http://EbmWebPacs.hospital-h.local/DicomWeb/
			Accept-Language: zh-TW
			User-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; InfoPath.3; .NET4.0C; .NET4.0E)
			Accept-Encoding: gzip, deflate
			Host: EbmWebPacs.hospital-h.local
			Connection: Keep-Alive
			Pragma: no-cache
			)
			
			
			httprequest(clipboard:=redirectUrl
				, post:=""
				;~ , header:="Referer: " this.url "`nHost: " this.host
				, header
				, "+NO_AUTO_REDIRECT")
			static field=["AccKey", "LicInfo", "TS"]
			for k,v in field
				if RegExMatch(header, v "=([^;]+)", match)
					this["login", v]:=match1
			
			return 0
		}else{
			return header "`n`n" post
		}
	}
	
	loadLoginPage(){
		httprequest("http://EbmWebPacs.hospital-h.local/DicomWeb"
			, post:=""
			, header:="Host: " this.host
			, "+NO_AUTO_REDIRECT")
		
		httprequest("http://EbmWebPacs.hospital-h.local/DicomWeb/"
			, post:=""
			, header:="Host: " this.host
			, "+NO_AUTO_REDIRECT")
		
		if !RegExMatch(post, "t=[^&]+&v=[^&]+&l=[^&]+", match)
			return -1
		
		static fields:=["ImgBtn", "OEM_Data", "Localization", "ErrorTrap"]
		for k,v in fields
			httprequest(this.url "Script/" v ".js?" match, "", "Host: " this.host)
		
	}
	
	
	query(queryObj){
		if(!IsObject(queryObj)){
			if StrLen(queryObj)=7
				queryObj:={"CHARTID": queryObj}
			else if StrLen(queryObj)=11 && SubStr(queryObj, 1, 1)="T"
				queryObj:={"AID": queryObj}
			else
				queryObj:={"NAME": queryObj}
		}

		params:={"AETitle": "", "HOSPITALCODE": "", "CHARTID": "", "CHARTID2": "", "VPwd": "", "OTHERPTNID": "", "NAME": "", "BOD": "", "DATEOPTION": "0", "DATE": "", "DATE2": "", "EXACTDATE": A_YYYY a_mm A_DD, "TIME1": "", "TIME2": "", "AID": "", "CID": "", "selectDOCTOR": "", "DOCTOR": "", "selectStudyDesc": "", "STUDYDESC": "", "selectREQSERVICE": "", "REQSERVICE": "", "selectREQPHY": "", "REQPHY": "", "textPART": "", "textMECHINE": "", "JPGQ": "-1", "COMPARISON": "", "SortKey": "", "SortMode": "", "AccKey": this.login.AccKey, "STUDYUID": "", "Page": "0", "SERIESUID": "", "INSTANCEUID": "", "PART": "", "MECHINE": "", "QueryBtn.x": "9", "QueryBtn.y": "18"}
		
		for k,v in queryObj
			params["" k]:=v

		url:="http://EbmWebPacs.hospital-h.local/DicomWeb/DicomWeb.dll/QueryPatientStudy?"
		for k,v in params
			url.=k "=" v "&"
		url:=SubStr(url, 1, -1)
		header:="Referer: " this.url "DicomWeb.dll/HTML?f=query.htm`nHost: " this.host "`nCookie: TS=" this.login.TS "; SN=" this.login.SN
		httprequest(url, post:="", header, "+NO_AUTO_REDIRECT")
		
		return post
	}


}