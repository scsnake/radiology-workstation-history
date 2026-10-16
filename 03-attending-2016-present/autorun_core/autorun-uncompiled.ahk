﻿﻿﻿; <COMPILER: v1.1.09.02>



#NoEnv



#SingleInstance,force



SetBatchLines,-1



DetectHiddenWindows, On



SetTitleMatchMode,2



coordmode,mouse,screen



#NoTrayIcon



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



VarSetCapacity(sRole, (A_IsUnicode?2:1)*nSize)



DllCall("oleacc\GetRoleText", "Uint", nRole, "str", sRole, "Uint", nSize+1)



Return	sRole



}



Acc_GetStateText(nState)



{



nSize := DllCall("oleacc\GetStateText", "Uint", nState, "Ptr", 0, "Uint", 0)



VarSetCapacity(sState, (A_IsUnicode?2:1)*nSize)



DllCall("oleacc\GetStateText", "Uint", nState, "str", sState, "Uint", nSize+1)



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



Acc_Role(Acc, ChildId=0) {



try return ComObjType(Acc,"Name")="IAccessible"?Acc_GetRoleText(Acc.accRole(ChildId)):"invalid object"



}



Acc_State(Acc, ChildId=0) {



try return ComObjType(Acc,"Name")="IAccessible"?Acc_GetStateText(Acc.accState(ChildId)):"invalid object"



}



Acc_Location(Acc, ChildId=0, byref Position="") {



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



Acc_Query(Acc) {



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



Children:=Acc_Children(AccObj), m2:=A_LoopField



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



listAccChildProperty(hwnd){



COM_AccInit()



If	pacc :=	COM_AccessibleObjectFromWindow(hWnd)



{



sResult	:="[Window]`n"



. "Name:`t`t"		COM_Invoke(pacc,"accName",0) "`n"



. "Value:`t`t"		COM_Invoke(pacc,"accValue",0) "`n"



. "Description:`t"	COM_Invoke(pacc,"accDescription",0) "`n"



. COM_Invoke(pacc,"accDefaultAction",0) "`n"



. COM_Invoke(pacc,"accHelp",0) "`n"



. COM_Invoke(pacc,"accKeyboardShortcut",0) "`n"



. COM_Invoke(pacc,"accRole",0) "`n"



. COM_Invoke(pacc,"accState",0) "`n"



Loop, %	COM_AccessibleChildren(pacc, COM_Invoke(pacc,"accChildCount"), varChildren)



If	NumGet(varChildren,16*(A_Index-1),"Ushort")=3 && idChild:=NumGet(varChildren,16*A_Index-8)



sResult	.="[" A_Index "]`n"



. "Name:`t`t"		COM_Invoke(pacc,"accName",idChild) "`n"



. "Value:`t`t"		COM_Invoke(pacc,"accValue",idChild) "`n"



. "Description:`t"	COM_Invoke(pacc,"accDescription",idChild) "`n"



. COM_Invoke(pacc,"accParent",idChild) "`n"



Else If	paccChild:=NumGet(varChildren,16*A_Index-8) {



sResult	.="[" A_Index "]`n"



. "Name:`t`t"		COM_Invoke(paccChild,"accName",0) "`n"



. "Value:`t`t"		COM_Invoke(paccChild,"accValue",0) "`n"



. "Description:`t"	COM_Invoke(paccChild,"accDescription",0) "`n"



if a_index=3



{



numput(1,var,"UInt")



COM_Invoke(pacc,"accSelect",1,paccChild)



}



COM_Release(paccChild)



}



COM_Release(pacc)



}



COM_AccTerm()



return sResult



}



getControlNameByHwnd(winHwnd,controlHwnd){



bufSize=1024



winget,processID,pid,ahk_id %winHwnd%



VarSetCapacity(var1,bufSize)



getName:=DllCall( "RegisterWindowMessage", "str", "WM_GETCONTROLNAME" )



dwResult:=DllCall("GetWindowThreadProcessId", "UInt", winHwnd)



hProcess:=DllCall("OpenProcess", "UInt", 0x8 | 0x10 | 0x20, "Uint", 0, "UInt", processID)



otherMem:=DllCall("VirtualAllocEx", "Ptr", hProcess, "Ptr", 0, "PTR", bufSize, "UInt", 0x3000, "UInt", 0x0004, "Ptr")



SendMessage,%getName%,%bufSize%,%otherMem%,,ahk_id %controlHwnd%



DllCall("ReadProcessMemory","UInt",hProcess,"UInt",otherMem,"Str",var1,"UInt",bufSize,"UInt *",0)



DllCall("CloseHandle","Ptr",hProcess)



DllCall("VirtualFreeEx","Ptr", hProcess,"UInt",otherMem,"UInt", 0, "UInt", 0x8000)



return var1



}



getByControlName(winHwnd,name){



winget,controlList,controlListhwnd,ahk_id %winHwnd%



arr:=[]



,bufSize=1024



winget,processID,pid,ahk_id %winHwnd%



VarSetCapacity(var1,bufSize)



if !(getName:=DllCall( "RegisterWindowMessage", "str", "WM_GETCONTROLNAME" ))



return []



if !(dwResult:=DllCall("GetWindowThreadProcessId", "UInt", winHwnd))



return []



if !(hProcess:=DllCall("OpenProcess", "UInt", 0x8 | 0x10 | 0x20, "Uint", 0, "UInt", processID))



return []



if !(otherMem:=DllCall("VirtualAllocEx", "Ptr", hProcess, "Ptr", 0, "PTR", bufSize, "UInt", 0x3000, "UInt", 0x0004, "Ptr"))



return []



loop,parse,controlList,`n



{



SendMessage,%getName%,%bufSize%,%otherMem%,,ahk_id %a_loopfield%



if errorlevel=FAIL



return []



if !DllCall("ReadProcessMemory","UInt",hProcess,"UInt",otherMem,"Str",var1,"UInt",bufSize,"UInt *",0)



return []



if (var1=name)



arr.push(a_loopfield)



,var1:=""



}



DllCall("VirtualFreeEx","Ptr", hProcess,"UInt",otherMem,"UInt", 0, "UInt", 0x8000)



DllCall("CloseHandle","Ptr",hProcess)



return arr



}



controlGetText(hwnd){



controlgettext,t,,ahk_id %hwnd%



return t



}



winGetClass(hwnd){



WinGetClass,cl,ahk_id %hwnd%



return cl



}



getNetControl2(winHwnd,text="",controlName="",accName="",classNN="",accHelp="",accRole="",style="",shift=0){



winget,list,controllisthwnd,ahk_id %winHwnd%



arr:=[],controlArr:=[]



loop,parse,list,`n



{



controlArr.push(a_loopfield)



if (text="" || instr(controlgettext(a_loopfield),text)) && (classNN="" || instr(winGetClass(a_loopfield),classNN)) && (controlName="" || getControlNameByHwnd(winHwnd,a_loopfield)=controlName) && (accName="" || instr((acc:=acc_objectfromwindow(a_loopfield)).accName,accName)) && (accHelp="" || instr(acc.accHelp,accHelp)) && (accRole="" || instr(acc.accRole,accRole)) && (!style || DllCall("GetWindowLong",UInt,a_loopfield,Int,-16)=style)



arr[a_index]:=a_loopfield



}



result:=[]



for k,v in arr



if (r:=controlArr[k+shift])



result.push(r)



return result



}



getNetControl(winHwnd,controlName="",accName="",classNN="",accHelp=""){



winget,list,controllisthwnd,ahk_id %winHwnd%



bufSize=1024



winget,processID,pid,ahk_id %winHwnd%



VarSetCapacity(var1,bufSize)



getName:=DllCall( "RegisterWindowMessage", "str", "WM_GETCONTROLNAME" )



dwResult:=DllCall("GetWindowThreadProcessId", "UInt", winHwnd)



hProcess:=DllCall("OpenProcess", "UInt", 0x8 | 0x10 | 0x20, "Uint", 0, "UInt", processID)



otherMem:=DllCall("VirtualAllocEx", "Ptr", hProcess, "Ptr", 0, "PTR", bufSize, "UInt", 0x3000, "UInt", 0x0004, "Ptr")



count=0



loop,parse,list,`n



{



SendMessage,%getName%,%bufSize%,%otherMem%,,ahk_id %a_loopfield%



DllCall("ReadProcessMemory","UInt",hProcess,"UInt",otherMem,"Str",var1,"UInt",bufSize,"UInt *",0)



if ((var1&&var1=controlName)&&(accName=""||(acc:=Acc_ObjectFromWindow(a_loopfield)).accName=accName)){



WinGetClass,cl,ahk_id %a_loopfield%



if(instr(cl,classNN)=1&&(accHelp=""||acc.accHelp=accHelp)) {



ret:=a_loopfield



break



}



}



var1:=""



}



DllCall("VirtualFreeEx","Ptr", hProcess,"UInt",otherMem,"UInt", 0, "UInt", 0x8000)



DllCall("CloseHandle","Ptr",hProcess)



DllCall("FreeLibrary", "Ptr", hModule)



return ret



}



getControlDescription(winHwnd,controlHwnd){



return "getNetControl2(RisState[2],""" controlgettext(controlHwnd) """,""" getControlNameByHwnd(winHwnd,controlHwnd) """,""" (acc:=acc_objectfromwindow(controlHwnd)).accName """,""" winGetClass(controlHwnd) """,""" acc.accHelp """,""" acc.accRole """,""" DllCall("GetWindowLong",UInt,controlHwnd,Int,-16) """,0)"



}



Edit_CanUndo(hEdit)



{



Static EM_CANUNDO:=0xC6



SendMessage EM_CANUNDO,0,0,,ahk_id %hEdit%



Return ErrorLevel



}



Edit_CharFromPos(hEdit,X,Y,ByRef r_CharPos="",ByRef r_LineIdx="")



{



Static EM_CHARFROMPOS:=0xD7



SendMessage EM_CHARFROMPOS,0,(Y<<16)|X,,ahk_id %hEdit%



if (ErrorLevel=0xFFFFFFFF)



{



r_CharPos:=-1



r_LineIdx:=-1



Return r_CharPos



}



r_CharPos:=ErrorLevel & 0xFFFF



r_LineIdx:=ErrorLevel>>16



FirstLine:=Edit_GetFirstVisibleLine(hEdit)-1



if (FirstLine>r_LineIdx)



r_LineIdx:=r_LineIdx+(65536*Floor((FirstLine+(65535-r_LineIdx))/65536))



FirstCharPos:=Edit_LineIndex(hEdit,FirstLine<0 ? 0:FirstLine)



if (FirstCharPos>r_CharPos)



r_CharPos:=r_CharPos+(65536*Floor((FirstCharPos+(65535-r_CharPos))/65536))



Return r_CharPos



}



Edit_Clear(hEdit)



{



Static WM_CLEAR:=0x303



SendMessage WM_CLEAR,0,0,,ahk_id %hEdit%



}



Edit_Convert2DOS(p_Text)



{



StringReplace p_Text,p_Text,`r`n,`n,All



StringReplace p_Text,p_Text,`r,`n,All



StringReplace p_Text,p_Text,`n,`r`n,All



Return p_Text



}



Edit_Convert2Mac(p_Text)



{



StringReplace p_Text,p_Text,`r`n,`r,All



StringReplace p_Text,p_Text,`n,`r,All



if StrLen(p_Text)



if p_Text not Contains `r



p_Text .= "`r"



Return p_Text



}



Edit_Convert2Unix(p_Text)



{



StringReplace p_Text,p_Text,`r`n,`n,All



StringReplace p_Text,p_Text,`r,`n,All



if StrLen(p_Text)



if p_Text not Contains `n



p_Text .= "`n"



Return p_Text



}



Edit_ConvertCase(hEdit,p_Case)



{



Edit_GetSel(hEdit,l_StartSelPos,l_EndSelPos)



if (l_StartSelPos=l_EndSelPos)



Return



l_SelectedText:=Edit_GetSelText(hEdit)



if l_SelectedText is Space



Return



if p_Case in U,Upper,Uppercase



StringUpper l_SelectedText,l_SelectedText



else



if p_Case in L,Lower,Lowercase



StringLower l_SelectedText,l_SelectedText



else



if p_Case in C,Capitalize,Title,TitleCase



StringLower l_SelectedText,l_SelectedText,T



else



if p_Case in T,Toggle,ToggleCase,I,Invert,InvertCase



{



t_SelectedText=



Loop Parse,l_SelectedText



{



t_Char:=A_LoopField



l_Asc:=Asc(t_Char)



if l_Asc between 65 and 90



t_Char:=Chr(l_Asc+32)



else



if l_Asc between 97 and 122



t_Char:=Chr(l_Asc-32)



t_SelectedText .= t_Char



}



l_SelectedText:=t_SelectedText



}



Edit_ReplaceSel(hEdit,l_SelectedText)



Edit_SetSel(hEdit,l_StartSelPos,l_EndSelPos)



}



Edit_Copy(hEdit)



{



Static WM_COPY:=0x301



SendMessage WM_COPY,0,0,,ahk_id %hEdit%



}



Edit_Cut(hEdit)



{



Static WM_CUT:=0x300



SendMessage WM_CUT,0,0,,ahk_id %hEdit%



}



Edit_EmptyUndoBuffer(hEdit)



{



Static EM_EMPTYUNDOBUFFER:=0xCD



SendMessage EM_EMPTYUNDOBUFFER,0,0,,ahk_id %hEdit%



}



Edit_FindText(hEdit,p_SearchText,p_Min=0,p_Max=-1,p_Flags="",ByRef r_RegExOut="")



{



Static s_Text



r_RegExOut:=""



if InStr(p_Flags,"Reset")



s_Text:=""



if StrLen(p_SearchText)=0



Return -1



l_MaxLen:=Edit_GetTextLength(hEdit)



if (l_MaxLen=0)



Return -1



if (p_Min<0 or p_Max>l_MaxLen)



p_Min:=l_MaxLen



if (p_Max<0 or p_Max>l_MaxLen)



p_Max:=l_MaxLen



if (p_Min=p_Max)



Return -1



if InStr(p_Flags,"Static")



{



if StrLen(s_Text)=0



s_Text:=Edit_GetText(hEdit)



l_Text:=SubStr(s_Text,(p_Max>p_Min) ? p_Min+1:p_Max+1,(p_Max>p_Min) ? p_Max:p_Min)



}



else



{



s_Text:=""



l_Text:=Edit_GetTextRange(hEdit,(p_Max>p_Min) ? p_Min:p_Max,(p_Max>p_Min) ? p_Max:p_Min)



}



if InStr(p_Flags,"RegEx")=0



l_FoundPos:=InStr(l_Text,p_SearchText,InStr(p_Flags,"MatchCase"),(p_Max>p_Min) ? 1:0)-1



else



{



p_SearchText:=RegExReplace(p_SearchText,"^P\)?","",1)



if (p_Max>p_Min)



{



l_FoundPos:=RegExMatch(l_Text,p_SearchText,r_RegExOut,1)-1



if ErrorLevel



{



outputdebug,



                   (ltrim join`s



                    Function: %A_ThisFunc% - RegExMatch error.



                    ErrorLevel=%ErrorLevel%



)



l_FoundPos:=-1



}



}



else



{



RE_MinPos     :=1



RE_MaxPos     :=StrLen(l_Text)



RE_StartPos   :=RE_MinPos



Saved_FoundPos:=-1



Saved_RegExOut:=""



loop



{



l_FoundPos:=RegExMatch(l_Text,p_SearchText,r_RegExOut,RE_StartPos)-1



if ErrorLevel



{



outputdebug,



                       (ltrim join`s



                        Function: %A_ThisFunc% - RegExMatch error.



                        ErrorLevel=%ErrorLevel%



)



l_FoundPos:=-1



Break



}



if (l_FoundPos>-1)



{



Saved_FoundPos:=l_FoundPos



Saved_RegExOut:=r_RegExOut



RE_MinPos     :=l_FoundPos+2



}



else



RE_MaxPos:=RE_StartPos-1



if (RE_MinPos>RE_MaxPos or RE_MinPos>StrLen(l_Text))



{



l_FoundPos:=Saved_FoundPos



r_RegExOut:=Saved_RegExOut



Break



}



RE_StartPos:=RE_MinPos+Floor((RE_MaxPos-RE_MinPos)/2)



}



}



}



if (l_FoundPos>-1)



l_FoundPos += (p_Max>p_Min) ? p_Min:p_Max



Return l_FoundPos



}



Edit_FindTextReset()



{



Edit_FindText("","",0,0,"Reset")



}



Edit_FmtLines(hEdit,p_Flag)



{



Static EM_FMTLINES:=0xC8



SendMessage EM_FMTLINES,p_Flag,0,,ahk_id %hEdit%



Return ErrorLevel



}



Edit_GetFirstVisibleLine(hEdit)



{



Static EM_GETFIRSTVISIBLELINE:=0xCE



SendMessage EM_GETFIRSTVISIBLELINE,0,0,,ahk_id %hEdit%



Return ErrorLevel



}



Edit_GetLastVisibleLine(hEdit)



{



Edit_GetRect(hEdit,Left,Top,Right,Bottom)



Return Edit_LineFromPos(hEdit,0,Bottom-1)



}



Edit_GetLimitText(hEdit)



{



Static EM_GETLIMITTEXT:=0xD5



SendMessage EM_GETLIMITTEXT,0,0,,ahk_id %hEdit%



Return ErrorLevel<<32>>32



}



Edit_GetLine(hEdit,p_LineIdx=-1,p_Length=-1)



{



Static EM_GETLINE:=0xC4



if (p_LineIdx<0)



p_LineIdx:=Edit_LineFromChar(hEdit,Edit_LineIndex(hEdit))



if (p_Length>-1)



l_Length:=p_Length



else



l_Length:=Edit_LineLength(hEdit,p_LineIdx)



if l_Length=0



Return



VarSetCapacity(l_Text,l_Length=1 ? 2:l_Length,0)



NumPut(l_Length=1 ? 2:l_Length,l_Text,0,"UShort")



SendMessage EM_GETLINE,p_LineIdx,&l_Text,,ahk_id %hEdit%



Return l_Length=1 ? SubStr(l_Text,1,1):l_Text



}



Edit_GetLineCount(hEdit)



{



Static EM_GETLINECOUNT:=0xBA



SendMessage EM_GETLINECOUNT,0,0,,ahk_id %hEdit%



Return ErrorLevel



}



Edit_GetMargins(hEdit,ByRef r_LeftMargin="",ByRef r_RightMargin="")



{



Static EM_GETMARGINS:=0xD4



SendMessage EM_GETMARGINS,0,0,,ahk_id %hEdit%



r_LeftMargin :=ErrorLevel & 0xFFFF



r_RightMargin:=ErrorLevel>>16



Return r_LeftMargin



}



Edit_GetModify(hEdit)



{



Static EM_GETMODIFY:=0xB8



SendMessage EM_GETMODIFY,0,0,,ahk_id %hEdit%



Return ErrorLevel



}



Edit_GetRect(hEdit,ByRef r_Left="",ByRef r_Top="",ByRef r_Right="",ByRef r_Bottom="")



{



Static EM_GETRECT:=0xB2



VarSetCapacity(RECT_Structure,16,0)



SendMessage EM_GETRECT,0,&RECT_Structure,,ahk_id %hEdit%



r_Left  :=NumGet(RECT_Structure,0,"Int")



r_Top   :=NumGet(RECT_Structure,4,"Int")



r_Right :=NumGet(RECT_Structure,8,"Int")



r_Bottom:=NumGet(RECT_Structure,12,"Int")



Return r_Left . A_Space . r_Top . A_Space . r_Right . A_Space . r_Bottom



}



Edit_GetSel(hEdit,ByRef r_StartSelPos="",ByRef r_EndSelPos="")



{



Static EM_GETSEL:=0xB0



VarSetCapacity(l_StartSelPos,4,0)



VarSetCapacity(l_EndSelPos,4,0)



SendMessage EM_GETSEL,&l_StartSelPos,&l_EndSelPos,,ahk_id %hEdit%



r_StartSelPos:=NumGet(l_StartSelPos)



r_EndSelPos  :=NumGet(l_EndSelPos)



Return r_StartSelPos



}



Edit_GetSelText(hEdit,l_startSelPos="",l_endSelPos="")



{



if l_startselpos= || l_endselpos=



Edit_GetSel(hEdit,l_StartSelPos,l_EndSelPos)



if (l_StartSelPos=l_EndSelPos)



Return



l_FirstSelectedLine:=Edit_LineFromChar(hEdit,l_StartSelPos)



l_LastSelectedLine :=Edit_LineFromChar(hEdit,l_EndSelPos)



l_FirstPos:=Edit_LineIndex(hEdit,l_FirstSelectedLine)



if (l_FirstSelectedLine=l_LastSelectedLine)



and (l_EndSelPos<=l_FirstPos+Edit_LineLength(hEdit,l_FirstSelectedLine))



Return SubStr(Edit_GetLine(hEdit,l_FirstSelectedLine,l_EndSelPos-l_FirstPos),l_StartSelPos-l_FirstPos+1)



else



Return SubStr(Edit_GetText(hEdit,l_EndSelPos),l_StartSelPos+1)



}



Edit_GetText(hEdit,p_Length=-1)



{



Static WM_GETTEXT:=0xD



if (p_Length<0)



p_Length:=Edit_GetTextLength(hEdit)



VarSetCapacity(l_Text,p_Length+1,0)



SendMessage WM_GETTEXT,p_Length+1,&l_Text,,ahk_id %hEdit%



return l_Text



}



Edit_GetTextLength(hEdit)



{



Static WM_GETTEXTLENGTH:=0xE



SendMessage WM_GETTEXTLENGTH,0,0,,ahk_id %hEdit%



Return ErrorLevel



}



Edit_GetTextRange(hEdit,p_Min=0,p_Max=-1)



{



Return SubStr(Edit_GetText(hEdit,p_Max),p_Min+1)



}



Edit_IsMultiline(hEdit)



{



Static ES_MULTILINE:=0x4



Return Edit_IsStyle(hEdit,ES_MULTILINE)



}



Edit_IsReadOnly(hEdit)



{



Static ES_READONLY:=0x800



Return Edit_IsStyle(hEdit,ES_READONLY)



}



Edit_IsStyle(hEdit,p_Style)



{



Static GWL_STYLE:=-16



ControlGet l_Style,Style,,,ahk_id %hEdit%



Return l_Style & p_Style ? True:False



}



Edit_SetStyle(hEdit,p_Style,p_Option="+")



{



Control Style,%p_Option%%p_Style%,,ahk_id %hEdit%



Return ErrorLevel ? False:True



}



Edit_LineFromChar(hEdit,p_CharPos=-1)



{



Static EM_LINEFROMCHAR:=0xC9



SendMessage EM_LINEFROMCHAR,p_CharPos,0,,ahk_id %hEdit%



Return ErrorLevel



}



Edit_LineFromPos(hEdit,X,Y,ByRef r_CharPos="",ByRef r_LineIdx="")



{



Edit_CharFromPos(hEdit,X,Y,r_CharPos,r_LineIdx)



Return r_LineIdx



}



Edit_LineIndex(hedit,p_LineIdx=-1)



{



Static EM_LINEINDEX:=0xBB



SendMessage EM_LINEINDEX,p_LineIdx,0,,ahk_id %hEdit%



Return ErrorLevel<<32>>32



}



Edit_LineLength(hEdit,p_LineIdx=-1)



{



Static EM_LINELENGTH:=0xC1



l_CharPos:=Edit_LineIndex(hEdit,p_LineIdx)



if (l_CharPos<0)



l_CharPos:=Edit_LineIndex(hEdit,Edit_GetTextLength(hEdit)-1)



SendMessage EM_LINELENGTH,l_CharPos,0,,ahk_id %hEdit%



Return ErrorLevel



}



Edit_LineScroll(hEdit,xScroll=0,yScroll=0)



{



Static EM_LINESCROLL:=0xB6



SendMessage EM_LINESCROLL,xScroll,yScroll,,ahk_id %hEdit%



Return ErrorLevel



}



Edit_LoadFile(hEdit,p_FileName,p_Convert2DOS=False,ByRef r_FileFormat="")



{



IfNotExist %p_FileName%



{



outputdebug Function: %A_ThiSFunc% - File "%p_FileName%" not found



Return False



}



FileRead l_Text,%p_FileName%



if ErrorLevel



{



outputdebug Function: %A_ThiSFunc% - Unable to read from "%p_FileName%"



Return False



}



if l_Text Contains `r`n



{



r_FileFormat:="DOS"



outputdebug DOS file format detected



}



else



if l_Text Contains `n



{



r_FileFormat:="UNIX"



outputdebug Unix file format detected



}



else



if l_Text Contains `r



{



r_FileFormat:="MAC"



outputdebug Mac file format detected



}



else



{



r_FileFormat:="DOS"



outputdebug NO EOL character detected. DOS file format assumed.



}



if p_Convert2DOS



l_Text:=Edit_Convert2DOS(l_Text)



Return Edit_SetText(hEdit,l_Text)



}



Edit_Paste(hEdit)



{



Static WM_PASTE:=0x302



SendMessage WM_PASTE,0,0,,ahk_id %hEdit%



}



Edit_PosFromChar(hEdit,p_CharPos,ByRef X,ByRef Y)



{



Static EM_POSFROMCHAR:=0xD6



SendMessage EM_POSFROMCHAR,p_CharPos,0,,ahk_id %hEdit%



X:=(ErrorLevel & 0xFFFF)<<48>>48



Y:=(ErrorLevel>>16)<<48>>48



}



Edit_ReplaceSel(hEdit,p_Text="",p_CanUndo=True)



{



Static EM_REPLACESEL:=0xC2



SendMessage EM_REPLACESEL,p_CanUndo,&p_Text,,ahk_id %hEdit%



}



Edit_SaveFile(hEdit,p_FileName,p_Convert="")



{



IfExist %p_FileName%



{



FileDelete %p_FileName%



if ErrorLevel



{



outputdebug Function: %A_ThisFunc% - Unable to delete "%p_FileName%"



Return False



}



}



l_Text:=Edit_GetText(hEdit)



if p_Convert in M,Mac



l_Text:=Edit_Convert2Mac(l_Text)



if p_Convert in U,Unix



l_Text:=Edit_Convert2Unix(l_Text)



FileAppend %l_Text%,*%p_FileName%



if ErrorLevel



{



outputdebug Function: %A_ThisFunc% - Unable to save to "%p_FileName%"



Return False



}



Return True



}



Edit_Scroll(hEdit,p_Pages=0,p_Lines=0)



{



Static EM_SCROLL  :=0xB5



,SB_LINEUP  :=0x0



,SB_LINEDOWN:=0x1



,SB_PAGEUP  :=0x2



,SB_PAGEDOWN:=0x3



l_ScrollLines:=0



Loop % Abs(p_Pages)



{



SendMessage EM_SCROLL,(p_Pages>0) ? SB_PAGEDOWN:SB_PAGEUP,0,,ahk_id %hEdit%



if not ErrorLevel



Break



l_ScrollLines:=l_ScrollLines+((ErrorLevel & 0xFFFF)<<48>>48)



}



Loop % Abs(p_Lines)



{



SendMessage EM_SCROLL,(p_Lines>0) ? SB_LINEDOWN:SB_LINEUP,0,,ahk_id %hEdit%



if not ErrorLevel



Break



l_ScrollLines:=l_ScrollLines+((ErrorLevel & 0xFFFF)<<48>>48)



}



Return l_ScrollLines



}



Edit_ScrollCaret(hEdit)



{



Static EM_SCROLLCARET:=0xB7



SendMessage EM_SCROLLCARET,0,0,,ahk_id %hEdit%



}



Edit_SetLimitText(hEdit,p_Limit)



{



Static EM_LIMITTEXT:=0xC5



SendMessage EM_LIMITTEXT,p_Limit,0,,ahk_id %hEdit%



}



Edit_SetMargins(hEdit,p_LeftMargin="",p_RightMargin="")



{



Static EM_SETMARGINS :=0xD3



,EC_LEFTMARGIN :=0x1



,EC_RIGHTMARGIN:=0x2



,EC_USEFONTINFO:=0xFFFF



l_Margins:=0



l_Flags  :=0



if p_LeftMargin is Integer



{



l_Flags |= EC_LEFTMARGIN



l_Margins |= p_LeftMargin



}



if p_RightMargin is Integer



{



l_Flags |= EC_RIGHTMARGIN



l_Margins |= p_RightMargin<<16



}



if l_Flags



SendMessage EM_SETMARGINS,l_Flags,l_Margins,,ahk_id %hEdit%



}



Edit_SetModify(hEdit,p_Flag)



{



Static EM_SETMODIFY:=0xB9



SendMessage EM_SETMODIFY,p_Flag,0,,ahk_id %hEdit%



}



Edit_SetPasswordChar(hEdit,p_Char="*")



{



Static EM_SETPASSWORDCHAR:=0xCC



SendMessage EM_SETPASSWORDCHAR,Asc(p_Char),0,,ahk_id %hEdit%



Return ErrorLevel



}



Edit_SetReadOnly(hEdit,p_Flag)



{



Static EM_SETREADONLY:=0xCF



SendMessage EM_SETREADONLY,p_Flag,0,,ahk_id %hEdit%



Return ErrorLevel ? True:False



}



Edit_SetRect(hEdit,p_Left,p_Top,p_Right,p_Bottom)



{



Static EM_SETRECT:=0xB3



VarSetCapacity(RECT_Structure,16,0)



NumPut(p_Left,  RECT_Structure,0,"Int")



NumPut(p_Top,   RECT_Structure,4,"Int")



NumPut(p_Right, RECT_Structure,8,"Int")



NumPut(p_Bottom,RECT_Structure,12,"Int")



SendMessage EM_SETRECT,0,&RECT_Structure,,ahk_id %hEdit%



}



Edit_SetTabStops(hEdit,p_NbrOfTabStops=0,p_DTU=32)



{



Static EM_SETTABSTOPS:=0xCB



VarSetCapacity(l_TabStops,p_NbrOfTabStops*4,0)



if p_DTU contains ,,



{



Loop Parse,p_DTU,`,,%A_Space%



if (A_Index<=p_NbrOfTabStops)



Numput(A_LoopField+0,l_TabStops,(A_Index-1)*4,"UInt")



}



else



Loop %p_NbrOfTabStops%



NumPut(p_DTU*A_Index,l_TabStops,(A_Index-1)*4,"UInt")



SendMessage EM_SETTABSTOPS,p_NbrOfTabStops,&l_TabStops,,ahk_id %hEdit%



Return ErrorLevel



}



Edit_SetText(hEdit,p_Text)



{



Static WM_SETTEXT:=0xC



SendMessage WM_SETTEXT,0,&p_Text,,ahk_id %hEdit%



Return ErrorLevel



}



Edit_SetSel(hEdit,p_StartSelPos=0,p_EndSelPos=-1)



{



Static EM_SETSEL:=0x0B1



SendMessage EM_SETSEL,p_StartSelPos,p_EndSelPos,,ahk_id %hEdit%



}



Edit_TextIsSelected(hEdit)



{



Edit_GetSel(hEdit,l_StartSelPos,l_EndSelPos)



Return (l_StartSelPos<>l_EndSelPos)



}



Edit_Undo(hEdit)



{



Static EM_UNDO:=0xC7



SendMessage EM_UNDO,0,0,,ahk_id %hEdit%



Return ErrorLevel



}



Edit_GetActiveHandles(ByRef hEdit="",ByRef hWindow="",p_MsgBox=False)



{



WinGet hWindow,ID,A



ControlGetFocus l_Control,A



if SubStr(l_Control,1,4)="Edit"



{



ControlGet hEdit,hWnd,,%l_Control%,A



Return hEdit



}



if p_MsgBox



MsgBox



,262160



,Error



,This request cannot be performed on this control.  %A_Space%



Return False



}



RisOpened()



{



SetTitleMatchMode,2



winget,winList,list,放射線資訊管理系統(Radiology Information System)



winget,activeWin,id,A



loop % winList



{



wingetclass, winClass,% "ahk_id " winList%a_index%



if instr(winClass,"WindowsForms10.Window.8.app.")



return array(2,winList%a_index%)



}



winget,winList,list,RIS系統登入<<陽明資訊>>



loop % winList



{



wingetclass, winClass,% "ahk_id " winList%a_index%



if instr(winClass,"WindowsForms10.Window.8.app.")



return array(1,winList%a_index%)



}



return array(0,0)



}



GetControls(hwnd)



{



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



ImpaxOpened()



{



winget,ImpaxIdList,list,ahk_class WindowsForms10.Window.8.app.0.2bf8098



winget,activeWin,id,A



arr:=[],ind1:=ind2:=ind3:=0,a1:=a2:=a3:=0



arr[1]:=0



loop 5



arr[2,a_index]:=0



loop % ImpaxIdList



{



id:=ImpaxIdList%a_index%



wingettext,text,ahk_id %id%



if ind:=instr(text,"STUDY_NAV_TOOLBAR0"){



ind1:=ind,a1:=a_index,arr[2,1]:=id



}



if((instr(text,"工作清單")&&instr(text,"相關性")&&instr(text,"更新"))||(instr(text,"Worklists")&&instr(text,"Relevance")&&instr(text,"Refresh"))){



if((instr(text,"臨床資訊")&&instr(text,"RIS 狀態")&&instr(text,"病患 HIS 代碼"))||(instr(text,"Clinical Information")&&instr(text,"RIS Status")&&instr(text,"Patient HIS Code"))){



ind2:=instr(text,"臨床資訊")|instr(text,"Clinical Information")



a2:=a_index,arr[2,2]:=id



}else{



ind3:=instr(text,"工作清單")|instr(text,"Worklists")



a3:=a_index,arr[2,3]:=id



}



}



wingetpos,,,,h,ahk_id %id%



if (maxH<h)



maxH:=h



}



h:=maxH



h-=41



if (arr[2,1]||arr[2,2]||arr[2,3]){



arr[1]:=2



if(arr[2,1]=(arr[2,2]|arr[2,3])){



arr[2,5]:=1



if ((bar:=impaxBar(arr[2,2]|arr[2,3])).h>h){



arr[2,4]:=2



}else if(ind1<(ind2|ind3)){



arr[2,4]:=1



}else {



arr[2,4]:=3



}



}else{



arr[2,5]:=2



if(a1<(a2|a3)){



arr[2,4]:=1



}else if(impaxBar(arr[2,2]|arr[2,3]).h>h){



arr[2,4]:=2



}else{



arr[2,4]:=3



}



}



return arr



}



loop % ImpaxIdList



{



id:=ImpaxIdList%a_index%



wingettext,text,ahk_id %id%



if (instr(text,"登入") && instr(text,"密碼") && instr(text,"選項")) || (instr(text,"Login") && instr(text,"Options") && instr(text,"User ID"))



return array(1,array(id))



}



return array(0,0)



}



GetControlIdByText(byref arr,RefControlText,offset=0,UseRegEx=0)



{



if !isobject(arr)||!arr.maxIndex()



return



k=0



if UseRegEx



{



for k,v in arr



if RegExMatch(v.text,RefControltext)



break



}



else



{



for k,v in arr



if v.text=RefControltext



break



if !k



for k,v in arr



if instr(v.text,RefControltext)



break



}



if !offset



i:=k



else



{



i:=k+offset



l:=arr.MaxIndex()



while i>l



i-=l



while i<1



i+=l



}



return (k=0 ? 0 : arr[i]["Hwnd"])



}



GetRisPath(){



if fileexist(path:=a_desktop "\放射線資訊管理系統(Radiology Information System).appref-ms")



return path



if fileexist(path:=a_desktop "\RIS.appref-ms")



return path



loop,HKCU,Software\Microsoft\Windows\ShellNoRoam\MUICache



if instr(a_loopregname,"Menu.exe") && fileexist(a_loopregname)



return a_loopregname



loop,HKCU,Software\Microsoft\Internet Explorer\TypedURLs



{



regread,v



if instr(a,"Menu.exe") && fileexist(v)



return v



}



if (a:=searchFile("Menu.exe",substr(a_windir,1,3) "Documents and Settings\" a_username "\Local Settings\Apps\2.0")).maxindex()



return a.pop()



return 0



}



ListControls(hwnd)



{



str=



arr:=GetControls(hwnd)



for k,v in arr



str.="""" v["Hwnd"] """,""" v["ClassNN"] """,""" v["text"] """`n"



return str



}



ImpaxBar(hwnd){



for k,v in (impaxControls:=getcontrols(hwnd)) {



if ((v.text="登出"||v.text="Logout") && instr(v.classNN,"WindowsForms10.BUTTON.app") && instr(impaxControls[k-2].classNN,"WindowsForms10.Window.8.app")) {



controlgetpos,x,y,w,h,,% "ahk_id " barId:=impaxControls[k-2].hwnd



break



}



}



return {hwnd:barId, x:x, y:y, w:w, h:h}



}



ImpaxSwitchPage(ImpaxStateArr,which=0,bar=""){



if !bar



bar:=ImpaxBar(ImpaxStateArr[2])



wingetpos,winx,winy,,,% "ahk_id " ImpaxStateArr[2]



if (which=0){



winactivate,% "ahk_id " ImpaxStateArr[2]



controlclick,,% "ahk_id " bar.hwnd



} else if (which=1) {



if(ImpaxState[1]) {



winactivate,% "ahk_id " ImpaxStateArr[1]



}else if !(bar.h>100) {



mouseclick,,% winx+bar.x+bar.w/3,% winy+bar.y+10,,0



}



}



}



getRisReports(risHwnd){



arr:=[]



for k,v in risControls:=getcontrols(risHwnd) {



if (instr(v.text,"下筆") && instr(v.classNN,"WindowsForms10.BUTTON")) {



temp:=k



break



}



}



for k,v in risControls {



if (v.text="Exam." && instr(risControls[k+1]["classNN"],"WindowsForms10.EDIT.app")) {



if(abs(k-temp)<14){



arr[1]:=array(risControls[k+1]["hwnd"],risControls[k+4]["hwnd"])



}else{



arr[2]:=array(risControls[k+1]["hwnd"],risControls[k+4]["hwnd"])



}



}



}



return arr



}



getRisReportsHwnd(risHwnd){



for k,v in risControls:=getcontrols(risHwnd) {



if (instr(v.text,"下筆") && instr(v.classNN,"WindowsForms10.BUTTON")) {



temp:=k



break



}



}



for k,v in risControls {



if (v.text="Exam." && instr(risControls[k+1]["classNN"],"WindowsForms10.EDIT.app") && abs(k-temp)<13) {



return array(risControls[k+1]["hwnd"])



break



}



}



return []



}



getTextByHwnd(id){



controlgettext,t,,ahk_id %id%



return t



}



getImpaxChartNo(hwnd){



controlgettext,chartNo,,% "ahk_id " getNetControl2(hwnd,"","patientIdLabel","","WindowsForms10.STATIC.app","","","",0)[1]



while strlen(chartNo)<7



chartNo:="0" chartNo



return chartno



}



getChartNo(id){



return getRisChartNo(id)



}



getRisChartNo(hwnd){



for k,v in controls:=getcontrols(hwnd)



if RegExMatch(v.text,"^\w\d{6}$") && controls[k-1].text="病歷號"



chartNo:=v.text



if chartNo!=



while strlen(chartNo)<7



chartNo:="0" chartNo



return chartNo



for k,v in getcontrols(hwnd)



if instr(v.classNN,"WindowsForms10.EDIT") && acc_objectfromwindow(v.hwnd).accName="病歷號"



{



controlgettext,str,,% "ahk_id " v.hwnd



return str



}



}



getRisSheetNo(hwnd){



for k,v in controls:=getcontrols(hwnd)



if controls[k-1].text="照會單號" && regexmatch(v.text,"T\d{10}") && instr(v.classNN,"WindowsForms10.EDIT")



{



return v.text



}



}



getRisHistoryId(hwnd){



for k,v in controls:=getControls(hwnd)



if (instr(v.classNN,"WindowsForms10.Window.8.app") && v.text="歷史報告" && instr(controls[k+3,"classNN"],"WindowsForms10.Window.8.app")){



if (controlId:=controls[k+3,"hwnd"])



return controlId



}



}



getRisHistoryIndex(dgHisReportAcc,rowAcc){



loop % acc_children(dgHisReportAcc).maxIndex()-1 {



check:=true



i:=a_index+1



loop % acc_children(acc_get("Object",1,0,dgHisReportAcc)).maxindex()-1 {



j:=A_Index



check:=check & (acc_get("Value",i "." j,0,dgHisReportAcc)=acc_get("Value",j,0,rowAcc))



}



if (check)



return i



}



return 0



}



searchFile(f,dir){



arr:=[]



originalWorkingDir:=A_WorkingDir



SetWorkingDir,% dir



loop,% f,0,1



arr.push(a_loopfilelongpath)



SetWorkingDir,% originalWorkingDir



return arr



}



searchRisChartNo(hwnd,chartNo){



for k,v in controls:=getControls(hwnd)



if (instr(v.text,"查詢單號") && instr(v.classNN,"WindowsForms10.STATIC")){



controlfocus,,% "ahk_id " controls[k+1].hwnd



controlsettext,,% chartNo,% "ahk_id " controls[k+1].hwnd



controlsend,,{Enter},% "ahk_id " controls[k+1].hwnd



return true



}



for k,v in controls



if (instr(v.text,"病歷號") && instr(v.classNN,"WindowsForms10.STATIC") && !instr(controls[k-3].text,"照會單號")){



controlfocus,,% "ahk_id " controls[k+1].hwnd



controlsettext,,% chartNo,% "ahk_id " controls[k+1].hwnd



controlsend,,{Enter},% "ahk_id " controls[k+1].hwnd



return true



}



return false



}



parseDataGrid(hwnd,acc=0){



if(acc=0)



acc:=acc_ObjectFromWindow(hwnd)



arr:=[]



for k,v in rows:=acc_children(acc)



for x,y in acc_children(v)



arr[k,x]:=y.accValue



return arr



}



getRisMenu(){



global menuHwnd=0



EnumAddress := RegisterCallback("EnumProc")



DllCall("EnumWindows", UInt, EnumAddress, UInt, 0)



return menuHwnd



}



EnumProc(hwnd, lParam)



{



global menuHwnd



if (DllCall("GetWindowLong",UInt,hwnd,Int,-20)=0______){



if ((acc:=acc_children(acc_objectfromwindow(hwnd))).maxindex()=6 && acc[1].accName="瀏覽影像"){



menuHwnd:=hwnd



return false



}



}



return true



}



getRisExamItems(hwnd){



for k,v in getcontrols(hwnd) {



if (instr(name:=getControlNameByHwnd(hwnd,v.hwnd),"EXAMITEM")) {



return v.hwnd



acc:=acc_objectFromWindow(v.hwnd)



break



}



}



}



parseRisHistory(hwnd){



arr:=[]



if !acc:=acc_objectfromwindow(hwnd)



return arr



for i,j in rows:=acc_children(acc) {



if i=1



continue



for x,y in acc_children(v)



arr[i-1,x]:=y.accValue



}



return arr



}



getRisHistory(hwnd){



for k,v in getcontrols(hwnd) {



if (getControlNameByHwnd(hwnd,v.hwnd)="dgHisReport") {



return v.hwnd



break



}



}



}



parseRisExamItems(hwnd){



arr:=[]



acc:=acc_objectFromWindow(hwnd)



if !acc



return arr



loop % acc_children(acc).maxindex()-1 {



i:=a_index+1



str:=acc_get("Value",i ".2",0,acc)



if instr(str,"※")



arr[0]:=str:=RegExReplace(str,"※")



arr[a_index]:=str



}



return arr



}



LineBreakConvert(str){



return regexreplace(regexreplace(str,"\r",""),"\n","`r`n")



}



getSEIM(ImpaxState=""){



if !impaxstate



impaxstate:=impaxOpened()



impaxImageHwnd:=impaxState[2,1]



SEIM:=getNetControl2(impaxImageHwnd,"","DicomImageNumbers","","WindowsForms10.STATIC.app","","","",0)



for k,v in SEIM



if text:=controlgettext(v)



break



RegExMatch(text,"i)S:\s+(\d+)\s+I:\s+(\d+)",match)



return [match1,match2]



}



RisExamEditInfo(RisHwnd="",RisExamHwnd=""){



if !rishwnd && !risexamhwnd



risHwnd:=risOpened()[2]



if !risexamhwnd



risexamhwnd:=getRisReports(risHwnd)[1,1]



Edit_GetSel(risexamhwnd,start,end)



return {id: risexamhwnd, start: start,end: end}



}



HTTPRequest( URL, byref In_POST__Out_Data="", byref In_Out_HEADERS="", Options="" ) {



Static version := "2.42", Ptr, PtrSize, IsUnicode, MyACP, MyCharset, Default_Agent, WorA := ""



, Default_Accept_Types := "text/xml, text/json; q=0.4, text/html; q=0.3, text/*; q=0.2, */*; q=0.1"



, Text_Content_Subtypes := "/atom/html/json/rss/soap/xhtml/xml/x-www-form-urlencoded"



, internet_flags_list := "



( LTRIM JOIN|INTERNET_FLAG_



	....



	NEED_FILE



	MUST_CACHE_REQUEST|.



	FWD_BACK|.



	FORMS_SUBMIT|..



	PRAGMA_NOCACHE|.



	NO_UI|.



	HYPERLINK|.



	RESYNCHRONIZE|.



	IGNORE_CERT_CN_INVALID|.



	IGNORE_CERT_DATE_INVALID|.



	IGNORE_REDIRECT_TO_HTTPS|.



	IGNORE_REDIRECT_TO_HTTP|..



	RESTRICTED_ZONE|.



	NO_AUTH|.



	NO_COOKIES|.



	READ_PREFETCH|.



	NO_AUTO_REDIRECT|.



	KEEP_CONNECTION|.



	SECURE|.



	FROM_CACHE



	OFFLINE|.



	MAKE_PERSISTENT|.



	DONT_CACHE|...



	NO_CACHE_WRITE|.



	RAW_DATA|.



	RELOAD|



)"



, security_flags_list := "



( LTRIM JOIN|SECURITY_FLAG_



	SECURE|.



	SSL|.



	SSL3|.



	PCT|.



	PCT4|.



	IETFSSL4|..



	IGNORE_REVOCATION|.



	IGNORE_UNKNOWN_CA|.



	IGNORE_WRONG_USAGE|...



	IGNORE_CERT_CN_INVALID|.



	IGNORE_CERT_DATE_INVALID|.



	IGNORE_REDIRECT_TO_HTTPS|.



	IGNORE_REDIRECT_TO_HTTP|............



	FORTEZZA|.



	40BIT



	NORMALBITNESS



	STRENGTH_WEAK|.



	128BIT



	STRENGTH_STRONG|.



	56BIT



	STRENGTH_MEDIUM|.



	UNKNOWNBIT|



)"



, Codepage_Charsets := "|



( LTRIM JOIN|



	00037=IBM037|00437=IBM437|00500=IBM500|00708=ASMO-708|00720=DOS-720|00737=ibm737



	00775=ibm775|00850=ibm850|00852=ibm852|00855=IBM855|00857=ibm857|00858=IBM00858|00860=IBM860



	00861=ibm861|00862=DOS-862|00863=IBM863|00864=IBM864|00865=IBM865|00866=cp866|00869=ibm869



	00870=IBM870|00874=windows-874|00875=cp875|00932=shift_jis|00936=gb2312|00949=ks_c_5601-1987



	00950=big5|01026=IBM1026|01047=IBM01047|01140=IBM01140|01141=IBM01141|01142=IBM01142



	01143=IBM01143|01144=IBM01144|01145=IBM01145|01146=IBM01146|01147=IBM01147|01148=IBM01148



	01149=IBM01149|01200=utf-16|01201=unicodeFFFE|01250=windows-1250|01251=windows-1251



	01252=Windows-1252|01253=windows-1253|01254=windows-1254|01255=windows-1255



	01256=windows-1256|01257=windows-1257|01258=windows-1258|01361=Johab|10000=macintosh



	10001=x-mac-japanese|10002=x-mac-chinesetrad|10003=x-mac-korean|10004=x-mac-arabic



	10005=x-mac-hebrew|10006=x-mac-greek|10007=x-mac-cyrillic|10008=x-mac-chinesesimp



	10010=x-mac-romanian|10017=x-mac-ukrainian|10021=x-mac-thai|10029=x-mac-ce



	10079=x-mac-icelandic|10081=x-mac-turkish|10082=x-mac-croatian|12000=utf-32|12001=utf-32BE



	20000=x-Chinese-CNS|20001=x-cp20001|20002=x-Chinese-Eten|20003=x-cp20003|20004=x-cp20004



	20005=x-cp20005|20105=x-IA5|20106=x-IA5-German|20107=x-IA5-Swedish|20108=x-IA5-Norwegian



	20127=us-ascii|20261=x-cp20261|20269=x-cp20269|20273=IBM273|20277=IBM277|20278=IBM278



	20280=IBM280|20284=IBM284|20285=IBM285|20290=IBM290|20297=IBM297|20420=IBM420|20423=IBM423



	20424=IBM424|20833=x-EBCDIC-KoreanExtended|20838=IBM-Thai|20866=koi8-r|20871=IBM871



	20880=IBM880|20905=IBM905|20924=IBM00924|20932=EUC-JP|20936=x-cp20936|20949=x-cp20949



	21025=cp1025|21866=koi8-u|28591=iso-8859-1|28592=iso-8859-2|28593=iso-8859-3|28594=iso-8859-4



	28595=iso-8859-5|28596=iso-8859-6|28597=iso-8859-7|28598=iso-8859-8|28599=iso-8859-9



	28603=iso-8859-13|28605=iso-8859-15|29001=x-Europa|38598=iso-8859-8-i|50220=iso-2022-jp



	50221=csISO2022JP|50222=iso-2022-jp|50225=iso-2022-kr|50227=x-cp50227|51932=euc-jp



	51936=EUC-CN|51949=euc-kr|52936=hz-gb-2312|54936=GB18030|57002=x-iscii-de|57003=x-iscii-be



	57004=x-iscii-ta|57005=x-iscii-te|57006=x-iscii-as|57007=x-iscii-or|57008=x-iscii-ka



	57009=x-iscii-ma|57010=x-iscii-gu|57011=x-iscii-pa|65000=utf-7|65001=utf-8|



)"



If ( WorA = "" )



{



If ( A_PtrSize = "" )



PtrSize := 4, Ptr := "UInt"



Else PtrSize := A_PtrSize, Ptr := "Ptr"



If !( IsUnicode := 1 = A_IsUnicode )



WorA := "A", MyACP := SubStr( 100000.0 + DllCall("GetACP"), 2, 5 )



Else WorA := "W", MyACP := "01200"



MyCharset := ( 7 = pos := 7 + InStr( Codepage_Charsets, "|" MyACP "=" ) ) ? "UTF-8"



: SubStr( Codepage_Charsets, pos, InStr( Codepage_Charsets, "|", 0, pos ) - pos )



SplitPath, A_ScriptName,,,, Default_Agent



Default_Agent .= "/1.0 (Language=AutoHotkey/" A_AhkVersion "; Platform=" A_OSVersion ")"



}



Internet_Open_Type := 1



Security_Flags := Security_Flags_Add := Security_Flags_Nix := 0



Response_Code := "0"



Do_Callback := 0



Do_NonBinary_Up := 0



Do_Binary_Down := 0



Do_Up_MD5_Hash := 0



Do_Dn_MD5_Hash := 0



Do_File_Upload := 0



Do_Multipart := 0



Do_Download_To_File := 0



Do_Download_Resume := 0



Do_Legacy_Dual_Output := 0



Agent := Default_Agent



Accept_Types := Default_Accept_Types



Multipart_Boundary := ""



proxy_bypass := ""



Method_Verb := ""



MyErrors := ""



dbuffsz := 0



port := 0



dtsz := 0



Convert_POST_To_Codepage := MyACP



Internet_Flags := 0



| 0x400000



| 0x80000000



| 0x20000000



StringLen, Content_Length, In_POST__Out_Data



Content_Length <<= IsUnicode



hbuffer := "The provided url could not be parsed: """ URL """"



If ( pos := InStr( URL, "://" ) )



{



StringLeft, scheme, URL, pos - 1



StringLower, scheme, scheme



StringTrimLeft, URL, URL, pos + 2



If ( scheme = "https" )



Internet_Flags |= 0x1000



| 0x2000



| 0x800000



Else If ( scheme != "http" )



Return 0, ErrorLevel := 0, In_Out_HEADERS := "HTTPRequest does not support '" scheme "' type connections."



}



Else scheme := "http"



StringLeft, host, URL, pos := InStr( URL "/", "/" ) - 1



StringTrimLeft, URL, URL, pos



If ( pos := InStr( host, "@" ) )



{



StringLeft, user, host, pos - 1



StringTrimLeft, host, host, pos



If ( pos := InStr( user, ":" ) )



{



StringTrimLeft, pass, user, pos



StringLeft, user, user, pos - 1



}



Else pass := ""



}



Else user := pass := ""



If ( pos := InStr( host, ":", 0, InStr( host, "[" ) = 1 ? InStr( host, "]" ) + 1 : 1 ) )



&& ( 0 < port := 0 | SubStr( host, pos + 1 ) ) && ( port < 65536 )



{



StringTrimLeft, port, host, pos



StringLeft, host, host, pos - 1



}



Else port := scheme = "https" ? 443 : 80



If ( host = "" )



Return 0, ErrorLevel := 0, In_Out_HEADERS := hbuffer



StringLen, pos, In_Out_HEADERS



VarSetCapacity( hbuffer, 1 + pos << IsUnicode )



hbuffer := "`r`n"



Loop, Parse, In_Out_HEADERS, `n



{



StringReplace, rbuffer, A_LoopField, :, `n



Loop, Parse, rbuffer, `n, % "`t`r "



If ( A_Index = 1 )



rbuffer := A_LoopField



Else If ( A_LoopField = "" )



If ( rbuffer = "Content-MD5" )



Do_Up_MD5_Hash := 1



Else Continue



Else If ( rbuffer = "Accept" )



Accept_Types := A_LoopField



Else If ( rbuffer = "Content-Length" ) && ( 0 < 1 | A_LoopField )



Content_Length := A_LoopField



Else If ( rbuffer = "Content-Type" )



{



hbuffer .= "Content-Type: " A_LoopField "`r`n"



StringReplace, Multipart_Boundary, A_LoopField, % ",", % ";", A



If ( 7 != pos := 7 + InStr( Multipart_Boundary, "charset=" ) )



&& ( pos := InStr( Codepage_Charsets, SubStr( Multipart_Boundary, pos



, InStr( Multipart_Boundary ";" , ";", 0, pos ) - pos ) "|" ) )



StringMid, Convert_POST_To_Codepage, Codepage_Charsets, pos - 5, 5



Multipart_Boundary := ( InStr( A_LoopField, "Multipart/" ) != 1



|| 9 = pos := 9 + InStr( Multipart_Boundary, "boundary=" ) ) ? ""



: SubStr( Multipart_Boundary, pos, InStr( Multipart_Boundary ";", ";" ) - pos )



}



Else If ( rbuffer = "Referrer" )



hbuffer .= "Referer: " A_LoopField "`r`n"



Else If ( rbuffer = "User-Agent" )



Agent := A_LoopField



Else hbuffer .= rbuffer ": " A_LoopField "`r`n"



}



IfInString, hbuffer, % "`r`nCookie: "



options .= "`n+NO_COOKIES"



If ( Multipart_Boundary != "" ) && ( pos := InStr( options, "--" Multipart_Boundary ) )



&& ( ( 4 + StrLen( Multipart_Boundary ) ) != ( Multipart_Boundary := 4



+ StrLen( Multipart_Boundary ) + InStr( options, "--" Multipart_Boundary "--", 0, 0 ) ) )



{



StringMid, Multipart_Envelope, options, pos, Multipart_Boundary - pos



options := SubStr( options, 1, pos - 1 ) SubStr( options, Multipart_Boundary )



}



Loop, Parse, options, `n



{



If InStr( A_LoopField, ">" ) + 3 >> 2 = 1



{



Loop, Parse, A_LoopField, >, % "`t`n`r "



If ( A_Index = 1 )



options := ( InStr( A_LoopField, "R" ) ? "RESUME`n" : "SAVEAS`n" )



, Do_Legacy_Dual_Output := !!InStr( A_LoopField, "N" )



Else options .= A_LoopField



}



Else IfInString, A_LoopField, :



StringReplace, options, A_LoopField, :, `n



Else If InString, A_LoopField, =



StringReplace, options, A_LoopField, =, `n



Else options := A_LoopField "`n"



Loop, Parse, options, `n, % "`t`r "



If ( A_Index = 1 )



StringUpper, options, A_LoopField



Else If ( options = "AUTOPROXY" )



Internet_Open_Type := !!A_LoopField || A_LoopField = "" ? 0 : 1



Else If ( options = "BINARY" )



Do_Binary_Down := !!A_LoopField || A_LoopField = ""



Else If ( options = "CALLBACK" )



{



If ( pos := InStr( A_LoopField, "," ) ) || ( pos := InStr( A_LoopField, ";" ) )



|| ( pos := InStr( A_LoopField, "`t" ) ) || ( pos := InStr( A_LoopField, " " ) )



{



StringLeft, Do_Callback_Func, A_LoopField, pos - 1



StringTrimLeft, Do_Callback_3rdParam, A_LoopField, pos



Loop, Parse, Do_Callback_3rdParam, `n, % "`t`r "



Do_Callback_3rdParam := A_LoopField



}



Else Do_Callback_Func := A_LoopField



Do_Callback := IsFunc( Do_Callback_Func ) + 3 >> 2 = 1



}



Else If ( options = "CHARSET" )



Do_NonBinary_Up := !( pos := InStr( Codepage_Charsets, "=" A_LoopField "|" ) ) ? Convert_POST_To_Codepage



: SubStr( Codepage_Charsets, pos - 5, 5 )



Else If ( options = "CHECKMD5" ) || ( options = "CHECK MD5" )



Do_Dn_MD5_Hash := 1



Else If ( options = "CODEPAGE" )



Do_NonBinary_Up := ( A_LoopField | 0 < 1 || A_LoopField >> 16 ) ? Convert_POST_To_Codepage



: ( Convert_POST_To_Codepage := SubStr( A_LoopField + 100000.0, 2, 5 ) )



Else If InStr( options, "+" ) = 1 || InStr( options, "-" ) = 1



{



StringLeft, flag_plus_or_minus, options, 1



Loop, Parse, options, +-, % "`t`n`r _"



options := A_LoopField



If ( options = "FLAG" )



StringUpper, options, A_LoopField



If ( pos := InStr( internet_flags_list, "|" options "|" ) )



|| ( pos := InStr( internet_flags_list, "|INTERNET_FLAG_" options "|" ) )



{



StringLeft, options, internet_flags_list, pos



StringReplace, options, options, ., ., UseErrorLevel



If ( flag_plus_or_minus = "+" )



Internet_Flags |= 1 << ErrorLevel



Else Internet_Flags &= ~( 1 << ErrorLevel )



}



Else If ( pos := InStr( security_flags_list, "|" options "|" ) )



|| ( pos := InStr( security_flags_list, "|SECURITY_FLAG_" options "|" ) )



{



StringLeft, options, security_flags_list, pos



StringReplace, options, options, ., ., UseErrorLevel



If ( flag_plus_or_minus = "+" )



Security_Flags_Add |= 1 << ErrorLevel



Else Security_Flags_Nix |= 1 << ErrorLevel



}



Else If ( InStr( options, "S" ) = 1 ) && ( 0 < pos := Abs( SubStr( options, 2 ) ) )



&& ( pos = 1 << Round( Ln( pos ) / Ln(2) ) )



{



If ( flag_plus_or_minus = "+" )



Security_Flags_Add |= pos



Else Security_Flags_Nix |= pos



}



Else If ( 0 < pos := Abs( options ) ) && ( pos = 1 << Round( Ln( pos ) / Ln(2) ) )



If ( flag_plus_or_minus = "+" )



Internet_Flags |= pos



Else Internet_Flags &= ~pos



}



Else If ( options = "METHOD" ) && InStr( "|GET|HEAD|POST|PUT|DELETE|OPTIONS|TRACE|", "|" A_LoopField "|" )



StringUpper, Method_Verb, A_LoopField



Else If ( options = "PROXY" )



Internet_Open_Type := 3, proxy_url := A_LoopField



Else If ( options = "PROXY BYPASS" )



proxy_bypass .= A_LoopField "`r`n"



Else If ( options = "RESUME" ) || ( options = "SAVEAS" ) || ( options = "SAVE AS" )



{



file_ext := FileExist( output_file_path := A_LoopField )



If ( file_ext = "" )



{



If !( pos := InStr( output_file_path, "\", 0, 0 ) )



|| FileExist( SubStr( output_file_path, 1, pos - 1 ) )



Do_Download_To_File := 1



Else MyErrors .= "`nThe file path """ output_file_path """ is not valid. The folder can't be found."



}



Else If InStr( file_ext, "D" )



{



file_ext := "V://x/E/" url



SplitPath, file_ext, file_ext



StringLeft, file_ext, file_ext, InStr( file_ext "?", "?" ) - 1



output_file_path .= ( SubStr( output_file_path, 0 ) = "\" ? "" : "\" )



. ( file_ext = "" ? "HTTPRequest " A_Year "-" A_MM "-" A_DD "_" SubStr( A_Now A_MSec, 9 ) ".txt" : file_ext )



}



Else



If ( options = "RESUME" )



FileGetSize, Do_Download_Resume, % output_file_path



}



Else If ( options = "UPLOAD" )



{



If ( pos := InStr( A_LoopField, "*", 0, 0 ) )



{



Upload_File_Path := SubStr( A_LoopField, 1, pos - 1 ) "`n" SubStr( A_LoopField, pos + 1 )



Loop, Parse, Upload_File_Path, `n, % "`t`r "



If ( A_Index = 1 )



Upload_File_Path := A_LoopField



Else If ( 0 < 0 | A_LoopField )



Do_File_Upload := !FileExist( Upload_File_Path ) ? 0 : 0 | 1 + A_LoopField



}



Else Do_File_Upload := !FileExist( Upload_File_Path := A_LoopField ) ? 0 : 1



If ( Do_File_Upload )



{



FileGetsize, Content_Length, % Upload_File_Path



}



Else MyErrors .= "`nFile upload failed: the file """ Upload_File_Path """ could not be found."



}



}



StringTrimRight, proxy_bypass, proxy_bypass, 2



If ( 0 < Content_Length )



{



If ( Do_File_Upload )



{



VarSetCapacity( dbuffer, 4096, 0 )



dbuffsz := Content_Length := SubStr( Content_Length + 0.0, 1, 1 + FLOOR( LOG( Content_Length )))



hbuffer .= "Content-Length: " Content_Length "`r`n"



IfNotInString, hbuffer, % "`r`nContent-Type: "



{



SplitPath, Upload_File_Path,,, file_ext



hbuffer .= "Content-Type: " ( file_ext = "xml" ? "text/xml"



: file_ext = "txt" ? "application/x-www-form-urlencoded"



: "application/octet-stream" ) "`r`n"



}



If ( Do_Up_MD5_Hash )



hbuffer .= "Content-MD5: " HTTPRequest_MD5( hbuffer, Upload_File_Path ) "`r`n"



}



Else If !( Do_NonBinary_Up ) || ( Do_NonBinary_Up = MyACP ) || ( Do_Multipart )



{



VarSetCapacity( dbuffer, dbuffsz := Content_Length, 0 )



DllCall( "RtlMoveMemory", Ptr, &dbuffer, Ptr, &In_POST__Out_Data, "Int", Content_Length )



Content_Length := SubStr( Content_Length + 0.0, 1, 1 + FLOOR( LOG( Content_Length )))



hbuffer .= "Content-Length: " Content_Length "`r`n"



IfNotInString, hbuffer, % "`r`nContent-Type: "



hbuffer .= "Content-Type: " ( InStr( dbuffer, "<?xml" ) + 3 >> 2 = 1 ? "text/xml"



: "application/x-www-form-urlencoded" ) "; charset=" MyCharset



}



Else



{



IfNotInString, hbuffer, % "`r`nContent-Type: "



{



hbuffer .= "Content-Type: " ( InStr( dbuffer, "<?xml" ) + 3 >> 2 = 1 ? "text/xml"



: "application/x-www-form-urlencoded" )



If ( 7 != pos := 7 + InStr( Codepage_Charsets, "|" Do_NonBinary_Up "=" ) )



hbuffer .= "; charset=" SubStr( Codepage_Charsets, pos, InStr( Codepage_Charsets, "|", 0, pos ) - pos )



hbuffer .= "`r`n"



}



If ( IsUnicode )



pos := &In_POST__Out_Data, rbuffsz := Content_Length >> 1



Else



{



If ( 0 < rbuffsz := DllCall( "MultiByteToWideChar", "UInt", MyACP, "UInt", 0, Ptr, &In_POST__Out_Data, "Int", Content_Length, Ptr, 0, "Int", 0 ) )



{



VarSetCapacity( rbuffer, rbuffsz + 1 << 1, 0 )



DllCall( "MultiByteToWideChar", "UInt", MyACP, "UInt", 0, Ptr, &In_POST__Out_Data, "Int", Content_Length, Ptr, pos := &rbuffer, "Int", rbuffsz )



}



Else MyErrors .= "`nThere was a problem converting codepage " MyACP " to " Convert_POST_To_Codepage ". 'MultiByteToWideChar' failed: Return value = " rbuffsz ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError



}



If ( 0 < rbuffsz )



If ( 0 < dbuffsz := DllCall( "WideCharToMultiByte", "UInt", Do_NonBinary_Up, "UInt", 0, Ptr, pos, "Int", rbuffsz, Ptr, 0, "Int", 0, Ptr, 0, Ptr, 0 ) )



{



VarSetCapacity( dbuffer, dbuffsz + 1, 0 )



DllCall( "WideCharToMultiByte", "UInt", Do_NonBinary_Up, "UInt", 0, Ptr, pos, "Int", rbuffsz, Ptr, &dbuffer, "Int", dbuffsz, Ptr, 0, Ptr, 0 )



Content_Length := SubStr( dbuffsz + 0.0, 1, 1 + FLOOR( LOG( dbuffsz )))



hbuffer .= "Content-Length: " Content_Length "`r`n"



}



Else MyErrors .= "`nThere was a problem converting codepage " MyACP " to " Convert_POST_To_Codepage ". 'WideCharToMultiByte' failed: Return value = " dbuffsz ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError



VarSetCapacity( rbuffer, 0 )



If ( Do_Up_MD5_Hash )



hbuffer .= "Content-MD5: " HTTPRequest_MD5( dbuffer, dbuffsz ) "`r`n"



}



VarSetCapacity( INTERNET_BUFFERS, 28 + PtrSize * 3, 0 )



NumPut( 28 + PtrSize * 3, INTERNET_BUFFERS, 0, "Int" )



NumPut( Content_Length, INTERNET_BUFFERS, 16 + PtrSize * 3, "Int" )



}



Loop, Parse, Accept_Types, "



If ( A_Index = 1 )



StringReplace, Accept_Types, A_LoopField, `,, `n, A



Else If ( A_Index & 1 )



{



StringReplace, Accept_PtrArray, A_LoopField, `,, `n, A



Accept_Types .= Accept_PtrArray



}



Else Accept_Types .= """" A_LoopField """"



Loop, Parse, Accept_Types, `n, % "`t`r "



If ( 1 = pos := A_Index )



Accept_Types := A_LoopField



Else Accept_Types .= "`n" A_LoopField



VarSetCapacity( Accept_PtrArray, pos * PtrSize + PtrSize, 0 )



pos := 0



Loop, Parse, Accept_Types, `n



{



NumPut( &Accept_Types + pos, Accept_PtrArray, A_Index * PtrSize - PtrSize, Ptr )



pos += 1 + StrLen( A_LoopField ) << IsUnicode



NumPut( 0, Accept_Types, pos - 1 - IsUnicode, IsUnicode ? "UShort" : "UChar" )



}



Method_Verb := Method_Verb != "" ? Method_Verb : 0 < Content_Length ? "POST" : "GET"



StringTrimLeft, hbuffer, hbuffer, 2



If InStr( MyErrors, "`n" )



Return 0, In_Out_HEADERS := SubStr( MyErrors, 2 ), ErrorLevel := oel



If !( hModule := DllCall( "LoadLibrary" WorA, "Str", "WinINet.dll", Ptr ) )



MyErrors .= "`nThere was a problem loading WinINet.dll. 'LoadLibrary" WorA "' failed: Return value = " hModule ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError



Else	If !( hInternet := Internet_Open_Type != 3 ? DllCall( "WinINet\InternetOpen" WorA, Ptr, &Agent, "UInt", Internet_Open_Type, Ptr, 0, Ptr, 0, "UInt", 0, Ptr )



: DllCall( "WinINet\InternetOpen" WorA, Ptr, &Agent, "UInt", 3, ptr, &proxy_url, Ptr, proxy_bypass = "" ? 0 : &proxy_bypass, "UInt", 0, Ptr ) )



MyErrors .= "`nThere was a problem initializing WinINet. 'WinINet\InternetOpen" WorA "' failed: Return value = " hInternet ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError



Else If !( hConnection := DllCall( "WinINet\InternetConnect" WorA, Ptr, hInternet, Ptr, &Host, "UInt", Port, Ptr, &User, Ptr, &Pass, "UInt", 3, "UInt", Internet_Flags, "UInt", 0, Ptr ) )



MyErrors .= "`nThere was a problem opening a HTTP session. 'WinINet\InternetConnect" WorA "' failed: Return value = " hConnection ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError



Else If !( hRequest := DllCall( "WinINet\HttpOpenRequest" WorA, Ptr, hConnection, Ptr, &Method_Verb, Ptr, &URL, "Str", "HTTP/1.1", Ptr, 0, Ptr, &Accept_PtrArray, "UInt", Internet_Flags, Ptr ) )



MyErrors .= "`nThere was a problem creating a HTTP request. 'WinINet\HttpOpenRequest" WorA "' failed: Return value = " hRequest ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError



Else If ( hbuffer != "" ) && !DllCall( "WinINet\HttpAddRequestHeaders" WorA, Ptr, hRequest, Ptr, &hbuffer, "UInt", StrLen( hbuffer ), "UInt", 0xA0000000 )



MyErrors .= "`nThere was a problem adding one or more headers to the request. 'WinINet\HttpAddRequestHeaders" WorA "' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError "`nHeaders: `n" hbuffer



Else If ( Security_Flags_Add || Security_Flags_Nix ) && !DllCall( "WinINet\InternetQueryOption" WorA, Ptr, hRequest, "UInt", 31, "UInt*", Security_Flags, "UInt*", 4 )



MyErrors .= "`nThere was a problem retrieving the security flags. 'WinINet\InternetQueryOption" WorA "' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError



Else If ( Security_Flags_Add || Security_Flags_Nix ) && !DllCall( "WinINet\InternetSetOption" WorA, Ptr, hRequest, "UInt", 31, "UInt*", pos := ( ~Security_Flags_Nix & Security_Flags ) | Security_Flags_Add, "UInt*", 4 )



MyErrors .= "`nThere was a problem setting the security flags. 'WinINet\InternetSetOption" WorA "' failed: Flags value = " pos ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError



Else If !( 0 < Content_Length ) && !DllCall( "WinINet\HttpSendRequest" WorA, Ptr, hRequest, Ptr, 0, "UInt", 0, Ptr, 0, "UInt", 0 )



MyErrors .= "`nThere was a problem sending the " Method_Verb " request. 'WinINet\HttpSendRequest" WorA "' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError



Else If ( 0 < Content_Length ) && !DllCall( "WinINet\HttpSendRequestEx" WorA, Ptr, hRequest, Ptr, &INTERNET_BUFFERS, "UInt", 0, Ptr, 0, "UInt", 0 )



MyErrors .= "`nThere was a problem sending the " Method_Verb " request. 'WinINet\HttpSendRequestEx" WorA "' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError



Else If ( 0 < Content_Length )



{



If ( Do_Callback ) && ( "CANCEL" = %Do_Callback_Func%( -1, Content_Length, Do_Callback_3rdParam ) )



MyErrors .= "`nThe callback function: """ Do_Callback_Func """ returned 'CANCEL' to cancel the transaction. Zero bytes were uploaded."



Else	If ( Do_File_Upload ) && !( Do_File_Upload := DllCall( "CreateFile" WorA, Ptr, &Upload_File_Path, "UInt", 0x80000000, "UInt", 0, Ptr, 0, "UInt", 4, "UInt", 0, Ptr, 0, Ptr ) )



MyErrors .= "`nThere was a problem opening the file to upload """ Upload_File_Path """. 'CreateFile" WorA "' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError



Else



{



size := 0



Loop



If ( Content_Length <= size )



Break



Else IfInString, MyErrors, `n



Break



Else



{



If ( size < Do_Multipart )



{



pos := &rbuffer



dtsz := Do_Multipart - size < 4096 ? Do_Multipart - size : 4096



}



Else If ( Do_Multipart + dbuffsz <= size )



{



pos := &rbuffer + Do_Multipart



dtsz := Content_Length - size < 4096 ? Content_Length - size : 4096



}



Else If ( Do_File_Upload ) && !DllCall( "ReadFile", Ptr, Do_File_Upload, Ptr, pos := &dbuffer, "UInt", dbuffsz - size < 4096 ? dbuffsz - size : 4096, "Int*", dtsz, Ptr, 0 )



{



MyErrors .= "`nThere was a problem reading from the file """ Upload_File_Path """. 'ReadFile' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError



Break



}



Else



{



pos := &dbuffer + size



dtsz := dbuffsz - size < 4096 ? dbuffsz - size : 4096



}



If !DllCall( "WinINet\InternetWriteFile", Ptr, hRequest, Ptr, pos, "UInt", dtsz + 0, "Int*", dtsz )



MyErrors .= "`nThere was a problem uploading the POST data. 'WinINet\InternetWriteFile' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError



Else



{



size += dtsz



If ( Do_Callback ) && ( "CANCEL" = %Do_Callback_Func%( size / Content_Length - 1, Content_Length, Do_Callback_3rdParam ) )



MyErrors .= "`nThe callback function: """ Do_Callback_Func """ returned 'CANCEL' to cancel the transaction. " size " bytes were uploaded."



}



}



If ( Do_File_Upload ) && !DllCall( "CloseHandle", Ptr, Do_File_Upload )



MyErrors .= "`nThere was a problem closing the file """ Upload_File_Path """. 'CloseHandle' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError



}



DllCall( "WinINet\HttpEndRequest" WorA, Ptr, hRequest, Ptr, 0, "UInt", 0, Ptr, 0 )



}



Content_Length := size := rbuffsz := 0



If InStr( MyErrors, "`n" )



hbuffer := ""



Else



{



DllCall( "WinINet\InternetQueryDataAvailable", Ptr, hRequest, "Int*", Content_Length, "UInt", 0, Ptr, 0 )



If VarSetCapacity( hbuffer, hbuffsz := 4096, 0 )



&& !DllCall( "WinINet\HttpQueryInfo" WorA, Ptr, hRequest, "UInt", 22, Ptr, &hbuffer, "Int*", hbuffsz, Ptr, 0 )



&& VarSetCapacity( hbuffer, hbuffsz, 0 )



&& !DllCall( "WinINet\HttpQueryInfo" WorA, Ptr, hRequest, "UInt", 22, Ptr, &hbuffer, "Int*", hbuffsz, Ptr, 0 )



MyErrors .= "`nThere was a problem reading the response headers. 'WinINet\HttpQueryInfo" WorA "' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError



Else



{



VarSetCapacity( hbuffer, -1 )



StringReplace, hbuffer, hbuffer, `r`n, `n, A



StringMid, Response_Code, hbuffer, InStr( hbuffer, " " ) + 1, 3



If ( 17 != pos := 17 + InStr( hbuffer, "`nContent-Length: " ) )



StringMid, Content_Length, hbuffer, pos, InStr( hbuffer, "`n", 0, pos ) - pos



}



}



If ( Content_Length ) && !InStr( MyErrors, "`n" )



{



If ( Do_Download_To_File ) && !( Do_Download_To_File := DllCall( "CreateFile" WorA, Ptr, &output_file_path, "UInt", 0x40000000, "UInt", 0, Ptr, 0, "UInt", 4, "UInt", 0, Ptr, 0, Ptr ) )



MyErrors .= "`nThere was a problem opening/creating the output file for writing data: """ output_file_path """. 'CreateFile" WorA "' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError



Else If ( Do_Download_Resume ) && !DllCall( "SetFilePointerEx", Ptr, Do_Download_To_File, "Int64", Do_Download_Resume, Ptr, 0, "UInt", 0 )



MyErrors .= "`nThere was a problem seeking to the end of the output file for resuming the download. 'SetFilePointerEx' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError



Else If ( Do_Callback ) && ( "CANCEL" = %Do_Callback_Func%( Do_Download_Resume, Content_Length + Do_Download_Resume, Do_Callback_3rdParam ) )



MyErrors .= "`nThe callback function: """ Do_Callback_Func """ returned 'CANCEL' to cancel the transaction. Zero bytes were downloaded."



Else



{



VarSetCapacity( dbuffer, dbuffsz := Do_Download_To_File ? 4096 : 4096 + Content_Length, 0 )



Loop



IfInString, MyErrors, `n



Break



Else



{



If ( Do_Download_To_File )



pos := &dbuffer



Else If ( size + 4096 < Content_Length )



pos := &dbuffer + size



Else



{



VarSetCapacity( rbuffer, rbuffsz := size + 4096 + 1, 0 )



pos := &rbuffer + size



}



If !DllCall( "WinINet\InternetReadFile", Ptr, hRequest, Ptr, pos, "UInt", 4096, "Int*", dtsz )



MyErrors .= "`nThere was a problem downoading data. 'WinINet\InternetReadFile' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError



Else If !dtsz



{



If ( Do_Callback )



%Do_Callback_Func%( 1, Content_Length + Do_Download_Resume, Do_Callback_3rdParam )



Break



}



Else If ( Do_Download_To_File ) && !DllCall( "WriteFile", Ptr, Do_Download_To_File, Ptr, pos, "UInt", dtsz, "Int*", 0, Ptr, 0 )



MyErrors .= "`nThere was a problem writing data to the disk. 'WriteFile' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError



Else If !( Do_Download_To_File ) && ( size < rbuffsz )



{



DllCall( "RtlMoveMemory", Ptr, &rbuffer, Ptr, &dbuffer, "Int", size )



VarSetCapacity( dbuffer, Content_Length := 4096 + ( size += dtsz ), 0 )



DllCall( "RtlMoveMemory", Ptr, &dbuffer, Ptr, &rbuffer, "Int", size )



rbuffsz := 0



}



Else size += dtsz



If ( Do_Callback ) && ( "CANCEL" = %Do_Callback_Func%( ( size + Do_Download_Resume ) / ( Content_Length + Do_Download_Resume ), Content_Length + Do_Download_Resume, Do_Callback_3rdParam ) )



MyErrors .= "`nThe callback function: """ Do_Callback_Func """ returned 'CANCEL' to cancel the transaction. " size " bytes were uploaded."



}



If ( Do_Download_To_File )



{



If ( Do_Legacy_Dual_Output )



{



VarSetCapacity( dbuffer, size + 1, 0 )



If !DllCall( "ReadFile", Ptr, Do_Download_To_File, Ptr, &dbuffer, "UInt", size, Ptr, 0, Ptr, 0 )



MyErrors .= "`nThere was a problem reading the file """ output_file_path """. 'ReadFile' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError



}



If !DllCall( "CloseHandle", Ptr, Do_Download_To_File )



MyErrors .= "`nThere was a problem closing the file """ output_file_path """. 'CloseHandle' failed: ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError



}



}



}



DllCall( "WinINet\InternetCloseHandle", Ptr, hRequest )



DllCall( "WinINet\InternetCloseHandle", Ptr, hConnection )



DllCall( "WinINet\InternetCloseHandle", Ptr, hInternet )



DllCall( "FreeLibrary", Ptr, hModule )



If ( Do_Dn_MD5_Hash ) && InStr( hbuffer, "`nContent-MD5: " )



If ( Do_Download_To_File )



hbuffer .= "`nComputed-MD5: " HTTPRequest_MD5( rbuffer, output_file_path )



Else hbuffer .= "`nComputed-MD5: " HTTPRequest_MD5( dbuffer, size )



If ( size ) && ( !( Do_Download_To_File ) || ( Do_Legacy_Dual_Output ) )



{



If ( 15 != pos := 15 + InStr( hbuffer, "`nContent-Type: " ) )



StringMid, Content_Type, hbuffer, pos, InStr( hbuffer "`n", "`n", 0, pos ) - pos



Else Content_Type := "text/plain; charset=" MyCharset



If ( 7 != pos := 7 + InStr( Content_Type, "charset=" ) )



&& ( pos := InStr( Codepage_Charsets, SubStr( Content_Type, pos



, InStr( Content_Type ";" , ";", 0, pos ) - pos ) "|" ) )



StringMid, Convert_POST_To_Codepage, Codepage_Charsets, pos - 5, 5



Else Convert_POST_To_Codepage := IsUnicode ? "65001" : MyACP



StringLeft, Content_Type, Content_Type, InStr( Content_Type ";", ";" ) - 1



If !( pos := InStr( Content_Type, "text/" ) = 1 )



Loop, Parse, Text_Content_Subtypes, /



If ( pos |= 0 < InStr( Content_Type, "/" A_LoopField ) )



Break



If ( Do_Binary_Down ) || !( pos ) || ( Convert_POST_To_Codepage = MyACP )



{



VarSetCapacity( In_POST__Out_Data, size + 2, 0 )



DllCall( "RtlMoveMemory", Ptr, &In_POST__Out_Data, Ptr, &dbuffer, "Int", size )



If ( pos )



VarSetCapacity( In_POST__Out_Data, -1 )



}



Else



{



If ( Convert_POST_To_Codepage = "01200" )



{



pos := &dbuffer



rbuffsz := size >> 1



}



Else If ( 0 < rbuffsz := DllCall( "MultiByteToWideChar", "UInt", Convert_POST_To_Codepage, "UInt", 0, Ptr, &dbuffer, "Int", size, Ptr, 0, "Int", 0 ) )



{



VarSetCapacity( rbuffer, rbuffsz + 1 << 1 )



DllCall( "MultiByteToWideChar", "UInt", Convert_POST_To_Codepage, "UInt", 0, Ptr, &dbuffer, "Int", size, Ptr, pos := &rbuffer, "Int", rbuffsz )



}



Else MyErrors .= "`nThere was a problem converting codepage " Convert_POST_To_Codepage " to " MyACP ". 'MultiByteToWideChar' failed: Return value = " rbuffsz ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError



If ( IsUnicode )



{



VarSetCapacity( In_POST__Out_Data, rbuffsz + 1 << 1, 0 )



DllCall( "RtlMoveMemory", Ptr, &In_POST__Out_Data, Ptr, &rbuffer, "Int", rbuffsz << 1 )



VarSetCapacity( In_POST__Out_Data, -1 )



}



Else If ( 0 < rbuffsz ) && ( 0 < dbuffsz := DllCall( "WideCharToMultiByte", "UInt", MyACP, "UInt", 0, Ptr, pos, "Int", rbuffsz, Ptr, 0, "Int", 0, Ptr, 0, Ptr, 0 ) )



{



VarSetCapacity( In_POST__Out_Data, dbuffsz + 1, 0 )



DllCall( "WideCharToMultiByte", "UInt", MyACP, "UInt", 0, Ptr, pos, "Int", rbuffsz, Ptr, &In_POST__Out_Data, "Int", dbuffsz, Ptr, 0, Ptr, 0 )



size := dbuffsz



VarSetCapacity( In_POST__Out_Data, -1 )



}



Else MyErrors .= "`nThere was a problem converting codepage " Convert_POST_To_Codepage " to " MyACP ". 'WideCharToMultiByte' failed: Return value = " dbuffsz ", ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError



}



}



Else



In_POST__Out_Data := ""



In_Out_HEADERS := SubStr( hbuffer, 1, -1 ) . SubStr( MyErrors, 1 + ( hbuffer = "" ) )



Return size, dbuffer := "", hbuffer := "", rbuffer := "", ErrorLevel := Response_Code



}



HTTPRequest_MD5( byref data, length=-1 ) {



Static s, k, pty, u, p:=0, r := "GLQVGLQVGLQVGLQVEINTEINTEINTEINTDKPWDKPWDKPWDKPWFJOUFJOUFJOUFJOU"



If !( p )



{



VarSetCapacity( k, 256 )



VarSetCapacity( S, 64, 0 )



u := !!A_IsUnicode



pty := A_PtrSize = "" ? "UInt" : "Ptr"



Loop, 64



NumPut( i := Floor(Abs(Sin(A_Index)) * 0x100000000 ), k, A_Index - 1 << 2, "UInt" )



}



If length IS NOT NUMBER



IfExist, % length



{



hFile := DllCall( "CreateFile" ( u ? "W" : "A" ), "Str", length



, "UInt", 0x80000000



, "UInt", 0, pty, 0



, "UInt", 4



, "UInt", 0, pty, 0, Ptr )



VarSetCapacity( l, 8 )



DllCall( "GetFileSizeEx", pty, hFile, pty, &l )



length := NumGet( l, 0, "Int64" )



}



If Round( length ) < 1



length := StrLen( dat ) << u



ha := 0x67452301, hb := 0xEFCDAB89, hc := 0x98BADCFE, hd := 0x10325476



Loop % length + 72 >> 6



{



If ( f := length - 64 > ( e := A_Index - 1 << 6 ) ? 64 : length > e ? length - e : 0 )



If ( hFile )



DllCall( "ReadFile", pty, hFile, pty, &s, "UInt", f, pty, &l, pty, 0 )



Else DllCall( "RtlMoveMemory", pty, &s, pty, &data + e, "UInt", f )



If ( f != 64 && e <= length )



NumPut( 128, s, f, "UChar" )



If ( f < 56 )



Loop 8



NumPut( ( ( length << 3 ) >> ( A_Index - 1 << 3 ) ) & 255, s, 55 + A_Index, "UChar" )



a := ha, b := hb, c := hc, d := hd



Loop 64



{



e := NumGet( r, ( i := A_Index - 1 ) << u, "UChar" ) & 31



f := 0 = ( j := i >> 4 ) ? (b&c)|(~b&d) : j=1 ? (d&b)|(~d&c) : j=2 ? b^c^d : c^(~d|b)



g := &s + (( i * ( 3817 >> j * 3 & 7 ) + ( 328 >> j * 3 & 7 ) & 15 ) << 2 )



w := (*(g+3) << 24 | *(g+2) << 16 | *(g+1) << 8 | *g) + a + f + NumGet(k,i<<2,"UInt")



a := d, d := c, c := b, b += w << e | (( w & 0xFFFFFFFF ) >> ( 32 - e ))



}



ha := ha+a&0xFFFFFFFF, hb := hb+b&0xFFFFFFFF, hc := hc+c&0xFFFFFFFF, hd := hd+d&0xFFFFFFFF



VarSetCapacity( S, 64, 0 )



}



If ( hFile )



DllCall( "CloseHandle", pty, hFile )



Loop 32



g:=1&(i:=A_Index-1), e:=Chr(97+(i>>3))



, f:=15&(h%e%>>((!g-g+i&7)<<2)), s.=Chr(48+f+39*(9<f))



s .= "0000"



Loop 6



Loop, % 4+0*(g := Abs("0x" SubStr( s,A_Index*6-5,6)))



i:=(g>>6*(4-A_Index))&63, s.=i=63 ? "/" : i=62 ? "+" : Chr(i<26 ? i+65 : i<52 ? i+71 : i-4)



Return SubStr( s, 37, 22 ) "=="



}



Bin2Hex(ByRef Bin,Len,Chunks=32, Div="|") {



bytes:=Chunks/8



strint:=A_FormatInteger



SetFormat, IntegerFast, H



line:=""



Loop, %Len% {



chunk:=NumGet(Bin,A_Index-1, "UChar")



chunk:=SubStr("00" . SubStr(chunk,3), -1)



if (!Mod(A_Index-1,bytes) && Chunks!=0)



line.=Div



line.=chunk



}



SetFormat, IntegerFast, %strint%



Return line



}



Hex2Bin(ByRef bin, hex) {



Static fun



If (fun = "") {



h:="568b74240c8a164684d2743b578b7c240c538ac2c0e806b109f6e98ac802cac0e104880f8"



. "a164684d2741a8ac2c0e806b309f6eb80e20f02c20ac188078a16474684d275cd5b5f5ec3"



VarSetCapacity(fun,StrLen(h)//2)



Loop % StrLen(h)//2



NumPut("0x" . SubStr(h,2*A_Index-1,2), fun, A_Index-1, "Char")



}



VarSetCapacity(bin,StrLen(hex)//2)



dllcall( &fun, "uint",&bin, (A_IsUnicode ? "AStr" : "Str"),hex, "cdecl" )



}



Crypt_AES(pData, nSize, sPassword, SID = 256, bEncrypt = True)



{



CALG_AES_256 := 1 + CALG_AES_192 := 1 + CALG_AES_128 := 0x660E



CALG_SHA1 := 1 + CALG_MD5 := 0x8003



DllCall("advapi32\CryptAcquireContextA", "UintP", hProv, "Uint", 0, "Uint", 0, "Uint", 24, "Uint", 0xF0000000)



DllCall("advapi32\CryptCreateHash", "Uint", hProv, "Uint", CALG_SHA1, "Uint", 0, "Uint", 0, "UintP", hHash)



DllCall("advapi32\CryptHashData", "Uint", hHash, "Uint", &sPassword, "Uint", StrLen(sPassword), "Uint", 0)



DllCall("advapi32\CryptDeriveKey", "Uint", hProv, "Uint", CALG_AES_%SID%, "Uint", hHash, "Uint", SID<<16, "UintP", hKey)



DllCall("advapi32\CryptDestroyHash", "Uint", hHash)



If	bEncrypt



DllCall("advapi32\CryptEncrypt", "Uint", hKey, "Uint", 0, "Uint", True, "Uint", 0, "Uint", pData, "UintP", nSize, "Uint", nSize+16)



Else	DllCall("advapi32\CryptDecrypt", "Uint", hKey, "Uint", 0, "Uint", True, "Uint", 0, "Uint", pData, "UintP", nSize)



DllCall("advapi32\CryptDestroyKey", "Uint", hKey)



DllCall("advapi32\CryptReleaseContext", "Uint", hProv, "Uint", 0)



Return	nSize



}



portalUrl:="http://portal.hospital-n.local"



#(byref pwb,id){



return pwb.document.getElementById(id)



}



$(byref dom,id){



return dom.getElementById(id)



}



get(byref html,identifier,from="id",get="value"){



dom:=ComObjCreate("HtmlFile")



dom.write(regexreplace(html,"is)(<\/html>).*$","$1"))



if(from="id"){



return dom.getElementById(identifier)[get]



}else if (from="name"){



return dom.all[identifier][get]



}



}



getText(byref html){



html:=RegExReplace(html,"[\n\r\t]+","")



html:=regexreplace(html,"\s{2,}<"," <")



html:=regexreplace(html,">\s{2,}","> ")



html:=regexreplace(html,">\s+<","><")



html:=RegExReplace(html,"is)<script[^>]*>.*?<\s*\/\s*script\s*>","")



html:=regexreplace(html,"<[^<>]+>","")



html:=regexreplace(html,"i)&nbsp;"," ")



return html



}



getHtmlById(byref html,id,outer=false){



RegExMatch(html,"is)<([^>\s]+)[^>]*\sid=(?:(?:""" id """)|(?:'" id "')|(?:" id "))[^>]*>(.*?)<\s*\/\s*\1\s*>",match)



return outer ? match : match2



}



getTextById(byref html,id,trim=true){



return trim ? trim(s:=getText(getHtmlById(html,id))) : s



}



getHtmlByTagName(byref html,tagName,outer=false){



arr:=[]



i:=0



while i:=regexmatch(html,"is)<" tagName "(?:\s[^>]*)?>(.*?)<\s*\/\s*" tagName "\s*>",match,i+1)



outer ? arr.push(match) : arr.push(match1)



return arr



}



getTextByTagName(byref html,tagName,trim=true){



arr:=getHtmlByTagName(html,tagName)



arr2:=[]



for k,v in arr



trim ? arr2.push(trim(s:=getText(v))) : arr2.push(s)



return arr2



}



getUserName(userId,sid){



if !checkSid(sid)



return



global portalUrl



httprequest(url:="http://ihisaw.hospital-n.local/WebApplication/InPatient/Ward/OpenWard.aspx?SESSION=" sid,html:="",header:="")



RegExMatch(header,"ASP.NET_SessionId=(\w+)",match)



header:="Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/msword, application/x-ms-application, application/x-ms-xbap, application/vnd.ms-xpsdocument, application/xaml+xml, */*`nReferer: http://ihisaw.hospital-n.local/WebApplication/InPatient/Ward/OpenWard.aspx?SESSION=" sid "`nAccept-Language: zh-tw`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; GTB7.4; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: ihisaw.hospital-n.local`nConnection: Close`nPragma: no-cache`nCookie: " match



post:="scrollLeft=&scrollTop=&__EVENTTARGET=&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATE=" encodeurl(get(html,"__VIEWSTATE")) "&__EVENTVALIDATION=" encodeurl(get(html,"__EVENTVALIDATION")) "&NWeb1%24QueryInPatientPersonAccountControl1%24DropListHosp=T0&NWeb1%24QueryInPatientPersonAccountControl1%24DropListWard=&NWeb1%24QueryInPatientPersonAccountControl1%24SearchDayRangeTextBox=4&NWeb1%24QueryInPatientPersonAccountControl1%24PersonIDInput=&NWeb1%24QueryInPatientPersonAccountControl1%24AccountIDSEInput=&NWeb1%24QueryInPatientPersonAccountControl1%24tbxChartNoInput=&NWeb1%24QueryInPatientPersonAccountControl1%24PatientBasicInfoQueryByName1%24ctl00=&NWeb1%24QueryInPatientPersonAccountControl1%24OperationRoomInput=&NWeb1%24QueryInPatientPersonAccountControl1%24OPDateInput%24YearInput=" a_yyyy "&NWeb1%24QueryInPatientPersonAccountControl1%24OPDateInput%24MonthInput" 0+a_mm "&NWeb1%24QueryInPatientPersonAccountControl1%24OPDateInput%24DayInput" 0+a_dd "&NWeb1%24QueryInPatientPersonAccountControl1%24IDInputTextBox=" getUserId(sid) "&NWeb1%24QueryInPatientPersonAccountControl1%24DateTextBoxYearMonthDayInputUI1%24YearInput=" a_yyyy "&NWeb1%24QueryInPatientPersonAccountControl1%24DateTextBoxYearMonthDayInputUI1%24MonthInput" 0+a_mm "&NWeb1%24QueryInPatientPersonAccountControl1%24DateTextBoxYearMonthDayInputUI1%24DayInput" 0+a_dd "&NWeb1%24QueryInPatientPersonAccountControl1%24DateTextBoxYearMonthDayInputUI2%24YearInput=" a_yyyy "&NWeb1%24QueryInPatientPersonAccountControl1%24DateTextBoxYearMonthDayInputUI2%24MonthInput" 0+a_mm "&NWeb1%24QueryInPatientPersonAccountControl1%24DateTextBoxYearMonthDayInputUI2%24DayInput" 0+a_dd "&NWeb1%24QueryInPatientPersonAccountControl1%24CheckBoxShowDrMainColumn=on&NWeb1%24QueryInPatientPersonAccountControl1%24ShowIntraReportCheck=on&NWeb1%24QueryInPatientPersonAccountControl1%24QueryPersonIDByChartNo1%24ChartNoTextBox=&NWeb1%24QueryInPatientPersonAccountControl1%24QueryPersonIDByChartNo1%24LNameInput=&NWeb1%24QueryInPatientPersonAccountControl1%24QueryPersonIDByChartNo1%24FNameInput=&NWeb1%24QueryInPatientPersonAccountControl1%24QueryPersonIDByChartNo1%24BirthDayInput=&NWeb1%24QueryInPatientPersonAccountControl1%24HiddenFieldIntraReport=&NWeb1%24Group=BySelectPrint&NWeb1%24ConditionLevelDropList=%23&NWeb1%24DateExecuteSwitchDate%24YearInput=" a_yyyy "&NWeb1%24DateExecuteSwitchDate%24MonthInput" 0+a_mm "&NWeb1%24DateExecuteSwitchDate%24DayInput" 0+a_dd "&NWeb1%24OriginalUserID=&NWeb1%24TransferUserID=&NWeb1%24QueryDrIDInfoByDrName1%24EmpNoQueryInput=" userId "&NWeb1%24QueryDrIDInfoByDrName1%24QueryByID=ID%E6%9F%A5%E5%A7%93%E5%90%8D&NWeb1%24DateTextBoxYearMonthDayInputDrugGiven%24YearInput=" a_yyyy "&NWeb1%24DateTextBoxYearMonthDayInputDrugGiven%24MonthInput" 0+a_mm "&NWeb1%24DateTextBoxYearMonthDayInputDrugGiven%24DayInput" 0+a_dd "&NWeb1%24PrintStartDate%24YearInput=1500&NWeb1%24PrintStartDate%24MonthInput=1&NWeb1%24PrintStartDate%24DayInput=1&NWeb1%24PrintEndDate%24YearInput=" a_yyyy "&NWeb1%24PrintEndDate%24MonthInput" 0+a_mm "&NWeb1%24PrintEndDate%24DayInput" 0+a_dd



httprequest(url,post,header,"charset: utf-8")



regexmatch(getTextById(post,"NWeb1_QueryDrIDInfoByDrName1_EmpNoLabel"),"姓名：([^\s　]+)",match)



return match1



}



getUserId(sid){



if !checkSid(sid)



return



global portalUrl



httprequest(portalUrl "/General/Redirect.aspx?SESSION=" sid,page)



RegExMatch(page,"Portal_UserID=([^\']+)\'",match)



return match1



}



checkSid(sid){



global portalUrl



if !RegExMatch(sid,"^[A-Z\d]{32}$")



return 0



httprequest(portalUrl "/General/Redirect.aspx?SESSION=" sid,page)



return instr(page,sid) ? 1 : 0



}



renewSid(sid,loginId,loginPw){



if checkSid(sid)



return sid



else



return login(loginId,loginPw)



}



login(loginId,loginPw,HospitalCode=0){



global portalUrl



httprequest(url:=portalUrl "/General/Login.aspx",html:="")



inputs:=[]



inputs[s:="__VIEWSTATE"]:="" get(html,s)



inputs[s:="__EVENTVALIDATION"]:="" get(html,s)



inputs["txtUserID"]:="" loginId



inputs["txtPass"]:="" md5(loginpw)



inputs["ddlHospital"]:="T" hospitalCode



inputs["rdblQuickMenu"]:="H"



str=



for k,v in inputs



str.= encodeurl(k) "=" encodeurl(v) "&"



post:=str "imgBtnSubmitNew.x=0&imgBtnSubmitNew.y=0"



header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nReferer: http://portal/General/Login.aspx`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; InfoPath.2; .NET4.0C; .NET4.0E)`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: portal`nConnection: Close`nPragma: no-cache"



httprequest(url,post,header,"charset: utf-8`n+NO_COOKIES")



RegExMatch(post,"SESSION=([A-Z\d]{32})",match)



global portalAspId:=RegExReplace(header,"s).+ASP\.NET_SessionId=([^;]+);.+","$1")



return match1 ? match1 : ""



}



logout(sid,portalAspId){



global portalUrl



httprequest(url:="http://portal.hospital-n.local/General/Redirect.aspx?SESSION=" sid,html:="")



header:="Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/msword, application/x-ms-application, application/x-ms-xbap, application/vnd.ms-xpsdocument, application/xaml+xml, */*`nReferer: http://portal.hospital-n.local/General/Redirect.aspx?SESSION=" sid "`nAccept-Language: zh-tw`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; GTB7.4; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: portal.hospital-n.local`nConnection: Close`nPragma: no-cache`nCookie: _CK_NPortal=HospitalCode=T0&HospitalCodeIndex=0&UserID=" getUserId(sid) "&SessionKey=" sid "&LoginPosCode=H&LoginPosCodeIndex=0; ASP.NET_SessionId=" portalAspId



post:="__EVENTTARGET=&__EVENTARGUMENT=&__VIEWSTATE=" encodeurl(get(html,"__VIEWSTATE")) "&__EVENTVALIDATION=" encodeurl(get(html,"__EVENTVALIDATION")) "&ibtnLogOut.x=63&ibtnLogOut.y=22"



httprequest(url,post,header,"charset: utf-8")



}



patientBasicInfo(chartNo,sid,byref html=""){



if !checkSid(sid)



return []



while strlen(chartNo)<7



chartNo:="0" chartNo



if !regexmatch(chartNo,"(n|N|\d)\d{6}")



return



if(html=""){



httprequest(url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/PatientMedicalRecordListQuery.aspx?QueryBySelf=N&SESSION=" sid,html:="")



inputs:=[]



inputs[s:="__VIEWSTATE"]:="" get(html,s)



inputs[s:="__EVENTVALIDATION"]:="" get(html,s)



inputs["NWeb1$PatientBasicInfoQueryByIDAndName1$ctl01"]:="" chartNo



inputs["NWeb1$PatientBasicInfoQueryByIDAndName1$ctl09"]:="查詢"



post=



for k,v in inputs



post.= encodeurl(k) "=" encodeurl(v) "&"



header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nReferer: " url "`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; InfoPath.2; .NET4.0C; .NET4.0E)`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: ihisaw.hospital-n.local`nConnection: Close`nPragma: no-cache"



httprequest(url,post,header,"charset: utf-8`n+NO_COOKIES")



}else {



post:=html



}



ptInfo:=[]



RegExMatch(post,"<[^>]+\sid=""NWeb1_PatAccountListRecord1_PatBasicDescription""[^>]*>([^\(]+)\(([^\,])\,(\d+)\/(\d+)\/(\d+)\,([^\)]+)\)",match)



ptInfo.name:=match1



ptInfo.gender:=match2



ptInfo.birthYear:=match3



ptInfo.birthMonth:=match4



ptInfo.birthDay:=match5



ptInfo.age:=match6



ptInfo.personId:=get(post,"NWeb1_PatAccountListRecord1_personidHidden")



if (instr(post,"住院中")||instr(post,"已住院登記")||(trim(txt:=getTextById(post,"NWeb1_PatAccountListRecord1_GridViewInPatRecord_ctl02_InLabelStatusName"))&&(!instr(txt,"已出院"))))



ptInfo.ward:=getTextById(post,"NWeb1_PatAccountListRecord1_GridViewInPatRecord_ctl02_InLabelWardName") " " getTextById(post,"NWeb1_PatAccountListRecord1_GridViewInPatRecord_ctl02_InLabelRoomName") "-" getTextById(post,"NWeb1_PatAccountListRecord1_GridViewInPatRecord_ctl02_InLabelBedName")



else if s:=getTextById(post,"NWeb1_PatAccountListRecord1_GridViewEmergencyContent_ctl02_LabelEmerTempBedID")



ptInfo.ward:="ER " s



else if (trim(txt:=getTextById(post,"NWeb1_PatAccountListRecord1_GridViewEmergencyContent_ctl02_LabelEmerStatusName"))&&txt!="已離部")



ptInfo.ward:="ER"



else



ptInfo.ward:="OPD"



return ptInfo



}



patientLabDataRecent(personId,sid){



if !checkSid(sid)



return



url:= "http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/ReportResultQuery.aspx?SESSION=" sid "&PatClass=I&PersonID=" personId "&Hosp=T0&DefaultQuery=EMRContent"



httprequest(url,data,header,"charset: utf-8`n+NO_COOKIES")



arr:=new patientLabDataRecent(getHtmlById(data,"TablePatientLabResult"))



return arr



}



class patientLabDataRecent {



__New(html){



i:=0,arr:=[]



while i:=RegExMatch(html,"is)<td>([^<]*)<\/td>",match,i+1) {



if a_index<10



continue



if mod(a_index,3)=1



item:=match1



else if mod(a_index,3)=2



value:=match1



else {



date:=match1



arr[item,"" date]:=value



}



}



this.lab:=arr



}



getValue(labName){



value:=[]



for k,v in this.lab {



if (isobject(labName)) {



for m,n in labName



if(k=n)



for x,y in v



value.push(array(x,y))



}else if(k=labName)



for x,y in v



value.push(array(x,y))



}



return value



}



}



waitLoaded(byref pwb,judge="",waitSeconds=30,firstDelay=200){



sleep % firstDelay



if !isobject(judge) {



while pwb.busy {



if (a_index>waitSeconds*10)



return 0



sleep 100



}



return 1



}else{



while !judge.(pwb) {



if (a_index>waitSeconds*10)



return 0



sleep 100



}



return 1



}



}



IEGet2(Name="",matchMode="1")



{



Name := ( Name="New Tab - Windows Internet Explorer" ) ? "about:Tabs" : RegExReplace( Name, " - (Windows|Microsoft) Internet Explorer" )



if(matchMode="1"){



For Pwb in ComObjCreate( "Shell.Application" ).Windows



If ( RegExMatch(Pwb.LocationName,"^" Name) && InStr( Pwb.FullName, "iexplore.exe" ))



Return Pwb



}else if(matchMode="2"){



For Pwb in ComObjCreate( "Shell.Application" ).Windows



If ( instr(Pwb.LocationName,Name) && InStr( Pwb.FullName, "iexplore.exe" ))



Return Pwb



}else if(matchMode="3"){



For Pwb in ComObjCreate( "Shell.Application" ).Windows



If ( Pwb.LocationName=Name) && InStr( Pwb.FullName, "iexplore.exe" )



Return Pwb



}else if(matchMode="RegEx"){



For Pwb in ComObjCreate( "Shell.Application" ).Windows



If ( RegExMatch(Pwb.LocationName,Name) && InStr( Pwb.FullName, "iexplore.exe" ))



Return Pwb



}



return ""



}



labOrderList(byref pwb,divId="NWeb1_OrderSearch1_pnlSearchOrders"){



arr:=[]



if instr(pwb.document.getElementById(divId).innerText,"查無醫令")



return arr



tr:=pwb.document.getElementById(divId).getElementsByTagName("a")



loop % tr.length



if RegExMatch(tr[a_index-1].id,"NWeb1_OrderSearch1_dlsOrders_ctl\d+_lbnName")



arr[tr[a_index-1].innerText]:=tr[a_index-1].id



return arr



}



medOrderList(pwb,divId="NWeb1_MedicationDrugSearchBox_pnlControl"){



arr:=[]



tr:=pwb.document.getElementById(divId).rows



loop % tr.length-1 {



name:=tr[a_index].cells[1].innerText



arr[name,"id"]:=tr[a_index].getElementsByTagName("input")[0].id



arr[name,"bName"]:=tr[a_index].cells[2].innerText



}



return arr



}



class parseLabDataRegex



{



__New(html){



if !html



return ""



labTable:=getHtmlByTagName(html,"table")[2]



labTableRows:=getHtmlByTagName(labTable,"tr")



lab:=[]



loop % labTableRows.maxIndex()



{



i:=a_index



labTableRowText:=getText(labTableRows[i])



if(i=1){



RegExMatch(labTableRowText,"病歷號:(\w{6}\d)\s+姓名:([^\n]+)(?:先生|小姐)\s+生日:\s民國\s([^\s]+)",match)



if !match1



break



lab.chartNo:="" match1



lab.name:="" match2



lab.birthDate:="" match3



continue



}



if (!labTableRowText)



continue



if(regexmatch(labTableRowText,"登記\s([^\s]+)\s+([^\s]+)\s+([^\n]+\s+)([^\s]+)\s+No:([^\s]+)\s+(?:詳細資料\s+)?報告\s([^\s]+)\s+([^\s]+)",match)){



labNo:=match5



lab[labNo]:=[]



lab[labNo].registerDate:="" match1



lab[labNo].registerTime:="" match2



lab[labNo].sample:="" trim(match3)



lab[labNo].examRoom:="" match4



lab[labNo].reportDate:="" match6



lab[labNo].reportTime:="" match7



continue



}



if(instr(labTableRowText,"檢查項目")){



labNameCol:=labValueCol:=labUnitCol:=labRangeCol:=labInfoCol:=""



loop % getHtmlByTagName(labTableRows[i],"td").maxIndex()



{



labTableCellText:=getText(getHtmlByTagName(labTableRows[i],"td")[a_index])



if instr(labTableCellText,"檢查項目")



labNameCol:=a_index



else if instr(labTableCellText,"數值")



labValueCol:=a_index



else if instr(labTableCellText,"單位")



labUnitCol:=a_index



else if instr(labTableCellText,"標準值")



labRangeCol:=a_index



else if instr(labTableCellText,"說明")



labInfoCol:=a_index



}



continue



}



if !labNameCol || !labNo



continue



else



{



labTableCells:=getHtmlByTagName(labTableRows[i],"td")



labName:=trim(getText(labTableCells[labNameCol]))



lab[labNo][labName]:=[]



if labValueCol



lab[labNo][labName].value:="" trim(getText(labTableCells[labValueCol]))



if labUnitCol



lab[labNo][labName].unit:="" trim(getText(labTableCells[labUnitCol]))



if labRangeCol



lab[labNo][labName].range:="" trim(getText(labTableCells[labRangeCol]))



if labInfoCol



lab[labNo][labName].info:="" trim(getText(labTableCells[labInfoCol]))



}



}



labHxTable:=getHtmlByTagName(html,"table")[3]



labHxTableRows:=getHtmlByTagName(labHxTable,"tr")



labHx:=[]



loop % labHxTableRows.maxIndex()-1



{



labHxTableRow:=labHxTableRows[a_index+1]



labHx[a_index]:=[]



labHx[a_index].account:="" getText(getHtmlByTagName(labHxTableRow,"td")[2])



labHx[a_index].ptFrom:="" getText(getHtmlByTagName(labHxTableRow,"td")[3])



labHx[a_index].earliest:="" getText(getHtmlByTagName(labHxTableRow,"td")[4])



labHx[a_index].last:="" getText(getHtmlByTagName(labHxTableRow,"td")[5])



labHx[a_index].newest:="" getText(getHtmlByTagName(labHxTableRow,"td")[6])



RegExMatch(getHtmlByTagName(labHxTableRow,"td")[2],"href=""([^""]+)""",match)



labHx[a_index].link:="" match1



}



lab.push("labHx",labHx)



this.lab:=lab



}



getValue(labName,sample="BLOOD"){



StringUpper,sample,sample



result:=[]



for k,v in this.lab



{



if k is not number



continue



if !(v.sample=sample)



continue



for i,j in v



{



if !isobject(j)



continue



if(i=labName)



result.push(array("" v.registerDate " " v.registerTime,"" j.value))



}



}



return result



}



}



