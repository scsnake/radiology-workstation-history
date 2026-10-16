#include <Excel_Get>

onexit,onexit

gui,+alwaysontop
gui,font,s10,Verdana
gui,add,button,gAdjust w100 h50,Adjust Row Height
gui,show,,% " "

return

Adjust:
ComObjError(false)
;~ oExcel:=ComObjActive("Excel.Application")
oExcel:=Excel_Get()

if !oExcel
	return

oExcel.ScreenUpdating:=ComObj(0xB,0) ;false

r:=oExcel.Selection.Rows.Count
loop % r {
	if (a_index > oExcel.Selection.Rows.Count)
		break
	row:=oExcel.Selection.Rows(a_index)
	count:=row.Columns.Count
	str:=false
	loop % count
		if (row.Columns(a_index).value!="")
			str:=true
	if (str) {
		row.EntireRow.AutoFit()
		row.EntireRow.RowHeight:=row.EntireRow.RowHeight+1.6*row.Columns(1).Font.Size
		row.VerticalAlignment:=-4108
	}
}

oExcel.ScreenUpdating:=ComObj(0xB,1) ;true
return

GUIclose:
onexit:
oExcel.ScreenUpdating:=ComObj(0xB,1) ;true
exitapp
return