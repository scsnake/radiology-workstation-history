﻿﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.


SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.


SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


#SingleInstance,off


SetBatchLines, -1


coordMode,mouse,screen


coordMode,pixel,screen


coordMode,tooltip,screen


SetTitleMatchMode,2


setformat,float,0.2


SetControlDelay,-1





gui,+border +lastfound


WinGet,guiHwnd,id





Gui, Font, S8 CDefault, Verdana


Gui, Add, Tab2, vtab_choosen gtab_select w845 h320, % "Patient Data|Swallowing Time|Swallowing Finding|Conclusion"





gui,tab,1








gui,add,text,section h20,Study No


gui,add,text,xs y+5 hp,Exam Date


gui,add,text,xs y+5 hp,Access No


gui,add,text,xs y+5 hp,Chart No


gui,add,text,xs y+5 hp,Name


gui,add,text,xs y+5 hp,Age


gui,add,text,xs y+5 hp,Gender


gui,add,edit,xs+70 ys vSerialNo w120 h20


gui,add,DateTime,xp y+5 vExDate wp hp


gui,add,edit,xp y+5 vAccessNo wp hp Uppercase limit11


gui,add,edit,xp y+5 vChartNo wp hp Uppercase limit7


gui,add,edit,xp y+5 vName wp hp 


gui,add,edit,xp y+5 vAge w60 hp


gui,add,edit,x+0 vAgeUnit wp hp,y/o


GenderArr:=["♀","♂"]


gui,add,radio,xs+70 y+5 vGender1 hp Checked group,♀


gui,add,radio,x+20 hp vGender2,♂








gui,add,groupbox,xs+200 ys-5 w210 h190


DxArr:=["CVA","Neurological dz not CVA","NPC","H/N tumor not NPC","Trauma","Cerebral palsy","Others"]


gui,add,radio,xp+10 yp+10 h20 vDx1 group,CVA


loop 6


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


loop 4


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


rowTitleArr2:=["LP","Asp","Symtic","Pre","During","Post"],SymticArr:={"no":0,"trace":1,"minor":2,"major":3},SymticArr2:=["no","trace","minor","major"]


gui,add,text,% "section y" firstEdity " x+30",LP


loop 5


	gui,add,text,% "xp+" colwidth2[a_index] " yp",% rowtitlearr2[a_index+1]





loop 4


{


	i:=a_index


	str:="LP",yset:="ys+" rowInterval+firstEdith " section "


	gui,add,checkbox,% "xs " yset " v" str i " gtogglePF"


	str:="Asp",xyset:="xp+" colwidth2[1] " yp"


	gui,add,checkbox,% xyset " v" str i " gtogglePF"


	


	loop 4


	{


		j:=a_index+2


		if j=3


			gui,add,text,% "disabled w" colwidth2[j-1] " xp+" colwidth2[j-1] " yp v" rowTitlearr2[j] i " gtoggleSym",% "no   "


		else


			gui,add,checkbox,% "disabled xp+" colwidth2[j-1] " yp v" rowTitlearr2[j] i


	}


	


}











gui,tab,3


FindingArr:=[[ ["Bolus holding","bh"], ["Oral drooling","od"], ["Premature oral leakage","pol"], ["Oral mucosal coating","omc"], ["Oral stasis","os"], ["Epiglottic movement","em"], ["Velar elevation","ve"], ["Pharyngo-oral reflux","por"], ["Symmetry","sym"]],[ ["Tongue-palate contact","tpc"], ["Piecemeal swallowing","ps"], ["Pharyngeal contraction","pc"], ["Pharyngeal mucosal coating","pmc"], ["Vallecular stasis","vs"], ["Pyriform sinus stasis","pss"], ["Hyoid bone elevation","hbe"], ["Pharyngo-nasal reflux","pnr"], ["Retropharyngeal soft tissue","rst"]]]


