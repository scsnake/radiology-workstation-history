/*
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
onexit,onexit
ComObjError(false)

#include <portalLib>


askForPortalIdPw()
param:=[],params:=0
Loop, %0%  
{
    param.push(%A_Index%)  ; Fetch the contents of the variable whose name is contained in A_Index.
}

if (param.maxindex()>0){
	params:=1
	settimer,renewSid,300000
	chartNos:=""
	for k,v in param 
		if RegExMatch(v,"\w{6}\d",match)
			chartNos.=match "`n"
	goto parseParam
}

;~ if fileexist("updateOpPatho.html") {
	;~ Fileread,html,updateOpPatho.html
	;~ RegExMatch(html,"SESSION=(\w{32})",match)
	;~ FileDelete,updateOpPatho.html
	;~ FileAppend,% RegExReplace(html,match1,sid),updateOpPatho.html,utf-8
;~ }

;~ if (param!="" && fileexist(param)){
	;~ Fileread,html,% param
	;~ RegExMatch(html,"SESSION=(\w{32})",match)
	;~ FileDelete,% param
	;~ FileAppend,% RegExReplace(html,match1,sid),% param,utf-8
	;~ exitapp
;~ }

gui,+lastfound
guiHwnd:=winexist()
gui,font,s10,Verdana

gui,add,text,,% "填入病歷號: (可由excel複製後貼上)"
gui,add,edit,vchartNos w800 r5 xs

d:=A_Now
d+=-28,days

;~ gui,add,checkbox,vnoLimit gnoLimit,% "只顯示"
;~ gui,add,datetime,% "x+0 yp w150 vdate disabled choose" substr(d,1,8),
;~ gui,add,text,yp x+10,% "之後的報告"
gui,add,button,xs gGo,% "開始查詢"
gui,add,edit,yp x+10 w400 vupdating disabled,
gui,add,text,yp x+100 gchangeUser,登入者：
gui,add,text,yp x+5 vchangeUser gchangeUser,% getUserName(loginId,sid) "      "
gui,add,button,x+200 yp gHelpFile,% "?"

gui,show,,% "Search Pathology Reports"

settimer,renewSid,300000

return

helpFile:
help=
(
1. 填入病歷號，以逗號、空白、斷行間隔。

2. 可篩選顯示結果在某個特定日期後(不影響查詢速度)。

3. 滑鼠左鍵點「登入者：XXX」可更改登入者。

scsnake@gmail.com 
Update: 2015/9/24
)
gui,2: add,edit,w300,% help
gui,2: show,,Help File
return


changeUser:
askForPortalIdPw(1)
guicontrol,,changeUser,% getUserName(loginId,sid)
return

renewSid:
renewSid(sid,loginId,loginPw)
return


#IfWinActive,Search Pathology Reports ahk_class AutoHotkeyGUI
#IfWinActive

Go:
gui,submit,nohide
parseParam:

if !checkSid(sid)
	sid:=login(loginId,loginPw)
pathoAspId:=getPathoAspId(sid)

if !noLimit
	date:="10000101"
else
	date:=substr(date,1,8)
if !params
	guicontrol,disable,Go

;~ html:="<head><style type=""text/css"">table{border-collapse:collapse;}table,th, td{border: 1px solid black;}</style></head><body><table width=90%><tr><th width=30%>Chart No</th><th>Update Info</th></tr>"
html=
(
<head><style type="text/css">

* {
	font-family: Calibri,Verdana,'微軟正黑體';
}

table{border-collapse:collapse;}table,th, td{border: 1px solid black;}

.highlight { background-color: yellow }

</style>

<script src='jquery.js' ></script>

<script>
var delay = (function(){
  var timer = 0;
  return function(callback, ms){
    clearTimeout (timer);
    timer = setTimeout(callback, ms);
  };
})();


/*

highlight v5

Highlights arbitrary terms.

<http://johannburkard.de/blog/programming/javascript/highlight-javascript-text-higlighting-jquery-plugin.html>

MIT license.

Johann Burkard
<http://johannburkard.de>
<mailto:jb@eaio.com>

*/

