﻿﻿/* scsnake@gmail.com





*/





version=2.10


updateDay=2016/10/04





#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.


SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.


SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


#SingleInstance,force


SetBatchLines, -1


coordMode,mouse,screen


coordMode,pixel,screen


coordMode,tooltip,screen


SetTitleMatchMode,2


setformat,float,0.2


SetControlDelay,-1


#include <risimpax>





gosub loadContacts





gui,+border +lastfound


WinGet,guiHwnd,id





Gui, Font,S8 CDefault, Verdana


Gui, Add, Tab2, vtab_choosen gtab_select w845 h320, % "Patient Data|Swallowing Time|Swallowing Finding|Conclusion"





gui,tab,1








gui,add,text,section h20,Study No


gui,add,text,xs y+5 hp,Exam Date


gui,add,text,xs y+5 hp,Access No


gui,add,text,xs y+5 hp,Chart No


gui,add,text,xs y+5 hp,Name


gui,add,text,xs y+5 hp,Age


gui,add,text,xs y+5 hp,Gender


gui,add,edit,xs+70 ys vStudyNo w120 h20


gui,add,DateTime,xp y+5 vExDate wp hp


gui,add,edit,xp y+5 vAccessNo wp hp Uppercase limit11


gui,add,edit,xp y+5 vChartNo wp hp Uppercase limit7


gui,add,edit,xp y+5 vName wp hp 


gui,add,edit,xp y+5 vAge w60 hp


gui,add,edit,x+0 vAgeUnit wp hp,y/o


GenderArr:=["Female","Male"]


gui,add,radio,xs+70 y+5 vGender2 hp Checked group,Male


gui,add,radio,x+0 hp vGender1,Female








gui,add,groupbox,xs+200 ys-5 w210 h190


DxArr:=["CVA","Neurological dz not CVA","NPC","H/N tumor not NPC","Trauma","Cerebral palsy","Others"]


gui,add,radio,xp+10 yp+10 h20 vDx1 group,CVA


loop % DxArr.maxindex()-1


{


	t:=a_index+1


	gui,add,radio,xp y+5 hp vDx%t%,% DxArr[t]


}





gui,add,Edit,x+0 yp hp w120 vOtherDx





gui,add,text,xs ys+200 h20,Ward/OPD


gui,add,Edit,xs+100 yp w120 hp vPtFrom,OPD


gui,add,text,xs y+5 hp,Chief Complaint


gui,add,edit,xs+100 yp hp w310 vComplaint





gui,add,groupbox,section xs+420 ys-5 w180 h140


DiffArr:=["No difficulty","Mild difficulty, fair eating","Soft diet","Liquid diet","Difficult even liquid"]


gui,add,radio,xp+10 yp+10 h20 vDiff1 group,No difficulty


loop % DiffArr.maxindex()-1


{


	t:=a_index+1


	gui,add,radio,xp y+5 hp vDiff%t%,% DiffArr[t]


}





gui,add,groupbox,xs+190 ys w180 h140


gui,add,text,xp+10 yp+10 h20,CVA


gui,add,text,xp y+5 hp,Attack


gui,add,datetime,xp y+5 hp w160 vCVAAttack choosenone


gui,add,text,xp y+5 hp,Location


gui,add,edit,xp y+5 hp w160 vCVALocation





gui,add,groupbox,section xs ys+140 w370 h140


gui,add,text,xp+10 yp+10 h20,NPC


gui,add,checkbox,xs+80 yp hp vNPCRT gRTclick,R/T


gui,add,checkbox,x+20 yp hp vNPCCT,C/T


gui,add,text,xs+10 y+5 h20 disabled,R/T period


gui,add,DateTime,xs+80 yp hp w120 vRTStart ChooseNone disabled


gui,add,text,x+10 yp hp disabled,to


gui,add,datetime,x+10 yp hp w120 vRTEnd ChooseNone  disabled


gui,add,text,xs+10 y+5 hp disabled,Symptom start at


gui,add,datetime,x+10 yp hp w120 vNPCSymptom ChooseNone  disabled


gui,add,text,xs+10 y+5 hp disabled,R/T type


gui,add,edit,xs+80 yp hp vRTType disabled


gui,add,text,xs+10 y+5 hp disabled,R/T dose


gui,add,edit,xs+80 yp hp vRTDose disabled








gui,tab,2





fontSize=10


Gui, Font, S%fontSize% CDefault, Verdana


rowTitleArr:=["Thin5","Thick5","Paste5","Pudding5"]


colTitleArr:=["1","2","3","4"]


rowHeight:=50,startx="",starty="",dataArrRC="",rowInterval=20,colInterval=""


colWidth:=[80,90,90,90,90]


gosub GUIgrid


gui,font,S8 CDefault W400,Verdana


swall:=["thin","thick","paste","pudding"]


guicontrolget,firstEdit,Pos,gridData1_1


rowHeight:=50,rowInterval=20,rowInterval2=1,colWidth2:=[60,60,60,60,60,60]


rowTitleArr2:=["LP","Asp","Symtic","Pre","During","Post"],SymticArr:={"no":0,"trace":1,"minor":2,"major":3},SymticArr2:={0:"no",1:"trace",2:"minor",3:"major"}


gui,add,text,% "section y" firstEdity " x+30",LP


loop % rowTitleArr2.maxindex()-1


	gui,add,text,% "xp+" colwidth2[a_index] " yp",% rowtitlearr2[a_index+1]





loop % rowTitleArr.maxindex()


{


	i:=a_index


	str:="LP",yset:="ys+" rowInterval+firstEdith " section "


	gui,add,checkbox,% "xs " yset " v" str i " gtogglePF"


	str:="Asp",xyset:="xp+" colwidth2[1] " yp"


	gui,add,checkbox,% xyset " v" str i " gtogglePF"


	


	loop % rowTitleArr2.maxindex()-2


	{


		j:=a_index+2


		if j=3


			gui,add,text,% "disabled w" colwidth2[j-1] " xp+" colwidth2[j-1] " yp v" rowTitlearr2[j] i " gtoggleSym",% "no   "


		else


			gui,add,checkbox,% "disabled xp+" colwidth2[j-1] " yp v" rowTitlearr2[j] i


	}


	


}


gui,add,checkbox,x30 y+30 gtoggleUnit vunit,% "frames to deci-seconds"








gui,tab,3


FindingArr:=[[ ["Bolus holding","bh"], ["Oral drooling","od"], ["Premature oral leakage","pol"], ["Oral mucosal coating","omc"], ["Oral stasis","os"], ["Epiglottic movement","em"], ["Velar elevation","ve"], ["Pharyngo-oral reflux","por"], ["Symmetry","sym"]],[ ["Tongue-palate contact","tpc"], ["Piecemeal swallowing","ps"], ["Pharyngeal contraction","pc"], ["Pharyngeal mucosal coating","pmc"], ["Vallecular stasis","vs"], ["Pyriform sinus stasis","pss"], ["Hyoid bone elevation","hbe"], ["Pharyngo-nasal reflux","pnr"], ["Retropharyngeal soft tissue","rst"]]]


bhArr:=["Normal","Abnormal"],odArr:=["No","Yes"],polArr:=["No","small amount","large amount"],omcArr:=["Normal","Abnormal"],osArr:=["No","Trace","Significant"],emArr:=["Normal","Flattening","Fixed"],veArr:=["Normal","Abnormal"],porArr:=["No","Yes"],symArr:=["Normal","Right","Left"],tpcArr:=["Normal","Abnormal"],psArr:=["No","Yes"],pcArr:=["Normal","Visible air gap"],pmcArr:=["No","Yes"],vsArr:=["No","small amount","large amount"],pssArr:=["No","small amount","large amount"],hbeArr:=["Normal","Abnormal"],pnrArr:=["No","Yes"],rstArr:=["Normal","Increased"]


boxWidth:=400,boxHeight=30,txtStartx=10,txtStarty=10,interval1=165,interval2=[[140],[60,70]],colSpan=420,rowInterval=5





gosub GUIFinding





guicontrol,+gVAGedit,pc2








gui,add,button,xs-140 y+10 gSetNormal,Set non-selected buttons as no or normal


gui,add,button,x+220 yp gReset,Reset all





gui,tab,4








gui,add,text,section,Other Comment:


gui,add,edit,r5 xs y+5 w800 vcomment


gui,add,text,xs y+10,Conclusion of VFSS:


gui,add,edit,r5 xs y+5 w800 vconclusion


