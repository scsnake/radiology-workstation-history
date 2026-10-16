﻿/* 
scsnake@gmail.com 
scsnake @ ptt & ptt2
*/


#Include ../COM.ahk
#SingleInstance,ignore
#NoEnv

coordMode,mouse,screen
coordMode,pixel,screen
coordMode,tooltip,screen
SetBatchLines, -1
SetWorkingDir, %a_scriptdir%

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; READ INI

iniRead,loginId,easyPortal.ini,Settings,account
iniRead,loginPw,easyPortal.ini,Settings,password
iniRead,firstrun,easyPortal.ini,FirstTimeRun,firstrun

timeOut=false
portalURL:="http://portal.hospital-n.local/General/Login.aspx"
radiologyRegistrationURL:="http://hisaw.hospital-n.local/WebApplication/Radiology/RISPatientRegistration.aspx"
patientMedicalRecordListQueryURL:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/patientMedicalRecordListQueryURL.aspx?QueryBySelf=N"
PACSURL:="http://pacssso.hospital-n.local/FSAuthenticator/index.jsp"
personnelQueryURL:="http://ahisaw.hospital-n.local/WebApplication/Administration/PersonNH/EmpQuery.aspx"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;embedded ie
COM_AtlAxWinInit()
Gui, +LastFound +Resize
;pwb := COM_AtlAxGetControl(COM_AtlAxCreateContainer(WinExist(),top,left,width,height, "Shell.Explorer") )  ;left these here just for reference of the parameters
pwb := COM_AtlAxGetControl(COM_AtlAxCreateContainer(WinExist(),0,0,a_screenwidth,a_screenheight-100, "Shell.Explorer") )
;http://msdn.microsoft.com/en-us/library/microsoft.visualstudio.ole.interop.ioleinplaceactiveobject(VS.80).aspx
IOleInPlaceActiveObject_Interface:="{00000117-0000-0000-C000-000000000046}"
pipa := COM_QueryInterface(pwb, IOleInPlaceActiveObject_Interface)
OnMessage(WM_KEYDOWN:=0x0100, "WM_KEYDOWN") 
OnMessage(WM_KEYUP:=0x0101, "WM_KEYDOWN") 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
com_invoke(pwb,"Navigate",portalURL)



menu,影醫常用Menu,add,&PACS
menu,影醫常用Menu,add,影核登記(&R)
menu,影醫常用Menu,add,病患就診記錄(&M)

menu,次常用Menu,add,員工連絡資料查詢(&Q)

menu,easyPortalMenu,add,影醫常用(&R),:影醫常用Menu
menu,easyPortalMenu,add,次常用(&S),:次常用Menu
gui,menu,easyPortalMenu



gui,show, Maximize ,easyPortal


if firstrun
{
   msgbox 請先設定帳號、密碼！
   iniwrite,0,easyPortal.ini,FirstTimeRun,firstrun
   run,easyPortal.ini,%a_scriptdir%
   firstrun=0
}





return





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;SUBROUTINE


;選單們
&PACS:
quickConnectTo(pwb,PACSURL)
return
影核登記(&R):
quickConnectTo(pwb,radiologyRegistrationURL)
return
病患就診記錄(&M):
quickConnectTo(pwb,patientMedicalRecordListQueryURL)
return


員工連絡資料查詢(&Q):
quickConnectTo(pwb,personnelQueryURL)
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;FUNCTIONS

;連到某個網頁
quickConnectTo(pwb,url)
{
   sid:=getSID(pwb)
   com_invoke(pwb,"Navigate",urlAppendSID(url,sid))
   if waitLoaded(pwb)
   {
      msgbox 連線逾時!
      return
   }
   

   if instr(com_invoke(pwb,"LocationURL"),portalURL)
   {
      if logIn(pwb)
      {
         msgbox 無法登入
         return
      }
      sid:=getSID(pwb)
      com_invoke(pwb,"Navigate",urlAppendSID(url,sid))
   }
   
   return

}
   
   
   


;超連結 + session id
urlAppendSID(domain,sid)
{
   str:= (instr(domain,"?")?"&":"?")
   return domain . str "SESSION=" sid
}

;取得session id
getSID(pwb)
{
   str:=COM_Invoke(pwb,"LocationURL")
   pos:=RegExMatch(str,"is).+\?(?:.+=.+&)*SESSION=([^&\?]+)(?:&.+=.+)*",sid)
   
   return (pos?sid1:0)
}

;等待網頁loading結束   傳回:是否timeout
waitLoaded(pwb)
{
   global timeOut=false
   sleep 100
   loop
   {
      If COM_Invoke(pwb,"readyState") = 4
         break
      if a_index>timeOutMin*60*1000/200
      {
         timeOut=true
         break
      }
      sleep 200
   }
   return timeOut
}

;登入portal   傳回:是否timeout
logIn(pwb)
{
   global timeOut=false,loginId,loginPw
   com_invoke(pwb,"Navigate","javascript:function a(b){return document.getElementById(b);}a('txtUserID').value='" loginId "';a('txtPass').value='" loginPw "';a('rdblQuickMenu_0').checked=true;a('imgBtnSubmitNew').click();void(0);")
   waitLoaded(pwb)
   return timeOut
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;HOTKEYS

GuiClose:
^w::
!q::
COM_Release(pwb)
COM_Term()
gui,destroy
exitapp

!left::
com_invoke(pwb,"Navigate","javascript:history.go(-1);void(0);")
return

F5::
com_invoke(pwb,"Navigate","javascript:history.go(0);void(0);")
return

!right::
com_invoke(pwb,"Navigate","javascript:history.go(1);void(0);")
return