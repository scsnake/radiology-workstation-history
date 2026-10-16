SearchChartNo(chartNo){
	if WinExist("Search Parameters ahk_exe PatientDirectory.exe")
		fillChartNo(chartNo)
	else
		
}

fillChartNo(chartNo, search=true){
	ControlSetText,Edit2,% chartNo,% "Search Parameters ahk_exe PatientDirectory.exe"
	ControlClick,WindowsForms10.BUTTON.app.0.e195c1_r12_ad11,% "Search Parameters ahk_exe PatientDirectory.exe"
}

#IfWinActive,Search Parameters ahk_exe PatientDirectory.exe
Enter::
NumpadEnter::
ControlClick,WindowsForms10.BUTTON.app.0.e195c1_r12_ad11,% "Search Parameters ahk_exe PatientDirectory.exe"
return
#IfWinActive

esc::ExitApp