gui,add,text,xs y+40,Examiner


;~ gui,add,edit,r1 x+20 yp w120 vexaminer1,% " 醫師"


gui,add,dropdownlist,x+20 yp w120 vexaminer1,% contactsR


gui,add,text,x+5 yp,/


;~ gui,add,edit,r1 x+5 yp w120 vexaminer2,張醫師


gui,add,dropdownlist,x+5 yp w120 vexaminer2,% contactsVS











;--------------------------MENU





menu,FileM,add,&New	Ctrl+N,MenuHandler


menu,FileM,add,&Open	Ctrl+O,MenuHandler


menu,FileM,add,&Save	Ctrl+S,MenuHandler


menu,FileM,add,&Export to RIS/Clipboard	Ctrl+E,MenuHandler


menu,FileM,add


menu,FileM,add,&Quit	Ctrl+Q,MenuHandler


menu,VFSSmenu,add,&File,:FileM


menu,HelpM,add,&About,MenuHandler


menu,VFSSmenu,add,&Help,:HelpM


menu,VFSSmenu,add,&YCC Report,MenuHandler


menu,BatchM,add,&Text,MenuHandler


menu,BatchM,add,&Report,MenuHandler


menu,BatchM,add,&Print,MenuHandler


menu,VFSSmenu,add,&Batch,:BatchM


menu,VFSSmenu,add,Previous,MenuHandler


menu,VFSSmenu,add,Next,MenuHandler


gui,menu,VFSSmenu





;----------------------------





gui,show,xCenter yCenter,VFSS Reporting System 2











txtVar:=["StudyNo","ExDate","AccessNo","ChartNo","Name","Age","AgeUnit","OtherDx","PtFrom","Complaint","CVAAttack","CVALocation","NPCRT","NPCCT","RTStart","RTEnd","NPCSymptom","RTType","RTDose","comment","conclusion","examiner1","examiner2","pc3","gridData2_1","gridData3_1","gridData4_1","gridData5_1"]


boxVar:=["unit"]


radioVar:=["Gender","Dx","Diff","bh","od","pol","omc","os","em","ve","por","sym","tpc","ps","pc","pmc","vs","pss","hbe","pnr","rst"]


symVar:=["LP","Asp","Symtic","Pre","During","Post"]





if %1%


{


	selectedFile=%1%


	gosub openFileDirect


}


if %2% {


	guicontrol,,ExDate,%2%


}


if %3% {


	GuiControl, ChooseString, examiner1, %3%


}


if %4% {


	GuiControl, ChooseString, examiner2, %4%


}


if %5% {


	guicontrol,,studyno,%5%


}





return





loadContacts:


if !FileExist(contactsFile:=A_ScriptDir "\contacts.csv")


	contactsFile:=RegExReplace(A_ScriptDir, "is)[\/\\][^\/\\]+$", "") "\contacts.csv"


CSVpath:=contactsFile


fileread,csv,*P65001 %CSVpath%


contacts:=[]


;name, phone, abbreviation, title, group


loop,parse,csv,`n


{


	if regexmatch(a_loopfield,"^;")


		continue


	i:=a_index,arr:=[]


	loop,parse,a_loopfield,csv


		arr.push(regexreplace(trim(a_loopfield),"(^[\n\s\t]+)|([\n\s\t]+$)"))


	if (arr.maxIndex())


		contacts.push(arr)


}


contactsR:=contactsVS:="||"


for k,v in contacts


	if instr(v.5,"VS")


		contactsVS.=v.1 "|"


	else if instr(v.5,"R")


		contactsR.=v.1 "|"


return














;-----------------------------------------------------------FUNCTION


MenuHandler:


if a_thismenuitem=&New	Ctrl+N


	gosub renew


else if a_thismenuitem=&Open	Ctrl+O


	gosub openFile


else if a_thismenuitem=&Save	Ctrl+S


	gosub saveFile


else if a_thismenuitem=&Export to Notepad	Ctrl+E


	gosub exportFile


else if a_thismenuitem=&Quit	Ctrl+Q


	send ^q


else if a_thismenuitem=&About


	msgbox,,About,VFSS Reporting System 2`tv%version%`n`n`t`t...modified from Dr. Chung-Wei Lee (2004)`n`n`n`t`tChen Yi-Chang,`n`t`tDepartment of Medical Imaging, N Hospital`n`t`t%updateDay%


else if a_thismenuitem=&YCC Report


	gosub printYCC


else if a_thismenuitem=&Text


	gosub batchText


else if a_thismenuitem=&Report


	gosub batchReport


else if a_thismenuitem=&Print


	gosub batchPrint


else if a_thismenuitem=Previous


	gosub openPrev


else if a_thismenuitem=Next


	gosub openNext





return





batchText:


batchWhat=1


gosub chooseVFSS2Files


return








batchReport:


batchWhat=0


gosub chooseVFSS2Files


return





batchPrint:


gui,+owndialogs


FileSelectFile,SelectedMultiFile,M3,%a_workingdir%,Open YCC Report,html (*.html)


if not SelectedMultiFile


	return


stringsplit,selectedArr,SelectedMultiFile,`n


listhtml:="<title>List of YCC Reports</title>"


loop,parse,SelectedMultiFile,`n


{


	if a_index=1


		SetWorkingDir,% a_loopfield


	else


		listhtml.="<a href=""" a_loopfield """>" a_loopfield "</a><br />"


}


if fileexist("list.html")


	FileDelete,list.html





fileappend,% listhtml,list.html,UTF-8


run,list.html


winwaitactive,List of YCC Reports


msgbox % "列印→選項→列印所有連結的文件"


SetWorkingDir,% a_scriptdir


return





chooseVFSS2Files:


gui,+owndialogs


FileSelectFile,SelectedMultiFile,M3,%a_workingdir%,Open VFSS,VFSS (*.vfs2)


if not SelectedMultiFile


	return


gui,hide


stringsplit,selectedArr,SelectedMultiFile,`n


loop,parse,SelectedMultiFile,`n


{


	if a_index=1


		folder:=a_loopfield


	else


	{


		selectedFile:=folder "\" a_loopfield


		batching=1


		gosub openFileDirect


		Loop


			sleep 100


		until !opening


		if batchwhat=0


			gosub printYCC


		else if batchwhat=1


			gosub exportFile


		Loop


			sleep 100


		until !exporting && !printing


		batching=0


		traytip,,% "Complete: " a_index-1 "/" selectedArr0-1


	}


}


msgbox Batch finished!


reload


SetWorkingDir,% a_scriptdir


traytip


return








exportFile:


exporting=1


gui,submit,nohide


loop 4


{


	i:=a_index+1


	txt:=gridData%i%_1


	stringlower,txt,txt


	txt:=RegExReplace(txt,"\s*\d*$")


	swall[a_index]:=txt


}





for k,v in radioVar


{


	arrName:=v "Arr",options:=%arrName%,%v%:=""


	loop % options.maxindex()


	{


		varName:=v A_Index


		if(%varName%)


			%v%:=options[a_index],break


	}


}





bariumMeals:=swall[1] " 5mL, " swall[2] " 5mL, " swall[3] " 5mL, " swall[4] " 5mL"


if ! (gridData2_2||gridData2_3||gridData2_4)


	StringReplace,bariumMeals,bariumMeals,% swall[1] " 5mL, "


if ! (gridData3_2||gridData3_3||gridData3_4)


	StringReplace,bariumMeals,bariumMeals,% swall[2] " 5mL, "


if ! (gridData4_2||gridData4_3||gridData4_4)


	StringReplace,bariumMeals,bariumMeals,% swall[3] " 5mL, "


if ! (gridData5_2||gridData5_3||gridData5_4)


	StringReplace,bariumMeals,bariumMeals,% ", " swall[4] " 5mL"





bariumMeals:=RegExReplace(bariumMeals,"(,\s){2,3}")





export=Clinical history: `n`nVideofluoroscopic swallowing study with barium meal in %bariumMeals% in lateral view, and thin 5mL in AP view shows: (S/N: %StudyNo%)`n





export.="1. Oral phase:`n   - Oral drooling: " lc(od) "`n   - Bolus holding: " lc(bh) "`n   - Oral stasis: " lc(os) "`n   - Oral mucosal coating: " lc(omc) "`n   - Premature oral leakage: " lc(pol) "`n   - Piecemeal swallowing: " lc(ps) "`n   - Tongue-palate contact: " lc(tpc) "`n"





