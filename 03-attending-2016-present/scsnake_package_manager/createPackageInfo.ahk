SetBatchLines,-1
FileEncoding,utf-8
#include <JXON>
#include <RegExSplit>

infoPath:=A_ScriptDir "\package_info.json"
DefaultInfo=
(
{
  "__titles__": [
    "is_folder",
    "dependency",
    "version",
    "description"
  ],
  "__url__": "http://intranet.hospital.example/scsnake/"
}
)
newInfo:=jxon_load(DefaultInfo)
,oldInfo:=[]
if FileExist(infoPath) {
	fileread,infoTxt,% infoPath,utf-8
	try 
		oldInfo:=jxon_load(infoTxt)
}

colNo:=[]
for k,v in newInfo.__titles__
	colNo[v]:=k


Loop,files,% A_ScriptDir "\*",D
{
	dirName:=A_LoopFileName
	,i:=0
	Loop,files,% A_LoopFileLongPath "\*.version"
		i++
		,versionFile:=A_LoopFileLongPath
	
	if (i=0)
		continue
	else if (i>1){
		if !FileExist(versionFile:=PathCombine(A_LoopFileLongPath, dirName ".version"))
			continue
	}
	
	fileread,txt,% versionFile
	RegExMatch(txt, "\[([^\[]+)\]", ver)
	,RegExMatch(txt, "\ndependency=([^\n]*)", dep)
	;~ ,RegExMatch(txt, "\nunzip=([^\n]*)", unzip)
	,dep:=[]
	Loop,Parse,dep1,|
		dep.push(A_LoopField)
	
	newInfo[dirName, colNo.is_folder]:=1
	,newInfo[dirName, colNo.dependency]:=dep
	;~ ,newInfo[dirName, colNo.unzip]:=unzip1
	,newInfo[dirName, colNo.version]:=ver1
	,newInfo[dirName, colNo.description]:=oldInfo[dirName, colNo.description]
	
}

Loop,files,% A_ScriptDir "\*.version"
{
	SplitPath,A_LoopFileLongPath,,,,fileNameNoExt
	versionFile:=A_LoopFileLongPath
	
	fileread,txt,% versionFile
	RegExMatch(txt, "\[([^\[]+)\]", ver)
	,RegExMatch(txt, "\ndependency=([^\n]*)", dep)
	,RegExMatch(txt, "\nunzip=([^\n]*)", unzip)
	,dep:=[]
	Loop,Parse,dep1,|
		dep.push(A_LoopField)
	
	newInfo[fileNameNoExt, colNo.is_folder]:=0
	,newInfo[fileNameNoExt, colNo.dependency]:=dep
	;~ ,newInfo[fileNameNoExt, colNo.unzip]:=unzip1
	,newInfo[fileNameNoExt, colNo.version]:=ver1
	,newInfo[fileNameNoExt, colNo.description]:=oldInfo[fileNameNoExt, colNo.description]
	
}

output:=RegExReplace(RegExReplaceFn((jxon_dump(newInfo, "  ")), "\\u(\w+)\b", "fn"), "\{\}\,", "[],")
FileDelete,% infoPath
FileAppend,% output,% infoPath,utf-8
return

fn(m){
	return Chr(("0x" m.1))
}