bhArr:=["Normal","Abnormal"],odArr:=["No","Yes"],polArr:=["No","<1/2",">1/2"],omcArr:=["Normal","Abnormal"],osArr:=["No","Trace","Significant"],emArr:=["Normal","Gr.1","Gr.2 fixed"],veArr:=["Normal","Abnormal"],porArr:=["No","Yes"],symArr:=["Normal","Right","Left"],tpcArr:=["No","Yes"],psArr:=["No","Yes"],pcArr:=["Normal","<1/2",">1/2"],pmcArr:=["No","Yes"],vsArr:=["No","<1/2",">1/2"],pssArr:=["No","<1/2",">1/2"],hbeArr:=["Normal","Abnormal"],pnrArr:=["No","Yes"],rstArr:=["Normal","Increased"]


boxWidth:=400,boxHeight=30,txtStartx=10,txtStarty=10,interval1=165,interval2=[[140],[70,70]],colSpan=420,rowInterval=5





gosub GUIFinding





gui,add,button,xs-140 y+10 gSetNormal,Set non-selected buttons as no or normal


gui,add,button,x+220 yp gReset,Reset all





gui,tab,4








gui,add,text,section,Other Comment:


gui,add,edit,r5 xs y+5 w800 vcomment


gui,add,text,xs y+10,Conclusion of VFSS:


gui,add,edit,r5 xs y+5 w800 vconclusion


gui,add,text,xs y+40,Examiner


gui,add,edit,r1 x+20 yp w120 vexaminer1,% " 醫師"


gui,add,text,x+5 yp,/


gui,add,edit,r1 x+5 yp w120 vexaminer2,張醫師








;--------------------------MENU





menu,FileM,add,&New	Ctrl+N,MenuHandler


menu,FileM,add,&Open	Ctrl+O,MenuHandler


menu,FileM,add,&Save	Ctrl+S,MenuHandler


menu,FileM,add,&Export to Notepad	Ctrl+E,MenuHandler


menu,FileM,add


menu,FileM,add,&Quit	Ctrl+Q,MenuHandler


menu,VFSSmenu,add,&File,:FileM


menu,HelpM,add,&About,MenuHandler


menu,VFSSmenu,add,&Help,:HelpM


menu,VFSSmenu,add,&YCC Report,MenuHandler


gui,menu,VFSSmenu





;----------------------------





gui,show,xCenter yCenter w865 h340,VFSS Reporting System 2











txtVar:=["SerialNo","ExDate","AccessNo","ChartNo","Name","Age","AgeUnit","OtherDx","PtFrom","Complaint","CVAAttack","CVALocation","NPCRT","NPCCT","RTStart","RTEnd","NPCSymptom","RTType","RTDose","comment","conclusion","examiner1","examiner2"]


radioVar:=["Gender","Dx","Diff","bh","od","pol","vs","ve","por","sym","tpc","ps","pc","pss","hbe","pnr","os","omc","pmc","em","rst"]





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


	msgbox,,About,VFSS Reporting System 2 v1.02`n`n`t`t...modified from Dr. Chung-Wei Lee (2004)`n`n`n`t`tChen Yi-Chang,`n`t`tDepartment of Medical Imaging, N Hospital


else if a_thismenuitem=&YCC Report


	gosub printYCC





return





exportFile:


gui,submit,nohide


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





export=Clinical history:`nVideofluoroscopic swallowing study with barium meal in thin 5mL, thick 5mL, paste 5mL, pudding 5mL in lateral view, and thin 5mL in AP view shows: (S/N: %SerialNo%)`n





export.="1. Oral phase:`n   - Oral drooling: " lc(od) "`n   - Bolus holdling: " lc(bh) "`n   - Oral stasis: " lc(os) "`n   - Oral mucosal coating: " lc(omc) "`n   - Premature oral leakage: " lc(pol) "`n   - Piecemeal swallowing: " lc(ps) "`n   - Tongue-palate contact: " lc(tpc) "`n"





