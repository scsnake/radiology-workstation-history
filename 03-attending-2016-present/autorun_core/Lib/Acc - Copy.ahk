;------------------------------------------------------------------------------
; Acc.ahk Standard Library
; by Sean
; Updated by jethrow:
; 	Modified ComObjEnwrap params from (9,pacc) --> (9,pacc,1)
; 	Changed ComObjUnwrap to ComObjValue in order to avoid AddRef (thanks fincs)
; 	Added Acc_GetRoleText & Acc_GetStateText
; 	Added additional functions - commented below
; 	Removed original Acc_Children function
; last updated 2/25/2010
;------------------------------------------------------------------------------
#include <Control_GetClassNN>
; #include <COM>
; RoleText object:
; ind, 1 = text
; ind, 2 = n-th match 
; ind, 3 = find at exactly n-th element
findAccByRoleText(acc, RoleText, depth=0){
	thisRoleText:=RoleText[depth+1]
	,which=thisRoleText[2]
	,findAt=thisRoleText[3]
	
	;~ if(which="" && findAt="")
		;~ which=1
	
	i:=0, found:=false
	if(which!=""){
		
		for ch in Acc_EnumChildren(acc)
			if (acc_GetRoleText(ch.accRole(0))=thisRoleText[1]) && (++i=which){
				found:=ch
				break
			}
		if(found)
			if IsObject(RoleText[depth+2])
				return findAccByRoleText(ch, RoleText, depth+1)
			else
				return ch
		else 
			return false
	}else if (findAt!=""){
		for ch in Acc_EnumChildren(acc)
			if(A_Index=findAt && (acc_GetRoleText(ch.accRole(0))=thisRoleText[1]))
				if IsObject(RoleText[depth+2])
					return findAccByRoleText(ch, RoleText, depth+1)
				else
					return ch
			else 
				return false
	}else{
		for ch in Acc_EnumChildren(acc)
			if (acc_GetRoleText(ch.accRole(0))=thisRoleText[1]){
				if IsObject(RoleText[depth+2])
					found:=findAccByRoleText(ch, RoleText, depth+1)
				else
					found:=ch
				
				if(found)
					return found
			}
		return false
	}
}

findAccByValue(byref acc,val,this_path=""){
	static arr:=[]
	static path:=""
	static record:=""
	for k,v in acc_children(acc) {
		if (IsObject(v) && instr(v.accValue,val)) || (!IsObject(v) && InStr(acc_get("value", "", k, acc), val))
			arr.push([v.clone(),this_path "," k])
		findAccByValue(v,val,this_path "," k)
	}
	record.=this_path "`n"
	return [arr,record]
}
findAccByName(byref acc,val,this_path=""){
	static arr:=[]
	static path:=""
	static record:=""
	for k,v in acc_children(acc) {
	if instr(v.accName,val)
		arr.push([v.clone(),this_path "," k])
		findAccByName(v,val,this_path "," k)
	}
	record.=this_path "`n"
	return [arr,record]
}
findAccBy(byref acc,val,by="value",this_path=""){
	static arr:=[]
	static path:=""
	static record:=""
	for k,v in acc_children(acc) {
	if instr(acc_get(by,"",0,v),val)
		arr.push([v.clone(),this_path "," k])
		findAccBy(v,val,by,this_path "," k)
	}
	record.=this_path "`n"
	return [arr,record]
}
accControl(Control,WinTitle=""){
	if (Control="A" && WinTitle="") { ; Control is "A", use focused control.
        ControlGetFocus, Control, A
        WinTitle = A
    } else if (Control+0!="" && WinTitle="") {  ; Control is numeric, assume its a ahk_id.
        WinTitle := "ahk_id " . Control
        Control =
    }

	controlget,hwnd,hwnd,,%control%,%WinTitle%
	return acc_objectfromwindow(hwnd)
}



Acc_Init()
{
	Static	h
	If Not	h
		h:=DllCall("LoadLibrary","Str","oleacc","Ptr")
}
Acc_ObjectFromEvent(ByRef _idChild_, hWnd, idObject, idChild)
{
	Acc_Init()
	If	DllCall("oleacc\AccessibleObjectFromEvent", "Ptr", hWnd, "UInt", idObject, "UInt", idChild, "Ptr*", pacc, "Ptr", VarSetCapacity(varChild,8+2*A_PtrSize,0)*0+&varChild)=0
	Return	ComObjEnwrap(9,pacc,1), _idChild_:=NumGet(varChild,8,"UInt")
}

