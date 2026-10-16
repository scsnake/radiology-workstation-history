#SingleInstance,ignore
#include <httprequest>

gui,font,s12,Verdana

gui,add,edit,vj r3 w600 h200,Journal Name List (以tab或斷行分隔)
gui,add,button,default,Go!
gui,show,autosize
return



ButtonGo!:
gui,submit
if (j="Journal Name List (以tab或斷行分隔)")
	goto back
output:=""
loop,parse,j,`t`n
{
	if (a_loopfield="")
		continue
	
	output.=trim(a_loopfield) "`t" checkSCI(trim(a_loopfield)) "`n"
}
clipboard:=output
tooltip,完成！找excel貼上結果~
settimer,tooltip,2000
back:
gui,show
return

tooltip:
ToolTip
return

guiclose:
~esc::
ExitApp
return


checkSCI(j){
	text:=RegExReplace(j,"\W","+")
	,j:=RegExReplace(j,"\W","\W")
	
	httprequest(url:="http://publik.tuwien.ac.at/info/sci_search.php"
		,post:="secondpass=1&lang=2&searchsrc=SCI&stext=" text
		,header:="Host: publik.tuwien.ac.at`nUser-Agent: Mozilla/5.0 (Windows NT 5.1; rv:36.0) Gecko/20100101 Firefox/36.0`nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8`nAccept-Language: zh-TW,zh;q=0.8,en-US;q=0.5,en;q=0.3`nAccept-Encoding: gzip, deflate`nReferer: http://publik.tuwien.ac.at/info/sci_search.php`nConnection: keep-alive"
		,"charset: utf-8")

	return !!RegExMatch(post,"i)<span class=""normal"">" j "<br>[^<]+ISSN: [\w-]+<br>[^<]+Index: SCI")
	
}