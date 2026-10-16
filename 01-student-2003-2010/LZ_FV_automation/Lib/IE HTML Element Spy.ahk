^E::MsgBox, % IE_HtmlElement()

IE_HtmlElement()
{
   CoordMode, Mouse
   MouseGetPos, xpos, ypos,, hWnd, 3
   Loop
   {
      If Not   hWnd
      Exit
      WinGetClass, sClass, ahk_id %hWnd%
      If Not   sClass == "Internet Explorer_Server"
         hWnd :=   DllCall("GetAncestor", "Ptr", hWnd, "Uint", 1, "Ptr")
      Else   Break
   }
   If   pwin := IE_GetWindow(hWnd)
   {
   If   pelt := COM_Invoke(pwin, "document.elementFromPoint", xpos-xorg:=COM_Invoke(pwin,"screenLeft"), ypos-yorg:=COM_Invoke(pwin,"screenTop"))
   {
      While   (type:=COM_Invoke(pelt,"tagName"))="IFRAME" || type="FRAME"
      {
      selt .= "[" type "]" (A_Index==1 ? "":"." A_Index-1) "`n" COM_Invoke(pelt,"src") "`n", COM_Release(pwin)
      pwin := COM_QueryService(pbrt:=COM_Invoke(pelt,"contentWindow"), "{332C4427-26CB-11D0-B483-00C04FD90119}"), COM_Release(pbrt)
      pbrt := COM_Invoke(pwin, "document.elementFromPoint", xpos-xorg+=COM_Invoke(pelt,"getBoundingClientRect.left"), ypos-yorg+=COM_Invoke(pelt,"getBoundingClientRect.top")), COM_Release(pelt), pelt:=pbrt
      }
      pbrt :=   COM_Invoke(pelt, "getBoundingClientRect")
      l  :=   COM_Invoke(pbrt, "left")
      t  :=   COM_Invoke(pbrt, "top")
      r  :=   COM_Invoke(pbrt, "right")
      b  :=   COM_Invoke(pbrt, "bottom")
      COM_Release(pbrt)
      selt .=   "[HTML]`n" COM_Invoke(pelt, "outerHTML") "`n[TEXT]`n" COM_Invoke(pelt, "outerText") "`n[RECTANGLE]`n(" l+xorg "," t+yorg "," r+xorg "," b+yorg ")"
      COM_Release(pelt)
   }
   COM_Release(pwin)
   Return   selt
   }
}

IE_GetWindow(hWnd)
{
   Static   h:=0
   If   h =0
      h:=COM_AccInit()
   If   pacc:=COM_AccessibleObjectFromWindow(hWnd)
   Return   COM_QueryService(pacc, "{332C4427-26CB-11D0-B483-00C04FD90119}") + COM_Release(pacc)*0
}

IE_GetDocument(hWnd)
{
   Static   h:=0,msg,iid
   If   h =0
      h:=COM_AccInit(), msg:=DllCall("user32\RegisterWindowMessage", "str", "WM_HTML_GETOBJECT"), COM_GUID4String(iid, "{332C4425-26CB-11D0-B483-00C04FD90119}")
   If   DllCall("user32\SendMessageTimeout", "Uint", hWnd, "Uint", msg, "Uint", 0, "Uint", 0, "Uint", 2, "Uint", 1000, "UintP", lr) && DllCall("oleacc\ObjectFromLresult", "Uint", lr, "Uint", &iid, "Uint", 0, "UintP", pdoc)=0
   Return   pdoc
}