Acc_ObjectFromPoint(ByRef _idChild_ = "", x = "", y = "")
{
	Acc_Init()
	If	DllCall("oleacc\AccessibleObjectFromPoint", "Int64", x==""||y==""?0*DllCall("GetCursorPos","Int64*",pt)+pt:x&0xFFFFFFFF|y<<32, "Ptr*", pacc, "Ptr", VarSetCapacity(varChild,8+2*A_PtrSize,0)*0+&varChild)=0
	Return	ComObjEnwrap(9,pacc,1), _idChild_:=NumGet(varChild,8,"UInt")
}

Acc_ObjectFromWindow(hWnd, idObject = -4)
{
	Acc_Init()
	If	DllCall("oleacc\AccessibleObjectFromWindow", "Ptr", hWnd, "UInt", idObject&=0xFFFFFFFF, "Ptr", -VarSetCapacity(IID,16)+NumPut(idObject==0xFFFFFFF0?0x46000000000000C0:0x719B3800AA000C81,NumPut(idObject==0xFFFFFFF0?0x0000000000020400:0x11CF3C3D618736E0,IID,"Int64"),"Int64"), "Ptr*", pacc)=0
	Return	ComObjEnwrap(9,pacc,1)
}
Acc_ObjectFromWindow2(hWnd, idObject = -4)
{
	;~ Acc_Init()
	
	If DllCall(AccessibleObjectFromWindowProc, "Ptr", hWnd, "UInt", idObject&=0xFFFFFFFF, "Ptr", -VarSetCapacity(IID,16)+NumPut(idObject==0xFFFFFFF0?0x46000000000000C0:0x719B3800AA000C81,NumPut(idObject==0xFFFFFFF0?0x0000000000020400:0x11CF3C3D618736E0,IID,"Int64"),"Int64"), "Ptr*", pacc)=0
	Return	ComObjEnwrap(9,pacc,1)
}
Acc_WindowFromObject(pacc)
{
	If	DllCall("oleacc\WindowFromAccessibleObject", "Ptr", IsObject(pacc)?ComObjValue(pacc):pacc, "Ptr*", hWnd)=0
	Return	hWnd
}

Acc_GetRoleText(nRole)
{
	nSize := DllCall("oleacc\GetRoleText", "Uint", nRole, "Ptr", 0, "Uint", 0)
	,VarSetCapacity(sRole, (A_IsUnicode?2:1)*nSize)
	,DllCall("oleacc\GetRoleText", "Uint", nRole, "str", sRole, "Uint", nSize+1)
	Return	sRole
}

Acc_GetStateText(nState)
{
	nSize := DllCall("oleacc\GetStateText", "Uint", nState, "Ptr", 0, "Uint", 0)
	,VarSetCapacity(sState, (A_IsUnicode?2:1)*nSize)
	,DllCall("oleacc\GetStateText", "Uint", nState, "str", sState, "Uint", nSize+1)
	Return	sState
}

Acc_SetWinEventHook(eventMin, eventMax, pCallback)
{
	Return	DllCall("SetWinEventHook", "Uint", eventMin, "Uint", eventMax, "Uint", 0, "Ptr", pCallback, "Uint", 0, "Uint", 0, "Uint", 0)
}

Acc_UnhookWinEvent(hHook)
{
	Return	DllCall("UnhookWinEvent", "Ptr", hHook)
}
/*	Win Events:

	pCallback := RegisterCallback("WinEventProc")
	WinEventProc(hHook, event, hWnd, idObject, idChild, eventThread, eventTime)
	{
		Critical
		Acc := Acc_ObjectFromEvent(_idChild_, hWnd, idObject, idChild)
		; Code Here:

	}
*/