export.="2. Swallowing time: `n   - Oral transit time (normal<2s): `n      thin 5:    " gridData2_4-gridData2_2 "s`n      thick 5:   " gridData3_4-gridData3_2 "s`n      paste 5:   " gridData4_4-gridData4_2 "s`n      pudding 5: " gridData5_4-gridData5_2 "s`n"


export.="   - Pharyngeal transit time (normal<1s): `n      thin 5:    " gridData2_5-gridData2_3 "s`n      thick 5:   " gridData3_5-gridData3_3 "s`n      paste 5:   " gridData4_5-gridData4_3 "s`n      pudding 5: " gridData5_5-gridData5_3 "s`n"


export.="   - Swallowing trigger (normal<1s): `n      thin 5:    " gridData2_4-gridData2_3 "s`n      thick 5:   " gridData3_4-gridData3_3 "s`n      paste 5:   " gridData4_4-gridData4_3 "s`n      pudding 5: " gridData5_4-gridData5_3 "s`n"





;---------------------------


LParr:=object(),timing:=["before","during","after"],str:=""


loop 4


{


	i:=A_Index


	loop 6


	{


		j:=a_index


		var:= rowtitlearr2[j] i


		if j=3


		{


			guicontrolget,val,,%var%


			val:=trim(val),LParr[i,j]:=symticarr[val]


		}


		else


			LParr[i,j]:=%var%


	}


}





str=


loop 4


{


	i:=a_index


	if ! lparr[i,1]


		continue


	else if LParr[i,3]


		str.= "symptomatic "


	else


		str.="asymptomatic "


	


	loop 3


	{


		j:=A_Index


		if LParr[i,j+3]


			str.=timing[j] "/"


	}


	str:=RegExReplace(str,"/$","")


	str.=" swallowing in " swall[i] " bolus study, "


}


if not str


	str:="no"


str:=RegExReplace(str,",\s$",""),str:=RegExReplace(str,"\s{2}","\s")


str.="."


export.="   - Laryngeal penetration: " str "`n"





str=


loop 4


{


	i:=a_index


	if not lparr[i,2]


		continue


	else if lparr[i,3]


		str.= "symptomatic "


	else


		str.="asymptomatic "


	


	loop 3


	{


		j:=A_Index


		if lparr[i,j+3]


			str.=timing[j] "/"


	}


	str:=RegExReplace(str,"/$","")


	str.=" swallowing in " swall[i] " bolus study, "


}


if not str


	str:="no"


str:=RegExReplace(str,",\s$",""),str:=RegExReplace(str,"\s{2}","\s")


str.="."


export.="   - Aspiration: " str "`n"


;-----------------------------------------------------------------------------








if pc=<1/2


	pc=mildly decreased


else if pc=>1/2


	pc=markedly decreased





export.="3. Pharyngeal phase:`n   - Vallecular stasis: " (vs<>"No" ? "yes(" vs ")" : "no") "`n   - Pyriform sinus stenosis: " (pss<>"No" ? "yes(" pss ")" : "no") "`n   - Velar elevation: " (ve="Normal" ? "normal and complete" : "incomplete") "`n   - Pharyngeal contraction: " lc(pc) "`n   - Hyoid bone elevation: " (hbe="Normal" ? "normal and complete" : "incomplete") "`n   - Epiglottic movement: " (em="Normal" ? lc(em) : em) "`n   - Pharyngeal mucosal coating: " lc(pmc) "`n   - Pharyngo-oral reflux: " lc(por) "`n   - Pharyngo-nasal reflux: " lc(pnr) "`n   - Retropharyngeal soft tissue: " lc(rst) "`n   - Bolus pass into esophagus: " (sym="Normal" ? "symmetric" : "asymmetric") "`n"





export.="4. Other finding:`n"


loop,parse,comment,`n


	if trim(a_loopfield)


		export.="   " trim(a_loopfield) "`n"








export.="5. Conclusion of VFSS:`n"


loop,parse,conclusion,`n


	if trim(a_loopfield)


		export.="   " trim(a_loopfield) "`n"