class parseLabData



{



__New(html){



if !html



return ""



doc := ComObjCreate("{25336920-03F9-11CF-8FD0-00AA00686F13}")



doc.write(html)



labTable:=doc.getElementsByTagName("table")[1]



labTableRows:=labTable.rows



lab:=[]



loop % labTableRows.length



{



i:=a_index-1



labTableRowText:=labTableRows[i].innerText



if(!i){



RegExMatch(labTableRowText,"病歷號:(\w{6}\d)\s+姓名:([^\n]+)(?:先生|小姐)\s+生日:\s民國\s([^\s]+)",match)



if !match1



break



lab.chartNo:="" match1



lab.name:="" match2



lab.birthDate:="" match3



continue



}



if (!labTableRowText)



continue



if(regexmatch(labTableRowText,"登記\s([^\s]+)\s+([^\s]+)\s+([^\n]+\s+)([^\s]+)\s+No:([^\s]+)\s+(?:詳細資料\s+)?報告\s([^\s]+)\s+([^\s]+)",match)){



labNo:=match5



lab[labNo]:=[]



lab[labNo].registerDate:="" match1



lab[labNo].registerTime:="" match2



lab[labNo].sample:="" trim(match3)



lab[labNo].examRoom:="" match4



lab[labNo].reportDate:="" match6



lab[labNo].reportTime:="" match7



continue



}



if(instr(labTableRowText,"檢查項目")){



labNameCol:=labValueCol:=labUnitCol:=labRangeCol:=labInfoCol:=""



loop % labTableRows[i].cells.length



{



labTableCellText:=labTableRows[i].cells[a_index-1].innerText



if instr(labTableCellText,"檢查項目")



labNameCol:=a_index-1



else if instr(labTableCellText,"數值")



labValueCol:=a_index-1



else if instr(labTableCellText,"單位")



labUnitCol:=a_index-1



else if instr(labTableCellText,"標準值")



labRangeCol:=a_index-1



else if instr(labTableCellText,"說明")



labInfoCol:=a_index-1



}



continue



}



if !labNameCol || !labNo



continue



else



{



labTableCells:=labTableRows[i].cells



labName:=trim(labTableCells[labNameCol].innerText)



lab[labNo][labName]:=[]



if labValueCol



lab[labNo][labName].value:="" trim(labTableCells[labValueCol].innerText)



if labUnitCol



lab[labNo][labName].unit:="" trim(labTableCells[labUnitCol].innerText)



if labRangeCol



lab[labNo][labName].range:="" trim(labTableCells[labRangeCol].innerText)



if labInfoCol



lab[labNo][labName].info:="" trim(labTableCells[labInfoCol].innerText)



}



}



labHxTable:=doc.getElementsByTagName("table")[2]



labHxTableRows:=labHxTable.rows



labHx:=[]



loop % labHxTableRows.length-1



{



labHxTableRow:=labHxTableRows[a_index]



labHx[a_index]:=[]



labHx[a_index].account:="" labHxTableRow.cells[1].innerText



labHx[a_index].ptFrom:="" labHxTableRow.cells[2].innerText



labHx[a_index].earliest:="" labHxTableRow.cells[3].innerText



labHx[a_index].last:="" labHxTableRow.cells[4].innerText



labHx[a_index].newest:="" labHxTableRow.cells[5].innerText



labHx[a_index].link:="" labHxTableRow.cells[1].getElementsByTagName("a")[0].href



}



lab.push("labHx",labHx)



this.lab:=lab



}



getValue(labName,sample="BLOOD"){



StringUpper,sample,sample



result:=[]



for k,v in this.lab



{



if k is not number



continue



if !(v.sample=sample)



continue



for i,j in v



{



if !isobject(j)



continue



if(i=labName)



result.push(array("" v.registerDate " " v.registerTime,"" j.value))



}



}



return result



}



}