; Written by jethrow
Acc_Role(Acc, ChildId=0) {
	try return ComObjType(Acc,"Name")="IAccessible"?Acc_GetRoleText(Acc.accRole(ChildId)):"invalid object"
}
Acc_State(Acc, ChildId=0) {
	try return ComObjType(Acc,"Name")="IAccessible"?Acc_GetStateText(Acc.accState(ChildId)):"invalid object"
}
Acc_Location(Acc, ChildId=0, byref Position="") { ; adapted from Sean's code
	try Acc.accLocation(ComObj(0x4003,&x:=0), ComObj(0x4003,&y:=0), ComObj(0x4003,&w:=0), ComObj(0x4003,&h:=0), ChildId)
	catch
		return
	Position := "x" NumGet(x,0,"int") " y" NumGet(y,0,"int") " w" NumGet(w,0,"int") " h" NumGet(h,0,"int")
	return	{x:NumGet(x,0,"int"), y:NumGet(y,0,"int"), w:NumGet(w,0,"int"), h:NumGet(h,0,"int")}
}
Acc_Parent(Acc) { 
	try parent:=Acc.accParent
	return parent?Acc_Query(parent):
}
Acc_Child(Acc, ChildId=0) {
	try child:=Acc.accChild(ChildId)
	return child?Acc_Query(child):
}
Acc_Query(Acc) { ; thanks Lexikos - www.autohotkey.com/forum/viewtopic.php?t=81731&p=509530#509530
	try return ComObj(9, ComObjQuery(Acc,"{618736e0-3c3d-11cf-810c-00aa00389b71}"), 1)
}
Acc_Error(p="") {
	static setting:=0
	return p=""?setting:setting:=p
}
Acc_Children(Acc) {
	if ComObjType(Acc,"Name") != "IAccessible"
		ErrorLevel := "Invalid IAccessible Object"
	else {
		Acc_Init(), cChildren:=Acc.accChildCount, Children:=[]
		if DllCall("oleacc\AccessibleChildren", "Ptr",ComObjValue(Acc), "Int",0, "Int",cChildren, "Ptr",VarSetCapacity(varChildren,cChildren*(8+2*A_PtrSize),0)*0+&varChildren, "Int*",cChildren)=0 {
			Loop %cChildren%
				i:=(A_Index-1)*(A_PtrSize*2+8)+8, child:=NumGet(varChildren,i), Children.push(NumGet(varChildren,i-8)=9?Acc_Query(child):child), NumGet(varChildren,i-8)=9?ObjRelease(child):
			return Children.MaxIndex()?Children:
		} else
			ErrorLevel := "AccessibleChildren DllCall Failed"
	}
	if Acc_Error()
		throw Exception(ErrorLevel,-1)
}

Acc_Children_first(Acc,Count=1){
	if ComObjType(Acc,"Name") != "IAccessible"
		ErrorLevel := "Invalid IAccessible Object"
	else {
		Acc_Init(), cChildren:=Acc.accChildCount, Children:=[]
		if DllCall("oleacc\AccessibleChildren", "Ptr",ComObjValue(Acc), "Int",0, "Int",cChildren, "Ptr",VarSetCapacity(varChildren,cChildren*(8+2*A_PtrSize),0)*0+&varChildren, "Int*",cChildren)=0 {
			Loop %cChildren%
			{
				if A_Index>Count
					break
				i:=(A_Index-1)*(A_PtrSize*2+8)+8, child:=NumGet(varChildren,i), Children.push(NumGet(varChildren,i-8)=9?Acc_Query(child):child), NumGet(varChildren,i-8)=9?ObjRelease(child):
			}
			return Children.MaxIndex()?Children:[]
		} else
			ErrorLevel := "AccessibleChildren DllCall Failed"
	}
	if Acc_Error()
		throw Exception(ErrorLevel,-1)
}


