#include <acc>

FirefoxGetTabs(hwnd=""){
	if !WinExist("ahk_id " hwnd)
		WinGet, hwnd, ID, ahk_class MozillaWindowClass
	
	FF := Acc_ObjectFromWindow(hwnd)
	ind:=0
	;~ for ch in acc_EnumChildren(FF)
		;~ if (acc_GetRoleText(ch.accRole(0))="工具列") && acc_GetRoleText((tb:=Acc_Children(ch)[1]).accRole(0)="索引標籤清單")
			;~ if (A_Index>1)
				;~ break
	tb:=findAccByRoleText(FF, [["工具列"], ["索引標籤清單", "", 1]])
	return tb
}

FirefoxActivateTab(tabAcc){
	tabAcc.accDoDefaultAction(0)
}

FirefoxGetTabsByName(name, hwnd=""){
	tb:=FirefoxGetTabs(hwnd)
	,arr:=[], i:=0
	for tab in acc_EnumChildren(tb) {
		++i
		if InStr(a:=tab.accName(0), name)
			arr[i]:=tab
	}
		
	return arr
}

FirefoxGetTabDoc(which, hwnd=""){
	if !WinExist("ahk_id " hwnd)
		WinGet, hwnd, ID, ahk_class MozillaWindowClass
	
	FF := Acc_ObjectFromWindow(hwnd)
	
	result:=findAccByRoleText(FF, [["群組", 1]])
	
	return result[1]
}
;~ MsgBox % FirefoxGetUrl()
FirefoxGetUrl(hwnd="", retAcc=false){
	if !WinExist("ahk_id " hwnd)
		WinGet, hwnd, ID, ahk_class MozillaWindowClass
	
	FF := Acc_ObjectFromWindow(hwnd)
	
	result:=findAccByRoleText(FF, [["工具列"], ["下拉式方塊", 1], ["可編輯的文字"]])
	 
	return retAcc?result:(result?result.accValue(0):"")
}

;~ FirefoxGetAllUrls()
;~ FirefoxGetAllUrls(hwnd=""){
	;~ urlAcc:=FirefoxGetUrl("", true)
	;~ ,tabs:=FirefoxGetTabs()
	;~ ,arr:=[]
	;~ for tab in acc_EnumChildren(tabs){
		;~ tab.accDoDefaultAction(0)
		;~ Sleep 100
		;~ arr.push(urlAcc.accValue(0))
	;~ }
	;~ return arr
;~ }

;
; FFwait - wait for a Firefox page to finish loading
;
; Requires:
;     Acc.ahk
; https://autohotkey.com/board/topic/90620-firefox-page-load-wait/page-2
;~ FFwait()
FFwait(hwnd="", timeout=30000) {
    ;~ WinWaitActive, ahk_class MozillaWindowClass

    ; define path to page load status push button
    ; the button's description will change when the page has finished loading
    ;~ button := "application.grouping2.property_page1.tool_bar2.combo_box1.push_button4"
    ; may require the path below for newer Firefox versions
    ;~ button := "application.tool_bar2.combo_box1.push_button4"
	
	
    ; the description text that indicates page load status
    ;
    ; note that these may change - mouse over the button to see what your
    ; Firefox shows in the tooltip
	
	;~ ReloadButton:=Acc_Get("Object", "應用程式.工具列3.下拉式方塊1.按鈕4", 0, "ahk_class MozillaWindowClass")
	
	if !WinExist("ahk_id " hwnd)
		WinGet, hwnd, ID, ahk_class MozillaWindowClass
	
	FF := Acc_ObjectFromWindow(hwnd)
	
	ReloadButton:=findAccByRoleText(FF, [["工具列"], ["下拉式方塊", 1], ["按鈕", 4]])
    ,loading := "Stop loading this page"
    ,loaded  := "Reload current page"
	,timeoutInd:=timeout/10
    ; sleep until the description indicates page is loaded
    Loop {
		description := Acc_Get("Name", "", 0, ReloadButton) 
		;~ MsgBox % description
		if(A_Index>timeoutInd)
			return 1
		if (description = loaded) {
			return 0
		}
		sleep, 10
    }
	
}