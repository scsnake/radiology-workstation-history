﻿/*
scsnake@gmail.com
2012/3/5
*/


#include httprequest.ahk
#Include ../COM.ahk
#SingleInstance,ignore
#NoEnv

coordMode,mouse,screen
coordMode,pixel,screen
coordMode,tooltip,screen
SetBatchLines, -1
SetWorkingDir, %a_scriptdir%
SetTitleMatchMode,2
DetectHiddenWindows, On

;~ while 1
;~ {
   ;~ inputbox,uid,Portal user id,,,400,200
   ;~ inputbox,portalpw,Portal user password,,,400,200
   ;~ gosub EnvironmentTest
   ;~ gosub Login
   ;~ if SID
      ;~ break
   ;~ else
      ;~ msgbox Can't login Portal...
;~ }

uid:=loginId
portalpw:="3.1416"

while 1
{
   inputbox,quitHour,Check for ? hours,,,400,200,,,,,8
   if quitHour
      break
}
   
setTimer,Quit,% quitHour*60*60*1000

gosub checkConsults
setTimer,checkConsults,1200000 ;20min



return


CheckConsults:
settimer,closePop,200

gosub EnvironmentTest
gosub Login
gosub EmbeddedIE

while !(isobject(pwb))
   break

gui,show,w800 h600,Reply Consults

pwb.Navigate("http://ihisaw.hospital-n.local/WebApplication/InPatient/Ward/QueryNotifyRecordByDr.aspx?SESSION=" SID)
if waitLoaded(pwb,"無法開啟照會查詢頁面")
   return

sleep 2000

msgbox % pwb.document.getElementById("NWeb1_NotifyDrRecord").firstChild.childNodes.length

Loop % (pwb.document.getElementById("NWeb1_NotifyDrRecord").firstChild.childNodes.length-1)
{
   i:=add0(a_index+1,2)

   ;~ if !(pwb.document.getElementById("NWeb1_NotifyDrRecord_ctl" i "_lbtnReply"))
      ;~ break
   
   if !(pwb.document.getElementById("NWeb1_NotifyDrRecord_ctl" i "_NotifyStatus").innerText="待回覆")
      continue
   ;
   ChartNo:=pwb.document.getElementById("NWeb1_NotifyDrRecord_ctl" i "_PersonChartNo").innerText
   
   js=javascript:document.getElementById('NWeb1_NotifyDrRecord_ctl%i%_lbtnReply').click();void 0;
   pwb.Navigate(js)


   url:="http://ihisaw.hospital-n.local/WebApplication/InPatient/Ward/NotifyOtherDoctor.aspx?SESSION=" substr(SID,1,8)
   winwait,% url,,30
   if errorlevel
   {
      msgbox % "無法開啟照會回覆頁面(病歷號" ChartNo ")"
      return
   }
   winget,ReplyHwnd,id
   pwb2:=IEGet(url)
   if waitLoaded(pwb2,"無法連線照會回覆頁面(病歷號" ChartNo ")")
      return
   ;
   
   js=javascript:function $(a){return document.getElementById(a);}b='We will evaluate the patient and the images soon. ';$('NWeb1_TextboxReplyContent').value=b;$('NWeb1_TextboxDiagnosis').value=b;$('NWeb1_TextboxSuggestion').value=b+'Please contact 62299 if emergent procedure is considered.';$('NWeb1_btnRecordFisrtAnalysisTime').click();void 0;
   pwb2.Navigate(js)
   ;~ pause
   if waitLoaded(pwb2,"回覆照會發生錯誤(病歷號" ChartNo ")")
      return
   
   winclose,ahk_id %ReplyHwnd%
   com_release(pwb2)
}



settimer,closePop,off
return

closePop:
ifwinexist,網頁訊息 ahk_class #32770,成功產生照會
   winclose
return

EmbeddedIE:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;embedded ie
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
return


EnvironmentTest:
httprequest("http://portal/General/Login.aspx",loginPage:="")
needle=is)name="%v%"([^>]+?value="([^"]*?)")?[^>]*?>
inputs:=[]
inputs.push("__EVENTTARGET","")
inputs.push("__EVENTARGUMENT","")
addParam(inputs,loginPage,"__VIEWSTATE")
addParam(inputs,loginPage,"__EVENTVALIDATION")
inputs.push("CardID","")

return

waitLoaded(byref pwb,msg="",timeOutSec=30)
{
   sleep 100
   while (pwb.readystate!=4)
   {
      sleep 200
      if(a_index>timeOutSec*1000/200)
      {
         if !(msg="")
            msgbox % msg
         return 1
      }
   }
   return 0
   sleep 500
}

waitIdLoaded(byref pwb,obj_id,timeOutSec=30)
{
   sleep 100
   while !(pwb.document.getElementById(obj_id))
   {
      sleep 200
      if(a_index>timeOutSec*1000/200)
      {
         msgbox,No object of id "%obj_id%"!
         return 1
      }
   }
   return 0
   sleep 500
}

add0(i,j)
{
   while(strlen(i)<j)
      i:="0" i
   
   return i
}
   
   

addParam(byref inputs,byref data,byref k,match=2)
{
	needle=is)name="%k%"([^>]+?value="([^"]*?)")?[^>]*?>
	RegExMatch(data,needle,var)
	var:=var%match%
	inputs.push(k,var)
}

Login:

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
   SID:=match1
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

Quit:
GuiClose:
!q::
exitapp