if SelectedFile


	txtFile:=RegExReplace(SelectedFile,".vfs2$",".txt")


else


{


	fileName:= (SerialNo && ChartNo ? SerialNo "-" ChartNo ".txt" : "")


	FileSelectFile,txtFile,,% a_workingdir "\" fileName,Text file (*.txt)


}





filedelete,% txtFile


FileAppend,% export,% txtFile,UTF-8


if not errorlevel


{


	run % txtFile


	traytip,,% "Export to " txtFile " successfully!",5


}


else


	traytip,,% "Oops...,Failure to export!",5





return





renew:


msgbox,1,,Any unsaved data will be cleared!!


ifMsgBox Cancel


	return





gosub clear


return





clear:


for k,v in txtVar


	guicontrol,,%v%,





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


		var:=rowtitlearr2[j] i,


		if j>2


			guicontrol,disable,% var


		if j=3


			guicontrol,,% var,no


		else


			guicontrol,,% var,0


		


	}


}





guicontrol,,gender1,1


guicontrol,,ageunit,y/o


guicontrol,,ptfrom,OPD


guicontrol,,examiner1,% " 醫師"


guicontrol,,examiner2,張醫師


return





openFile:


gui,+owndialogs


FileSelectFile,SelectedFile,,%a_workingdir%,Open VFSS,VFSS (*.vfs2)


if not SelectedFile


	return


FileRead,datadump,% SelectedFile


gosub clear