jQuery.fn.highlight = function(pat) {
 function innerHighlight(node, pat) {
  var skip = 0;
  if (node.nodeType == 3) {
   var pos = node.data.toUpperCase().indexOf(pat);
   pos -= (node.data.substr(0, pos).toUpperCase().length - node.data.substr(0, pos).length);
   if (pos >= 0) {
    var spannode = document.createElement('span');
    spannode.className = 'highlight';
    var middlebit = node.splitText(pos);
    var endbit = middlebit.splitText(pat.length);
    var middleclone = middlebit.cloneNode(true);
    spannode.appendChild(middleclone);
    middlebit.parentNode.replaceChild(spannode, middlebit);
    skip = 1;
   }
  }
  else if (node.nodeType == 1 && node.childNodes && !/(script|style)/i.test(node.tagName)) {
   for (var i = 0; i < node.childNodes.length; ++i) {
    i += innerHighlight(node.childNodes[i], pat);
   }
  }
  return skip;
 }
 return this.length && pat && pat.length ? this.each(function() {
  innerHighlight(this, pat.toUpperCase());
 }) : this;
};

jQuery.fn.removeHighlight = function() {
 return this.find("span.highlight").each(function() {
  this.parentNode.firstChild.nodeName;
  with (this.parentNode) {
   replaceChild(this.firstChild, this);
   normalize();
  }
 }).end();
};

$(document).ready(function(){
	$('#filter').keyup(function(){
		return delay(function(){
			var i=0;
			var t=$.trim($('#filter').val());

			if(t==''){
				reset();
				return;
			}

			$('tr').find('td:eq(1)').each(function(){
				if(this.innerText.toUpperCase().indexOf(t.toUpperCase())==-1){
					$(this).parent().hide().removeHighlight();
				}else{
					$(this).parent().show().removeHighlight().highlight(t);
					i++;
				}
			});

			$('#match').text(i+' matched');
			delay(function(){$('#match').text('');},2000);

		},300);
	});

	$('#exclude').keyup(function(){
		return delay(function(){

			var t=$.trim($('#exclude').val());

			if(t==''){
				reset();
				return;
			}

			$('tr').find('td:eq(1)').find('a').each(function(){
				if(this.innerText.toUpperCase().indexOf(t.toUpperCase())==-1){
					$(this).show();
				}else{
					$(this).hide();

				}
			});

			var i=0;
			$('tr').find('td:eq(1)').each(function(){
				if($.trim($(this).find(':visible').text())==''){
					$(this).parent().hide();
				}else{
					$(this).parent().show();
					i++;
				}
			});


			$('#match1').text(i+' matched');
			delay(function(){$('#match1').text('');},2000);

		},300);
	});

	var date=new Date();
	$('#date2').val(date.getFullYear()+("0" + (date.getMonth() + 1)).slice(-2)+("0" + date.getDate()).slice(-2)).keyup(function(){
		return delay(filterDate,200);
	});

	date.setMonth(date.getMonth() - 1);

	$('#date1').val(date.getFullYear()+("0" + (date.getMonth() + 1)).slice(-2)+("0" + date.getDate()).slice(-2)).keyup(function(){
		return delay(filterDate,200);
	});

	reset();
});

function reset(state){
	$('tr').show();
	$('a').show();

	$('#filter').val('');
	$(document).removeHighlight();

	filterDate();
}

function showAll(){
	$('#date1').val('');
	
	filterDate();
}


function filterDate(){
	var date1=$.trim($('#date1').val());
	var date2=$.trim($('#date2').val());

	if(date1=='' || date2==''){
		$('tr').show();
		$('a').show();
		return;
	}

	if(date1.length!=8 || date2.length!=8){
		return;
	}

	$('tr').find('td:eq(1)').find('a').each(function(){
		var date=this.innerText.substring(0,8);
		if(date1<date && date<date2){
			$(this).show();
		}else{
			$(this).hide();
		}
	});

	var i=0;
	$('tr').find('td:eq(1)').each(function(){
		if($.trim($(this).find(':visible').text())==''){
			$(this).parent().hide();
		}else{
			$(this).parent().show();
			i++;
		}
	});

	$('#match2').text(i+' matched');
	delay(function(){$('#match2').text('');},2000);
}
var pathoWin;
function openPatho(pathoCode){
	if(pathoWin){
		pathoWin.location.href='pathoFull.html#'+pathoCode;
	}else{
		pathoWin=open('pathoFull.html#'+pathoCode);
		
	}
	return false;
}
</script>

</head><body>

