﻿FileEncoding,utf-8
#SingleInstance,Ignore
SetBatchLines,-1
SetWorkingDir,% A_ScriptDir
SetTitleMatchMode,2
OnExit,OnExit
#include <Zip>

if FileExist(z:=A_ScriptDir "\nodejs.zip") && !FileExist(A_ScriptDir "\nodejs")
	unz(z, A_ScriptDir)

if FileExist(z:=A_ScriptDir "\PDFTKBuilderPortable.zip") && !FileExist(A_ScriptDir "\PDFTKBuilderPortable")
	unz(z, A_ScriptDir)

root:=SubStr(A_ScriptDir, 1,2)

,electronPdf:=pathSelect([A_ScriptDir "\nodejs\", A_ScriptDir "\..\nodejs\"
	, A_ScriptDir "\..\..\nodejs\"
	, A_MyDocuments "\nodejs\"
	, ProgramW6432 "\nodejs\"
	, ProgramW6432  " (x86)\nodejs", root "\scripts\nodejs\"] ,"electron-pdf.cmd")
,pdftk:=pathSelect([A_ScriptDir "\PDFTKBuilderPortable\", A_ScriptDir "\..\software\PDFTKBuilderPortable\"
	, A_ScriptDir "\..\..\software\PDFTKBuilderPortable\"
	, A_ScriptDir "\..\..\..\software\PDFTKBuilderPortable\"
	, A_MyDocuments "\PDFTKBuilderPortable\"
	, ProgramW6432 "\PDFTKBuilderPortable\", ProgramW6432  " (x86)\nodejs", root "\software\PDFTKBuilderPortable"] ,"App\pdftkbuilder\pdftk.exe")
,sumatraPdf:=A_ScriptDir "\SumatraPDF.exe"


,inputFiles:=[]
,tmpFiles:=[]
Loop %0%
{
	path:=%A_Index%
	,inputFiles.push(path)
}
;~ Loop % "C:\Users\raduser\Documents\MammoSR\陳醫師\*.html"
	;~ inputFiles.push(A_LoopFileLongPath)

;~ inputFiles:=["G:\scripts\Radiology\MammoSR\陳醫師\20180119 1______.html"
	;~ , "G:\scripts\Radiology\MammoSR\陳醫師\20180119 6______.html"]

if !FileExist(electronPdf){
	MsgBox % "Can't find the path of electron-pdf!"
	ExitApp
}	
if !FileExist(pdftk){
	MsgBox % "Can't find the path of PDFTK!"
	ExitApp
}	
if !FileExist(sumatraPdf){
	MsgBox % "Can't find the path of SumatraPDF!"
	ExitApp
}

signPics:=[]
Loop,files,% ".\sign\*.png"
	signPics.push(A_LoopFileName)
Loop,files,% ".\sign\*.jpg"
	signPics.push(A_LoopFileName)
Loop,files,% ".\sign\*.jpeg"
	signPics.push(A_LoopFileName)

if(!signPics.length()){
	MsgBox,4,,% "No signature picture found in `n" A_ScriptDir "\sign\{YOUR_CHINESE_NAME}\`n`nContinue with plain text?"
	IfMsgBox,No
		ExitApp
}


if (inputFiles.maxIndex()<1){
	gui,-Resize
	gui,Add,Text,,File list (ordered by modification time)
	gui,Add,button,gselectfile x+30,Select files
	gui,Add,Edit,xm ReadOnly w500 vfilelist r20,
	gui,Add,Button,gpdf,Convert to PDF (no print)
	gui,Add,Button,ggo Default,Convert to PDF and print (Default printer)
	gui,Show,Center,Mammo Report Print
	gosub SelectFile
}else{
	inputFiles:=sortFileListByTime(inputFiles)
	gosub go
}

return 

SelectFile:
FileSelectFile, selectedFiles, M, % A_ScriptDir "\MammoReportSaved",Select files to print,HTML (*.html)
inputFiles:=[]
Loop,Parse,selectedFiles,`n
{
	if(A_Index=1)
		dir:=A_LoopField "\"
	else
		inputFiles.push(f:=dir A_LoopField)
}
inputFiles:=sortFileListByTime(inputFiles)
,selectedFilesStr:="Folder: " dir "`r`n"
,l:=StrLen(dir)+1
for k,v in inputFiles
	selectedFilesStr.=SubStr(v, l) "`r`n"
guicontrol,,filelist,% selectedFilesStr
return

;~ esc::
GuiClose:
ExitApp
return

pdf:
pdfOnly:=true
go:
if(!inputFiles.length()){
	MsgBox % "No files are selected!"
	return
}
gui,hide
SetTimer,HideCmd,100
;~ st:=""
pdfs:=[]
,failCount:=0
,failLog:=""
,printedPdf:=[]
for k,file in inputFiles {
	;~ st.=file "`n"
	failCount+=print(file)?1:0
	,ShowToolTip("Finished: " A_Index " / " inputFiles.length())
}
;~ mergePDFandPrint(pdfs)
;~ MsgBox % st
if(failCount>0){
	MsgBox % failCount " task failed!`n" failLog
}else{
	if (printedPdf.length() && !pdfOnly)
		MsgBox,4,,% "Done!`n`nDelete PDFs?"
		IfMsgBox,Yes
			for k,v in printedPdf
				try
					FileDelete % v
	else
		MsgBox % "Done!"
}
ExitApp
return

mergePDFandPrint(pdfs){
	global pdftk
	
	cmd:=pdftk " "
	for k,pdf in pdfs
		cmd.="""" pdf """ "
	outputFile:=A_ScriptDir "\" a_now "_merge.pdf"
	,cmd.="cat output """ outputFile """" 
	
	RunWait,% cmd,,
	
	
}

print(inputFile){
	global PicW,PicH,electronPdf,sumatraPdf,pdfs, signPics, pdfOnly, failLog, printedPdf
;~ MsgBox % inputFile
	
	if (inputFile ~= "i).pdf$"){
		pdfs.push(inputFile)
		return
	}

	SplitPath,inputFile,,fileDir,,fileNameNoExt
	tmpFile:=false
	
	,outputPath:=fileDir "\" fileNameNoExt ".pdf"
	FileGetSize,size,% outputPath,k
	if !FileExist(outputPath) || size<10{
		
	

	fileread,html,% inputFile
	StringReplace,html,html,<script type="text/javascript">window.onload=function(){window.print();}</script>,
	dom:=ComObjCreate("HtmlFile")
	,dom.write(html)
	
	
	
	if (signPics.length()){
		Random,rand,1,% signPics.length()
	}
	
	Random,randTop,-10,10
	Random,randLeft,-10,10
	Random,randRot,-5,5

	s:=dom.getElementsByTagName("span")
	Loop % s.length {
		if(s[A_Index-1].getAttribute("name")="radiologist"){
			radiologist:=s[A_Index-1].innerText
			break
		}
	}

	if (signPics.length()) && FileExist(signPath:=".\sign\" signPics[rand]) {	
		getImageSize(signPath)
		,img:=dom.createElement("IMG")
		,img.setAttribute("src", "." signPath)
		,img.setAttribute("width", w:=160+randTop)
		,img.setAttribute("height", Floor(PicH*160/PicW))
		,img.style.position:="absolute"
		,img.style.top:= -30 + randTop
		,img.style.Left:= randLeft
		,img.style.webkitTransform := "rotate(" randRot "deg)"
		,img.style.transform := "rotate(" randRot "deg)"
		
		,signHere:=dom.getElementById("signHereDiv")
		,signHere.appendChild(img)
		
		,signHere.nextSibling.style.display:="none"
	}
		tmpFilePath:=fileDir "\" fileNameNoExt "_" a_now ".html"
	
		FileDelete,% tmpFilePath
		FileDelete,% outputPath
		FileAppend,% dom.documentElement.innerHTML,% tmpFilePath,utf-8
		tmpFile:=true
		;~ ExitApp
		
		RunWait,% clipboard:="""" electronPdf """ """ tmpFilePath """ """ outputPath """ -c """ A_ScriptDir "\script\style.css""",,hide
		;~ MsgBox
		pSize:=size:=fail:=0
		Loop {
			FileGetSize,size,% outputPath,k
			;~ ToolTip % size
			if(pSize && pSize=size)
				break
			if (wait:=A_Index)>150 {
				fail:=1
				break
			}
			pSize:=size
			Sleep 200
		}
		if (fail)
			failLog.="PDF conversion failed: " fileNameNoExt "`n"
		
	}
		;~ ExitApp
		if (!fail && !pdfOnly){
			;~ shell := ComObjCreate("WScript.Shell")
			;~ ,exec := shell.Exec(ComSpec " /Q /k echo off")
			;~ ,commands := """" sumatraPdf """ -silent -print-settings duplexlong -print-to-default """ outputPath """"
			;~ ,exec.StdIn.WriteLine(commands "`nexit")
			;~ exec.StdOut.ReadAll()
			
			RunWait % """" sumatraPdf """ -silent -print-settings duplexlong -print-to-default """ outputPath """"
			FileCreateDir,% A_ScriptDir "\MammoReports_printed"
			FileMove,% inputFile,% A_ScriptDir "\MammoReports_printed",1
			printedPdf.push(outputPath)
			
			;~ Sleep 10000
			;~ pdfs.push(outputPath)
		}
		
		if tmpFile
			FileDelete,% tmpFilePath
		;~ if(!pdfOnly)
			;~ FileDelete,% outputPath
		
	
	return fail
}

sortFileListByTime(dir, fileType="html", sortedBy="M"){
	if IsObject(dir){
		arr:=dir, sort:=[]
		for k,v in arr {
			FileGetTime, time, % v, % sortedBy
			sort[time fill0(k)]:=A_Index
		}
	}else{
		arr:=[], sort:=[]
		Loop % dir "\*." fileType {
			arr.push(A_LoopFileFullPath)
			FileGetTime, time, % A_LoopFileFullPath, % sortedBy
			sort[time fill0(A_Index)]:=A_Index
		}
	}
	ret:=[]
	for k,v in sort
		ret.push(arr[v])
	return ret
}


fill0(str, n=2){
	while StrLen(str)<n
		str:="0" str
	return str
}

HideCmd:
WinHide,ahk_exe cmd.exe
return

getImageSize(fileName){
	global
	gui, add,picture, vimage, %fileName%
	GuiControlGet, Pic, Pos, image  ; The position/size will be stored in PicX, PicY, PicW, and PicH
	gui,destroy
}

pathSelect(path, fileName=""){
	if !IsObject(path){
		return FileExist(p:=path (fileName!="" && !(SubStr(path,0,1)~="\\|\/")?(InStr(path,"/")?"/":"\"):"") fileName)?p:""
	}
	for k,v in path
		if FileExist(p:=v (fileName!="" && !(SubStr(v,0,1)~="\\|\/")?(InStr(v,"/")?"/":"\"):"") fileName)
			return p
		
	return ""
}

OnExit:
for k,v in tmpFiles
	FileDelete % v
ExitApp