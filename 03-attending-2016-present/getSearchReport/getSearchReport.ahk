SetBatchLines,-1
DetectHiddenWindows,On


#include <risimpax>


saveTo:=A_ScriptDir "\save.xml"

hwnd:=WinExist("報告全文檢索 ahk_exe Menu.exe")
GridAcc:=getNetAcc(hwnd, "DataGridView2", "WindowsForms10.Window")
GridHwnd:=acc_windowfromobject(GridAcc)
GridRows:=acc_children(GridAcc)
ExamAcc:=getNetAcc(hwnd, "QEXAM_TEXT", "WindowsForms10.RichEdit20W")
ImpAcc:=getNetAcc(hwnd, "QIMPRESSION_TEXT", "WindowsForms10.RichEdit20W")
col:=[]
Loop % (FirstRowCells:=acc_children(GridRows[1])).maxindex()-1 
	col.push(FirstRowCells[A_Index+1].accValue)

FileAppend,% "<?xml version=""1.0"" encoding=""UTF-8""?>`n<SearchReport>`n",% saveTo,utf-8

Loop % GridRows.maxindex()-1 {
	
	str:="<study>`n"
	cells:=acc_children(GridRows[A_Index+1])
	Loop % cells.maxindex()-1
		str.="<" (colName:=col[A_Index]) ">" XML_escape(cells[A_Index+1].accValue) "</" colName ">`n"
	str.="<exam>"
	str.=XML_escape(ExamAcc.accValue) "</exam>`n"
	str.="<impression>"
	str.=XML_escape(ImpAcc.accValue) "</impression></study>`n"
	FileAppend,% str,% saveTo,utf-8
	controlsend,,{Down},% "ahk_id " GridHwnd
	Sleep 500
}
FileAppend,% "</SearchReport>`n",% saveTo,utf-8

ExitApp

return


XML_escape(str){
	str:=RegExReplace(str, """", "&quot;")
	str:=RegExReplace(str, "'", "&apos;")
	str:=RegExReplace(str, "<", "&lt;")
	str:=RegExReplace(str, ">", "&gt;")
	str:=RegExReplace(str, "&", "&amp;")
	return str
}