loop,parse,datadump,`,


{


	RegExMatch(a_loopfield,"is).+?(?=\s)",varName)


	varValue:=SubStr(a_loopfield,strlen(varName)+2)


	if varName=data


	{


		StringReplace,varValue,varValue,|\,\,all


		loop,parse,varValue,\


		{


			i:=A_Index


			loop,parse,a_loopfield,|


			{


				j:=a_index


				if a_loopfield


				{


					gridVar:="gridData" i+1 "_" j+1


					guicontrol,,%gridVar%,%a_loopfield%


				}


			}


		}


	}


	else if varName in Gender,Dx,Diff,bh,od,pol,vs,ve,por,sym,tpc,ps,pc,pss,hbe,pnr,os,omc,pmc,em,rst


		guicontrol,,%varName%%varValue%,1


	else


		guicontrol,,%varName%,% varValue


	


}


return





saveFile:


gosub dump


fileName:= (SerialNo && ChartNo ? SerialNo "-" ChartNo ".vfs2" : "")


if not SelectedFile


{


	gui,+owndialogs


	FileSelectFile,SelectedFile,S,%a_workingdir%\%fileName%,Save VFSS,VFSS (*.vfs2)


}





if not SelectedFile


	return


else if not RegExMatch(SelectedFile,".vfs2$")


	SelectedFile.=".vfs2"





FileDelete,% SelectedFile


FileAppend,%datadump%,*%SelectedFile%,UTF-8





if not errorlevel


	msgbox % "Save to " SelectedFile " successfully!"


else


	msgbox,16,Oops...,Failure to save!








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


	loop 10


	{


		j:=A_Index+1


		datadump.=gridData%i%_%j% "|"


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


			gui,font,w700


			gui,add,edit,% "disabled readonly " gridFormat " vgridData" row "_" col,% rowTitleArr[row-1]


			gui,font,w400


		}


		else


			gui,add,edit,%gridFormat% vgridData%row%_%col%,% dataArrRC[row-1,col-1]


	}


	


}


return





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





#ifwinactive VFSS reporting system


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


#ifwinactive





printYCC:


;~ txtVar:=["SerialNo","ExDate","AccessNo","ChartNo","Name","Age","AgeUnit","OtherDx","PtFrom","Complaint","CVAAttack","CVALocation","NPCRT","NPCCT","RTStart","RTEnd","NPCSymptom","RTType","RTDose","comment","conclusion","examiner1","examiner2"]


;~ radioVar:=["Gender","Dx","Diff","bh","od","pol","vs","ve","por","sym","tpc","ps","pc","pss","hbe","pnr","os","omc","pmc","em","rst"]








gui,submit,nohide


FormatTime,Exdate2,% exdate,yyyy/MM/dd








YCChtml:="<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'><html xmlns='http://www.w3.org/1999/xhtml'><head><meta http-equiv='Content-Type' content='text/html; charset=utf-8' /><title>YCC Report</title><style type='text/css'>* {font-size:6pt;font-family: '微軟正黑體', Verdana, 'Arial Unicode MS', Tahoma, 'Times New Roman', '標楷體', '新細明體';} .pagebr {	page-break-before: always;}li .indent1 {	margin-left: 16pt;	text-indent:-16pt;}</style></head><body><p style='text-align:right'><table width='100%' border='0' cellspadding='0' cellspacing='0' align='right'><tr><td rowspan='2' width='80%'></td><td>StudyNumber: "(html(serialno) ? html(serialno) : "") "</td></tr><tr><td>StudyDate: " exdate2 "</td></tr></table></p><div style='font-size: 18pt;text-align: center;'>N醫院影像醫學部X光透射錄影吞嚥檢查<br />Videofluoroscopic Swallowing Study (VFSS)</div> <p style='text-align:right'>(民國91年7月第3次修改)　　　　　</p> <table border='0' width='100%' cellspacing='0'>    <tr><td width='50%' align='left' valign='top' nowrap='nowrap'>日期：" ExDate2 "<br />      檢查編號：" html(serialno) "<br />    檢查單號：" html(accessno) "<br />    病歷號：" html(chartno) "<br />    姓名：" html(name) "<br />    年齡：" html(age) " " html(ageunit) "<br />    性別："





if gender1


	ycchtml.="<u>　　　</u> 女 (0) <u>　　　</u> 男 (1)"


else if gender 2


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





str5:=str6:=str1:="<u>　　　　　　</u>年<u>　　　</u>月<u>　　　</u>日",str8="<u>　　　</u>",str9=str10=str2="<u>　　　　　　　　</u>",str4=str3="否(　　　)、是(　　　)",str7="<u>　　　　　　</u>年<u>　　　</u>月"


if CVAattack


	FormatTime,str1,% CVAattack,<u>　　yyyy　　</u>年<u>　MM　</u>月<u>　dd　</u>日


if CVAlocation


	str2:="<u>　　" html(CVAlocation) "　　</u>"


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


		str10:="<u>　　" html(rtdose) "　　</u>"


}


if NPCCT


	str4:="否(　　　)、是(　Ｖ　)"











YCChtml.= str "</p><p>1. CVA病患：last attack：" str1 "，Location in CT or MRI：" str2 "<br /> 2. NPC病患：<br /><span style='margin-left:12pt;'>(1) 是否接受過R/T：" str3 "；是否接受化療：" str4 "<br /></span><span style='margin-left:12pt;'>(2) R/T由" str5 "起至" str6 "完成<br /></span><span style='margin-left:12pt;'>(3) 何時開始有吞嚥不正常：" str7 "起共" str8 "月<br /></span><span style='margin-left:12pt;'>(4) Radiotherapy type:" str9 "、Radiotherapy dose: " str10 "</span></p>VFSS:<br /><div style='font-size: 4px'><table width='100%' border='1' align='center'  cellspacing='0' halign='center'>  <tr align='center'>    <td width='6%' rowspan='2'>　</td>    <td width='8%' rowspan='2'>檢查位置<br />      Lat/AP</td>    <td colspan='2'>Bolus</td>    <td colspan='3'>VFSS異常發現</td>    <td width='6%' rowspan='2'>L.P.</td>    <td width='6%' rowspan='2'>ASP.</td>    <td width='6%' rowspan='2'>Symp</td>    <td width='6%' rowspan='2'>Pre-</td>    <td width='6%' rowspan='2'>During</td>    <td width='6%' rowspan='2'>After</td>  </tr>  <tr align='center'>    <td width='10%'>Amount(mL)</td>    <td width='10%'>Consistency</td>    <td width='10%'>Oral transit time</td>    <td width='10%'>Phayrngeal transit time</td>    <td width='10%'>Swallowing trigger time</td>  </tr> "





tmpdata:=object()


loop 4


{


	i:=A_Index


	loop 4


	{


		j:=a_index,varName:="gridData" i+1 "_" j+1,varValue:=%varName%


		tmpdata[i,j]:=trim(varValue)


	}


	


	loop 6


	{


		j:=a_index+4,varName:=rowtitlearr2[j-4] i,var:=%varName%


		if j=7


		{


			guicontrolget,var,,%varName%


			tmpdata[i,j]:=symticarr[trim(var)]


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








str:="<p><u>Oral phase</u><br /> <ol>  <li>Oral drooling: (　　　) no (0), (　　　) yes (1)</li>  <li>Bolus holding: (　　　) normal (0), (　　　) abnormal (1)</li>  <li>Oral stasis: (　　　) no (0), (　　　) trace (1), (　　　) significant (2)</li>  <li>Oral mucosal coating: (　　　) normal (0), (　　　) increased (1)</li>  <li>Premature oral leakage: (　　　) no (0), (　　　) yes &#44;small&lt;1/2 (1), (　　　) yes &#44;large&gt;1/2 (2)</li>  <li>Piecemeal swallowing: (　　　) no (0), (　　　) yes (1)</li>  <li>Tongue-palate contact: (　　　) normal (0), (　　　) abnormal (1)</li></ol></p><p style='text-align:right'  class='pagebr'><table width='100%' border='0' cellspadding='0' cellspacing='0' align='right'><tr><td rowspan='2' width='80%'></td><td>StudyNumber: "(html(serialno) ? html(serialno) : "") "</td></tr><tr><td>StudyDate: " exdate2 "</td></tr></table></p><u>Pharyngeal phase</u><ol><li>Swallowing trigger:</li><u>　　　</u> thin: (　　　) normal&lt;1s (0), (　　　) delayed 1-2s (1), (　　　) delayed 2-3s (2), (　　　) delayed>3s (3)<br /><u>　　　</u> thick: (　　　) normal&lt;1s (0), (　　　) delayed 1-2s (1), (　　　) delayed 2-3s (2), (　　　) delayed>3s (3)<br /><u>　　　</u> paste: (　　　) normal&lt;1s (0), (　　　) delayed 1-2s (1), (　　　) delayed 2-3s (2), (　　　) delayed>3s (3)<br /><u>　　　</u> pudding: (　　　) normal&lt;1s (0), (　　　) delayed 1-2s (1), (　　　) delayed 2-3s (2), (　　　) delayed>3s (3)<li>Vallecular stasis: (　　　) no (0), (　　　) less than 1/2 (1), (　　　) larger than 1/2 (2)</li><li>Pyriform sinus stasis: (　　　)  no (0), (　　　) less than 1/2 (1), (　　　) larger than 1/2 (2)</li><li>Velar elevation: (　　　) normal and complete (0), (　　　) abnormal and incomplete (1)</li><li>Pharyngeal contraction: (　　　) normal (0), (　　　) mildly decreased or air gap &lt;1/2 (1), (　　　) markedly decreased or air gap &gt; 1/2 (2)</li><li>Hyoid bone elevation: (　　　) normal and complete (0), (　　　) abnormal and incomplete (1)</li><li>Epiglottic movement: (　　　) normal (0), (　　　) abnormal&#44; grade 1&#44; lack of 2nd movement (inversion) (1), (　　　) abnormal&#44; grade 2&#44; lack of 1st movement (persistent upright position) (2)</li><li>Laryngeal penetration: (　　　) no (0), (　　　) yes (1)</li><li>Aspiration: (　　　) no (0), (　　　) trace (1), (　　　) minor (2), (　　　) major (3)</li>Aspiration: (　　　) symptomatic (0), (　　　) silent (1)<br />Aspiration: (　　　) pre-swallowing (0), (　　　) during (1), (　　　) after (2)<br />Aspiration: (　　　) thin (0), (　　　) thick (1), (　　　) paste (2), (　　　) pudding (3)<li>Pharyngeal mucosal coating: (　　　) normal (0), (　　　) abnormally increased (1)</li><li>Pharyngo-oral reflux: (　　　) no (0), (　　　) yes (1)</li><li>Pharyngo-nasal reflux: (　　　) no (0), (　　　) yes (1)</li><li>Symmetry of bolus passage from the pharynx to esophagus: (　　　) symmetric (0), (　　　) asymmetric with right predominance (1), (　　　) asymmetric with left predominance (2)</li><li>Increased retropharyngeal soft tissue: (　　　) no (0), (　　　) yes (1)</li></ol>"





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


	str:=regexreplace(str,"is)(" heading "[^<]*?\(　)　(　\)[^,<]*?\(" code "\))","$1Ｖ$2")	


}


tmp:=[0,0,0,0,0,0]


loop 4


{


	i:=a_index


	tmp[1].=tmpdata[i,6]


	loop 4


		tmp[a_index+1]:=tmp[a_index+1] | tmpdata[i,a_index+6]


	tmp[6]:=tmp[6] | tmpdata[i,5]


}





studyDone:=false


for k1,v1 in tmpdata


	for k2,v2 in v1


		studyDone:= v2 ? studyDone|true : studyDone|false


	


if studyDone


{


	if tmp[6]


		str:=regexreplace(str,"is)(Laryngeal penetration[^<]*?\(　)　(　\)[^,<]*?yes)","$1Ｖ$2")


	else


		str:=regexreplace(str,"is)(Laryngeal penetration[^<]*?\(　)　(　\)[^,<]*?no)","$1Ｖ$2")


	


	sympExt:=tmp[1]


	if sympExt contains 3 ;major


		str:=regexreplace(str,"is)(Aspiration[^<]*?\(　)　(　\)[^,<]*?major)","$1Ｖ$2")


	else if sympExt contains 2 ;minor


		str:=regexreplace(str,"is)(Aspiration[^<]*?\(　)　(　\)[^,<]*?minor)","$1Ｖ$2")


	else if sympExt contains 1 ;trace


		str:=regexreplace(str,"is)(Aspiration[^<]*?\(　)　(　\)[^,<]*?trace)","$1Ｖ$2")


	else ;if sympExt contains 0 ;no


		str:=regexreplace(str,"is)(Aspiration[^<]*?\(　)　(　\)[^,<]*?no)","$1Ｖ$2")





	if tmp[2]


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


str3=


loop,parse,comment,`n


	if trim(a_loopfield)


		str3.="<span style='margin-left:1em'>" a_loopfield "<br /></span>"





str2=


loop,parse,conclusion,`n


	if trim(a_loopfield)


		str2.="<span style='margin-left:1em'>" a_loopfield "<br /></span>"





YCChtml.= str1 "</table></div><p>　</p><p style='font-size:14pt'><strong>VFSS findings:</strong></p>" str "<p><span'>Other comments:</span><br /><span style='text-indent:8pt;'>" str3 "</span></p><p><span>Conclusion of VFSS:</span><br /><span style='text-indent:12pt;'>" str2 "</span></p><p align='right'>" html(examiner1) " / " html(examiner2) "</p></body></html>"





FileDelete,YCC Report.html


fileappend,% ycchtml,YCC Report.html,UTF-8


run,YCC Report.html


WinWaitActive,YCC Report,Videofluoroscopic Swallowing Study





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


 * ;~ txtVar:=["SerialNo","ExDate","AccessNo","ChartNo","Name","Age","AgeUnit","OtherDx","PtFrom","Complaint","CVAAttack","CVALocation","NPCRT","NPCCT","RTStart","RTEnd","NPCSymptom","RTType","RTDose","comment","conclusion","examiner1","examiner2"]


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


