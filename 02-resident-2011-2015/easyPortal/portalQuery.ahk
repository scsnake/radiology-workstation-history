;~ #include ../com.ahk
#include httprequest.ahk
;~ #include <_struct>
#SingleInstance,ignore
#NoEnv

coordMode,mouse,screen
coordMode,pixel,screen
coordMode,tooltip,screen
SetBatchLines, -1
SetWorkingDir, %a_scriptdir%
SetTitleMatchMode,2

;~ COM_AtlAxWinInit()

gui,+lastfound +border +resize
Gui, Font, S8 CDefault, Verdana

gui,add,text,section,User ID:
gui,add,edit,x100 ys w100 vuid,
gui,add,text,xs y+5,Portal PW:
gui,add,edit,x100 yp password w100 vportalpw,
gui,add,text,xs y+20,SESSION ID:
gui,add,edit,x100 yp vsid w300

gui,add,button,xs y+20 gLogin,Login
gui,add,edit,x100 yp readonly vinfo w300

;~ SID:="SESSION=6E4569880207416ABE8D3B773CDF2596"
;~ header:="Content-Type: text/xml charset=UTF-8"
;~ test:=httprequest(data:="","http://hisaw.hospital-n.local/WebApplication/Radiology/RISPatientRegistration.aspx?" postdata)

gosub EnvironmentTest
gui,show,xCenter yCenter,Portal Query




return

EnvironmentTest:
;~ header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`r`nAccept-Language: zh-TW`r`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; InfoPath.2; .NET4.0C; .NET4.0E)`r`nAccept-Encoding: gzip, deflate`r`nConnection: Close`r`nHost: portal`r`n"
httprequest("http://portal/General/Login.aspx",loginPage:="")
;~ msgbox % loginPage
;~ ASPid:=regexreplace(header,"is).*ASP\.NET_SessionId=([^;]+);.*","$1")

;~ Gui,2: +LastFound +Resize
;~ pwb:= COM_AtlAxGetControl(COM_AtlAxCreateContainer(WinExist(),0,0,a_screenwidth,a_screenheight-100, "Shell.Explorer") )
;~ IOleInPlaceActiveObject_Interface:="{00000117-0000-0000-C000-000000000046}"
;~ pipa := COM_QueryInterface(pwb, IOleInPlaceActiveObject_Interface)
;~ pwb.navigate("http://portal.hospital-n.local/General/Login.aspx")
;~ if waitLoaded(pwb)
   ;~ return
;~ cookie:=com_invoke(pwb,"document.cookie")



needle=is)name="%v%"([^>]+?value="([^"]*?)")?[^>]*?>
inputs:=[]
inputs.push("__EVENTTARGET","")
inputs.push("__EVENTARGUMENT","")
addParam(inputs,loginPage,"__VIEWSTATE")
addParam(inputs,loginPage,"__EVENTVALIDATION")
inputs.push("CardID","")





return

waitLoaded(byref pwb,timeOutSec=10)
{
   while pwb.readystate!=4
   {
      sleep 200
      if(a_index>timeOutSec*1000/200)
      {
         guicontrol,,info,Can't connect to Portal !
         return 1
      }
   }
   return 0
}


addParam(byref inputs,byref data,byref k,match=2)
{
	needle=is)name="%k%"([^>]+?value="([^"]*?)")?[^>]*?>
	RegExMatch(data,needle,var)
	var:=var%match%
	inputs.push(k,var)
}

Login:
gui,submit,nohide
if ! ((uid && portalpw) || sid)
{
	guicontrol,,info,Enter something !
	return
}
if uid && portalpw
{
   inputs.push("txtUserID",uid)
   inputs.push("txtPass",md5(portalpw))
   inputs.push("ddlHospital","T0")
   inputs.push("rdblQuickMenu","H")	
   str=
   for k,v in inputs
      str.= encodeurl(k) "=" encodeurl(v) "&"
   url:="http://portal/General/Login.aspx" 
   post:=str "imgBtnSubmitNew.x=0&imgBtnSubmitNew.y=0"
   header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nReferer: http://portal/General/Login.aspx`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; InfoPath.2; .NET4.0C; .NET4.0E)`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: portal`nConnection: Close`nPragma: no-cache"
   ;~ msgbox % header "`n`n" post
   httprequest(url,post,header,"charset: utf-8`n+NO_COOKIES")
   ;~ msgbox % header
   ;~ clipboard:= post
   RegExMatch(post,"SESSION=(\w{32})",match)
   guicontrol,,SID,% match1
}
return

MD5( V ) { ; www.autohotkey.com/forum/viewtopic.php?p=376840#376840
 VarSetCapacity( MD5_CTX,104,0 ), DllCall( "advapi32\MD5Init", UInt,&MD5_CTX )
 DllCall( "advapi32\MD5Update", UInt,&MD5_CTX, A_IsUnicode ? "AStr" : "Str",V
 , UInt,StrLen(V) ), DllCall( "advapi32\MD5Final", UInt,&MD5_CTX )
 Loop % StrLen( Hex:="123456789ABCDEF0" )
  N := NumGet( MD5_CTX,87+A_Index,"Char"), MD5 .= SubStr(Hex,N>>4,1) . SubStr(Hex,N&15,1)
stringlower,MD5,md5
return md5
}

EncodeURL( p_data, p_reserved=true, p_encode=true )
{
   old_FormatInteger := A_FormatInteger
   SetFormat, Integer, hex

   unsafe = 
      ( Join LTrim
         25000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F20
         22233C3E5B5C5D5E607B7C7D7F808182838485868788898A8B8C8D8E8F9091929394
         95969798999A9B9C9D9E9FA0A1A2A3A4A5A6A7A8A9AAABACADAEAFB0B1B2B3B4B5B6
         B7B8B9BABBBCBDBEBFC0C1C2C3C4C5C6C7C8C9CACBCCCDCECFD0D1D2D3D4D5D6D7D8
         D9DADBDCDDDEDF7EE0E1E2E3E4E5E6E7E8E9EAEBECEDEEEFF0F1F2F3F4F5F6F7F8F9
         FAFBFCFDFEFF
      )
      
   if ( p_reserved )
      unsafe = %unsafe%24262B2C2F3A3B3D3F40
   
   if ( p_encode )
      loop, % StrLen( unsafe )//2
      {
         StringMid, token, unsafe, A_Index*2-1, 2
         StringReplace, p_data, p_data, % Chr( "0x" token ), `%%token%, all 
      }
   else
      loop, % StrLen( unsafe )//2
      {
         StringMid, token, unsafe, A_Index*2-1, 2
         StringReplace, p_data, p_data, `%%token%, % Chr( "0x" token ), all
      }
      
   SetFormat, Integer, %old_FormatInteger%

   return, p_data
}

DecodeURL( p_data )
{
   return, EncodeURL( p_data, true, false )
}
GuiClose:
!q::
exitapp