MD5( V ) {



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



getLab4New(chartNo,sid,days=10){



global lab4portalAspId



url:="http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MedicalReportContent.aspx?PatClass=I&WardCode=03C1&ChartNo=" chartNo "&HospitalCode=T0&Seed=" a_now "&IntervalDay=-" days-1 "&SESSION=" sid



header:="Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/msword, application/xaml+xml, application/vnd.ms-xpsdocument, application/x-ms-xbap, application/x-ms-application, */*`nAccept-Language: zh-tw`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; BTRS105843; SIMBAR={170CCC21-65EC-11E2-B538-FEB49644ABDD}; GTB7.5; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nAccept-Encoding: gzip, deflate`nConnection: Close`nHost: ihisaw.hospital-n.local`nCookie: CK_MedicalReportOpen_PatientQueryCookie=SelectPatListTypeCookieIPatList=&SelectPatListTypeCookieEPatList=&SelectPatListTypeCookieOPatList=&SelectPatListTypeCookieLabPatList=&SelectPatListTypeCookieSpeList=&SelectPatListTypeCookie=IPatList;"



httprequest(url,post:="",header,"charset: utf-8")



RegExMatch(header,"is).+ASP.NET_SessionId=(\w{24}).+",match)



lab4portalAspId:=match1



url:="http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MedicalReportContent.aspx?PatClass=I&WardCode=03C1&ChartNo=" chartNo "&HospitalCode=T0&Seed=" a_now "&IntervalDay=-" days-1 "&SESSION=" sid



header:="Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/msword, application/xaml+xml, application/vnd.ms-xpsdocument, application/x-ms-xbap, application/x-ms-application, */*`nAccept-Language: zh-tw`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; BTRS105843; SIMBAR={170CCC21-65EC-11E2-B538-FEB49644ABDD}; GTB7.5; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nAccept-Encoding: gzip, deflate`nConnection: Close`nHost: ihisaw.hospital-n.local`nCookie: CK_MedicalReportOpen_PatientQueryCookie=SelectPatListTypeCookieIPatList=&SelectPatListTypeCookieEPatList=&SelectPatListTypeCookieOPatList=&SelectPatListTypeCookieLabPatList=&SelectPatListTypeCookieSpeList=; ASP.NET_SessionId=" lab4portalAspId



httprequest(url,post:="",header,"charset: utf-8")



dom:=ComObjCreate("HtmlFile")



dom.write(post)



return parseLab4New(dom)



}



parseLab4New(byref dom){



arr:=[]



loop % (spans:=$(dom,"lReportTab_lsvReportBody_ctrl0_ctl00_LabDetailedSheetControl1_SpanSort").parentNode.childNodes).length-1 {



specimen:=[]



span:=spans[a_index]



RegExMatch(text:=span.firstChild.innerText,"isO)([^:\d]+?):(.+?)\s([^:\d]+?):(\d+?)\s(.+)\s([^:\d]+?):(.+?)\s([^:\d]+?):(.+?)\s([^:\d]+?):(.+?)$",match)



specimen["Info","" trim(match.1)]:=trim(match.2)



specimen["Info","" trim(match.3)]:=trim(match.4)



specimen["Info","SpecimenName"]:=trim(match.5)



specimen["Info","" trim(match.6)]:=trim(match.7)



specimen["Info","" trim(match.8)]:=trim(match.9)



specimen["Info","" trim(match.10)]:=trim(match.11)



table:=span.getElementsByTagName("TABLE")[0]



titles:=[]



loop % (tds:=table.rows[0].childNodes).length



titles.push(trim(tds[a_index-1].innerText))



loop % (trs:=table.childNodes[1].childNodes).length {



item:=[],i:=a_index



for k,v in titles



item["" v]:="" trim(regexreplace(trs[i-1].childNodes[k-1].innerText,"歷$"))



specimen.push(item)



}



arr.push(specimen)



}



return arr



}



findLab4New(byref lab,itemName,specimenName="BLOOD"){



arr:=[],itemNameText:="檢驗項目",sort:=[],foundCount:=0



for i,specimen in lab



for k,item in specimen {



if (k="Info" || !(item[itemNameText]=itemName))



continue



if (time:=regexreplace(specimen["info","採檢"],"\D")) {



}else if (time:=regexreplace(specimen["info","登入"],"\D")) {



}else



time:=regexreplace(specimen["info","最後報告"],"\D")



sort[time]:=(++foundCount)



found:=item.clone()



for m,n in specimen.Info



found["" m]:="" n



arr.push(found)



}



sortedArr:=[]



for k,v in sort



sortedArr[foundCount+1-a_index]:=arr[v].clone()



return sortedArr



}



searchLab4(chartNo,sid){



if !checksid(sid)



return



httprequest(url:="http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MedicalReportContent.aspx?SESSION=" sid,html:="")



inputs:=[]



inputs["__LASTFOCUS"]:=""



inputs["__EVENTTARGET"]:=""



inputs["__EVENTARGUMENT"]:=""



inputs[s:="__VIEWSTATE"]:="" get(html,s)



inputs["__VIEWSTATEENCRYPTED"]:=""



inputs[s:="__PREVIOUSPAGE"]:="" get(html,s)



inputs[s:="__EVENTVALIDATION"]:="" get(html,s)



inputs["hdfDelayedAction"]:=""



inputs["hdfAction"]:=""



inputs["hdfSplitted"]:="false"



inputs["hdfSelectPatientList"]:=""



inputs["hdfPatientInfoStaus"]:=""



inputs["CleanCookie"]:="false"



inputs["HeaderTemplate1$hdfSelectedFilter"]:=""



inputs["HeaderTemplate1$hdfIsFilterSetModified"]:="False"



inputs["sltexample4"]:="LabReport"



inputs["sltexample4"]:="XrayTextReport"



inputs["sltexample4"]:="UltraSonicReport"



inputs["sltexample4"]:="ECGReport"



inputs["sltexample4"]:="CECGReport"



inputs["sltexample4"]:="TreadmillReport"



inputs["sltexample4"]:="ABPMReport"



inputs["sltexample4"]:="LungFunctionReport"



inputs["sltexample4"]:="ExerciseLungReport"



inputs["sltexample4"]:="GEEndoScopeReport"



inputs["sltexample4"]:="EchocardiogramExternalReport"



inputs["sltexample4"]:="EchocardiogramReport"



inputs["sltexample4"]:="HolterReport"



inputs["sltexample4"]:="HealthyCenterReport"



inputs["sltexample4"]:="PathologyReport"



inputs["sltexample4"]:="PapTestReport"



inputs["sltexample4"]:="SLP"



inputs["sltexample4"]:="UBTReport"



inputs["sltexample4"]:="UltraSoundReport"



inputs["sltexample4"]:="EEGReport"



inputs["sltexample4"]:="ConductionReport"



inputs["sltexample4"]:="EvokeReport"



inputs["sltexample4"]:="RTNoteReport"



inputs["sltexample4"]:="GeneticReport"



inputs["sltexample4"]:="ChromosomesReport"



inputs["sltexample4"]:="PEDEEGReport"



inputs["sltexample4"]:="PEDHEARTSONOReport"



inputs["sltexample4"]:="01400-4-601266"



inputs["sltexample4"]:="01400-4-601197"



inputs["sltexample4"]:="01400-4-601267"



inputs["sltexample4"]:="01400-4-601431"



inputs["multiselect_sltReportFilter"]:="LabReport"



inputs["multiselect_sltReportFilter"]:="XrayTextReport"



inputs["multiselect_sltReportFilter"]:="UltraSonicReport"



inputs["multiselect_sltReportFilter"]:="ECGReport"



inputs["multiselect_sltReportFilter"]:="CECGReport"



inputs["multiselect_sltReportFilter"]:="TreadmillReport"



inputs["multiselect_sltReportFilter"]:="ABPMReport"



inputs["multiselect_sltReportFilter"]:="LungFunctionReport"



inputs["multiselect_sltReportFilter"]:="ExerciseLungReport"



inputs["multiselect_sltReportFilter"]:="GEEndoScopeReport"



inputs["multiselect_sltReportFilter"]:="EchocardiogramExternalReport"



inputs["multiselect_sltReportFilter"]:="EchocardiogramReport"



inputs["multiselect_sltReportFilter"]:="HolterReport"



inputs["multiselect_sltReportFilter"]:="HealthyCenterReport"



inputs["multiselect_sltReportFilter"]:="PathologyReport"



inputs["multiselect_sltReportFilter"]:="PapTestReport"



inputs["multiselect_sltReportFilter"]:="SLP"



inputs["multiselect_sltReportFilter"]:="UBTReport"



inputs["multiselect_sltReportFilter"]:="UltraSoundReport"



inputs["multiselect_sltReportFilter"]:="EEGReport"



inputs["multiselect_sltReportFilter"]:="ConductionReport"



inputs["multiselect_sltReportFilter"]:="EvokeReport"



inputs["multiselect_sltReportFilter"]:="RTNoteReport"



inputs["multiselect_sltReportFilter"]:="GeneticReport"



inputs["multiselect_sltReportFilter"]:="ChromosomesReport"



inputs["multiselect_sltReportFilter"]:="PEDEEGReport"



inputs["multiselect_sltReportFilter"]:="PEDHEARTSONOReport"



inputs["multiselect_sltReportFilter"]:="01400-4-601266"



inputs["multiselect_sltReportFilter"]:="01400-4-601197"



inputs["multiselect_sltReportFilter"]:="01400-4-601267"



inputs["multiselect_sltReportFilter"]:="01400-4-601431"



inputs["q"]:=""



inputs["HeaderTemplate1$txbIDInput"]:="" chartNo



inputs["HeaderTemplate1$TextBoxWatermarkExtender1_ClientState"]:=""



inputs["HeaderTemplate1$btnQueryAction"]:="查詢"



inputs["PatientListTemplate1$rblPatList"]:="IPatList"



inputs["PatientListTemplate1$ddlBedHosp"]:="T0"



inputs["PatientListTemplate1$ddlWard"]:=""



post=



for k,v in inputs



post.= encodeurl(k) "=" encodeurl(v) "&"



header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nReferer: http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MedicalReportContent.aspx?`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: ihisaw.hospital-n.local`nConnection: Close`nPragma: no-cache`nCookie: InPatientWardDefaultQuery=T0|0000|00|; WardListColumnSelect=DR; ASP.NET_SessionId=MOCK_SESSION_ID



httprequest(url,post,header,"charset: utf-8")



return header "`n`n" post



}



LabIn10Days(chartNo,sid,personId=""){



if !checksid(sid)



return



while strlen(chartNo)<7



chartNo:="0" chartNo



if !personId



personId:=patientBasicInfo(chartNo,sid).personId



seed:=a_now



header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nReferer: http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleShowiframePage.aspx?SESSION=" sid "&PersonID=" personId "&Seed=" seed "`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nAccept-Encoding: gzip, deflate`nHost: portal.hospital-n.local`nConnection: Close`nCookie: _CK_NPortal=HospitalCode=T0&HospitalCodeIndex=0&UserID=" getUserId(sid) "&SessionKey=" sid "&LoginPosCode=H&LoginPosCodeIndex=0"



httprequest("http://portal.hospital-n.local/new_digreport/Lab/NewQuery.asp?result_latest=Y&chartno=" chartNo,post:="",header,"charset: utf-8")



lab:=new patientLabIn10Days(post)



return lab



}



class patientLabIn10Days {



__New(html){



i:=0,arr:=[],labNo:=""



dom:=ComObjCreate("HtmlFile")



dom.write(html)



loop % (tables:=dom.getElementsByTagName("TABLE")).length {



v:=tables[a_index-1]



if RegExMatch(v.innerText,"[^\s]+\s+([^\n]+)\s+No:(\d+)\s+\(\s+(\d+).(\d+).(\d+)\s+(\d+:\d+)[^\(]+\((\d+).(\d+).(\d+)\s+(\d+:\d+)",match){



labNo:=match2



arr["" labNo,"sample"]:="" trim(match1)



arr["" labNo,"regDate"]:=(match3+1911) match4 match5



arr["" labNo,"regTime"]:="" match6



arr["" labNo,"reportDate"]:=(match7+1911) match8 match9



arr["" labNo,"reportTime"]:="" match10



continue



}



if !labNo



continue



if(v.getElementsByTagName("TABLE").length)



continue



loop % (tr:=v.rows).length {



if(a_index=1)



continue



if (td:=tr[a_index-1].cells).length<6



continue



labName:="" trim(td[1].innerText)



arr["" labNo,"" labName,"value"]:="" trim(td[2].innerText)



arr["" labNo,"" labName,"unit"]:="" trim(td[3].innerText)



arr["" labNo,"" labName,"range"]:="" trim(td[4].innerText)



arr["" labNo,"" labName,"condition"]:="" trim(td[5].innerText)



}



labNo:=""



}



this.lab:=arr



}



getValue(byref labName,sample="BLOOD"){



result:=[]



StringUpper,sample,sample



for k,v in this.lab {



if (!isobject(v) || v.sample!=sample)



continue



if (isobject(labName))



for m,n in labName



if(isobject(v[n]))



result[v.reportDate]:=v[n]



else if (isobject(v[labName]))



result[v.reportDate]:=v[labName]



}



return result



}



}



StrPutVar(string, ByRef var, encoding)



{



VarSetCapacity( var, StrPut(string, encoding)



* ((encoding="utf-16"||encoding="cp1200") ? 2 : 1) )



return StrPut(string, &var, encoding),VarSetCapacity(var,-1)



}



patientBasicInfoTree(chartNo,sid,function="",personId=""){



if !function



return



if !checkSid(sid)



return



while strlen(chartNo)<7



chartNo:="0" chartNo



if !personId



personId:=patientBasicInfo(chartNo,sid).personId



url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleShowiframePage.aspx?SESSION=" sid "&PersonID=" personId "&Seed=" a_now



header:="Accept: */*`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nAccept-Encoding: gzip, deflate`nConnection: Close`nHost: ihisaw.hospital-n.local`nPragma: no-cache"



httprequest(url,page:="",header,"charset: utf-8`n+NO_COOKIES")



RegExMatch(page,"i)http:[^']+?SimpleInfoShowUsingPlaceHolder[^']+?Func=" function "&[^']+?Seed=\d+",match)



return (match?RegExReplace(match,"&amp;","&"):"")



}



patientBasicInfoWeb(chartNo,sid,personId="",medicalPrivacy="C5"){



if !checkSid(sid)



return



while strlen(chartNo)<7



chartNo:="0" chartNo



if !personId



personId:=patientBasicInfo(chartNo,sid).personId



url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleShowiframePage.aspx?SESSION=" sid "&PersonID=" personId "&Seed=" a_now



header2:=header:="Accept: */*`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nAccept-Encoding: gzip, deflate`nConnection: Close`nHost: ihisaw.hospital-n.local`nPragma: no-cache"



httprequest(url,page:="",header,"charset: utf-8`n+NO_COOKIES")



if(instr(page,"確認非醫療業務執行期間開檔申請")){



RegExMatch(page,"<form[^>]+action=""[^>]+ReturnPath=(\w+)[^>]+>",match)



url2:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/MedicalManagementAuthor.aspx?SESSION=" sid "&PersonID=" personId "&ReturnPath=" match1



header2:="Accept: */*`nAccept-Language: zh-tw`nReferer: " url2 "`nx-microsoftajax: Delta=true`nContent-Type: application/x-www-form-urlencoded; charset=utf-8`nCache-Control: no-cache`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nHost: ihisaw.hospital-n.local`nConnection: Close`nPragma: no-cache"



post2:="ScriptManager1=UpdatePanelContent%7CConfirmButton&__EVENTTARGET=&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATE=" encodeurl(get(page,"__VIEWSTATE")) "&__EVENTVALIDATION=" encodeurl(get(page,"__EVENTVALIDATION")) "&SelectCodeValue=" medicalPrivacy "&RBList=" medicalPrivacy "&OtherReason=&__ASYNCPOST=true&ConfirmButton=%E7%A2%BA%E8%AA%8D%E7%94%B3%E8%AB%8B%E9%96%8B%E6%AA%94"



httprequest(url2,post2,header2,"charset: utf-8`n+NO_COOKIES")



url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleShowiframePage.aspx?SESSION=" sid "&PersonID=" personId "&Seed=" a_now



header2:=header:="Accept: */*`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nAccept-Encoding: gzip, deflate`nConnection: Close`nHost: ihisaw.hospital-n.local`nPragma: no-cache"



httprequest(url,page:="",header,"charset: utf-8`n+NO_COOKIES")



}



return page



}



patientBriefMedicalRecord(chartNo,sid,personId=""){



if !checkSid(sid)



return



while strlen(chartNo)<7



chartNo:="0" chartNo



if !personId



personId:=patientBasicInfo(chartNo,sid).personId



url:=patientBasicInfoTree(chartNo,sid,"PatientBriefMedicalRecord",personId)



httprequest(url,page:="",header:="","charset: utf-8`n+NO_COOKIES")



arr:=[]



RegExMatch(page,"體重:([.\d]+)",match)



arr["BW"]:="" (match1?"" match1:"")



RegExMatch(page,"身高:([.\d]+)",match)



arr["BH"]:="" (match1?"" match1:"")



return arr



}



patientBWBH(chartNo,sid,personId=""){



if !checkSid(sid)



return



while strlen(chartNo)<7



chartNo:="0" chartNo



if !personId



personId:=patientBasicInfo(chartNo,sid).personId



url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/PatientBasicExaminationInfo.aspx?SESSION=" sid "&PersonID=" personId "&Hosp=T0&PatClass=E"



httprequest(url,page:="",header:="","charset: utf-8`n+NO_COOKIES")



arr:=[]



arr["BH"]:="" regexreplace(getTextById(page,"TextBoxInputArea_ctl00_Label1"),"i)上次記錄 : ([\d.]+|nil|NA)","$1")



arr["BW"]:="" regexreplace(getTextById(page,"TextBoxInputArea_ctl01_Label1"),"i)上次記錄 : ([\d.]+|nil|NA)","$1")



arr["UpdateDate"]:="" RegExReplace(getTextById(page,"ErrorMessage"),"is).+?([\d\/]+).*?","$1")



return arr



}



patientLabHistory(chartNo,sid,personId=""){



if !checkSid(sid)



return



while strlen(chartNo)<7



chartNo:="0" chartNo



if !personId



personId:=patientBasicInfo(chartNo,sid).personId



url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleInfoShowUsingPlaceHolder.aspx?SESSION=" sid "&PersonID=" personId "&Func=LabResultHistory&Seed=" a_now



httprequest(url,page:="",header:="","charset: utf-8`n+NO_COOKIES")



return o:=new patientLabHistory(page)



}



fill0(str,n=2,fill="0"){



while strlen(str)<n



str:=fill str



return str



}



parseRisPatientMainPage(html){



arr:=[]



html:=RegExReplace(html,"is)<input type=""hidden"" name=""__VIEWSTATE"" id=""__VIEWSTATE"" value="".+?"" \/>")



dom:=comobjcreate("HtmlFile")



dom.write(html)



arr["OrderName"]:=$(html,"NWeb1_OrderScheduleInfo1_OrderNameLabel").innerText



arr["CreatePersonName"]:=$(html,"NWeb1_OrderScheduleInfo1_lblCreateName").innerText



arr["AccountNo"]:=$(html,"NWeb1_OrderScheduleInfo1_lblAccountNo").innerText



arr["SheetNo"]:=$(html,"NWeb1_OrderScheduleInfo1_RequestSheetLabel").innerText



arr["OrderStatus"]:=$(html,"NWeb1_OrderScheduleInfo1_OrderStatusLabel").innerText



arr["ConfirmPersonName"]:=$(html,"NWeb1_OrderScheduleInfo1_LabelConfirmEmp").innerText



arr["OrderTime"]:=$(html,"NWeb1_OrderScheduleInfo1_lblCreateDateTime").title



arr["RegisterTime"]:=$(html,"NWeb1_OrderScheduleInfo1_RegisterTimeLabel").title



arr["LoginTime"]:=$(html,"NWeb1_OrderScheduleInfo1_LoginDateTimeLabel").title



arr["NotPerformReason"]:=$(html,"NWeb1_OrderScheduleInfo1_NotPerformReasonList").value



arr["SpecialInstruction"]:=$(html,"NWeb1_OrderScheduleInfo1_SpecialInstructionLabel").innerText



arr["ExecuteDr"]:=$(html,"NWeb1_OrderScheduleInfo1_ExecuteDrListLabel").innerText



arr["CCC"]:=$(html,"NWeb1_OrderScheduleInfo1_lblExecuteCCC").innerText



arr["ReportDr"]:=$(html,"NWeb1_OrderScheduleInfo1_ReportDrListLabel").innerText



arr["Technician"]:=$(html,"NWeb1_OrderScheduleInfo1_TechnicianList").innerText



arr["Machine"]:=$(html,"NWeb1_OrderScheduleInfo1_ExecuteMachineList").innerText



arr["ExecuteRecord"]:=$(html,"NWeb1_OrderScheduleInfo1_ExcuteRecordInfo").innerText



arr["ReportTime"]:=$(html,"NWeb1_OrderScheduleInfo1_txbReportDateTime").value



arr["ShouldPayAmount"]:=$(html,"NWeb1_OrderScheduleInfo1_lblShouldPayAmount").innerText



arr["PaidAmount"]:=$(html,"NWeb1_OrderScheduleInfo1_lblPaidAmount").innerText



arr["NeedToPayAmount"]:=$(html,"NWeb1_OrderScheduleInfo1_lblNeedToPayAmount").innerText



arr["LastPaidDate"]:=$(html,"NWeb1_OrderScheduleInfo1_lblLastPaidDate").innerText



arr["LastPaidDate"]:=$(html,"NWeb1_OrderScheduleInfo1_lblLastPaidDate").innerText



loop % (tr:=$(html,"NWeb1_AppendCreateOrders1_grvTreOrders").rows).length {



arr["CreateOrders",a_index,"class"]:=(td:=tr[a_index+1].cells)[2].innerText



arr["CreateOrders",a_index,"code"]:=td[3].innerText



arr["CreateOrders",a_index,"name"]:=td[4].innerText



arr["CreateOrders",a_index,"amount"]:=td[5].innerText



arr["CreateOrders",a_index,"ifEmergent"]:=td[6].innerText



arr["CreateOrders",a_index,"accountType"]:=td[7].innerText



arr["CreateOrders",a_index,"executeTime"]:=td[8].innerText



}



return arr



}



getRisPatientMainPage(sid,which="",ChartNo="",UnitList="X",StartDate="",ShiftType="",PatClass="",QueryDays=1,SheetNo="",PersonID="",AccountNo=""){



global __VIEWSTATE,__EVENTVALIDATION,portalAspId



if portalAspId=



portalAspId=3aq1hx55dvooyqyzlp0nod22



if which=



which:="02"



else



which:=fill0(which+1)



if (StartDate="")



StartDate:=substr(a_now,1,4) "/" substr(a_now,5,2) "/" substr(a_now,7,2)



url:="http://hisaw.hospital-n.local/WebApplication/Radiology/RISPatientRegistration.aspx?SESSION=" sid



if (__VIEWSTATE="" || __EVENTVALIDATION=""){



header:="Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/msword, application/xaml+xml, application/vnd.ms-xpsdocument, application/x-ms-xbap, application/x-ms-application, */*`nReferer: http://hisaw.hospital-n.local/WebApplication/Radiology/Default.aspx?SESSION=" sid "`nAccept-Language: zh-tw`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nAccept-Encoding: gzip, deflate`nHost: hisaw.hospital-n.local`nConnection: Keep-Alive`nCookie: 3=1; ASP.NET_SessionId=" portalAspId "; JSESSIONID=null; CK_Radiology_RISPatientRegistration=X_StatisticGroupCodeCookie=&IsShowChartNo=Y"



httprequest(url,post:="",header,"charset: utf-8")



__VIEWSTATE:=get(post,"__VIEWSTATE")



__EVENTVALIDATION:=get(post,"__EVENTVALIDATION")



}



header:="Accept: */*`nAccept-Language: zh-tw`nReferer: http://hisaw.hospital-n.local/WebApplication/Radiology/RISPatientRegistration.aspx?SESSION=" sid "`nx-microsoftajax: Delta=true`nContent-Type: application/x-www-form-urlencoded; charset=utf-8`nCache-Control: no-cache`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nHost: hisaw.hospital-n.local`nConnection: Keep-Alive`nPragma: no-cache`nCookie: 3=1; ASP.NET_SessionId=" portalAspId "; JSESSIONID=null; CK_Radiology_RISPatientRegistration=X_StatisticGroupCodeCookie=&IsShowChartNo=Y"



post:="NWeb1%24ScriptManager1=NWeb1%24uPnlOrders%7CNWeb1%24grvPatientOrderList%24ctl" which "%24lbnSelect&scrollLeft=0&scrollTop=99&__LASTFOCUS=&__EVENTTARGET=NWeb1%24grvPatientOrderList%24ctl" which "%24lbnSelect&__EVENTARGUMENT=&__VIEWSTATE=" encodeurl(__VIEWSTATE) "&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION) "&NWeb1%24ddlOrderType=X&NWeb1%24ddlUnitList=CHCT&NWeb1%24ddlStatisticGroupCode=MRI&NWeb1%24ddlShiftType=&NWeb1%24ddlPatClass=&NWeb1%24txbQueryStartDate=" encodeurl(StartDate) "&NWeb1%24ddlQueryDays=1&NWeb1%24txbRequestSheetNo=&NWeb1%24txbPersonID=&NWeb1%24txbAccountNo=&NWeb1%24txbChartNo=&NWeb1%24ddlStatisticGroupCodeFilter=&NWeb1%24cbxIsShowChartNo=on&NWeb1%24txbExecuteDate=" encodeurl(StartDate) " " substr(a_now,9,2) "%3A" substr(a_now,11,2) "&NWeb1%24ddlNotPerformReasonList=&NWeb1%24ddlFunctionType=&NWeb1%24grvPatientOrderList%24ctl" which "%24cbxSelect=on&NWeb1%24ddlFunctionType2=&__ASYNCPOST=true&"



httprequest(url,post,header,"charset: utf-8")



url:="http://hisaw.hospital-n.local/WebApplication/Radiology/PatientMainPage.aspx?SESSION=" sid



header:="Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/msword, application/xaml+xml, application/vnd.ms-xpsdocument, application/x-ms-xbap, application/x-ms-application, */*`nReferer: http://hisaw.hospital-n.local/WebApplication/Radiology/RISPatientRegistration.aspx?SESSION=" sid "`nAccept-Language: zh-tw`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nAccept-Encoding: gzip, deflate`nHost: hisaw.hospital-n.local`nConnection: Keep-Alive`nCookie: 3=1; ASP.NET_SessionId=" portalAspId "; JSESSIONID=null; CK_Radiology_RISPatientRegistration=X_StatisticGroupCodeCookie=&IsShowChartNo=Y"



httprequest(url,post:="",header,"charset: utf-8")



return post



}



class parseRisSchedule{



__New(html){



arr:=[]



dom:=comobjcreate("HtmlFile")



dom.write(html)



table:=$(dom,"NWeb1_grvPatientOrderList")



loop % table.rows.length-1 {



row:=table.rows[a_index]



exam:=[]



exam.Date:=trim(row.cells[2].firstChild.title)



exam.Shift:=trim(row.cells[3].innerText)



exam.ExamOrder:=trim(row.cells[4].innerText)



exam.ChartNo:=trim(row.cells[5].innerText)



exam.Name:=trim(row.cells[6].innerText)



exam.IdBirth:=trim(row.cells[6].firstChild.title)



exam.Gender:=trim(row.cells[7].innerText)



exam.Dept:=trim(row.cells[8].innerText)



exam.Dept1:=trim(row.cells[8].firstChild.title)



exam.BillType:=trim(row.cells[9].innerText)



exam.OrderName:=trim(row.cells[10].innerText)



exam.SheetNo:=trim(row.cells[10].firstChild.title)



exam.Status:=trim(row.cells[11].innerText)



exam.AccountStatus:=trim(row.cells[12].innerText)



exam.ArriveTime:=trim(row.cells[13].innerText)



exam.Emergent:=trim(row.cells[14].innerText)



exam.Portable:=trim(row.cells[15].innerText)



arr.push(exam)



}



this.schedule:=arr



}



filter(byref exam,filterName,filterValue,fitType=0){



if instr(exam.Status,"刪除")



return 0



if(fitType=1)



return exam[filterName]=trim(filterValue)?1:0



else if(fitType=0 || fitType="")



return instr(exam[filterName],trim(filterValue))?1:0



else if(fitType=2)



return regexmatch(exam[filterName],trim(filterValue))?1:0



}



query(param){



arr:=[]



for k,v in this.schedule {



match:=true



for x,y in param



if !(match:=match && this.filter(v,y.1,y.2,y.3))



break



if match



arr.push(v)



}



return arr



}



}



getRisSchedule(sid,ChartNo="",UnitList="CTE1",StartDate="",ShiftType="",PatClass="",QueryDays=1,SheetNo="",PersonID="",AccountNo=""){



global __VIEWSTATE,__EVENTVALIDATION,portalAspId



loop % 7-strlen(chartNo)



chartNo:="0" chartNo



url:="http://hisaw.hospital-n.local/WebApplication/Radiology/RISPatientRegistration.aspx?SESSION=" sid



if (__VIEWSTATE="" || __EVENTVALIDATION="" || !portalAspId){



httprequest(url,post:="",header,"charset: utf-8")



portalAspId:=RegExReplace(header,"s).+ASP\.NET_SessionId=([^;]+);.+","$1")



__VIEWSTATE:=get(post,"__VIEWSTATE")



__EVENTVALIDATION:=get(post,"__EVENTVALIDATION")



}



header:="Accept: */*`nAccept-Language: zh-tw`nReferer: http://hisaw.hospital-n.local/WebApplication/Radiology/RISPatientRegistration.aspx?SESSION=" sid "`nx-microsoftajax: Delta=true`nContent-Type: application/x-www-form-urlencoded; charset=utf-8`nCache-Control: no-cache`nAccept-Encoding: gzip, deflate`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nHost: hisaw.hospital-n.local`nConnection: Keep-Alive`nPragma: no-cache`nCookie: 3=1; ASP.NET_SessionId=" portalAspId "; JSESSIONID=null; CK_Radiology_RISPatientRegistration=X_StatisticGroupCodeCookie=&IsShowChartNo=Y"



if (StartDate="")



formattime,StartDate,% a_now,yyyy/MM/dd



queryType:="NWeb1$uPnlQuery"



if chartNo!=



queryType.="|NWeb1$btnQueryByPatient"



if UnitList!=X



queryType.="|NWeb1$ddlUnitList"



formattime,now,% a_now,yyyy/MM/dd hh:mm



post:="NWeb1%24ScriptManager1=" encodeurl(queryType) "&scrollLeft=&scrollTop=&__LASTFOCUS=&__EVENTTARGET=&__EVENTARGUMENT=&__VIEWSTATE=" encodeurl(__VIEWSTATE) "&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION) "&NWeb1%24ddlOrderType=X&NWeb1%24ddlUnitList=" encodeurl(UnitList) "&NWeb1%24ddlStatisticGroupCode=MRI&NWeb1%24ddlShiftType=" encodeurl(ShiftType) "&NWeb1%24ddlPatClass=" encodeurl(PatClass) "&NWeb1%24txbQueryStartDate=" encodeurl(StartDate) "&NWeb1%24ddlQueryDays=" encodeurl(QueryDays) "&NWeb1%24txbRequestSheetNo=" encodeurl(SheetNo) "&NWeb1%24txbPersonID=" encodeurl(PersonID) "&NWeb1%24txbAccountNo=" encodeurl(AccountNo) "&NWeb1%24txbChartNo=" encodeurl(ChartNo) "&NWeb1%24ddlStatisticGroupCodeFilter=&NWeb1%24cbxIsShowChartNo=on&__ASYNCPOST=true"



if chartNo!=



post.="&NWeb1%24btnQueryByPatient=%E6%8E%92%E7%A8%8B%E6%9F%A5%E8%A9%A2"



httprequest(url,post,header,"charset: utf-8")



return post



}



class patientLabHistory {



__New(html){



arr:=[]



,ComObjError(false)



,dom:=ComObjCreate("HtmlFile")



,dom.write(html)



loop % (tr:=dom.getElementById("TableLabHistoryNote").rows).length {



if (td:=tr[a_index-1].cells).length <=1



continue



labName:=td[1].innerText



ind=0



loop % (i:=td[2].cells).length {



if(ind:=!ind){



RegExMatch(i[a_index-1].innerText,"is)(.+)\s([^\s]+?)$",match)



,labValue:=match1



,labUnit:=match2



}else{



labDate:=i[a_index-1].innerText



if !isobject(arr["" labName,"" labDate])



arr["" labName,"" labDate]:=[]



arr["" labName,"" labDate].push(array("" labValue,"" labUnit))



}



}



}



this.lab:=arr



}



getValue(labName){



result:=[]



if(!isobject(this.lab[labName]))



return result



for k,v in this.lab[labName]



result[k]:=v



return result



}



}



getPathoportalAspId(sid){



url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/MedicalReportQuery/PathExam.aspx?SESSION=" sid



header:="Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/msword, application/x-ms-application, application/x-ms-xbap, application/vnd.ms-xpsdocument, application/xaml+xml, */*`nAccept-Language: zh-tw`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; GTB7.4; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nAccept-Encoding: gzip, deflate`nConnection: Keep-Alive`nHost: ihisaw.hospital-n.local`nCookie: NPage_MenuSettingCookie=%u5831%u544a%u7d22%u5f15%u7cfb%u7d71=Y&%u5831%u544a%u67e5%u8a62=Y"



httprequest(url,post:="",header)



RegExMatch(header,"ASP.NET_SessionId=(\w{24})",match)



return match1



}



getPatho(sid,chartNo){



global pathoportalAspId



if !pathoportalAspId



pathoportalAspId:=getPathoportalAspId(sid)



url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/MedicalReportQuery/PathExam.aspx"



header:="Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/msword, application/x-ms-application, application/x-ms-xbap, application/vnd.ms-xpsdocument, application/xaml+xml, */*`nReferer: " url "?`nAccept-Language: zh-tw`nUser-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; GTB7.4; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: ihisaw.hospital-n.local`nConnection: Close`nPragma: no-cache`nCookie: NPage_MenuSettingCookie=%u5831%u544a%u7d22%u5f15%u7cfb%u7d71=Y&%u5831%u544a%u67e5%u8a62=Y; ASP.NET_SessionId=" pathoportalAspId ";"



httprequest(url "?SESSION=" sid,html:="",h:=header)



post:="__EVENTTARGET=&__EVENTARGUMENT=&ctl07_ExpandState=eununnunnnnununnunnunnnnnununnunnn&ctl07_SelectedNode=&ctl07_PopulateLog=&__VIEWSTATE=" encodeurl(get(html,"__VIEWSTATE")) "&__EVENTVALIDATION=" encodeurl(get(html,"__EVENTVALIDATION")) "&QueryByChartNo1%24txbPatChar=" chartNo "&QueryByChartNo1%24btnPerIDPatChar=%E6%9F%A5%E8%A9%A2"



httprequest(url,post,header,"charset: utf-8")



dom:=ComObjCreate("HtmlFile")



dom.write(post)



arr:=[]



loop % (rows:=dom.getElementById("PathExam_Control1_GridViewPathExamno").rows).length



{



if a_index=1



continue



cells:=rows[i:=a_index-1].cells



arr[i,"Name"]:=trim(cells[0].innerText)



arr[i,"PathoNo"]:=trim(cells[1].innerText)



arr[i,"Department"]:=trim(cells[2].innerText)



arr[i,"Ward"]:=trim(cells[3].innerText)



arr[i,"Specimen"]:=trim(cells[4].innerText)



arr[i,"getDate"]:="" trim(convertTaiwanDateToWestern(cells[5].innerText))



arr[i,"reportDate"]:="" trim(convertTaiwanDateToWestern(cells[6].innerText))



arr[i,"linkId"]:=trim(cells[7].firstChild.id)



}



return arr



}



getPatho2(chartNo){



url:="http://converws.hospital-n.local/WebApplication/PathologyReportWS/PathologyReportWS.asmx"



header:="SOAPAction: ""http://PathologyReportWS.hospital-n.local/GetPathReportListByChartNo""`nHost: converws.hospital-n.local`nContent-Type: text/xml; charset=utf-8"



post=



	(



	<?xml version="1.0" encoding="utf-8"?>



	<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">



	  <soap:Body>



		<GetPathReportListByChartNo xmlns="http://PathologyReportWS.hospital-n.local/">



		  <chartNo>%chartNo%</chartNo>



		</GetPathReportListByChartNo>



	  </soap:Body>



	</soap:Envelope>



)



httprequest(url,post,header,"charset: utf-8")



i:=0,arr:=[]



while (i:=regexmatch(post,"is)<Table.+?<PATHCODE>(.+?)</PATHCODE><CHARTNO>" chartNo "</CHARTNO><SPECIMENGETDATE>(.+?)</SPECIMENGETDATE><REPORTDATETIME>(.+?)</REPORTDATETIME><ORGSOURCE>(.+?)</ORGSOURCE><CHECKREPORT>(.+?)</CHECKREPORT></Table>",match,i+1)) {



arr[a_index,"" "pathCode"]:="" match1



arr[a_index,"" "getDate"]:="" dateTimeParse1(match2).str



arr[a_index,"" "reportDate"]:="" dateTimeParse1(match3).str



arr[a_index,"" "resource"]:="" match4



arr[a_index,"" "report"]:="" match5



}



return arr



}



getLabValue(byref Lab2Arr,ItemName,SpecimenName="BLOOD"){



arr:=[],sort:=[],newArr:=[],foundCount:=0



if(isobject(ItemName)){



for k,v in Lab2Arr



for m,n in ItemName



if (v.ItemName=n && v.SpecimenName=SpecimenName) {



arr.push(v)



if ((time:=regexreplace(v.LogDateTime,"\D"))&&floor(substr(time,1,1))>1){



}else



time:=regexreplace(v.ReleaseDateTime,"\D")



sort["" time (++foundCount)]:=(foundCount)



}



}else {



for k,v in Lab2Arr



if (v.ItemName=ItemName && v.SpecimenName=SpecimenName) {



arr.push(v)



if ((time:=regexreplace(v.LogDateTime,"\D"))&&floor(substr(time,1,1))>1){



}else



time:=regexreplace(v.ReleaseDateTime,"\D")



sort["" time (++foundCount)]:=(foundCount)



}



}



for k,v in sort



newArr[foundCount+1-a_index]:=arr[v].clone()



return newArr



}



getLab2(chartNo,sid,startDays=14,endDays=0,startTime="",endTime=""){



global ptInfo,birthday,userId



url:="http://converws.hospital-n.local/WebApplication/MedicalReportWS/MedicalReportSelectedLabItemReportWS.asmx"



header:="SOAPAction: ""http://tempuri.org/QueryLabReportWithNormalRange""`nHost: converws.hospital-n.local`nContent-Type: text/xml; charset=utf-8"



while(strlen(chartNo)<7)



chartNo:="0" chartNo



if !ptInfo



ptInfo:=patientBasicInfo(chartNo,sid)



if !birthDay



birthDay:=ptInfo.birthYear "-" ptInfo.birthMonth "-" ptInfo.birthDay "T00:00:00"



if !userId



userId:=getUserId(sid)



if (startTime=""){



date:=a_now



date+=-%startDays%,d



FormatTime,startTime,% date,yyyy-MM-ddTHH:mm:ss



}



if (endTime=""){



date:=a_now



date+=-%endDays%,d



FormatTime,endTime,% date,yyyy-MM-ddTHH:mm:ss



}



post=



	(



	<?xml version="1.0" encoding="utf-8"?>



	<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">



	  <soap:Body>



		<QueryLabReportWithNormalRange xmlns="http://tempuri.org/">



		  <chartNo>%chartNo%</chartNo>



		  <birthday>%birthday%</birthday>



		  <loginEmpNo>%userId%</loginEmpNo>



		  <startTime>%startTime%</startTime>



		  <endTime>%endTime%</endTime>



		</QueryLabReportWithNormalRange>



	  </soap:Body>



	</soap:Envelope>



)



httprequest(url,post,header,"charset: utf-8")



itemName:=["SybaseAcc","PortalAcc","DeptCode","Value","itemCode","LoginNo","ItemName","UnitName","ItemNameShort","OrderCode","ACMGroupName","OrderSeqNo","SpecimenName","SpecimenCode","LogDate","LogDateTime","ReleaseDateTime","Description","ViewCondition","OperatorDefineRange","RangeResult","MaxValue","MinValue","PatientClassCode"]



i:=0,arr:=[]



while i:=RegExMatch(post,"is)<LabItem>(.+?)</LabItem>",m,i+1) {



j:=a_index



for k,v in itemName {



RegExMatch(m1,"<" v ">(.+?)</" v ">",match)



StringReplace,match1,match1,&gt;,>



StringReplace,match1,match1,&lt;,<



StringReplace,match1,match1,&nbsp;,%a_space%



StringReplace,match1,match1,&quot;,"



StringReplace,match1,match1,&amp;,&



arr[j,v]:=match1



}



}



return arr



}



dateTimeParse1(str,delim="-"){



arr:=[]



RegExMatch(str,"(\d{4})" delim "(\d{2})" delim "(\d{2})T(\d{2}):(\d{2}):(\d{2})((?:\+|-)(?:\d{2}):(?:\d{2}))",match)



arr.year:=match1



arr.month:=match2



arr.day:=match3



arr.hour:=match4



arr.minute:=match5



arr.second:=match6



arr.zone:=match7



arr.dateStr:=match1 fill0(match2) fill0(match3)



arr.timeStr:=fill0(match4) fill0(match5) fill0(match6)



arr.str:=arr.dateStr arr.timeStr



return arr



}



convertTaiwanDateToWestern(tw,delim="/"){



RegExMatch(tw,"(\d+)\" delim "(\d+)\" delim "(\d+)",match)



return (match1<200?(1911+match1):match1) fill0(match2) fill0(match3)



}



portalMessage(sid,phoneNos,msg,msgType=3){



global portalAspId



url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/CriticalVentilator/MessageSend.aspx?SESSION=" sid



if (msgType=2)



category:="rdbUnNormal"



else if (msgType=1)



category:="rdbCritical"



else



category:="rdbNormal"



httprequest(url,html:="")



header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nReferer: " url "`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E; Sleipnir/2.9.14)`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: ihisaw.hospital-n.local`nConnection: Keep-Alive`nPragma: no-cache"



str:="`nCookie: 3=1; ASP.NET_SessionId=" portalAspId "; JSESSIONID=null;"



post:="scrollLeft=&scrollTop=&__EVENTTARGET=NWeb1%24btnSendSMSAndEmail&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATE=" encodeurl(get(html,"__VIEWSTATE")) "&__EVENTVALIDATION=" encodeurl(get(html,"__EVENTVALIDATION")) "&NWeb1%24PersonIDInput=&NWeb1%24txbwardno=&NWeb1%24QueryInputByDr=&NWeb1%24PHSSendSeqNo=&NWeb1%24PHSTelNo=" phoneNos "&NWeb1%24txbEmail=&NWeb1%24MessageContent=" encodeurl(msg) "&NWeb1%24Category=" category "&NWeb1%24txbSearchID=loginId&NWeb1%24txbStartDate=2013%2F4%2F29&NWeb1%24txbEndDate=2013%2F5%2F2"



httprequest(url,post,header str,"charset: utf-8")



return RegExMatch(post,"is)<script>alert.+?簡訊發送完成\\n")?true:false



}



getOpHistory(sid,chartNo,personId=""){



if(personId=""){



personId:=patientBasicInfo(chartNo,sid).personId



}



httprequest("http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleInfoShowUsingPlaceHolder.aspx?SESSION=" sid "&PersonID=" personId "&Func=OPNoteList&Seed=" a_now,html:="")



dom:=ComObjCreate("HtmlFile")



dom.write(html)



arr:=[]



loop {



if((t:=getTextById(html,"TreeViewItemt" a_index-1))="")



break



RegExMatch(t,"is)(.+)_(\d+)\/(\d+)\/(\d+)",match)



arr["" match2 match3 match4]:=match1



}



return arr



}



getLab4(sid,chartNo){



global portalAspId



httprequest(url:="http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MedicalReportOpen.aspx?SESSION=" sid,html:="",header:="Cookie: ASP.NET_SessionId=" portalAspId)



url:="http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MedicalReportOpen.aspx"



header:="Cookie: NPage_MenuSettingCookie=%u5831%u544a%u7d22%u5f15%u7cfb%u7d71=Y; ASP.NET_SessionId=" portalAspId



}



htmlEscapeBack(str){



static escapeCode:="&euro;,&nbsp;,&quot;,&amp;,&lt;,&gt;,&iexcl;,&cent;,&pound;,&curren;,&yen;,&brvbar;,&sect;,&uml;,&copy;,&ordf;,&not;,&reg;,&macr;,&deg;,&plusmn;,&sup2;,&sup3;,&acute;,&micro;,&para;,&middot;,&cedil;,&sup1;,&ordm;,&raquo;,&frac14;,&frac12;,&frac34;,&iquest;,&Agrave;,&Aacute;,&Acirc;,&Atilde;,&Auml;,&Aring;,&AElig;,&Ccedil;,&Egrave;,&Eacute;,&Ecirc;,&Euml;,&Igrave;,&Iacute;,&Icirc;,&Iuml;,&ETH;,&Ntilde;,&Ograve;,&Oacute;,&Ocirc;,&Otilde;,&Ouml;,&times;,&Oslash;,&Ugrave;,&Uacute;,&Ucirc;,&Uuml;,&Yacute;,&THORN;,&szlig;,&agrave;,&aacute;,&acirc;,&atilde;,&auml;,&aring;,&aelig;,&ccedil;,&egrave;,&eacute;,&ecirc;,&euml;,&igrave;,&iacute;,&icirc;,&iuml;,&eth;,&ntilde;,&ograve;,&oacute;,&ocirc;,&otilde;,&ouml;,&divide;,&oslash;,&ugrave;,&uacute;,&ucirc;,&uuml;,&yacute;,&thorn;"



static characters:="€ ""&<>¡¢£¤¥¦§¨©ª¬®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþ"



i:=0



s:=str



while RegExMatch(s,"&([\w\d#]+?);",m,i+1) {



if RegExMatch(m,"#(\d+)",n) {



s:=RegExReplace(s,m,chr(n1))



}else {



loop,parse,escapeCode,`,



if(a_loopfield=m) {



s:=RegExReplace(s,m,substr(characters,a_index,1))



break



}



}



}



return s



}



OpdHxArrToCSV(byref arr,chartNo){



csv:=""



csv.="""病歷號"",""性別"",""生日年"",""生日月"",""生日日"",""姓名"",""門診日期"",""診斷"",""處方"",""醫令"",""年齡"",""帳號"",""院區"",""部門"",""主治醫師"",""Subjective"",""Objective"",""未來影像檢查排程"",""未來其他檢查排程"",""未來門診預約""`n"



for k,v in arr {



csv.=OpdHxToCSV(v,chartNo)



}



return csv



}



escapeQuote(str){



return trim(RegExReplace(str,"""",""""""))



}



OpdHxToCSV(html,chartNo){



v:=parseOpdHx(html)



csv:=""



csv.= """" escapeQuote(chartNo) ""","



csv.= """" escapeQuote(v.gender) ""","



RegExMatch(v.birthDay,"(\d+)\/(\d+)\/(\d+)",match)



csv.= """" escapeQuote(match1) ""","



csv.= """" escapeQuote(match2) ""","



csv.= """" escapeQuote(match3) ""","



csv.= """" escapeQuote(v.name) ""","



csv.= """" escapeQuote(v.OpdDate) ""","



str:=""



for x,y in v.diagnosis



str.= y.1 "," y.2 "`n"



csv.= """" escapeQuote(regexreplace(str,"\n?$")) ""","



str:=""



for x,y in v.drug



str.= y.name " | " y.dose " | " y.frequency " | " y.duration " | " y.totalAmount " | " y.ifChronic " | " y.orderDate " | " y.specialOrder "`n"



csv.= """" escapeQuote(regexreplace(str,"\n?$")) ""","



str:=""



for x,y in v.order



str.= y "`n"



csv.= """" escapeQuote(regexreplace(str,"\n?$")) ""","



csv.= """" escapeQuote(v.age) ""","



csv.= """" escapeQuote(v.account) ""","



csv.= """" escapeQuote(v.hospital) ""","



csv.= """" escapeQuote(v.department) ""","



csv.= """" escapeQuote(v.VS) ""","



csv.= """" escapeQuote(v.subjective) ""","



csv.= """" escapeQuote(v.objective) ""","



str:=""



for x,y in v.imageSchedule



str.= y.date " | " y.timeShift " | " y.examRoom " | " y.number " | " y.orderName "`n"



csv.= """" escapeQuote(regexreplace(str,"\n?$")) ""","



str:=""



for x,y in v.examSchedule



str.= y.date " | " y.timeShift " | " y.examRoom " | " y.number " | " y.orderName "`n"



csv.= """" escapeQuote(regexreplace(str,"\n?$")) ""","



str:=""



for x,y in v.FutureSchedule



str.= y.date " | " y.timeShift " | " y.department " | " y.OpdNo " | " y.number " | " y.VS "`n"



csv.= """" escapeQuote(regexreplace(str,"\n?$")) """`n"



return csv



}



parseOpdHx(byref html){



arr:=[]



dom:=ComObjCreate("HtmlFile")



dom.write(html)



str:=$(dom,"TablePatientBasic").rows[1].innerText



regexmatch(str,regex:="is)([^\s]+)\s+?\((\w),\s+?(\w+),\s+?([^)]+)\)",match)



arr.name:=match1



arr.gender:=match2



arr.age:=match3



arr.birthDay:=match4



str:=$(dom,"TablePatientBasic").rows[2].innerText



regexmatch(str,regex:="is)([^\s]+)\s+?([^\s]+)\s+?([^\s]+)\s+?主治醫師：([^\s]+)\s+?看診日期：([\d\/]+)",match)



arr.account:=match1



arr.hospital:=match2



arr.department:=match3



arr.VS:=match4



arr.OpdDate:=match5



arr.subjective:=htmlEscapeBack($(dom,"TableSubjectContent").rows[1].innerText)



arr.objective:=htmlEscapeBack($(dom,"TableObjectContent").rows[1].innerText)



dx:=[]



loop % $(dom,"TableDiagnosis").rows.length {



RegExMatch($(dom,"TableDiagnosis").rows[a_index-1].innerText,"is)([^,]+),\s+?(.+)",match)



dx.push(array("" match1, "" htmlEscapeBack(match2)))



}



arr.diagnosis:=dx



if $(dom,"TablePlanningContent").rows[1].getElementsByTagName("TABLE").length=0



arr.plan:=$(dom,"TablePlanningContent").rows[1].innerText



drug:=[]



loop % (tr:=$(dom,"TableDrugData").rows).length-2 {



d:=[],td:=tr[a_index+1].cells



if ((name:=htmlEscapeBack(td[0].innerText))="") || td.length<8 {



drug[drug.maxIndex(),"specialOrder"]:="" tr[a_index+1].innerText



continue



}



d.name:="" name



d.dose:="" td[1].innerText



d.frequency:="" td[2].innerText



d.duration:="" td[3].innerText



d.totalAmount:="" td[4].innerText



d.ifChronic:="" td[5].innerText



d.orderDate:="" td[6].innerText



drug.push(d)



}



arr.drug:=drug



order:=[]



loop % (tr:=$(dom,"TableOrderInfo").rows).length-1 {



contents:=RegExReplace(tr[a_index].cells[0].innerHTML,"is)<br\s*(\/)?>","ω")



loop,parse,contents,ω



{



if ((txt:=trim(htmlEscapeBack(regexreplace(a_loopfield,"is)<span[^>]+?line-through[^>]+?>.+?<\/span>"))))!="")



order.push(RegExReplace(txt,",$"))



}



}



arr.order:=order



imageSchedule:=[]



loop % (tr:=dom.getElementById("TableImageSchedule").rows).length-2 {



i:=[],td:=tr[a_index+1].cells



if(instr(tr.innerText,"未來一般檢查排程")||instr(tr.innerText,"日期"))



continue



i.date:=td[0].innerText



i.timeShift:=td[1].innerText



i.examRoom:=htmlEscapeBack(td[2].innerText)



i.number:=td[3].innerText



i.orderName:=htmlEscapeBack(td[4].innerText)



imageSchedule.push(i)



}



arr.imageSchedule:=imageSchedule



if ((table:=dom.getElementById("TableImageSchedule").nextSibling).tagName="TABLE"&&instr(table.innerText,"未來一般檢查排程")) {



examSchedule:=[]



loop % (tr:=table.rows).length-2 {



e:=[],td:=tr[a_index+1].cells



e.date:=td[0].innerText



e.timeShift:=td[1].innerText



e.examRoom:=htmlEscapeBack(td[2].innerText)



e.number:=td[3].innerText



e.orderName:=htmlEscapeBack(td[4].innerText)



examSchedule.push(e)



}



arr.examSchedule:=examSchedule



}



FutureSchedule:=[]



loop % (tr:=$(dom,"TableFutureSchedule").rows).length-2 {



f:=[],td:=tr[a_index+1].cells



f.date:=td[0].innerText



f.timeShift:=td[1].innerText



f.department:=htmlEscapeBack(td[2].innerText)



f.OpdNo:=td[3].innerText



f.number:=td[4].innerText



f.VS:=td[5].innerText



FutureSchedule.push(f)



}



arr.FutureSchedule:=FutureSchedule



return arr



}



parseOldOpdHx(byref html){



arr:=[]



dom:=ComObjCreate("HtmlFile")



dom.write(html)



loop % (elm:=dom.body.childNodes).length {



title:=trim((tr:=elm[a_index-1].firstChild.childNodes)[0].innerText)



if(title="基本資料"){



RegExMatch(tr[1].innerText,"([^\s]+)\s*?\((\w),([\d\/]+)\)\s*?\(電話\)([^\s]*?)\s*?\(手機\)([^\s]*?)\s*?\(住址\)([^\n]*)",match)



arr.name:=match1



arr.gender:=match2



arr.birthDay:=match3



arr.phone:=match4



arr.cellPhone:=match5



arr.address:=match6



}else if(title="帳號資料"){



RegExMatch(tr[1].innerText,"N醫院([^\s]+) 科部：([^\s]+) 主治醫師：([^\s]+) 看診時間：([\d\/]+)",match)



arr.hospital:=match1



arr.department:=match2



arr.VS:=match3



arr.OpdDate:=match4



}else if(title="病歷內容"){



arr.chart:=htmlEscapeBack(tr[1].innerText)



}else if(title="診斷內容"){



dx:=[],text:=tr[1].innerText



StringReplace,text,text,`,(,¢



temp:=""



loop,parse,text,¢



{



if(RegExMatch(a_loopfield,"^\w)")){



if(temp)



dx.push(htmlEscapeBack(temp)),temp:=A_LoopField



}else{



temp.=a_loopfield



}



}



dx.push(RegExReplace(htmlEscapeBack(temp),",\s?$"))



arr.diagnosis:=dx



}else if(title="處方內容"){



drug:=[]



loop % tr.length-2 {



d:=[]



name:=(td:=tr[a_index+1].childNodes)[0].innerText



d.route:=td[1].innerText



d.dose:=td[2].innerText



d.frequency:=td[3].innerText



d.duration:=td[4].innerText



d.totalAmount:=td[5].innerText



d.ifChronic:=td[6].innerText



d.specialOrder:=htmlEscapeBack(td[7].innerText)



drug["" name]:=d



}



arr.drug:=drug



}else if(title="醫令內容"){



order:=[]



loop % tr.length-1 {



order.push(htmlEscapeBack(tr[a_index].innerText))



}



arr.order:=order



}



}



return arr



}



OldOpdHxToCSV(byref html,chartNo){



v:=parseOldOpdHx(html)



csv:=""



csv.= """" escapeQuote(chartNo) ""","



csv.= """" escapeQuote(v.gender) ""","



RegExMatch(v.birthDay,"(\d+)\/(\d+)\/(\d+)",match)



csv.= """" escapeQuote(match1) ""","



csv.= """" escapeQuote(match2) ""","



csv.= """" escapeQuote(match3) ""","



csv.= """" escapeQuote(v.name) ""","



csv.= """" escapeQuote(v.OpdDate) ""","



str:=""



for x,y in v.diagnosis



str.= y "`n"



csv.= """" escapeQuote(regexreplace(str,"\n?$")) ""","



str:=""



for x,y in v.drug



str.= x " | " y.dose " | " y.frequency " | " y.duration " | " y.totalAmount " | " y.ifChronic " |  | " y.route " | " y.specialOrder "`n"



csv.= """" escapeQuote(regexreplace(str,"\n?$")) ""","



str:=""



for x,y in v.order



str.= y "`n"



csv.= """" escapeQuote(regexreplace(str,"\n?$")) ""","



csv.= """" escapeQuote(v.age) ""","



csv.= """" escapeQuote(v.account) ""","



csv.= """" escapeQuote(v.hospital) ""","



csv.= """" escapeQuote(v.department) ""","



csv.= """" escapeQuote(v.VS) ""","



csv.= """" escapeQuote(v.chart) ""","



csv.= """" escapeQuote(v.objective) ""","



return csv ","""","""",""""`n"



str:=""



for x,y in v.imageSchedule



str.= y.date " | " y.timeShift " | " y.examRoom " | " y.number " | " y.orderName "`n"



csv.= """" escapeQuote(regexreplace(str,"\n?$")) ""","



str:=""



for x,y in v.examSchedule



str.= y.date " | " y.timeShift " | " y.examRoom " | " y.number " | " y.orderName "`n"



csv.= """" escapeQuote(regexreplace(str,"\n?$")) ""","



str:=""



for x,y in v.FutureSchedule



str.= y.date " | " y.timeShift " | " y.department " | " y.OpdNo " | " y.number " | " y.VS "`n"



csv.= """" escapeQuote(regexreplace(str,"\n?$")) """`n"



}



consultInfo(sid,queryBy="",byref params="",html="",parse=1){



if (params="")



params:=[]



if (queryBy="")



queryBy:="NWeb1$QueryNotifyContent"



if queryBy=Dept



queryBy=NWeb1$ButtonQueryByDept



global __VIEWSTATE,__EVENTVALIDATION,portalAspId,__VIEWSTATEGENERATOR



if (__VIEWSTATE="" || __EVENTVALIDATION="" || portalAspId="" || __VIEWSTATEGENERATOR="")



httprequest(url:="http://ihisaw.hospital-n.local/WebApplication/InPatient/Ward/QueryNotifyRecordByDr.aspx?SESSION=" sid,html:="",header:="","charset: utf-8")



,RegExMatch(header,"i)ASP\.NET_SessionId=\w{24}",portalAspId)



header:="Accept: image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/msword, application/xaml+xml, application/vnd.ms-xpsdocument, application/x-ms-xbap, application/x-ms-application, */*`nReferer: " url "`nAccept-Language: zh-tw`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: ihisaw.hospital-n.local`nPragma: no-cache`nCookie: " portalAspId



endDate:=startDate:=a_now



if(!params.endYear)



params.endYear:=substr(endDate,1,4)



if(!params.endMonth)



params.endMonth:=substr(endDate,5,2)*1



if(!params.endDay)



params.endDay:=substr(endDate,7,2)*1



startDate+=-3,D



if(!params.startYear)



params.startYear:=substr(startDate,1,4)



if(!params.startMonth)



params.startMonth:=substr(startDate,5,2)*1



if(!params.startDay)



params.startDay:=substr(startDate,7,2)*1



if (queryBy="NWeb1$ButtonQueryByDept"){



post:="scrollLeft=0&scrollTop=0&__EVENTTARGET=" encodeurl("NWeb1$NotDepartSelectionObj$ddlDeptCode") "&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATE=" encodeurl(__VIEWSTATE:=get(html,"__VIEWSTATE")) "&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION:=get(html,"__EVENTVALIDATION")) "&NWeb1%24DateTextBoxYearMonthDayStart%24YearInput=" params.startYear "&NWeb1%24DateTextBoxYearMonthDayStart%24MonthInput=" params.startMonth "&NWeb1%24DateTextBoxYearMonthDayStart%24DayInput=" params.startDay "&NWeb1%24DateTextBoxYearMonthDayEnd%24YearInput=" params.endYear "&NWeb1%24DateTextBoxYearMonthDayEnd%24MonthInput=" params.endMonth "&NWeb1%24DateTextBoxYearMonthDayEnd%24DayInput=" params.endDay "&NWeb1%24NotDepartSelectionObj%24ddlHospitalCode=" ((hospital:=params.hospital)?hospital:"T0") "&NWeb1%24NotDepartSelectionObj%24ddlDeptCode=" params.DeptCode "&NWeb1%24DropDownListPatClass=&NWeb1%24PersonIDInput=" ((id:=params.userId)?id:getUserid(sid)) "&NWeb1%24DropDownListWardCode=" params.ward "&NWeb1%24txbChartNo=" params.chartNo "&NWeb1%24txbPatientPID=" params.patientId "&NWeb1%24QueryDrIDInfoByDrName1%24EmpNoQueryInput=&NWeb1%24HiddenFieldHospitalCode=T0&NWeb1%24NotDepartSelectionObj%24ddlSubDept=&__VIEWSTATEGENERATOR=" encodeurl(__VIEWSTATEGENERATOR:=get(html,"__VIEWSTATEGENERATOR"))



httprequest(url,html:=post,header1:=header,"charset: utf-8")



}



post:="scrollLeft=0&scrollTop=0&__EVENTTARGET=" encodeurl(queryBy) "&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATE=" encodeurl(__VIEWSTATE:=get(html,"__VIEWSTATE")) "&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION:=get(html,"__EVENTVALIDATION")) "&NWeb1%24DateTextBoxYearMonthDayStart%24YearInput=" params.startYear "&NWeb1%24DateTextBoxYearMonthDayStart%24MonthInput=" params.startMonth "&NWeb1%24DateTextBoxYearMonthDayStart%24DayInput=" params.startDay "&NWeb1%24DateTextBoxYearMonthDayEnd%24YearInput=" params.endYear "&NWeb1%24DateTextBoxYearMonthDayEnd%24MonthInput=" params.endMonth "&NWeb1%24DateTextBoxYearMonthDayEnd%24DayInput=" params.endDay "&NWeb1%24NotDepartSelectionObj%24ddlHospitalCode=" ((hospital:=params.hospital)?hospital:"T0") "&NWeb1%24NotDepartSelectionObj%24ddlDeptCode=" params.DeptCode "&NWeb1%24DropDownListPatClass=&NWeb1%24PersonIDInput=" ((id:=params.userId)?id:getUserid(sid)) "&NWeb1%24DropDownListWardCode=" params.ward "&NWeb1%24txbChartNo=" params.chartNo "&NWeb1%24txbPatientPID=" params.patientId "&NWeb1%24QueryDrIDInfoByDrName1%24EmpNoQueryInput=&NWeb1%24HiddenFieldHospitalCode=T0&NWeb1%24NotDepartSelectionObj%24ddlSubDept=&__VIEWSTATEGENERATOR=" encodeurl(__VIEWSTATEGENERATOR:=get(html,"__VIEWSTATEGENERATOR"))



httprequest(url,post,header,"charset: utf-8")



if !parse



return post



dom:=ComObjCreate("HtmlFile")



dom.write(post)



arr:=[]



if !(table:=$(dom,"NWeb1_NotifyDrRecord"))



return arr



vsName:=getUserName(params.userId,sid)



loop % (tr:=table.rows).length-1 {



if(instr(tr[a_index].innerHTML,"line-through"))



continue



vs:="" trim((td:=tr[a_index].cells)[9].innerText)



R:="" trim(td[10].innerText)



replyBy:="" trim(td[11].innerText)



GCA:="" trim(td[12].innerText)



if(params.userId && vsName!=vs && vsName!=R && vsName!=replyBy && vsName!=GCA)



continue



if !(time:=trim(RegExReplace(td[4].firstChild.title,"[\/\s:]")))



continue



row:=[]



RegExMatch(td[1].firstChild.title,"is)T0-(.+)分機:(.+)",match)



row.department:="" (d:=RegExReplace(match1,"\s"))?d:td[1].innerText



row.departmentPhone:="" trim(match2)



row.chartNo:="" trim(td[2].innerText)



row.notifyId:="" td[2].firstChild.title



row.account:="" trim(td[3].firstChild.title)



RegExMatch(td[3].innerText,"is)([^\(]+)\((\w),([^\)]+)\)",match)



row.name:=match1,row.gender:=match2,row.age:=match3



row.time:=time



row.type:="" trim(td[5].innerText)



row.type2:=td[5].firstChild.title



row.consulter:="" trim(td[6].innerText)



RegExMatch(td[6].firstChild.title,"\d+",match)



row.consulterPhone:=match



row.purpose:=td[7].firstChild.title



row.consulted:="" trim(td[8].innerText)



row.VS:=vs



RegExMatch(td[9].firstChild.title,"\d+",match)



row.Rphone:=match



row.R:=R



RegExMatch(td[10].firstChild.title,"\d+",match)



row.Rphone:=match



row.replyBy:=replyBy



row.GCA:=GCA



row.status:="" trim(td[13].innerText)



row.leftTime:="" trim(td[14].innerText)



arr.push(row)



}



return arr



}



getConsult(sid,accountIDSE,notifyIDSE,PatClass){



seed2:=(substr(a_now,9,2)<12?"上午":"下午") " " substr(a_now,11,2) ":" substr(a_now,13,2) ":" substr(a_now,15,2)



url:="http://ihisaw.hospital-n.local/WebApplication/InPatient/Ward/NotifyOtherDoctor.aspx?SESSION=" sid "&AccountIDSE=" accountIDSE "&NotifyIDSE=" notifyIDSE  "&Reply=Y&Seed=" seed2



httprequest(url,html:="",header:="","charset: utf-8`n+NO_COOKIES")



return html



}



replyConsult(sid,accountIDSE,notifyIDSE,PatClass,replyContent,diagnosis,suggestion,byref params=""){



seed1:=(substr(a_now,9,2)<12?"%ufffdU%ufffd%ufffd":"%ufffdU%ufffd%ufffd") "+" substr(a_now,11,2) "%3a" substr(a_now,13,2) "%3a" substr(a_now,15,2)



seed2:=(substr(a_now,9,2)<12?"上午":"下午") " " substr(a_now,11,2) ":" substr(a_now,13,2) ":" substr(a_now,15,2)



url:="http://ihisaw.hospital-n.local/WebApplication/InPatient/Ward/NotifyOtherDoctor.aspx?SESSION=" sid "&AccountIDSE=" accountIDSE "&NotifyIDSE=" notifyIDSE  "&Reply=Y&Seed=" seed1



referer:="http://ihisaw.hospital-n.local/WebApplication/InPatient/Ward/NotifyOtherDoctor.aspx?SESSION=" sid "&AccountIDSE=" accountIDSE "&NotifyIDSE=" notifyIDSE  "&Reply=Y&Seed=" seed2



html:=getConsult(sid,accountIDSE,notifyIDSE,PatClass)



dom:=ComObjCreate("HtmlFile")



dom.write(html)



header:="Accept: image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*`nReferer: " referer "`nAccept-Language: zh-TW`nUser-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)`nContent-Type: application/x-www-form-urlencoded`nAccept-Encoding: gzip, deflate`nHost: ihisaw.hospital-n.local`nConnection: Close`nPragma: no-cache"



post:="scrollLeft=0&scrollTop=0&__EVENTTARGET=NWeb1%24btnRecordFisrtAnalysisTime&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATE=" encodeurl($(dom,"__VIEWSTATE").value) "&__EVENTVALIDATION=" encodeurl($(dom,"__EVENTVALIDATION").value) "&NWeb1%24TextboxMainPurpose=" regexreplace(encodeurl($(dom,"NWeb1_TextboxMainPurpose").value),"%20","+") "&NWeb1%24TextboxDescription=" regexreplace(encodeurl($(dom,"NWeb1_TextboxDescription").value),"%20","+") "&NWeb1%24TextboxReplyContent=" regexreplace(encodeurl(replyContent),"%20","+") "&NWeb1%24TextboxDiagnosis=" regexreplace(encodeurl(diagnosis),"%20","+") "&NWeb1%24TextboxSuggestion=" regexreplace(encodeurl(suggestion),"%20","+") "&NWeb1%24atxbGCAEmpNo%24txbContent=" (params.VS?params.VS:$(dom,"NWeb1_atxbGCAEmpNo_txbContent").value) "&NWeb1%24TextboxCostCenterInput=" (params.costCenter?params.costCenter:$(dom,"NWeb1_TextboxCostCenterInput").value) "&hiddenInputToUpdateATBuffer_CommonToolkitScripts=1&__VIEWSTATEGENERATOR=" encodeurl($(dom,"__VIEWSTATEGENERATOR").value)



httprequest(url,post,header,"charset: utf-8`n+NO_COOKIES")



return 1



}



askForPortalIdPw(opt=0){



global loginId,loginPw,sid



priorSid:=Sid



if fileexist("portal.ini")



path:="portal.ini"



else if fileexist((dir:=regexreplace(a_scriptdir,"[/\\][^/\\]+$")) "\portal.ini")



path:=dir "\portal.ini"



AES_pw:="scsnakePortalLib"



if(!opt){



enc_dec:=""



if(loginId=""&&loginPw=""&&fileexist(path)){



iniread,loginId,% path,login,loginId



iniread,loginPw,% path,login,loginPw



Hex2Bin(enc_dec,loginPw)



size:=Crypt_AES(&enc_dec, floor(strlen(loginPw)/2), AES_pw, 256, 0)



loginPw:MOCK_PASSWORD,1,size),1,size-16)



}



priorPw:=loginPw



priorId:=loginId



}else{



priorPw:=loginPw



priorId:=loginId



loginId:="",loginPw:MOCK_PASSWORD""



}



while !checkSid(sid:=Login(loginId,loginPw)) {



if (a_index>50) {



msgbox % Can not login Portal !!



exitapp



}



loop {



inputbox,loginId,Portal login ID,,,300,150,,,,,% (loginId="ERROR")?"":loginId



if (errorlevel && !opt)



exitapp



else if (errorlevel) {



loginId:=priorId,loginPw:MOCK_PASSWORD,Sid:=priorSid



return



}



} until loginId!=""



loop {



inputbox,loginPw,Portal login password,,Hide,300,150



if (errorlevel && !opt)



exitapp



else if (errorlevel){



loginId:=priorId,loginPw:MOCK_PASSWORD,Sid:=priorSid



return



}



} until loginPw!=""



sleep 200



}



enc_dec:=loginPw "0123456789abcdef"



size:=Crypt_AES(&enc_dec, strlen(enc_dec), AES_pw, 256, 1)



encloginPw:MOCK_PASSWORD,size,32,"")



if !fileexist(path)



path:="portal.ini"



if(opt||priorId!=loginId||priorPw!=loginPw){



iniwrite,% loginId,% path,login,loginId



iniwrite,% encloginPw,% path,login,loginPw



}



}



getOptionByText(byref el,str){



if(el.tagName="select"){



loop % el.options.length {



if instr(el.options[a_index-1].innerText,str)



return object("index",a_index-1,"value",el.options[a_index-1].value)



}



}



}



queryDigiSign(sid,id){



global __VIEWSTATE,__EVENTVALIDATION,portalAspId



url:="http://ihisaw.hospital-n.local/WebApplication/DigitalSignature/DSQuery.aspx?SESSION=" sid



if (!__VIEWSTATE || !__EVENTVALIDATION || !portalAspId) {



header:="Host: ihisaw.hospital-n.local`nUser-Agent: Mozilla/5.0 (Windows NT 5.1; rv:29.0) Gecko/20100101 Firefox/29.0`nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8`nAccept-Language: en-US,en;q=0.5`nAccept-Encoding: gzip, deflate`nConnection: keep-alive"



httprequest(url,html:="",header,"charset: utf-8")



portalAspId:=RegExReplace(header,"s).+ASP\.NET_SessionId=([^;]+);.+","$1")



__VIEWSTATE:=get(html,"__VIEWSTATE")



__EVENTVALIDATION:=get(html,"__EVENTVALIDATION")



}



while strlen(id)<6



id:="0" id



formattime,date,% a_now,yyyy/MM/dd



header:="Host: ihisaw.hospital-n.local`nUser-Agent: Mozilla/5.0 (Windows NT 5.1; rv:29.0) Gecko/20100101 Firefox/29.0`nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8`nAccept-Language: en-US,en;q=0.5`nAccept-Encoding: gzip, deflate`nReferer: http://ihisaw.hospital-n.local/WebApplication/DigitalSignature/DSQuery.aspx?SESSION=" sid "`nConnection: close`nCookie: 5=1; ASP.NET_SessionId=" portalAspId "; JSESSIONID=null"



post:="scrollLeft=0&scrollTop=0&__EVENTTARGET=NWeb1%24txbEmpNO&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATE=" encodeurl(__VIEWSTATE) "&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION) "&NWeb1%24txbEmpNO=" id "&NWeb1%24txbPinCode=&NWeb1%24txtSDateChar=" encodeurl(date) "&NWeb1%24txtSDateChar_MaskedEditExtender_ClientState=&NWeb1%24txtEDateChar=" encodeurl(date) "&NWeb1%24txtEDateChar_MaskedEditExtender_ClientState="



httprequest(url,post,header,"charset: utf-8")



return post



}



queryDigiSignN(sid,id){



global __VIEWSTATE,__EVENTVALIDATION,portalAspId,loginId



url:="http://ihisaw.hospital-n.local/WebApplication/DigitalSignature/DrugGivenDS.aspx?SESSION=" sid



if (!__VIEWSTATE || !__EVENTVALIDATION || !portalAspId) {



header:="Host: ihisaw.hospital-n.local`nUser-Agent: Mozilla/5.0 (Windows NT 5.1; rv:29.0) Gecko/20100101 Firefox/29.0`nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8`nAccept-Language: en-US,en;q=0.5`nAccept-Encoding: gzip, deflate`nConnection: keep-alive"



httprequest(url,html:="",header,"charset: utf-8")



portalAspId:=RegExReplace(header,"s).+ASP\.NET_SessionId=([^;]+);.+","$1")



__VIEWSTATE:=get(html,"__VIEWSTATE")



__EVENTVALIDATION:=get(html,"__EVENTVALIDATION")



}



while strlen(id)<6



id:="0" id



formattime,date,% a_now,yyyy/MM/dd



header:="Host: ihisaw.hospital-n.local`nUser-Agent: Mozilla/5.0 (Windows NT 5.1; rv:29.0) Gecko/20100101 Firefox/29.0`nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8`nAccept-Language: en-US,en;q=0.5`nAccept-Encoding: gzip, deflate`nReferer: http://ihisaw.hospital-n.local/WebApplication/DigitalSignature/DrugGivenDS.aspx?SESSION=" sid "`nConnection: close`nCookie: 5=1; ASP.NET_SessionId=" portalAspId "; JSESSIONID=null"



d:=A_Now



d+=-6,days



post:="NWeb1%24ScriptManager1=NWeb1%24UpdatePanel1%7CNWeb1%24BtnGetEmgPatientListByDoctor&scrollLeft=0&scrollTop=0&hiddenHl7Reg=http%3A%2F%2Fihiswsvc.hospital-n.local%2FHL7Central_IIS%2FCentral.asmx-" sid "-" loginId "-" A_IPAddress1 "-DigitalSignature%2FDrugGivenDS&NWeb1%24txbEmpNO=" id "&NWeb1%24txtSDateChar=" substr(d,1,4) "%2F" substr(d,5,2) "%2F" substr(d,7,2) "&NWeb1%24txtSDateChar_MaskedEditExtender_ClientState=&NWeb1%24txtEDateChar=" a_yyyy "%2F" a_MM "%2F" a_dd "&NWeb1%24txtEDateChar_MaskedEditExtender_ClientState=&NWeb1%24txbPinCode=&NWeb1%24hiddenPin=undefind&__EVENTTARGET=&__EVENTARGUMENT=&__VIEWSTATE=" encodeurl(__VIEWSTATE) "&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION) "&__AjaxControlToolkitCalendarCssLoaded=&hiddenRecord=000000-" loginId "-T0&__ASYNCPOST=true&NWeb1%24BtnGetEmgPatientListByDoctor=%E6%9F%A5%E8%A9%A2"



httprequest(url,post,header,"charset: utf-8")



return post



}



EMRViewerMobile(sid,chartNo){



global __VIEWSTATE,__EVENTVALIDATION,portalAspId,reportpageguid



while strlen(chartNo)<7



chartNo:="0" chartNo



if !(__VIEWSTATE && __EVENTVALIDATION && reportpageguid){



url:="http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MedicalReportOpen.aspx?SESSION=" sid



header:="Host: ihisaw.hospital-n.local`nConnection: Keep-Alive"



httprequest(url,post:="",header,"charset: utf-8")



RegExMatch(post,"reportpageguid=([\w\-]+)",match)



reportpageguid:=match1



__VIEWSTATE:=get(post,"__VIEWSTATE")



__EVENTVALIDATION:=get(post,"__EVENTVALIDATION")



}



url:="http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MobileMasterPage.aspx?reportpageguid="reportpageguid



header:="Referer: http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MobileMasterPage.aspx?reportpageguid=" reportpageguid "`nHost: ihisaw.hospital-n.local`nConnection: Keep-Alive`nPragma: no-cache"



post:="__LASTFOCUS=&__EVENTTARGET=&__EVENTARGUMENT=&__VIEWSTATE=" encodeurl(__VIEWSTATE) "&__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION) "&txbIDInput=" chartNo "&btnQueryAction=%E6%9F%A5%E8%A9%A2"



httprequest(url,post,header,"charset: utf-8")



RegExMatch(post,"reportpageguid=([\w\-]+)",match)



reportpageguid:=match1



__VIEWSTATE:=get(post,"__VIEWSTATE")



__EVENTVALIDATION:=get(post,"__EVENTVALIDATION")



return new EMRViewerMobile(post)



}



class EMRViewerMobile {



__New(html){



dom:=ComObjCreate("HtmlFile")



dom.write(html)



ret:=[]



loop % $(dom,"MobileMenu").childNodes.length



{



arr:=[]



group:=$(dom,"MobileMenu").childNodes[a_index-1]



arr["title"]:=group.firstChild.firstChild.nodeValue



col:=[]



loop % group.childNodes[1].firstChild.firstChild.childNodes.length



col.push(trim(group.childNodes[1].firstChild.firstChild.childNodes[a_index-1].innerText))



loop % group.childNodes[1].childNodes[1].childNodes.length {



i:=a_index



item:=[]



item["param"]:=trim(group.childNodes[1].childNodes[1].childNodes[i-1].param)



loop % group.childNodes[1].childNodes[1].childNodes[i-1].childNodes.length {



j:=a_index



if (col[j]="開報告"){



regexmatch(group.childNodes[1].childNodes[1].childNodes[i-1].childNodes[j-1].firstChild.href,"WebForm_PostBackOptions\(""([^""]+)",match)



item["" col[j]]:="" trim(match1)



}else{



item["" col[j]]:="" trim(group.childNodes[1].childNodes[1].childNodes[i-1].childNodes[j-1].innerText)



}



}



arr.push(item)



}



ret.push(arr)



}



this.EMR:=ret



RegExMatch(html,"reportpageguid=([\w\-]+)",match)



this.reportpageguid:=match1



this.__VIEWSTATE:=get(html,"__VIEWSTATE")



this.__EVENTVALIDATION:=get(html,"__EVENTVALIDATION")



this.chartNo:=get(html,"txbIDInput")



}



getReport(reportNameSubStr,examDate,titleSubStr="影核醫",Number=0,reportDate=""){



if (reportNameSubStr="" || titleSubStr="")



return []



arr:=[],arr2:=[]



if isobject(reportNameSubStr) {



for k,v in this.EMR {



if instr(v.title,titleSubStr) {



for x,y in v {



if x is not number



continue



if reportNameSubStr.(y["報告類別"]) && instr(RegExReplace(y["檢查日期"],"\D",""),RegExReplace(examDate,"\D","")){



arr2.push(y["開報告"])



if (reportDate="" || instr(RegExReplace(y["報告日期"],"\D",""),RegExReplace(reportDate,"\D","")))



arr.push(y["開報告"])



}



}



break



}



}



}else{



for k,v in this.EMR {



if instr(v.title,titleSubStr) {



for x,y in v {



if x is not number



continue



if instr(y["報告類別"],reportNameSubStr) && instr(RegExReplace(y["檢查日期"],"\D",""),RegExReplace(examDate,"\D","")){



arr2.push(y["開報告"])



if (reportDate="" || instr(RegExReplace(y["報告日期"],"\D",""),RegExReplace(reportDate,"\D","")))



arr.push(y["開報告"])



}



}



break



}



}



}



if !arr.maxIndex()



arr:=arr2.clone()



if !arr.maxIndex()



return 0



arr2:=[]



for k,v in arr {



if (number>0&&a_index>number)



break



arr2.push(this.getReportByLink(v))



}



return arr2



}



getReportByLink(linkId){



url:="http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MobileMasterPage.aspx?reportpageguid=" this.reportpageguid



header:="Referer: http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MobileMasterPage.aspx?reportpageguid=" this.reportpageguid "`nHost: ihisaw.hospital-n.local`nConnection: Keep-Alive`nPragma: no-cache"



post:="__LASTFOCUS=&__EVENTTARGET=" encodeUrl(linkId) "&__EVENTARGUMENT=&__VIEWSTATE=" encodeurl(this.__VIEWSTATE) "&__EVENTVALIDATION=" encodeurl(this.__EVENTVALIDATION) "&ddlPatChartNo=" encodeUrl(this.chartNo) "&txbIDInput=" encodeUrl(this.chartNo) "&txtEndDate=&txtStartDate="



httprequest(url,post,header,"charset: utf-8")



url:=RegExReplace(get(post,"Reportifrm","id","src"),"&amp;","&")



httprequest(url,post:="",header:="","charset: utf-8")



return post



}



radReportText(html){



dom:=ComObjCreate("HtmlFile")



dom.write(html)



table1:=$(dom,"rReportTab_lsvReportBody_ctrl0_ctl00_tblDisplay").previousSibling.childNodes[5].firstChild



table2:=$(dom,"rReportTab_lsvReportBody_ctrl0_ctl00_tblDisplay")



str:=""



loop % table1.firstChild.childNodes.length {



i:=a_index



loop % table1.firstChild.childNodes[i-1].childNodes.length {



j:=a_index



str.=trim(table1.firstChild.childNodes[i-1].childNodes[j-1].innerText) " "



}



str.="`n"



}



loop % table2.firstChild.childNodes.length {



i:=a_index



loop % table2.firstChild.childNodes[i-1].childNodes.length {



j:=a_index



if(table2.firstChild.childNodes[i-1].childNodes[j-1].getElementsByTagName("textarea").length>0)



str.=trim(table2.firstChild.childNodes[i-1].childNodes[j-1].firstChild.firstChild.innerText) " "



else



str.=trim(table2.firstChild.childNodes[i-1].childNodes[j-1].innerText) " "



}



str.="`n"



}



return str



}



}



RisReport2Yr(sid,chartNo){



if !checksid(sid){



return -1



}



if RegExMatch(chartNo,"i)\w\d{9}"){



personId:=chartNo



}else {



while strlen(chartNo)<7



chartNo:="0" chartNo



personId:=patientBasicInfo(chartNo,sid).personId



}



url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleInfoShowUsingPlaceHolder.aspx?SESSION=" sid "&Func=RISReport&AccountIDSE=&PersonID=" personid "&Hosp=&WinPup=True&Seed=" a_hour a_min a_sec



header:="Referer: http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/PatientBasicInfoEdit/SimpleShowiframePage.aspx?SESSION=" sid "&PersonID=" personid "&Seed=" a_now "`nHost: ihisaw.hospital-n.local"



httprequest(url,post:="",header,"charset: utf-8")



return post



}



AppendAspInfo(post,html){



global __VIEWSTATE,__EVENTVALIDATION



post:=RegExReplace(post,"i)&?(__VIEWSTATE|__EVENTVALIDATION)=[^&]+","")



post:=RegExReplace(post,"i)(__VIEWSTATE|__EVENTVALIDATION)=[^&]+&?","")



if (post!="")



post.="&"



if (__VIEWSTATE="")



__VIEWSTATE:=get(html,"__VIEWSTATE")



if (__EVENTVALIDATION="")



__EVENTVALIDATION:=get(html,"__EVENTVALIDATION")



return post "__EVENTVALIDATION=" encodeurl(__EVENTVALIDATION) "&__VIEWSTATE=" encodeurl(__VIEWSTATE)



}



ExtractHeaderCookie(responseHeader){



i:=0,match:=str:=""



while i:=regexmatch(responseHeader,"i)Set-Cookie: ([^\n]+)",match,i+strlen(match)+1)



str.=match1



return str:=RegExReplace(str,"(path=\/|HttpOnly|expires=[^;]+);?","")



}



Hotstring(trigger, label, mode := 1, clearTrigger := 1, cond := ""){



global $



static keysBound := false,hotkeyPrefix := "~$", hotstrings := {}, typed := "", keys := {"symbols": "!""#$%&'()*+,-./:;<=>?@[\]^_``{|}~", "num": "0123456789", "alpha":"abcdefghijklmnopqrstuvwxyz", "other": "BS,Return,Tab,Space", "breakKeys":"Left,Right,Up,Down,Home,End,RButton,LButton,LControl,RControl,LAlt,RAlt,AppsKey,Lwin,Rwin,WheelDown,WheelUp,f1,f2,f3,f4,f5,f6,f7,f8,f9,f6,f7,f9,f10,f11,f12", "numpad":"Numpad0,Numpad1,Numpad2,Numpad3,Numpad4,Numpad5,Numpad6,Numpad7,Numpad8,Numpad9,NumpadDot,NumpadDiv,NumpadMult,NumpadAdd,NumpadSub,NumpadEnter"}, effect := {"Return" : "`n", "Tab":A_Tab, "Space": A_Space, "Enter":"`n", "Dot": ".", "Div":"/", "Mult":"*", "Add":"+", "Sub":"-"}



if (!keysBound){



for k,v in ["symbols", "num", "alpha"]



{



v := keys[v]



Loop,Parse, v



Hotkey,%hotkeyPrefix%%A_LoopField%,__hotstring



}



v := keys.alpha



Loop,Parse, v



Hotkey, %hotkeyPrefix%+%A_Loopfield%,__hotstring



for k,v in ["other", "breakKeys", "numpad"]



{



v := keys[v]



Loop,Parse, v,`,



Hotkey,%hotkeyPrefix%%A_LoopField%,__hotstring



}



keysBound := true



}



if (mode == "CALLBACK"){



Hotkey := SubStr(A_ThisHotkey,3)



if (StrLen(Hotkey) == 2 && Substr(Hotkey,1,1) == "+" && Instr(keys.alpha, Substr(Hotkey, 2,1))){



Hotkey := Substr(Hotkey,2)



if (!GetKeyState("Capslock", "T")){



StringUpper, Hotkey,Hotkey



}



}



shiftState := GetKeyState("Shift", "P")



uppercase :=  GetKeyState("Capslock", "T") ? !shiftState : shiftState



if (uppercase && Instr(keys.alpha, Hotkey)){



StringUpper, Hotkey,Hotkey



}



if (Instr("," . keys.breakKeys . ",", "," . Hotkey . ",")){



typed := ""



return



} else if Hotkey in Return,Tab,Space



{



typed .= effect[Hotkey]



} else if (Hotkey == "BS"){



StringTrimRight,typed,typed,1



return



} else if (RegExMatch(Hotkey, "Numpad(.+?)", numKey)) {



if (numkey1 ~= "\d"){



typed .= numkey1



} else {



typed .= effects[numKey1]



}



} else {



typed .= Hotkey



}



matched := false



for k,v in hotstrings



{



matchRegex := (v.mode == 1 ? "Oi)" : "")  . (v.mode == 3 ? RegExReplace(v.trigger, "\$$", "") : "\Q" . v.trigger . "\E") . "$"



if (v.mode == 3){



if (matchRegex ~= "^[^\s\)\(\\]+?\)"){



matchRegex := "O" . matchRegex



} else {



matchRegex := "O)" . matchRegex



}



}



if (RegExMatch(typed, matchRegex, local$)){



matched := true



if (v.cond != "" && IsFunc(v.cond)){



A_LoopCond := Func(v.cond)



if (A_LoopCond.MinParams >= 1){



A_LoopRetVal := A_LoopCond.(v.mode == 3 ? local$ : local$.Value(0))



} else {



A_LoopRetVal := A_LoopCond.()



}



if (!A_LoopRetVal){



matched := false



continue



}



}



if (v.clearTrigger){



SendInput % "{BS " . StrLen(local$.Value(0))  . "}"



}



if (IsLabel(v.label)){



$ := v.mode == 3 ? local$ : local$.Value(0)



gosub, % v.label



} else if (IsFunc(v.label)){



callbackFunc := Func(v.label)



if (callbackFunc.MinParams >= 1){



callbackFunc.(v.mode == 3 ? local$ : local$.Value(0))



} else {



callbackFunc.()



}



} else {



toSend := v.label



Loop, % local$.Count()



StringReplace, toSend,toSend,% "$" . A_Index,% local$.Value(A_index),All



toSend := RegExReplace(toSend,"([!#\+\^\{\}])","{$1}")



SendInput,%toSend%



}



}



}



if (matched){



typed := ""



} else if (StrLen(typed) > 350){



StringTrimLeft,typed,typed,200



}



} else {



if (hotstrings.HasKey(trigger) && label == ""){



hotstrings.Deletetrigger)



} else {



hotstrings[trigger] := {"trigger" : trigger, "label":label, "mode":mode, "clearTrigger" : clearTrigger, "cond": cond}



}



}



return



__hotstring:



Hotstring("", "", "CALLBACK")



return



}



SystemCursor(OnOff=1)



{



static AndMask, XorMask, $, h_cursor



,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13



, b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13



, h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12,h13



if (OnOff = "Init" or OnOff = "I" or $ = "")



{



$ = h



VarSetCapacity( h_cursor,4444, 1 )



VarSetCapacity( AndMask, 32*4, 0xFF )



VarSetCapacity( XorMask, 32*4, 0 )



system_cursors = 32512,32513,32514,32515,32516,32642,32643,32644,32645,32646,32648,32649,32650



StringSplit c, system_cursors, `,



Loop %c0%



{



h_cursor   := DllCall( "LoadCursor", "uint",0, "uint",c%A_Index% )



h%A_Index% := DllCall( "CopyImage",  "uint",h_cursor, "uint",2, "int",0, "int",0, "uint",0 )



b%A_Index% := DllCall("CreateCursor","uint",0, "int",0, "int",0



, "int",32, "int",32, "uint",&AndMask, "uint",&XorMask )



}



}



if (OnOff = 0 or OnOff = "Off" or $ = "h" and (OnOff < 0 or OnOff = "Toggle" or OnOff = "T"))



$ = b



else



$ = h



Loop %c0%



{



h_cursor := DllCall( "CopyImage", "uint",%$%%A_Index%, "uint",2, "int",0, "int",0, "uint",0 )



DllCall( "SetSystemCursor", "uint",h_cursor, "uint",c%A_Index% )



}



}



sendmode,input



IMPAX_id:=loginId



IMPAX_pw:=loginPw



RIS_id:=loginId



RIS_pw:=loginPw



IMPAX_title:="IMPAX 6.5.2.114 Radiologist with QC"



RisName:="陳醫師"



imageWinToggle:=1



scrollImageConst:=0



RegExMatch(a_scriptdir,"^[^\\]*",root)



onexit,onexit



gosub closeOtherAHK



gui,+lastfound +toolwindow



winget,guiHWND,id



gui,add,edit,vcommands,



gui,add,button,gterminateUSBprocess,Unmount USB



gui,add,button,gexe yp x+5,Execute



gui,show,autosize,Enter command ...



process,close,AgfaDTIWatchDog.exe



process,close,AgfaDTIBridge.exe



gosub commandArr



openedWindows:=object()



hiddenWindows:=[]



autofocus=1



setTimer,killUpdate,500



setTimer,noIdle,540000



settimer,checkExam,-1



settimer,RisImpaxRoutine,200



breakLineControls:=["txtALL","INDICATION","ALLERGY","HEALTHY_VOLUNTEER","DIAGNOSTIC","SPECIAL_MEDICAL","SYMPTOM"]



settimer,RisHistoryBreakline,500



sysget,monitorCount,monitorcount



if (monitorcount>1){



sysget,firstMonitor,monitor,1



sysget,lastMonitor,monitor,% monitorCount



settimer,cyclicMonitor,200



}



run % root "\scripts\Autohotkey\AutoHotkey.exe " root "\scripts\Radiology\TextHotkey\TextHotkey.ahk"



run % root "\scripts\Autohotkey\AutoHotkey.exe " root "\scripts\Radiology\MouseKeyRemap\capslock_remap_alt.ahk"



run % root "\scripts\Autohotkey\AutoHotkey.exe " root "\scripts\Radiology\RisTyper\AutoNum.ahk"



return



closeOtherAHK:



PID:=DllCall("GetCurrentProcessId")



for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process where name = 'Autohotkey.exe' and processID  <> " PID )



winclose,% "ahk_pid " process.ProcessId



return



:?*b0:(::){left}



~^9::



send (



return



+bs::



send ^+{right}{bs}



return



*`::



if getkeystate("shift") {



send ~



return



}



if getkeystate("ctrl"){



send ``



return



}



ifwinactive,ahk_class SciTEWindow



{



send ``



return



}



send ^+{left}{bs}



return



cyclicMonitor:



mousegetpos,x,y



if (x=lastMonitorRight-1){



mousemove,1,% y*firstMonitorBottom/lastMonitorBottom,0



}else if(x=0){



mousemove,% lastMonitorRight,% y*lastMonitorBottom/firstMonitorBottom,0



}



return



~^!z::



if !(a_priorhotkey=a_thishotkey && A_TimeSincePriorHotkey<300)



return



tooltip,% "Autofocus " ((autofocus:=!autofocus)?"":"de") "activated!"



sleep 1000



tooltip



return



RisImpaxRoutine:



risState:=risOpened(),impaxState:=impaxOpened()



return



autofocus:



if !autofocus



return



mousegetpos,x,y,mouseWin



if(priorX<a_screenwidth&&x>a_screenwidth) && !winexist("匯出影像 ahk_class WindowsForms10.Window.8.app.0.2bf8098"){



winactivate,% "ahk_id " mouseWin



}else if (priorX>a_screenwidth&&x<a_screenwidth) {



wingetclass,mouseWinClass,ahk_id %mouseWin%



if instr(mouseWinClass,"WindowsForms10.Window.8.app") && risState[2]!=mouseWin



return



if mouseWinClass not in Chrome_WidgetWin_1,AutoHotkeyGUI,#32770,IEFrame,SciTEWindow,MozillaWindowClass,SleipnirMainWindow



{



winactivate,% "ahk_id " risState[2]



}



}



priorX:=x



return



checkActivateImpax:



loop 15 {



if !winactive("ahk_class WindowsForms10.Window.8.app.0.2bf8098"){



winactivate,% "ahk_id " reActivate



break



}



sleep 200



}



return



AppsKey:



if ImpaxState[1]!=2



return



winget,list,list,ahk_class WindowsForms10.Window.8.app.0.2bf8098



loop % list {



for k,v in getControls(list%a_index%)



if (instr(v.text,"BMP_SERIES_MODE") && instr(v.classNN,"WindowsForms10.BUTTON.app")) {



loc:=Acc_Location(acc_objectfromwindow(v.hwnd))



winget,id,id,A



mousegetpos,x,y



mouseclick,l,% loc.x+1,% loc.y+1,1,0



winactivate,% id



mousemove,% x,% y,0



break



}



}



return



noIdle:



if  RisState[1]!=2



return



mousegetpos,,,win



if (win=RisState[2])



{



mousemove,1,0,0,R



mousemove,-1,0,0,R



}else {



for k,v in risControls:=GetControls(RisState[2])



if instr(v.ClassNN,"WindowsForms10.SysTreeView32") {



controlsend,,{space},% "ahk_id " v.Hwnd



break



}



}



return



killUpdate:



ifwinexist,Sleipnir ahk_class #32770,Latest version of Sleipnir



controlclick,Button2,Sleipnir ahk_class #32770,Latest version of Sleipnir



ifwinexist,SciTE4AutoHotkey Updater ahk_class #32770



controlclick,Button2,SciTE4AutoHotkey Updater ahk_class #32770



ifwinexist,Microsoft Office Activation Wizard ahk_class NUIDialog



controlsend,NetUIHWND1,{esc},Microsoft Office Activation Wizard ahk_class NUIDialog



ifwinexist,ahk_class #32770,The type initializer for 'HL7.HL7Port' threw an exception.



controlclick,Button1,ahk_class #32770,The type initializer for 'HL7.HL7Port' threw an exception.



winshow,Sleipnir ahk_class SleipnirMainWindow



if winHwnd:=winexist("放射線資訊管理系統(Radiology Information System)","Unhandled exception")



for k,v in getControls(winHwnd)



if instr(v.text,"Continue")



controlclick,,% "ahk_id " v.hwnd



if winHwnd:=winexist("放射線資訊管理系統(Radiology Information System)","未處理的例外狀況")



for k,v in getControls(winHwnd)



if instr(v.text,"繼續")



controlclick,,% "ahk_id " v.hwnd



ifwinexist,Error ahk_class #32770,A problem occurred and the application



controlclick,Button1,Error ahk_class #32770,A problem occurred and the application



ifwinexist,錯誤 ahk_class #32770,發生問題，應用程式無法繼續執行



controlclick,Button1,錯誤 ahk_class #32770,發生問題，應用程式無法繼續執行



ifwinexist,Windows - 沒有磁片



controlclick,Button1,Windows - 沒有磁片



return



parse_commands:



if !(nosubmit)



gui,submit,nohide



nosubmit=0



loop,parse,commands,`,



{



command:=trim(a_loopfield)



if(!command)



continue



if(val:=commandArr[command]){



run,% val



if command in YCH,YXR,CXR,brus,mamm



{



process,close,Hotstring Helper.exe



loop,% root "\scripts\Radiology\Hotstring Helper\*.ahk"



if !instr(a_loopfilename,"Hotstring")



filedelete,% a_loopfilelongpath



RegExMatch(val,"is)Autohotkey.exe (.+)",match)



fileappend,% joinScript(match1),% root "\scripts\Radiology\Hotstring Helper\" regexreplace(match1,"s).+(\\|\/)",""),utf-8



run % root "\scripts\Radiology\Hotstring Helper\Hotstring Helper.exe"



if command=mamm



run % root "\scripts\Autohotkey\AutoHotkey.exe " root "\scripts\Radiology\mammoMagMove.ahk"



else if command=brus



run % root "\scripts\Autohotkey\AutoHotkey.exe " root "\scripts\Radiology\breastUS.ahk"



}



}else if (command="rad"){



loop {



process,close,Menu.exe



} until !errorlevel



work()



}else if (command="rad1"){



loop {



process,close,Menu.exe



} until !errorlevel



work(1)



}else if (command="slp"){



gosub run_slp



settimer,run_slp,3000



}else if (command="boneage"){



run,% root "\scripts\bone_age\boneage report.exe"



IfWinNotExist,Skeletal Development of the Hand and Wrist - A Radiographic Atlas and Digital Bone Age Companion



run,% root "\R2\PED\Skeletal Development of the Hand and Wrist - A Radiographic Atlas and Digital Bone Age Companion.pdf"



}else{



run % command



}



}



guicontrol,,commands,% ""



return



work(para=0){



global



nosubmit=1



commands:="ych"



settimer,parse_commands,-1



gosub run_slp



settimer,run_slp,3000



alternativeLogin:=!!para



settimer,~^!l,-500



}



#ifwinactive,Enter command



exe:



~NumpadEnter::



~Enter::



gosub parse_commands



guicontrol,focus,commands



return



~esc::



guicontrol,,commands,% ""



return



#IfWinActive



#ifwinactive,臨床報告



~esc::



WinGetClass,winClass,A



if !instr(winClass,"WindowsForms10.Window.8.app")



return



send !{F4}



winactivate,% "ahk_id " risState[2]



return



#IfWinActive



~rbutton::



if !(a_thishotkey=a_priorhotkey && A_TimeSincePriorHotkey<300 && GetKeyState("RButton","P")) {



return



}



mousemove,-1,-1,0,R



mousegetpos,,,activeWin



wingetTitle,activeWinTitle,% "ahk_id " activeWin



keywait,rbutton



if (instr(activeWinTitle,"放射線資訊管理系統(Radiology Information System)") || instr(activeWinTitle,"DisplayMenuForm")) {



mouseclick,l,-2,-2,1,0,,r



mouseclick,r,2,2,1,0,,r



sleep 100



mouseclick,l,5,5,1,0,,r



}



return



#ifwinactive,ahk_class #32770



~esc::



winclose,A



return



#ifwinactive



~esc::



UnhookWindowsHookEx(hHookMouse)



return



#ifwinactive,ahk_class WindowsForms10.Window.8.app.0.2bf8098



capslock::



if RisState[1]!=2



return



winactivate,% "ahk_id " risstate[2]



focused:=getFocused()



risReports:=getRisReports(risstate[2])



if (focused!=risReports[1,1] && focused!=risReports[1,2])



controlfocus,,% "ahk_id " risReports[1,1]



return



F3::



send {F3}



sleep 100



send h



return



F6::



send {f6}



sleep 100



send h



return



~lbutton up::



UnhookWindowsHookEx(hHookMouse)



,SystemCursor("On")



settimer,hidecursor,off



return



~lbutton::



mousegetpos,,,,mouseControl



KeyWait, LButton, T0.1



if (errorlevel && regexmatch(mouseControl,"AfxWnd90u\d")) {



hHookMouse := SetWindowsHookEx(WH_MOUSE_LL   := 14, RegisterCallback("MouseHook", "Fast"))



} else {



UnhookWindowsHookEx(hHookMouse)



,SystemCursor("On")



settimer,hideCursor,off



}



return



MouseHook(nCode, wParam, lParam){



static lx,ly



global hHookMouse



Critical



if (wParam=0x202){



UnhookWindowsHookEx(hHookMouse)



return CallNextHookEx(nCode, wParam, lParam)



}



If nCode || !(wParam = 0x200)



return CallNextHookEx(nCode, wParam, lParam)



VarSetCapacity(lpPoint,8)



DllCall("GetCursorPos", "Uint", &lpPoint)



lx := NumGet(lpPoint, 0, "Int")



ly := NumGet(lpPoint, 4, "Int")



mx := NumGet(lParam+0, 0, "Int")



my := NumGet(lParam+0, 4, "Int")



mx := lx + (mx-lx)



my := ly + (mx-lx) + (my-ly)



DllCall("SetCursorPos", "Int", mx, "Int", my)



NumPut(mx, lParam+0, 0, "Int")



NumPut(my, lParam+0, 4, "Int")



return 1



}



ClipCursor( Confine=True, x1=0 , y1=0, x2=1, y2=1 ) {



VarSetCapacity(R,16,0),  NumPut(x1,&R+0),NumPut(y1,&R+4),NumPut(x2,&R+8),NumPut(y2,&R+12)



Return Confine ? DllCall( "ClipCursor", UInt,&R ) : DllCall( "ClipCursor" )



}



SetWindowsHookEx(idHook, pfn)



{



Return DllCall("SetWindowsHookEx", "int", idHook, "Uint", pfn, "Uint", DllCall("GetModuleHandle", "Uint", 0), "Uint", 0)



}



CallNextHookEx(nCode, wParam, lParam, hHook = 0)



{



Return DllCall("CallNextHookEx", "Uint", hHook, "int", nCode, "Uint", wParam, "Uint", lParam)



}



UnhookWindowsHookEx(hHook)



{



Return DllCall("UnhookWindowsHookEx", "Uint", hHook)



}



mouseGesture:



if (abs(gestureY2-gestureY1)+abs(gestureX2-gestureX1)<20) {



gestureValue:=0



return



}



if (gestureX2=gestureX1) {



gestureValue:=(gestureY2>gestureY1)?4:8



}else if (gestureX2>gestureX1){



if (slope:=(gestureY2-gestureY1)/(gestureX2-gestureX1))>2.414



gestureValue:=4



else if slope>0.414



gestureValue:=3



else if slope>-0.414



gestureValue:=2



else if slope>-2.414



gestureValue:=1



else



gestureValue:=8



}else if (gestureX2<gestureX1){



if (slope:=(gestureY2-gestureY1)/(gestureX2-gestureX1))>2.414



gestureValue:=8



else if slope>0.414



gestureValue:=7



else if slope>-0.414



gestureValue:=6



else if slope>-2.414



gestureValue:=5



else



gestureValue:=4



}



if gesturevalue=2



send {right}



else if gesturevalue=6



send {left}



else if gesturevalue=8



send {up}



else if gesturevalue=4



send {down}



return



mbutton::



mousegetpos,gestureX1,gestureY1,mouseWin



WinGetClass,mouseWinClass,ahk_id %mouseWin%



winactivate,ahk_id %mouseWin%return



mbutton up::



mousegetpos,gestureX2,gestureY2



gosub mouseGesture



if (Impax:=ImpaxState)[1]!=2



return



if (!gestureValue)



for k,v in impaxControls:=getControls(Impax[2,1])



if (v.text="BMP_CURSOR_MODE_NEW" && instr(v.classNN,"WindowsForms10.BUTTON.app")){



controlclick,,% "ahk_id " v.hwnd



return



}



gestureValue:=0



return



`::



toggleImageText:



if (Impax:=ImpaxState)[1]!=2



return



if(Impax[2,5]=2){



if(Impax[2,4]=1){



for k,v in (impaxControls:=getcontrols(Impax[2,1])){



if (v.text="文字" || v.text="Text" || v.text="影像" || v.text="Image") && instr(v.ClassNN,"WindowsForms10.BUTTON") {



controlclick,,% "ahk_id " v.hwnd



return



}



}



}else if(Impax[2,4]=3){



winactivate,% "ahk_id " Impax[2,1]



}



}else if(Impax[2,5]=1){



for k,v in (impaxControls:=getcontrols(Impax[2,1])){



if (v.text="文字" || v.text="Text" || v.text="影像" || v.text="Image") && instr(v.ClassNN,"WindowsForms10.BUTTON") {



controlclick,,% "ahk_id " v.hwnd



return



}



}



}



return



~!2::



winwait,ahk_class #32770,Screen_0_format,2



winmove,ahk_class #32770,Screen_0_format,% 0,% 0



mousemove,-99999,-99999,0,R



wingetpos,x,y,,,ahk_class #32770,Screen_0_format



mousemove,% x+550, % y+550,0



return



tab::



if (Impax:=ImpaxState)[1]!=2 && Impax[2,4]!=1



return



for k,v in (impaxControls:=getcontrols(Impax[2,1])){



if v.text="BMP_VIRTUAL_SCREEN_BUTTON" && instr(v.ClassNN,"WindowsForms10.BUTTON") {



controlclick,,% "ahk_id " v.hwnd



}



}



winactivate,% "ahk_id " ImpaxState[2,1]



return



~rbutton::



if !(a_thishotkey=a_priorhotkey && A_TimeSincePriorHotkey<300 && GetKeyState("RButton","P")) {



return



}



sleep 100



mousemove,10,10,0,r



mousegetpos,,,menuHwnd



controlgetpos,,,w,h,,ahk_id %menuHwnd%



mouseclick,l,% w/2-10,% (h/9)*3,1,0,,R



return



~numpadenter::



~enter::



if (Impax:=ImpaxState)[1]!=2 && Impax[2,4]!=2



return



selectChartNo:



for k,v in (impaxControls:=getcontrols(id2:=Impax[2,2]|Impax[2,3])){



if k<2



continue



if instr(v.classNN,"WindowsForms10.EDIT.app") && ((impaxControls[k-1].text="病歷號碼" ) || (impaxControls[k-1].text="Patient ID")) {



controlfocus,,% "ahk_id " impaxChartnoControl:=v.hwnd



controlget,selectedText,Selected,,,% "ahk_id " impaxChartnoControl



if !selectedText



ControlClick,,% "ahk_id " impaxChartnoControl,,l,1



break



}



}



return



f1::



if (Impax:=ImpaxState)[1]!=2



return



bar:=ImpaxBar(id2:=Impax[2,2]|Impax[2,3])



if(Impax[2,5]=2){



if(Impax[2,4]=1){



winactivate,ahk_id %id2%



wingetpos,,,,h,ahk_id %id2%



if !(bar.h>h-37)



controlclick,,% "ahk_id " bar.hwnd



}else if(Impax[2,4]=3){



wingetpos,,,,h,ahk_id %id2%



if !(bar.h>h-37)



controlclick,,% "ahk_id " bar.hwnd



}else if(Impax[2,4]=2){



winactivate,% "ahk_id " Impax[2,1]



}



}else if(Impax[2,5]=1){



if(Impax[2,4]=2){



controlclick,,% "ahk_id " bar.hwnd,,,,% "x" a_screenwidth/2 " y5"



loop {



sleep 200



if(ImpaxState[2,4]=1){



break



}else if(ImpaxState[2,4]=3){



for k,v in (impaxControls:=getcontrols(ImpaxState[2,2]|ImpaxState[2,3])){



if (v.text="影像" || v.text="Image") && instr(v.ClassNN,"WindowsForms10.BUTTON") {



controlclick,,% "ahk_id " v.hwnd



break



}



}



}



}



}else if(Impax[2,4]=1||Impax[2,4]=3){



controlclick,,% "ahk_id " bar.hwnd



}



}



if (Impax[2,4]!=2) {



gosub selectChartNo



}



return



backToList:



return



gosub selectChartNo



return



#ifwinactive



slp_login:



ifwinnotexist,SleipnirLogin ahk_class AutoHotkeyGUI



{



settimer,slp_login,-500



return



}



controlsettext,Edit1,loginId,SleipnirLogin ahk_class AutoHotkeyGUI



controlsettext,Edit2,loginPw,SleipnirLogin ahk_class AutoHotkeyGUI



controlclick,Button1,SleipnirLogin ahk_class AutoHotkeyGUI



return



run_slp:



ifwinnotexist,ahk_class SleipnirMainWindow



{



if fileexist(path:=a_mydocuments "\scsnake\Sleipnir\SleipnirLogin.exe") {



ifwinnotexist,ahk_exe SleipnirLogin.exe



run % path



sleep 200



gosub slp_login



settimer,run_slp,off



}else{



run,% root "\software\Sleipnir\Sleipnir.exe"



}



}



else {



settimer,run_slp,off



settimer,slp_login,off



settimer,renewsid,300000



}



return



renewSid:



SlpWb:=getSlpWb()



SlpSid:=[]



for k,v in SlpWb



if regexmatch(v.document.body.innerHTML,"i)SESSION=(\w{32})",match)



isobject(SlpSid["" match1])?(SlpSid["" match1].push(k)):(SlpSid["" match1]:=array(k))



for k,v in SlpSid



if !checksid(k)



for x,y in v



renewSlpUrl(SlbWb[y],sid:=login(newusername,newpassword))



return



renewSlpUrl(wb,sid){



if regexmatch(href:=wb.LocationUrl,"i)SESSION=\w{32}")



wb.Navigate(RegExReplace(href,"i)SESSION=\w{32}","SESSION=" sid))



else if regexmatch(href,"is)/[^/\?]+(\?)?$",match)



wb.Navigate(href (match1=""?"?":"") "SESSION=" sid)



else if regexmatch(href,"is)/[^/&\?]+\?[^/\?]+(&?)$",match)



wb.Navigate(href . (match1=""?"&":"") . "SESSION=" sid)



}



getSlpWb(){



arr:=[]



winget,SlpControlList,ControlListHwnd,ahk_class SleipnirMainWindow



loop,parse,SlpControlList,`n



{



WinGetClass,controlClass,ahk_id %a_loopfield%



if(controlClass!="Internet Explorer_Server")



continue



static msg := DllCall("RegisterWindowMessage", "str", "WM_HTML_GETOBJECT")



, IID := "{0002DF05-0000-0000-C000-000000000046}"



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



GUIClose:



WinMinimize,ahk_id %guiHWND%



return



close_RIS:



if RisState[1]!=2



return



wingettitle,RisTitle,% "ahk_id " RisState[2]



if !instr(RisTitle,RisName)



return



winclose,% "ahk_id " RisState[2]



settimer,RisCloseConfirm,500



return



RisCloseConfirm:



if (RisState[1]!=2){



settimer,RisCloseConfirm,off



return



}



ifwinexist,Menu ahk_class #32770,是否確定要離開放射線資訊管理(RIS)系統?



controlclick,Button1



else



settimer,RisCloseConfirm,off



return



close_impax:



if (Impax:=ImpaxState)[1]!=2



return



for k,v in ImpaxControls:=getControls(Impax[2,2]|Impax[2,3])



if ((v.text="登出" || v.text="Logout") && instr(v.classNN,"WindowsForms10.BUTTON.app") && instr(ImpaxControls[k-1].classNN,"WindowsForms10.STATIC.app") && ImpaxControls[k-1].text!=impax_id){



controlclick,,% "ahk_id " v.hwnd



return



}



winclose,% "ahk_id " ImpaxState[2,2]|ImpaxState[2,3]



return



close_SLP:



winget,slpList,list,ahk_class SleipnirMainWindow



closingSlp:=0



settimer,closeSLPconfirm,500



loop % slpList {



winget,slpPath,processpath,% "ahk_id " slpList%a_index%



if instr(slpPath,root)!=1



continue



winclose,% "ahk_id " closingSlp:=slpList%a_index%



break



}



return



closeSLPconfirm:



ifwinexist,Sleipnir ahk_class #32770



controlClick,Button1



if closingSlp && !winexist("ahk_id " closingSlp)



settimer,closeSLPconfirm,off



return



closeSCITE:



winget,sciteList,list,SciTE4AutoHotkey



loop % sciteList {



winget,scitePath,processpath,% "ahk_id " sciteList%a_index%



if instr(scitePath,root)!=1



continue



winclose,% "ahk_id " sciteList%a_index%



}



return



NumLock::



send {bs}



return



!a::



IfWinNotActive,ahk_id %guiHWND%



{



winshow,ahk_id %guiHWND%



winactivate,ahk_id %guiHWND%



}



else



winhide,ahk_id %guiHWND%



if(!hiddenWindows[0]){



winget,fbWin,list,Facebook



loop % fbWin



{



hiddenWindows[a_index]:=fbWin%a_index%



winhide,% "ahk_id " fbWin%a_index%



}



hiddenWindows[0]:=1



}else {



hiddenWindows[0]:=0



while (hwnd:=hiddenWindows.pop())



winshow,% "ahk_id " hwnd



}



return



~!p::



regread,proxy_state,HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyEnable



if !proxy_state



{



RegWrite,reg_dword,HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyEnable,1



RegWrite,reg_sz,HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyServer,proxy.hospital-n.local:3128



RegWrite,reg_sz,HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyOverride,<local>



tooltip,N Hospital Proxy On



}



else



{



RegWrite,reg_dword,HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyEnable,0



tooltip,Proxy Off



}



settimer,tooltip,-5000



return



tooltip:



tooltip



return



^!d::



clipboard=



send ^c



clipwait,1



fileappend,% """" clipboard """`n",words.csv,utf-8



return



#ifwinexist,放射線資訊管理系統(Radiology Information System)



^#tab::



keywait,LWIN,1



keywait,RWIN,1



keywait,tab,1



keywait,ctrl,1



if errorlevel



return



sleep 100



clipboard=



send ^c



clipwait,1



if !regexmatch(clipboard,"(t|T)\d{10}",match) && !regexmatch(clipboard,"\w\d{6}",match)



return



clipboard:=match



winactivate,% "ahk_id " RisState[2]



searchRisChartNo(RisState[2],match)



return



#ifwinexist



mbutton::



mousegetpos,gestureX1,gestureY1,mouseWin



WinGetClass,mouseWinClass,ahk_id %mouseWin%



winactivate,ahk_id %mouseWin%



return



mbutton up::



if (!gestureValue)



send {mbutton}



return



#ifwinexist,ahk_class WindowsForms10.Window.8.app.0.2bf8098



~wheeldown::



~wheelup::



if impaxState[1]!=2



return



mousegetpos,,,mouseWin



WinGetClass,mouseWinClass,ahk_id %mouseWin%



if(mouseWinClass="WindowsForms10.Window.8.app.0.2bf8098")



winactivate,% "ahk_id " (impaxState[2,4]>1?(impaxState[2,2]|impaxState[2,3]):impaxState[2,1])



return



^!tab::



if (Impax:=ImpaxState)[1]!=2



return



ifwinactive,UniReport ahk_class TMainForm



{



wingettitle,str,UniReport ahk_class TMainForm



clipboard:=str



}else{



keywait,alt,1



keywait,tab,1



keywait,ctrl,1



if errorlevel



return



sleep 100



clipboard=



send ^c



clipwait,1



}



^!tab1:



if !regexmatch(clipboard,"\w\d{6}",match)



return



chartNo:=match



winactivate,% "ahk_id " id2:=Impax[2,2]|Impax[2,3]



bar:=ImpaxBar(id2)



wingetpos,,,,h,ahk_id %id2%



if !(bar.h>h-37)



controlclick,,% "ahk_id " bar.hwnd



gosub selectChartNo



acc_objectfromwindow(impaxChartnoControl).accValue:=chartNo



controlsend,,{enter},% "ahk_id " impaxChartnoControl



return



#ifwinexist



~!e::



while(x:=winexist("Microsoft Internet Explorer"))



winkill,ahk_id %x%



return



^!q::



if !(a_priorhotkey=a_thishotkey && A_TimeSincePriorHotkey<300)



return



winclose,autorun.exe,Quit?



settimer,close_RIS,-1



settimer,close_impax,-500



closeSLPind:=0



settimer,close_SLP,-1



process,close,XLiu.exe



settimer,closeUSBprocess,-1



return



closeUSBprocess:



winget,pList,list



loop % pList {



winget,pPath,processpath,% "ahk_id " pList%a_index%



if (instr(pPath,root)=1 && a_scripthwnd!=pList%a_index% )



winclose,% "ahk_id " pList%a_index%



}



p:=listProcess()[1]



loop,parse,p,|



{



if instr(GetModuleFileNameEx(a_loopfield),root)



process,close,% a_loopfield



}



return



terminateUSBprocess:



msgbox,1,,Sure?



ifmsgbox,Cancel



return



gosub closeUSBprocess



winget,pList,list



loop % pList {



winget,pPath,processpath,% "ahk_id " pList%a_index%



if (instr(pPath,root)=1 && a_scripthwnd!=pList%a_index% && guiHwnd!=pList%a_index%){



winget,pid,pid,% "ahk_id " pList%a_index%



process,close,% pid



}



}



gosub unmountUSB



return



unmountUSB:



filecopy,% root "\scripts\Autorun\RemoveDrive\Win32\RemoveDrive.exe",% a_mydocuments,1



run,% a_mydocuments "\RemoveDrive.exe " root " -L -w:3000 -s -h -a",% a_mydocuments



exitapp



return



unmountUSBold:



if (a_osversion!="WIN_XP")



exitapp



FileCopy,% root "\deveject.exe",% A_MyDocuments,1



FileAppend,% "`n@echo off`n:L1`nIF EXIST " root " (`ndeveject.exe -EjectDrive:" root "`nping 1.1.1.1 -n 1 -w 2000`ngoto L1 ) ELSE (`ndel deveject.exe`ndel unmount.cmd )",% A_MyDocuments "\unmount.cmd",utf-8



run,% A_MyDocuments "\unmount.cmd",% A_MyDocuments



exitapp



return



~^!l::



critical



risLoging:=0,waiting:=0



if(!alternativeLogin){



RIS_id:=loginId



RIS_pw:=loginPw



}else{



RIS_id:="YCH1"



RIS_pw:="YCH1"



settimer,login_IMPAX,-1



}



settimer,login_RIS,-100



settimer,maximizeImpax,2000



alternativeLogin:=0



return



~^!i::



settimer,login_impax,-1



return



sig1:



sig1:=(Impax:=ImpaxOpened())[1]=1 && i++<60



return



login_impax:



if (Impax:=ImpaxState)[1]=2



return



if(Impax[1]=0){



settimer,restartImpax,300



run,% A_ProgramFiles "\Agfa\IMPAX Client\AppStart.exe"



loop



sleep % 200



until (ImpaxOpened()[1]||a_index>300)



}



loginText:=GetControlIdByText(controls,"登入")?"登入":"Login"



gosub login_impax2



settimer,login_impax2,2000



return



login_impax2:



if((Impax:=ImpaxOpened())[1]=1 && i++<60){



for k,v in controls:=GetControls(impaxHwnd:=Impax[2,1])



if (v.classNN="WindowsForms10.EDIT.app.0.2bf80982") {



controlsettext,,%IMPAX_id%,% "ahk_id " v.hwnd



break



}



for k,v in controls



if (v.classNN="WindowsForms10.EDIT.app.0.2bf80981") {



controlsettext,,%IMPAX_pw%,% "ahk_id " v.hwnd



break



}



for k,v in controls



if (v.classNN="WindowsForms10.BUTTON.app.0.2bf80981") {



controlfocus,,% "ahk_id " v.hwnd



controlsend,,{enter},% "ahk_id " v.hwnd



break



}



}else{



return



}



settimer,restartImpax,off



settimer,login_impax2,off



gosub maximizeImpax



settimer,maximizeImpax,2000



return



maximizeImpax:



WinGet,minmaxImpax,minmax,% "ahk_id " ImpaxState[2,3]



if (minmaxImpax=1)



settimer,maximizeImpax,off



else



WinMaximize,% "ahk_id " ImpaxState[2,3]



return



restartImpax:



if restartImpaxId:=winexist("重新啟動 ahk_class WindowsForms10.Window.8.app.0.2bf8098")



controlclick,WindowsForms10.BUTTON.app.0.2bf80982,ahk_id %restartImpaxId%



return



login_RIS:



if(!waiting){



if(risopened()[1]=0){



loop {



process,close,Menu.exe



} until !errorlevel



}



settimer,closeRisError,500



RisLoginAttempt:=0



if(risopened()[1]=2){



return



}



if(risopened()[1]=0 && !risLoging){



RISpath:=getrispath()



run,% RISpath,% RegExReplace(RISpath,"\\Menu\.exe$")



risLoging:=1



waiting:=1



settimer,login_RIS,-500



}



}else{



if(++waiting>120){



return



}



if(risopened()[1]=1){



waiting:=0



RISarr:=getControls(risid:=risopened()[2])



,RisIdHwnd:=GetControlIdByText(RISarr,"Password",-1)



winactivate,% "ahk_id " risId



winwaitactive,% "ahk_id " risId,,3



controlfocus,,ahk_id %RisIdHwnd%



send % ris_id



send {tab}



send % ris_pw



send {enter}



settimer,RisSetDefaultSearch,2000



}else{



settimer,login_RIS,-500



}



}



return



RisSetDefaultSearch:



if (RisState[1]=2){



settimer,closeRisError,off



control,choosestring,所有撰打住院醫師,,% "ahk_id " getNetControl2(RisState[2],"撰打住院醫師","FID_LABEL","撰打住院醫師","WindowsForms10.STATIC.app","","","",1)[1]



controlfocus,,% "ahk_id " getNetControl2(RisState[2],"報告醫師","FID_LABEL","報告醫師","WindowsForms10.STATIC.app","","","",1)[1]



settimer,RisSetDefaultSearch,off



}



return



closeRisError:



IfWinExist,Menu ahk_class #32770,查無使用者



{



controlclick,Button1



if (++RisLoginAttempt)>10 {



settimer,closeRisError,off



settimer,RisSetDefaultSearch,off



RisLoginAttempt:=0



}



}



ifwinexist,Menu ahk_class #32770,查無



controlclick,Button1



return



~!q::



winactivate,ahk_exe autorun.exe,Quit?



msgbox,1,,Quit?



ifmsgbox,cancel



return



ExitApp



return



showCursor:



settimer,hideCursor,off



SystemCursor("On")



return



hideCursor:



SystemCursor("Off")



return



onexit:



settimer,showCursor,-1



UnhookWindowsHookEx(hHookMouse)



RegWrite,reg_dword,HKEY_CURRENT_USER,Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyEnable,0



while hwnd:=hiddenWindows.pop()



winshow,% "ahk_id " hwnd



ExitApp



return



relativeDate(theDay,relative=-1){



Formattime,d,% theDay,yyyyMMddHHmmss



d+=%relative%,d



return d



}



~^k::



if (RisState[1]!=2 || winactive("ahk_exe impax-client-main.exe"))



return



send ^c



RisReports:=getRisReports(RisState[2])



paste:=""



loop,parse,clipboard,`n`r



if (trim(a_loopfield)!="")



paste.=RegExReplace(trim(a_loopfield),"[\W\s]+$","") "; "



if (oldText:=controlgettext(RisReports[1,1]))=""



Controlsettext,,% "History: " paste,% "ahk_id " RisReports[1,1]



else



ControlSetText,,% oldText paste,% "ahk_id " RisReports[1,1]



Edit_SetSel(RisReports[1,1],strlen(sentText),strlen(sentText))



return



#ifwinactive,放射線資訊管理系統(Radiology Information System)



^y::



send {home}+{end}{del}{del}



return



`::



send ^+{left}{bs}



return



^i::



imageNumber:=getSEIM(ImpaxState)



if (imageNumber[1]!="")



send % "SE" imageNumber[1] " IM" imageNumber[2]



return



~^r::



if(RisState[1]!=2)



return



control,choosestring,所有類別,,% "ahk_id " getNetControl2(RisState[2],"檢查類別","FID_LABEL","檢查類別","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,未發送,,% "ahk_id " getNetControl2(RisState[2],"狀態","FID_LABEL","狀態","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,所有診別,,% "ahk_id " getNetControl2(RisState[2],"診別","FID_LABEL","診別","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,所有報告醫師,,% "ahk_id " getNetControl2(RisState[2],"報告醫師","FID_LABEL","報告醫師","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,所有撰打住院醫師,,% "ahk_id " getNetControl2(RisState[2],"撰打住院醫師","FID_LABEL","撰打住院醫師","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,所有執行住院醫師,,% "ahk_id " getNetControl2(RisState[2],"執行住院醫師","FID_LABEL","執行住院醫師","WindowsForms10.STATIC.app","","","",1)[1]



controlsettext,,% "",% "ahk_id " getNetControl2(RisState[2],"病歷號","FID_LABEL","病歷號","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,% "所有檢查地",,% "ahk_id " (test:=getNetControl2(RisState[2],"檢查地","FID_LABEL","檢查地","WindowsForms10.STATIC.app","","","",1))[1]



return



~^n::



if(RisState[1]!=2)



return



control,choosestring,所有報告醫師,,% "ahk_id " getNetControl2(RisState[2],"報告醫師","FID_LABEL","報告醫師","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,所有撰打住院醫師,,% "ahk_id " getNetControl2(RisState[2],"撰打住院醫師","FID_LABEL","撰打住院醫師","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,所有執行住院醫師,,% "ahk_id " getNetControl2(RisState[2],"執行住院醫師","FID_LABEL","執行住院醫師","WindowsForms10.STATIC.app","","","",1)[1]



controlsettext,,% "",% "ahk_id " getNetControl2(RisState[2],"病歷號","FID_LABEL","病歷號","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,CT,,% "ahk_id " getNetControl2(RisState[2],"檢查類別","FID_LABEL","檢查類別","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,未發送,,% "ahk_id " getNetControl2(RisState[2],"狀態","FID_LABEL","狀態","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,急診,,% "ahk_id " getNetControl2(RisState[2],"診別","FID_LABEL","診別","WindowsForms10.STATIC.app","","","",1)[1]



control,choosestring,N總院,,% "ahk_id " getNetControl2(RisState[2],"檢查地","FID_LABEL","檢查地","WindowsForms10.STATIC.app","","","",1)[1]



return



~^f::



if (RisState[1]=2){



if (reportDrHwnd:=getNetControl2(RisState[2],"報告醫師","FID_LABEL","報告醫師","WindowsForms10.STATIC.app","","","",1)[1]) {



inputbox,reportDrInput,報告VS,,,150,120



if !errorlevel



control,choosestring,% trim(reportDrInput)=""?"所有報告醫師":trim(reportDrInput),,% "ahk_id " reportDrHwnd



}



}



return



~^g::



if (RisState[1]=2){



if (reportDrHwnd:=getNetControl2(RisState[2],"撰打住院醫師","FID_LABEL","撰打住院醫師","WindowsForms10.STATIC.app","","","",1)[1]) {



inputbox,reportDrInput,撰打R,,,150,120



if !errorlevel



control,choosestring,% trim(reportDrInput)=""?"所有撰打住院醫師":trim(reportDrInput),,% "ahk_id " reportDrHwnd



}



}



return



~^h::



if (RisState[1]=2){



if (reportDrHwnd:=getNetControl2(RisState[2],"執行住院醫師","FID_LABEL","執行住院醫師","WindowsForms10.STATIC.app","","","",1)[1]) {



inputbox,reportDrInput,執行R,,,150,120



if !errorlevel



control,choosestring,% trim(reportDrInput)=""?"所有執行住院醫師":trim(reportDrInput),,% "ahk_id " reportDrHwnd



}



}



return



AppsKey::



tmp:=clipboardall



send ^+{left}^c



regexmatch(clipboard,"is)(.+?)(\W*)$",match)



send {bs}%match1%



clipboard:=tmp



return



^numpadenter::



^Enter::



controlclick,,% "ahk_id " getNetControl2(RisState[2],"","cmdSearch","","WindowsForms10.BUTTON.app","","","",0)[1]



return



#IfWinActive



!#ctrl::



ifwinactive,UniReport ahk_class TMainForm



{



wingettitle,str,UniReport ahk_class TMainForm



clipboard:=str



}else{



keywait,alt,1



keywait,lwin,1



keywait,rwin,1



keywait,ctrl,1



if errorlevel



return



sleep 100



clipboard=



send ^c



clipwait,1



}



slpwb:=getSlpWb()



if (slpWb.maxIndex())



settimer,!#tab1,-100



if (Impax:=ImpaxState)[1]=2



settimer,^!tab1,-200



return



!#tab::



slpwb:=getSlpWb()



if !slpWb.maxIndex()



return



keywait,alt,1



keywait,tab,1



keywait,shift,1



if errorlevel



return



sleep 100



clipboard=



send ^c



clipwait,1



!#tab1:



if !regexmatch(clipboard,"\w\d{6}",match) {



return



}



chartNo:=match



for k,v in slpWb {



if instr(v.LocationUrl,"WebApplication/OtherIndependentProj/PatientBasicInfoEdit/PatientMedicalRecordListQuery.aspx") {



loop % (inputs:=v.document.getElementsByTagName("INPUT")).length {



if (inputs[a_index-1].name="NWeb1$PatientBasicInfoQueryByIDAndName1$ctl01"){



inputs[a_index-1].value:=match



break



}



}



loop % (inputs:=v.document.getElementsByTagName("INPUT")).length {



if (inputs[a_index-1].name="NWeb1$PatientBasicInfoQueryByIDAndName1$ctl05"){



inputs[a_index-1].click()



break



}



}



Loop



sleep 200



until !v.busy



v.document.getElementById("NWeb1_PatAccountListRecord1_ButtonWebEMR").click()



break



}



}



winactivate,ahk_class SleipnirMainWindow



return



checkExam:



if RisState[1]!=2



return



for k,v in risControls:=getcontrols(risstate[2]) {



if (instr(v.text,"下筆") && instr(v.classNN,"WindowsForms10.BUTTON")) {



temp:=k



break



}



}



for k,v in risControls {



if (v.text="Exam." && instr(risControls[k+1]["classNN"],"WindowsForms10.EDIT.app") && abs(k-temp)<13) {



controlgettext,examText,,% "ahk_id " risControls[k+1]["hwnd"]



break



}



}



examTextTransform(examText)



return



examTextTransform(str){



t:="",numbering:=false,ind:=0,



loop,parse,str,`n,`r



{



if(regexmatch(a_loopfield,"is)^(\d)[^\d\w]?\s*?(.*)",m)){



}



}



}



^!t::



ifwinexist,Convert first word



return



gui, 2: +lastfound



gui2hwnd:=winexist()



gui, 2: font,s10,Verdana



gui, 2: add,edit,w800 h600 vreport hwndreportEditHwnd



gui, 2: add,edit,r1 w20 vfirstword,1



gui, 2: add,button,x+5 yp gConvertFirstWord,Convert



gui, 2: add,button,x+5 yp gCopyPaste,% "Copy && Paste"



gui, 2: show,w850 h650,Convert first word



return



CopyPaste:



clipboard:=""



controlgettext,clipboard,,% "ahk_id " reportEditHwnd



clipwait,1



winactivate,% "ahk_id " RisState[2]



winwaitactive,% "ahk_id " RisState[2],,1



send ^v



return



ConvertFirstWord:



gui, 2: submit,NoHide



firstword:=trim(firstword)



if !regexmatch(firstword,"\d+")



{



report:=regexreplace(report,"\n\d+.\s*","`n" firstword " ")



}else{



ind:=0



while ind:=regexmatch(report,"\n[^\s\w\(\[]+(.|\)|\s+)\s*",match,ind+1)



{



report:=regexreplace(report,match,"`n" a_index ". ","",1,ind)



}



}



guicontrol, 2: ,report,% report



guicontrol, 2: focus,report



sendmessage,0xB1,0,-1,, ahk_id %reportEditHwnd%



return



2GUIClose:



gui, 2: destroy



return



#ifwinactive,Convert first word



~esc::



gui, 2: destroy



return



#ifwinactive



:*:pxy1::proxy.hospital-n.local{tab}3128



:*:a;::



input,code,i L2 T1 V *



if(code+0!=a_min+mod(a_hour,12)){



send a;



return



}



loop % strlen(code)



send {bs}



send {alt down}{numpad1}{numpad0}{numpad9}{alt up}{alt down}{numpad1}{numpad0}{numpad3}{alt up}{alt down}{numpad1}{numpad1}{numpad2}{alt up}{alt up}{alt down}{numpad1}{numpad1}{numpad5}{alt up}{alt up}{alt down}{numpad1}{numpad1}{numpad0}{alt up}{alt up}{alt down}{numpad1}{numpad2}{numpad2}{alt up}



return



::;rp::radiopaedia



::;rg::radiographics



::;ra::radiology assistant



::;lr::learning radiology



::;conct::Please send consult sheet and patient stickers to CT room for scheduling. Thanks.



::;conan::Please send consult sheet and patient stickers to angioroom for scheduling. Thanks.



::;cns::We were consulted for



::qov0::kenbo_14586298



:*:s2g::scsnake@gmail.com



:*:b2n::user@hospital-n.local



::scss::scsnake



:*:mdlb::medlib@hospital-n.local{tab}MOCK_PASSWORD{enter}



::ahkk::autohotkey



commandArr:



commandArr:=[]



commandArr["note"]:=root "\software\Notepad++\unicode\notepad++.exe"



commandArr["scite"]:=root "\scripts\Autohotkey\SciTE\SciTE.exe"



commandArr["script"]:=root "\scripts\"



commandArr["lib"]:=root "\scripts\Autohotkey\Lib\"



commandArr["word"]:=(fileexist(path:=a_mydocuments "\Office 2010 Portable\WINWORD.EXE")?path:root "\software\Office 2010 Portable\WINWORD.EXE")



commandArr["access"]:=(fileexist(path:=a_mydocuments "\Office 2010 Portable\MSACCESS.EXE")?path:root "\software\Office 2010 Portable\MSACCESS.EXE")



commandArr["excel"]:=(fileexist(path:=a_mydocuments "\Office 2010 Portable\EXCEL.EXE")?path:root "\software\Office 2010 Portable\EXCEL.EXE")



commandArr["ppt"]:=(fileexist(path:=a_mydocuments "\Office 2010 Portable\POWERPNT.EXE")?path:root "\software\Office 2010 Portable\POWERPNT.EXE")



commandArr["office"]:=root "\software\Office 2010 Portable\"



commandArr["vfss"]:=root "\scripts\VFSS2\"



commandArr["chm"]:=root "\scripts\Autohotkey\AutoHotkey.chm"



commandArr["spy"]:=root "\scripts\Autohotkey\AU3_Spy.exe"



commandArr["seah"]:=root "\software\Sleipnir\plugins\seahorse\"



commandArr["seah1"]:=A_MyDocuments "\scsnake\Sleipnir\plugins\seahorse\"



commandArr["liu"]:=root "\software\XLiu\Xliu.exe"



commandArr["autorun"]:=root "\scripts\Autorun\"



commandArr["YCH"]:=root "\scripts\Autohotkey\AutoHotkey.exe " root "\scripts\Radiology\YCH.ahk"



commandArr["YCHm"]:=root "\scripts\Autohotkey\SciTE\SciTE.exe " root "\scripts\Radiology\YCH_main.ahk"



commandArr["YCHx"]:=root "\scripts\Autohotkey\SciTE\SciTE.exe " root "\scripts\Radiology\YCH_XR.ahk"



commandArr["YXR"]:=root "\scripts\Autohotkey\AutoHotkey.exe " root "\scripts\Radiology\YCH_XR.ahk"



commandArr["CXR"]:=root "\scripts\Autohotkey\AutoHotkey.exe " root "\-----------R3\chest\AutoHotkey_chest\Chest_CXJ.ahk"



commandArr["brus"]:=root "\scripts\Autohotkey\AutoHotkey.exe " root "\-----------R3\chest\AutoHotkey_chest\breast_CXJ.ahk"



commandArr["mamm"]:=root "\scripts\Autohotkey\AutoHotkey.exe " root "\-----------R3\chest\AutoHotkey_chest\CUCmammo.ahk"



commandArr["chrome"]:=root "\software\GoogleChromePortable\GoogleChromePortable.exe --proxy-server=proxy.hospital-n.local:3128"



commandArr["pcman"]:=root "\software\PCMan Combo\PCMan.exe"



commandArr["firefox"]:=root "\software\FirefoxPortable\FirefoxPortable.exe"



commandArr["msn"]:=root "\software\MSN 8.5\msnmsgr.exe"



commandArr["7z"]:=root "\software\7-Zip\"



commandArr["tshark"]:=root "\software\tshark\"



commandArr["server"]:=root "\software\TWAMPd\"



commandArr["cmd"]:=root "\software\PowerCmd\PowerCmd.exe"



commandArr["teamviewer"]:=root "\software\TeamViewerPortable\TeamViewer.exe"



commandArr["ugi"]:=root "\scripts\Autohotkey\AutoHotkey.exe " root "\scripts\Radiology\YCH-UGI.ahk"



commandArr["hct"]:=root "\scripts\Autohotkey\AutoHotkey.exe " root "\scripts\Radiology\YCH-HCT.ahk"



commandArr["info"]:=root "\scripts\AHK_Window_Info_v1.7.exe"



commandArr["nginx"]:=root "\software\WNMP\"



commandArr["diff"]:=root "\scripts\Radiology\diffReport.exe"



commandArr["case"]:=(fileexist(path:=a_mydocuments "\Office 2010 Portable\EXCEL.EXE")?path " ":root "\software\Office 2010 Portable\EXCEL.EXE ") """" root "\case list.xlsx"""



commandArr["pdf"]:=root "\software\PDF-XChange Viewer\PDFXCview.exe"



commandArr["ftp"]:=root "\software\FileZillaPortable\FileZillaPortable.exe"



commandArr["icon"]:=root "\scripts\IconChanger\IconChangerMain.exe"



commandArr["simple"]:=root "\scripts\Radiology\AntiImpaxFlash.exe"



commandArr["type"]:=root "\scripts\Radiology\RisTyper\RisTyper.exe"



commandArr["rfa"]:=root "\scripts\Radiology\RFA note.exe"



commandArr["nhi"]:=root "\scripts\Radiology\NHIform"



commandArr["radtem"]:=root "\scripts\Radiology\RadTemplate\RadTemplate.exe"



return



listProcess(){



d := "  |  "



s := 4096



Process, Exist



h := DllCall("OpenProcess", "UInt", 0x0400, "Int", false, "UInt", ErrorLevel, "Ptr")



DllCall("Advapi32.dll\OpenProcessToken", "Ptr", h, "UInt", 32, "PtrP", t)



VarSetCapacity(ti, 16, 0)



NumPut(1, ti, 0, "UInt")



DllCall("Advapi32.dll\LookupPrivilegeValue", "Ptr", 0, "Str", "SeDebugPrivilege", "Int64P", luid)



NumPut(luid, ti, 4, "Int64")



NumPut(2, ti, 12, "UInt")



r := DllCall("Advapi32.dll\AdjustTokenPrivileges", "Ptr", t, "Int", false, "Ptr", &ti, "UInt", 0, "Ptr", 0, "Ptr", 0)



DllCall("CloseHandle", "Ptr", t)



DllCall("CloseHandle", "Ptr", h)



hModule := DllCall("LoadLibrary", "Str", "Psapi.dll")



s := VarSetCapacity(a, s)



c := 0



DllCall("Psapi.dll\EnumProcesses", "Ptr", &a, "UInt", s, "UIntP", r)



Loop, % r // 4



{



id := NumGet(a, A_Index * 4, "UInt")



h := DllCall("OpenProcess", "UInt", 0x0010 | 0x0400, "Int", false, "UInt", id, "Ptr")



if !h



continue



VarSetCapacity(n, s, 0)



e := DllCall("Psapi.dll\GetModuleBaseName", "Ptr", h, "Ptr", 0, "Str", n, "UInt", A_IsUnicode ? s//2 : s)



if !e



if e := DllCall("Psapi.dll\GetProcessImageFileName", "Ptr", h, "Str", n, "UInt", A_IsUnicode ? s//2 : s)



SplitPath n, n



DllCall("CloseHandle", "Ptr", h)



if (n && e)



l .= n . d, c++



}



DllCall("FreeLibrary", "Ptr", hModule)



return array(l,c)



}



GetModuleFileNameEx( p_pid )



{



h_process := DllCall( "OpenProcess", "uint", 0x10|0x400, "int", false, "uint", p_pid )



if ( ErrorLevel or h_process = 0 )



return



name_size = 255



VarSetCapacity( name, name_size )



result := DllCall( "psapi.dll\GetModuleFileNameExA", "uint", h_process, "uint", 0, "str", name, "uint", name_size )



DllCall( "CloseHandle", h_process )



return, name



}



RisHistoryBreakline:



if risState[1]!=2



return



if (pSheetNo=(cSheetNo:=getRisSheetNo(RisState[2])))



return



pSheetNo:=cSheetNo



for breakLineControlKey,breakLineControlValue in breakLineControls



if breakLineControl:=getNetControl2(risState[2],"",breakLineControlValue,"","WindowsForms10.EDIT","","","",0)[1]



acc_objectfromwindow(breakLineControl).accValue:=RegExReplace(RegExReplace(controlgettext(breakLineControl),"\r|\n","€"),"€+","`r`n")



return



getFocused(){



static GuiThreadInfoSize = 48



VarSetCapacity(GuiThreadInfo, GuiThreadInfoSize)



NumPut(GuiThreadInfoSize, GuiThreadInfo, 0)



DllCall("GetGUIThreadInfo", uint, 0, str, GuiThreadInfo)



return FocusedHWND := NumGet(GuiThreadInfo, 12)



}



COM_Init(bUn = "")



{



Static	h



Return	(bUn&&!h:="")||h==""&&1==(h:=DllCall("ole32\OleInitialize","Uint",0))?DllCall("ole32\OleUninitialize"):0



}



COM_Term()



{



COM_Init(1)



}



COM_VTable(ppv, idx)



{



Return	NumGet(NumGet(1*ppv)+4*idx)



}



COM_QueryInterface(ppv, IID = "")



{



If	DllCall(NumGet(NumGet(1*ppv:=COM_Unwrap(ppv))), "Uint", ppv+0, "Uint", COM_GUID4String(IID,IID ? IID:IID=0 ? "{00000000-0000-0000-C000-000000000046}":"{00020400-0000-0000-C000-000000000046}"), "UintP", ppv:=0)=0



Return	ppv



}



COM_AddRef(ppv)



{



Return	DllCall(NumGet(NumGet(1*ppv:=COM_Unwrap(ppv))+4), "Uint", ppv)



}



COM_Release(ppv)



{



If Not	IsObject(ppv)



Return	DllCall(NumGet(NumGet(1*ppv)+8), "Uint", ppv)



Else



{



nRef:=	DllCall(NumGet(NumGet(COM_Unwrap(ppv))+8), "Uint", COM_Unwrap(ppv)), nRef==0 ? (ppv.prm_:=0):""



Return	nRef



}



}



COM_QueryService(ppv, SID, IID = "")



{



If	DllCall(NumGet(NumGet(1*ppv:=COM_Unwrap(ppv))), "Uint", ppv, "Uint", COM_GUID4String(IID_IServiceProvider,"{6D5140C1-7436-11CE-8034-00AA006009FA}"), "UintP", psp)=0



&&	DllCall(NumGet(NumGet(1*psp)+12), "Uint", psp, "Uint", COM_GUID4String(SID,SID), "Uint", IID ? COM_GUID4String(IID,IID):&SID, "UintP", ppv:=0)+DllCall(NumGet(NumGet(1*psp)+8), "Uint", psp)*0=0



Return	COM_Enwrap(ppv)



}



COM_FindConnectionPoint(pdp, DIID)



{



DllCall(NumGet(NumGet(1*pdp)+ 0), "Uint", pdp, "Uint", COM_GUID4String(IID_IConnectionPointContainer, "{B196B284-BAB4-101A-B69C-00AA00341D07}"), "UintP", pcc)



DllCall(NumGet(NumGet(1*pcc)+16), "Uint", pcc, "Uint", COM_GUID4String(DIID,DIID), "UintP", pcp)



DllCall(NumGet(NumGet(1*pcc)+ 8), "Uint", pcc)



Return	pcp



}



COM_GetConnectionInterface(pcp)



{



VarSetCapacity(DIID,16,0)



DllCall(NumGet(NumGet(1*pcp)+12), "Uint", pcp, "Uint", &DIID)



Return	COM_String4GUID(&DIID)



}



COM_Advise(pcp, psink)



{



DllCall(NumGet(NumGet(1*pcp)+20), "Uint", pcp, "Uint", psink, "UintP", nCookie)



Return	nCookie



}



COM_Unadvise(pcp, nCookie)



{



Return	DllCall(NumGet(NumGet(1*pcp)+24), "Uint", pcp, "Uint", nCookie)



}



COM_Enumerate(penum, ByRef Result, ByRef vt = "")



{



VarSetCapacity(varResult,16,0)



If (0 =	hr:=DllCall(NumGet(NumGet(1*penum:=COM_Unwrap(penum))+12), "Uint", penum, "Uint", 1, "Uint", &varResult, "UintP", 0))



Result:=(vt:=NumGet(varResult,0,"Ushort"))=9||vt=13?COM_Enwrap(NumGet(varResult,8),vt):vt=8||vt<0x1000&&COM_VariantChangeType(&varResult,&varResult)=0?StrGet(NumGet(varResult,8)) . COM_VariantClear(&varResult):NumGet(varResult,8)



Return	hr



}



COM_Invoke(pdsp,name="",prm0="vT_NoNe",prm1="vT_NoNe",prm2="vT_NoNe",prm3="vT_NoNe",prm4="vT_NoNe",prm5="vT_NoNe",prm6="vT_NoNe",prm7="vT_NoNe",prm8="vT_NoNe",prm9="vT_NoNe")



{



pdsp :=	COM_Unwrap(pdsp)



If	name=



Return	DllCall(NumGet(NumGet(1*pdsp)+8),"Uint",pdsp)



If	name contains .



{



SubStr(name,1,1)!="." ? name.=".":name:=SubStr(name,2) . "."



Loop,	Parse,	name, .



{



If	A_Index=1



{



name :=	A_LoopField



Continue



}



Else If	name not contains [,(



prmn :=	""



Else If	InStr("])",SubStr(name,0))



Loop,	Parse,	name, [(,'")]



If	A_Index=1



name :=	A_LoopField



Else	prmn :=	A_LoopField



Else



{



name .=	"." . A_LoopField



Continue



}



If	A_LoopField!=



pdsp:=	COM_Invoke(pdsp,name,prmn!="" ? prmn:"vT_NoNe"),name:=A_LoopField



Else	Return	prmn!=""?COM_Invoke(pdsp,name,prmn,prm0,prm1,prm2,prm3,prm4,prm5,prm6,prm7,prm8):COM_Invoke(pdsp,name,prm0,prm1,prm2,prm3,prm4,prm5,prm6,prm7,prm8,prm9)



}



}



Static	varg,namg,iidn,varResult,sParams



VarSetCapacity(varResult,64,0),sParams?"":(sParams:="0123456789",VarSetCapacity(varg,160,0),VarSetCapacity(namg,88,0),VarSetCapacity(iidn,16,0)),mParams:=0,nParams:=10,nvk:=3



Loop, 	Parse,	sParams



If	(prm%A_LoopField%=="vT_NoNe")



{



nParams:=A_Index-1



Break



}



Else If	prm%A_LoopField% is integer



NumPut(SubStr(prm%A_LoopField%,1,1)="+"?9:prm%A_LoopField%=="-0"?(prm%A_LoopField%:=0x80020004)*0+10:3,NumPut(prm%A_LoopField%,varg,168-16*A_Index),-12)



Else If	IsObject(prm%A_LoopField%)



typ:=prm%A_LoopField%["typ_"],prm:=prm%A_LoopField%["prm_"],typ+0==""?(NumPut(&_nam_%A_LoopField%:=typ,namg,84-4*mParams++),typ:=prm%A_LoopField%["nam_"]+0==""?prm+0==""||InStr(prm,".")?8:3:prm%A_LoopField%["nam_"]):"",NumPut(typ==8?COM_SysString(prm%A_LoopField%,prm):prm,NumPut(typ,varg,160-16*A_Index),4)



Else	NumPut(COM_SysString(prm%A_LoopField%,prm%A_LoopField%),NumPut(8,varg,160-16*A_Index),4)



If	nParams



SubStr(name,0)="="?(name:=SubStr(name,1,-1),nvk:=12,NumPut(-3,namg,4)):"",NumPut(nvk==12?1:mParams,NumPut(nParams,NumPut(&namg+4,NumPut(&varg+160-16*nParams,varResult,16))))



Global	COM_HR, COM_LR:=""



If	(COM_HR:=DllCall(NumGet(NumGet(1*pdsp)+20),"Uint",pdsp,"Uint",&iidn,"Uint",NumPut(&name,namg,84-4*mParams)-4,"Uint",1+mParams,"Uint",1024,"Uint",&namg,"Uint"))=0&&(COM_HR:=DllCall(NumGet(NumGet(1*pdsp)+24),"Uint",pdsp,"int",NumGet(namg),"Uint",&iidn,"Uint",1024,"Ushort",nvk,"Uint",&varResult+16,"Uint",&varResult,"Uint",&varResult+32,"Uint",0,"Uint"))!=0&&nParams&&nvk<4&&NumPut(-3,namg,4)&&(COM_LR:=DllCall(NumGet(NumGet(1*pdsp)+24),"Uint",pdsp,"int",NumGet(namg),"Uint",&iidn,"Uint",1024,"Ushort",12,"Uint",NumPut(1,varResult,28)-16,"Uint",0,"Uint",0,"Uint",0,"Uint"))=0



COM_HR:=0



Global	COM_VT:=NumGet(varResult,0,"Ushort")



Return	COM_HR=0?COM_VT>1?COM_VT=9||COM_VT=13?COM_Enwrap(NumGet(varResult,8),COM_VT):COM_VT=8||COM_VT<0x1000&&COM_VariantChangeType(&varResult,&varResult)=0?StrGet(NumGet(varResult,8)) . COM_VariantClear(&varResult):NumGet(varResult,8):"":COM_Error(COM_HR,COM_LR,&varResult+32,name)



}



COM_InvokeSet(pdsp,name,prm0,prm1="vT_NoNe",prm2="vT_NoNe",prm3="vT_NoNe",prm4="vT_NoNe",prm5="vT_NoNe",prm6="vT_NoNe",prm7="vT_NoNe",prm8="vT_NoNe",prm9="vT_NoNe")



{



Return	COM_Invoke(pdsp,name "=",prm0,prm1,prm2,prm3,prm4,prm5,prm6,prm7,prm8,prm9)



}



COM_DispInterface(this, prm1="", prm2="", prm3="", prm4="", prm5="", prm6="", prm7="", prm8="")



{



Critical



If	A_EventInfo = 6



hr:=DllCall(NumGet(NumGet(0+p:=NumGet(this+8))+28),"Uint",p,"Uint",prm1,"UintP",pname,"Uint",1,"UintP",0),hr==0?(sfn:=StrGet(this+40) . StrGet(pname),COM_SysFreeString(pname),%sfn%(prm5,this,prm6)):""



Else If	A_EventInfo = 5



hr:=DllCall(NumGet(NumGet(0+p:=NumGet(this+8))+40),"Uint",p,"Uint",prm2,"Uint",prm3,"Uint",prm5)



Else If	A_EventInfo = 4



NumPut(0*hr:=0x80004001,prm3+0)



Else If	A_EventInfo = 3



NumPut(0,prm1+0)



Else If	A_EventInfo = 2



NumPut(hr:=NumGet(this+4)-1,this+4)



Else If	A_EventInfo = 1



NumPut(hr:=NumGet(this+4)+1,this+4)



Else If	A_EventInfo = 0



COM_IsEqualGUID(this+24,prm1)||InStr("{00020400-0000-0000-C000-000000000046}{00000000-0000-0000-C000-000000000046}",COM_String4GUID(prm1)) ? NumPut(NumPut(NumGet(this+4)+1,this+4)-8,prm2+0):NumPut(0*hr:=0x80004002,prm2+0)



Return	hr



}



COM_DispGetParam(pDispParams, Position = 0, vt = 8)



{



VarSetCapacity(varResult,16,0)



DllCall("oleaut32\DispGetParam", "Uint", pDispParams, "Uint", Position, "Ushort", vt, "Uint", &varResult, "UintP", nArgErr)



Return	(vt:=NumGet(varResult,0,"Ushort"))=8?StrGet(NumGet(varResult,8)) . COM_VariantClear(&varResult):vt=9||vt=13?COM_Enwrap(NumGet(varResult,8),vt):NumGet(varResult,8)



}



COM_DispSetParam(val, pDispParams, Position = 0, vt = 8)



{



Return	NumPut(vt=8?COM_SysAllocString(val):vt=9||vt=13?COM_Unwrap(val):val,NumGet(NumGet(pDispParams+0)+(NumGet(pDispParams+8)-Position)*16-8),0,vt=11||vt=2 ? "short":"int")



}



COM_Error(hr = "", lr = "", pei = "", name = "")



{



Static	bDebug:=1



If Not	pei



{



bDebug:=hr



Global	COM_HR, COM_LR



Return	COM_HR&&COM_LR ? COM_LR<<32|COM_HR:COM_HR



}



Else If	!bDebug



Return



hr ? (VarSetCapacity(sError,1022),VarSetCapacity(nError,62),DllCall("kernel32\FormatMessage","Uint",0x1200,"Uint",0,"Uint",hr<>0x80020009?hr:(bExcep:=1)*(hr:=NumGet(pei+28))?hr:hr:=NumGet(pei+0,0,"Ushort")+0x80040200,"Uint",0,"str",sError,"Uint",512,"Uint",0),DllCall("kernel32\FormatMessage","Uint",0x2400,"str","0x%1!p!","Uint",0,"Uint",0,"str",nError,"Uint",32,"UintP",hr)):sError:="No COM Dispatch Object!`n",lr?(VarSetCapacity(sError2,1022),VarSetCapacity(nError2,62),DllCall("kernel32\FormatMessage","Uint",0x1200,"Uint",0,"Uint",lr,"Uint",0,"str",sError2,"Uint",512,"Uint",0),DllCall("kernel32\FormatMessage","Uint",0x2400,"str","0x%1!p!","Uint",0,"Uint",0,"str",nError2,"Uint",32,"UintP",lr)):""



MsgBox, 260, COM Error Notification, % "Function Name:`t""" . name . """`nERROR:`t" . sError . "`t(" . nError . ")" . (bExcep ? SubStr(NumGet(pei+24) ? DllCall(NumGet(pei+24),"Uint",pei) : "",1,0) . "`nPROG:`t" . StrGet(NumGet(pei+4)) . COM_SysFreeString(NumGet(pei+4)) . "`nDESC:`t" . StrGet(NumGet(pei+8)) . COM_SysFreeString(NumGet(pei+8)) . "`nHELP:`t" . StrGet(NumGet(pei+12)) . COM_SysFreeString(NumGet(pei+12)) . "," . NumGet(pei+16) : "") . (lr ? "`n`nERROR2:`t" . sError2 . "`t(" . nError2 . ")" : "") . "`n`nWill Continue?"



IfMsgBox, No, Exit



}



COM_CreateIDispatch()



{



Static	IDispatch



If Not	VarSetCapacity(IDispatch)



{



VarSetCapacity(IDispatch,28,0),   nParams=3______



Loop,   Parse,   nParams



NumPut(RegisterCallback("COM_DispInterface","",A_LoopField,A_Index-1),IDispatch,4*(A_Index-1))



}



Return &IDispatch



}



COM_GetDefaultInterface(pdisp)



{



DllCall(NumGet(NumGet(1*pdisp) +12), "Uint", pdisp , "UintP", ctinf)



If	ctinf



{



DllCall(NumGet(NumGet(1*pdisp)+16), "Uint", pdisp, "Uint" , 0, "Uint", 1024, "UintP", ptinf)



DllCall(NumGet(NumGet(1*ptinf)+12), "Uint", ptinf, "UintP", pattr)



DllCall(NumGet(NumGet(1*pdisp)+ 0), "Uint", pdisp, "Uint" , pattr, "UintP", ppv)



DllCall(NumGet(NumGet(1*ptinf)+76), "Uint", ptinf, "Uint" , pattr)



DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf)



If	ppv



DllCall(NumGet(NumGet(1*pdisp)+ 8), "Uint", pdisp),	pdisp := ppv



}



Return	pdisp



}



COM_GetDefaultEvents(pdisp)



{



DllCall(NumGet(NumGet(1*pdisp)+16), "Uint", pdisp, "Uint" , 0, "Uint", 1024, "UintP", ptinf)



DllCall(NumGet(NumGet(1*ptinf)+12), "Uint", ptinf, "UintP", pattr)



VarSetCapacity(IID,16),DllCall("kernel32\RtlMoveMemory","Uint",&IID,"Uint",pattr,"Uint",16)



DllCall(NumGet(NumGet(1*ptinf)+76), "Uint", ptinf, "Uint" , pattr)



DllCall(NumGet(NumGet(1*ptinf)+72), "Uint", ptinf, "UintP", ptlib, "UintP", idx)



DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf)



Loop, %	DllCall(NumGet(NumGet(1*ptlib)+12), "Uint", ptlib)



{



DllCall(NumGet(NumGet(1*ptlib)+20), "Uint", ptlib, "Uint", A_Index-1, "UintP", TKind)



If	TKind <> 5



Continue



DllCall(NumGet(NumGet(1*ptlib)+16), "Uint", ptlib, "Uint", A_Index-1, "UintP", ptinf)



DllCall(NumGet(NumGet(1*ptinf)+12), "Uint", ptinf, "UintP", pattr)



nCount:=NumGet(pattr+48,0,"Ushort")



DllCall(NumGet(NumGet(1*ptinf)+76), "Uint", ptinf, "Uint" , pattr)



Loop, %	nCount



{



DllCall(NumGet(NumGet(1*ptinf)+36), "Uint", ptinf, "Uint", A_Index-1, "UintP", nFlags)



If	!(nFlags & 1)



Continue



DllCall(NumGet(NumGet(1*ptinf)+32), "Uint", ptinf, "Uint", A_Index-1, "UintP", hRefType)



DllCall(NumGet(NumGet(1*ptinf)+56), "Uint", ptinf, "Uint", hRefType , "UintP", prinf)



DllCall(NumGet(NumGet(1*prinf)+12), "Uint", prinf, "UintP", pattr)



nFlags & 2 ? DIID:=COM_String4GUID(pattr) : bFind:=COM_IsEqualGUID(pattr,&IID)



DllCall(NumGet(NumGet(1*prinf)+76), "Uint", prinf, "Uint" , pattr)



DllCall(NumGet(NumGet(1*prinf)+ 8), "Uint", prinf)



}



DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf)



If	bFind



Break



}



DllCall(NumGet(NumGet(1*ptlib)+ 8), "Uint", ptlib)



Return	bFind ? DIID : "{00000000-0000-0000-0000-000000000000}"



}



COM_GetGuidOfName(pdisp, Name)



{



DllCall(NumGet(NumGet(1*pdisp)+16), "Uint", pdisp, "Uint", 0, "Uint", 1024, "UintP", ptinf)



DllCall(NumGet(NumGet(1*ptinf)+72), "Uint", ptinf, "UintP", ptlib, "UintP", idx)



DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf), ptinf:=0



DllCall(NumGet(NumGet(1*ptlib)+44), "Uint", ptlib, "Uint", &Name, "Uint", 0, "UintP", ptinf, "UintP", memID, "UshortP", 1)



DllCall(NumGet(NumGet(1*ptlib)+ 8), "Uint", ptlib)



DllCall(NumGet(NumGet(1*ptinf)+12), "Uint", ptinf, "UintP", pattr)



GUID := COM_String4GUID(pattr)



DllCall(NumGet(NumGet(1*ptinf)+76), "Uint", ptinf, "Uint" , pattr)



DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf)



Return	GUID



}



COM_GetTypeInfoOfGuid(pdisp, GUID)



{



DllCall(NumGet(NumGet(1*pdisp)+16), "Uint", pdisp, "Uint", 0, "Uint", 1024, "UintP", ptinf)



DllCall(NumGet(NumGet(1*ptinf)+72), "Uint", ptinf, "UintP", ptlib, "UintP", idx)



DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf), ptinf := 0



DllCall(NumGet(NumGet(1*ptlib)+24), "Uint", ptlib, "Uint", COM_GUID4String(GUID,GUID), "UintP", ptinf)



DllCall(NumGet(NumGet(1*ptlib)+ 8), "Uint", ptlib)



Return	ptinf



}



COM_ConnectObject(pdisp, prefix = "", DIID = "")



{



pdisp:=	COM_Unwrap(pdisp)



If Not	DIID



0+(pconn:=COM_FindConnectionPoint(pdisp,"{00020400-0000-0000-C000-000000000046}")) ? (DIID:=COM_GetConnectionInterface(pconn))="{00020400-0000-0000-C000-000000000046}" ? DIID:=COM_GetDefaultEvents(pdisp):"":pconn:=COM_FindConnectionPoint(pdisp,DIID:=COM_GetDefaultEvents(pdisp))



Else	pconn:=COM_FindConnectionPoint(pdisp,SubStr(DIID,1,1)="{" ? DIID:DIID:=COM_GetGuidOfName(pdisp,DIID))



If	!pconn||!ptinf:=COM_GetTypeInfoOfGuid(pdisp,DIID)



{



MsgBox, No Event Interface Exists!



Return



}



NumPut(pdisp,NumPut(ptinf,NumPut(1,NumPut(COM_CreateIDispatch(),0+psink:=COM_CoTaskMemAlloc(40+nSize:=StrLen(prefix)*2+2)))))



DllCall("kernel32\RtlMoveMemory","Uint",psink+24,"Uint",COM_GUID4String(DIID,DIID),"Uint",16)



DllCall("kernel32\RtlMoveMemory","Uint",psink+40,"Uint",&prefix,"Uint",nSize)



NumPut(COM_Advise(pconn,psink),NumPut(pconn,psink+16))



Return	psink



}



COM_DisconnectObject(psink)



{



Return	COM_Unadvise(NumGet(psink+16),NumGet(psink+20))=0 ? (0,COM_Release(NumGet(psink+16)),COM_Release(NumGet(psink+8)),COM_CoTaskMemFree(psink)):1



}



COM_CreateObject(CLSID, IID = "", CLSCTX = 21)



{



ppv :=	COM_CreateInstance(CLSID,IID,CLSCTX)



Return	IID=="" ? COM_Enwrap(ppv):ppv



}



COM_GetObject(Name)



{



COM_Init()



If	DllCall("ole32\CoGetObject", "Uint", &Name, "Uint", 0, "Uint", COM_GUID4String(IID_IDispatch,"{00020400-0000-0000-C000-000000000046}"), "UintP", pdisp)=0



Return	COM_Enwrap(pdisp)



}



COM_GetActiveObject(CLSID)



{



COM_Init()



If	DllCall("oleaut32\GetActiveObject", "Uint", COM_GUID4String(CLSID,CLSID), "Uint", 0, "UintP", punk)=0



&&	DllCall(NumGet(NumGet(1*punk)), "Uint", punk, "Uint", COM_GUID4String(IID_IDispatch,"{00020400-0000-0000-C000-000000000046}"), "UintP", pdisp)+DllCall(NumGet(NumGet(1*punk)+8), "Uint", punk)*0=0



Return	COM_Enwrap(pdisp)



}



COM_CreateInstance(CLSID, IID = "", CLSCTX = 21)



{



COM_Init()



If	DllCall("ole32\CoCreateInstance", "Uint", COM_GUID4String(CLSID,CLSID), "Uint", 0, "Uint", CLSCTX, "Uint", COM_GUID4String(IID,IID ? IID:IID=0 ? "{00000000-0000-0000-C000-000000000046}":"{00020400-0000-0000-C000-000000000046}"), "UintP", ppv)=0



Return	ppv



}



COM_CLSID4ProgID(ByRef CLSID, ProgID)



{



VarSetCapacity(CLSID,16,0)



DllCall("ole32\CLSIDFromProgID", "Uint", &ProgID, "Uint", &CLSID)



Return	&CLSID



}



COM_ProgID4CLSID(pCLSID)



{



DllCall("ole32\ProgIDFromCLSID", "Uint", pCLSID, "UintP", pProgID)



Return	StrGet(pProgID) . COM_CoTaskMemFree(pProgID)



}



COM_GUID4String(ByRef CLSID, String)



{



VarSetCapacity(CLSID,16,0)



DllCall("ole32\CLSIDFromString", "Uint", &String, "Uint", &CLSID)



Return	&CLSID



}



COM_String4GUID(pGUID)



{



VarSetCapacity(String,38*2)



DllCall("ole32\StringFromGUID2", "Uint", pGUID, "str", String, "int", 39)



Return	String



}



COM_IsEqualGUID(pGUID1, pGUID2)



{



Return	DllCall("ole32\IsEqualGUID", "Uint", pGUID1, "Uint", pGUID2)



}



COM_CoCreateGuid()



{



VarSetCapacity(GUID,16,0)



DllCall("ole32\CoCreateGuid", "Uint", &GUID)



Return	COM_String4GUID(&GUID)



}



COM_CoInitialize()



{



Return	DllCall("ole32\CoInitialize", "Uint", 0)



}



COM_CoUninitialize()



{



DllCall("ole32\CoUninitialize")



}



COM_CoTaskMemAlloc(cb)



{



Return	DllCall("ole32\CoTaskMemAlloc", "Uint", cb)



}



COM_CoTaskMemFree(pv)



{



DllCall("ole32\CoTaskMemFree", "Uint", pv)



}



COM_SysAllocString(str)



{



Return	DllCall("oleaut32\SysAllocString", "Uint", &str)



}



COM_SysFreeString(pstr)



{



DllCall("oleaut32\SysFreeString", "Uint", pstr)



}



COM_SafeArrayDestroy(psar)



{



Return	DllCall("oleaut32\SafeArrayDestroy", "Uint", psar)



}



COM_VariantClear(pvar)



{



DllCall("oleaut32\VariantClear", "Uint", pvar)



}



COM_VariantChangeType(pvarDst, pvarSrc, vt = 8)



{



Return	DllCall("oleaut32\VariantChangeTypeEx", "Uint", pvarDst, "Uint", pvarSrc, "Uint", 1024, "Ushort", 0, "Ushort", vt)



}



COM_SysString(ByRef wString, sString)



{



VarSetCapacity(wString,4+nLen:=2*StrLen(sString))



Return	DllCall("kernel32\lstrcpyW","Uint",NumPut(nLen,wString),"Uint",&sString)



}



COM_AccInit()



{



Static	h



If Not	h



COM_Init(), h:=DllCall("kernel32\LoadLibrary","str","oleacc")



}



COM_AccTerm()



{



COM_Term()



}



COM_AccessibleChildren(pacc, cChildren, ByRef varChildren)



{



VarSetCapacity(varChildren,cChildren*16,0)



If	DllCall("oleacc\AccessibleChildren", "Uint", COM_Unwrap(pacc), "Uint", 0, "Uint", cChildren+0, "Uint", &varChildren, "UintP", cChildren:=0)=0



Return	cChildren



}



COM_AccessibleObjectFromEvent(hWnd, idObject, idChild, ByRef _idChild_="")



{



COM_AccInit(), VarSetCapacity(varChild,16,0)



If	DllCall("oleacc\AccessibleObjectFromEvent", "Uint", hWnd, "Uint", idObject, "Uint", idChild, "UintP", pacc, "Uint", &varChild)=0



Return	COM_Enwrap(pacc), _idChild_:=NumGet(varChild,8)



}



COM_AccessibleObjectFromPoint(x, y, ByRef _idChild_="")



{



COM_AccInit(), VarSetCapacity(varChild,16,0)



If	DllCall("oleacc\AccessibleObjectFromPoint", "int", x, "int", y, "UintP", pacc, "Uint", &varChild)=0



Return	COM_Enwrap(pacc), _idChild_:=NumGet(varChild,8)



}



COM_AccessibleObjectFromWindow(hWnd, idObject=-4, IID = "")



{



COM_AccInit()



If	DllCall("oleacc\AccessibleObjectFromWindow", "Uint", hWnd, "Uint", idObject, "Uint", COM_GUID4String(IID, IID ? IID : idObject&0xFFFFFFFF==0xFFFFFFF0 ? "{00020400-0000-0000-C000-000000000046}":"{618736E0-3C3D-11CF-810C-00AA00389B71}"), "UintP", pacc)=0



Return	COM_Enwrap(pacc)



}



COM_WindowFromAccessibleObject(pacc)



{



If	DllCall("oleacc\WindowFromAccessibleObject", "Uint", COM_Unwrap(pacc), "UintP", hWnd)=0



Return	hWnd



}



COM_GetRoleText(nRole)



{



nLen:=	DllCall("oleacc\GetRoleTextW", "Uint", nRole, "Uint", 0, "Uint", 0)



VarSetCapacity(sRole,nLen*2)



If	DllCall("oleacc\GetRoleTextW", "Uint", nRole, "str", sRole, "Uint", nLen+1)



Return	sRole



}



COM_GetStateText(nState)



{



nLen:=	DllCall("oleacc\GetStateTextW", "Uint", nState, "Uint", 0, "Uint", 0)



VarSetCapacity(sState,nLen*2)



If	DllCall("oleacc\GetStateTextW", "Uint", nState, "str", sState, "Uint", nLen+1)



Return	sState



}



COM_AtlAxWinInit(Version = "")



{



Static	h



If Not	h



COM_Init(), h:=DllCall("kernel32\LoadLibrary","str","atl" . Version), DllCall("atl" . Version . "\AtlAxWinInit")



}



COM_AtlAxWinTerm(Version = "")



{



COM_Term()



}



COM_AtlAxGetHost(hWnd, Version = "")



{



If	DllCall("atl" . Version . "\AtlAxGetHost", "Uint", hWnd, "UintP", punk)=0



Return	COM_Enwrap(COM_QueryInterface(punk)+COM_Release(punk)*0)



}



COM_AtlAxGetControl(hWnd, Version = "")



{



If	DllCall("atl" . Version . "\AtlAxGetControl", "Uint", hWnd, "UintP", punk)=0



Return	COM_Enwrap(COM_QueryInterface(punk)+COM_Release(punk)*0)



}



COM_AtlAxAttachControl(pdsp, hWnd, Version = "")



{



If	DllCall("atl" . Version . "\AtlAxAttachControl", "Uint", punk:=COM_QueryInterface(pdsp,0), "Uint", hWnd, "Uint", COM_AtlAxWinInit(Version))+COM_Release(punk)*0=0



Return	COM_Enwrap(pdsp)



}



COM_AtlAxCreateControl(hWnd, Name, Version = "")



{



If	DllCall("atl" . Version . "\AtlAxCreateControl", "Uint", &Name, "Uint", hWnd, "Uint", 0, "Uint", COM_AtlAxWinInit(Version))=0



Return	COM_AtlAxGetControl(hWnd,Version)



}



COM_AtlAxCreateContainer(hWnd, l, t, w, h, Name = "", Version = "")



{



Return	DllCall("user32\CreateWindowEx", "Uint",0x200, "str", "AtlAxWin" . Version, "Uint", Name?&Name:0, "Uint", 0x54000000, "int", l, "int", t, "int", w, "int", h, "Uint", hWnd, "Uint", 0, "Uint", 0, "Uint", COM_AtlAxWinInit(Version))



}



COM_AtlAxGetContainer(pdsp, bCtrl = "")



{



DllCall(NumGet(NumGet(1*pdsp:=COM_Unwrap(pdsp))), "Uint", pdsp, "Uint", COM_GUID4String(IID_IOleWindow,"{00000114-0000-0000-C000-000000000046}"), "UintP", pwin)



DllCall(NumGet(NumGet(1*pwin)+12), "Uint", pwin, "UintP", hCtrl)



DllCall(NumGet(NumGet(1*pwin)+ 8), "Uint", pwin)



Return	bCtrl?hCtrl:DllCall("user32\GetParent", "Uint", hCtrl)



}



COM_ScriptControl(sCode, sEval = "", sName = "", Obj = "", bGlobal = "")



{



oSC:=COM_CreateObject("ScriptControl"), oSC.Language(sEval+0==""?"VBScript":"JScript"), sName&&Obj?oSC.AddObject(sName,Obj,bGlobal):""



Return	sEval?oSC.Eval(sEval+0?sCode:sEval oSC.AddCode(sCode)):oSC.ExecuteStatement(sCode)



}



COM_Parameter(typ, prm = "", nam = "")



{



Return	IsObject(prm)?prm:Object("typ_",typ,"prm_",prm,"nam_",nam)



}



COM_Enwrap(obj, vt = 9)



{



Static	base



Return	IsObject(obj)?obj:Object("prm_",obj,"typ_",vt,"base",base?base:base:=Object("__Delete","COM_Invoke","__Call","COM_Invoke","__Get","COM_Invoke","__Set","COM_InvokeSet","base",Object("__Delete","COM_Term")))



}



COM_Unwrap(obj)



{



Return	IsObject(obj) ? (obj.prm_) :obj



}



JoinScript(scriptFullPath,workingDir=""){



global outputvar



IncludedScript:=[]



static includedLib



if !isobject(includeLib)



includeLib:=[]



scriptDir:=RegExReplace(scriptFullPath,"(\/|\\)([^\/\\]+)$","")



if workingDir=



workingDir:=scriptDir



lib:=[workingDir "\Lib",a_mydocuments "\AutoHotkey\Lib",a_ahkpath "\Lib"]



fileread,scriptText,% scriptFullPath



includePattern:="is)#include(again|)\s+(?:\*i\s+)?(<?)([^\n\r;>]+)(>?)(?:;[^\n\r]*)?\r?\n?"



matched:=[]



i:=0,match:="1"



while i:=RegExMatch(scriptText,includePattern,match,i+strlen(match))



matched.push(array(match,match1?1:0,match3,match2&&match4?1:0,i,strlen(match)))



fullScript:=""



for k,v in matched {



valued:=0



includePath:=v.3



if (v.4) {



for x,y in lib



if fileexist(y "\" includePath ".ahk") {



includePath:=y "\" includePath ".ahk"



if includedLib.haskey(includePath)



break



else



includeLib["" includePath]:=1,valued:=1



}



}else{



StringReplace,includePath,includePath,% "%A_AppData%",%a_appdata%,all



StringReplace,includePath,includePath,% "%A_AppDataCommon%",%A_AppDataCommon%,all



StringReplace,includePath,includePath,% "%A_ScriptDir%",%ScriptDir%,all



if instr(fx:=fileexist(includePath),"D") {



workingDir:=RegExReplace(includePath,"(\\|\/)?$","")



}else if (fx!="") {



valued:=1



}



}



if IncludedScript.hasKey(includePath) && v.1=0



valued:=0



fullScript.=(k=1?substr(scriptText,1,v.5-1):substr(scriptText,matched[k-1,5]+matched[k-1,6],v.5-1)) . (valued?joinScript(includePath):"")



IncludedScript["" includePath]:=1



}



return matched.maxindex()?(fullScript substr(scriptText,v.5+v.6)):scriptText



}