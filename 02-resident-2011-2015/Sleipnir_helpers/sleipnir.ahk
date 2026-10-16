#include <acc>
#include <IEget>






getSlpWb(){
	arr:=[]
	winget,SlpControlList,ControlListHwnd,ahk_class SleipnirMainWindow
	loop,parse,SlpControlList,`n 
	{
		WinGetClass,controlClass,ahk_id %a_loopfield%
		if(controlClass!="Internet Explorer_Server")
			continue
		
		static msg := DllCall("RegisterWindowMessage", "str", "WM_HTML_GETOBJECT")
			, IID := "{0002DF05-0000-0000-C000-000000000046}"   ;// IID_IWebBrowserApp
		SendMessage msg, 0, 0, ,ahk_id %a_loopfield%
		if (ErrorLevel != "FAIL") {
			lResult:=ErrorLevel, VarSetCapacity(GUID,16,0)
			if DllCall("ole32\CLSIDFromString", "wstr","{332C4425-26CB-11D0-B483-00C04FD90119}", "ptr",&GUID) >= 0 {
				DllCall("oleacc\ObjectFromLresult", "ptr",lResult, "ptr",&GUID, "ptr",0, "ptr*",pdoc)
				arr.push(ComObj(9,ComObjQuery(pdoc,IID,IID),1)), ObjRelease(pdoc)
			}
		}else{
			continue
		}
	}
	return arr
}
a:=getSlpWb()
for k,v in a
	v.document.body.innerHTML:=""
exitapp


;Internet Explorer_Server1
a:=acc_objectfromwindow(0______

;window
v:=acc_parent(acc_parent(acc_parent(acc_parent(acc_parent(acc_parent(acc_parent(acc_parent(acc_parent(acc_parent(acc_parent(acc_parent(acc_parent(acc_parent(a))))))))))))))
	msgbox % v.accName "," v.accValue "," acc_role(v)
	
k:=acc_get("Object","4.1.4.1.4.1.4.1.4.1.4.1.4.1.1",0,v)
msgbox % acc_windowfromobject(k-0______
;~ msgbox % k.accName "," k.accValue "," acc_role(k)
return

;~ msgbox % acc_children(a).maxindex()