export.="2. Swallowing time: `n   - Oral transit time (normal<2s): `n      " swall[1] " 5:         "    fill_spaces(gridData2_4-gridData2_2) "s`n      " swall[2] " 5:       "   fill_spaces(gridData3_4-gridData3_2) "s`n      " swall[3] " 5:      "   fill_spaces(gridData4_4-gridData4_2) "s`n      " swall[4] " 5:  " fill_spaces(gridData5_4-gridData5_2) "s`n"


export.="   - Pharyngeal transit time (normal<1s): `n      " swall[1] " 5:         "    fill_spaces(gridData2_5-gridData2_3) "s`n      " swall[2] " 5:       "   fill_spaces(gridData3_5-gridData3_3) "s`n      " swall[3] " 5:      "   fill_spaces(gridData4_5-gridData4_3) "s`n      " swall[4] " 5:  " fill_spaces(gridData5_5-gridData5_3) "s`n"


export.="   - Swallowing trigger (normal<1s): `n      " swall[1] " 5:         "    fill_spaces(gridData2_4-gridData2_3) "s`n      " swall[2] " 5:       "   fill_spaces(gridData3_4-gridData3_3) "s`n      " swall[3] " 5:      "   fill_spaces(gridData4_4-gridData4_3) "s`n      " swall[4] " 5:  " fill_spaces(gridData5_4-gridData5_3) "s`n"








if ! (gridData3_2||gridData3_3||gridData3_4)


	StringReplace,export,export,% "      " swall[2] " 5:            s`n",,a


if ! (gridData4_2||gridData4_3||gridData4_4)


	StringReplace,export,export,% "      " swall[3] " 5:           s`n",,a


if ! (gridData5_2||gridData5_3||gridData5_4)


	StringReplace,export,export,% "      " swall[4] " 5:       s`n",,a











;---------------------------


LP_sym:=LP_asym:=Asp_sym:=Asp_asym:=symData:=object(),timing:=["before","during","after"]


loop 4


{


	i:=A_Index


	loop 6


	{


		j:=a_index,	varName:= symVar[j] i


		if j=3


			guicontrolget,varValue,,%varName%


		else


			varValue:=%varName%


		symData[i,j]:=varValue


	}


}





str1:=LPstr:=ASPstr:=""


loop 4


{


	i:=A_Index


	if symData[i,2]


	{


		ASPstr.= (instr(symData[i,3],"no")=1 ? "a" : "") "symptomatic "


		tmp:=""


		loop 3


			if symData[i,a_index+3]


				tmp.=timing[a_index] "/"


		ASPstr.= tmp " swallowing in " swall[i] " bolus study, "


		if symData[i,1]


			LPstr.="occurs " tmp " swallowing in " swall[i] " bolus study, "


	}


	else if symData[i,1]


	{


		;~ msgbox % symData[i,3]


		;~ msgbox % (instr(symData[i,3],"no") ? "a" : "")


		LPstr.=(instr(symData[i,3],"no")=1 ? "a" : "") "symptomatic "


		loop 3


			if symData[i,a_index+3]


				LPstr.=timing[a_index] "/"


		LPstr.=" swallowing in " swall[i] " bolus study, "


	}


}


LPstr:=RegExReplace(LPstr,"/ "," ")			


LPstr:=RegExReplace(LPstr,", $",".")


LPstr:=RegExReplace(LPstr,"  swallowing","")


Aspstr:=RegExReplace(Aspstr,"/ "," ")			


Aspstr:=RegExReplace(Aspstr,", $",".")


Aspstr:=RegExReplace(Aspstr,"  swallowing","")


if(!LPstr)


	LPstr:="no."


if(!Aspstr)


	Aspstr:="no."








export.="   - Laryngeal penetration: " LPstr "`n   - Aspiration: " Aspstr "`n"








;-----------------------------------------------------------------------------








if pc=<1/2


	pc=mildly decreased


else if pc=>1/2


	pc=markedly decreased





export.="3. Pharyngeal phase:`n   - Vallecular stasis: " (!vs ? "" : (vs<>"No" ? "yes (" vs ")" : "no")) "`n   - Pyriform sinus stasis: " (!pss ? "" : (pss<>"No" ? "yes (" pss ")" : "no")) "`n   - Velar elevation: " (!ve ? "" : (ve="Normal" ? "normal and complete" : "incomplete")) "`n   - Pharyngeal contraction: " lc(pc) . (pc3 ? " (" lc(pc3) ")" : "") "`n   - Hyoid bone elevation: " (!hbe ? "" :(hbe="Normal" ? "normal and complete" : "incomplete")) "`n   - Epiglottic movement: " (!em ? "" :(em="Normal" ? lc(em) : lc(em))) "`n   - Pharyngeal mucosal coating: " lc(pmc) "`n   - Pharyngo-oral reflux: " lc(por) "`n   - Pharyngo-nasal reflux: " lc(pnr) "`n   - Retropharyngeal soft tissue: " lc(rst) "`n   - Bolus pass into esophagus: " (!sym ? "" :(sym="Normal" ? "symmetric" : "asymmetric")) "`n"





export.="4. Other finding:`n"


loop,parse,comment,`n


	if trim(a_loopfield)


		export.="   " trim(a_loopfield) "`n"








export.="5. Conclusion of VFSS:`n"


loop,parse,conclusion,`n


	if trim(a_loopfield)


		export.="   " trim(a_loopfield) "`n"





export:=RegExReplace(export,"\n$")





if (RisHwnd:=RisOpened())[1]<>2 {


	if savedFile


		txtFile:=RegExReplace(savedFile,".vfs2$",".txt")


	else


	{


		fileName:= (StudyNo && ChartNo ? StudyNo "-" ChartNo ".txt" : "")


		FileSelectFile,txtFile,,% a_workingdir "\" fileName,Text file (*.txt)


	}





	filedelete,% txtFile


	FileAppend,% export,% txtFile,UTF-8


	if batching


		exporting:=0,return	


	if not errorlevel


	{


		run % txtFile


		traytip,,% "Export to " txtFile " successfully!",5


	}


	else


		traytip,,% "Oops...,Failure to export!",5


}else {


	RegExMatch(export,"is)(.+)\n5\. Conclusion of VFSS:\n?\s*(.*)",match)


	if (!match)


		match1:=export


	;~ for k,v in RisControls:=getControls(RisHwnd[2])


		;~ if (v.text="Exam." && instr(RisControls[k+1].classnn,"WindowsForms10.EDIT.app")) {


			


			;~ ControlSetText,,% RegExReplace(match1,"\n","`r`n"),% "ahk_id " RisControls[k+1].hwnd


			;~ ControlSetText,,% RegExReplace(match2,"\n","`r`n"),% "ahk_id " RisControls[k+4].hwnd


			;~ break


		;~ }


		;~ for k,v in risControls:=getcontrols(RisHwnd[2]) {


			;~ if (instr(v.text,"下筆") && instr(v.classNN,"WindowsForms10.BUTTON")) {


				;~ temp:=k


				;~ break


			;~ }


		;~ }


		;~ for k,v in risControls {


			;~ if (v.text="Exam." && instr(risControls[k+1]["classNN"],"WindowsForms10.EDIT.app") && abs(k-temp)<13) {


				;~ ControlSetText,,% RegExReplace(match1,"\n","`r`n"),% "ahk_id " RisControls[k+1].hwnd


				;~ ControlSetText,,% RegExReplace(match2,"\n","`r`n"),% "ahk_id " RisControls[k+4].hwnd


				;~ break


			;~ }


		;~ }


		


		RisReports:=getRisReports(RisHwnd[2])


		ControlSetText,,% RegExReplace(match1,"\n","`r`n"),% "ahk_id " RisReports[1,1]


		ControlSetText,,% RegExReplace(match2,"\n","`r`n"),% "ahk_id " RisReports[1,2]


		


		


	winactivate,% "ahk_id " RisHwnd[2]


}


clipboard:=RegExReplace(export,"\n","`r`n")


exporting:=0


return





renew:


msgbox,1,,Any unsaved data will be cleared!!


ifMsgBox Cancel


	return


gui,submit,nohide


;~ gosub clear


if studyNo


	studyNo++