Acc_ChildrenByRole(Acc, Role) {
	if ComObjType(Acc,"Name")!="IAccessible"
		ErrorLevel := "Invalid IAccessible Object"
	else {
		Acc_Init(), cChildren:=Acc.accChildCount, Children:=[]
		if DllCall("oleacc\AccessibleChildren", "Ptr",ComObjValue(Acc), "Int",0, "Int",cChildren, "Ptr",VarSetCapacity(varChildren,cChildren*(8+2*A_PtrSize),0)*0+&varChildren, "Int*",cChildren)=0 {
			Loop %cChildren% {
				i:=(A_Index-1)*(A_PtrSize*2+8)+8, child:=NumGet(varChildren,i)
				if NumGet(varChildren,i-8)=9
					AccChild:=Acc_Query(child), ObjRelease(child), Acc_Role(AccChild)=Role?Children.push(AccChild):
				else
					Acc_Role(Acc, child)=Role?Children.push(child):
			}
			return Children.MaxIndex()?Children:, ErrorLevel:=0
		} else
			ErrorLevel := "AccessibleChildren DllCall Failed"
	}
	if Acc_Error()
		throw Exception(ErrorLevel,-1)
}
Acc_Get(Cmd, ChildPath="", ChildID=0, WinTitle="", WinText="", ExcludeTitle="", ExcludeText="") {
	static properties := {Action:"DefaultAction", DoAction:"DoDefaultAction", Keyboard:"KeyboardShortcut"}
	AccObj :=   IsObject(WinTitle)? WinTitle
			:   Acc_ObjectFromWindow( WinExist(WinTitle, WinText, ExcludeTitle, ExcludeText), 0 )
	if ComObjType(AccObj, "Name") != "IAccessible"
		ErrorLevel := "Could not access an IAccessible Object"
	else {
		StringReplace, ChildPath, ChildPath, _, %A_Space%, All
		AccError:=Acc_Error(), Acc_Error(true)
		Loop Parse, ChildPath, ., %A_Space%
			try {
				if A_LoopField is digit
					Children:=Acc_Children(AccObj), m2:=A_LoopField ; mimic "m2" output in else-statement
				else
					RegExMatch(A_LoopField, "(\D*)(\d*)", m), Children:=Acc_ChildrenByRole(AccObj, m1), m2:=(m2?m2:1)
				if Not Children.HasKey(m2)
					throw
				AccObj := Children[m2]
			} catch {
				ErrorLevel:="Cannot access ChildPath Item #" A_Index " -> " A_LoopField, Acc_Error(AccError)
				if Acc_Error()
					throw Exception("Cannot access ChildPath Item", -1, "Item #" A_Index " -> " A_LoopField)
				return
			}
		Acc_Error(AccError)
		StringReplace, Cmd, Cmd, %A_Space%, , All
		properties.HasKey(Cmd)? Cmd:=properties[Cmd]:
		try {
			if (Cmd = "Location")
				AccObj.accLocation(ComObj(0x4003,&x:=0), ComObj(0x4003,&y:=0), ComObj(0x4003,&w:=0), ComObj(0x4003,&h:=0), ChildId)
			  , ret_val := "x" NumGet(x,0,"int") " y" NumGet(y,0,"int") " w" NumGet(w,0,"int") " h" NumGet(h,0,"int")
			else if (Cmd = "Object")
				ret_val := AccObj
			else if Cmd in Role,State
				ret_val := Acc_%Cmd%(AccObj, ChildID+0)
			else if Cmd in ChildCount,Selection,Focus
				ret_val := AccObj["acc" Cmd]
			else
				ret_val := AccObj["acc" Cmd](ChildID+0)
		} catch {
			ErrorLevel := """" Cmd """ Cmd Not Implemented"
			if Acc_Error()
				throw Exception("Cmd Not Implemented", -1, Cmd)
			return
		}
		return ret_val, ErrorLevel:=0
	}
	if Acc_Error()
		throw Exception(ErrorLevel,-1)
}