<div>Filter: <input type=text id=filter />&nbsp;&nbsp;&nbsp;&nbsp;<span id=match ></span><br />
Exclude: <input type=text id=exclude />&nbsp;&nbsp;&nbsp;&nbsp;<span id=match1 ></span><br />
Date from: <input type=text id=date1 /> to <input type=text id=date2 />&nbsp;&nbsp;&nbsp;&nbsp;<span id=match2 ></span><br />
<input type=button value=Reset onclick='return reset();' />
<input type=button value='Show All' onclick='return showAll();' />

</div>
<br />
<div id=result>

<table width=90`%><tr style="background: #33cc33;"><th width=30`%>Chart No</th><th>Pathology Results</th></tr>
)
html2=
(
<head><style type="text/css">

* {
	font-family: Calibri,Verdana,'微軟正黑體';
}

table{border-collapse:collapse;}table,th, td{border: 1px solid black;}

</style>
</head><body>

<table width=90`%><tr style="background: #33cc33;"><th width=30`%>Chart No</th><th>Pathology Reports</th></tr>
)

chartArr1:=[],chartArr2:=[]
loop,parse,chartNos,`,`n%A_Tab%%A_Space%
{
	if ! regexmatch(chartNo:=trim(a_loopfield),"^(\w)\w{5}\d$")
		continue
	if chartArr2.hasKey("" chartNo)
		continue
	chartArr1.push("" chartNo)
	chartArr2["" chartNo]:=0
}	

counts:=chartArr1.maxindex()
finish:=0
for k,chartNo in chartArr1 {
	if params
		tooltip % "(" k "/" counts ") Searching for: " chartNo
	else 
		guicontrol,,updating,% "(" k "/" counts ") Searching for: " chartNo
	
	OpStr:=PathoStr:=""
	
	
	personId:=(ptInfo:=patientBasicInfo(chartNo,sid)).personId


	patho:=getPatho2(chartNo)
	html.="<tr><td rowspan=" patho.maxIndex() "><a href=""pathoFull.html#" chartNo """ onclick=""javascript:return openPatho('" chartNo "');"" >" chartNo "</a></td>"
	html2.="<tr><td id=" chartNo " rowspan=" patho.maxIndex() " style=""vertical-align:top"">" chartNo "<br />" ptInfo.name "<br />" ptInfo.birthYear "/" ptInfo.birthMonth "/" ptInfo.birthDay "<br />" (ptInfo.gender="F"?"Female":"Male") "</td>"
	
	for k,v in patho {
		url:="http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/SingleMedicalReport.aspx?SESSION=" sid "&ReportPageGUID=" personId "&ChartNo=" chartNo "&ReportKey=PathologyReport_" chartNo "_" v.pathCode "&ReportCode=PathologyReport&PersonID=" personId
		httprequest(url,post:="",header:="","charset: utf-8")
		dom:=ComObjCreate("HtmlFile")
		dom.write(post)
		$(dom,"rReportTab_lsvReportBody_ctrl0_ctl00_lblPathCode").parentNode.style.backgroundColor:="#ffcccc"
		reports:=RegExReplace($(dom,"rReportTab_lsvReportBody_ctrl0_ctl00_divReportTextVersion").innerHTML,"rReportTab_lsvReportBody_ctrl0_ctl00_tblDisplay",v.pathCode)

		html2.=(k=1?"":"<tr>") "<td>" reports "</td></tr>"
		
		html.=(k=1?"":"<tr>") "<td><a href=""pathoFull.html#" pathoCode """ title=""" trim(v.report) """ date=" substr(v.reportDate,1,8) " onclick=""javascript:return openPatho('" v.pathCode "');"">" substr(v.reportDate,1,8) " Patho: " trim(v.report) "</a></td></tr>"
		
		
	}
	
}
finish:=1	
gosub finish
run % htmlPath
if (params){
	tooltip
	exitapp
}
guicontrol,,updating,% ""
guicontrol,enable,Go
return

finish:
html.="</table></body>"
html2.="</table></body>"
htmlPath:="pathoList.html"
html2Path:="pathoFull.html"
if fileexist(htmlPath)
	FileDelete, % htmlpath
FileAppend,% html,% htmlPath,utf-8
if fileexist(html2Path)
	FileDelete, % html2path
FileAppend,% html2,% html2Path,utf-8
return

nolimit:
gui,submit,nohide
guicontrol,enable%noLimit%,date
return


guiclose:

;~ ~esc::
exitapp
return

onexit:
if !finish
	gosub finish
exitapp
return