run,% A_ScriptFullPath " 0 """ ExDate """ """ examiner1 """ """ examiner2 """ """ studyNo """"


studyNo--


return





clear:


;~ reload


for k,v in txtVar


{


	if v in NPCCT,NPCRT


		guicontrol,,% v,0


	else


		guicontrol,,%v%,


}





for k,v in radioVar


{


	arrName:=v "Arr",options:=%arrName%


	loop % options.maxindex()


		guicontrol,,% v a_index,0


}





loop 4


{


	i:=A_Index


	loop 4


	{


		j:=A_Index


		guicontrol,,% "gridData" i+1 "_" j+1,


	}


}





loop 4


{


	i:=A_Index


	loop 6


	{


		j:=A_Index


		var:=symvar[j] i,


		if j>2


			guicontrol,disable,% var


		if j=3


			guicontrol,,% var,no


		else


			guicontrol,,% var,0


		


	}


}


pc3=





guicontrol,,gender1,1


guicontrol,,ageunit,y/o


guicontrol,,ptfrom,OPD


;~ guicontrol,,examiner1,% " 醫師"


;~ guicontrol,,examiner2,張醫師


GuiControl, ChooseString, examiner1, % ""


GuiControl, ChooseString, examiner2, % ""


guicontrol,,unit,0


WinSetTitle,ahk_id %guiHWND%,,VFSS Reporting System 2


savedFile=


return





toggleUnit:


guicontrolget,unit,,unit


loop 4


{


	i:=a_index+1


	loop 4


	{


		j:=a_index+1


		guicontrolget,value,,gridData%i%_%j%


		guicontrol,,gridData%i%_%j%,% convertUnit(value,unit)


	}


}


return





; to be edited





convertUnit(value,frameToDeci)


{


	if !value || !instr(value,".")


		return value


	


	value:=RegExReplace(value,"\.+",".")


	value:=RegExReplace(value,"^0+([^0]\d*\.)","$1")


	value:=RegExReplace(value,"^0+\.","0.")


	int:=floor(value)


	rem:=value-int


	if frameToDeci


	{


		while rem*100>30


			rem-=0.3,int++


		return int + round(rem/30*10000)/100


	}


	else


		return int "." round(rem*30)


}








swallowValue(value){


	if regexmatch(value,"[^\d.]")


		return value


	v:=regexreplace(value,".+",".")


	if v is not number


		return value


	if !instr(v,".") && strlen(v)>2


		return v/100


	return v*1


}








openFile:


gui,+owndialogs


old_version=0


if(savedFile)


	FileSelectFile,SelectedFile,,% RegExReplace(savedFile,"is)/.*?$"),Open VFSS,VFSS (*.vfs2)


else


	FileSelectFile,SelectedFile,,%a_workingdir%,Open VFSS,VFSS (*.vfs2)


if not SelectedFile


	return


openFileDirect:


SetWorkingDir,% folderOf(SelectedFile)


opening=1


FileRead,datadump,% SelectedFile


gosub clear





loop,parse,datadump,`,


{


	RegExMatch(a_loopfield,"is).+?(?=\s)",varName)


	


	if !varName


		continue


	


	if varName in comment,conclusion


		continue


	


	varValue:=SubStr(a_loopfield,strlen(varName)+2)


	if varName=data


	{


		StringReplace,varValue,varValue,|\,\,all


		loop,parse,varValue,\


		{


			i:=A_Index


			if(i>5)


			{


				if !old_version


				{


					if !batching


					{


						traytipstr:="此為舊存檔格式，有些資訊可能遺失！"


						traytip,,% traytipstr,5


					}


					


					old_version=1


				}


				continue


			}


			loop,parse,a_loopfield,|


			{


				j:=a_index


				if(j>5)


				{


					if !old_version


					{


						if !batching


						{


							traytipstr:="此為舊存檔格式，有些資訊可能遺失！"


							traytip,,% traytipstr,5


						}


						old_version=1


					}


					continue


				}


				if a_loopfield


				{


					gridVar:="gridData" i+1 "_" j+1


					guicontrol,,%gridVar%,%a_loopfield%


				}


			}


		}


	}


	else if varName=symp


	{


		StringReplace,varValue,varValue,|\,\,all


		loop,parse,varValue,\


		{


			i:=A_Index


			hasSymp=0


			loop,parse,a_loopfield,|


			{


				j:=a_index


				varName:=symVar[j] i


				


				guicontrol,,%varName%,% a_loopfield


				if j<3


					hasSymp:=hasSymp || a_loopfield


				else if (j=3 && hasSymp)


					loop,4


						guicontrol,Enable,% symVar[a_index+2] i


			}


		}


	}


	else if varName in Gender,Dx,Diff,bh,od,pol,vs,ve,por,sym,tpc,ps,pc,pss,hbe,pnr,os,omc,pmc,em,rst


		guicontrol,,%varName%%varValue%,1


	else if varName in unit 


		guicontrol,,%varName%,1


	else if varName=SerialNo


		guicontrol,,StudyNo,% varValue


	else if (varName="examiner1") || (varName="examiner2")


		;~ msgbox % regexreplace(varValue,"is)(.+?)\s*(.+)","$1")


		guicontrol,choosestring,%varName%,% regexreplace(varValue,"is)(.+)\s*(.+)","$1")


	else


		guicontrol,,%varName%,% varValue


	


}





RegExMatch(datadump,"is)(,comment\s)(.+?),(conclusion|examiner)",match)


guicontrol,,comment,% match2


RegExMatch(datadump,"is)(,conclusion\s)(.+?),examiner",match)


guicontrol,,conclusion,% match2








loop 4


{


	guicontrolget,v,,% "gridData" a_index+1 "_1"


	if !v


		guicontrol,,% "gridData" a_index+1 "_1",% rowTitleArr[a_index]


}








savedFile:=selectedFile


gosub RTclick


;~ run % regexreplace(savedFile,".vfs2$",".txt")


WinSetTitle,ahk_id %guiHWND%,,% "VFSS Reporting System 2 - " RegExReplace(savedFile,"is).*\\(.*?)","$1")


opening=0


return











saveFile:


gosub dump


fileName:= (StudyNo && ChartNo ? StudyNo "-" ChartNo ".vfs2" : "")


if not savedFile


{


	gui,+owndialogs


	FileSelectFile,savedFile,S,%a_workingdir%\%fileName%,Save VFSS,VFSS (*.vfs2)


}





if not savedFile


	return


else if not RegExMatch(savedFile,".vfs2$")


	savedFile.=".vfs2"








FileDelete,% savedFile


FileAppend,%datadump%,*%savedFile%,UTF-8





if not errorlevel


	traytip,, % "Save to " savedFile " successfully!",5


else


	msgbox,16,Oops...,Failure to save!





WinSetTitle,ahk_id %guiHWND%,,% "VFSS Reporting System 2 - " RegExReplace(savedFile,"is).*\\(.*?)","$1")





return





dump:


gui,submit,nohide


datadump=


for k,v in txtVar


{	


	varValue:=%v%


	if varValue


		datadump.=v " " varValue ","


}


for k,v in boxVar


	if varValue:=%v%


		datadump.=v " " varValue ","


for k,v in radioVar


{


	


	arrName:=v "Arr",options:=%arrName%


	loop % options.maxindex()


	{


		varName:=v a_index


		if(%varName%)


		{


			datadump.=v " " a_index ","


			break


		}


	}


}











datadump.="data "


loop 4


{


	i:=a_index+1


	loop 4


	{


		j:=A_Index+1


		datadump.=gridData%i%_%j% "|"


	}


	datadump.="\"


}





datadump.=",symp "


loop 4


{


	i:=a_index


	loop 6


	{


		j:=a_index


		varName:=symvar[j] i


		if j=3


			guicontrolget,%varName%,,%varName%


		datadump.=%varName% "|"


	}


	datadump.="\"


}





return








GUIFinding:


for k1,v1 in FindingArr


{


	for k2,v2 in v1


	{


		format=


		title:=v2[1],var=v2[2]


		optionArrName:=var "Arr",options:=%optionArrName%


		if k2=1 


			if k1=1


				format:="section "


			else


				format:="section xs+" colSpan " ys "


		else


			format:="xs y+" rowInterval " "


		format.="w" boxWidth " h" boxHeight " "


		gui,add,groupbox,%format%


		gui,add,text,xp+%txtStartx% yp+%txtStarty%,%title%


		


		n:=options.maxindex()


		for k3,v3 in options


			if k3=1


				gui,add,radio,group xp+%interval1% yp v%var%1,% v3


			else


				gui,add,radio,% "xp+" interval2[n-1,k3-1] " yp v"  var k3,% v3


	}


}


return





GUIgrid:


if not (isobject(rowTitleArr) && isobject(colTitleArr))


	return





rows:=rowTitleArr.maxindex()


cols:=colTitleArr.maxindex()





if not isobject(rowHeight)


{


	tmp:=round(rowHeight)


	rowHeight:=object()


	loop % rows+1


		rowHeight.push(tmp)


}


else if (rowHeight.maxindex()<>rows+1)


	return


	


if not isobject(colWidth)


{


	tmp:=round(colWidth)


	colWidth:=object()


	loop % cols+1


		colWidth.push(tmp)


}


else if (colWidth.maxindex()<>cols+1)


	return


if not isobject(rowInterval)


{


	tmp:=round(rowInterval)


	rowInterval:=object()


	loop % rows


		rowInterval.push(tmp)


}


else if (rowInterval.maxindex()<>rows)


	return


if not isobject(colInterval)


{


	tmp:=round(colInterval)


	colInterval:=object()


	loop % cols


		colInterval.push(tmp)


}


else if (colInterval.maxindex()<>cols)


	return


	


loop % rows+1


{


	row:=a_index


	loop % cols+1


	{


		col:=a_index


		gridFormat=


		


		if (row=1 && col=1)


		{


			gridFormat.="section "


			if startx<>


				gridFormat.="x" startx " "


			if starty<>


				gridFormat.="y" starty " "


		}


		else if col>1


			gridFormat.="x+" colInterval[col-1] " yp "


		else if col=1


			gridFormat.="xs y+" rowInterval[row-1] " "


		


		gridFormat.="h" rowHeight[row] " w" colWidth[col] " r1 "


		


		if row=1


		{


			gui,font,w700


			gui,add,edit,% "disabled readonly " gridFormat " vgridData" row "_" col,% colTitleArr[col-1]


		}


		else if col=1


		{


			gui,font,w400 s10


			gui,add,edit,% gridFormat " vgridData" row "_" col,% rowTitleArr[row-1]


			gui,font,w400


		}


		else


			gui,add,edit,%gridFormat% vgridData%row%_%col%,% dataArrRC[row-1,col-1]


	}


	


}


return





folderOf(path)


{


	RegExMatch(path,"is)(.*(\\|\/))?",match)


	return match


}





filenameOf(path)


{


	return RegExReplace(path,"is).*(\\|\/)")


}








lc(str)


{


	stringlower,tmp,str


	return % tmp


}


uc(str)


{


	stringupper,tmp,str


	return % tmp


}





fill_spaces(str,spaces=5)


{


	if(strlen(str)>=spaces)


		return % str


	


	add_spaces:=spaces-strlen(str)


	str2:=""


	loop % add_spaces


		str2.=" "


	return % (str2 . str)


}





SwitchToTabN(t_TabControl, t_TabNumber, t_Wintitle="")


{


  If t_TabControl is not number


    ControlGet, t_TabControl, Hwnd,, %t_TabControl%, %t_WinTitle%


  WinGet, t_tabStyle, Style, ahk_id %t_TabControl%


  If (t_tabStyle & 0x100) { ; buttons are enabled - remove TCS_BUTTONS style


    WinSet, Style, -0x100, ahk_id %t_TabControl%


    t_tbuttons = 1


  } 


  SendMessage, 0x1330, %t_TabNumber%,,, ahk_id %t_TabControl%  ; 0x1330 is TCM_SETCURFOCUS


  sleep, 0 ; to prevent redraw issues


  SendMessage, 0x130C, %t_TabNumber%,,, ahk_id %t_TabControl%  ; 0x130C is TCM_SETCURSEL


  If (t_tbuttons)


    WinSet, Style, +0x100, ahk_id %t_TabControl%


}








SetNormal:


gui,submit,nohide


for k1,v1 in FindingArr


	for k2,v2 in v1


	{


		arrName:=v2[2] "Arr",options:=%arrName%,set=1


		loop % options.maxindex()


		{


			varName:=v2[2] A_Index


			if(%varName%)


				set:=0,break


		}


		if set


			guicontrol,,% v2[2] "1",1


	}


return





Reset:


gui,submit,nohide


for k1,v1 in FindingArr


	for k2,v2 in v1


	{


		arrName:=v2[2] "Arr",options:=%arrName%,set=1


		loop % options.maxindex()


			guicontrol,,% v2[2] A_Index,0


	}





pc3:=""


return





RTclick:


gui,submit,nohide





guicontrol,enable%NPCRT%,R/T period


guicontrol,enable%NPCRT%,RTStart


guicontrol,enable%NPCRT%,to


guicontrol,enable%NPCRT%,RTEnd


guicontrol,enable%NPCRT%,Symptom start at


guicontrol,enable%NPCRT%,NPCSymptom


guicontrol,enable%NPCRT%,R/T type


guicontrol,enable%NPCRT%,RTType


guicontrol,enable%NPCRT%,R/T dose


guicontrol,enable%NPCRT%,RTDose


return





togglePF:


gui,submit,nohide


RegExMatch(a_guicontrol,"\D*",varName)


regexmatch(a_guicontrol,"\d*$",varNo)


var1:="LP" varNo,var2:="Asp" varNo,var1:=%var1%,var2:=%var2%


if !(var1 || var2)


{


	loop 4


	{


		var:=rowtitlearr2[a_index+2] varNo


		guicontrol,disable,% var


		if a_index=1


			guicontrol,,% var,no


		else


			guicontrol,,% var,0


	}


}


else


{


	loop 4


	{


		var:=rowtitlearr2[a_index+2] varNo


		guicontrol,enable,% var


	}


}


return





toggleSym:


gui,submit,nohide


guicontrolget,val,,%a_guicontrol%


val:=trim(val)


if(val="no")


	guicontrol,,%a_guicontrol%,trace


else if (val="trace")


	guicontrol,,%a_guicontrol%,minor


else if (val="minor")


	guicontrol,,%a_guicontrol%,major


else if (val="major")


	guicontrol,,%a_guicontrol%,no


return





tab_select:


return





RBmenu:


gosub closeRBmenu


winwaitactive,ahk_id %guiHWND%


ControlSetText,edit39,% trim(a_guicontrol)


;~ msgbox % a_guicontrol


;~ temp:=clipboardall


;~ clipboard:=a_guicontrol


;~ controlsend,,%a_guicontrol%,ahk_id %guiHWND%


;~ clipboard:=temp


return





#ifwinactive,VFSS Reporting System 2


openPrev:


!left::


guicontrolget,studyno,,studyno





loop,% --studyno "*.vfs2"


{


	selectedFile:=a_LoopFileLongPath


	gosub openFileDirect


	break


}


return





openNext:


!right::


guicontrolget,studyno,,studyno





loop,% ++studyno "*.vfs2"


{


	selectedFile:=a_LoopFileLongPath


	gosub openFileDirect


	break


}


return











#ifwinactive,VFSS Reporting System 2 ahk_class AutoHotkeyGUI


~tab::


gui,submit,nohide


if !studyNo || AccessNo || ChartNo || name || age


	return


if (RisHwnd:=RisOpened())[1]<>2


	return





for k,v in RisControls:=getControls(RisHwnd[2]) {


	if v.text="照會單號" && RegExMatch(RisText:=RisControls[k+1].text,"^(t|T|y|Y)\w{9}\d$") 


		guicontrol,,AccessNo,% RisText


		


	if v.text="病歷號" && RegExMatch(RisText:=RisControls[k+1].text,"(\w)\w{5}\d")


		guicontrol,,ChartNo,% RisText


	if v.text="姓名"


		guicontrol,,name,% RisControls[k+1].text


	if v.text="性別"


		if (RisText:=RisControls[k+1].text)="M"


			guicontrol,,gender2,1


		else if (RisText="F")


			guicontrol,,gender1,1


	if v.text="年齡"


		guicontrol,,age,% RisControls[k+1].text


	if v.text="病房" && (RisText:=RisControls[k+1].text)<>"NA"


		guicontrol,,PtFrom,% RisText


	


}





return


#ifwinactive











$RButton::


;~ caretX:=a_caretx


;~ caretY:=a_carety


mousegetpos,PosX,PosY,underWin,underControl


if (underWin=guiHwnd && underControl="Edit39")


{


	gui,2:+owner +AlwaysOnTop +LastFound -MINIMIZEBOX -MaximizeBox


	winget,rbmenuID,id


	gui,2:font,s8,Verdana


	gui,2:add,text,gRBmenu,% "Normal.                                     "


	gui,2:add,text,gRBmenu y+2,% "Normal swallowing with mild VFSS abnormality."


	gui,2:add,text,gRBmenu y+2,% "Mild oral dysphagia.                         "


	gui,2:add,text,gRBmenu y+2,% "Mild pharyngeal dysphagia.                   "


	gui,2:add,text,gRBmenu y+2,% "Mild oropharyngeal dysphagia.                "


	gui,2:add,text,gRBmenu y+2,% "Moderate oropharyngeal dysphagia.            "


	gui,2:add,text,gRBmenu y+2,% "Severe oropharyngeal dysphagia.              "


	gui,2:show,x%PosX% y%PosY%,Can words


}


else 


	send {Rbutton}


return








::bh::bolus holding


::od::oral drooling


::pol::premature oral leakage


::omc::oral mucosal coating


::os::oral stasis


::em::epiglottic movement


::ve::velar elevation


::por::phayrngo-oral reflux


::sym::symmetric


::tpc::tongue-palate contact


::ps::piecemeal swallowing


::pc::phayrngeal contraction


::pmc::phayrngeal mucosal coating


::vs::vallecular stasis


::pss::pyriform sinus stasis


::hbe::hyoid bone elevation


::pnr::pharyngo-nasal reflux


::rst::retropharyngeal soft tissue





::lp::laryngeal penetration


::asp::aspiration





::bs::bolus study


::bar::barium


::swa::swallowing


::dys::dysphagia


::tri::trismus





::ng::placement of a NG tube


::opc::post-op change


::tra::tracheostomy








#ifwinactive





closeRBmenu:


~esc::


ifwinexist,ahk_id %rbmenuID%


{


	winclose


	winactivate,ahk_id %guiHWND%


}


return





#ifwinactive VFSS Reporting System 2


^e::


	gosub exportFile


return


^o::





	gosub openfile


return


^q::





	send !q


return


^s::





	gosub saveFile


return


^n::





	gosub renew


return


#IfWinActive




















printYCC:


printing:=1


;~ txtVar:=["StudyNo","ExDate","AccessNo","ChartNo","Name","Age","AgeUnit","OtherDx","PtFrom","Complaint","CVAAttack","CVALocation","NPCRT","NPCCT","RTStart","RTEnd","NPCSymptom","RTType","RTDose","comment","conclusion","examiner1","examiner2"]


;~ radioVar:=["Gender","Dx","Diff","bh","od","pol","vs","ve","por","sym","tpc","ps","pc","pss","hbe","pnr","os","omc","pmc","em","rst"]








gui,submit,nohide


FormatTime,Exdate2,% exdate,yyyy/MM/dd





loop 4


{


	i:=a_index+1


	txt:=gridData%i%_1


	stringlower,txt,txt


	txt:=RegExReplace(txt,"\s*\d*$")


	swall[a_index]:=txt


}











size_title=16pt


size_text=8pt


line_height=12pt


size_indent:=substr(size_text,1,strlen(size_text)-2)*2 substr(size_text,strlen(size_text)-1,2)


size_table=7pt





YCChtml:="<html><head><meta http-equiv='Content-Type' content='text/html; charset=utf-8' /><title>YCC Report - " studyNo " " chartNo "</title><style type='text/css'>* {line-height: " line_height ";font-size:" size_text ";font-family: 'Times New Roman','新細明體';} .pagebr {	page-break-before: always;} .small td, .small tr {line-height:8pt;font-size: " size_table ";margin: 0; padding: 4px; border-width: 1px 1px 0 0; border-style: solid;}</style></head><body><p style='text-align:right'><table width='100%' border='0' cellspadding='0' cellspacing='0' align='central'><tr><td rowspan='2' width='75%'></td><td>StudyNumber: "(html(StudyNo) ? html(StudyNo) : "") "</td></tr><tr><td>StudyDate: " exdate2 "</td></tr></table></p><div style='line-height:20pt;font-size: " size_title ";text-align: center;'>N醫院影像醫學部X光透射錄影吞嚥檢查<br />Videofluoroscopic Swallowing Study (VFSS)</div> <p style='text-align:right'>(民國91年7月第3次修改)　　　　　</p> <table border='0' width='100%' cellspacing='0'>    <tr><td width='50%' align='left' valign='top' nowrap='nowrap'>日期：" ExDate2 "<br />      檢查編號：" html(StudyNo) "<br />    檢查單號：" html(accessno) "<br />    病歷號：" html(chartno) "<br />    姓名：" html(name) "<br />    年齡：" html(age) " " html(ageunit) "<br />    性別："








if !gender1


	ycchtml.="<u>　　　</u> 女 (0) <u>　Ｖ　</u> 男 (1)"


else


	ycchtml.="<u>　Ｖ　</u> 女 (0) <u>　　　</u> 男 (1)"





YCChtml.="</td><td width='50%' align='left' valign='top' nowrap='nowrap' >臨床診斷，病理診斷：<br />"





str:=" (　　　) CVA (1)<br />(　　　) Neurological disease other than CVA (2)<br />(　　　) NPC (3)<br />(　　　) Head/Neck tumor other than NPC (4)<br />(　　　) Trauma (5)<br />(　　　) Cerebral palsy (6)<br />(　　　) Other (7)" (trim(otherdx) ? ": " html(trim(otherdx)) : "")


loop 7


{


	var:="dx" a_index


	if(%var%)


		str:=RegExReplace(str,"is)(.*)\(　　　\)(.+?)\(" a_index "\)","$1(　Ｖ　)$2(" a_index ")"),break


}





YCChtml.= str "<br /></td></tr></table><p>主訴及症狀：<u>" html(complaint) "</u></p><p>吞嚥困難程度：<br />"





str:="(　　　) 0 無困難<br />(　　　) 1 有些不適，但飲食無礙<br />(　　　) 2 有困難，需飲食<br />(　　　) 3 相當困難，只能液體進食<br />(　　　) 4 即使吞嚥液體亦十分困難"


loop 5


{


	var:="diff" a_index


	if(%var%)


		str:=RegExReplace(str,"is)(.*\(　)　(　\)\s" a_index-1 ")","$1Ｖ$2"),break


}





str5:=str6:=str1:="<u>　　　　　　</u>年<u>　　　</u>月<u>　　　</u>日",str8="<u>　　　</u>",str9=str2="<u>　　　　　　　　</u>",str4=str3="否(　　　)、是(　　　)",str7="<u>　　　　　　</u>年<u>　　　</u>月",str10:=str9 "."


if CVAattack


	FormatTime,str1,% CVAattack,<u>　　yyyy　　</u>年<u>　MM　</u>月<u>　dd　</u>日


if CVAlocation


	str2:="<u>　　" html(CVAlocation) "　　</u>."


if NPCRT


{


	str3:="否(　　　)、是(　Ｖ　)"


	if RTStart


		FormatTime,str5,% RTstart,<u>　　yyyy　　</u>年<u>　MM　</u>月<u>　dd　</u>日


	if rtend


		FormatTime,str6,% RTend,<u>　　yyyy　　</u>年<u>　MM　</u>月<u>　dd　</u>日


	if NPCsymptom


	{


		str8:=npcsymptom


		str8-=a_now,days


		str8/=-30,str8:="<u>　" str8 "　</u>"


		FormatTime,str7,% NPCsymptom,<u>　　yyyy　　</u>年<u>　MM　</u>月


	}


	if RTtype


		str9:="<u>　　" html(rttype) "　　</u>"


	if rtdose


		str10:="<u>　　" html(rtdose) "　　</u>."


}


if NPCCT


	str4:="否(　　　)、是(　Ｖ　)"











YCChtml.= str "</p><p>1. CVA病患：last attack：" str1 "，Location in CT or MRI：" str2 "<br /> 2. NPC病患：<br /><span style='margin-left:" size_indent ";'>(1) 是否接受過R/T：" str3 "；是否接受化療：" str4 "<br /></span><span style='margin-left:" size_indent ";'>(2) R/T由" str5 "起至" str6 "完成<br /></span><span style='margin-left:" size_indent ";'>(3) 何時開始有吞嚥不正常：" str7 "起共" str8 "月<br /></span><span style='margin-left:" size_indent ";'>(4) Radiotherapy type:" str9 "、Radiotherapy dose: " str10 "</span></p>VFSS:<br /><div><table style='border-width: 0 0 1px 1px;border-spacing: 0; border-collapse: collapse; border-style: solid;' width='100%' border='1' align='center'  cellspacing='0' halign='center' class='small'>  <tr align='center'>    <td width='6%' rowspan='2'>　</td>    <td width='8%' rowspan='2'>檢查位置<br />      Lat/AP</td>    <td colspan='2'>Bolus</td>    <td colspan='3'>VFSS異常發現</td>    <td width='6%' rowspan='2'>L.P.</td>    <td width='6%' rowspan='2'>ASP.</td>    <td width='6%' rowspan='2'>Symp</td>    <td width='6%' rowspan='2'>Pre-</td>    <td width='6%' rowspan='2'>During</td>    <td width='6%' rowspan='2'>After</td>  </tr>  <tr align='center'>    <td width='10%'>Amount(mL)</td>    <td width='10%'>Consistency</td>    <td width='10%'>Oral transit time</td>    <td width='10%'>Phayrngeal transit time</td>    <td width='10%'>Swallowing trigger time</td>  </tr> "





tmpdata:=object()


loop 4


{


	i:=A_Index


	loop 4


	{


		j:=a_index,varName:="gridData" i+1 "_" j+1,varValue:=%varName%


		varValue:=RegExReplace(varValue,"\.+",".")


		RegExMatch(varValue,"(0\.\d+)|([1-9]\d*(\.\d+)?)",match)


		tmpdata[i,j]:=match


	}


	


	loop 6


	{


		j:=a_index+4,varName:=rowtitlearr2[j-4] i,var:=%varName%


		if j=7


		{


			guicontrolget,var,,%varName%


			if tmpdata[i,j-1] || tmpdata[i,j-2]


				tmpdata[i,j]:=symticarr[trim(var)]


			else


				tmpdata[i,j]:=-1


		}


		else


			tmpdata[i,j]:=var


	}


}








str1:="",j=1


loop 4


{


	if not (tmpdata[a_index,1]||tmpdata[a_index,2]||tmpdata[a_index,3]||tmpdata[a_index,4]||tmpdata[a_index,5]||tmpdata[a_index,6])


		continue


		


	str1.="<tr align='center'><td>" j "</td><td>Lat</td><td>5</td><td>" swall[a_index] "</td><td>" tmpdata[a_index,3]-tmpdata[a_index,1] "</td><td>" tmpdata[a_index,4]-tmpdata[a_index,2] "</td><td>" tmpdata[a_index,3]-tmpdata[a_index,2] "</td><td>" (tmpdata[a_index,5] ? "v" : "") "</td><td>" (tmpdata[a_index,6] ? "v" : "") "</td><td>" (symticarr2[tmpdata[a_index,7]]) "</td><td>" (tmpdata[a_index,8] ? "v" : "") "</td><td>" (tmpdata[a_index,9] ? "v" : "") "</td><td>" (tmpdata[a_index,10] ? "v" : "") "</td></tr>",j++


}








str:="<p><u>Oral phase</u><br /> <ol>  <li>Oral drooling: (　　　) no (0), (　　　) yes (1)</li>  <li>Bolus holding: (　　　) normal (0), (　　　) abnormal (1)</li>  <li>Oral stasis: (　　　) no (0), (　　　) trace (1), (　　　) significant (2)</li>  <li>Oral mucosal coating: (　　　) normal (0), (　　　) increased (1)</li>  <li>Premature oral leakage: (　　　) no (0), (　　　) small amount (1), (　　　) large amount (2)</li>  <li>Piecemeal swallowing: (　　　) no (0), (　　　) yes (1)</li>  <li>Tongue-palate contact: (　　　) normal (0), (　　　) abnormal (1)</li></ol></p><p  class='pagebr'>　</p><p style='text-align:right' ><table width='100%' border='0' cellspadding='0' cellspacing='0' align='central'><tr><td rowspan='2' width='75%'></td><td>StudyNumber: "(html(StudyNo) ? html(StudyNo) : "") "</td></tr><tr><td>StudyDate: " exdate2 "</td></tr></table></p><u>Pharyngeal phase</u><ol><li>Swallowing trigger:</li><br /><u>　　　</u> " swall[1] ": (　　　) normal&lt;1s (0), (　　　) delayed 1-2s (1), (　　　) delayed 2-3s (2), (　　　) delayed>3s (3)<br /><u>　　　</u> " swall[2] ": (　　　) normal&lt;1s (0), (　　　) delayed 1-2s (1), (　　　) delayed 2-3s (2), (　　　) delayed>3s (3)<br /><u>　　　</u> " swall[3] ": (　　　) normal&lt;1s (0), (　　　) delayed 1-2s (1), (　　　) delayed 2-3s (2), (　　　) delayed>3s (3)<br /><u>　　　</u> " swall[4] ": (　　　) normal&lt;1s (0), (　　　) delayed 1-2s (1), (　　　) delayed 2-3s (2), (　　　) delayed>3s (3)<li>Vallecular stasis: (　　　) no (0), (　　　) small amount (1), (　　　) large amount (2)</li><li>Pyriform sinus stasis: (　　　)  no (0), (　　　) small amount (1), (　　　) large amount (2)</li><li>Velar elevation: (　　　) normal and complete (0), (　　　) abnormal and incomplete (1)</li><li>Pharyngeal contraction: (　　　) normal (0), (　　　) visible air gap" ( !pc1 && html(pc3) ? " (" html(pc3) ")" : "" ) " (1)</li><li>Hyoid bone elevation: (　　　) normal and complete (0), (　　　) abnormal and incomplete (1)</li><li>Epiglottic movement: (　　　) normal (0), (　　　) flattening (1), (　　　) fixed (2)</li><li>Laryngeal penetration: (　　　) no (0), (　　　) yes (1)</li><li>Aspiration: (　　　) no (0), (　　　) trace (1), (　　　) minor (2), (　　　) major (3)</li><br />Aspiration: (　　　) symptomatic (0), (　　　) silent (1)<br />Aspiration: (　　　) pre-swallowing (0), (　　　) during (1), (　　　) after (2)<br />Aspiration: (　　　) " swall[1] " (0), (　　　) " swall[2] " (1), (　　　) " swall[3] " (2), (　　　) " swall[4] " (3)<li>Pharyngeal mucosal coating: (　　　) normal (0), (　　　) abnormally increased (1)</li><li>Pharyngo-oral reflux: (　　　) no (0), (　　　) yes (1)</li><li>Pharyngo-nasal reflux: (　　　) no (0), (　　　) yes (1)</li><li>Symmetry of bolus passage from the pharynx to esophagus: (　　　) symmetric (0), (　　　) asymmetric with right predominance (1), (　　　) asymmetric with left predominance (2)</li><li>Increased retropharyngeal soft tissue: (　　　) no (0), (　　　) yes (1)</li></ol>"





for k1,v1 in findingarr


	for k2,v2 in v1


	{


		heading:=v2[1]


		varName:=v2[2],varArrName:=varName "Arr",varArr:=%varArrName%


		loop % varArr.maxindex()


		{


			var:=varName a_index


			if(%var%)


				str:=regexreplace(str,"is)(" heading "[^<]*?\(　)　(　\)[^,<]*?\(" a_index-1 "\))","$1Ｖ$2")


		}


	}


for k,v in swall


{


	heading:=v


	if not (tmpdata[a_index,1]||tmpdata[a_index,2]||tmpdata[a_index,3]||tmpdata[a_index,4]||tmpdata[a_index,5]||tmpdata[a_index,6])


	{


		str:=regexreplace(str,"<u>　　　</u> " heading,"<u>　Ｘ　</u> " heading)


		continue


	}


	if !tmpdata[a_index,2] || !tmpdata[a_index,3]


		code=3


	else


	{


		trig:=tmpdata[a_index,3]-tmpdata[a_index,2]


		if(!trig)


			str:=regexreplace(str,"<u>　　　</u> " heading,"<u>　Ｘ　</u> " heading)


		else if trig<1


			code=0


		else if trig<2


			code=1


		else if trig<3


			code=2


		else


			code=3


	}


	str:=regexreplace(str,"is)(" heading ":[^<]*?\(　)　(　\)[^,<]*?\(" code "\))","$1Ｖ$2")	


}


tmp:=[0,"",0,0,0,0]


; if any asp, most prominent symp, if pre, if during, if post, if any LP


loop 4


{


	i:=a_index


	tmp[1]:=tmp[1] | tmpdata[i,6]


	tmp[2].=(tmpdata[i,7]<=0 ? 0 : tmpdata[i,7] )


	loop 3


		tmp[a_index+2]:=tmp[a_index+2] | tmpdata[i,a_index+7]


	tmp[6]:=tmp[6] | tmpdata[i,5]


}





studyDone:=false


for k1,v1 in tmpdata


	for k2,v2 in v1


		studyDone:= v2<=0 ? studyDone|true : studyDone|false


	


if studyDone


{


	if tmp[6]


		str:=regexreplace(str,"is)(Laryngeal penetration[^<]*?\(　)　(　\)[^,<]*?yes)","$1Ｖ$2")


	else


		str:=regexreplace(str,"is)(Laryngeal penetration[^<]*?\(　)　(　\)[^,<]*?no)","$1Ｖ$2")


	


	;;;; question?


	if tmp[1]


		str:=regexreplace(str,"is)(Aspiration[^<]*?\(　)　(　\)[^,<]*?trace)","$1Ｖ$2")


	else


		str:=regexreplace(str,"is)(Aspiration[^<]*?\(　)　(　\)[^,<]*?no)","$1Ｖ$2")


	;~ sympExt:=tmp[2]


	;~ if sympExt contains 3 ;major


		;~ str:=regexreplace(str,"is)(Aspiration[^<]*?\(　)　(　\)[^,<]*?major)","$1Ｖ$2")


	;~ else if sympExt contains 2 ;minor


		;~ str:=regexreplace(str,"is)(Aspiration[^<]*?\(　)　(　\)[^,<]*?minor)","$1Ｖ$2")


	;~ else if sympExt contains 1 ;trace


		;~ str:=regexreplace(str,"is)(Aspiration[^<]*?\(　)　(　\)[^,<]*?trace)","$1Ｖ$2")


	;~ else ;if sympExt contains 0 ;no


		;~ str:=regexreplace(str,"is)(Aspiration[^<]*?\(　)　(　\)[^,<]*?no)","$1Ｖ$2")


	


	if tmp[1]


	{


	


		if !RegExMatch(tmp[2],"^0+$")


			str:=regexreplace(str,"is)(Aspiration[^<]*?\(　)　(　\)[^,<]*?symptomatic)","$1Ｖ$2")


		else 


			str:=regexreplace(str,"is)(Aspiration[^<]*?\(　)　(　\)[^,<]*?silent)","$1Ｖ$2")





		if tmp[3]


			str:=regexreplace(str,"is)(Aspiration[^<]*?\(　)　(　\)[^,<]*?pre-swallowing)","$1Ｖ$2")


		if tmp[4]


			str:=regexreplace(str,"is)(Aspiration[^<]*?\(　)　(　\)[^,<]*?during)","$1Ｖ$2")


		if tmp[5]


			str:=regexreplace(str,"is)(Aspiration[^<]*?\(　)　(　\)[^,<]*?after)","$1Ｖ$2")





		loop 4


		{


			which:=tmpdata[a_index,6]


			if which


				str:=regexreplace(str,"is)(Aspiration[^<]*?\(　)　(　\)[^,<]*?" swall[a_index] ")","$1Ｖ$2")


		}


	}


}


str3=


loop,parse,comment,`n


	if trim(a_loopfield)


		str3.="<span style='margin-left:1em'>" a_loopfield "<br /></span>"





str2=


loop,parse,conclusion,`n


	if trim(a_loopfield)


		str2.="<span style='margin-left:1em'>" a_loopfield "<br /></span>"





YCChtml.= str1 "</table></div><p>　</p><p><strong>VFSS findings:</strong></p>" str "<p><span style='font-size:10pt'>Other comments:</span><br /><span style='text-indent:8pt;'>" str3 "</span></p><p><span style='font-size:10pt'>Conclusion of VFSS:</span><br /><span style='text-indent:" size_indent ";'>" str2 "</span></p><p align='right' style='font-size:10pt'>" html(examiner1) " / " html(examiner2) "</p></body></html>"








;~ while(!savedFile)


	;~ gosub saveFile











;~ msgbox % path


if (chartno && StudyNo)


	file_name:="YCC Report - " studyno " " chartNo


else


	file_name=YCC Report





if !batching


	file_name:=folderOf(selectedfile) . file_name














file_ind=1


if fileexist(tmp:=file_name ".html")


	while fileexist(tmp:=file_name " (" file_ind ").html")


		file_ind++





;~ FileDelete,%tmp%


fileappend,% ycchtml,%tmp%,UTF-8


if !batching


	run,%tmp%


printing:=0


;~ WinWaitActive,%tmp%,Videofluoroscopic Swallowing Study





;~ winactivate,YCC Report


;~ send {F5}





;~ clpbd:=clipboardall


;~ clipboard:=ycchtml


;~ msgbox % clipboard


;~ fileappend,% clipboardall,YCC Report.txt,UTF-8


;~ clipboard:=clpbd


/* if fileexist("VFSS.exe")


 * 	run,VFSS.exe


 * winwait,VFSS ahk_class TForm1


 * winget,VFSSid,id


 * winget,VFSSpid,pid


 * ;~ txtVar:=["StudyNo","ExDate","AccessNo","ChartNo","Name","Age","AgeUnit","OtherDx","PtFrom","Complaint","CVAAttack","CVALocation","NPCRT","NPCCT","RTStart","RTEnd","NPCSymptom","RTType","RTDose","comment","conclusion","examiner1","examiner2"]


 * ;~ radioVar:=["Gender","Dx","Diff","bh","od","pol","vs","ve","por","sym","tpc","ps","pc","pss","hbe","pnr","os","omc","pmc","em","rst"]


 * 


 * txtVFSSVar:=["TEdit12","","TEdit11","TEdit13","TEdit14","TEdit15","","TEdit9","Edit2","TEdit8","TEdit2","TEdit1","","","TEdit7","TEdit6","TEdit5","TEdit4","TEdit3","TMemo2","TMemo1","Edit1",""]


 * radioVFSSvar:=[[14,13],[12,11,10,9,8,7,6],[5,4,3,2,1],[17,16],[19,18],[15,14,13],[22,21,20],[24,23],[26,25],[29,28,27],[12,11],[10,9],[8,7,6],[5,4,3],[2,1],[31,30],[43,42,41],[40,39],[38,37],[36,35,34],[33,32]]


 * 


 * 


 * if Exdate


 * 	controlsettext,TEdit10,% substr(exdate,1,4) "/" substr(exdate,5,2) "/" substr(exdate,7,2)


 * if NPCRT


 * 	control,check,,TCheckBox2


 * if NPCCT


 * 	control,check,,TCheckBox1


 * for k,v in txtVar


 * {


 * 	if not tgt:=txtVFSSVar[a_index]


 * 		continue


 * 	srcValue:=%v%


 * 	if not srcValue


 * 		continue


 * 	controlsettext,% tgt,% srcValue


 * }


 * 


 * for k,v in radioVar


 * {


 * 	if k=3


 * 		SwitchToTabN("TPageControl1",2),sleep 10 


 * 	varArrName:=v "Arr",varArr=%varArrName%


 * 	for k1,v1 in varArr


 * 	{


 * 		varName:=v k1


 * 		if(%varName%)


 * 		{


 * 			radioNo:=radioVFSSvar[k,k1]


 * 			control,check,,% "TRadioButton" radioNo


 * 			break


 * 		}


 * 	}


 * }


 * 


 * ;~ SwitchToTabN("TPageControl1",1)


 * ;~ Controlsettext,tstringgrid1.cells[1,1],test


 * 


 * ;~ stringgrid:=[2,4,5,9]


 * ;~ loop 4


 * ;~ {


 * 	;~ i:=a_index


 * 	;~ srcData:=object()


 * 	;~ loop 4


 * 	;~ {


 * 		;~ j:=a_index


 * 		;~ srcDataName:="dataGrid" i+1 j+1,srcDataValue:=%srcDataName%


 * 		;~ srcData.push(srcDataValue)


 * 	;~ }


 * ;~ }


 * 


 * 


 */





return





VAGedit:


gui,submit,nohide


inputbox,pc3,Visible air gap,Enter some description:,,300,150,,,,,visible air gap


return





html(str)


{


	StringReplace,str,str,&,&amp;,all


	StringReplace,str,str,%a_space%%a_space%,　,all


	StringReplace,str,str,%a_space%,&nbsp;,all


	StringReplace,str,str,",&quot;,all


	StringReplace,str,str,<,&lt;,all


	StringReplace,str,str,>,&gt;,all


	return str


}


	


	





GuiClose:


onexit:


~!q::


;~ process,close,% VFSSpid


;~ winactivate,VFSS2.ahk


exitapp