;~ acc:=new AccObj(0x1840f32)
;~ msgbox % clipboard:=acc.childrenTreeStr()
;~ exitapp
Class AccObj {
	__New(hwnd){
		if !hwnd
			return 
		setformat,integer,h
		if isobject(hwnd) {
			
			this.hwnd:=acc_windowfromobject(hwnd)
			this.acc:=hwnd
		}else{
			this.hwnd:=hwnd
			this.acc:=acc_objectfromwindow(hwnd)
		}
		setformat,integer,d
	}
	
	
	loc(childId=0, byref pos=""){
		return Acc_Location(this.Acc, childId, pos)
	}
	
	get(Cmd, ChildPath="", ChildID=0,WinTitle="", WinText="", ExcludeTitle="", ExcludeText=""){
		if (WinTitle WinText ExcludeTitle ExcludeText="")
			wintitle:=this.acc
		get:=Acc_Get(Cmd, ChildPath, ChildID, WinTitle, WinText, ExcludeTitle, ExcludeText)
		return isobject(get)?(new AccObj(get)):get
	}
	
	parent(){
		return new AccObj(acc_parent(this.acc))
	}
	
	children(ind=""){
		ret:=[]
		ch:=acc_children(this.acc)
		if (ind=""){
			
			if ch.maxindex() {
			for k,v in acc_children(this.acc)
				ret.push(new AccObj(v))
			}
		}else{
			ret:=new AccObj(acc_children(this.acc)[ind])
		}

		return ret
	}
	
	__Get(childrenCount){
		ret:=acc_children(this.acc)
		return (ret.maxIndex()?ret.maxIndex():0)
	}
	
	childrenTree(obj=""){
		arr:=[]
		if (obj="")
			obj:=this
		arr[0]:=obj
		ch:=obj.children()
		if ch.maxIndex() {
			for k,v in ch
				arr.push(obj.childrenTree(v))
		}
		return arr
	}

	childrenTreeStr(byref node="",win=""){
		;~ if (controls=""){
			;~ a:=this
			;~ loop
				;~ a:=a.parent()
			;~ until a.parent().hwnd=a.hwnd
			;~ controls:=this.getControls(a.hwnd)
		;~ }
		
		if win=
			win:=this.belongWin()
		;~ for k,v in controls
			;~ if (v.hwnd=this.hwnd) {
		/*
		setformat,integer,h	
		controlgettext,text,,% "ahk_id " this.hwnd
				str:=this.hwnd "|" Control_GetClassNN(win,this.hwnd) "|" text "`n"
				;~ break
			;~ }
		setformat,integer,d
		;~ controls:=this.getControls()
		ch:=this.children()
		loop % ch.maxIndex()
			str.="`t" ch[a_index].childrenTreeStr(win)
			
			*/
		if node=
			node:=this.childrenTree()
		controlgettext,text,,% "ahk_id " node[0].hwnd
		str:=node[0].hwnd "|" Control_GetClassNN(win,node[0].hwnd) "|" text "`n"
		for k,v in node {
			if k
				str.="`t" this.childrenTreeStr(v,win)
		}
		
		return str
	}
	
	GetControls(hwnd="")
	{
		if hwnd=
			hwnd:=this.hwnd
		controls:=[]
		winget,classnn,ControlList,ahk_id %hwnd%
		winget,controlId,controllisthwnd,ahk_id %hwnd%
		loop,parse,classnn,`n
		{
			controls[a_index]:=[]
			controls[a_index]["ClassNN"]:=a_loopfield
		}
		
		loop,parse,controlId,`n
		{
			controls[a_index]["Hwnd"]:=a_loopfield
			controlgetText,txt,,ahk_id %a_loopfield%
			controls[a_index]["text"]:=txt
		}
		return controls
	}
	
	belongWin(){
		WinGet, all, list
		DetectHiddenWindows,on
		
		Loop, %all%
		{
			setformat,integer,d
            v := all%A_Index%
			winget,controls,controllisthwnd,ahk_id %v%
			setformat,integer,h
			hwnd:=this.hwnd
			if regexmatch(controls,"\b" hwnd "\b") {
				
			;~ for x,y in controls:=this.getControls(v) 
				;~ if (y.hwnd=this.hwnd){
					found:=v
					break
				}
		}
		return found?found:0
	}
}

Acc_Children2(pacc, cChildren, ByRef varChildren)
{
	Acc_Init()
	If	DllCall("oleacc\AccessibleChildren", "Ptr", IsObject(pacc)?ComObjValue(pacc):pacc, "Int", 0, "Int", cChildren, "Ptr", VarSetCapacity(varChildren,cChildren*(8+2*A_PtrSize),0)*0+&varChildren, "Int*", cChildren)=0
	Return	cChildren
}

Acc_EnumChildren(Acc) {
	Children := []
	Loop, % Acc_Children2(Acc, Acc.accChildCount, varChildren)
		i := (A_Index-1)*(A_PtrSize*2+8)+8
	  , child := NumGet(varChildren,i)
	  , Children.push(NumGet(varChildren,i-8)=3?child:ComObj(9,child,1))
	return, {	Items:		Children
			,	_NewEnum:	Func("Acc_Enum_NewEnum")
			,	Next:		Func("Acc_Enum_Next")	
			,	base:		{__Get:Func("Acc_Enum_Get")}	}
}
Acc_Enum_NewEnum(obj) {
	return, obj
}
Acc_Enum_Next(obj, byref child, byref type="") {
	If Not obj.HasKey("child")
		obj.child:=child, obj.type:=type
	If Not obj.Items.MaxIndex() {
		child:=obj.child, type:=obj.type
		return, false
	} else {
		child:=obj.Items.Delete(1), type:=IsObject(child)?9:3
		return, true
	}
}
Acc_Enum_Get(obj, key) {
	return, obj.Items[key]
}
