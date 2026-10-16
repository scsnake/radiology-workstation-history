#include <httprequest>


str:=""

loop  {
header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nReferer: https://www.rsroc.org.tw/annual/AnnualPostResult.asp`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; InfoPath.3; .NET4.0C; .NET4.0E)`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: www.rsroc.org.tw`nConnection: Keep-Alive`nCache-Control: no-cache`nCookie: ASPSESSIONIDAQTBAQQT=HHBKIAOBKEPNCNFCIOEIHGEG"

post:="AID=10501&RecID=" a_index "&RecTITLE=&RecWRITER=&btn=%ACd+%B8%DF"
url:="https://www.rsroc.org.tw/annual/AnnualPostResultList.asp"
httprequest(url,post,header,"charset: utf-8`nbinary")
dom:=comobjcreate("HtmlFile")
fileappend,% post,test.txt,CP950
text:=strget(&post,20000,"CP950")
dom.write(clipboard:=text)
text:=dom.documentElement.innerText
regexmatch(text,"s)摘要標題(.+?)第一作者(.+?)投稿日期(.+?)受  理  否(.+?)發表型式([^\r\n]+)",match)
if(trim(match1)="")
	break
str.="收件編號: " a_index "`n摘要標題: " trim(match1) "`n第一作者: " trim(match2) "`n投稿日期: " trim(match3) "`n受理否: " trim(match4) "`n發表型式: " trim(match5) "`n`n"

}
fileappend,% str,result.txt,utf-8